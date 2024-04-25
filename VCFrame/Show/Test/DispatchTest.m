//
//  DispatchTest.m
//  VCFrame
//
//  Created by 马斯 on 2024/4/25.
//

#import "DispatchTest.h"

@implementation DispatchTest
- (void)testjiaocha {
    NSLog(@"1线程:%@", NSThread.currentThread);
    dispatch_queue_t queue = dispatch_queue_create("com.test.gcd", DISPATCH_QUEUE_SERIAL);
    dispatch_async(queue, ^{
        NSLog(@"3线程:%@", NSThread.currentThread);
    });
    
    dispatch_sync(queue, ^{
        NSLog(@"2线程:%@", NSThread.currentThread);
    });
    
    
    NSLog(@"4线程:%@", NSThread.currentThread);
}

- (void)test12345Sleep {
    
//    1线程:<_NSMainThread: 0x600000d38580>{number = 1, name = main}
//     2线程:<NSThread: 0x600000d70d00>{number = 6, name = (null)}
//     4线程:<_NSMainThread: 0x600000d38580>{number = 1, name = main}
//     3线程:<NSThread: 0x600000d70d00>{number = 6, name = (null)}
    NSLog(@"1线程:%@", NSThread.currentThread);
    dispatch_queue_t queue = dispatch_queue_create("com.test.gcd", DISPATCH_QUEUE_SERIAL);
    dispatch_async(queue, ^{
        NSLog(@"2线程:%@", NSThread.currentThread);
    });
    sleep(3);
    dispatch_async(queue, ^{
        NSLog(@"3线程:%@", NSThread.currentThread);
    });
    NSLog(@"4线程:%@", NSThread.currentThread);
}


- (void)test12345 {
//    dispatch_queue_t queue = dispatch_queue_create("com.test.gcd", DISPATCH_QUEUE_CONCURRENT);
    NSLog(@"1");
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSLog(@"2 线程:%@", NSThread.currentThread);
        dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            NSLog(@"3");
        });
        NSLog(@"4");
    });
    NSLog(@"5");
}

- (void)testSyncInSerial {
    for (int i = 0; i < 20; i++) {
        dispatch_queue_t queue = dispatch_queue_create("com.test.gcd", DISPATCH_QUEUE_SERIAL);
        dispatch_async(queue, ^{
            NSLog(@"线程:%@", NSThread.currentThread);
        });
    }
}

// 区别哈：
// 看来NSOperationQueue & Operation(默认是start同步，还是给了新线程运行)
// dispatch_queue_t & 同步任务，就用当前线程

- (void)testSyncInConcurrent {
    //都是主线程，因为是同步处理
    //1-线程:<_NSMainThread: 0x600000888580>{number = 1, name = main}
    //2-线程:<_NSMainThread: 0x600000888580>{number = 1, name = main}
    //3-线程:<_NSMainThread: 0x600000888580>{number = 1, name = main}
    dispatch_queue_t queue = dispatch_queue_create("com.test.gcd", DISPATCH_QUEUE_CONCURRENT);
    dispatch_sync(queue, ^{
        NSLog(@"1-线程:%@", NSThread.currentThread);
    });
    dispatch_sync(queue, ^{
        NSLog(@"2-线程:%@", NSThread.currentThread);
    });
    dispatch_sync(queue, ^{
        NSLog(@"3-线程:%@", NSThread.currentThread);
    });
}

- (void)userConcurrentQueue {
    // 哪怕只有一个都使用的是子线程
//    m-线程:<NSThread: 0x600000909940>{number = 3, name = (null)}
//    m-线程:<NSThread: 0x600000959580>{number = 6, name = (null)}
//    m-线程:<NSThread: 0x600000938240>{number = 7, name = (null)}
//    m-线程:<NSThread: 0x600000911c80>{number = 8, name = (null)}
    NSOperationQueue *q = [[NSOperationQueue alloc] init];
    for (int i = 0; i < 4; i++) {
        NSBlockOperation *o1 = [NSBlockOperation blockOperationWithBlock:^{
            NSLog(@"m-线程:%@", NSThread.currentThread);
        }];
        [q addOperation:o1];
    }
}

- (void)getNSThreadFirst {
    // 2024-04-02 14:55:48.363110+0800 VCFrame[4400:181333] a
    // 2024-04-02 14:55:48.363171+0800 VCFrame[4400:181333] b
    // 2024-04-02 14:55:48.363217+0800 VCFrame[4400:181333] c
    // 2024-04-02 14:55:48.363270+0800 VCFrame[4400:181333] d
    // 2024-04-02 14:55:48.363335+0800 VCFrame[4400:181564] 1
    NSLog(@"a");
    NSThread *thread = [[NSThread alloc] initWithTarget:self
                                               selector:@selector(log5)
                                                 object:nil];
    
    NSLog(@"b");
    [self performSelector:@selector(test)
                 onThread:thread
               withObject:nil
            waitUntilDone:NO];
    
    NSLog(@"c");
    [thread start];
    
    NSLog(@"d");
}

- (void)log5 {
    NSLog(@"5");
}

- (void)test5 {
//    开始
//    结束
//    1-线程:<NSThread: 0x6000027a9e80>{number = 7, name = (null)}
//    2-线程:<NSThread: 0x6000027a9e80>{number = 7, name = (null)}
    NSLog(@"开始");
    dispatch_queue_t queue = dispatch_queue_create("com.test.gcd", DISPATCH_QUEUE_SERIAL);
    dispatch_async(queue, ^{
        NSLog(@"1-线程:%@", NSThread.currentThread);
        // 这里是同步操作，本身在子线程中，子线程同步，所以打印是在子线程的。
        // 放到并发队列中，没事哈
        dispatch_sync(queue, ^{
            NSLog(@"2-线程:%@", NSThread.currentThread);
        });
    });
    NSLog(@"结束");
}

- (void)testDeadThread {
    NSThread *thread = [[NSThread alloc] initWithBlock:^{
                            NSLog(@"1");
                            [[NSRunLoop currentRunLoop] addPort:[[NSPort alloc] init]
                                                        forMode:NSDefaultRunLoopMode];
                            [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode
                                                     beforeDate:[NSDate distantFuture]];
                        }];
    [thread start];
    
    [self performSelector:@selector(test)
                 onThread:thread
               withObject:nil
            waitUntilDone:YES];
}

- (void)test {
   NSLog(@"2");
}

- (void)testNSLog {
    NSLog(@"initWithTarget:test:");
}

- (void)testsync {
    dispatch_queue_t queue = dispatch_queue_create("com.test.gcd", DISPATCH_QUEUE_SERIAL);
    dispatch_sync(queue, ^{
        NSLog(@"1-线程:%@", NSThread.currentThread);
    });
    dispatch_sync(queue, ^{
        NSLog(@"2-线程:%@", NSThread.currentThread);
    });
    dispatch_sync(queue, ^{
        NSLog(@"3-线程:%@", NSThread.currentThread);
    });
}

- (void)testAsync {
    dispatch_queue_t queue = dispatch_queue_create("com.test.gcd", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(queue, ^{
        NSLog(@"1-线程:%@", NSThread.currentThread);
    });
    dispatch_async(queue, ^{
        NSLog(@"2-线程:%@", NSThread.currentThread);
    });
    dispatch_async(queue, ^{
        NSLog(@"3-线程:%@", NSThread.currentThread);
    });
}

@end
