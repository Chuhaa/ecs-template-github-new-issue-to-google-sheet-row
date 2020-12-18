import ballerina/config;
import ballerina/http;
import ballerina/oauth2;
import ballerina/websub;
import ballerinax/github.webhook as webhook;
import ballerinax/googleapis_sheets as sheets;

oauth2:OutboundOAuth2Provider githubOAuth2Provider = new ({
    accessToken: config:getAsString("GH_ACCESS_TOKEN"),
    refreshConfig: {
        clientId: config:getAsString("GH_CLIENT_ID"),
        clientSecret: config:getAsString("GH_CLIENT_SECRET"),
        refreshUrl: config:getAsString("GH_REFRESH_URL"),
        refreshToken: config:getAsString("GH_REFRESH_TOKEN")
    }
});
http:BearerAuthHandler githubOAuth2Handler = new (githubOAuth2Provider);

listener webhook:Listener githubWebhookListener = new (4567);

sheets:SpreadsheetConfiguration spreadsheetConfig = {
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

sheets:Client spreadsheetClient = new (spreadsheetConfig);

@websub:SubscriberServiceConfig {
    subscribeOnStartUp: true,
    target: [webhook:HUB, "https://github.com/" + config:getAsString("GH_USERNAME") + "/" + config:getAsString("GH_REPO_NAME") + "/events/*.json"],
    hubClientConfig: {
        auth: {
            authHandler: githubOAuth2Handler
        }
    },
    callback: config:getAsString("CALLBACK_URL")
}
service websub:SubscriberService /payload on githubWebhookListener {
    remote function onIssuesOpened(websub:Notification notification, webhook:IssuesEvent event) {
        (string|int)[] values = [event.issue.number, event.issue.title, event.issue.user.login, event.issue.created_at];
        sheets:Spreadsheet|error spreadsheet = spreadsheetClient->openSpreadsheetById(config:getAsString("SPREADSHEET_ID"));
        if (spreadsheet is sheets:Spreadsheet) {
            sheets:Sheet|error sheet = spreadsheet.getSheetByName(config:getAsString("SHEET_NAME"));
            if (sheet is sheets:Sheet) {
                error? appendResult = sheet->appendRow(values);            
            }
        }
    }
}
