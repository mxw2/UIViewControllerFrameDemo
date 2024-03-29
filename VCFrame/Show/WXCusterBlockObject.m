//
//  WXCusterBlockObject.m
//  VCFrame
//
//  Created by 马斯 on 2023/10/20.
//

#import "WXCusterBlockObject.h"

@interface WXCusterBlockObject ()

@property (nonatomic, strong) NSObject *object;

@end

@implementation WXCusterBlockObject

- (void)run {
    self.object = [NSObject new];
    // 第一种情况和第二种情况都会用到哈
//     __weak WXCusterBlockObject *weakSelf = self;
    __weak NSObject *weakObject = self.object;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 第一种情况：
        // 打印null，因为此时strongSelf = nil; strongSelf.object sendMsg(nil, object)
        // 给空对象发送消息，不会crash
        // __strong WXCusterBlockObject* strongSelf = weakSelf;
        // NSLog(@"%@", strongSelf.object);
        
        // 第二种情况：
        // Crash
        // strongSelf->_object表示获获取到_object这个成员变量的指针，
        // 使用了strong_Self来创建一个强引用,
        // 但是你仍然尝试访问strongSelf->_object，
        // 这实际上是直接访问了_object的实例变量，而不是通过属性访问。
        // 由于你的strongSelf是一个强引用，它不会被提前释放，
        // 但如果self（即WXCusterBlockObject的实例）在闭包执行前被销毁
        // （虽然是置空了，没有被覆盖，但是他是），
        // _object实例变量将变得不可访问，这会导致崩溃。
        // 解决：可以采用判断strongSelf是否为空哈
//         __strong WXCusterBlockObject* strongitySelf = weakSelf;
        __strong NSObject *strongObject = weakObject;
        // 此时我认为在block对变量strongitySelf->_object的捕获，可能是assgin的
        NSLog(@"%@", strongObject);
        
        // 第三种情况：
        // 没有出现crash，相当于self->_object，对self强引用了
        // 因为self没有销毁，所以_object可以正常访问
        // 警告:Block implicitly retains 'self';
        // explicitly mention 'self' to indicate this is intended behavior
        // NSLog(@"%@", _object);
    });
}

- (void)dealloc {
    NSLog(@"WXCusterBlockObject dealloc");
}

@end
