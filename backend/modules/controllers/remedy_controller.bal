import ballerina/http;

public service object {} remedyService = @http:ServiceConfig {
    basePath: "/api/remedies"
} service object {

    resource function get hello() returns string {
        return "Remedy endpoint working!";
    }
};
