//
//  AppDelegate.m
//  VCFrame
//
//  Created by marsxinwang on 2021/9/15.
//

#import "AppDelegate.h"
#import "KDNavigationController.h"
#import "KDTabBarController.h"
#import "KDTwoViewController.h"
#import "KDThreeViewController.h"
#import "KDFourViewController.h"
#import "KDTableViewController.h"
#import "VCFrameDefine.h"
#import "KDDemoViewController.h"
#import "KDNoNavigationBarViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

// 参考文章链接：https://blog.csdn.net/Bolted_snail/article/details/99673358

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
//     [self setupTabbarController]; // 4个tabs demo
    [self setupOriginalController];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)setupOriginalController {
    KDDemoViewController *controller = [[KDDemoViewController alloc] init];
    controller.title = @"有导航栏";
    KDNavigationController *navigationController = [[KDNavigationController alloc] initWithRootViewController:controller];
    self.window.rootViewController = navigationController;
}

- (void)setupTabbarController {
    KDTabBarController *tabbarController = [[KDTabBarController alloc] init];
    for (NSInteger i = 0; i < 4; i++) {
        UIViewController *controller = [self setupControllerWithIndex:i];
        [tabbarController addChildViewController:controller];
    }
    self.window.rootViewController = tabbarController;
}

- (UIViewController *)setupControllerWithIndex:(NSInteger)index {
    KDBaseViewController *viewController = nil;
    if (index == 0) {
        viewController = [[KDTableViewController alloc] init];
    } else if (index == 1){
        viewController = [[KDTwoViewController alloc] init];
    } else if (index == 2){
        viewController = [[KDThreeViewController alloc] init];
    } else if (index == 3){
        viewController = [[KDFourViewController alloc] init];
    }
    viewController.view.backgroundColor = randomColor;
    KDNavigationController *navigationController = [[KDNavigationController alloc] initWithRootViewController:viewController];
    navigationController.tabBarItem.title = @(index).stringValue;
    return navigationController;
}

@end
