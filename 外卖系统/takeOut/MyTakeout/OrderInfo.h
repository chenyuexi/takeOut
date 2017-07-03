//
//  OrderInfo.h
//  takeOut
//
//  Created by Yuexi on 2017/5/4.
//  Copyright © 2017年 Yuexi. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Order;
@interface OrderInfo : NSObject

@property (strong, nonatomic)  NSString *user_name;
@property (strong, nonatomic)  NSString *store_name;
@property (strong, nonatomic)  NSString *order_time;
@property (strong, nonatomic)  NSString *arrival_time;
@property (strong, nonatomic)  NSString *food_name;
@property (strong, nonatomic)  NSString *deliver_info;
@property (strong, nonatomic)  Order *order;
@property (assign, nonatomic,getter=isVisible)  BOOL visible;

@end
