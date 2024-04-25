//
//  SuanFaTest.m
//  VCFrame
//
//  Created by 马斯 on 2024/4/25.
//

#import "SuanFaTest.h"
#import <UIKit/UIKit.h>
#import "WDButton.h"

@implementation SuanFaTest
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

// 动态规划，递归函数
- (int)getNums:(int)n m:(int)m {
    // 递归函数结束条件
    if( n ==0 || m == 0){
        return 1;
    } else {
        return [self getNums:(n - 1) m:m] + [self getNums:n m:(m -1)];
    }
}

@end
