//
//  KDTableViewController.m
//  UIViewControllerFrameDemo
//
//  Created by marsxinwang on 2021/9/15.
//

#import "KDTableViewController.h"
#import "UIViewControllerFrameDemoDefine.h"
#import "KDNoNavigationBarViewController.h"

@interface KDTableViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak) UITableView *tableView;

@end

@implementation KDTableViewController

/* 情景一：
 不处理任何translucent属性
 self.navigationController.navigationBar.translucent
 self.tabBarController.tabBar.translucent
 直接设置self.edgesForExtendedLayout = UIRectEdgeNone;
 在viewDidLayoutSubviews设置tableView.frame也会得到正确的效果
 即上下bar都是透明的，self.view处于二者之间，tableView在layout的方法整可以正确拿到self.view.bounds
 **/

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

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    // 此处才能拿到正确的self.view.bounds，
    // self.tableView.frame = self.view.bounds;
    // NSLog(@"KDTableViewController.frame viewDidAppear = %@", [NSValue valueWithCGRect:self.view.frame]);
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
    self.navigationItem.title = [NSString stringWithFormat:@"%@", self];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds
                                                          style:UITableViewStylePlain];
    [self.view addSubview:tableView];
    tableView.backgroundColor = UIColor.cyanColor;
    tableView.delegate = self;
    tableView.dataSource = self;
    // 没起作用，只要布局放到viewDidLayoutSubviews就没有问题
    // automaticallyAdjustsScrollIndicatorInsets 感觉可以不要
    tableView.automaticallyAdjustsScrollIndicatorInsets = UIApplicationBackgroundFetchIntervalNever;
    self.tableView = tableView;
}

// 对subview布局，就应该在这类方法中才可以拿到正确的self.view.frame
// 由于self可能配置了edgesForExtendedLayout、translucent、automaticallyAdjustsScrollIndicatorInsets等属性
// 所以self.view.bounds一定会变化，而viewDidLayoutSubviews会得到正确的bounds
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.tableView.frame = self.view.bounds;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    cell.textLabel.text = @(indexPath.row).stringValue;
    cell.backgroundColor = randomColor;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    KDNoNavigationBarViewController *tempController = [[KDNoNavigationBarViewController alloc] init];
    [self.navigationController pushViewController:tempController animated:YES];
}

@end
