//
//  EditOrderInfoController.h
//  takeOut
//
//  Created by Yuexi on 2017/6/21.
//  Copyright © 2017年 Yuexi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Order.h"
@interface EditOrderInfoController : UITableViewController
@property (strong, nonatomic) IBOutlet UILabel *nameLbl;
@property (strong, nonatomic) IBOutlet UILabel *foodLbl;
@property (strong, nonatomic) IBOutlet UILabel *ordertimeLbl;
@property (strong, nonatomic) IBOutlet UIPickerView *deliverPickView;

@property (strong, nonatomic)  NSString *name;
@property (strong, nonatomic)  NSString *food;
@property (strong, nonatomic)  NSString *time;
@property (strong, nonatomic)  Order *order;

@end
