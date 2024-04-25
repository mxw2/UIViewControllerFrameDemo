//
//  AutoReleasePoolTest.m
//  VCFrame
//
//  Created by 马斯 on 2024/4/25.
//

#import "AutoReleasePoolTest.h"

@implementation AutoReleasePoolTest


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

- (void)print0_100 {
    __block int i = 0;
    dispatch_queue_t q0 = dispatch_queue_create("q1", DISPATCH_QUEUE_CONCURRENT);
    dispatch_queue_t q1 = dispatch_queue_create("q2", DISPATCH_QUEUE_CONCURRENT);
    dispatch_queue_t q2 = dispatch_queue_create("q3", DISPATCH_QUEUE_CONCURRENT);
    NSCondition *condition = [[NSCondition alloc] init];
    dispatch_async(q0, ^{
        while(1) {
            [condition lock];
            while (i % 3 != 0) {
                [condition wait];
            }
            if (i > 100) {
                [condition unlock];
                return;
            }
            NSLog(@"q0 - i = %d", i);
            i++;
            [condition broadcast];
            [condition unlock];
        }
    });

    dispatch_async(q1, ^{
        while(1) {
            [condition lock];
            while (i % 3 != 1) {
                [condition wait];
            }
            if (i > 100) {
                [condition unlock];
                return;
            }
            NSLog(@"q1 - i = %d", i);
            i++;
            [condition broadcast];
            [condition unlock];
        }
    });

    dispatch_async(q2, ^{
        while(1) {
            [condition lock];
            while (i % 3 != 2) {
                [condition wait];
            }
            if (i > 100) {
                [condition unlock];
                return;
            }
            NSLog(@"q2 - i = %d", i);
            i++;
            [condition broadcast];
            [condition unlock];
        }
    });

    NSLog(@"[print0_100]end");
}

//- (void)print0_100 {
//    __block int i = 0;
//    dispatch_queue_t queueA = dispatch_queue_create("queue a", DISPATCH_QUEUE_CONCURRENT);
//    dispatch_queue_t queueB = dispatch_queue_create("queue b", DISPATCH_QUEUE_CONCURRENT);
//    dispatch_queue_t queueC = dispatch_queue_create("queue c", DISPATCH_QUEUE_CONCURRENT);
//    NSCondition *condition = [[NSCondition alloc] init];
//    NSLog(@"[print0_100]begin");
//    dispatch_async(queueA, ^{
//        while (1) {
//            [condition lock];
//            // 这里是while
//            while (i%3 != 0) {
//                [condition wait];
//            }
//            if (i > 100) {
//                [condition unlock];
//                return;
//            }
//            NSLog(@"[print0_100]A ==== i = %d",i);
//            i++;
//            [condition broadcast];
//            [condition unlock];
//        }
//    });
//
//    dispatch_async(queueB, ^{
//        while (1) {
//            [condition lock];
//            // 这里是while
//            while (i%3 != 1) {
//                [condition wait];
//            }
//            if (i > 100) {
//                [condition unlock];
//                return;
//            }
//            NSLog(@"[print0_100]B ==== i = %d",i);
//            i++;
//            [condition broadcast];
//            [condition unlock];
//        }
//    });
//    dispatch_async(queueC, ^{
//        while (1) {
//            [condition lock];
//            // 这里是while
//            while (i%3 != 2) {
//                [condition wait];
//            }
//            if (i > 100) {
//                [condition unlock];
//                return;
//            }
//            NSLog(@"[print0_100]C ==== i = %d",i);
//            i++;
//            [condition broadcast];
//            [condition unlock];
//        }
//    });
//    NSLog(@"[print0_100]end");
//}

- (void)testAutoReleasePool {
    NSMutableArray *array = [NSMutableArray arrayWithObject:@"1"];
    NSInteger count = CFGetRetainCount((__bridge CFTypeRef ) array);
    NSLog(@"array.retainCount = %ld, p = %p", count, array);
    void(^block)(void) = ^{
        // retainCount = 2. 强引用，retainCount+1，
        // 即使array在外界设置为nil，会减一，但是此时还是1, 不会释放
        // 可以参考self的引用哈
        [array addObject:@"3"];
        NSInteger count2 = CFGetRetainCount((__bridge CFTypeRef ) array);
        NSLog(@"2.array.retainCount = %ld, p = %p", count2, array);
        NSLog(@"block.array = %@", array);
    };
    [array addObject:@"4"];
    array = nil;
    NSLog(@"3.array.p = %p", array);
    // 结果是1\3
    dispatch_after(2, dispatch_get_main_queue(), ^{
        block();
    });
    
//    block();
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

- (void)syn {
    @synchronized (nil) {
        NSLog(@"123");
    }
}


@end
