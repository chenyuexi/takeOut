//
//  OrderHeaderView.h
//  takeOut
//
//  Created by Yuexi on 17/4/19.
//  Copyright © 2017年 Yuexi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OrderHeaderView;

@protocol OrderHeaderViewClickDelegate <NSObject>

- (void)clickOrderHeaderView:(OrderHeaderView *)headerView;

@end

@interface OrderHeaderView : UITableViewHeaderFooterView

@property (weak, nonatomic) IBOutlet UIButton *headerBtn;

@property (strong, nonatomic)  NSString *btnlbl;

@property (weak, nonatomic)  id<OrderHeaderViewClickDelegate> delegate;

@end
