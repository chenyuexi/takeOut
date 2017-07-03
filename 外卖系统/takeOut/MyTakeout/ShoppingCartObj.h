//
//  ShoppingCartObj.h
//  takeOut
//
//  Created by Yuexi on 2017/6/18.
//  Copyright © 2017年 Yuexi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShoppingCartObj : NSObject

@property (strong, nonatomic)  NSString *store_name;
@property (assign, nonatomic)  NSInteger store_id;
@property (strong, nonatomic)  NSString *food_name;
@property (assign, nonatomic)  NSInteger price;


@end
