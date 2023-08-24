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
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSLog(@"WDButton touchesMoved");
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSLog(@"WDButton touchesEnded");
}

@end
