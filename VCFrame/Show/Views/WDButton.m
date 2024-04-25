//
//  WDButton.m
//  VCFrame
//
//  Created by 马斯 on 2023/8/24.
//

#import "WDButton.h"

@implementation WDButton

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSLog(@"WDButton touchesBegan");
    [super touchesBegan:touches withEvent:event];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSLog(@"WDButton touchesMoved");
    [super touchesMoved:touches withEvent:event];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSLog(@"WDButton touchesEnded");
    [super touchesEnded:touches withEvent:event];
}

@end
