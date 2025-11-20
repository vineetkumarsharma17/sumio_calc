<?php
/**
 * Database Configuration and Connection Handler
 */
class Database {
    private static $instance = null;
    private $conn;
    
    private $host = "localhost";
    private $username = "u865000035_vsafe_user";
    private $password = "B5espk938j@123";
    private $database = "u865000035_vsafe";
    
    private function __construct() {
        try {
            $this->conn = new mysqli(
                $this->host,
                $this->username,
                $this->password,
                $this->database
            );
            
            if ($this->conn->connect_error) {
                throw new Exception("Connection failed: " . $this->conn->connect_error);
            }
            
            $this->conn->set_charset("utf8mb4");
        } catch (Exception $e) {
            die("Database connection error: " . $e->getMessage());
        }
    }
    
    public static function getInstance() {
        if (self::$instance === null) {
            self::$instance = new Database();
        }
        return self::$instance;
    }
    
    public function getConnection() {
        return $this->conn;
    }
    
    public function prepare($sql) {
        return $this->conn->prepare($sql);
    }
    
    public function escape($value) {
        return $this->conn->real_escape_string($value);
    }
    
    // Prevent cloning
    private function __clone() {}
    
    // Prevent unserialization
    public function __wakeup() {
        throw new Exception("Cannot unserialize singleton");
    }
}
