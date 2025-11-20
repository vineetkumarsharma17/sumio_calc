<?php
/**
 * Base Controller Class
 * All controllers extend this class
 */
class Controller {
    protected $db;
    
    public function __construct() {
        $this->db = Database::getInstance()->getConnection();
    }
    
    /**
     * Get request body as JSON
     */
    protected function getRequestBody() {
        $input = file_get_contents('php://input');
        return json_decode($input, true) ?? [];
    }
    
    /**
     * Validate required fields
     */
    protected function validate($data, $rules) {
        $errors = [];
        
        foreach ($rules as $field => $rule) {
            if ($rule === 'required' && empty($data[$field])) {
                $errors[$field] = ucfirst($field) . ' is required';
            }
            
            if (strpos($rule, 'min:') === 0) {
                $min = (int)substr($rule, 4);
                if (isset($data[$field]) && strlen($data[$field]) < $min) {
                    $errors[$field] = ucfirst($field) . " must be at least {$min} characters";
                }
            }
            
            if ($rule === 'email' && isset($data[$field])) {
                if (!filter_var($data[$field], FILTER_VALIDATE_EMAIL)) {
                    $errors[$field] = 'Invalid email format';
                }
            }
        }
        
        return $errors;
    }
    
    /**
     * Get authenticated user ID
     */
    protected function getUserId() {
        return $GLOBALS['user_id'] ?? null;
    }
    
    /**
     * Get authenticated user email
     */
    protected function getUserEmail() {
        return $GLOBALS['user_email'] ?? null;
    }
}
