//
//  PushViewController.m
//  GestureLock
//
//  Created by zhao on 16/6/21.
//  Copyright © 2016年 zhao. All rights reserved.
//

#import "PushViewController.h"

@interface PushViewController ()

@end

@implementation PushViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"解锁成功";
    
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(50, 100, 250, 100)];
    label.text =@"嘿，fuck！你已经成为解锁专家了";
    
    label.font = [UIFont systemFontOfSize:21];
    
    label.textColor = [UIColor redColor];
    
    label.textAlignment = NSTextAlignmentCenter;
    
    label.numberOfLines = 0;
    
    [self.view addSubview:label];
}



@end
