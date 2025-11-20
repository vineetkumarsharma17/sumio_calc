<?php
/**
 * Router Class
 * Handles routing and middleware execution
 */
class Router {
    private $routes = [];
    private $globalMiddleware = [];
    
    public function addMiddleware($middleware) {
        $this->globalMiddleware[] = $middleware;
    }
    
    public function get($path, $handler, $middleware = []) {
        $this->addRoute('GET', $path, $handler, $middleware);
    }
    
    public function post($path, $handler, $middleware = []) {
        $this->addRoute('POST', $path, $handler, $middleware);
    }
    
    public function put($path, $handler, $middleware = []) {
        $this->addRoute('PUT', $path, $handler, $middleware);
    }
    
    public function delete($path, $handler, $middleware = []) {
        $this->addRoute('DELETE', $path, $handler, $middleware);
    }
    
    private function addRoute($method, $path, $handler, $middleware = []) {
        $this->routes[] = [
            'method' => $method,
            'path' => $path,
            'handler' => $handler,
            'middleware' => $middleware
        ];
    }
    
    public function run() {
        // Run global middleware
        foreach ($this->globalMiddleware as $middleware) {
            $middleware->handle();
        }
        
        $requestMethod = $_SERVER['REQUEST_METHOD'];
        $requestUri = $_SERVER['REQUEST_URI'];
        
        // Remove query string
        $requestUri = strtok($requestUri, '?');
        
        // Remove leading slash
        $requestUri = trim($requestUri, '/');
        
        foreach ($this->routes as $route) {
            $pattern = $this->convertToRegex($route['path']);
            
            if ($route['method'] === $requestMethod && preg_match($pattern, $requestUri, $matches)) {
                // Remove the full match
                array_shift($matches);
                
                // Run route-specific middleware
                foreach ($route['middleware'] as $middleware) {
                    $middleware->handle();
                }
                
                // Call handler
                $handler = $route['handler'];
                
                if (is_array($handler)) {
                    $controller = new $handler[0]();
                    $method = $handler[1];
                    echo call_user_func_array([$controller, $method], $matches);
                } else {
                    echo call_user_func_array($handler, $matches);
                }
                
                return;
            }
        }
        
        // No route matched
        Response::error('Route not found', 404);
    }
    
    private function convertToRegex($path) {
        // Convert :param to named capture groups
        $pattern = preg_replace('/\{(\w+)\}/', '(?P<$1>[^/]+)', $path);
        $pattern = '#^' . trim($pattern, '/') . '$#';
        return $pattern;
    }
}
