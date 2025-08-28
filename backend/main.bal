import ballerina/http;
import ballerina/time;
import backend.controllers;

// Global controller instances
controllers:RemedyController remedyController = new;
controllers:HerbalPlantController herbalPlantController = new;
controllers:ArticleController articleController = new;

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
