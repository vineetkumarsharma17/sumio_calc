# PHP REST API

A well-structured PHP REST API with middleware, routing, and authentication.

## Project Structure

```
sumio_calc/
├── index.php                 # Entry point
├── .htaccess                 # Apache rewrite rules
├── config/
│   ├── Database.php          # Database connection (singleton)
│   └── config.php            # App configuration
├── core/
│   ├── Router.php            # Route handler
│   ├── Controller.php        # Base controller
│   └── Response.php          # Response helper
├── middleware/
│   ├── CorsMiddleware.php    # CORS handler
│   └── AuthMiddleware.php    # JWT authentication
├── controllers/
│   └── AuthController.php    # Authentication controller
├── models/
│   └── User.php              # User model
└── routes/
    └── api.php               # API route definitions
```

## Features

- ✅ Clean MVC architecture
- ✅ Middleware support (CORS, Authentication)
- ✅ JWT authentication
- ✅ RESTful routing
- ✅ Password hashing
- ✅ Input validation
- ✅ Standardized JSON responses
- ✅ Auto-creates users table

## API Endpoints

### Public Routes

#### Register User
```bash
POST /api/v1/auth/register
Content-Type: application/json

{
  "name": "John Doe",
  "email": "john@example.com",
  "password": "password123"
}
```

#### Login User
```bash
POST /api/v1/auth/login
Content-Type: application/json

{
  "email": "john@example.com",
  "password": "password123"
}
```

#### Health Check
```bash
GET /api/v1/health
```

### Protected Routes (Require Authentication)

#### Get Profile
```bash
GET /api/v1/auth/profile
Authorization: Bearer YOUR_JWT_TOKEN
```

#### Logout
```bash
POST /api/v1/auth/logout
Authorization: Bearer YOUR_JWT_TOKEN
```

## Setup Instructions

1. **Configure Database**
   - Update credentials in `config/Database.php`
   - The users table will be created automatically

2. **Apache Configuration**
   - Ensure mod_rewrite is enabled
   - The `.htaccess` file handles routing

3. **Test the API**
   ```bash
   # Health check
   curl http://localhost/api/v1/health

   # Register
   curl -X POST http://localhost/api/v1/auth/register \
     -H "Content-Type: application/json" \
     -d '{"name":"Test User","email":"test@example.com","password":"password123"}'

   # Login
   curl -X POST http://localhost/api/v1/auth/login \
     -H "Content-Type: application/json" \
     -d '{"email":"test@example.com","password":"password123"}'
   ```

## Security Notes

⚠️ **Important for Production:**
- Change `JWT_SECRET` in `config/config.php`
- Disable error display in `index.php`
- Use HTTPS in production
- Consider using a proper JWT library (like firebase/php-jwt)
- Implement rate limiting
- Add input sanitization
- Set up proper CORS policies

## Response Format

### Success Response
```json
{
  "success": true,
  "message": "Success message",
  "data": {}
}
```

### Error Response
```json
{
  "success": false,
  "message": "Error message",
  "errors": {}
}
```

## Extending the API

### Add New Route
Edit `routes/api.php`:
```php
$router->get('api/v1/users', [UserController::class, 'index']);
```

### Add New Controller
Create in `controllers/`:
```php
class UserController extends Controller {
    public function index() {
        Response::success(['users' => []]);
    }
}
```

### Add New Model
Create in `models/`:
```php
class Product {
    private $db;
    private $table = 'products';
    
    public function __construct() {
        $this->db = Database::getInstance()->getConnection();
    }
}
```
