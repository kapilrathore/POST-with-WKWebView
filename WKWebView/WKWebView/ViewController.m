//
//  ViewController.m
//  WKWebView
//
//  Created by Kapil Rathore on 18/05/16.
//  Copyright © 2016 Kapil Rathore. All rights reserved.
//

#import "ViewController.h"

#define k_URL @"http://kapilrathore.github.io/"

@interface ViewController () <WKNavigationDelegate>
@property (strong, nonatomic) WKWebView *webView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
    WKUserContentController *controller = [[WKUserContentController alloc] init];
    
    [controller addScriptMessageHandler:self name:@"observe"];
    configuration.userContentController = controller;
    
    NSURL *jsbin = [NSURL URLWithString:k_URL];
    
    _webView = [[WKWebView alloc] initWithFrame:self.view.frame configuration:configuration];
    
    [_webView loadRequest:[NSURLRequest requestWithURL:jsbin]];
    [self.view addSubview:_webView];
    
    NSSet *websiteDataTypes
    = [NSSet setWithArray:@[
                            WKWebsiteDataTypeDiskCache,
                            //WKWebsiteDataTypeOfflineWebApplicationCache,
                            WKWebsiteDataTypeMemoryCache,
                            //WKWebsiteDataTypeLocalStorage,
                            //WKWebsiteDataTypeCookies,
                            //WKWebsiteDataTypeSessionStorage,
                            //WKWebsiteDataTypeIndexedDBDatabases,
                            //WKWebsiteDataTypeWebSQLDatabases
                            ]];
    //// All kinds of data
    //NSSet *websiteDataTypes = [WKWebsiteDataStore allWebsiteDataTypes];
    //// Date from
    NSDate *dateFrom = [NSDate dateWithTimeIntervalSince1970:0];
    //// Execute
    [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:websiteDataTypes modifiedSince:dateFrom completionHandler:^{
        // Done
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)userContentController:(WKUserContentController *)userContentController
      didReceiveScriptMessage:(WKScriptMessage *)message {
    
    if ([message.name isEqualToString:@"observe"]) {
        NSLog(@"Received event %@", message.body);
        NSString *version = [[UIDevice currentDevice] valueForKey:message.body];
        NSString *exec_template = @"set_headline(\"received: %@\");";
        NSString *exec_waiting = @"set_waiting(\"Done!\");";
        NSString *exec = [NSString stringWithFormat:exec_template, version];
        [_webView evaluateJavaScript:exec completionHandler:nil];
        [_webView evaluateJavaScript:exec_waiting completionHandler:nil];
        
        NSString *name = @"Kapil Rathore";
        NSString *postData = [NSString stringWithFormat: @"name: \"%@\"", name];
        NSString *urlString = @"http://putsreq.com/H4sHr7TS4FWKpdmw5XDZ";
        NSString *jscript = [NSString stringWithFormat:@"$.post(\"%@\",{%@},function(data){$(\"#proceed\").text(data)});", urlString, postData];
        [_webView evaluateJavaScript:jscript completionHandler:nil];
    }
}

@end