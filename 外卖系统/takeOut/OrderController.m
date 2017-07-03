//
//  OrderController.m
//  takeOut
//
//  Created by Yuexi on 17/4/16.
//  Copyright © 2017年 Yuexi. All rights reserved.
//

#import "OrderController.h"
#import "OrderHeaderView.h"
#import "OHMySQL.h"
#import "Order.h"
#import "OrderViewCell.h"
#import "OrderInfo.h"
@interface OrderController ()<OrderHeaderViewClickDelegate>
@property (strong, nonatomic)  OHMySQLManager *manager;
@property (strong, nonatomic)  OHMySQLUser *sqlUser;
@property (strong, nonatomic)  NSMutableArray *orderArr;


@end

@implementation OrderController
- (NSMutableArray*)orderArr{
    if (!_orderArr) {
        
        NSMutableArray *mArr = [NSMutableArray array];
        OHMySQLQuery *query = [[OHMySQLQuery alloc]initWithUser:self.sqlUser queryString:@"select * from orders where user_id = '18819258238'"];
        NSArray *arr = [self.manager executeSELECTQuery:query];
        for (int i = 0; i < arr.count; i++) {
            OrderInfo *odInfo = [[OrderInfo alloc] init];
            Order *order = [[Order alloc] init];
            [order setValuesForKeysWithDictionary:arr[i]];
            odInfo.order = order;
            NSString *queryStr = [NSString stringWithFormat:@"select * from store where store_id = %ld",(long)order.store_id];
            query = [[OHMySQLQuery alloc] initWithUser:self.sqlUser queryString:queryStr];
            NSDictionary *dic = [[self.manager executeSELECTQuery:query]firstObject];
            odInfo.store_name = [NSString stringWithFormat:@"store: %@",[dic valueForKey:@"store_name"]];
            if (order.deliver_id != 0) {
                queryStr = [NSString stringWithFormat:@"select * from deliver where deliver_id = %ld",(long)order.deliver_id];
                query = [[OHMySQLQuery alloc] initWithUser:self.sqlUser queryString:queryStr];
                dic = [[self.manager executeSELECTQuery:query]firstObject];
                odInfo.deliver_info = [NSString stringWithFormat:@"deliver: %@   %@",[dic valueForKey:@"name"],[dic valueForKey:@"deliver_id"]];
            }else{
                odInfo.deliver_info = @"deliver: no infomation";
            }
            NSString *odTimeStr = [NSString stringWithFormat:@"%ld",order.ordertime];
            NSRange rangeYear = NSMakeRange(0, 4);
            NSRange rangeMonth = NSMakeRange(4, 2);
            NSRange rangeDay = NSMakeRange(6, 2);
            NSRange rangeHour = NSMakeRange(8, 2);
            NSRange rangeMinute = NSMakeRange(10, 2);
            odInfo.order_time = [NSString stringWithFormat:@"order time: %@.%@.%@ %@:%@",[odTimeStr substringWithRange:rangeYear],[odTimeStr substringWithRange:rangeMonth],[odTimeStr substringWithRange:rangeDay],[odTimeStr substringWithRange:rangeHour],[odTimeStr substringWithRange:rangeMinute]];
            if (order.arrivaltime != 0) {
                NSString *arTimeStr = [NSString stringWithFormat:@"%ld",order.arrivaltime];
                odInfo.arrival_time = [NSString stringWithFormat:@"arrival time: %@.%@.%@ %@:%@",[arTimeStr substringWithRange:rangeYear],[arTimeStr substringWithRange:rangeMonth],[arTimeStr substringWithRange:rangeDay],[arTimeStr substringWithRange:rangeHour],[arTimeStr substringWithRange:rangeMinute]];
            }else{
                odInfo.arrival_time = @"arrival time :undelivered";
            }
            odInfo.food_name = [NSString stringWithFormat:@"food: %@",order.food_id];
            odInfo.visible = YES;
            [mArr addObject:odInfo];

        }
        [self quick_sortWith:mArr from:0 to:mArr.count - 1];
        _orderArr = mArr;
    }
    
    return _orderArr;
}

- (void) quick_sortWith:(NSMutableArray *)arr from:(NSInteger) l to:(NSInteger) r
{
    
    if (l < r)
    {
        OrderInfo *info = arr[l];
        NSInteger x = info.order.ordertime;
        NSInteger i = l, j = r;
        while (i < j)
        {
            while(i < j && ((OrderInfo *)arr[j]).order.ordertime < x) // 从右向左找第一个大于x的数
                j--;
            if(i < j)
                arr[i++] = arr[j];
            while(i < j && ((OrderInfo *)arr[i]).order.ordertime >= x) // 从左向右找第一个小于等于x的数
                i++;
            if(i < j)
                arr[j--] = arr[i];
        }
        arr[i] = info;
        // 递归调用
        [self quick_sortWith:arr from:l to:i-1];
        [self quick_sortWith:arr from:i+1 to:r];
    }
}


- (void)clickOrderHeaderView:(OrderHeaderView *)headerView{
    OrderInfo *odInfo = self.orderArr[headerView.tag];
    odInfo.visible = !odInfo.isVisible;
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:headerView.tag] withRowAnimation:UITableViewRowAnimationFade];
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.tabBarController.tabBar.hidden = YES;
    
    // Uncomment the following line to preserve selection between presentations.
    
    
    [self.tableView registerNib:[UINib nibWithNibName:@"OrderViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"orderCell"];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"OrderHeaderView" bundle:[NSBundle mainBundle]] forHeaderFooterViewReuseIdentifier:@"orderHeader"];

    
    
    //链接数据库
    self.sqlUser = [[OHMySQLUser alloc]initWithUserName:@"root" password:@"3306" serverName:@"127.0.0.1" dbName:@"takeOut" port:3306 socket:nil];
    self.manager = [OHMySQLManager sharedManager];
    [self.manager connectWithUser:self.sqlUser];
    

    
}
    


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.orderArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    OrderInfo *odInfo = self.orderArr[section];
    if (odInfo.isVisible) {
        return 1;
    }else{
        return 0;
    }
    
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    OrderHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"orderHeader"];
    headerView.btnlbl = [NSString stringWithFormat:@"订单 %ld",(long)section + 1];
    headerView.tag = section;
    headerView.delegate = self;
    return headerView;
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 150;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    OrderViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"orderCell"];
    OrderInfo *odInfo = self.orderArr[indexPath.section];
    cell.storeLbl.text = odInfo.store_name;
    cell.deliverLbl.text = odInfo.deliver_info;
    cell.ordertomeLbl.text = odInfo.order_time;
    cell.arrivaltimeLbl.text = odInfo.arrival_time;
    cell.foodLbl.text = odInfo.food_name;
    
    if ([cell.arrivaltimeLbl.text isEqualToString:@"arrival time :undelivered"]) {
        cell.arrivaltimeLbl.textColor = [UIColor redColor];
    }else{
        cell.arrivaltimeLbl.textColor = [UIColor colorWithDisplayP3Red:102.0/255.0 green:215.0/255.0 blue:255/255.0 alpha:1.0];
    }
    if ([cell.deliverLbl.text isEqualToString:@"deliver: no infomation"]) {
        cell.deliverLbl.textColor = [UIColor redColor];
    }else{
        cell.deliverLbl.textColor = [UIColor colorWithDisplayP3Red:102.0/255.0 green:215.0/255.0 blue:255/255.0 alpha:1.0];
    }
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
