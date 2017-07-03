//
//  TwoView.m
//  LinkageMenu
//
//  Created by 风间 on 2017/3/10.
//  Copyright © 2017年 EmotionV. All rights reserved.
//

#import "FoodListView.h"
#import "Store.h"
#import "OHMySQL.h"
#import "Menu.h"
#import "ShoppingCartObj.h"
#import "ShoppingCart.h"

// 屏幕宽度
#define _ScreenWidth    ([UIScreen mainScreen].bounds.size.width)

// 屏幕高度
#define _ScreenHeight   ([UIScreen mainScreen].bounds.size.height)
@interface FoodListView()<CAAnimationDelegate>

@property (strong, nonatomic)  NSMutableArray *storeArr;
@property (strong, nonatomic)  OHMySQLManager *manager;
@property (strong, nonatomic)  OHMySQLUser *sqlUser;
@property (nonatomic,strong) UIBezierPath *path;

@end

@implementation FoodListView{
    CALayer *_layer;
}

- (NSMutableArray *)storeArr{
    if (!_storeArr) {
        NSMutableArray *mArr = [NSMutableArray array];
        OHMySQLQuery *query = [[OHMySQLQuery alloc]initWithUser:self.sqlUser queryString:@"select * from store"];
        NSArray *arr = [self.manager executeSELECTQuery:query];
        
        query = [[OHMySQLQuery alloc]initWithUser:self.sqlUser queryString:@"select * from menu"];
        NSMutableArray *menuArr = [NSMutableArray arrayWithArray:[self.manager executeSELECTQuery:query]];
        
        for (int i = 0; i < arr.count; i ++) {
            Store *store = [[Store alloc] init];
            [store setValuesForKeysWithDictionary:arr[i]];
            NSMutableArray *tempArr = [NSMutableArray array];
            for (int j = 0; j < menuArr.count; j++) {
                Menu *menu = [[Menu alloc] init];
                [menu setValuesForKeysWithDictionary:menuArr[j]];
                if (menu.store_id == store.store_id) {
                    [tempArr addObject:menu];
                }
            }
            store.menuArr = tempArr;
            [mArr addObject:store];
        }
        _storeArr = mArr;
        
    }
    return _storeArr;
}

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    if (self = [super initWithFrame:frame style:style]) {
        self.delegate = self;
        self.dataSource = self;
        
        //链接数据库
        self.sqlUser = [[OHMySQLUser alloc]initWithUserName:@"root" password:@"3306" serverName:@"127.0.0.1" dbName:@"takeOut" port:3306 socket:nil];
        self.manager = [OHMySQLManager sharedManager];
        [self.manager connectWithUser:self.sqlUser];
        self.tableFooterView = [[UIView alloc] init];

        
    }
    return self;
}


#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    Store *store = self.storeArr[self.listTag];
    return store.menuArr.count;

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *storeCell = @"storeCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:storeCell];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:storeCell];
    }
    Store *store = self.storeArr[self.listTag];
    Menu *menu = store.menuArr[indexPath.row];
    cell.textLabel.text = menu.food_id;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"$%ld",(long)menu.price];
    cell.imageView.image = [UIImage imageNamed:menu.food_id];
    return cell;

}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    Store *store = self.storeArr[self.listTag];
    Menu *menu = store.menuArr[indexPath.row];
    UIAlertController *alterCon = [UIAlertController alertControllerWithTitle:@"" message:[NSString stringWithFormat:@"Do you want to pay $%ld for %@?",(long)menu.price,menu.food_id] preferredStyle:UIAlertControllerStyleAlert];
    [alterCon addAction:[UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        ShoppingCartObj *cartObj = [[ShoppingCartObj alloc] init];
        cartObj.store_name = store.store_name;
        cartObj.store_id = store.store_id;
        cartObj.food_name = menu.food_id;
        cartObj.price = menu.price;
        ShoppingCart *sc = [ShoppingCart shareInstance];
        [sc.shopCartList addObject:cartObj];
        NSInteger y = 30 + 70 * indexPath.row;
        [self foodAnimationWithImage:[UIImage imageNamed:menu.food_id] andImageCenter:CGPointMake(30, y)];
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
    CGPoint endPoint = CGPointMake(_ScreenWidth / 2 - 60, _ScreenHeight + 222);
    
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
