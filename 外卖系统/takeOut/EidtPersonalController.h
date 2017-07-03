//
//  EidtPersonalController.h
//  takeOut
//
//  Created by Yuexi on 17/4/15.
//  Copyright © 2017年 Yuexi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EidtPersonalController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *nameTxt;
@property (weak, nonatomic) IBOutlet UITextField *addressTxt;

@property (weak, nonatomic) IBOutlet UISegmentedControl *genderSeg;
@property (weak, nonatomic) IBOutlet UIPickerView *agePicker;

@end
