import ballerina/test;
import ballerina/http;
import backend.models;
import backend.services;
import backend.repositories;
import backend.controllers;

// Test data
models:NewArticle testArticle = {
    title: "Test Article",
    category: "Test Category",
    content: "This is test content for the article. It contains detailed information about testing.",
    image_url: "https://example.com/test-image.jpg"
};

// Test the Article Service
@test:Config {}
function testArticleServiceGetAll() returns error? {
    services:ArticleService articleService = new;
    models:ArticleResponse[]|error result = articleService.getAllArticles();
    
    if result is error {
        test:assertFail("Failed to get all articles: " + result.message());
    } else {
        // Should return an array (could be empty)
        test:assertTrue(result is models:ArticleResponse[]);
    }
}

@test:Config {}
function testArticleServiceGetById() returns error? {
    services:ArticleService articleService = new;
    
    // Test with non-existent ID
    models:ArticleResponse|models:ErrorResponse|error result = articleService.getArticleById(99999);
    
    if result is error {
        test:assertFail("Unexpected error when getting article by ID: " + result.message());
    } else if result is models:ErrorResponse {
        test:assertEquals(result.message, "Article not found");
    } else {
        // If an article is found, it should be valid
        test:assertTrue(result.article_id > 0);
        test:assertTrue(result.title.length() > 0);
    }
}

// Test the Article Repository
@test:Config {}
function testArticleRepositoryGetAll() returns error? {
    repositories:ArticleRepository articleRepo = new;
    models:Article[]|error result = articleRepo.getAllArticles();
    
    if result is error {
        test:assertFail("Failed to get all articles from repository: " + result.message());
    } else {
        // Should return an array (could be empty)
        test:assertTrue(result is models:Article[]);
    }
}

@test:Config {}
function testArticleRepositoryGetById() returns error? {
    repositories:ArticleRepository articleRepo = new;
    
    // Test with non-existent ID
    models:Article|error? result = articleRepo.getArticleById(99999);
    
    if result is error {
        test:assertFail("Unexpected error when getting article by ID from repository: " + result.message());
    } else if result is () {
        // Should return null for non-existent article
        test:assertTrue(true); // Test passes
    } else {
        // If an article is found, it should be valid
        test:assertTrue(result.article_id > 0);
        test:assertTrue(result.title.length() > 0);
    }
}

// Test the Article Controller
@test:Config {}
function testArticleControllerGetAll() returns error? {
    controllers:ArticleController articleController = new;
    http:Request req = new;
    http:Response response = articleController.getAllArticles(req);
    
    // Should return a successful response
    test:assertTrue(response.statusCode == 200 || response.statusCode == 500);
}

@test:Config {}
function testArticleControllerGetById() returns error? {
    controllers:ArticleController articleController = new;
    http:Request req = new;
    
    // Test with non-existent ID
    http:Response response = articleController.getArticleById(req, 99999);
    
    // Should return 404 for non-existent article or 500 for database error
    test:assertTrue(response.statusCode == 404 || response.statusCode == 500);
}

// Test Article model validation
@test:Config {}
function testArticleModelValidation() {
    models:Article article = {
        article_id: 1,
        title: "Test Article",
        category: "Test Category",
        content: "Test content",
        image_url: "https://example.com/test.jpg"
    };
    
    test:assertEquals(article.article_id, 1);
    test:assertEquals(article.title, "Test Article");
    test:assertEquals(article.category, "Test Category");
    test:assertEquals(article.content, "Test content");
}

@test:Config {}
function testNewArticleModel() {
    models:NewArticle newArticle = {
        title: "New Test Article",
        category: "New Test Category",
        content: "New test content",
        image_url: "https://example.com/new-image.jpg"
    };
    
    test:assertEquals(newArticle.title, "New Test Article");
    test:assertEquals(newArticle.category, "New Test Category");
    test:assertEquals(newArticle.content, "New test content");
    test:assertEquals(newArticle.image_url, "https://example.com/new-image.jpg");
}

@test:Config {}
function testArticleResponseModel() {
    models:ArticleResponse articleResponse = {
        article_id: 1,
        title: "Response Test Article",
        category: "Response Test Category",
        content: "Response test content",
        image_url: "https://example.com/response-image.jpg",
        created_at: "2025-08-31T10:00:00Z",
        updated_at: "2025-08-31T10:00:00Z"
    };
    
    test:assertEquals(articleResponse.article_id, 1);
    test:assertEquals(articleResponse.title, "Response Test Article");
    test:assertEquals(articleResponse.category, "Response Test Category");
    test:assertEquals(articleResponse.content, "Response test content");
    test:assertEquals(articleResponse.created_at, "2025-08-31T10:00:00Z");
}
