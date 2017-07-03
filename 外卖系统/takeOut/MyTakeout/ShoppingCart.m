//
//  ShoppingCart.m
//  takeOut
//
//  Created by Yuexi on 2017/6/18.
//  Copyright © 2017年 Yuexi. All rights reserved.
//

#import "ShoppingCart.h"

@implementation ShoppingCart


+ (ShoppingCart *)shareInstance{
    static ShoppingCart *shopCart = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shopCart = [[ShoppingCart alloc] init];
        shopCart.shopCartList = [NSMutableArray array];
    });
    return shopCart;
}



@end
