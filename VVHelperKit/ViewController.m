//
//  ViewController.m
//  VVHelperKit
//
//  Created by Vivi on 16/11/17.
//  Copyright © 2016年 Vivi. All rights reserved.
//

#import "ViewController.h"
#import "VVHelperKit.h"
#import "AppDelegate.h"
#import "GCDViewController.h"

@interface ViewController ()
@property (nonatomic, strong) GCDViewController *gcdViewController;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITextField *testField = [[UITextField alloc] initWithFrame:CGRectMake(0, 100, 100, 40)];
    testField.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:testField];
    
    //object 当值为nil，可以获取所有对象的通知信息。（2）如果观察者object需获取指定通知中心的对象信息，且通知中心对象传观察者需要的对象信息，则可以获取到通知。
    self.gcdViewController = [[GCDViewController alloc] init];
    // 注册通知，以 SEL 方法回调
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(test:) name:@"testWillChangeNotification" object:self.gcdViewController.icon];
    
}
- (IBAction)pushVC:(id)sender {
    [self presentViewController:self.gcdViewController animated:YES completion:nil];
}

// 此处 出现了 NSNotification 是系统创建了通知类。自定义也可以创建。
- (void)test:(NSNotification *)notification{
    
    // ueerInfo 包含一些信息，用于后续处理
    NSDictionary *userinfo = notification.userInfo;
    DLog(@"%@  %@",userinfo,notification.object);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"testWillChangeNotification" object:self.gcdViewController.icon];
}
@end
