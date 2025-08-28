import ballerina/http;
import ayurconnect_backend.controllers.remedy_controller;

public function main() returns error? {
    // Attach Remedy Controller service
    check new http:Listener(8080).attach(remedy_controller:service);
}
