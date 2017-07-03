//
//  OrderViewCell.h
//  takeOut
//
//  Created by Yuexi on 2017/5/3.
//  Copyright © 2017年 Yuexi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *storeLbl;
@property (weak, nonatomic) IBOutlet UILabel *foodLbl;
@property (weak, nonatomic) IBOutlet UILabel *ordertomeLbl;
@property (weak, nonatomic) IBOutlet UILabel *arrivaltimeLbl;
@property (weak, nonatomic) IBOutlet UILabel *deliverLbl;

@end
