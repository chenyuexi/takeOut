//
//  SearchView.h
//  takeOut
//
//  Created by Yuexi on 2017/6/25.
//  Copyright © 2017年 Yuexi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchView : UITableView<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic)  NSMutableArray* menuArr;

@end
