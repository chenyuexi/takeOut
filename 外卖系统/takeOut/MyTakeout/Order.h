//
//  Order.h
//  takeOut
//
//  Created by Yuexi on 2017/5/2.
//  Copyright © 2017年 Yuexi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Order : NSObject

@property (strong, nonatomic)  NSString *food_id;
@property (assign, nonatomic)  NSInteger user_id;
@property (assign, nonatomic)  NSInteger ordertime;
@property (assign, nonatomic)  NSInteger arrivaltime;
@property (assign, nonatomic)  NSInteger store_id;
@property (assign, nonatomic)  NSInteger deliver_id;

@end
