//
//  ShopCartFooterView.h
//  takeOut
//
//  Created by Yuexi on 2017/6/18.
//  Copyright © 2017年 Yuexi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShopCartFooterView : UITableViewHeaderFooterView

@property (weak, nonatomic) IBOutlet UILabel *totalPrice;
@property (copy, nonatomic)  void(^clickFinishBlock)(NSMutableArray *shopCartArr);
@property (assign, nonatomic)  NSInteger needMoney;
@property (assign, nonatomic)  NSInteger myMoney;

@end
