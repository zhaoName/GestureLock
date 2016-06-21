//
//  GestureView.h
//  GestureLock
//
//  Created by zhao on 16/6/20.
//  Copyright © 2016年 zhao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"

@interface GestureView : UIView

@property (nonatomic, assign)  GestureLockType lockType;


/**第一次设置密码*/
@property (nonatomic, strong) void(^setFirstPwd)(void);

/**确认密码*/
@property (nonatomic, strong) void(^setConfirmPwd)(void);

/** 两次输入的密码不一样*/
@property (nonatomic, strong) void(^twiceInputPwdIsUnEqual)(void);

/** 两次输入的密码一样*/
@property (nonatomic, strong) void(^twiceInputPwdIsEqual)(void);

/** 检验密码长度*/
@property (nonatomic, strong) void(^judgePwdLength)(void);




/**重置密码*/
@property (nonatomic, strong) void(^setNewPwd)(void);

/**忘记密码*/
@property (nonatomic, strong) void(^forgetPwd)(void);

@end
