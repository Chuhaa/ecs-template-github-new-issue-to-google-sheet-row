import ballerina/config;
import ballerina/http;
import ballerina/io;
import ballerina/oauth2;
import ballerina/websub;
import ballerinax/github.webhook;
import ballerinax/googleapis.sheets4;

oauth2:OutboundOAuth2Provider githubOAuth2Provider = new ({
    accessToken: config:getAsString("GH_ACCESS_TOKEN")
});
http:BearerAuthHandler githubOAuth2Handler = new (githubOAuth2Provider);

listener webhook:Listener githubWebhookListener = new (4567);

sheets4:SpreadsheetConfiguration spreadsheetConfig = {
    oauth2Config: {
        accessToken: config:getAsString("ACCESS_TOKEN"),
        refreshConfig: {
            clientId: config:getAsString("CLIENT_ID"),
            clientSecret: config:getAsString("CLIENT_SECRET"),
            refreshUrl: config:getAsString("REFRESH_URL"),
            refreshToken: config:getAsString("REFRESH_TOKEN")
        }
    }
};

sheets4:Client spreadsheetClient = new (spreadsheetConfig);

@websub:SubscriberServiceConfig {
    path: "/payload",
    subscribeOnStartUp: true,
    target: [webhook:HUB, "https://github.com/"+config:getAsString("GH_USERNAME")+"/"+config:getAsString("GH_REPO_NAME")+"/events/*.json"],
    hubClientConfig: {
        auth: {
            authHandler: githubOAuth2Handler
        }
    },
    callback: config:getAsString("CALLBACK_URL")
}
service githubWebhookSubscriber on githubWebhookListener {
    resource function onIssuesOpened(websub:Notification notification, webhook:IssuesEvent event) {
        io:println("[onIssuesOpened] Issue ID: ", event.issue.number);
        (string|int)[] values = [event.issue.number, event.issue.title, event.issue.user.login, event.issue.created_at];
        sheets4:Spreadsheet|error spreadsheet = spreadsheetClient->openSpreadsheetById(config:getAsString("SPREADSHEET_ID"));
        if (spreadsheet is sheets4:Spreadsheet) {
            sheets4:Sheet|error sheet = spreadsheet.getSheetByName(config:getAsString("SHEET_NAME"));
            if (sheet is sheets4:Sheet) {
                error? appendResult = sheet->appendRow(values);            
            }
        }
    }
}
