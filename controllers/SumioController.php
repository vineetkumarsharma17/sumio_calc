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
}
