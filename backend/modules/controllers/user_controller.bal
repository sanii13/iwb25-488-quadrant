import ballerina/http;
import backend.models;
import backend.services;

// User controller for handling HTTP requests
public class UserController {
    private services:UserService userService;

    public function init() {
        self.userService = new services:UserService();
    }

    // POST /api/auth/register - Register a new user
    public function registerUser(http:Request req) returns http:Response {
        http:Response response = new;
        
        json|http:ClientError payload = req.getJsonPayload();
        if payload is http:ClientError {
            response.statusCode = 400;
            response.setJsonPayload({message: "Invalid JSON payload"});
            return response;
        }

        models:NewUser|error newUser = payload.cloneWithType(models:NewUser);
        if newUser is error {
            response.statusCode = 400;
            response.setJsonPayload({message: "Invalid user data", details: newUser.message()});
            return response;
        }

        // Basic validation
        if newUser.email.trim().length() == 0 {
            response.statusCode = 400;
            response.setJsonPayload({message: "Email is required"});
            return response;
        }

        if newUser.password.trim().length() < 6 {
            response.statusCode = 400;
            response.setJsonPayload({message: "Password must be at least 6 characters"});
            return response;
        }

        models:UserResponse|models:UserErrorResponse result = self.userService.registerUser(newUser);
        if result is models:UserErrorResponse {
            response.statusCode = 400;
            response.setJsonPayload(result);
            return response;
        }

        response.statusCode = 201;
        response.setJsonPayload(result);
        return response;
    }

    // POST /api/auth/login - User login
    public function loginUser(http:Request req) returns http:Response {
        http:Response response = new;
        
        json|http:ClientError payload = req.getJsonPayload();
        if payload is http:ClientError {
            response.statusCode = 400;
            response.setJsonPayload({message: "Invalid JSON payload"});
            return response;
        }

        models:UserLogin|error loginData = payload.cloneWithType(models:UserLogin);
        if loginData is error {
            response.statusCode = 400;
            response.setJsonPayload({message: "Invalid login data", details: loginData.message()});
            return response;
        }

        // Basic validation
        if loginData.email.trim().length() == 0 {
            response.statusCode = 400;
            response.setJsonPayload({message: "Email is required"});
            return response;
        }

        if loginData.password.trim().length() == 0 {
            response.statusCode = 400;
            response.setJsonPayload({message: "Password is required"});
            return response;
        }

        models:AuthResponse result = self.userService.loginUser(loginData);
        if result.token is () {
            response.statusCode = 401;
            response.setJsonPayload({message: result.message});
            return response;
        }

        response.statusCode = 200;
        response.setJsonPayload(result);
        return response;
    }

    // GET /api/users - Get all users (admin only)
    public function getAllUsers(http:Request req) returns http:Response {
        http:Response response = new;

        // Check authorization
        models:User|error? user = self.authorize(req, [models:ADMIN]);
        if user is error {
            response.statusCode = 401;
            response.setJsonPayload({message: "Unauthorized"});
            return response;
        }
        if user is () {
            response.statusCode = 403;
            response.setJsonPayload({message: "Insufficient permissions"});
            return response;
        }

        models:UserResponse[]|models:UserErrorResponse result = self.userService.getAllUsers();
        if result is models:UserErrorResponse {
            response.statusCode = 500;
            response.setJsonPayload(result);
            return response;
        }

        response.statusCode = 200;
        response.setJsonPayload(result);
        return response;
    }

    // GET /api/users/{id} - Get user by ID
    public function getUserById(http:Request req, int userId) returns http:Response {
        http:Response response = new;

        // Check authorization - users can view their own profile, admins can view all
        models:User|error? user = self.authorize(req, [models:ADMIN, models:DOCTOR, models:PATIENT]);
        if user is error {
            response.statusCode = 401;
            response.setJsonPayload({message: "Unauthorized"});
            return response;
        }
        if user is () {
            response.statusCode = 403;
            response.setJsonPayload({message: "Insufficient permissions"});
            return response;
        }

        // Users can only view their own profile unless they're admin
        if user.role != models:ADMIN && user.user_id != userId {
            response.statusCode = 403;
            response.setJsonPayload({message: "Access denied"});
            return response;
        }

        models:UserResponse|models:UserErrorResponse result = self.userService.getUserById(userId);
        if result is models:UserErrorResponse {
            response.statusCode = 404;
            response.setJsonPayload(result);
            return response;
        }

        response.statusCode = 200;
        response.setJsonPayload(result);
        return response;
    }

    // PUT /api/users/{id} - Update user
    public function updateUser(http:Request req, int userId) returns http:Response {
        http:Response response = new;

        // Check authorization
        models:User|error? user = self.authorize(req, [models:ADMIN, models:DOCTOR, models:PATIENT]);
        if user is error {
            response.statusCode = 401;
            response.setJsonPayload({message: "Unauthorized"});
            return response;
        }
        if user is () {
            response.statusCode = 403;
            response.setJsonPayload({message: "Insufficient permissions"});
            return response;
        }

        // Users can only update their own profile unless they're admin
        if user.role != models:ADMIN && user.user_id != userId {
            response.statusCode = 403;
            response.setJsonPayload({message: "Access denied"});
            return response;
        }

        json|http:ClientError payload = req.getJsonPayload();
        if payload is http:ClientError {
            response.statusCode = 400;
            response.setJsonPayload({message: "Invalid JSON payload"});
            return response;
        }

        models:UserUpdate|error userUpdate = payload.cloneWithType(models:UserUpdate);
        if userUpdate is error {
            response.statusCode = 400;
            response.setJsonPayload({message: "Invalid user update data", details: userUpdate.message()});
            return response;
        }

        // Non-admin users cannot change their role
        if user.role != models:ADMIN && userUpdate.role is models:UserRole {
            response.statusCode = 403;
            response.setJsonPayload({message: "Cannot change role"});
            return response;
        }

        models:UserResponse|models:UserErrorResponse result = self.userService.updateUser(userId, userUpdate);
        if result is models:UserErrorResponse {
            response.statusCode = 400;
            response.setJsonPayload(result);
            return response;
        }

        response.statusCode = 200;
        response.setJsonPayload(result);
        return response;
    }

    // DELETE /api/users/{id} - Delete user (admin only)
    public function deleteUser(http:Request req, int userId) returns http:Response {
        http:Response response = new;

        // Check authorization
        models:User|error? user = self.authorize(req, [models:ADMIN]);
        if user is error {
            response.statusCode = 401;
            response.setJsonPayload({message: "Unauthorized"});
            return response;
        }
        if user is () {
            response.statusCode = 403;
            response.setJsonPayload({message: "Insufficient permissions"});
            return response;
        }

        models:UserErrorResponse? result = self.userService.deleteUser(userId);
        if result is models:UserErrorResponse {
            response.statusCode = 404;
            response.setJsonPayload(result);
            return response;
        }

        response.statusCode = 204;
        return response;
    }

    // GET /api/users/role/{role} - Get users by role (admin only)
    public function getUsersByRole(http:Request req, string roleStr) returns http:Response {
        http:Response response = new;

        // Check authorization
        models:User|error? user = self.authorize(req, [models:ADMIN]);
        if user is error {
            response.statusCode = 401;
            response.setJsonPayload({message: "Unauthorized"});
            return response;
        }
        if user is () {
            response.statusCode = 403;
            response.setJsonPayload({message: "Insufficient permissions"});
            return response;
        }

        // Convert string to UserRole
        models:UserRole role;
        if roleStr.toUpperAscii() == "ADMIN" {
            role = models:ADMIN;
        } else if roleStr.toUpperAscii() == "DOCTOR" {
            role = models:DOCTOR;
        } else if roleStr.toUpperAscii() == "PATIENT" {
            role = models:PATIENT;
        } else {
            response.statusCode = 400;
            response.setJsonPayload({message: "Invalid role"});
            return response;
        }

        models:UserResponse[]|models:UserErrorResponse result = self.userService.getUsersByRole(role);
        if result is models:UserErrorResponse {
            response.statusCode = 500;
            response.setJsonPayload(result);
            return response;
        }

        response.statusCode = 200;
        response.setJsonPayload(result);
        return response;
    }

    // GET /api/auth/profile - Get current user profile
    public function getCurrentUserProfile(http:Request req) returns http:Response {
        http:Response response = new;

        models:User|error? user = self.authorize(req, [models:ADMIN, models:DOCTOR, models:PATIENT]);
        if user is error {
            response.statusCode = 401;
            response.setJsonPayload({message: "Unauthorized"});
            return response;
        }
        if user is () {
            response.statusCode = 403;
            response.setJsonPayload({message: "Insufficient permissions"});
            return response;
        }

        models:UserResponse|models:UserErrorResponse result = self.userService.getUserById(user.user_id);
        if result is models:UserErrorResponse {
            response.statusCode = 500;
            response.setJsonPayload(result);
            return response;
        }

        response.statusCode = 200;
        response.setJsonPayload(result);
        return response;
    }

    // Private helper method for authorization
    private function authorize(http:Request req, models:UserRole[] allowedRoles) returns models:User|error? {
        string|http:HeaderNotFoundError authHeader = req.getHeader("Authorization");
        if authHeader is http:HeaderNotFoundError {
            return error("Authorization header not found");
        }

        if !authHeader.startsWith("Bearer ") {
            return error("Invalid authorization header format");
        }

        string token = authHeader.substring(7);
        models:User|error user = self.userService.verifyToken(token);
        if user is error {
            return user;
        }

        // Check if user role is allowed
        foreach models:UserRole allowedRole in allowedRoles {
            if user.role == allowedRole {
                return user;
            }
        }

        return (); // Insufficient permissions
    }
}
