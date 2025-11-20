<?php
require_once 'core/Controller.php';
require_once 'core/Response.php';
require_once 'config/Database.php';

class SumioController extends Controller {
	/**
	 * Upload JSON data to sumio_data table
	 * POST /api/v1/sumio/upload-json
	 */
	public function uploadJsonData() {
		$body = $this->getRequestBody();

		// Validate input
		if (!isset($body['column']) || !is_array($body['column']) || empty($body['column'])) {
			Response::validationError(['column' => 'Column array is required']);
		}
		if (!isset($body['data']) || !is_array($body['data']) || empty($body['data'])) {
			Response::validationError(['data' => 'Data array is required']);
		}
		if (!isset($body['file_name']) || !is_string($body['file_name']) || empty($body['file_name'])) {
			Response::validationError(['file_name' => 'File name is required']);
		}

		$columns = $body['column'];
		$rows = $body['data'];
        $fileName = trim($body['file_name']);

		$db = Database::getInstance()->getConnection();

		// Insert file_name into sumio_files
		$fileStmt = $db->prepare("INSERT INTO sumio_files (file_name) VALUES (?)");
		if (!$fileStmt) {
			Response::serverError('Failed to prepare file insert statement');
		}
		$fileStmt->bind_param('s', $fileName);
		if (!$fileStmt->execute()) {
			Response::serverError('Failed to insert file name');
		}
		$fileId = $fileStmt->insert_id;
		$fileStmt->close();

		// Add file_id to columns
		$columnsWithFileId = array_merge($columns, ['file_id']);
		$colSql = '`' . implode('`,`', array_map('trim', $columnsWithFileId)) . '`';
		$placeholders = '(' . rtrim(str_repeat('?,', count($columnsWithFileId)), ',') . ')';

		$stmt = $db->prepare("INSERT INTO sumio_data ($colSql) VALUES $placeholders");
		if (!$stmt) {
			Response::serverError('Failed to prepare statement');
		}

		$inserted = 0;
		foreach ($rows as $row) {
			if (count($row) !== count($columns)) continue;
			$rowWithFileId = array_merge($row, [$fileId]);
			$types = str_repeat('s', count($rowWithFileId));
			$stmt->bind_param($types, ...$rowWithFileId);
			if ($stmt->execute()) {
				$inserted++;
			}
		}
		$stmt->close();

		Response::success([
			'inserted' => $inserted,
			'columns' => $columnsWithFileId,
			'file_id' => $fileId,
			'rows' => count($rows)
		], 'Data uploaded successfully');
	}

	/**
	 * Get list of file names with count of rows
	 * GET /api/v1/sumio/files
	 */
	public function getFilesWithRowCounts() {
		$db = Database::getInstance()->getConnection();

		// Pagination params from query string
		$page = isset($_GET['page']) ? (int)$_GET['page'] : 1;
		$perPage = isset($_GET['per_page']) ? (int)$_GET['per_page'] : 50;
		if ($page < 1) $page = 1;
		// enforce minimum per_page of 50
		$minPerPage = 50;
		if ($perPage < $minPerPage) $perPage = $minPerPage;
		$maxPerPage = 500;
		if ($perPage > $maxPerPage) $perPage = $maxPerPage;
		$offset = ($page - 1) * $perPage;

		// Get total number of files for pagination metadata
		$countSql = "SELECT COUNT(*) AS total FROM sumio_files";
		$countStmt = $db->prepare($countSql);
		if (!$countStmt) {
			Response::serverError('Failed to prepare count query');
		}
		if (!$countStmt->execute()) {
			Response::serverError('Failed to execute count query');
		}
		$countRes = $countStmt->get_result()->fetch_assoc();
		$total = (int)$countRes['total'];
		$countStmt->close();

		// Query to get file names, created_at and count of rows from sumio_data with limit/offset
		$sql = "SELECT f.id AS file_id, f.file_name, f.createdAt, COUNT(d.id) AS row_count FROM sumio_files f LEFT JOIN sumio_data d ON f.id = d.file_id GROUP BY f.id, f.file_name, f.createdAt ORDER BY f.createdAt DESC LIMIT ? OFFSET ?";
		$stmt = $db->prepare($sql);
		if (!$stmt) {
			Response::serverError('Failed to prepare query for files');
		}
		$stmt->bind_param('ii', $perPage, $offset);
		if (!$stmt->execute()) {
			Response::serverError('Failed to execute query for files');
		}
		$result = $stmt->get_result();
		$files = [];
		while ($row = $result->fetch_assoc()) {
			$files[] = [
				'file_id' => (int)$row['file_id'],
				'file_name' => $row['file_name'],
				'createdAt' => $row['createdAt'],
				'row_count' => (int)$row['row_count']
			];
		}
		$stmt->close();

		$totalPages = $perPage > 0 ? (int)ceil($total / $perPage) : 0;

		Response::success([
			'files' => $files,
			'pagination' => [
				'total' => $total,
				'per_page' => $perPage,
				'page' => $page,
				'total_pages' => $totalPages
			]
		]);
	}
}
