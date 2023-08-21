//
//  KDDemoViewController.m
//  VCFrame
//
//  Created by marsxinwang on 2023/8/11.
//

#import "KDDemoViewController.h"
#import "SIPerson.h"
#import <WebKit/WebKit.h>
#import "KDCustomURLSchemeHandler.h"
#import <JavaScriptCore/JavaScriptCore.h>

@interface KDDemoViewController ()

//@property (nonatomic, strong) NSTimer *timer;

@end

@implementation KDDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.redColor;
    [self jsTest];
    
}

- (void)jsTest {
    JSContext *context = [[JSContext alloc] init];
    JSValue *value = [context evaluateScript:@"2 + 3"];
    NSLog(@"2 + 3 = %@", value);
}

- (void)setupWebViewButton {
    UIButton *button = [[UIButton alloc] init];
    [button setTitle:@"点击跳webview" forState:UIControlStateNormal];
    [button addTarget:self
               action:@selector(didClickButton)
     forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    button.frame = CGRectMake(50, 150, 200, 50);
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
    WKWebView *wk = [[WKWebView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-200) configuration:configuration];
    [self.view addSubview:wk];
    [wk loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://www.baidu.com"]]];

}

- (void)setupRunloopTest {
    [self runloopCombine];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self personDealloc];
    });
}

- (void)syn {
    @synchronized (nil) {
        NSLog(@"123");
    }
}

- (void)runloopCombine {
//    self.timer = [NSTimer scheduledTimerWithTimeInterval:1
//                                                 repeats:YES
//                                                   block:^(NSTimer * _Nonnull timer) {
//        NSLog(@"yyyy");
//    }];
    [self runloop];
    
}

- (void)personDealloc {
    // 内部有打印逻辑
    SIPerson * p = [[SIPerson alloc] init];
}

- (void)runloop {
    //1.创建监听者
    /*
     第一个参数:怎么分配存储空间
     第二个参数:要监听的状态 kCFRunLoopAllActivities 所有的状态
     第三个参数:时候持续监听
     第四个参数:优先级 总是传0
     第五个参数:当状态改变时候的回调
     */
    CFRunLoopObserverRef observer = CFRunLoopObserverCreateWithHandler(CFAllocatorGetDefault(), kCFRunLoopAllActivities, YES, 0, ^(CFRunLoopObserverRef observer, CFRunLoopActivity activity) {
        
        /*
         kCFRunLoopEntry = (1UL << 0),        即将进入runloop
         kCFRunLoopBeforeTimers = (1UL << 1), 即将处理timer事件
         kCFRunLoopBeforeSources = (1UL << 2),即将处理source事件
         kCFRunLoopBeforeWaiting = (1UL << 5),即将进入睡眠
         kCFRunLoopAfterWaiting = (1UL << 6), 被唤醒
         kCFRunLoopExit = (1UL << 7),         runloop退出
         kCFRunLoopAllActivities = 0x0FFFFFFFU
         */
        switch (activity) {
            case kCFRunLoopEntry:
                NSLog(@"1.即将进入runloop");
                break;
            case kCFRunLoopBeforeTimers:
                NSLog(@"2.即将处理timer事件");
                break;
            case kCFRunLoopBeforeSources:
                NSLog(@"3.即将处理source事件");
                break;
            case kCFRunLoopBeforeWaiting:
                NSLog(@"4.即将进入睡眠");
                break;
            case kCFRunLoopAfterWaiting:
                NSLog(@"5.被唤醒");
                break;
            case kCFRunLoopExit:
                NSLog(@"6.runloop退出");
                break;
                
            default:
                break;
        }
    });
    
    /*
     第一个参数:要监听哪个runloop
     第二个参数:观察者
     第三个参数:运行模式
     */
    CFRunLoopAddObserver(CFRunLoopGetCurrent(),observer, kCFRunLoopDefaultMode);
    
    //NSDefaultRunLoopMode == kCFRunLoopDefaultMode
    //NSRunLoopCommonModes == kCFRunLoopCommonModes
}

@end
