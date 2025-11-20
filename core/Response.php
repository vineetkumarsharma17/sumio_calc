<?php
/**
 * Response Helper Class
 * Standardizes API responses
 */
class Response {
    public static function success($data = [], $message = 'Success', $code = 200) {
        http_response_code($code);
        echo json_encode([
            'success' => true,
            'message' => $message,
            'data' => $data
        ], JSON_PRETTY_PRINT);
        exit;
    }
    
    public static function error($message = 'An error occurred', $code = 400, $errors = []) {
        http_response_code($code);
        echo json_encode([
            'success' => false,
            'message' => $message,
            'errors' => $errors
        ], JSON_PRETTY_PRINT);
        exit;
    }

    /**
     * Handle exception and PHP error as JSON response
     */
    public static function exception($exception) {
        http_response_code(500);
        echo json_encode([
            'success' => false,
            'message' => 'Exception occurred',
            'error' => [
                'type' => get_class($exception),
                'message' => $exception->getMessage(),
                'file' => $exception->getFile(),
                'line' => $exception->getLine()
            ]
        ], JSON_PRETTY_PRINT);
        exit;
    }

    public static function phpError($errno, $errstr, $errfile, $errline) {
        http_response_code(500);
        echo json_encode([
            'success' => false,
            'message' => 'Server error',
            'error' => [
                'type' => 'Error',
                'errno' => $errno,
                'errstr' => $errstr,
                'file' => $errfile,
                'line' => $errline
            ]
        ], JSON_PRETTY_PRINT);
        exit;
    }
    
    public static function validationError($errors = []) {
        self::error('Validation failed', 422, $errors);
    }
    
    public static function unauthorized($message = 'Unauthorized') {
        self::error($message, 401);
    }
    
    public static function notFound($message = 'Resource not found') {
        self::error($message, 404);
    }
    
    public static function serverError($message = 'Internal server error') {
        self::error($message, 500);
    }
}
