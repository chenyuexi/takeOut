//
//  PersonalController.h
//  takeOut
//
//  Created by Yuexi on 17/4/16.
//  Copyright © 2017年 Yuexi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PersonalController : UITableViewController{
    NSInteger testint;
}
@property (weak, nonatomic) IBOutlet UIImageView *genderImg;
@property (weak, nonatomic) IBOutlet UILabel *nameLbl;
@property (weak, nonatomic) IBOutlet UILabel *money;

@end
