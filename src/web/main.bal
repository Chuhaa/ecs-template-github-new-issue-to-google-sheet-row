import ballerina/http;
 
listener http:Listener webhookListener = new (4567);

@http:ServiceConfig {
    basePath: "/payload"
}
service githubWebhookListener on webhookListener {

    @http:ResourceConfig {
        methods: ["POST"],
        path: "/"
    }
    resource function onEvent(http:Caller caller, http:Request req) {
       //handle webhook request
    }


    function handleIssueCreated(http:Request req) {
        //issue Handling
    }

    function handleIssueClosed(http:Request req) {
        //issue Handling
    }

    function handleIssueModified(http:Request req) {
        //issue Handling
    }

    function handleIssueAssigned(http:Request req) {
        //issue Handling
    }
}
