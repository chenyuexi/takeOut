//
//  EditOrderController.h
//  takeOut
//
//  Created by Yuexi on 2017/6/21.
//  Copyright © 2017年 Yuexi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditOrderController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *foodLbl;
@property (weak, nonatomic) IBOutlet UILabel *ordertimeLbl;
@property (weak, nonatomic) IBOutlet UIPickerView *deliverPickView;
@property (weak, nonatomic) IBOutlet UILabel *nameLbl;

@property (strong, nonatomic)  NSString *kuku;
@end
