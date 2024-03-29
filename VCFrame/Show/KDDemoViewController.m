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
#import "WXCusterBlockObject.h"

@interface KDDemoViewController ()

@property (nonatomic, strong) SIPerson *person;
@property (nonatomic, strong) dispatch_queue_t queue;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) NSMutableDictionary *params;

@end

extern void _objc_autoreleasePoolPrint(void);

@implementation KDDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.redColor;
    
}

- (void)mock {
    dispatch_queue_t queue = dispatch_queue_create("com.test.gcd.serial",
                                                   DISPATCH_QUEUE_SERIAL);
    NSLog(@"cur theard before = %@", NSThread.currentThread);
    __block __weak SIPerson *weakPerson = nil;
    dispatch_async(queue, ^{
        NSLog(@"cur theard = %@", NSThread.currentThread);
        SIPerson *p = [[SIPerson alloc] init];
        weakPerson = p;
        _objc_autoreleasePoolPrint();
    });
    NSLog(@"weakPerson = %@", weakPerson);
    NSThread *t = [[NSThread alloc] initWithTarget:self
                                          selector:@selector(useThread)
                                            object:nil];
    [t start];
    [[WXCusterBlockObject new] run];
}

- (void)hightligthText {
    NSMutableString *str = [NSMutableString stringWithString:@"这是我的ppt\1234的🚗大纲👌😋😪，使用了ppt大"];
    [str replaceOccurrencesOfString:@"\1234" withString:@"----" options:NSLiteralSearch range:NSMakeRange(0, [str length])];
    NSLog(@"str = %@", str);
}

// 给定一个window对象，找到这个window上所有class类型为TargetView的 view实例
- (NSArray *)findAllTargetViewClass:(UIView *)view {
    if (!view) {
        return nil;
    }
    
    NSMutableArray<UIView *> *targetViews = [NSMutableArray array];
    for (UIView *subview in [view subviews]) {
        if ([subview isKindOfClass:[WDButton class]]) {
            [targetViews addObject:subview];
        }
        
        NSArray *tempArray = [self findAllTargetViewClass:subview];
        if (tempArray.count > 0) {
            [targetViews addObjectsFromArray:tempArray];
        }
    }

    return targetViews;
}

- (void)useThread {
    NSLog(@"cur theard = %@", NSThread.currentThread);
    __weak SIPerson *weakPerson = nil;
    {
        SIPerson *p = [[SIPerson alloc] init];
        weakPerson = p;
        NSLog(@"p = %@, weak.p = %@", p, weakPerson);
    }
    NSLog(@"weakPerson = %@", weakPerson);
}

- (void)test10 {
    dispatch_queue_t queue = dispatch_queue_create("com.test.gcd.serial", DISPATCH_QUEUE_SERIAL);
        dispatch_async(queue, ^{
            NSLog(@"logCCCC");
            // 这里也会死锁哈
            dispatch_sync(queue, ^{
                NSLog(@"logAAAA");
            });
        });
}

- (void)manyNotification {
    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(recieveN)
                                               name:@"asd"
                                             object:nil];
    
    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(recieveN)
                                               name:@"asd"
                                             object:nil];
    
    [self manyTimeKVO];
    
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 100, 40, 40)];
    button.backgroundColor = UIColor.greenColor;
    [self.view addSubview:button];
    button.opaque = YES;
    [button addTarget:self
               action:@selector(changeName)
     forControlEvents:UIControlEventTouchUpInside];
}

- (void)recieveN {
    NSLog(@"444");
}

- (void)dealloc {
    NSLog(@"demo view controller dealloc");
}

- (void)manyTimeKVO {
    SIPerson *p = [[SIPerson alloc] init];
    p.name = @"1";
    // 1.KVO可以添加多次，并且调用多次
    // 2.只add，不remove，会怎么样
    // chatgpt: 在iOS中使用KVO（Key-Value Observing）时，如果你没有手动移除观察者，
    // 通常不会导致野指针或内存泄漏问题。
    // KVO机制会在观察对象被销毁时自动将观察者移除，
    // 因此在大多数情况下，你不需要担心这个问题。
    // 3.remove多次会crash哈
    [p addObserver:self
                  forKeyPath:@"name"
                     options:NSKeyValueObservingOptionNew
                     context:nil];
    [p addObserver:self
                  forKeyPath:@"name"
                     options:NSKeyValueObservingOptionNew
                     context:nil];
    self.person = p;
}

- (void)changeName {
//    self.person.name = @"2";
    [NSNotificationCenter.defaultCenter postNotificationName:@"asd" object:nil];
//    [self.person removeObserver:self forKeyPath:@"name"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSKeyValueChangeKey,id> *)change
                       context:(void *)context {
    NSLog(@"obj = %@", change[NSKeyValueChangeNewKey]);
}

- (void)test6 {
    
//    [self test5];
    
    // 打印是1哈
//    __weak id m = nil;
    @autoreleasepool {
//        id obj = [SIPerson person]; // 没有加入自动释放池中哈
//        m = obj;
//        NSLog(@"retain  count = %ld\n",CFGetRetainCount((__bridge  CFTypeRef)obj));
        // 出去自动释放池的范围就释放掉了哈，立刻
//        NSLog(@"m in = %@", m);
//        id obj2 = [NSMutableSet set]; // 加入到自动释放中，内部做了autoreleasepool
    }
    // 这里m已经值为空，说明对象已经在自动释放池作用域结束的时候
    // 已经释放了哈，但是没有放到自动释放池中，因为没有放到自动释放池的操作
//    NSLog(@"m out = %@", m);
    // 调用下面的就crash
    // NSLog(@"m retain  count = %ld\n",CFGetRetainCount((__bridge  CFTypeRef)m));
}

// 测试：并发队列中，异步任务中在添加一个同步任务试试哈
// 一切正常哈
- (void)test5 {
//    开始
//    结束
//    1-线程:<NSThread: 0x6000027a9e80>{number = 7, name = (null)}
//    2-线程:<NSThread: 0x6000027a9e80>{number = 7, name = (null)}
    NSLog(@"开始");
    dispatch_queue_t queue = dispatch_queue_create("com.test.gcd", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(queue, ^{
        NSLog(@"1-线程:%@", NSThread.currentThread);
        // 这里是同步操作，放到并发队列中，没事哈
        dispatch_sync(queue, ^{
            NSLog(@"2-线程:%@", NSThread.currentThread);
        });
    });
    dispatch_async(queue, ^{
        NSLog(@"3-线程:%@", NSThread.currentThread);
    });
    NSLog(@"结束");
}

- (void)test4 {
//    [37435:1419522] 开始
//    [37435:1419522] 结束 // 这里我还是挺意外的，哈哈哈
//    [37435:1419714] 2-线程:<NSThread: 0x600003da5b40>{number = 6, name = (null)}
//    [37435:1419718] 1-线程:<NSThread: 0x600003de1340>{number = 5, name = (null)}
//    [37435:1419719] 3-线程:<NSThread: 0x600003de1380>{number = 3, name = (null)}
//    [这里做了栅栏函数哈] 4-线程:<NSThread: 0x600003de1340>{number = 5, name = (null)}
//    [37435:1419718] 5-线程:<NSThread: 0x600003de1340>{number = 5, name = (null)}
    NSLog(@"开始");
    dispatch_queue_t queue = dispatch_queue_create("com.test.gcd", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(queue, ^{
        NSLog(@"1-线程:%@", NSThread.currentThread);
    });
    dispatch_async(queue, ^{
        NSLog(@"2-线程:%@", NSThread.currentThread);
    });
    dispatch_sync(queue, ^{
        NSLog(@"3-线程:%@", NSThread.currentThread);
    });
    dispatch_barrier_async(queue, ^{
        NSLog(@"4-dispatch_barrier_async-线程:%@", NSThread.currentThread);
    });
    dispatch_async(queue, ^{
        NSLog(@"5-线程:%@", NSThread.currentThread);
    });
    // 因为这里没有子线程的sync方法，所以会立刻打印”结束“，在去打印block内部的
    NSLog(@"结束");
}

- (void)test3 {
    
    NSLog(@"开始");
    dispatch_queue_t queue = dispatch_queue_create("com.test.gcd", DISPATCH_QUEUE_SERIAL);
    dispatch_async(queue, ^{
        [self sleep5:@"a"];
       NSLog(@"1-线程:%@", NSThread.currentThread);
    });
    dispatch_async(queue, ^{
        [self sleep5:@"b"];
       NSLog(@"2-线程:%@", NSThread.currentThread);
    });
    
    [self sleep5:@"c"];
}

- (void)sleep5:(NSString *)str {
    sleep(2);
    NSLog(@"xxx from %@", str);
}

- (void)oneAyncAndOneSaync {
    NSLog(@"开始");
    dispatch_queue_t queue = dispatch_queue_create("com.test.gcd", DISPATCH_QUEUE_SERIAL);
    dispatch_async(queue, ^{
        [self sleep5:@"a"];
       NSLog(@"1-线程:%@", NSThread.currentThread);
    });
    dispatch_sync(queue, ^{
        [self sleep5:@"b"];
       NSLog(@"2-线程:%@", NSThread.currentThread);
    });
    [self sleep5:@"c"];

}

- (void)null {
    __weak NSMutableArray *temp = nil;
    @autoreleasepool {
        NSMutableArray *array = [[NSMutableArray alloc] init];
        [array addObject:@"1"];
        temp = array;
    }
    NSLog(@"block.array = %@", temp); // null
}

- (void)dayin {
    NSMutableArray *array = [NSMutableArray arrayWithObjects:@"1", @"2", nil];
    __weak NSMutableArray *temp = array;
    // 这里是强引用，retainCount+1，
    // 即使array在外界设置为nil，会减一，但是此时还是1，所以不会释放
    // 可以参考self的引用哈
//    void(^block)(void) = ^{
//        [array addObject:@"3"];
//        NSLog(@"block.array = %@", array);
//    };
    [array addObject:@"4"];
    array = nil;
    // array工厂模式搞出来的对象，需要等待runloop时候才会被释放哈
    NSLog(@"block.array = %@, temp = %@", array, temp);
//    block();
}

- (void)test {
    self.params = [NSMutableDictionary dictionary];
    // 两个nil
    // -[__NSDictionaryM removeObjectForKey:]: key cannot be nil'
    // Null passed to a callee that requires a non-null argument
    // key对应做清空
//    [self.params setValue:nil forKey:nil];
//    [self.params setValue:nil forKey:@"name"]; // KVC
    
    // 都是nil -[__NSDictionaryM setObject:forKey:]: key cannot be nil'
    // -[__NSDictionaryM setObject:forKey:]: object cannot be nil (key: name)'
    [self.params setObject:nil forKey:@"name"];
    
    NSNumber *num = [[NSNumber alloc] init];
    [num copy];
}

- (void)test2222 {
    [self globalQueueTest];
    
//    WDButton *b = [[WDButton alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
//    [self.view addSubview:b];
    // 不会crash，但是value or key set nil, will crash
//    [b setValue:[NSNull null] forKey:@"name"];
}

- (void)globalQueueTest {
    //2.创建一个全局队列
    NSArray *array = @[@"a", @"b", @"c", @"d", @"e", @"f", @"g", @"h", @"i", @"j"];
    dispatch_queue_t queue =  dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//    dispatch_async([array count], queue, ^(size_t index) {
//        NSLog(@"%zu: %@", index, [array objectAtIndex:index]);
//    });
    dispatch_async(queue, ^{
        NSLog(@"logCCCC");
    });
    NSLog(@"done");
}

- (void)kuaishouQueue {
    // 串行队列,并发队列，都是直接死锁，啥也不打印哈（之前我就是这么说的，让面试官吓唬住了）
    dispatch_queue_t queue = dispatch_queue_create("com.test.gcd.serial", DISPATCH_QUEUE_SERIAL);
    dispatch_async(queue, ^{
        NSLog(@"logCCCC");
        dispatch_sync(queue, ^{
            NSLog(@"logAAAA");
        });
    });
    
    dispatch_sync(dispatch_get_main_queue(), ^{
        NSLog(@"log1111");
    });
}

- (void)findAllViews {
    NSArray<UIView *> *subviews = UIApplication.sharedApplication.keyWindow.subviews;
    for (UIView *view in subviews) {
        NSLog(@"mihayou: %@", view);
    }
}

- (void)synaInNewQueue {
    NSLog(@"1");
    dispatch_queue_t queue = dispatch_queue_create("com.test.gcd.serial", DISPATCH_QUEUE_SERIAL);
    
    dispatch_sync(queue, ^{
        NSLog(@"2-线程:%@", NSThread.currentThread);
    });
    
    NSLog(@"3");
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

//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    for (int i = 0; i < 10000; i++) {
//        dispatch_async(self.queue, ^{
//            // lg_念念不忘，就在堆区，字符串太复杂了，所以就在堆；
//            // abc很简单，优化后是NSTaggedPointerString类型，是常量区
//            self.name = [NSString stringWithFormat:@"abc"];
//            NSLog(@"name = %@", self.name);
//        });
//    }
//}

// 测试1：只有touchStart三件套情况，就打印他们
// 测试2：touch三件套，外加addTarget:action: touch起作用(覆盖addTarget-cancel了)
// 测试3：touch & button.addTarget:action & b.addTapGeust，结果会打印touch & tap事件(覆盖addTarget-cancel了)
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
