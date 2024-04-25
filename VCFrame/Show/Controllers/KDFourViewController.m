//
//  KDFourViewController.m
//  VCFrame
//
//  Created by marsxinwang on 2021/9/15.
//

#import "KDFourViewController.h"
#import <objc/runtime.h>

//static const NSString * kUserName = @"StrongX";


@interface Student : NSObject

@property (nonatomic, copy) NSString *name;
- (void)speak;

@end

@implementation Student

- (void)speak {
    NSLog(@"my name's %@", self.name);
}

@end

@interface People : NSObject

@end

@implementation People

@end
/// 具体的控制器

@implementation KDFourViewController

void printClassInfo(id obj)
{
    Class cls = object_getClass(obj);
    NSLog(@"self:%s ", class_getName(cls));
    Class superCls = class_getSuperclass(cls);
    NSLog(@"superClass:%s", class_getName(superCls));
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSMutableSet *set = [NSMutableSet set];
    
    // 应该是具体的view
    UIView *targetView = [[UIView alloc] init];
    NSLog(@"init targetView = %@", targetView);
    UIView *viewA = [[UIView alloc] init];
    UIView *viewB = [[UIView alloc] init];
    [targetView addSubview:viewA];
    [targetView addSubview:viewB];
    while (viewA) {
        [set addObject:viewA];
        viewA = [viewA superview];
    };
    UIView *findView = nil;
    while (viewB) {
        if ([set containsObject:viewB]) {
            findView = viewB;
            break;
        } else {
            viewB = [viewB superview];
        }
    };
    NSLog(@"targetView = %@", targetView);
    
    self.view.backgroundColor = UIColor.cyanColor;
}

- (void)function5 {
    
//    NSString *b = @"halfrost";
//    NSLog(@"b = %p, 地址 = %p , 大小 = %lu  ",b, &b ,sizeof(b));
//    NSString *bx = @"x";
//    NSLog(@"bx = %p, 地址 = %p , 大小 = %lu  ",bx, &bx ,sizeof(bx));
    
    id clazz = [Student class];
    NSLog(@"Student class = %@,地址1 = %p, 地址2 = %p", clazz, clazz, &clazz);
    
    void *obj = &clazz;
    NSLog(@"Void *obj = %@ ，地址2 = %p ,地址3=%p", obj, obj, &obj);
    
    [(__bridge id)obj speak];
}

- (void)function4 {
    dispatch_queue_t q = dispatch_queue_create("qb.com", NULL);
    NSLog(@"thread = %@", NSThread.currentThread);
    dispatch_sync(q, ^{
        NSLog(@"sd");
        NSLog(@"thread = %@", NSThread.currentThread);
        dispatch_sync(q, ^{
            NSLog(@"s");
        });
    });
}

- (void)function3 {
    dispatch_async(dispatch_get_main_queue(), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"1");
        });
        
        NSLog(@"2");
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"3");
        });
    });
}

- (void)function2 {
//    NSLog(@"内存地址： %x",&kUserName);
//    kUserName = @"superXLX";
//    NSLog(@"内存地址： %x",&kUserName);
//    NSString *a = @"1";
//    NSLog(@"%x", &a);
//    a = @"2";
//    NSLog(@"%x", &a);
    
    
//    People *aPeople = [People new];
//
//    NSLog(@"before release!");
//    printClassInfo(aPeople);
//
//    [aPeople release];
//
//    NSLog(@"after release!");
//    printClassInfo(aPeople);
}

- (void)function1 {
    /**
     * 2020-03-07 23:24:30.935624+0800 XXXXX[46632:2549608] 1
     2020-03-07 23:24:30.935818+0800 XXXXX[46632:2549608] 3
     2020-03-07 23:24:30.935887+0800 XXXXX[46632:2549608] 2
     *     waitUntilDone = NO，不用等待主线程中log2执行完毕，可以直接执行log3
     *     waitUntilDone = YES, 必须执行主线程中的log2完毕后，在执行log3
     */
    
    NSLog(@"1");
    [self performSelectorOnMainThread:@selector(log2) withObject:nil waitUntilDone:YES];
    NSLog(@"3");
}

- (void)log2
{
    NSLog(@"2");
}

@end
