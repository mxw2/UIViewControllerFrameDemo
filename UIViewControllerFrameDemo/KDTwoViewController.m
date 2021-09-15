//
//  KDTwoViewController.m
//  UIViewControllerFrameDemo
//
//  Created by marsxinwang on 2021/9/15.
//

#import "KDTwoViewController.h"

@interface KDTwoViewController ()

@end

@implementation KDTwoViewController

#warning mark - 修改edgesForExtendedLayout及translucent属性后，需要在viewDidAppear:方法中获取正确的frame

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // 只会影响TwoViewController对应的导航栏是不透明的，其他导航栏依旧正常显示，self.view会处于导航栏之下，tabbar之上
    self.navigationController.navigationBar.translucent = NO;
    // tabbarController修改之后，会影响其他的控制器，导致其他view的显示出现问题：在导航栏top开始，在tabbar的top截止
    self.tabBarController.tabBar.translucent = NO;
    // 获取的frame有问题
    // NSLog(@"KDBaseViewController.frame viewWillAppear = %@", [NSValue valueWithCGRect:self.view.frame]);
    // defalut YES 不透明的
    // self.navigationController.navigationBar.opaque = NO;
    NSLog(@"%@:viewWillAppear, translucent = NO", self);
}

// 在此可以拿到正确的self.view.frame
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    // NSLog(@"KDBaseViewController.frame viewDidAppear = %@", [NSValue valueWithCGRect:self.view.frame]);
    // 理论上讲，tabbar.translucent一开始就会确定，不会来回修改
    // 目前Demo只是为了测试特定效果，所以在TableViewController & TwoViewController中是不透明的，其他tab是透明的
    // 因为viewWillAppear顺序导致有问题，所以需要在viewDidAppear重新设置tabbar的透明属性，然后使用self.navigationController去更新self.view.frame，否则难以更新
    self.tabBarController.tabBar.translucent = NO;
    [self.navigationController.view setNeedsLayout];
    [self.navigationController.view layoutSubviews];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    // 还原之后，保证tabbar其他子控制器的view在tabbar的底部截止
    self.tabBarController.tabBar.translucent = YES;
    NSLog(@"%@:viewWillDisappear, translucent = YES", self);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeAll;
}

// 对subview布局，就应该在这类方法中才可以拿到正确的self.view.frame
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    // NSLog(@"KDTwoViewController.frame viewDidLayoutSubviews = %@", [NSValue valueWithCGRect:self.view.frame]);
}

@end
