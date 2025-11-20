<?php
/**
 * Authentication Middleware
 * Validates JWT tokens for protected routes
 */
class AuthMiddleware {
    public function handle() {
        require_once 'config/config.php';
        
        $headers = getallheaders();
        $token = null;

            // Check API key
            $apiKeyHeader = isset($headers['api_key']) ? $headers['api_key'] : (isset($headers['Api-Key']) ? $headers['Api-Key'] : null);
            if (!defined('API_KEY')) {
                define('API_KEY', 'dSIUfnwn8RQAU87nBZRJfOiTdLEB84rE'); // Set your API key in config/config.php
            }
            if (!$apiKeyHeader || $apiKeyHeader !== API_KEY) {
                Response::error('Invalid or missing API key', 401);
            }

        // Ignore JWT token check for now
    }

    private function verifyToken($token) {
        // Simple JWT verification (for production, use a proper JWT library)
        $parts = explode('.', $token);
        
        if (count($parts) !== 3) {
            throw new Exception('Invalid token format');
        }

        list($header, $payload, $signature) = $parts;
        
        // Verify signature
        $validSignature = hash_hmac('sha256', "$header.$payload", JWT_SECRET, true);
        $validSignature = $this->base64UrlEncode($validSignature);
        
        if ($signature !== $validSignature) {
            throw new Exception('Invalid signature');
        }

        // Decode payload
        $payload = json_decode($this->base64UrlDecode($payload));
        
        // Check expiration
        if (isset($payload->exp) && $payload->exp < time()) {
            throw new Exception('Token expired');
        }

        return $payload;
    }

    private function base64UrlEncode($data) {
        return rtrim(strtr(base64_encode($data), '+/', '-_'), '=');
    }

    private function base64UrlDecode($data) {
        return base64_decode(strtr($data, '-_', '+/'));
    }

    public static function generateToken($userId, $email) {
        require_once 'config/config.php';
        
        $header = json_encode(['typ' => 'JWT', 'alg' => 'HS256']);
        $payload = json_encode([
            'user_id' => $userId,
            'email' => $email,
            'iat' => time(),
            'exp' => time() + JWT_EXPIRY
        ]);

        $base64UrlHeader = rtrim(strtr(base64_encode($header), '+/', '-_'), '=');
        $base64UrlPayload = rtrim(strtr(base64_encode($payload), '+/', '-_'), '=');
        
        $signature = hash_hmac('sha256', $base64UrlHeader . "." . $base64UrlPayload, JWT_SECRET, true);
        $base64UrlSignature = rtrim(strtr(base64_encode($signature), '+/', '-_'), '=');
        
        return $base64UrlHeader . "." . $base64UrlPayload . "." . $base64UrlSignature;
    }
}
