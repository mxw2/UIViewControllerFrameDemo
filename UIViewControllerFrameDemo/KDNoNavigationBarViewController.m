//
//  KDNoNavigationBarViewController.m
//  UIViewControllerFrameDemo
//
//  Created by marsxinwang on 2021/9/16.
//

#import "KDNoNavigationBarViewController.h"
#import "KDShowNavigabationBarViewController.h"

@interface KDNoNavigationBarViewController ()

@end

@implementation KDNoNavigationBarViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    // 想要隐藏navigationBar，同时又想支持右滑返回功能
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = UIColor.cyanColor;
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 300, 400, 400)];
    button.backgroundColor = UIColor.redColor;
    [self.view addSubview:button];
    // 会导致button消失
//    button.alpha = 0;
//    button.hidden = YES;
    button.opaque = YES;
    [button addTarget:self
               action:@selector(pushToShowNavigationBarController)
     forControlEvents:UIControlEventTouchUpInside];
    
    UIView *smallView = [[UIView alloc] init];
    [button addSubview:smallView];
    smallView.frame = CGRectMake(0, 0, 100, 100);
    smallView.backgroundColor = UIColor.brownColor;
}

- (void)pushToShowNavigationBarController {
    KDShowNavigabationBarViewController *controller = [[KDShowNavigabationBarViewController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
}

@end
