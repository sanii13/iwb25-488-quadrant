import ballerina/http;

@http:ServiceConfig {
    basePath: "/api/remedies"
}
service /remedies on new http:Listener(8080) {

    resource function get hello(http:Caller caller, http:Request req) returns error? {
        check caller->respond("Remedy endpoint working!");
    }
}
