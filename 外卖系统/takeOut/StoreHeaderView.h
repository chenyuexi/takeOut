//
//  StoreHeaderView.h
//  takeOut
//
//  Created by Yuexi on 2017/5/3.
//  Copyright © 2017年 Yuexi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StoreHeaderView : UITableViewHeaderFooterView
@property (weak, nonatomic) IBOutlet UILabel *store_name;
@property (weak, nonatomic) IBOutlet UILabel *address;
@property (weak, nonatomic) IBOutlet UILabel *store_id;

@end
