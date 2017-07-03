//
//  ShoppingCart.h
//  takeOut
//
//  Created by Yuexi on 2017/6/18.
//  Copyright © 2017年 Yuexi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShoppingCart : NSObject

+ (ShoppingCart *)shareInstance;

@property (strong, nonatomic)  NSMutableArray *shopCartList;
@property (assign, nonatomic)  NSInteger money;

@end
