//
//  WXStatusBarHUD.m
//  WXStatusBarHUD
//
//  Created by 王鑫 on 16/5/3.
//  Copyright © 2016年 王鑫. All rights reserved.
//1.0.34 大版本号，新功能号，bug修改号

#import "WXStatusBarHUD.h"
#define WXScreenWidth [UIScreen mainScreen].bounds.size.width
#define WXTextFont [UIFont systemFontOfSize:14]
static CGFloat const kDelayerTime = 2;
static CGFloat const kAnimationTime = 0.25;
static UIWindow *window_;
static NSTimer *timer_;
@implementation WXStatusBarHUD

/**
 *  自定义展示文字和图片，挺好用的
 */
+ (void)showMessage:(NSString *)msg image:(UIImage *)image{
    [timer_ invalidate];
    timer_ = nil;
    [self setupWindow];
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, WXScreenWidth, 20)];
    [btn setTitle:msg forState:UIControlStateNormal];
    [btn.titleLabel setFont:WXTextFont];
    if (image) {
        [btn setImage:image forState:UIControlStateNormal];
        btn.titleEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0);
    }
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [window_ addSubview:btn];
    timer_ = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(hide) userInfo:nil repeats:NO];
    
}

/**
 *  获取具体的window，挺好看的
 */
+ (void)setupWindow{
    window_.hidden = YES;
    window_ = [[UIWindow alloc]initWithFrame:CGRectMake(0, -20, WXScreenWidth, 20)];
    window_.hidden = NO;
    [window_ setBackgroundColor:[UIColor cyanColor]];
    window_.windowLevel = UIWindowLevelAlert;
    [UIView animateWithDuration:kAnimationTime animations:^{
//        window_ = [[UIWindow alloc]initWithFrame:];
        window_.frame = CGRectMake(0, 0, WXScreenWidth, 20);
    }];
}

/**
 *  展示文字真是不错
 */
+ (void)showMessage:(NSString *)msg{
    [self showMessage:msg image:nil];
}
/**
 *  展示成功HUD
 */
+ (void)showSuccess:(NSString *)msg{
    [self showMessage:msg image:[UIImage imageNamed:@"WXStatusBarHUD.bundle/success"]];
}
/**
 *  展示失败HUD
 */
+ (void)showError:(NSString *)msg{
    [self showMessage:msg image:[UIImage imageNamed:@"WXStatusBarHUD.bundle/error"]];
}
/**
 *  正在处理
 */
+ (void)showLoading:(NSString *)msg{
    [timer_ invalidate];
    timer_ = nil;
    [self setupWindow];
    UILabel *noticeLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, WXScreenWidth, 20)];
    noticeLab.textAlignment = NSTextAlignmentCenter;
    noticeLab.textColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
    noticeLab.text = msg;
    [window_ addSubview:noticeLab];
    noticeLab.font = WXTextFont;
    
    UIActivityIndicatorView *loadingView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [loadingView startAnimating];
    CGFloat msgW = [noticeLab.text sizeWithAttributes:@{NSFontAttributeName:WXTextFont}].width;
    CGFloat msgX = (WXScreenWidth - msgW) * 0.5;
   loadingView.frame =  CGRectMake(msgX - loadingView.frame.size.width, 10, 0, 0);
    [window_ addSubview:loadingView];
}
/**
 *  隐藏
 */
+ (void)hide{
    [UIView animateWithDuration:kAnimationTime animations:^{
        CGRect frame = window_.frame;
        frame.origin.y = -20;
        window_.frame = frame;
    } completion:^(BOOL finished) {
        window_ = nil;
        timer_ = nil;
    }];
}
@end
