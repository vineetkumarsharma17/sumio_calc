<?php
/**
 * Application Configuration
 */

define('JWT_SECRET', 'your-secret-key-here-change-in-production');
define('JWT_EXPIRY', 86400); // 24 hours

define('API_VERSION', 'v1');
define('API_BASE_URL', '/api/' . API_VERSION);

// Password settings
define('PASSWORD_MIN_LENGTH', 8);

// Response messages
define('MSG_SUCCESS', 'Success');
define('MSG_ERROR', 'An error occurred');
define('MSG_UNAUTHORIZED', 'Unauthorized access');
define('MSG_NOT_FOUND', 'Resource not found');
define('MSG_VALIDATION_ERROR', 'Validation error');
