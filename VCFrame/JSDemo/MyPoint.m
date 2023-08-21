//
//  MyPoint.m
//  VCFrame
//
//  Created by 马斯 on 2023/8/20.
//

#import "MyPoint.h"

@implementation MyPoint

- (void)description {
    NSLog(@"MyPoint 自定义方法 description, x = %f, y = %f", self.x, self.y);
}

- (MyPoint *)makePointerWithX:(double)x y:(double)y {
    NSLog(@"MyPoint makePointerWithX = %f, y = %f", self.x, self.y);
    self.x = x;
    self.y = y;
    return self;
}

@synthesize x;

@synthesize y;

@end
