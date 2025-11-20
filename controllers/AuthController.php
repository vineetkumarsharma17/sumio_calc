<?php
/**
 * Authentication Controller
 * Handles user registration, login, and authentication
 */

require_once 'core/Controller.php';
require_once 'models/User.php';

class AuthController extends Controller {
    private $userModel;
    
    public function __construct() {
        parent::__construct();
        $this->userModel = new User();
    }
    
    /**
     * Register a new user
     * POST /api/v1/auth/register
     */
    public function register() {
        $data = $this->getRequestBody();
        
        // Validate input
        $errors = $this->validate($data, [
            'name' => 'required',
            'email' => 'required|email',
            'password' => 'required|min:8'
        ]);
        
        if (!empty($errors)) {
            Response::validationError($errors);
        }
        
        $name = trim($data['name']);
        $email = trim(strtolower($data['email']));
        $password = $data['password'];
        
        // Check if email already exists
        if ($this->userModel->emailExists($email)) {
            Response::error('Email already registered', 409);
        }
        
        // Create user
        $userId = $this->userModel->create($name, $email, $password);
        
        if (!$userId) {
            Response::serverError('Failed to create user');
        }
        
        // Generate token
        $token = AuthMiddleware::generateToken($userId, $email);
        
        // Get user data
        $user = $this->userModel->findById($userId);
        
        Response::success([
            'user' => [
                'id' => $user['id'],
                'name' => $user['name'],
                'email' => $user['email'],
                'created_at' => $user['created_at']
            ],
            'token' => $token
        ], 'User registered successfully', 201);
    }
    
    /**
     * Login user
     * POST /api/v1/auth/login
     */
    public function login() {
        $data = $this->getRequestBody();
        
        // Validate input
        $errors = $this->validate($data, [
            'email' => 'required|email',
            'password' => 'required'
        ]);
        
        if (!empty($errors)) {
            Response::validationError($errors);
        }
        
        $email = trim(strtolower($data['email']));
        $password = $data['password'];
        
        // Find user by email
        $user = $this->userModel->findByEmail($email);
        
        if (!$user) {
            Response::error('Invalid credentials', 401);
        }
        
        // Verify password
        if (!password_verify($password, $user['password'])) {
            Response::error('Invalid credentials', 401);
        }
        
        // Generate token
        $token = AuthMiddleware::generateToken($user['id'], $user['email']);
        
        Response::success([
            'user' => [
                'id' => $user['id'],
                'name' => $user['name'],
                'email' => $user['email'],
                'created_at' => $user['created_at']
            ],
            'token' => $token
        ], 'Login successful');
    }
    
    /**
     * Get authenticated user profile
     * GET /api/v1/auth/profile
     * Requires authentication
     */
    public function profile() {
        $userId = $this->getUserId();
        
        $user = $this->userModel->findById($userId);
        
        if (!$user) {
            Response::notFound('User not found');
        }
        
        Response::success([
            'user' => [
                'id' => $user['id'],
                'name' => $user['name'],
                'email' => $user['email'],
                'created_at' => $user['created_at']
            ]
        ]);
    }
    
    /**
     * Logout user (client-side token removal)
     * POST /api/v1/auth/logout
     * Requires authentication
     */
    public function logout() {
        Response::success([], 'Logout successful');
    }
}
