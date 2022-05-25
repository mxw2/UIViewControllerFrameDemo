//
//  WXStatusBarHUD.h
//  WXStatusBarHUD
//
//  Created by 王鑫 on 16/5/3.
//  Copyright © 2016年 王鑫. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WXStatusBarHUD : NSObject
/**
 *  自定义展示文字和图片
 */
+ (void)showMessage:(NSString *)msg image:(UIImage *)image;
/**
 *  展示文字
 */
+ (void)showMessage:(NSString *)msg;
/**
 *  展示成功HUD
 */
+ (void)showSuccess:(NSString *)msg;
/**
 *  展示失败HUD
 */
+ (void)showError:(NSString *)msg;
/**
 *  正在处理
 */
+ (void)showLoading:(NSString *)msg;
/**
 *  隐藏
 */
+ (void)hide;
@end
