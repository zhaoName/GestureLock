//
//  GestureView.m
//  GestureLock
//
//  Created by zhao on 16/6/20.
//  Copyright © 2016年 zhao. All rights reserved.
//

#import "GestureView.h"

#define ButtonCount 9
#define ButtonRowCount 3

@interface GestureView ()

/** 选中的按钮*/
@property (nonatomic, strong) NSMutableArray *selectButtons;
/** 临时密码*/
@property (nonatomic, strong) NSMutableString *passwordStr;
/** 正确的密码*/
@property (nonatomic, strong) NSString *rightPwdStr;

@end

@implementation GestureView



- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        self.backgroundColor = [UIColor lightGrayColor];
        [self createGestureButton];
    }
    return self;
}

/** 创建9个按钮*/
- (void)createGestureButton
{
    for(int i=0; i<ButtonCount; i++)
    {
        UIButton * gesturebutton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        //注意这里一定取消button的交互事件，不然button盖在view上，touch view就不会反应
        gesturebutton.userInteractionEnabled = NO;
        gesturebutton.tag = i;
        
        //正常状态button的背景图片
        [gesturebutton setBackgroundImage:[UIImage imageNamed:@"gesture_node_normal"] forState:UIControlStateNormal];
        //选中状态button的背景图片
        [gesturebutton setBackgroundImage:[UIImage imageNamed:@"gesture_node_highlighted"] forState:UIControlStateSelected];
        
        [self addSubview:gesturebutton];
    }
}

/** 设置9个按钮的frame*/
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    for(int i=0; i<self.subviews.count; i++)
    {
        UIButton *button = self.subviews[i];
        
        //计算button之间的间距
        CGFloat intervalWidth = (self.frame.size.width - 74*ButtonRowCount) / (ButtonRowCount + 1);
        CGFloat intervalHeigth = intervalWidth;
        
        //此button所在的行
        int row = i / ButtonRowCount;
        //此button所在的列
        int column = i % ButtonRowCount;
        
        //此button的X值
        CGFloat buttonX = intervalWidth + column * (74 + intervalWidth);
        //此button的Y值
        CGFloat buttonY = intervalHeigth + row * (74 + intervalHeigth);
        
        button.frame = CGRectMake(buttonX, buttonY, 74, 74);
    }
}

#pragma mark -- touch事件
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if(self.lockType == GestureLockTypeSetPwd)
    {
        //第一次设置密码
        if(![[NSUserDefaults standardUserDefaults] objectForKey:@"pwd"])
        {
            self.setFirstPwd();
        }
        else //确认密码
        {
            self.setConfirmPwd();
        }
    }
    else if(self.lockType == GestureLockTypeResetPwd)
    {
        self.VerifyOldPwdBeforeSetNewPwd(@"请输入旧密码");
    }
    else if(self.lockType == GestureLockTypeForgetPwd)
    {
        
    }
    
    [self touchesMoved:touches withEvent:event];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint touchLocation = [touch locationInView:touch.view];
    
    //NSLog(@"%@", NSStringFromCGPoint(touchLocation));
    
    for(UIButton *gesButton in self.subviews)
    {
        //若滑动时碰到此按钮
        if(CGRectContainsPoint(gesButton.frame, touchLocation))
        {
            gesButton.selected = YES;
            
            //若没有重复碰到同一个按钮
            if(![self.selectButtons containsObject:gesButton])
            {
                [self.selectButtons addObject:gesButton];
                //记录点击过的button
                [self.passwordStr appendString:[NSString stringWithFormat:@"%lu", gesButton.tag]];
            }
        }
    }
    //开始画线
    [self setNeedsDisplay];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self slideEndDealGesturePwd];
}

#pragma mark -- 当滑动结束时对密码的一些处理

/** 当滑动结束时对密码的一些处理*/
- (void)slideEndDealGesturePwd
{
    if(self.passwordStr.length != 0)  [self checkGesturePwd];
    
    for(UIButton *button in self.selectButtons)
    {
        //去除已选中button的选中状态
        button.selected = NO;
    }
    
    //清除记录的所点击的轨迹
    self.passwordStr = nil;
    
    //清除已选中的button
    [self.selectButtons removeAllObjects];
    
    //去除红色线
    [self setNeedsDisplay];
}

/** 验证手势密码*/
- (void)checkGesturePwd
{
    //选中的按钮应该超过3个
    if(self.selectButtons.count <= 3)
    {
        self.judgePwdLength();
        return;
    }
    if(self.lockType == GestureLockTypeSetPwd)
    {
        [self setupPwd];
    }
    else if(self.lockType == GestureLockTypeResetPwd)
    {
        //若NSUserDefaults不为空，则说明是在验证旧密码
        if([[NSUserDefaults standardUserDefaults] objectForKey:@"pwd"])
        {
            if([self.passwordStr isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:@"pwd"]])
            {
                self.setNewPwd();
            }
            else
            {
                self.VerifyOldPwdBeforeSetNewPwd(@"输入的旧密码有误");
            }
        }
        else //若NSUserDefaults为空，则说明验证旧密码成功，要设置新密码
        {
            [self setupPwd];
        }
    }
    else if(self.lockType == GestureLockTypeForgetPwd)
    {
        
    }
}

/** 处理密码*/
- (void)setupPwd
{
    //判断两次输入的密码
    if(self.rightPwdStr.length == 0)
    {
        //记录第一次的密码
        self.rightPwdStr = self.passwordStr;
    }
    else
    {
        if([self.rightPwdStr isEqualToString:self.passwordStr])
        {
            self.twiceInputPwdIsEqual(); //一样
            //若两次一样 则存储手势密码
            [[NSUserDefaults standardUserDefaults] setObject:self.rightPwdStr forKey:@"pwd"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        else
        {
            self.twiceInputPwdIsUnEqual();//不一样
        }
    }
    NSLog(@"%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"pwd"]);
}

#pragma mark -- 将点击的button用线连接起来

- (void)drawRect:(CGRect)rect
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    for(int i=0; i<self.selectButtons.count; i++)
    {
        UIButton *button = self.selectButtons[i];
        if(i == 0)
        {
            [path moveToPoint:button.center];//起点
        }
        else
        {
            [path addLineToPoint:button.center];//终点
        }
    }
    //线的颜色
    [[UIColor redColor] setStroke];
    //线宽
    [path setLineWidth:12.0];
    //线的样式（有圆角）
    [path setLineCapStyle:kCGLineCapRound];
    //连接处线的样式
    [path setLineJoinStyle:kCGLineJoinRound];
    //画线
    [path stroke];
}

#pragma mark -- setter getter

- (NSMutableArray *)selectButtons
{
    if(!_selectButtons)
    {
        _selectButtons = [[NSMutableArray alloc] init];
    }
    return _selectButtons;
}

- (NSMutableString *)passwordStr
{
    if(!_passwordStr)
    {
        _passwordStr = [[NSMutableString alloc] init];
    }
    return _passwordStr;
}

- (NSString *)rightPwdStr
{
    if(!_rightPwdStr)
    {
        _rightPwdStr = [NSString string];
    }
    return _rightPwdStr;
}

@end
