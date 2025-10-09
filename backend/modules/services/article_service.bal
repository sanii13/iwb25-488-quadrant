import ballerina/time;
import backend.models;
import backend.repositories;

// Article Service for business logic
public class ArticleService {
    private repositories:ArticleRepository articleRepository;

    public function init() {
        self.articleRepository = new repositories:ArticleRepository();
    }

    // Get all articles
    public function getAllArticles() returns models:ArticleResponse[]|error {
        models:Article[]|error articles = self.articleRepository.getAllArticles();
        
        if articles is error {
            return articles;
        }
        
        models:ArticleResponse[] articleResponses = [];
        
        foreach models:Article article in articles {
            articleResponses.push(self.mapToResponse(article));
        }
        
        return articleResponses;
    }

    // Get article by ID
    public function getArticleById(int articleId) returns models:ArticleResponse|models:ErrorResponse|error {
        models:Article|error? result = self.articleRepository.getArticleById(articleId);
        
        if result is error {
            return result;
        }
        
        if result is () {
            return {
                message: "Article not found",
                details: string `Article with ID ${articleId} does not exist`
            };
        }
        
        return self.mapToResponse(result);
    }

    // Create a new article
    public function createArticle(models:NewArticle newArticle) returns models:ArticleResponse|error {
        models:Article|error result = self.articleRepository.createArticle(newArticle);
        
        if result is error {
            return result;
        }
        
        return self.mapToResponse(result);
    }

    // Update an existing article
    public function updateArticle(int articleId, models:NewArticle updatedArticle) returns models:ArticleResponse|models:ErrorResponse|error {
        models:Article|error? result = self.articleRepository.updateArticle(articleId, updatedArticle);
        
        if result is error {
            return result;
        }
        
        if result is () {
            return {
                message: "Article not found",
                details: string `Article with ID ${articleId} does not exist`
            };
        }
        
        return self.mapToResponse(result);
    }

    // Delete an article
    public function deleteArticle(int articleId) returns boolean|models:ErrorResponse|error {
        boolean|error result = self.articleRepository.deleteArticle(articleId);
        
        if result is error {
            return result;
        }
        
        if result == false {
            return {
                message: "Article not found",
                details: string `Article with ID ${articleId} does not exist`
            };
        }
        
        return true;
    }

    // Helper function to map Article to ArticleResponse
    private function mapToResponse(models:Article article) returns models:ArticleResponse {
        string? createdAtStr = article.created_at is time:Utc ? time:utcToString(<time:Utc>article.created_at) : ();
        string? updatedAtStr = article.updated_at is time:Utc ? time:utcToString(<time:Utc>article.updated_at) : ();
        
        return {
            article_id: article.article_id,
            title: article.title,
            category: article.category,
            content: article.content,
            image_url: article.image_url,
            created_at: createdAtStr,
            updated_at: updatedAtStr
        };
    }
}
