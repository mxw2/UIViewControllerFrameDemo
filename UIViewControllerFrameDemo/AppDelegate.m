//
//  AppDelegate.m
//  UIViewControllerFrameDemo
//
//  Created by marsxinwang on 2021/9/15.
//

#import "AppDelegate.h"
#import "KDNavigationController.h"
#import "KDTabBarController.h"
#import "KDViewController.h"

#define random(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)/255.0]

#define randomColor random(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256))

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
    KDTabBarController *tabbarController = [[KDTabBarController alloc] init];
    for (NSInteger i = 0; i < 4; i++) {
        UIViewController *controller = [self setupControllerWithIndex:i];
        [tabbarController addChildViewController:controller];
    }
    self.window.rootViewController = tabbarController;
    [self.window makeKeyAndVisible];
    return YES;
}

- (UIViewController *)setupControllerWithIndex:(NSInteger)index {
    KDViewController *viewController = [[KDViewController alloc] init];
    viewController.view.backgroundColor = randomColor;
    KDNavigationController *navigationController = [[KDNavigationController alloc] initWithRootViewController:viewController];
    navigationController.tabBarItem.title = @(index).stringValue;
    return navigationController;
}

@end
