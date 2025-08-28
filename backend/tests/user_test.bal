import ballerina/test;
import backend.models;
import backend.services;

// Test data
models:NewUser testUser = {
    email: "test@example.com",
    password: "password123",
    role: models:PATIENT
};

models:UserLogin testLogin = {
    email: "test@example.com",
    password: "password123"
};

models:UserLogin invalidLogin = {
    email: "test@example.com",
    password: "wrongpassword"
};

@test:Config
function testUserRegistration() {
    services:UserService userService = new services:UserService();
    
    models:UserResponse|models:UserErrorResponse result = userService.registerUser(testUser);
    
    test:assertTrue(result is models:UserResponse, "User registration should succeed");
    
    if result is models:UserResponse {
        test:assertEquals(result.email, testUser.email, "Email should match");
        test:assertEquals(result.role, testUser.role, "Role should match");
        test:assertTrue(result.user_id > 0, "User ID should be generated");
    }
}

@test:Config {
    dependsOn: [testUserRegistration]
}
function testDuplicateUserRegistration() {
    services:UserService userService = new services:UserService();
    
    models:UserResponse|models:UserErrorResponse result = userService.registerUser(testUser);
    
    test:assertTrue(result is models:UserErrorResponse, "Duplicate registration should fail");
    
    if result is models:UserErrorResponse {
        test:assertEquals(result.message, "Email already exists", "Should return email exists error");
    }
}

@test:Config {
    dependsOn: [testUserRegistration]
}
function testUserLogin() {
    services:UserService userService = new services:UserService();
    
    models:AuthResponse result = userService.loginUser(testLogin);
    
    test:assertEquals(result.message, "Login successful", "Login should succeed");
    test:assertTrue(result.user is models:UserResponse, "User data should be returned");
    test:assertTrue(result.token is string, "JWT token should be generated");
    
    models:UserResponse? user = result.user;
    if user is models:UserResponse {
        test:assertEquals(user.email, testLogin.email, "Email should match");
    }
}

@test:Config {
    dependsOn: [testUserRegistration]
}
function testInvalidUserLogin() {
    services:UserService userService = new services:UserService();
    
    models:AuthResponse result = userService.loginUser(invalidLogin);
    
    test:assertEquals(result.message, "Invalid email or password", "Invalid login should fail");
    test:assertTrue(result.user is (), "User data should not be returned");
    test:assertTrue(result.token is (), "JWT token should not be generated");
}

@test:Config {
    dependsOn: [testUserRegistration]
}
function testGetAllUsers() {
    services:UserService userService = new services:UserService();
    
    models:UserResponse[]|models:UserErrorResponse result = userService.getAllUsers();
    
    test:assertTrue(result is models:UserResponse[], "Should return list of users");
    
    if result is models:UserResponse[] {
        test:assertTrue(result.length() > 0, "Should have at least one user");
    }
}

@test:Config {
    dependsOn: [testUserRegistration]
}
function testGetUsersByRole() {
    services:UserService userService = new services:UserService();
    
    models:UserResponse[]|models:UserErrorResponse result = userService.getUsersByRole(models:PATIENT);
    
    test:assertTrue(result is models:UserResponse[], "Should return list of users");
    
    if result is models:UserResponse[] {
        test:assertTrue(result.length() > 0, "Should have at least one patient");
        
        foreach models:UserResponse user in result {
            test:assertEquals(user.role, models:PATIENT, "All users should have PATIENT role");
        }
    }
}

@test:Config {
    dependsOn: [testUserRegistration]
}
function testUpdateUser() {
    services:UserService userService = new services:UserService();
    
    // First get a user to update
    models:UserResponse[]|models:UserErrorResponse users = userService.getAllUsers();
    test:assertTrue(users is models:UserResponse[], "Should get users list");
    
    if users is models:UserResponse[] && users.length() > 0 {
        models:UserResponse firstUser = users[0];
        
        models:UserUpdate updateData = {
            email: "updated@example.com",
            password: "newpassword123",
            role: models:PATIENT
        };
        
        models:UserResponse|models:UserErrorResponse result = userService.updateUser(firstUser.user_id, updateData);
        
        test:assertTrue(result is models:UserResponse, "User update should succeed");
        
        if result is models:UserResponse {
            test:assertEquals(result.email, "updated@example.com", "Email should be updated");
            test:assertEquals(result.user_id, firstUser.user_id, "User ID should remain same");
        }
    }
}

@test:Config {
    dependsOn: [testUpdateUser]
}
function testDeleteUser() {
    services:UserService userService = new services:UserService();
    
    // First get a user to delete
    models:UserResponse[]|models:UserErrorResponse users = userService.getAllUsers();
    test:assertTrue(users is models:UserResponse[], "Should get users list");
    
    if users is models:UserResponse[] && users.length() > 0 {
        models:UserResponse firstUser = users[0];
        
        models:UserErrorResponse? result = userService.deleteUser(firstUser.user_id);
        
        test:assertTrue(result is (), "User deletion should succeed");
        
        // Verify user is deleted
        models:UserResponse|models:UserErrorResponse deletedUser = userService.getUserById(firstUser.user_id);
        test:assertTrue(deletedUser is models:UserErrorResponse, "Deleted user should not be found");
    }
}
