//
//  KDNavigationController.m
//  UIViewControllerFrameDemo
//
//  Created by marsxinwang on 2021/9/15.
//

#import "KDNavigationController.h"

@interface KDNavigationController ()

@end

@implementation KDNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.viewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:animated];
}

@end
