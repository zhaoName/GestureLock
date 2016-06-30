//
//  ViewController.m
//  GestureLock
//
//  Created by zhao on 16/6/20.
//  Copyright © 2016年 zhao. All rights reserved.
//

#import "ViewController.h"
#import "GestureLockViewController.h"

#define BtnWidth 100
#define BtnHeight 100

@interface ViewController ()

@property (nonatomic, strong) UIButton *btn;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.navigationItem.title = @"fuck";
    
    _btn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    _btn.frame = CGRectMake(10, 64, BtnWidth, BtnHeight);
    _btn.backgroundColor = [UIColor redColor];
    _btn.userInteractionEnabled = NO;
    
    [self.view addSubview:_btn];
    
    //动画
    [UIView animateWithDuration:10.0f delay:0.0 options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionAllowUserInteraction  animations:^{
        
        _btn.frame = CGRectMake(10, 480, BtnWidth, BtnHeight);
    } completion:^(BOOL finished) {
        
    }];
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    
    //获取鼠标点击的点
    CGPoint point = [touch locationInView:self.view];
    
    //获取移动中btn的位置   center
    CGPoint btnPoint = [[_btn.layer presentationLayer] position];
    //NSLog(@"%@", NSStringFromCGPoint(btnPoint));
    
    if(point.x < btnPoint.x + BtnWidth/2 && point.x > btnPoint.x - BtnWidth/2 && point.y < btnPoint.y + BtnHeight/2 && point.y > btnPoint.y - 50)
    {
        NSLog(@"点击了移动中的btn");
    }
}

/** 设置手势密码*/
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

/** 重置手势密码*/
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

/** 忘记手势密码*/
- (IBAction)forgetGesturePassword:(UIButton *)sender
{
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"pwd"])
    {
        GestureLockViewController *gesVC = [[GestureLockViewController alloc] init];
        gesVC.type = GestureLockTypeForgetPwd;
        [self.navigationController pushViewController:gesVC animated:YES];
    }
    else
    {
        NSLog(@"你还未设置手势密码");
    }
}


/** 清除手势密码*/
- (IBAction)cleanGesturePwd:(UIButton *)sender
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"pwd"];
}

@end
