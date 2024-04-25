//
//  KDDemoViewController.m
//  VCFrame
//
//  Created by marsxinwang on 2023/8/11.
//

#import "KDDemoViewController.h"
#import "SIPerson.h"
#import "KDCustomURLSchemeHandler.h"
#import "WDButton.h"
#import "KDThreeViewController.h"
#import "KDNavigationController.h"
#import "UIWindow+BBACurrentVC.h"

@interface KDDemoViewController ()

@property (nonatomic, strong) UIButton *blueButton;

@end

@implementation KDDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.cyanColor;
    self.title = @"有导航栏-KDDemoViewController";
    
    [self addB];
}

# pragma mark - 手势识别器

# pragma mark - 多线程

# pragma mark - webview

# pragma mark - runloop

# pragma mark - 异步绘制

# pragma mark - 全屏弹出控制器








- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    for (int i = 0; i < 10000; i++) {
//        dispatch_async(self.queue, ^{
//            // lg_念念不忘，就在堆区，字符串太复杂了，所以就在堆；
//            // abc很简单，优化后是NSTaggedPointerString类型，是常量区
//            self.name = [NSString stringWithFormat:@"abc"];
//            NSLog(@"name = %@", self.name);
//        });
//    }
}

// 测试1：只有touchStart三件套情况，就打印他们
// 测试2：touch三件套，外加addTarget:action: touch起作用
// 测试3：touch & button.addTarget:action & b.addTapGeust，结果会打印touch & tap事件
- (void)addB {
    WDButton *b = [[WDButton alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
    [b addTarget:self action:@selector(didB) forControlEvents:UIControlEventTouchUpInside];
    b.backgroundColor = UIColor.yellowColor;
    [self.view addSubview:b];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
    [tap addTarget:self action:@selector(clickTapUITapGestureRecognizer)];
    [b addGestureRecognizer:tap];
}

- (void)clickTapUITapGestureRecognizer {
    NSLog(@"clickTapUITapGestureRecognizer");
}

- (void)didB {
    NSLog(@"didClickB");
}

// 不行哈
- (void)mockAMethodWithObejct:(NSString *)object {
    NSLog(@"mockAMethodWithObejct:NSString");
}

//- (void)mockAMethodWithObejct:(NSObject *)object {
//    NSLog(@"mockAMethodWithObejct:NSObject");
//}





@end
