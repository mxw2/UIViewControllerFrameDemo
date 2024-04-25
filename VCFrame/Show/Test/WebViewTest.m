//
//  WebViewTest.m
//  VCFrame
//
//  Created by 马斯 on 2024/4/25.
//

#import "WebViewTest.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import <WebKit/WebKit.h>
#import <UIKit/UIKit.h>

@implementation WebViewTest

- (void)jsTest {
    JSContext *context = [[JSContext alloc] init];
    JSValue *value = [context evaluateScript:@"2 + 3"];
    NSLog(@"2 + 3 = %@", value);
}

- (void)setupWebViewButton {
//    UIButton *button = [[UIButton alloc] init];
//    [button setTitle:@"点击跳webview" forState:UIControlStateNormal];
//    [button addTarget:self
//               action:@selector(didClickButton)
//     forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:button];
//    button.frame = CGRectMake(50, 150, 200, 50);
}

- (void)didClickButton {
    WKWebViewConfiguration *configuration = [WKWebViewConfiguration new];
//    KDCustomURLSchemeHandler *handler = [KDCustomURLSchemeHandler new];
    
    //支持https和http的方法1  这个需要去hook +[WKwebview handlesURLScheme]的方法,可以去看WKWebView+Custome类的实现
//    [configuration setURLSchemeHandler:handler forURLScheme:@"https"];
//    [configuration setURLSchemeHandler:handler forURLScheme:@"http"];
    
    //hook系统的方法2   xcode11可能会运行直接崩溃,因为用到了私有变量,xcode会检测，但是xcode10没问题，应该是xcode做了拦截，不影响使用
//    NSMutableDictionary *handlers = [configuration valueForKey:@"_urlSchemeHandlers"];
//    handlers[@"https"] = handler;//修改handler,将HTTP和HTTPS也一起拦截
//    handlers[@"http"] = handler;
    
//    WKWebView *wk = [[WKWebView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-200) configuration:configuration];
//    [self.view addSubview:wk];
//    [wk loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://www.baidu.com"]]];

}

@end
