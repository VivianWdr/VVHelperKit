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
@property (nonatomic) double odometer;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNotificationCenter];
    [self settingBlock];
    [self setConvert];
}
- (IBAction)pushVC:(id)sender {
    [self presentViewController:self.gcdViewController animated:YES completion:nil];
}
#pragma mark - convertPoint坐标转换规律
- (void)setConvert{
    UIView *rootView = ({
        UIView *view = [UIView new];
        [self.view addSubview:view];
        view.frame = CGRectMake(10, 10, 100, 100);
        view.backgroundColor = [UIColor blueColor];
        view;
    });
    
    UIView *aView = ({
        UIView *view = [UIView new];
        [self.view addSubview:view];
        view.frame = CGRectMake(100, 100, 300, 500);
        view.backgroundColor = [UIColor yellowColor];
        view;
    });
    
    UIView *bView = ({
        UIView *view = [UIView new];
        [self.view addSubview:view];
        view.frame = CGRectMake(0, 64, 50, 50);
        view.backgroundColor = [UIColor redColor];
        view;
    });
    
    CGPoint point = [rootView convertPoint:aView.frame.origin toView:bView];
    DLog(@"[point: %@]",NSStringFromCGPoint(point));//[point: {110, 46}]
    point = [rootView convertPoint:aView.frame.origin fromView:bView];
    DLog(@"[point: %@]", NSStringFromCGPoint(point));
    
    point = [rootView convertPoint:bView.frame.origin toView:aView];
    DLog(@"[point: %@]", NSStringFromCGPoint(point));
    
    point = [rootView convertPoint:bView.frame.origin fromView:aView];
    DLog(@"[point: %@]", NSStringFromCGPoint(point));
    /*
     [aView convertPoint:point toView:bView];
     ==> result = aView.origin + point - bView.origin
     [aView convertPoint:point fromView:bView];
     ==> result = bView.origin + point - aView.origin
     */
}


#pragma mark - NSNotificationCenter
- (void)setNotificationCenter{
    UITextField *testField = [[UITextField alloc] initWithFrame:CGRectMake(0, 100, 100, 40)];
    testField.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:testField];
    
    //object 当值为nil，可以获取所有对象的通知信息。（2）如果观察者object需获取指定通知中心的对象信息，且通知中心对象传观察者需要的对象信息，则可以获取到通知。
    self.gcdViewController = [[GCDViewController alloc] init];
    // 注册通知，以 SEL 方法回调
    [kNotificationCenter addObserver:self selector:@selector(test:) name:@"testWillChangeNotification" object:self.gcdViewController.icon];

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

- (void)dealloc{
    [kNotificationCenter removeObserver:self name:@"testWillChangeNotification" object:self.gcdViewController.icon];
}

#pragma mark - Block
//定义block---链式编程
- (ViewController *(^)(NSString *name))people{
    return ^(NSString *name){
        DLog(@"%@",name);
        return self;
    };
}

- (void)settingBlock{
    //循环引用：在block中引用了self，对block做了copy操作 || self持有block，而同时Block持有self
    
    self.people(@"Vivi");//对象通过点语法获取block变量
    
    //注意 block 可以使用相同作用域范围内定义的变量。
    int multoplier = 7;
    int (^myBlock) (int) = ^(int num){
        return num * multoplier;
    };
    //1.如果你声明一个 block 作为变量,你可以把它简单的作为一个函数使用:
    DLog(@"%d",myBlock(7));
    
    //2.直接使用block（作为参数）
    char *myCharacters[3] = { "TomJohn", "George", "Charles Condomine" };
    
    qsort_b(myCharacters, 3, sizeof(char *), ^(const void *l, const void *r) {
        
        char *left = *(char **)l;
        
        char *right = *(char **)r;
        
        return strncmp(left, right, 1);
    });
    
    [self driveForDuration:3.0 withVariableSpeed:^double(double time) {
        DLog(@"%f",time);
        return time;
    } steps:1];
    
    //3.函数参数
    int (^mySquare)(int) = ^int (int a){
        return a*a;
    };
    [self myFouction:mySquare];
    
    //4.变量作用域
    int outA = 8;
    int (^myPtr)(int) = ^(int a){ return outA + a;}; //block里面可以读取同一类型的outA的值，事实上，myPtr在其主体中用到的outA这个变量值的时候做了一个copy的动作，把outA的值copy下来。
    
    outA = 5;  //在调用myPtr之前改变outA的值
    int result = myPtr(3);  // result的值仍然是11，并不是8
    NSLog(@"result=%d", result);
    
    //5.这里copy的值是变量的值，如果它是一个记忆体的位置（地址），换句话说，就是这个变量是个指针的话，它的值是可以在block里被改变的。
    NSMutableArray *mutableArray = [NSMutableArray arrayWithObjects:@"one", @"two", @"three", nil];
    int results = ^(int a){
        [mutableArray removeLastObject];
        return a*a;
    }(5);
    DLog(@"test array :%@", mutableArray);//原本mutableArray的值是{@"one",@"two",@"three"}，在block里面被更改mutableArray后，就变成{@"one", @"two"}了。
    //6.静态变量
    static int outAa = 8;
    int (^myPtrs)(int) = ^(int a){return outA + a;};
    outAa = 5;
    int resultas = myPtrs(3);  //result的值是8，因为outA是static类型的变量
    NSLog(@"result=%d", resultas);
    //甚至可以直接在block里面修改outA的值，例如下面的写法：
//    static int outA = 8;
//    int (^myPtr)(int) = ^(int a){ outA = 5; return outA + a;};
//    int result = myPtr(3);  //result的值是8，因为outA是static类型的变量
//    NSLog(@"result=%d", result);
    //7.__block:可以任意修改此变量的值
//    __block int num = 5;
//    
//    int (^myPtr)(int) = ^(int a){return num++;};
//    int (^myPtr2)(int) = ^(int a){return num++;};
//    int result = myPtr(0);   //result的值为5，num的值为6
//    result = myPtr2(0);      //result的值为6，num的值为7
//    NSLog(@"result=%d", result);

}
- (void)myFouction:(int(^)(int))block{
    block(3);
}
//block作为函数参数，函数体调用block
- (void)driveForDuration:(double)duration
       withVariableSpeed:(double (^)(double time))speedFunction
                   steps:(int)numSteps {
    double dt = duration / numSteps;
    for (int i=1; i<=numSteps; i++) {
        _odometer += speedFunction(i*dt) * dt;
    }
    speedFunction(5);
}
@end
