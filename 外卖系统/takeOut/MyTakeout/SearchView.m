//
//  SearchView.m
//  takeOut
//
//  Created by Yuexi on 2017/6/25.
//  Copyright © 2017年 Yuexi. All rights reserved.
//

#import "SearchView.h"
#import "ShoppingCartObj.h"
#import "ShoppingCart.h"

// 屏幕宽度
#define _ScreenWidth    ([UIScreen mainScreen].bounds.size.width)

// 屏幕高度
#define _ScreenHeight   ([UIScreen mainScreen].bounds.size.height)
@interface SearchView()<CAAnimationDelegate>
@property (nonatomic,strong) UIBezierPath *path;
@end

@implementation SearchView{
    CALayer *_layer;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {

        self.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.9];

        UILongPressGestureRecognizer* recognizer;
        recognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom)];
        [self addGestureRecognizer:recognizer];
        UIView *bv = [[UIView alloc] init];
        bv.backgroundColor = [UIColor clearColor];
        self.tableFooterView = bv;
        
        self.delegate = self;
        self.dataSource = self;

    }
    return self;
}



- (void)handleSwipeFrom{
    NSLog(@"11");
    [self removeFromSuperview];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"---%ld",self.menuArr.count);
    return self.menuArr.count;
    
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *shopCartCell = @"shopCartCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:shopCartCell];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:shopCartCell];
    }
    ShoppingCartObj *cartObj = self.menuArr[indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ --%@",cartObj.food_name,cartObj.store_name];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"$%ld",cartObj.price];
    cell.imageView.image = [UIImage imageNamed:cartObj.food_name];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ShoppingCartObj *menu = self.menuArr[indexPath.row];
    UIAlertController *alterCon = [UIAlertController alertControllerWithTitle:@"" message:[NSString stringWithFormat:@"Do you want to pay $%ld for %@?",(long)menu.price,menu.food_name] preferredStyle:UIAlertControllerStyleAlert];
    [alterCon addAction:[UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        ShoppingCart *sc = [ShoppingCart shareInstance];
        [sc.shopCartList addObject:menu];
        NSInteger y = 30 + 70 * indexPath.row;
        [self foodAnimationWithImage:[UIImage imageNamed:menu.food_name] andImageCenter:CGPointMake(30, y)];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"kShopingCarNotification" object:nil];
    }]];
    [alterCon addAction:[UIAlertAction actionWithTitle:@"CANCLE" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [self.window.rootViewController presentViewController:alterCon animated:YES completion:^{
        
    }];
}

- (void)foodAnimationWithImage:(UIImage *)img andImageCenter:(CGPoint)imgCenter{
    // 获取传递的位置 , 起始点
    CGPoint startPoint = imgCenter;
    
    // 通过起始点计算 控制点
    CGPoint controlPoint = CGPointMake(_ScreenWidth / 2, startPoint.y - 80);
    
    // 终点
    CGPoint endPoint = CGPointMake(_ScreenWidth / 2 + 120, _ScreenHeight + 222);
    
    // 实例化imageView
    UIImageView *iconImage = [[UIImageView alloc] init];
    
    [iconImage setImage:img];
    
    _layer = [CALayer layer];
    _layer.contents = (id)iconImage.layer.contents;
    
    _layer.contentsGravity = kCAGravityResizeAspectFill;
    _layer.bounds = CGRectMake(0, 0, 100, 100);
    [_layer setCornerRadius:CGRectGetHeight([_layer bounds]) / 2];
    _layer.masksToBounds = YES;
    // 原View中心点
    _layer.position = imgCenter;
    [self.layer addSublayer:_layer];
    self.path = [UIBezierPath bezierPath];
    // 起点
    [_path moveToPoint:_layer.position];
    [_path addQuadCurveToPoint:endPoint controlPoint:controlPoint];
    
    
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    animation.path = _path.CGPath;
    animation.rotationMode = kCAAnimationRotateAuto;
    CABasicAnimation *expandAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    expandAnimation.duration = 0.5f;
    expandAnimation.fromValue = [NSNumber numberWithFloat:1];
    expandAnimation.toValue = [NSNumber numberWithFloat:2.0f];
    expandAnimation.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    
    CABasicAnimation *narrowAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    narrowAnimation.beginTime = 0.5;
    narrowAnimation.fromValue = [NSNumber numberWithFloat:2.0f];
    narrowAnimation.duration = 1.5f;
    narrowAnimation.toValue = [NSNumber numberWithFloat:0.3f];
    
    narrowAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    CAAnimationGroup *groups = [CAAnimationGroup animation];
    groups.animations = @[animation,expandAnimation,narrowAnimation];
    groups.duration = 2.0f;
    groups.removedOnCompletion=NO;
    groups.fillMode=kCAFillModeForwards;
    groups.delegate = self;
    
    animation.removedOnCompletion = NO;
    
    animation.fillMode = kCAFillModeBoth;
    
    [_layer addAnimation:groups forKey:@"group"];
}


@end
