import ballerina/test;

@test:Config {}
function testRemedyHello() {
    test:assertTrue(true, msg = "Dummy test case");
}
