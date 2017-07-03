//
//  store.h
//  takeOut
//
//  Created by Yuexi on 2017/5/3.
//  Copyright © 2017年 Yuexi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Store : NSObject

@property (assign, nonatomic)  NSInteger store_id;
@property (strong, nonatomic)  NSString *store_name;
@property (strong, nonatomic)  NSString *address;
@property (strong, nonatomic)  NSMutableArray *menuArr;
@property (strong, nonatomic)  NSString *psw;

@end
