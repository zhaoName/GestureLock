//
//  GestureLockViewController.m
//  GestureLock
//
//  Created by zhao on 16/6/20.
//  Copyright © 2016年 zhao. All rights reserved.
//

#import "GestureLockViewController.h"
#import "GestureView.h"
#import "PushViewController.h"
#import "CALayer+Shake.h"

#define WIDTH self.view.frame.size.width
#define HEIGTH self.view.frame.size.height

@interface GestureLockViewController ()

@property (nonatomic, strong) GestureView *gestureView;
@property (nonatomic, strong) UILabel *tipLabel;

@end

@implementation GestureLockViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.title = @"设置手势密码";
    
    [self.view addSubview:self.tipLabel];
    [self.view addSubview:self.gestureView];
    
    [self showLabelTextAndDealEvent];
}

/** 随着设置密码label显示不同数据 且处理相关事件*/
- (void)showLabelTextAndDealEvent
{
    __weak typeof(self) weakSelf = self;
    
    /*****  设置密码  ********/
    self.gestureView.setFirstPwd = ^(void)
    {
       [weakSelf showNormalLabel:@"请滑动设置手势密码"];
    };
    
    self.gestureView.setConfirmPwd = ^(void)
    {
        [weakSelf showNormalLabel:@"请再次滑动确认手势密码"];
    };
    
    self.gestureView.judgePwdLength = ^(void)
    {
        [weakSelf showLabelShake:@"密码长度应该大于3"];
    };
    
    self.gestureView.twiceInputPwdIsUnEqual = ^(void)
    {
        [weakSelf showLabelShake:@"两次输入的密码不一样"];
        
        //导航栏右上角按钮
        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"重设" style:UIBarButtonItemStylePlain target:weakSelf action:@selector(resetPwd)];
        
        weakSelf.navigationItem.rightBarButtonItem = rightItem;
    };
    
    self.gestureView.twiceInputPwdIsEqual = ^(void)
    {
        [weakSelf showNormalLabel:@"密码设置成功"];
        
        //延迟1秒钟跳转到下一个界面
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            PushViewController *pushVC = [[PushViewController alloc] init];
            
            [weakSelf.navigationController pushViewController:pushVC animated:YES];
        });
    };
    
    
     /*****  重置密码  ********/
    self.gestureView.VerifyOldPwdBeforeSetNewPwd = ^(NSString *message)
    {
        [weakSelf showLabelShake:message];
    };
    
    self.gestureView.setNewPwd = ^()
    {
        [weakSelf showNormalLabel:@"请滑动设置新的手势密码"];
        
        //删除以前的旧密码
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"pwd"];
    };
    
    
     /*****  忘记密码  ********/
    
}

/**重设密码*/
- (void)resetPwd
{
    self.navigationItem.rightBarButtonItem = nil;
    
    [self showNormalLabel:@"请重新输入密码"];
    
    //第一次输入的密码没有存储，so重设密码时应该把第一次正确的密码清除
    self.gestureView.rightPwdStr = nil;
}


#pragma mark -- 显示label内容

- (void)showNormalLabel:(NSString *)labelStr
{
    self.tipLabel.text = labelStr;
    self.tipLabel.textColor = [UIColor blackColor];
}

- (void)showLabelShake:(NSString *)labelStr
{
    self.tipLabel.text = labelStr;
    self.tipLabel.textColor = [UIColor redColor];
    [self.tipLabel.layer shake];
}

#pragma mark -- setter或getter

- (GestureView *)gestureView
{
    if(!_gestureView)
    {
        _gestureView = [[GestureView alloc] initWithFrame:CGRectMake(0, 164, WIDTH, HEIGTH - 200 - 64)];
    }
    return _gestureView;
}

- (UILabel *)tipLabel
{
    if(!_tipLabel)
    {
        _tipLabel = [[UILabel alloc] initWithFrame:CGRectMake((WIDTH-200)/2, 94, 200, 21)];
        //居中
        _tipLabel.textAlignment = NSTextAlignmentCenter;
        //点击不同按钮显示不同内容
        if(self.type == GestureLockTypeSetPwd)
        {
            [self showNormalLabel:@"请滑动设置手势密码"];
            self.gestureView.lockType = GestureLockTypeSetPwd;
        }
        else if (self.type == GestureLockTypeResetPwd)
        {
            [self showNormalLabel:@"请输入旧密码"];
            self.gestureView.lockType = GestureLockTypeResetPwd;
        }
        else
        {
            [self showNormalLabel:@""];
            self.gestureView.lockType = GestureLockTypeForgetPwd;
        }
    }
    return _tipLabel;
}

@end
