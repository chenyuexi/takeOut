//
//  User.h
//  takeOut
//
//  Created by Yuexi on 2017/5/1.
//  Copyright © 2017年 Yuexi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

@property (assign, nonatomic)  NSInteger user_id;
@property (strong, nonatomic)  NSString *psw;
@property (strong, nonatomic)  NSString *address;
@property (strong, nonatomic)  NSString *name;
@property (assign, nonatomic)  NSInteger age;
@property (assign, nonatomic)  NSInteger gender;
@property (assign, nonatomic)  NSInteger money;

@end
