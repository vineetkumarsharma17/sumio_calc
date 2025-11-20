<?php
/**
 * API Entry Point
 */

header('Content-Type: application/json');

// Error reporting for development
error_reporting(E_ALL);
ini_set('display_errors', 1);

// Global error handler
set_error_handler(function($errno, $errstr, $errfile, $errline) {
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
});

// Global exception handler
set_exception_handler(function($exception) {
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
});

// Autoloader
spl_autoload_register(function ($class) {
    $file = __DIR__ . '/' . str_replace('\\', '/', $class) . '.php';
    if (file_exists($file)) {
        require_once $file;
    }
});

// Load configuration
require_once 'config/Database.php';
require_once 'core/Router.php';
require_once 'core/Response.php';

// Load middleware
require_once 'middleware/CorsMiddleware.php';
require_once 'middleware/AuthMiddleware.php';

// Initialize router
$router = new Router();

// Apply global middleware
$router->addMiddleware(new CorsMiddleware());

// Load routes
require_once 'routes/api.php';

// Handle the request
$router->run();
