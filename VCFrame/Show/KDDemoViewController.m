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
#import "WDButton.h"
#import "KDThreeViewController.h"
#import "KDNavigationController.h"
#import "UIWindow+BBACurrentVC.h"
// KDNoNavigationBarViewController

@interface KDDemoViewController ()

//@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) dispatch_queue_t queue;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) UIButton *blueButton;

@end

@implementation KDDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.cyanColor;
//    [self gcdTestSync];
    // KVO打印的问题
//    int result = [self getNums:8 m:8];
//    NSLog(@"---result = %d", result);
//    [self taggedPointerDemo];
    
//    [self addB];
    
    // [self testHunHeSerices];
    
    // 测试出现整个AI打电话效果
    [self setupButton];
}

- (void)setupButton {
    // 创建一个按钮
    self.blueButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.blueButton.backgroundColor = [UIColor blueColor];
    self.blueButton.frame = CGRectMake(100, 100, 100, 50); // 设置按钮的位置和大小

    // 添加点击事件
    [self.blueButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];

    // 将按钮添加到视图上
    [self.view addSubview:self.blueButton];
}

- (void)buttonClicked:(UIButton *)sender {
    UIViewController *fromVC = [UIWindow bba_topViewController];
    KDThreeViewController *threeController = [[KDThreeViewController alloc] init];
    KDNavigationController *navigationController = [[KDNavigationController alloc] initWithRootViewController:threeController];
    navigationController.modalPresentationStyle = UIModalPresentationOverFullScreen;
    [fromVC presentViewController:navigationController animated:NO completion:nil];
}

- (void)testConcurrent {
    // 打印结果
//     1
//     100
//     2-线程:<NSThread: 0x6000035880c0>{number = 4, name = (null)}
//     4-线程:<NSThread: 0x6000035c5640>{number = 5, name = (null)}
//     3-线程:<NSThread: 0x6000035946c0>{number = 7, name = (null)}
//     5-线程:<NSThread: 0x6000035c5180>{number = 3, name = (null)}
    
    // 因为是异步执行，所以内部具体是多少，也是随机的哈
    NSLog(@"1");
    dispatch_queue_t queue = dispatch_queue_create("com.test.gcd", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(queue, ^{
        NSLog(@"2-线程:%@", NSThread.currentThread); // 这里是子线程哈，切记
        // 这里没有开启runloop，所以无法打印哈
        [self performSelector:@selector(log6)
                   withObject:nil
                   afterDelay:0];
        // 这里是是异步，所以没有问题哈，同步就挂了
    });
    
    dispatch_async(queue, ^{
        NSLog(@"3-线程:%@", NSThread.currentThread); // 这里是子线程哈，切记
    });
    
    dispatch_async(queue, ^{
        NSLog(@"4-线程:%@", NSThread.currentThread); // 这里是【主】线程哈，切记
    });
    
    dispatch_async(queue, ^{
        NSLog(@"5-线程:%@", NSThread.currentThread); // 这里是子线程哈，切记
    });
    
    NSLog(@"100");
}

// 【过去没有接触过这样的哈，注意！！！】
- (void)testHunHeSerices {
//     1
//     4-线程:<_NSMainThread: 0x6000036c4240>{number = 1, name = main}
//     2-线程:<NSThread: 0x6000036c2a00>{number = 3, name = (null)}
//     3-线程:<NSThread: 0x600003684c80>{number = 5, name = (null)}
//     100
//     5-线程:<NSThread: 0x60000368ea40>{number = 6, name = (null)}
    
    // 打印了，非常随机，除了1是稳定的，其他的都是随机的，同步打印4是主线程
        NSLog(@"1");
        dispatch_queue_t queue = dispatch_queue_create("com.test.gcd", DISPATCH_QUEUE_CONCURRENT);
        dispatch_async(queue, ^{
            NSLog(@"2-线程:%@", NSThread.currentThread); // 这里是子线程哈，切记
            // 这里没有开启runloop，所以无法打印哈
            [self performSelector:@selector(log6)
                       withObject:nil
                       afterDelay:0];
            // 这里是是异步，所以没有问题哈，同步就挂了
        });
        
        dispatch_async(queue, ^{
            NSLog(@"3-线程:%@", NSThread.currentThread); // 这里是子线程哈，切记
        });
        // 4永远在100之前哈
        dispatch_sync(queue, ^{
            // 临时添加等待几秒后，会先执行1 100 2 5 3 4（最后）
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                    NSLog(@"4-线程:%@", NSThread.currentThread); // 这里是【主】线程哈，切记
//            });
            
            NSLog(@"4-线程:%@", NSThread.currentThread); // 这里是【主】线程哈，切记
        });
        
        dispatch_async(queue, ^{
            NSLog(@"5-线程:%@", NSThread.currentThread); // 这里是子线程哈，切记
        });
        
        NSLog(@"100");
}

- (void)taggedPointerDemo {
    self.queue = dispatch_queue_create("com.lj.com", DISPATCH_QUEUE_CONCURRENT);
    for (int i = 0; i < 10000; i++) {
        dispatch_async(self.queue, ^{
            self.name = [NSString stringWithFormat:@"ld"];
            NSLog(@"name = %@", self.name);
        });
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    for (int i = 0; i < 10000; i++) {
//        dispatch_async(self.queue, ^{
//            // lg_念念不忘，就在堆区，字符串太复杂了，所以就在堆；
//            // abc很简单，优化后是NSTaggedPointerString类型，是常量区
//            self.name = [NSString stringWithFormat:@"abc"];
//            NSLog(@"name = %@", self.name);
//        });
//    }
}

// 测试1：只有touchStart三件套情况，就打印他们
// 测试2：touch三件套，外加addTarget:action: touch起作用
// 测试3：touch & button.addTarget:action & b.addTapGeust，结果会打印touch & tap事件
- (void)addB {
    WDButton *b = [[WDButton alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
//    [b addTarget:self action:@selector(didB) forControlEvents:UIControlEventTouchUpInside];
    b.backgroundColor = UIColor.yellowColor;
    [self.view addSubview:b];
    
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
//    [tap addTarget:self action:@selector(clickTapEvent)];
//    [b addGestureRecognizer:tap];
}

- (void)clickTapEvent {
    NSLog(@"clickTapEvent");
}

- (void)didB {
    NSLog(@"didClickB");
}

// 不行哈
- (void)mockAMethodWithObejct:(NSString *)object {
    NSLog(@"mockAMethodWithObejct:NSString");
}

//- (void)mockAMethodWithObejct:(NSObject *)object {
//    NSLog(@"mockAMethodWithObejct:NSObject");
//}

// 动态规划，递归函数
- (int)getNums:(int)n m:(int)m {
    // 递归函数结束条件
    if( n ==0 || m == 0){
        return 1;
    } else {
        return [self getNums:(n - 1) m:m] + [self getNums:n m:(m -1)];
    }
}

- (void)gcdTestAynac {
    // 打印结果
    // 1 5 2（子线程） 4（子线程） 3（子线程）
    NSLog(@"1");
    dispatch_queue_t queue = dispatch_queue_create("com.test.gcd", DISPATCH_QUEUE_SERIAL);
    dispatch_async(queue, ^{
        NSLog(@"2-线程:%@", NSThread.currentThread); // 这里是子线程哈，切记
        // 这里没有开启runloop，所以无法打印哈
        [self performSelector:@selector(log6)
                   withObject:nil
                   afterDelay:0];
        // 这里是是异步，所以没有问题哈，同步就挂了
        dispatch_async(queue, ^{
            NSLog(@"3-线程:%@", NSThread.currentThread);
        });
        NSLog(@"4-线程:%@", NSThread.currentThread);
    });
    NSLog(@"5");
}

- (void)gcdTestSync {
    // 打印结果
    // 1 5 2（子线程） 挂掉
    NSLog(@"1");
    dispatch_queue_t queue = dispatch_queue_create("com.test.gcd", DISPATCH_QUEUE_SERIAL);
    dispatch_async(queue, ^{
        NSLog(@"2-线程:%@", NSThread.currentThread); // 这里是子线程哈，切记
        // 这里没有开启runloop，所以无法打印哈
        [self performSelector:@selector(log6)
                   withObject:nil
                   afterDelay:0];
        // 这里是是异步，所以没有问题哈，同步就挂了(死锁)
        dispatch_sync(queue, ^{
            NSLog(@"3-线程:%@", NSThread.currentThread);
        });
        NSLog(@"4-线程:%@", NSThread.currentThread);
    });
    NSLog(@"5");
}

// 给gcd用的，不要删除哈
- (void)log6 {
    NSLog(@"6");
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
//    SIPerson * p = [[SIPerson alloc] init];
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
