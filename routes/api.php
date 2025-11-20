<?php
/**
 * API Routes Definition
 */

require_once 'config/config.php';
require_once 'controllers/AuthController.php';

// Public routes
$router->post('api/v1/auth/register', [AuthController::class, 'register']);
$router->post('api/v1/auth/login', [AuthController::class, 'login']);

// Protected routes (require authentication)
$router->get('api/v1/auth/profile', [AuthController::class, 'profile'], [new AuthMiddleware()]);
$router->post('api/v1/auth/logout', [AuthController::class, 'logout'], [new AuthMiddleware()]);

// Health check
$router->get('api/v1/health', function() {
    Response::success(['status' => 'API is running', 'timestamp' => time()]);
});
