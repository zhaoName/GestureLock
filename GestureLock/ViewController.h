//
//  ViewController.h
//  GestureLock
//
//  Created by zhao on 16/6/20.
//  Copyright © 2016年 zhao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, GestureLockType) {
    
    GestureLockTypeSetPwd = 0, /**<设置密码*/
    GestureLockTypeResetPwd,   /**<重置密码*/
    GestureLockTypeForgetPwd,  /**<忘记密码*/
};


@interface ViewController : UIViewController


@property (nonatomic, assign) GestureLockType type /**<忘记密码*/;


@end

