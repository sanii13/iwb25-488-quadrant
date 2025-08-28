import ballerina/http;

service /api/remedies on new http:Listener(8080) {

    resource function get hello() returns string {
        return "Remedy endpoint working!";
    }
}
