//
//  KDThreeViewController.m
//  VCFrame
//
//  Created by marsxinwang on 2021/9/15.
//

#import "KDThreeViewController.h"
#import "KDFourViewController.h"

@implementation KDThreeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:1 green:0 blue:0 alpha:0.5];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickView)];
    [self.view addGestureRecognizer:tap];
    
    
    self.blueButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.blueButton.backgroundColor = [UIColor yellowColor];
    self.blueButton.frame = CGRectMake(100, 200, 100, 50); // 设置按钮的位置和大小

    // 添加点击事件
    [self.blueButton addTarget:self action:@selector(buttonClicked) forControlEvents:UIControlEventTouchUpInside];

    // 将按钮添加到视图上
    [self.view addSubview:self.blueButton];
}

- (void)buttonClicked {
//    KDFourViewController *four = [[KDFourViewController alloc] init];
//    [self.navigationController pushViewController:four animated:YES];
    
    
    //创建线程组
    dispatch_semaphore_t sem = dispatch_semaphore_create(0);
    dispatch_queue_t quene = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(quene, ^{
       sleep(5);
       NSLog(@"task 1");
       dispatch_semaphore_signal(sem);
    });

    dispatch_async(quene, ^{
       sleep(2);
       NSLog(@"task 2");
       dispatch_semaphore_signal(sem);
    });


    dispatch_async(quene, ^{
       sleep(3);
       NSLog(@"task 3");
       dispatch_semaphore_signal(sem);
    });
    dispatch_time_t t = dispatch_time(DISPATCH_TIME_NOW, 5 * NSEC_PER_SEC);
    dispatch_semaphore_wait(sem, t);
    dispatch_semaphore_wait(sem, t);
    dispatch_semaphore_wait(sem, t);
    //创建的4个任务执行完之后
    NSLog(@"do something");
}

- (void)clickView {
    [self dismissViewControllerAnimated:NO completion:nil];
}

@end
