//
//  VVRACViewController.m
//  VVHelperKit
//
//  Created by Vivi on 16/11/23.
//  Copyright © 2016年 Vivi. All rights reserved.
//

#import "VVRACViewController.h"
#import "VVCommonKit.h"
#import "KVOViewController.h"

@interface VVRACViewController ()
<
myDelegate
>

@end

@implementation VVRACViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setRACSiganl];
    [self CreateRACSuject];
    [self setUpateUI];
    [self setRACSequence];
}

#pragma mark - ReactiveCocoa

#pragma mark - RACSignal,RACDisposable,RACSubscriber 
/*
 信号类 RACSignal 只是表示当数据改变时，信号内部会发出数据，它本身不具备发送信号的能力，而是交给内部
 一个RACSubscriber 订阅者发出。
 默认信号是冷信号，也就是值改变了，也不会触发，只有订阅了这个信号，这个信号才会变为热信号，值改变了才会触发。
 如何订阅信号：调用信号RACSignal的subscribeNext就能订阅。
 */

/* RACSignal使用步骤：
  1.创建信号，首先把didSubscribe保存到信号中，还不会触发。
  2.当信号被订阅，也就是调用signal的subscribeNext:nextBlock
  2.2 subscribeNext内部会创建订阅者subscriber，并且把nextBlock保存到subscriber中。
  2.1 subscribeNext内部会调用siganl的didSubscribe
  3.siganl的didSubscribe中调用[subscriber sendNext:@1];
  3.1 sendNext底层其实就是执行subscriber的nextBlock
 */
/*
 RACSignal底层实现：
 1.创建信号，首先把didSubscribe保存到信号中，还不会触发。
 2.当信号被订阅，也就是调用signal的subscribeNext:nextBlock.
 */

//RACSignal:信号类，一般表示将来有数据传递，只要有数据改变，信号内部接收到数据，就会马上发出数据。
//RACDisposable:用于取消订阅或者清理资源，当信号发送完成或者发送错误的时候，就会自动触发它。
//RACSubscriber:表示订阅者，用于发送信号，这是一个协议，不是类，只是遵守这个协议，并且实现方法才能成为订阅者。通过create创建的信号，都有一个订阅者，帮助他发送数据。

- (void) setRACSiganl{
    //信号创建
    RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        //首先把didSubscribe保存到信号中，还不会触发。
        [subscriber sendNext:@"保存信息"];
        [subscriber sendCompleted];
        return [RACDisposable disposableWithBlock:^{
            DLog(@"信号被销毁");
        }];
    }];
    
    //信号订阅
    //内部创建订阅者subscriber,并且把nextBlock保存到subscriber中。
    [signal subscribeNext:^(id x) {
        //sendNext底层其实就是执行subscriber的nextBlock
        DLog(@"接受到数据:%@",x);
    }];
}

#pragma mark - ARCSubject、RACReplaySubject
/*
 ARCSubject：信号提供者，自己可以充当信息，又能发送信号。代替代理，不必要定义代理。
 RACReplaySubject:重复提供信号类，RACSubject的子类。
*/

- (void) CreateRACSuject{
    //创建信号
    RACSubject *subject = [RACSubject subject];
    //订阅信号
    [subject subscribeNext:^(id x) {
        DLog(@"1订阅者%@",x);
    }];
    [subject subscribeNext:^(id x) {
        DLog(@"2订阅者%@",x);
    }];
    //发送信号
    [subject sendNext:@"hello"];
}
/*
 代替代理。
 需求1.给当前控制器添加一个按钮，modal到另一个控制器界面
    2.另一个控制器view中有个按钮，点击按钮，通知当前控制器（通知当前控制器，触发接受信息的另一个控制代理方法（block的定义））
 实现步骤：
 1.在第二个控制器.h 添加一个RACSubject代替代理
 2.监听第二个控制器按钮点击
 3.在第一个控制器中，监听跳转按钮，给第二个控制器的代理信号赋值，并且监听。
 */
- (void) setUpateUI{
    UIButton *sujectBtn = ({
        UIButton *view = [UIButton new];
        [self.view addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.equalTo(@100);
            make.width.height.equalTo(@80);
        }];
        view.titleLabel.text = @"RACSubject";
        view.backgroundColor = [UIColor yellowColor];
        view;
    });
    [sujectBtn addTarget:self action:@selector(pushKVOViewController) forControlEvents:UIControlEventTouchUpInside];
    
    UITextField *textField = ({
        UITextField *view = [UITextField new];
        [self.view addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(sujectBtn.mas_bottom).mas_offset(50);
            make.left.equalTo(sujectBtn.mas_left).mas_offset(50);
            make.width.equalTo(@80);
            make.height.equalTo(@30);
        }];
        view.backgroundColor = [UIColor yellowColor];
        view;
    });
    
    UILabel *label = ({
        UILabel *view = [UILabel new];
        [self.view addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(textField.mas_bottom).mas_offset(10);
            make.left.equalTo(textField.mas_left);
            make.width.equalTo(@80);
            make.height.equalTo(@30);
        }];
        view.backgroundColor = [UIColor grayColor];
        view;
    });
}
//跳转KVO控制器
- (void) pushKVOViewController{
    //方法一：block实现
    KVOViewController *vc = [[KVOViewController alloc] initWithComplete:^void (NSString *message) {
        DLog(@"%@",message);
    }];
    
    vc.delegate = self;
    
    //方法三：
    //设置代理信号
    vc.delegateSignal = [RACSubject subject];
    //订阅代理信号
    [vc.delegateSignal subscribeNext:^(id x) {
        DLog(@"%@",x);
    }];
    
    [self.navigationController pushViewController:vc animated:YES];
}
//方法二 代理实现
- (void) sendMesage:(NSString *)message{
    DLog(@"%@",message);
}

- (void) CreateRACSubject{
    //创建信号
    RACReplaySubject *replaySubject = [RACReplaySubject subject];
    //发送信号
    [replaySubject sendNext:@1];
    [replaySubject sendNext:@2];
    //订阅信号
    [replaySubject subscribeNext:^(id x) {
        DLog(@"第一个订阅者接收到的数据%@",x);
    }];
    
    [replaySubject subscribeNext:^(id x) {
        DLog(@"第二个订阅者接收到的数据%@",x);
    }];    
}

#pragma mark - RACTuple 元组类，类似NSArray，用来包装值。
#pragma mark - RACSequence 集合类，用于替代NSArray,NSDictionary使用来快速遍历数组和字典。

- (void) setRACSequence{
    //1.遍历数组
    NSArray *array = @[@1,@2,@3];
    // 这里其实是三步
    // 第一步: 把数组转换成集合RACSequence numbers.rac_sequence
    // 第二步: 把集合RACSequence转换RACSignal信号类,numbers.rac_sequence.signal
    // 第三步: 订阅信号，激活信号，会自动把集合中的所有值，遍历出来。
    [array.rac_sequence.signal subscribeNext:^(id x) {
        DLog(@"%@",x);
    }];
    //2.遍历字典，遍历出来的键值对会包装RACTuple(元组对象)
    NSDictionary *dictionary = @{@"name": @"vivi",@"age":@20};
    [dictionary.rac_sequence.signal subscribeNext:^(id x) {
        //解包元组，会把元组的值，按顺序给参数里面的变量赋值
        RACTupleUnpack(NSString *key,NSString *value) = x;
        
//        NSString *key = x[0];
//        NSString *value = x[1];
        
        DLog(@"%@ %@",key,value);
    }];
    
    //字典转模型
    // 3.1 OC写法
    /*
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"flags.plist" ofType:nil];
    
    NSArray *dictArr = [NSArray arrayWithContentsOfFile:filePath];
    
    NSMutableArray *items = [NSMutableArray array];
    
    for (NSDictionary *dict in dictArr) {
        FlagItem *item = [FlagItem flagWithDict:dict];
        [items addObject:item];
    }
    
    
    // 3.2 RAC写法
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"flags.plist" ofType:nil];
    
    NSArray *dictArr = [NSArray arrayWithContentsOfFile:filePath];
    
    NSMutableArray *flags = [NSMutableArray array];
    
    _flags = flags;
    
    // rac_sequence注意点：调用subscribeNext，并不会马上执行nextBlock，而是会等一会。
    [dictArr.rac_sequence.signal subscribeNext:^(id x) {
        // 运用RAC遍历字典，x：字典
        
        FlagItem *item = [FlagItem flagWithDict:x];
        
        [flags addObject:item];
        
    }];
    
    NSLog(@"%@",  NSStringFromCGRect([UIScreen mainScreen].bounds));
    
    
    // 3.3 RAC高级写法:
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"flags.plist" ofType:nil];
    
    NSArray *dictArr = [NSArray arrayWithContentsOfFile:filePath];
    // map:映射的意思，目的：把原始值value映射成一个新值
    // array: 把集合转换成数组
    // 底层实现：当信号被订阅，会遍历集合中的原始值，映射成新值，并且保存到新的数组里。
    NSArray *flags = [[dictArr.rac_sequence map:^id(id value) {
        
        return [FlagItem flagWithDict:value];
        
    }] array];
     */

}
#pragma mark - RACCommand:处理事件的类，可以把事件如何处理，事件中的数据如何传递，包装到这个类中，它可以很方便监控事件的执行过程。
//使用场景：监听按钮点击，网络请求。
- (void) setRACCommand{
    /*使用步骤：
     1.创建命令
     2.创建RACSignal
     3.执行命令
     */
    /*
     使用注意：
     1.signalBlock必须要返回一个信号，不能传nil.
     2.如果不想要传递信号，直接创建空的信号[RACSignal empty];
     3.RACCommand中信号如果数据传递完，必须调用[subscriber sendCompleted]，这时命令才会执行完毕，否则永远处于执行中。
     4.RACCommand需要被强引用，否则接收不到RACCommand中的信号，因此RACCommand中的信号是延迟发送的。
     */
    // 三、RACCommand设计思想：内部signalBlock为什么要返回一个信号，这个信号有什么用。
    // 1.在RAC开发中，通常会把网络请求封装到RACCommand，直接执行某个RACCommand就能发送请求。
    // 2.当RACCommand内部请求到数据的时候，需要把请求的数据传递给外界，这时候就需要通过signalBlock返回的信号传递了。
    
    // 四、如何拿到RACCommand中返回信号发出的数据。
    // 1.RACCommand有个执行信号源executionSignals，这个是signal of signals(信号的信号),意思是信号发出的数据是信号，不是普通的类型。
    // 2.订阅executionSignals就能拿到RACCommand中返回的信号，然后订阅signalBlock返回的信号，就能获取发出的值。
    
    // 五、监听当前命令是否正在执行executing
    
    // 六、使用场景,监听按钮点击，网络请求
    
    RACCommand *command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        DLog(@"执行命令");
        
        // 创建空信号,必须返回信号
        // return [RACSignal empty];
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            [subscriber sendNext:@"请求数据"];
            // 注意：数据传递完，最好调用sendCompleted，这时命令才执行完毕。
            [subscriber sendCompleted];
            
            return nil;
        }];
    }];
    
    // 强引用命令，不要被销毁，否则接收不到数据
//    _conmmand = command;
    
    // 3.订阅RACCommand中的信号

    [command.executionSignals subscribeNext:^(id x) {
        [x subscribeNext:^(id x) {
            
            NSLog(@"%@",x);
        }];
    }];
}

#pragma mark - RACMulticastConnection 用户当一个信号，被多次订阅时，为了保证创建信号时，避免多次调用创建信号中的block，造成副作用，可以使用这个类处理。
//注意：RACMulticastConnection通过RACSignal的-public或者-miticast方法创建

- (void) setRACMulticastConnection{
    
}

#pragma mark 常用方法：代理、KVO、监听事件、通知、监听文本框、
- (void) inCommonUseSelector{
    //代理：rac_signalForSelector
    [[self.view rac_signalForSelector:@selector(sendMesage:)] subscribeNext:^(id x) {
        NSLog(@"点击了");
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
