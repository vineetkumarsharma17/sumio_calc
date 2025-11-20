<?php
/**
 * API Entry Point
 */

header('Content-Type: application/json');

// Error reporting for development
error_reporting(E_ALL);
ini_set('display_errors', 1);

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
