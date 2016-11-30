//
//  KVOViewController.h
//  Exotic
//
//  Created by HCZH on 16/10/17.
//  Copyright © 2016年 陈维维. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReactiveCocoa.h"

@protocol myDelegate <NSObject>

- (void) sendMesage:(NSString *)message;

@end

typedef void (^Complete)(NSString *string);

@interface KVOViewController : UIViewController

@property (nonatomic, weak) Complete complete;
@property (nonatomic, weak) id delegate;
@property (nonatomic, strong) RACSubject *delegateSignal;

- (instancetype)initWithComplete:(Complete)complete;

@end
