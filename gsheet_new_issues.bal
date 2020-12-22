import ballerina/config;
import ballerina/http;
import ballerina/oauth2;
import ballerina/websub;
import ballerinax/github.webhook as webhook;
import ballerinax/googleapis_sheets as sheets;
import ballerina/log;
import ballerina/io;

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
    target: [webhook:HUB, "https://github.com/shanan/check2/events/*.json"],
    hubClientConfig: {
        auth: {
            authHandler: githubOAuth2Handler
        }
    },
    callback: config:getAsString("CALLBACK_URL")
}
service websub:SubscriberService /payload on githubWebhookListener {
    // remote function onIssuesOpened(websub:Notification notification, webhook:IssuesEvent event) {
    //     (string|int)[] values = [event.issue.number, event.issue.title, event.issue.user.login, event.issue.created_at];
    //     sheets:Spreadsheet|error spreadsheet = spreadsheetClient->openSpreadsheetById(config:getAsString("SPREADSHEET_ID"));
    //     if (spreadsheet is sheets:Spreadsheet) {
    //         sheets:Sheet|error sheet = spreadsheet.getSheetByName(config:getAsString("SHEET_NAME"));
    //         if (sheet is sheets:Sheet) {
    //             error? appendResult = sheet->appendRow(values);            
    //         }
    //     }
    // }

    //  remote function onIssueCommentCreated(websub:Notification notification, webhook:IssueCommentEvent event) {
    //     log:print("onisscreated");
    // }

    remote function onPing(websub:Notification notification, webhook:PingEvent event) {
        log:print("onPing");
    }

    remote function onFork(websub:Notification notification, webhook:ForkEvent event) {
        log:print("onFork");
    }

    remote function onPush(websub:Notification notification, webhook:PushEvent event) {
        log:print("onPush");
    }

    remote function onRelease(websub:Notification notification, webhook:ReleaseEvent event) {
        log:print("onRelease");
    }

    remote function onWatch(websub:Notification notification, webhook:WatchEvent event) {
        log:print("onWatch");
    }

    remote function onIssuesAssigned(websub:Notification notification, webhook:IssuesEvent event) {
        log:print("onIssuesAssigned");
    }

    remote function onIssuesUnassigned(websub:Notification notification, webhook:IssuesEvent event) {
        log:print("onIssuesUnassigned");
    }

    remote function onIssuesLabeled(websub:Notification notification, webhook:IssuesEvent event) {
        log:print("onIssuesLabeled");
    }
    remote function onIssuesUnlabeled(websub:Notification notification, webhook:IssuesEvent event) {
        log:print("onIssuesUnlabeled");
    }

    remote function onIssuesOpened(websub:Notification notification, webhook:IssuesEvent event) {
        log:print("onIssuesOpened");
    }

    remote function onIssuesEdited(websub:Notification notification, webhook:IssuesEvent event) {
        log:print("onissedited");
    }

    remote function onIssuesMilestoned(websub:Notification notification, webhook:IssuesEvent event) {
        log:print("onIssuesMilestoned");
    }

    remote function onIssuesDemilestoned(websub:Notification notification, webhook:IssuesEvent event) {
        log:print("onIssuesDemilestoned");
    }

    remote function onIssuesClosed(websub:Notification notification, webhook:IssuesEvent event) {
        log:print("onIssuesClosed");
    }

    remote function onIssuesReopened(websub:Notification notification, webhook:IssuesEvent event) {
        log:print("onIssuesReopened");
    }

    remote function onLabelCreated(websub:Notification notification, webhook:LabelEvent event) {
        log:print("onLabelCreated");
    }

    remote function onLabelEdited(websub:Notification notification, webhook:LabelEvent event) {
        log:print("onLabelEdited");
    }

    remote function onLabelDeleted(websub:Notification notification, webhook:LabelEvent event) {
        log:print("onLabelDeleted");
    }

    remote function onMilestoneCreated(websub:Notification notification, webhook:MilestoneEvent event) {
        log:print("onissedited");
    }

    remote function onMilestoneClosed(websub:Notification notification, webhook:MilestoneEvent event) {
        log:print("onMilestoneClosed");
    }

    remote function onMilestoneOpened(websub:Notification notification, webhook:MilestoneEvent event) {
        log:print("onMilestoneOpened");
    }

    remote function onMilestoneEdited(websub:Notification notification, webhook:MilestoneEvent event) {
        log:print("onMilestoneEdited");
    }

    remote function onMilestoneDeleted(websub:Notification notification, webhook:MilestoneEvent event) {
        log:print("onMilestoneDeleted");
    }

    remote function onPullRequestAssigned(websub:Notification notification, webhook:PullRequestEvent event) {
        log:print("onPullRequestOpened");
    }

    remote function onPullRequestUnassigned(websub:Notification notification, webhook:PullRequestEvent event) {
     log:print("onPullRequestUnassigned");
    }

    remote function onPullRequestReviewRequested(websub:Notification notification, webhook:PullRequestEvent event) {
     log:print("onPullRequestReviewRequested");
    }

    remote function onPullRequestReviewRequestRemoved(websub:Notification notification, webhook:PullRequestEvent event) {
        log:print("onPullRequestReviewRequestRemoved");
    }

    remote function onPullRequestLabeled(websub:Notification notification, webhook:PullRequestEvent event) {
     log:print("onPullRequestLabeled");
    }

    remote function onPullRequestUnlabeled(websub:Notification notification, webhook:PullRequestEvent event) {
      log:print("onPullRequestUnlabeled");
    }

    remote function onPullRequestOpened(websub:Notification notification, webhook:PullRequestEvent event) {
        log:print("onPullRequestOpened");
    }

    remote function onPullRequestEdited(websub:Notification notification, webhook:PullRequestEvent event) {
        log:print("onPullRequestEdited");
    }

    remote function onPullRequestClosed(websub:Notification notification, webhook:PullRequestEvent event) {
        log:print("onPullRequestClosed");
    }

    remote function onPullRequestReopened(websub:Notification notification, webhook:PullRequestEvent event) {
        log:print("onPullRequestReopened");
    }

    remote function onPullRequestReviewSubmitted(websub:Notification notification, webhook:PullRequestReviewEvent event) {
        log:print("onPullRequestReviewSubmitted");
    }

    remote function onPullRequestReviewEdited(websub:Notification notification, webhook:PullRequestReviewEvent event) {
        log:print("onPullRequestReviewEdited");
    }

    remote function onPullRequestReviewDismissed(websub:Notification notification, webhook:PullRequestReviewEvent event) {
        log:print("onPullRequestReviewDismissed");
    }

    remote function onPullRequestReviewCommentCreated(websub:Notification notification, webhook:PullRequestReviewCommentEvent event) {
        log:print("onPullRequestReviewCommentCreated");
    }

    remote function onPullRequestReviewCommentEdited(websub:Notification notification, webhook:PullRequestReviewCommentEvent event) {
        log:print("onPullRequestReviewCommentEdited");
    }

    remote function onPullRequestReviewCommentDeleted(websub:Notification notification, webhook:PullRequestReviewCommentEvent event) {
        log:print("onPullRequestReviewCommentDeleted");
    }
  
}
