//
//  SYTipInterdictView.m
//  SYTip
//
//  Created by xzineiw on 16-1-8.
//  Copyright © 2016 yx.com. All rights reserved.
//

#import "SYTipInterdictView.h"
#import "SYTipConst.h"

static SYTipInterdictView *syTipInterdictView = nil;

@interface SYTipInterdictView ()

@property (nonatomic, assign) BOOL isDisplaying;            //限制不能重复点
@property (nonatomic, strong) UIButton *interdictButton;    // 限制弹出tips无法点击背景

@end

@implementation SYTipInterdictView

+ (SYTipInterdictView *)shareInstance
{
    static dispatch_once_t oneceToken;
    dispatch_once(&oneceToken, ^{
        syTipInterdictView = [[[self class] alloc] init];
    });
    return syTipInterdictView;
}

- (id)init
{
    self = [super init];
    if (self) {
        if (_interdictButton == nil) {
            UIWindow *keyWindow = GetKeyWindow;
            _interdictButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, keyWindow.rootViewController.view.bounds.size.width, keyWindow.rootViewController.view.bounds.size.height)];
            _interdictButton.center = CGPointMake(keyWindow.rootViewController.view.bounds.size.width * 0.5, keyWindow.rootViewController.view.bounds.size.height * 0.5);
            _interdictButton.backgroundColor = [UIColor clearColor];
        }
    }
    return self;
}

#pragma mark - 显示正确信息提示

- (void)showSuccessTipWithText:(NSString *)tipText
{
    [super showSuccessTipWithText:tipText];
}

#pragma mark - 显示错误信息提示

- (void)showErrorTipWithText:(NSString *)tipText
{
    [super showErrorTipWithText:tipText];
}

#pragma mark - 开始提示
- (void)startWithText:(NSString *)tipText;
{
    
    [super startWithText:tipText];
    
    if (_isDisplaying && _interdictButton.superview != nil)
        return;
    _isDisplaying = YES;
    
    UIWindow *keyWindow = GetKeyWindow;
    
    _interdictButton.center = CGPointMake(keyWindow.rootViewController.view.bounds.size.width * 0.5f, keyWindow.rootViewController.view.bounds.size.height * 0.5f);
    [_interdictButton setBackgroundColor:[UIColor clearColor]];
    
    [keyWindow.rootViewController.view addSubview:_interdictButton];
}

#pragma mark - 关闭有回调的成功提示
- (void)dismissSuccessWithText:(NSString *)tipText block:(void(^)())action
{
    [super dismissSuccessWithText:tipText block:action];
    [self performSelector:@selector(removeInterdictButton:) withObject:nil afterDelay:1.0];
}

#pragma mark - 关闭有回调的失败提示
- (void)dismissErrorWithText:(NSString *)tipText block:(void(^)())action
{
    [super dismissErrorWithText:tipText block:action];
    [self performSelector:@selector(removeInterdictButton:) withObject:nil afterDelay:1.0];
}

- (void)removeSuccessTipView {
    [super removeSuccessTipView];
    [self removeInterdictButton:nil];
}

- (void)removeErrorTipView {
    [super removeErrorTipView];
    [self removeInterdictButton:nil];
}

- (void)removeInterdictButton:(id)sender {
    if (_interdictButton.superview != nil) {
        [_interdictButton removeFromSuperview];
    }
}

@end
