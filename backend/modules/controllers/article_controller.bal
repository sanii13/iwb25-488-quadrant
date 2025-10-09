import ballerina/http;
import ballerina/log;
import backend.models;
import backend.services;

// Article Controller for handling HTTP requests
public class ArticleController {
    private services:ArticleService articleService;

    public function init() {
        self.articleService = new services:ArticleService();
    }

    // GET /api/articles - Get all articles
    public function getAllArticles(http:Request req) returns http:Response {
        http:Response response = new;
        
        models:ArticleResponse[]|error articles = self.articleService.getAllArticles();
        
        if articles is error {
            log:printError("Error fetching all articles", 'error = articles);
            response.statusCode = 500;
            response.setJsonPayload({
                message: "Internal server error",
                details: "Failed to fetch articles"
            });
        } else {
            response.statusCode = 200;
            response.setJsonPayload(articles);
        }
        
        return response;
    }

    // GET /api/articles/{id} - Get article by ID
    public function getArticleById(http:Request req, int articleId) returns http:Response {
        http:Response response = new;
        
        models:ArticleResponse|models:ErrorResponse|error result = self.articleService.getArticleById(articleId);
        
        if result is error {
            log:printError("Error fetching article by ID", 'error = result);
            response.statusCode = 500;
            response.setJsonPayload({
                message: "Internal server error",
                details: "Failed to fetch article"
            });
        } else if result is models:ErrorResponse {
            response.statusCode = 404;
            response.setJsonPayload(result);
        } else {
            response.statusCode = 200;
            response.setJsonPayload(result);
        }
        
        return response;
    }

    // POST /api/articles - Create a new article (for future use if needed)
    public function createArticle(http:Request req) returns http:Response {
        http:Response response = new;
        
        json|error payload = req.getJsonPayload();
        
        if payload is error {
            log:printError("Error reading request payload", 'error = payload);
            response.statusCode = 400;
            response.setJsonPayload({
                message: "Invalid request payload",
                details: "Unable to parse JSON payload"
            });
            return response;
        }
        
        models:NewArticle|error newArticle = payload.cloneWithType(models:NewArticle);
        
        if newArticle is error {
            log:printError("Invalid request payload", 'error = newArticle);
            response.statusCode = 400;
            response.setJsonPayload({
                message: "Invalid request payload",
                details: "Please provide valid article data"
            });
            return response;
        }
        
        models:ArticleResponse|error result = self.articleService.createArticle(newArticle);
        
        if result is error {
            log:printError("Error creating article", 'error = result);
            response.statusCode = 500;
            response.setJsonPayload({
                message: "Internal server error",
                details: "Failed to create article"
            });
        } else {
            response.statusCode = 201;
            response.setJsonPayload(result);
        }
        
        return response;
    }

    // PUT /api/articles/{id} - Update article (for future use if needed)
    public function updateArticle(http:Request req, int articleId) returns http:Response {
        http:Response response = new;
        
        json|error payload = req.getJsonPayload();
        
        if payload is error {
            log:printError("Error reading request payload", 'error = payload);
            response.statusCode = 400;
            response.setJsonPayload({
                message: "Invalid request payload",
                details: "Unable to parse JSON payload"
            });
            return response;
        }
        
        models:NewArticle|error updatedArticle = payload.cloneWithType(models:NewArticle);
        
        if updatedArticle is error {
            log:printError("Invalid request payload", 'error = updatedArticle);
            response.statusCode = 400;
            response.setJsonPayload({
                message: "Invalid request payload",
                details: "Please provide valid article data"
            });
            return response;
        }
        
        models:ArticleResponse|models:ErrorResponse|error result = self.articleService.updateArticle(articleId, updatedArticle);
        
        if result is error {
            log:printError("Error updating article", 'error = result);
            response.statusCode = 500;
            response.setJsonPayload({
                message: "Internal server error",
                details: "Failed to update article"
            });
        } else if result is models:ErrorResponse {
            response.statusCode = 404;
            response.setJsonPayload(result);
        } else {
            response.statusCode = 200;
            response.setJsonPayload(result);
        }
        
        return response;
    }

    // DELETE /api/articles/{id} - Delete article (for future use if needed)
    public function deleteArticle(http:Request req, int articleId) returns http:Response {
        http:Response response = new;
        
        boolean|models:ErrorResponse|error result = self.articleService.deleteArticle(articleId);
        
        if result is error {
            log:printError("Error deleting article", 'error = result);
            response.statusCode = 500;
            response.setJsonPayload({
                message: "Internal server error",
                details: "Failed to delete article"
            });
        } else if result is models:ErrorResponse {
            response.statusCode = 404;
            response.setJsonPayload(result);
        } else {
            response.statusCode = 204;
            response.setJsonPayload({
                message: "Article deleted successfully"
            });
        }
        
        return response;
    }
}
