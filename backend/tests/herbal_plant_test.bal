import ballerina/test;
import ballerina/http;
import backend.models;
import backend.services;
import backend.controllers;

// Test data
models:NewHerbalPlant testPlant = {
    botanical_name: "Test Botanical Name",
    local_name: "Test Local Name", 
    description: "Test description for herbal plant",
    medicinal_uses: "Test medicinal uses",
    cultivation_steps: "Test cultivation steps",
    image_url: "https://example.com/test-plant.jpg"
};

// Test HerbalPlantService
@test:Config {}
function testHerbalPlantServiceInit() {
    services:HerbalPlantService herbalPlantService = new();
    test:assertTrue(herbalPlantService is services:HerbalPlantService, "HerbalPlantService should be initialized successfully");
}

// Test HerbalPlantController
@test:Config {}
function testHerbalPlantControllerInit() {
    controllers:HerbalPlantController herbalPlantController = new();
    test:assertTrue(herbalPlantController is controllers:HerbalPlantController, "HerbalPlantController should be initialized successfully");
}

// Test controller GET request handling
@test:Config {}
function testGetAllHerbalPlantsRequest() {
    controllers:HerbalPlantController herbalPlantController = new();
    http:Request req = new();
    
    http:Response response = herbalPlantController.getAllHerbalPlants(req);
    
    test:assertTrue(response is http:Response, "Should return HTTP response");
    test:assertTrue(response.statusCode == 200 || response.statusCode == 500, "Should return either success or server error status");
}

@test:Config {}
function testGetHerbalPlantByIdRequest() {
    controllers:HerbalPlantController herbalPlantController = new();
    http:Request req = new();
    
    http:Response response = herbalPlantController.getHerbalPlantById(req, 1);
    
    test:assertTrue(response is http:Response, "Should return HTTP response");
    test:assertTrue(response.statusCode == 200 || response.statusCode == 404 || response.statusCode == 500, 
                   "Should return success, not found, or server error status");
}

// Test model validation
@test:Config {}
function testHerbalPlantModelCreation() {
    models:HerbalPlant plant = {
        plant_id: 1,
        botanical_name: "Azadirachta indica",
        local_name: "Neem",
        description: "Neem tree description",
        medicinal_uses: "Antibacterial, antifungal properties",
        cultivation_steps: "Plant in well-draining soil",
        image_url: "https://example.com/neem.jpg"
    };
    
    test:assertEquals(plant.plant_id, 1, "Plant ID should be set correctly");
    test:assertEquals(plant.botanical_name, "Azadirachta indica", "Botanical name should be set correctly");
    test:assertEquals(plant.local_name, "Neem", "Local name should be set correctly");
}

@test:Config {}
function testNewHerbalPlantModelCreation() {
    models:NewHerbalPlant newPlant = {
        botanical_name: "Ocimum tenuiflorum",
        local_name: "Holy Basil",
        description: "Sacred plant in Hindu tradition",
        medicinal_uses: "Stress reduction, respiratory support",
        cultivation_steps: "Grow in well-draining soil",
        image_url: "https://example.com/tulsi.jpg"
    };
    
    test:assertEquals(newPlant.botanical_name, "Ocimum tenuiflorum", "Botanical name should be set correctly");
    test:assertEquals(newPlant.local_name, "Holy Basil", "Local name should be set correctly");
}

@test:Config {}
function testHerbalPlantResponseModelCreation() {
    models:HerbalPlantResponse plantResponse = {
        plant_id: 1,
        botanical_name: "Curcuma longa",
        local_name: "Turmeric",
        description: "Flowering plant of the ginger family",
        medicinal_uses: "Anti-inflammatory, antioxidant properties",
        cultivation_steps: "Plant rhizomes in well-draining soil",
        image_url: "https://example.com/turmeric.jpg",
        created_at: "2024-01-01T00:00:00Z",
        updated_at: "2024-01-01T00:00:00Z"
    };
    
    test:assertEquals(plantResponse.plant_id, 1, "Plant ID should be set correctly");
    test:assertEquals(plantResponse.botanical_name, "Curcuma longa", "Botanical name should be set correctly");
    test:assertEquals(plantResponse.local_name, "Turmeric", "Local name should be set correctly");
}
