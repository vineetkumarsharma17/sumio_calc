<?php
/**
 * User Model
 * Handles user database operations
 */
class User {
    private $db;
    private $table = 'users';
    
    public function __construct() {
        $this->db = Database::getInstance()->getConnection();
        $this->createTableIfNotExists();
    }
    
    /**
     * Create users table if it doesn't exist
     */
    private function createTableIfNotExists() {
        $sql = "CREATE TABLE IF NOT EXISTS {$this->table} (
            id INT AUTO_INCREMENT PRIMARY KEY,
            name VARCHAR(100) NOT NULL,
            email VARCHAR(255) UNIQUE NOT NULL,
            password VARCHAR(255) NOT NULL,
            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
            updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
            INDEX idx_email (email)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci";
        
        $this->db->query($sql);
    }
    
    /**
     * Create a new user
     */
    public function create($name, $email, $password) {
        $hashedPassword = password_hash($password, PASSWORD_DEFAULT);
        
        $stmt = $this->db->prepare(
            "INSERT INTO {$this->table} (name, email, password) VALUES (?, ?, ?)"
        );
        
        $stmt->bind_param("sss", $name, $email, $hashedPassword);
        
        if ($stmt->execute()) {
            return $stmt->insert_id;
        }
        
        return false;
    }
    
    /**
     * Find user by ID
     */
    public function findById($id) {
        $stmt = $this->db->prepare(
            "SELECT id, name, email, created_at, updated_at FROM {$this->table} WHERE id = ?"
        );
        
        $stmt->bind_param("i", $id);
        $stmt->execute();
        
        $result = $stmt->get_result();
        return $result->fetch_assoc();
    }
    
    /**
     * Find user by email
     */
    public function findByEmail($email) {
        $stmt = $this->db->prepare(
            "SELECT id, name, email, password, created_at, updated_at FROM {$this->table} WHERE email = ?"
        );
        
        $stmt->bind_param("s", $email);
        $stmt->execute();
        
        $result = $stmt->get_result();
        return $result->fetch_assoc();
    }
    
    /**
     * Check if email exists
     */
    public function emailExists($email) {
        $stmt = $this->db->prepare(
            "SELECT id FROM {$this->table} WHERE email = ?"
        );
        
        $stmt->bind_param("s", $email);
        $stmt->execute();
        
        $result = $stmt->get_result();
        return $result->num_rows > 0;
    }
    
    /**
     * Update user
     */
    public function update($id, $data) {
        $fields = [];
        $values = [];
        $types = '';
        
        foreach ($data as $key => $value) {
            if (in_array($key, ['name', 'email'])) {
                $fields[] = "{$key} = ?";
                $values[] = $value;
                $types .= 's';
            }
        }
        
        if (empty($fields)) {
            return false;
        }
        
        $values[] = $id;
        $types .= 'i';
        
        $sql = "UPDATE {$this->table} SET " . implode(', ', $fields) . " WHERE id = ?";
        $stmt = $this->db->prepare($sql);
        
        $stmt->bind_param($types, ...$values);
        
        return $stmt->execute();
    }
    
    /**
     * Delete user
     */
    public function delete($id) {
        $stmt = $this->db->prepare("DELETE FROM {$this->table} WHERE id = ?");
        $stmt->bind_param("i", $id);
        
        return $stmt->execute();
    }
}
