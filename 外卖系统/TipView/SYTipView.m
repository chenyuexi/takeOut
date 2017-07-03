//
//  SYTipView.m
//  SYTip
//
//  Created by xzineiw on 16-1-8.
//  Copyright © 2016 yx.com. All rights reserved.
//

#import "SYTipView.h"
#import "SYTipConst.h"
#define VERSION_FLOAT [[[UIDevice currentDevice] systemVersion] floatValue]
static SYTipView *syTipView = nil;

@interface SYTipView ()

@property (nonatomic, strong) UIView *tipBgView;
@property (nonatomic, strong) UILabel *tipTextLabel;
@property (nonatomic, strong) UIImageView *rightImageView;
@property (nonatomic, strong) UIImageView *wrongImageView;
@property (nonatomic, strong) UIViewController *tipViewController;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicatorView;

@property (nonatomic, assign) BOOL isDisplaying;    //限制不能重复点

@end

@implementation SYTipView

+ (SYTipView *)shareInstance
{
    static dispatch_once_t oneceToken;
    dispatch_once(&oneceToken, ^{
        syTipView = [[[self class] alloc] init];
    });
    return syTipView;
}

#pragma mark - 初始化

- (id)init
{
    self = [super init];
    
    if (self)
    {
        UIWindow *keyWindow = GetKeyWindow;
        
        if (_tipViewController == nil)
        {
            _tipViewController = [[UIViewController alloc] init];
            [_tipViewController.view setFrame:CGRectMake(0, 0, TIPVIEW_WIDTH, TIPVIEW_HEIGHT)];
            _tipViewController.view.center = CGPointMake(keyWindow.rootViewController.view.bounds.size.width * 0.5f,
                                                         keyWindow.rootViewController.view.bounds.size.height * 0.5f);
            _tipViewController.view.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin  |
                                                       UIViewAutoresizingFlexibleRightMargin |
                                                       UIViewAutoresizingFlexibleTopMargin   |
                                                       UIViewAutoresizingFlexibleBottomMargin;
        }
        
        if (_activityIndicatorView == nil)
        {
            _activityIndicatorView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0 , 0,
                                                                                               TIPVIEW_WIDTH,
                                                                                               TIPVIEW_HEIGHT)];
            _activityIndicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
            _activityIndicatorView.backgroundColor = [UIColor lightGrayColor];
			//_activityIndicatorView.alpha = 0.9;
            _activityIndicatorView.layer.cornerRadius = 4;
        }
        
        if (_tipBgView == nil)
        {
            _tipBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, TIPVIEW_WIDTH, TIPVIEW_HEIGHT)];
            _tipBgView.layer.cornerRadius = 4;
            _tipBgView.backgroundColor = [UIColor lightGrayColor];
			//_tipBgView.alpha = 0.9;
        }

        if (_rightImageView == nil)
        {
			UIImage * image = [UIImage imageNamed:SYTipsResSrcName(@"SY_arrow.png")];
            _rightImageView = [[UIImageView alloc] initWithImage:image];
            [_rightImageView setFrame:CGRectMake(0, 0, TIPIMAGEVIEW_WIDTH, TIPIMAGEVIEW_WIDTH)];
            _rightImageView.center = CGPointMake(_tipViewController.view.bounds.size.width / 2,
                                                 _tipViewController.view.bounds.size.height / 2);
			//_rightImageView.alpha = 0.75;
        }
        
        if (_wrongImageView== nil)
        {
			UIImage * image = [UIImage imageNamed:SYTipsResSrcName(@"SY_wrong.png")];
            _wrongImageView = [[UIImageView alloc] initWithImage:image];
            [_wrongImageView setFrame:CGRectMake(0, 0, TIPIMAGEVIEW_WIDTH, TIPIMAGEVIEW_WIDTH)];
            _wrongImageView.center = CGPointMake(_tipViewController.view.bounds.size.width / 2,
                                                 _tipViewController.view.bounds.size.height / 2);
        }
    }
    return self;
}

#pragma mark - 构造TipTextView

- (void)createTipTextView:(NSString *)tipText
{
    if (_tipTextLabel)
    {
        [_tipTextLabel removeFromSuperview];
        _tipTextLabel = nil;
    }
	
    //文字提示
	CGSize size, sizeModel;
	UIFont * font = [UIFont boldSystemFontOfSize:13];
	if (VERSION_FLOAT >= 7.0 && [tipText respondsToSelector:@selector(sizeWithAttributes:)])
    {
		size = [tipText sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil]];
		sizeModel = [@"成功" sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil]];
	}
    else if ([tipText respondsToSelector:@selector(sizeWithFont:constrainedToSize:lineBreakMode:)])
    {
		size = [tipText sizeWithFont:font constrainedToSize:CGSizeMake(TIPVIEW_WIDTH, TIPVIEW_HEIGHT)
								 lineBreakMode:NSLineBreakByWordWrapping];
        
		sizeModel = [@"成功" sizeWithFont:font constrainedToSize:CGSizeMake(TIPVIEW_WIDTH, TIPVIEW_HEIGHT)
						  lineBreakMode:NSLineBreakByWordWrapping];;
	}

	NSInteger line = size.width / ([[NSNumber numberWithFloat:TIPVIEW_WIDTH] intValue] - 4) + 1;
	
	if (line > 1)
    {
		_rightImageView.center = CGPointMake(_rightImageView.center.x, TIPVIEW_WIDTH/2.0 + (line -1) * sizeModel.height);
		_wrongImageView.center = CGPointMake(_wrongImageView.center.x, TIPVIEW_WIDTH/2.0 + (line -1) * sizeModel.height);
	}
    else
    {
		_rightImageView.center = CGPointMake(_rightImageView.center.x, TIPVIEW_HEIGHT/2.0);
		_wrongImageView.center = CGPointMake(_wrongImageView.center.x, TIPVIEW_HEIGHT/2.0);
	}
    
    _tipTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(0 ,
                                                              TIPVIEW_WIDTH/4.0 - TIPIMAGEVIEW_WIDTH/4.0 - sizeModel.height/2.0,
                                                              TIPVIEW_WIDTH - 4,
                                                              line * sizeModel.height)];
	
    _tipTextLabel.textAlignment = NSTextAlignmentCenter;
    _tipTextLabel.font = font;
    _tipTextLabel.backgroundColor = [UIColor clearColor];
    _tipTextLabel.textColor = [UIColor whiteColor];
    _tipTextLabel.userInteractionEnabled = NO;
    _tipTextLabel.text = tipText;
	_tipTextLabel.lineBreakMode = NSLineBreakByWordWrapping;
	_tipTextLabel.numberOfLines = line;
}

#pragma mark - 显示正确信息提示

- (void)showSuccessTipWithText:(NSString *)tipText
{
    if (_isDisplaying)
    {
        return;
    }
    _isDisplaying = YES;
    UIWindow *keyWindow = GetKeyWindow;
    
    _tipViewController.view.center = CGPointMake(keyWindow.rootViewController.view.bounds.size.width  * 0.5f,
                                                 keyWindow.rootViewController.view.bounds.size.height * 0.5f);
    [_tipBgView addSubview:_rightImageView];
    [self createTipTextView:tipText];
    [_tipBgView addSubview:_tipTextLabel];
    [_tipViewController.view addSubview:_tipBgView];
    
//    [keyWindow.rootViewController.view addSubview:_tipViewController.view];
    
    [[self appRootViewController].view addSubview:_tipViewController.view];

	
    
    _tipViewController.view.alpha = 0.0f;
	
	//开始动画
	[UIView beginAnimations:nil context:nil];
	//设定动画持续时间
	[UIView setAnimationDuration:0.15f];
	//动画的内容
	_tipViewController.view.alpha = 1.0f;
	//动画结束
	[UIView commitAnimations];
	
	_rightImageView.alpha = 0.0f;
	//开始动画
	[UIView beginAnimations:nil context:nil];
	//设定动画持续时间
	[UIView setAnimationDuration:0.45f];
	//动画的内容
	_rightImageView.alpha = 1.0f;
	//动画结束
	[UIView commitAnimations];
    
    [self performSelector:@selector(removeSuccessTipView) withObject:nil afterDelay:0.6];
}

- (void)removeSuccessTipView
{
    [_rightImageView removeFromSuperview];
    [_tipTextLabel removeFromSuperview];
    _tipTextLabel = nil;
    [_tipBgView removeFromSuperview];
    [_tipViewController.view removeFromSuperview];
    
    _isDisplaying = NO;
}

#pragma mark - 显示错误信息提示

- (void)showErrorTipWithText:(NSString *)tipText
{
    if (_isDisplaying)
    {
        return;
    }
    _isDisplaying = YES;
    UIWindow *keyWindow = GetKeyWindow;
    
    _tipViewController.view.center = CGPointMake(keyWindow.rootViewController.view.bounds.size.width  * 0.5f,
                                                 keyWindow.rootViewController.view.bounds.size.height * 0.5f);
    
    [_tipBgView addSubview:_wrongImageView];
    [self createTipTextView:tipText];
    [_tipBgView addSubview:_tipTextLabel];
    [_tipViewController.view addSubview:_tipBgView];
	
	_wrongImageView.alpha = 0.0f;
	//开始动画
	[UIView beginAnimations:nil context:nil];
	//设定动画持续时间
	[UIView setAnimationDuration:0.45f];
	//动画的内容
	_wrongImageView.alpha = 1.0f;
	//动画结束
	[UIView commitAnimations];
    
//    [keyWindow.rootViewController.view addSubview:_tipViewController.view];
    
    [[self appRootViewController].view addSubview:_tipViewController.view];
    
    [self performSelector:@selector(removeErrorTipView) withObject:nil afterDelay:0.6];
}



- (void)removeErrorTipView
{
    [_wrongImageView removeFromSuperview];
    [_tipTextLabel removeFromSuperview];
    _tipTextLabel = nil;
    [_tipBgView removeFromSuperview];
    [_tipViewController.view removeFromSuperview];
    
    _isDisplaying = NO;
}

#pragma mark - 开始提示

- (void)startWithText:(NSString *)tipText;
{
    if (_isDisplaying)
    {
        return;
    }
    _isDisplaying = YES;
    UIWindow *keyWindow = GetKeyWindow;
    
    _tipViewController.view.center = CGPointMake(keyWindow.rootViewController.view.bounds.size.width  * 0.5f,
                                                 keyWindow.rootViewController.view.bounds.size.height * 0.5f);
    [_tipViewController.view addSubview:_activityIndicatorView];

    [self createTipTextView:tipText];
    [_tipViewController.view addSubview:_tipTextLabel];
    [[self appRootViewController].view addSubview:_tipViewController.view];
//    [keyWindow.rootViewController.view addSubview:_tipViewController.view];
    [_activityIndicatorView startAnimating];
}

#pragma mark - 关闭有回调的成功提示

- (void)dismissSuccessWithText:(NSString *)tipText block:(void(^)())action
{
    [_activityIndicatorView stopAnimating];
    [_activityIndicatorView removeFromSuperview];
    
    [_tipBgView addSubview:_rightImageView];
	
    [_tipTextLabel removeFromSuperview];
    _tipTextLabel = nil;
    [self createTipTextView:tipText];
    [_tipBgView addSubview:_tipTextLabel];
    
    [_tipViewController.view addSubview:_tipBgView];
	
	_rightImageView.alpha = 0.0f;
	//开始动画
	[UIView beginAnimations:nil context:nil];
	//设定动画持续时间
	[UIView setAnimationDuration:0.45f];
	//动画的内容
	_rightImageView.alpha = 1.0f;
	//动画结束
	[UIView commitAnimations];
    
    dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, 0.6 * NSEC_PER_SEC);
    dispatch_after(time, dispatch_get_main_queue(), ^{
        
        [_tipTextLabel removeFromSuperview];
        _tipTextLabel = nil;
        [_rightImageView removeFromSuperview];
        [_tipBgView removeFromSuperview];
        [_tipViewController.view removeFromSuperview];

        if (action)
        {
            action();
        }
        
        _isDisplaying = NO;
    });
}

- (void)removeSuccessTipViewAction:(void(^)())action
{
    [_tipTextLabel removeFromSuperview];
    _tipTextLabel = nil;
    [_rightImageView removeFromSuperview];
    [_tipBgView removeFromSuperview];
    [_tipViewController.view removeFromSuperview];
    action();
    
    _isDisplaying = NO;
}

#pragma mark - 关闭有回调的失败提示

- (void)dismissErrorWithText:(NSString *)tipText block:(void(^)())action
{
    [_activityIndicatorView stopAnimating];
    [_activityIndicatorView removeFromSuperview];
    
    [_tipBgView addSubview:_wrongImageView];
	
    [_tipTextLabel removeFromSuperview];
    _tipTextLabel = nil;
    
    [self createTipTextView:tipText];
    [_tipBgView addSubview:_tipTextLabel];
    
    [_tipViewController.view addSubview:_tipBgView];
	
	_wrongImageView.alpha = 0.0f;
	//开始动画
	[UIView beginAnimations:nil context:nil];
	//设定动画持续时间
	[UIView setAnimationDuration:0.45f];
	//动画的内容
	_wrongImageView.alpha = 1.0f;
	//动画结束
	[UIView commitAnimations];
	
    dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, 0.6 * NSEC_PER_SEC);
    dispatch_after(time, dispatch_get_main_queue(), ^{
        
        [_tipTextLabel removeFromSuperview];
        _tipTextLabel = nil;
        [_wrongImageView removeFromSuperview];
        [_tipBgView removeFromSuperview];
        [_tipViewController.view removeFromSuperview];
        
        action();
        
        _isDisplaying = NO;
    });
}

- (void)removeErrorTipViewAction:(void(^)())action
{
    [_tipTextLabel removeFromSuperview];
    _tipTextLabel = nil;
    [_wrongImageView removeFromSuperview];
    [_tipBgView removeFromSuperview];
    [_tipViewController.view removeFromSuperview];
    action();
    
    _isDisplaying = NO;
}

- (void)dismissSuccessWithText:(NSString *)tipText
{
    [self dismissSuccessWithText:tipText block:^{}];
}

- (UIViewController *)appRootViewController
{
    UIViewController *appRootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *topVC = appRootVC;
    while (topVC.presentedViewController) {
        topVC = topVC.presentedViewController;
    }
    return topVC;
}

@end
