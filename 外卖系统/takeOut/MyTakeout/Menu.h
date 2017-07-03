//
//  Menu.h
//  takeOut
//
//  Created by Yuexi on 2017/5/4.
//  Copyright © 2017年 Yuexi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Menu : NSObject

@property (assign, nonatomic)  NSInteger store_id;
@property (strong, nonatomic)  NSString *food_id;
@property (assign, nonatomic)  NSInteger price;

@end
