import ballerina/http;
import ballerina/log;
import backend.models;
import backend.services;

// Patient controller for handling patient-related HTTP requests
public class PatientController {
    private services:PatientService patientService;
    private services:UserService userService;

    public function init() {
        self.patientService = new ();
        self.userService = new ();
    }

    // Create a new patient
    public function createPatient(http:Request req) returns http:Response {
        http:Response response = new;
        
        // Check authorization
        models:User|error? user = self.authorize(req, [models:ADMIN, models:DOCTOR]);
        if user is error {
            response.statusCode = 401;
            response.setJsonPayload({
                "message": "Unauthorized",
                "details": "Authentication required"
            });
            return response;
        }
        if user is () {
            response.statusCode = 403;
            response.setJsonPayload({
                "message": "Forbidden",
                "details": "Only doctors and admins can create patient records"
            });
            return response;
        }

        json|http:ClientError payload = req.getJsonPayload();
        if payload is http:ClientError {
            response.statusCode = 400;
            response.setJsonPayload({
                "message": "Invalid JSON payload",
                "details": "Please provide valid patient data"
            });
            return response;
        }

        models:NewPatient|error newPatient = payload.cloneWithType(models:NewPatient);
        if newPatient is error {
            log:printError("Error parsing patient creation request", newPatient);
            response.statusCode = 400;
            response.setJsonPayload({
                "message": "Invalid request format",
                "details": "Please provide valid patient data"
            });
            return response;
        }

        models:PatientResponse|models:PatientErrorResponse result = self.patientService.createPatient(newPatient);
        
        if result is models:PatientErrorResponse {
            if result.message.includes("already") {
                response.statusCode = 409; // Conflict
            } else if result.message.includes("not found") {
                response.statusCode = 404;
            } else {
                response.statusCode = 500;
            }
            response.setJsonPayload(result);
            return response;
        }

        response.statusCode = 201;
        response.setJsonPayload({
            "message": "Patient created successfully",
            "data": result
        });
        return response;
    }

    // Get patient by ID
    public function getPatientById(http:Request req, int patientId) returns http:Response {
        http:Response response = new;
        
        // Check authorization
        models:User|error? user = self.authorize(req, [models:ADMIN, models:DOCTOR, models:PATIENT]);
        if user is error {
            response.statusCode = 401;
            response.setJsonPayload({
                "message": "Unauthorized",
                "details": "Authentication required"
            });
            return response;
        }
        if user is () {
            response.statusCode = 403;
            response.setJsonPayload({
                "message": "Forbidden",
                "details": "Authentication required"
            });
            return response;
        }

        models:PatientResponse|models:PatientErrorResponse result = self.patientService.getPatientById(patientId);
        
        if result is models:PatientErrorResponse {
            if result.message.includes("not found") {
                response.statusCode = 404;
            } else {
                response.statusCode = 500;
            }
            response.setJsonPayload(result);
            return response;
        }

        // Patients can only view their own records, doctors and admins can view any
        if user.role == models:PATIENT && result.user_id != user.user_id {
            response.statusCode = 403;
            response.setJsonPayload({
                "message": "Forbidden",
                "details": "You can only view your own patient record"
            });
            return response;
        }

        response.statusCode = 200;
        response.setJsonPayload({
            "message": "Patient retrieved successfully",
            "data": result
        });
        return response;
    }

    // Get patient by user ID
    public function getPatientByUserId(http:Request req, int userId) returns http:Response {
        http:Response response = new;
        
        // Check authorization
        models:User|error? user = self.authorize(req, [models:ADMIN, models:DOCTOR, models:PATIENT]);
        if user is error {
            response.statusCode = 401;
            response.setJsonPayload({
                "message": "Unauthorized",
                "details": "Authentication required"
            });
            return response;
        }
        if user is () {
            response.statusCode = 403;
            response.setJsonPayload({
                "message": "Forbidden",
                "details": "Authentication required"
            });
            return response;
        }

        // Patients can only view their own records, doctors and admins can view any
        if user.role == models:PATIENT && userId != user.user_id {
            response.statusCode = 403;
            response.setJsonPayload({
                "message": "Forbidden",
                "details": "You can only view your own patient record"
            });
            return response;
        }

        models:PatientResponse|models:PatientErrorResponse result = self.patientService.getPatientByUserId(userId);
        
        if result is models:PatientErrorResponse {
            if result.message.includes("not found") {
                response.statusCode = 404;
            } else {
                response.statusCode = 500;
            }
            response.setJsonPayload(result);
            return response;
        }

        response.statusCode = 200;
        response.setJsonPayload({
            "message": "Patient retrieved successfully",
            "data": result
        });
        return response;
    }

    // Get all patients (for doctors and admins only)
    public function getAllPatients(http:Request req) returns http:Response {
        http:Response response = new;
        
        // Check authorization
        models:User|error? user = self.authorize(req, [models:ADMIN, models:DOCTOR]);
        if user is error {
            response.statusCode = 401;
            response.setJsonPayload({
                "message": "Unauthorized",
                "details": "Authentication required"
            });
            return response;
        }
        if user is () {
            response.statusCode = 403;
            response.setJsonPayload({
                "message": "Forbidden",
                "details": "Only doctors and admins can view all patients"
            });
            return response;
        }

        // Parse query parameters for pagination
        string? pageStr = req.getQueryParamValue("page");
        string? limitStr = req.getQueryParamValue("limit");
        
        int page = 1;
        int 'limit = 10;
        
        if pageStr is string {
            int|error pageInt = int:fromString(pageStr);
            if pageInt is int && pageInt > 0 {
                page = pageInt;
            }
        }
        
        if limitStr is string {
            int|error limitInt = int:fromString(limitStr);
            if limitInt is int && limitInt > 0 && limitInt <= 100 {
                'limit = limitInt;
            }
        }

        models:PatientResponse[]|models:PatientErrorResponse result = self.patientService.getAllPatients(page, 'limit);
        
        if result is models:PatientErrorResponse {
            response.statusCode = 500;
            response.setJsonPayload(result);
            return response;
        }

        // Get total count for pagination metadata
        int|models:PatientErrorResponse totalCount = self.patientService.getPatientsCount();
        int total = totalCount is int ? totalCount : 0;
        int totalPages = total == 0 ? 0 : (total + 'limit - 1) / 'limit;

        response.statusCode = 200;
        response.setJsonPayload({
            "message": "Patients retrieved successfully",
            "data": result,
            "pagination": {
                "current_page": page,
                "per_page": 'limit,
                "total_records": total,
                "total_pages": totalPages,
                "has_next": page < totalPages,
                "has_previous": page > 1
            }
        });
        return response;
    }

    // Update patient
    public function updatePatient(http:Request req, int patientId) returns http:Response {
        http:Response response = new;
        
        // Check authorization
        models:User|error? user = self.authorize(req, [models:ADMIN, models:DOCTOR, models:PATIENT]);
        if user is error {
            response.statusCode = 401;
            response.setJsonPayload({
                "message": "Unauthorized",
                "details": "Authentication required"
            });
            return response;
        }
        if user is () {
            response.statusCode = 403;
            response.setJsonPayload({
                "message": "Forbidden",
                "details": "Authentication required"
            });
            return response;
        }

        // Get the patient first to check ownership for patients
        if user.role == models:PATIENT {
            models:PatientResponse|models:PatientErrorResponse existingPatient = self.patientService.getPatientById(patientId);
            if existingPatient is models:PatientErrorResponse {
                response.statusCode = 404;
                response.setJsonPayload(existingPatient);
                return response;
            }
            
            if existingPatient.user_id != user.user_id {
                response.statusCode = 403;
                response.setJsonPayload({
                    "message": "Forbidden",
                    "details": "You can only update your own patient record"
                });
                return response;
            }
        }

        json|http:ClientError payload = req.getJsonPayload();
        if payload is http:ClientError {
            response.statusCode = 400;
            response.setJsonPayload({
                "message": "Invalid JSON payload",
                "details": "Please provide valid patient update data"
            });
            return response;
        }

        models:PatientUpdate|error patientUpdate = payload.cloneWithType(models:PatientUpdate);
        if patientUpdate is error {
            log:printError("Error parsing patient update request", patientUpdate);
            response.statusCode = 400;
            response.setJsonPayload({
                "message": "Invalid request format",
                "details": "Please provide valid patient update data"
            });
            return response;
        }

        models:PatientResponse|models:PatientErrorResponse result = self.patientService.updatePatient(patientId, patientUpdate);
        
        if result is models:PatientErrorResponse {
            if result.message.includes("not found") {
                response.statusCode = 404;
            } else {
                response.statusCode = 500;
            }
            response.setJsonPayload(result);
            return response;
        }

        response.statusCode = 200;
        response.setJsonPayload({
            "message": "Patient updated successfully",
            "data": result
        });
        return response;
    }

    // Delete patient (doctors and admins only)
    public function deletePatient(http:Request req, int patientId) returns http:Response {
        http:Response response = new;
        
        // Check authorization
        models:User|error? user = self.authorize(req, [models:ADMIN, models:DOCTOR]);
        if user is error {
            response.statusCode = 401;
            response.setJsonPayload({
                "message": "Unauthorized",
                "details": "Authentication required"
            });
            return response;
        }
        if user is () {
            response.statusCode = 403;
            response.setJsonPayload({
                "message": "Forbidden",
                "details": "Only doctors and admins can delete patient records"
            });
            return response;
        }

        models:PatientErrorResponse? result = self.patientService.deletePatient(patientId);
        
        if result is models:PatientErrorResponse {
            if result.message.includes("not found") {
                response.statusCode = 404;
            } else {
                response.statusCode = 500;
            }
            response.setJsonPayload(result);
            return response;
        }

        response.statusCode = 200;
        response.setJsonPayload({
            "message": "Patient deleted successfully"
        });
        return response;
    }

    // Get current user's patient record
    public function getCurrentUserPatient(http:Request req) returns http:Response {
        http:Response response = new;
        
        // Check authorization
        models:User|error? user = self.authorize(req, [models:ADMIN, models:DOCTOR, models:PATIENT]);
        if user is error {
            response.statusCode = 401;
            response.setJsonPayload({
                "message": "Unauthorized",
                "details": "Authentication required"
            });
            return response;
        }
        if user is () {
            response.statusCode = 403;
            response.setJsonPayload({
                "message": "Forbidden",
                "details": "Authentication required"
            });
            return response;
        }

        models:PatientResponse|models:PatientErrorResponse result = self.patientService.getPatientByUserId(user.user_id);
        
        if result is models:PatientErrorResponse {
            if result.message.includes("not found") {
                response.statusCode = 404;
            } else {
                response.statusCode = 500;
            }
            response.setJsonPayload(result);
            return response;
        }

        response.statusCode = 200;
        response.setJsonPayload({
            "message": "Patient record retrieved successfully",
            "data": result
        });
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
