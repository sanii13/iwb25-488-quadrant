import ballerina/http;
import ballerina/time;
import backend.controllers;

// Global controller instances
controllers:RemedyController remedyController = new;
controllers:HerbalPlantController herbalPlantController = new;
controllers:ArticleController articleController = new;
controllers:UserController userController = new;
controllers:PatientController patientController = new;

// Main service for remedy API endpoints
service /api/remedies on new http:Listener(8080) {

    // GET /api/remedies - Get all remedies
    resource function get .() returns http:Response {
        http:Request req = new;
        return remedyController.getAllRemedies(req);
    }

    // GET /api/remedies/{id} - Get remedy by ID
    resource function get [int remedyId]() returns http:Response {
        http:Request req = new;
        return remedyController.getRemedyById(req, remedyId);
    }

    // POST /api/remedies - Create a new remedy (for future use)
    resource function post .(http:Request req) returns http:Response {
        return remedyController.createRemedy(req);
    }

    // PUT /api/remedies/{id} - Update remedy (for future use)
    resource function put [int remedyId](http:Request req) returns http:Response {
        return remedyController.updateRemedy(req, remedyId);
    }

    // DELETE /api/remedies/{id} - Delete remedy (for future use)
    resource function delete [int remedyId]() returns http:Response {
        http:Request req = new;
        return remedyController.deleteRemedy(req, remedyId);
    }
}

// Main service for herbal plants API endpoints
service /api/herbal\-plants on new http:Listener(8080) {

    // GET /api/herbal-plants - Get all herbal plants
    resource function get .() returns http:Response {
        http:Request req = new;
        return herbalPlantController.getAllHerbalPlants(req);
    }

    // GET /api/herbal-plants/{id} - Get herbal plant by ID
    resource function get [int plantId]() returns http:Response {
        http:Request req = new;
        return herbalPlantController.getHerbalPlantById(req, plantId);
    }
}

// Main service for articles API endpoints
service /api/articles on new http:Listener(8080) {

    // GET /api/articles - Get all articles
    resource function get .() returns http:Response {
        http:Request req = new;
        return articleController.getAllArticles(req);
    }

    // GET /api/articles/{id} - Get article by ID
    resource function get [int articleId]() returns http:Response {
        http:Request req = new;
        return articleController.getArticleById(req, articleId);
    }
}

// Authentication service for user management
service /api/auth on new http:Listener(8080) {

    // POST /api/auth/register - Register a new user
    resource function post register(http:Request req) returns http:Response {
        return userController.registerUser(req);
    }

    // POST /api/auth/login - User login
    resource function post login(http:Request req) returns http:Response {
        return userController.loginUser(req);
    }

    // GET /api/auth/profile - Get current user profile
    resource function get profile(http:Request req) returns http:Response {
        return userController.getCurrentUserProfile(req);
    }
}

// User management service
service /api/users on new http:Listener(8080) {

    // GET /api/users - Get all users (admin only)
    resource function get .(http:Request req) returns http:Response {
        return userController.getAllUsers(req);
    }

    // GET /api/users/{id} - Get user by ID
    resource function get [int userId](http:Request req) returns http:Response {
        return userController.getUserById(req, userId);
    }

    // PUT /api/users/{id} - Update user
    resource function put [int userId](http:Request req) returns http:Response {
        return userController.updateUser(req, userId);
    }

    // DELETE /api/users/{id} - Delete user (admin only)
    resource function delete [int userId](http:Request req) returns http:Response {
        return userController.deleteUser(req, userId);
    }

    // GET /api/users/role/{role} - Get users by role (admin only)
    resource function get role/[string role](http:Request req) returns http:Response {
        return userController.getUsersByRole(req, role);
    }
}

// Patient management service
service /api/patients on new http:Listener(8080) {

    // POST /api/patients - Create a new patient record
    resource function post .(http:Request req) returns http:Response {
        return patientController.createPatient(req);
    }

    // GET /api/patients - Get all patients (doctors and admins only)
    resource function get .(http:Request req) returns http:Response {
        return patientController.getAllPatients(req);
    }

    // GET /api/patients/{id} - Get patient by ID
    resource function get [int patientId](http:Request req) returns http:Response {
        return patientController.getPatientById(req, patientId);
    }

    // PUT /api/patients/{id} - Update patient
    resource function put [int patientId](http:Request req) returns http:Response {
        return patientController.updatePatient(req, patientId);
    }

    // DELETE /api/patients/{id} - Delete patient (doctors and admins only)
    resource function delete [int patientId](http:Request req) returns http:Response {
        return patientController.deletePatient(req, patientId);
    }

    // GET /api/patients/user/{userId} - Get patient by user ID
    resource function get user/[int userId](http:Request req) returns http:Response {
        return patientController.getPatientByUserId(req, userId);
    }

    // GET /api/patients/me - Get current user's patient record
    resource function get me(http:Request req) returns http:Response {
        return patientController.getCurrentUserPatient(req);
    }
}

// Health check endpoint
service /health on new http:Listener(8080) {
    resource function get .() returns json {
        return {
            "status": "healthy",
            "serviceName": "remedy-api",
            "timestamp": time:utcNow()
        };
    }
}
