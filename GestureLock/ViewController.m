//
//  ViewController.m
//  GestureLock
//
//  Created by zhao on 16/6/20.
//  Copyright © 2016年 zhao. All rights reserved.
//

#import "ViewController.h"
#import "GestureLockViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.navigationItem.title = @"fuck";
}

- (IBAction)setGesturePassword:(UIButton *)sender
{
    //[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"pwd"];
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"pwd"])
    {
        NSLog(@"你已设置过手势密码了");
    }
    else
    {
        GestureLockViewController *gesVC = [[GestureLockViewController alloc] init];
        gesVC.type = GestureLockTypeSetPwd;
        [self.navigationController pushViewController:gesVC animated:YES];
    }
}

- (IBAction)setAgainGesturePassword:(id)sender
{
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"pwd"])
    {
        GestureLockViewController *gesVC = [[GestureLockViewController alloc] init];
        gesVC.type = GestureLockTypeResetPwd;
        [self.navigationController pushViewController:gesVC animated:YES];
    }
    else
    {
        NSLog(@"你还未设置手势密码");
    }
}

- (IBAction)forgetGesturePassword:(UIButton *)sender
{
    
}

@end
