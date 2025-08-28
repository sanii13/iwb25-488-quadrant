import ballerina/test;
import ballerina/http;
import backend.models;
import backend.services;
import backend.utils;

// Test service initialization
@test:Config {}
function testServiceInitialization() {
    services:RemedyService remedyService = new;
    test:assertTrue(remedyService is services:RemedyService, "RemedyService should be initialized");
}

// Test utility functions
@test:Config {}
function testValidateRemedyData() {
    json validData = {
        "name": "Test Remedy",
        "description": "Test description",
        "uses": "Test uses",
        "ingredients": ["ingredient1", "ingredient2"],
        "steps": ["step1", "step2"],
        "cautions": ["caution1"]
    };
    
    boolean result = utils:validateRemedyData(validData);
    test:assertTrue(result, "Valid remedy data should pass validation");
}

@test:Config {}
function testValidateRemedyDataInvalid() {
    json invalidData = {
        "name": "Test Remedy"
        // Missing required fields
    };
    
    boolean result = utils:validateRemedyData(invalidData);
    test:assertFalse(result, "Invalid remedy data should fail validation");
}

@test:Config {}
function testSanitizeString() {
    string input = "  test string  ";
    string result = utils:sanitizeString(input);
    test:assertEquals(result, "test string", "String should be trimmed");
}

@test:Config {}
function testIsValidUrl() {
    test:assertTrue(utils:isValidUrl("https://example.com"), "Valid HTTPS URL should pass");
    test:assertTrue(utils:isValidUrl("http://example.com"), "Valid HTTP URL should pass");
    test:assertTrue(utils:isValidUrl(()), "Null URL should pass (optional)");
    test:assertTrue(utils:isValidUrl(""), "Empty URL should pass (optional)");
    test:assertFalse(utils:isValidUrl("invalid-url"), "Invalid URL should fail");
}

@test:Config {}
function testIsValidId() {
    test:assertTrue(utils:isValidId(1), "Positive ID should be valid");
    test:assertTrue(utils:isValidId(100), "Large positive ID should be valid");
    test:assertFalse(utils:isValidId(0), "Zero ID should be invalid");
    test:assertFalse(utils:isValidId(-1), "Negative ID should be invalid");
}

// Test error response creation
@test:Config {}
function testCreateErrorResponse() {
    http:Response response = utils:createErrorResponse(404, "Not found", "Resource not found");
    test:assertEquals(response.statusCode, 404, "Status code should be 404");
}

// Test model types
@test:Config {}
function testRemedyModel() {
    models:NewRemedy newRemedy = {
        name: "Test Remedy",
        description: "Test description",
        uses: "Test uses",
        ingredients: ["ingredient1"],
        steps: ["step1"],
        cautions: ["caution1"],
        image_url: "https://example.com/image.jpg"
    };
    
    test:assertEquals(newRemedy.name, "Test Remedy", "Remedy name should match");
    test:assertEquals(newRemedy.ingredients.length(), 1, "Should have one ingredient");
}

@test:Config {}
function testRemedyHello() {
    test:assertTrue(true, msg = "Dummy test case");
}
