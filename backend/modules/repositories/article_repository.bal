import ballerina/sql;
import ballerina/log;
import backend.database;
import backend.models;

// Article Repository for database operations
public class ArticleRepository {

    // Get all articles
    public function getAllArticles() returns models:Article[]|error {
        sql:ParameterizedQuery query = `
            SELECT article_id, title, category, content, image_url, created_at, updated_at 
            FROM articles 
            ORDER BY created_at DESC
        `;

        stream<models:Article, sql:Error?> resultStream = database:dbClient->query(query);
        models:Article[] articles = [];

        check from models:Article article in resultStream
            do {
                articles.push(article);
            };

        check resultStream.close();
        return articles;
    }

    // Get article by ID
    public function getArticleById(int articleId) returns models:Article|error? {
        sql:ParameterizedQuery query = `
            SELECT article_id, title, category, content, image_url, created_at, updated_at 
            FROM articles 
            WHERE article_id = ${articleId}
        `;

        models:Article|sql:Error result = database:dbClient->queryRow(query);
        
        if result is sql:NoRowsError {
            return ();
        }
        
        if result is sql:Error {
            log:printError("Error fetching article by ID", 'error = result);
            return result;
        }
        
        return result;
    }

    // Create a new article
    public function createArticle(models:NewArticle newArticle) returns models:Article|error {
        sql:ParameterizedQuery insertQuery = `
            INSERT INTO articles (title, category, content, image_url)
            VALUES (${newArticle.title}, ${newArticle.category}, ${newArticle.content}, 
                   ${newArticle.image_url})
            RETURNING article_id, title, category, content, image_url, created_at, updated_at
        `;

        models:Article|sql:Error result = database:dbClient->queryRow(insertQuery);
        
        if result is sql:Error {
            log:printError("Error creating article", 'error = result);
            return result;
        }
        
        return result;
    }

    // Update an existing article
    public function updateArticle(int articleId, models:NewArticle updatedArticle) returns models:Article|error? {
        sql:ParameterizedQuery updateQuery = `
            UPDATE articles 
            SET title = ${updatedArticle.title}, 
                category = ${updatedArticle.category}, 
                content = ${updatedArticle.content}, 
                image_url = ${updatedArticle.image_url}, 
                updated_at = CURRENT_TIMESTAMP
            WHERE article_id = ${articleId}
            RETURNING article_id, title, category, content, image_url, created_at, updated_at
        `;

        models:Article|sql:Error result = database:dbClient->queryRow(updateQuery);
        
        if result is sql:NoRowsError {
            return ();
        }
        
        if result is sql:Error {
            log:printError("Error updating article", 'error = result);
            return result;
        }
        
        return result;
    }

    // Delete an article
    public function deleteArticle(int articleId) returns boolean|error {
        sql:ParameterizedQuery deleteQuery = `
            DELETE FROM articles WHERE article_id = ${articleId}
        `;

        sql:ExecutionResult|sql:Error result = database:dbClient->execute(deleteQuery);
        
        if result is sql:Error {
            log:printError("Error deleting article", 'error = result);
            return result;
        }

        return result.affectedRowCount > 0;
    }
}
