import ballerina/http;
import ballerina/log;
import backend.models;
import backend.services;

// Doctor controller for handling doctor-related HTTP requests
public class DoctorController {
    private services:DoctorService doctorService;
    private services:UserService userService;

    public function init() {
        self.doctorService = new services:DoctorService();
        self.userService = new services:UserService();
    }

    // Create a new doctor profile
    public function createDoctor(http:Request req) returns http:Response {
        http:Response response = new;
        
        // Check authorization - Only admin or the user themselves can create doctor profile
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
                "details": "Only admins and doctors can create doctor profiles"
            });
            return response;
        }

        json|http:ClientError payload = req.getJsonPayload();
        if payload is http:ClientError {
            response.statusCode = 400;
            response.setJsonPayload({
                "message": "Invalid JSON payload",
                "details": "Please provide valid doctor data"
            });
            return response;
        }

        models:NewDoctor|error newDoctor = payload.cloneWithType(models:NewDoctor);
        if newDoctor is error {
            log:printError("Error parsing doctor creation request", newDoctor);
            response.statusCode = 400;
            response.setJsonPayload({
                "message": "Invalid doctor data",
                "details": "Please check the provided doctor information"
            });
            return response;
        }

        // Verify the user is creating profile for themselves or admin is creating
        if user.role != models:ADMIN && user.user_id != newDoctor.user_id {
            response.statusCode = 403;
            response.setJsonPayload({
                "message": "Forbidden",
                "details": "Cannot create doctor profile for another user"
            });
            return response;
        }

        models:DoctorResponse|models:DoctorErrorResponse result = self.doctorService.createDoctor(newDoctor);
        
        if result is models:DoctorResponse {
            response.statusCode = 201;
            response.setJsonPayload(result);
        } else {
            response.statusCode = 400;
            response.setJsonPayload(result);
        }
        
        return response;
    }

    // Get all doctors
    public function getAllDoctors(http:Request req) returns http:Response {
        http:Response response = new;
        
        // Parse query parameters
        map<string[]> queryParams = req.getQueryParams();
        
        models:DoctorSearchParams searchParams = {};
        
        if queryParams.hasKey("page") {
            string[]? pageParam = queryParams["page"];
            if pageParam is string[] && pageParam.length() > 0 {
                int|error pageResult = int:fromString(pageParam[0]);
                if pageResult is int {
                    searchParams.page = pageResult;
                }
            }
        }
        
        if queryParams.hasKey("limit") {
            string[]? limitParam = queryParams["limit"];
            if limitParam is string[] && limitParam.length() > 0 {
                int|error limitResult = int:fromString(limitParam[0]);
                if limitResult is int {
                    searchParams.'limit = limitResult;
                }
            }
        }
        
        if queryParams.hasKey("specialization") {
            string[]? specializationParam = queryParams["specialization"];
            if specializationParam is string[] && specializationParam.length() > 0 {
                searchParams.specialization = specializationParam[0];
            }
        }
        
        if queryParams.hasKey("location") {
            string[]? locationParam = queryParams["location"];
            if locationParam is string[] && locationParam.length() > 0 {
                searchParams.location = locationParam[0];
            }
        }
        
        if queryParams.hasKey("name") {
            string[]? nameParam = queryParams["name"];
            if nameParam is string[] && nameParam.length() > 0 {
                searchParams.name = nameParam[0];
            }
        }

        models:DoctorResponse[]|models:DoctorErrorResponse result = self.doctorService.getAllDoctors(searchParams);
        
        if result is models:DoctorResponse[] {
            response.statusCode = 200;
            response.setJsonPayload(result);
        } else {
            response.statusCode = 400;
            response.setJsonPayload(result);
        }
        
        return response;
    }

    // Get doctor by ID
    public function getDoctorById(http:Request req, int doctorId) returns http:Response {
        http:Response response = new;
        
        models:DoctorResponse|models:DoctorErrorResponse? result = self.doctorService.getDoctorById(doctorId);
        
        if result is () {
            response.statusCode = 404;
            response.setJsonPayload({
                "message": "Doctor not found",
                "details": "No doctor found with the given ID"
            });
        } else if result is models:DoctorResponse {
            response.statusCode = 200;
            response.setJsonPayload(result);
        } else {
            response.statusCode = 400;
            response.setJsonPayload(result);
        }
        
        return response;
    }

    // Update doctor profile
    public function updateDoctor(http:Request req, int doctorId) returns http:Response {
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
                "details": "Only admins and doctors can update doctor profiles"
            });
            return response;
        }

        // Check if doctor exists and verify authorization
        models:DoctorResponse|models:DoctorErrorResponse? existingDoctor = self.doctorService.getDoctorById(doctorId);
        if existingDoctor is () {
            response.statusCode = 404;
            response.setJsonPayload({
                "message": "Doctor not found",
                "details": "No doctor found with the given ID"
            });
            return response;
        }
        if existingDoctor is models:DoctorErrorResponse {
            response.statusCode = 400;
            response.setJsonPayload(existingDoctor);
            return response;
        }

        // Verify authorization (only the doctor themselves or admin can update)
        if user.role != models:ADMIN && user.user_id != existingDoctor.user_id {
            response.statusCode = 403;
            response.setJsonPayload({
                "message": "Forbidden",
                "details": "Cannot update another doctor's profile"
            });
            return response;
        }

        json|http:ClientError payload = req.getJsonPayload();
        if payload is http:ClientError {
            response.statusCode = 400;
            response.setJsonPayload({
                "message": "Invalid JSON payload",
                "details": "Please provide valid doctor update data"
            });
            return response;
        }

        models:DoctorUpdate|error doctorUpdate = payload.cloneWithType(models:DoctorUpdate);
        if doctorUpdate is error {
            log:printError("Error parsing doctor update request", doctorUpdate);
            response.statusCode = 400;
            response.setJsonPayload({
                "message": "Invalid doctor update data",
                "details": "Please check the provided doctor information"
            });
            return response;
        }

        models:DoctorResponse|models:DoctorErrorResponse? result = self.doctorService.updateDoctor(doctorId, doctorUpdate);
        
        if result is () {
            response.statusCode = 404;
            response.setJsonPayload({
                "message": "Doctor not found",
                "details": "No doctor found with the given ID"
            });
        } else if result is models:DoctorResponse {
            response.statusCode = 200;
            response.setJsonPayload(result);
        } else {
            response.statusCode = 400;
            response.setJsonPayload(result);
        }
        
        return response;
    }

    // Delete doctor profile
    public function deleteDoctor(http:Request req, int doctorId) returns http:Response {
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
                "details": "Only admins and doctors can delete doctor profiles"
            });
            return response;
        }

        // Check if doctor exists and verify authorization
        models:DoctorResponse|models:DoctorErrorResponse? existingDoctor = self.doctorService.getDoctorById(doctorId);
        if existingDoctor is () {
            response.statusCode = 404;
            response.setJsonPayload({
                "message": "Doctor not found",
                "details": "No doctor found with the given ID"
            });
            return response;
        }
        if existingDoctor is models:DoctorErrorResponse {
            response.statusCode = 400;
            response.setJsonPayload(existingDoctor);
            return response;
        }

        // Verify authorization (only the doctor themselves or admin can delete)
        if user.role != models:ADMIN && user.user_id != existingDoctor.user_id {
            response.statusCode = 403;
            response.setJsonPayload({
                "message": "Forbidden",
                "details": "Cannot delete another doctor's profile"
            });
            return response;
        }

        boolean|models:DoctorErrorResponse result = self.doctorService.deleteDoctor(doctorId);
        
        if result is boolean {
            if result {
                response.statusCode = 200;
                response.setJsonPayload({
                    "message": "Doctor deleted successfully"
                });
            } else {
                response.statusCode = 404;
                response.setJsonPayload({
                    "message": "Doctor not found",
                    "details": "No doctor found with the given ID"
                });
            }
        } else {
            response.statusCode = 400;
            response.setJsonPayload(result);
        }
        
        return response;
    }

    // Get doctor by user ID
    public function getDoctorByUserId(http:Request req, int userId) returns http:Response {
        http:Response response = new;
        
        models:DoctorResponse|models:DoctorErrorResponse? result = self.doctorService.getDoctorByUserId(userId);
        
        if result is () {
            response.statusCode = 404;
            response.setJsonPayload({
                "message": "Doctor not found",
                "details": "No doctor profile found for the given user ID"
            });
        } else if result is models:DoctorResponse {
            response.statusCode = 200;
            response.setJsonPayload(result);
        } else {
            response.statusCode = 400;
            response.setJsonPayload(result);
        }
        
        return response;
    }

    // Get current user's doctor profile
    public function getCurrentUserDoctorProfile(http:Request req) returns http:Response {
        http:Response response = new;
        
        // Check authorization
        models:User|error? user = self.authorize(req, [models:DOCTOR]);
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
                "details": "Only doctors can access their own profile"
            });
            return response;
        }

        models:DoctorResponse|models:DoctorErrorResponse? result = self.doctorService.getDoctorByUserId(user.user_id);
        
        if result is () {
            response.statusCode = 404;
            response.setJsonPayload({
                "message": "Doctor profile not found",
                "details": "No doctor profile found for the current user"
            });
        } else if result is models:DoctorResponse {
            response.statusCode = 200;
            response.setJsonPayload(result);
        } else {
            response.statusCode = 400;
            response.setJsonPayload(result);
        }
        
        return response;
    }

    // Get doctors by specialization
    public function getDoctorsBySpecialization(http:Request req, string specialization) returns http:Response {
        http:Response response = new;
        
        // Parse query parameters for pagination
        map<string[]> queryParams = req.getQueryParams();
        int page = 1;
        int 'limit = 10;
        
        if queryParams.hasKey("page") {
            string[]? pageParam = queryParams["page"];
            if pageParam is string[] && pageParam.length() > 0 {
                int|error pageResult = int:fromString(pageParam[0]);
                if pageResult is int {
                    page = pageResult;
                }
            }
        }
        
        if queryParams.hasKey("limit") {
            string[]? limitParam = queryParams["limit"];
            if limitParam is string[] && limitParam.length() > 0 {
                int|error limitResult = int:fromString(limitParam[0]);
                if limitResult is int {
                    'limit = limitResult;
                }
            }
        }

        models:DoctorResponse[]|models:DoctorErrorResponse result = self.doctorService.getDoctorsBySpecialization(specialization, page, 'limit);
        
        if result is models:DoctorResponse[] {
            response.statusCode = 200;
            response.setJsonPayload(result);
        } else {
            response.statusCode = 400;
            response.setJsonPayload(result);
        }
        
        return response;
    }

    // Get doctors by location
    public function getDoctorsByLocation(http:Request req, string location) returns http:Response {
        http:Response response = new;
        
        // Parse query parameters for pagination
        map<string[]> queryParams = req.getQueryParams();
        int page = 1;
        int 'limit = 10;
        
        if queryParams.hasKey("page") {
            string[]? pageParam = queryParams["page"];
            if pageParam is string[] && pageParam.length() > 0 {
                int|error pageResult = int:fromString(pageParam[0]);
                if pageResult is int {
                    page = pageResult;
                }
            }
        }
        
        if queryParams.hasKey("limit") {
            string[]? limitParam = queryParams["limit"];
            if limitParam is string[] && limitParam.length() > 0 {
                int|error limitResult = int:fromString(limitParam[0]);
                if limitResult is int {
                    'limit = limitResult;
                }
            }
        }

        models:DoctorResponse[]|models:DoctorErrorResponse result = self.doctorService.getDoctorsByLocation(location, page, 'limit);
        
        if result is models:DoctorResponse[] {
            response.statusCode = 200;
            response.setJsonPayload(result);
        } else {
            response.statusCode = 400;
            response.setJsonPayload(result);
        }
        
        return response;
    }

    // Get top-rated doctors
    public function getTopRatedDoctors(http:Request req) returns http:Response {
        http:Response response = new;
        
        // Parse query parameters
        map<string[]> queryParams = req.getQueryParams();
        int 'limit = 10;
        
        if queryParams.hasKey("limit") {
            string[]? limitParam = queryParams["limit"];
            if limitParam is string[] && limitParam.length() > 0 {
                int|error limitResult = int:fromString(limitParam[0]);
                if limitResult is int {
                    'limit = limitResult;
                }
            }
        }

        models:DoctorProfileSummary[]|models:DoctorErrorResponse result = self.doctorService.getTopRatedDoctors('limit);
        
        if result is models:DoctorProfileSummary[] {
            response.statusCode = 200;
            response.setJsonPayload(result);
        } else {
            response.statusCode = 400;
            response.setJsonPayload(result);
        }
        
        return response;
    }

    // Update doctor rating
    public function updateDoctorRating(http:Request req, int doctorId) returns http:Response {
        http:Response response = new;
        
        // Check authorization - any authenticated user can rate a doctor
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
                "details": "Authentication required to rate doctors"
            });
            return response;
        }

        json|http:ClientError payload = req.getJsonPayload();
        if payload is http:ClientError {
            response.statusCode = 400;
            response.setJsonPayload({
                "message": "Invalid JSON payload",
                "details": "Please provide valid rating data"
            });
            return response;
        }

        decimal|error rating = (<decimal>payload.rating);
        if rating is error {
            response.statusCode = 400;
            response.setJsonPayload({
                "message": "Invalid rating",
                "details": "Rating must be a decimal number between 0.0 and 5.0"
            });
            return response;
        }

        models:DoctorResponse|models:DoctorErrorResponse? result = self.doctorService.updateDoctorRating(doctorId, rating);
        
        if result is () {
            response.statusCode = 404;
            response.setJsonPayload({
                "message": "Doctor not found",
                "details": "No doctor found with the given ID"
            });
        } else if result is models:DoctorResponse {
            response.statusCode = 200;
            response.setJsonPayload(result);
        } else {
            response.statusCode = 400;
            response.setJsonPayload(result);
        }
        
        return response;
    }

    // Get available specializations
    public function getSpecializations(http:Request req) returns http:Response {
        http:Response response = new;
        
        string[]|models:DoctorErrorResponse result = self.doctorService.getSpecializations();
        
        if result is string[] {
            response.statusCode = 200;
            response.setJsonPayload(result);
        } else {
            response.statusCode = 400;
            response.setJsonPayload(result);
        }
        
        return response;
    }

    // Get available locations
    public function getLocations(http:Request req) returns http:Response {
        http:Response response = new;
        
        string[]|models:DoctorErrorResponse result = self.doctorService.getLocations();
        
        if result is string[] {
            response.statusCode = 200;
            response.setJsonPayload(result);
        } else {
            response.statusCode = 400;
            response.setJsonPayload(result);
        }
        
        return response;
    }

    // Get doctors count
    public function getDoctorsCount(http:Request req) returns http:Response {
        http:Response response = new;
        
        int|models:DoctorErrorResponse result = self.doctorService.getDoctorsCount();
        
        if result is int {
            response.statusCode = 200;
            response.setJsonPayload({count: result});
        } else {
            response.statusCode = 400;
            response.setJsonPayload(result);
        }
        
        return response;
    }

    // Helper method for authorization (copied from patient controller pattern)
    private function authorize(http:Request req, models:UserRole[] allowedRoles) returns models:User|error? {
        // This would be implemented with JWT token validation or session management
        // For now, returning a basic implementation
        // In a real application, you'd extract and validate the JWT token from headers
        
        string|http:HeaderNotFoundError authHeader = req.getHeader("Authorization");
        if authHeader is http:HeaderNotFoundError {
            return error("No authorization header found");
        }
        
        // For demo purposes - in real implementation, decode JWT and validate
        // This is a simplified version that would need proper JWT handling
        return error("Authorization not fully implemented yet");
    }
}
