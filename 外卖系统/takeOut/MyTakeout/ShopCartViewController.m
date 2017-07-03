//
//  ShopCartViewController.m
//  takeOut
//
//  Created by Yuexi on 2017/6/18.
//  Copyright © 2017年 Yuexi. All rights reserved.
//

#import "ShopCartViewController.h"
#import "ShoppingCart.h"
#import "ShoppingCartObj.h"
#import "ShopCartFooterView.h"
#import "FoodListView.h"
#import "OHMySQL.h"
#import "Order.h"
#import "User.h"
@interface ShopCartViewController ()
@property (strong, nonatomic)  UIImageView *imgView;
@property (strong, nonatomic)  FoodListView *flv;


@property (strong, nonatomic)  OHMySQLManager *manager;
@property (strong, nonatomic)  OHMySQLUser *sqlUser;

@end

@implementation ShopCartViewController

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if(self = [super initWithCoder:aDecoder]){
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clickToBuyNotification) name:@"kShopingCarNotification" object:nil];
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    

    [self.tableView registerNib:[UINib nibWithNibName:@"ShopCartFooterView" bundle:[NSBundle mainBundle]] forHeaderFooterViewReuseIdentifier:@"ShopCartFooterView"];
    
    //链接数据库
    self.sqlUser = [[OHMySQLUser alloc]initWithUserName:@"root" password:@"3306" serverName:@"127.0.0.1" dbName:@"takeOut" port:3306 socket:nil];
    self.manager = [OHMySQLManager sharedManager];
    [self.manager connectWithUser:self.sqlUser];

        
}

- (void)clickToBuyNotification{
    
    ShoppingCart *sc = [ShoppingCart shareInstance];
    if (sc.shopCartList.count == 0) {
        self.navigationController.tabBarItem.badgeValue = nil;
    }else{
        self.navigationController.tabBarItem.badgeValue = [NSString stringWithFormat:@"%lu",(unsigned long)sc.shopCartList.count];
    }
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    
    [self.tableView reloadData];
    
    User *user = [[User alloc] init];
    OHMySQLQuery *query = [[OHMySQLQuery alloc]initWithUser:self.sqlUser queryString:@"select * from user where user_id = 18819258238"];
    NSDictionary *dic = [[self.manager executeSELECTQuery:query] firstObject];
    [user setValuesForKeysWithDictionary:dic];
    [ShoppingCart shareInstance].money = user.money;
    NSLog(@"%lu",(unsigned long)[ShoppingCart shareInstance].money);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 60;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    ShoppingCart *sc = [ShoppingCart shareInstance];
    if (sc.shopCartList.count != 0) {
        ShopCartFooterView *footerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"ShopCartFooterView"];
        NSInteger num = 0;
        for (ShoppingCartObj *scObj in sc.shopCartList) {
            num += scObj.price;
        }
        footerView.totalPrice.text = [NSString stringWithFormat:@"$%ld",(long)num];
        footerView.needMoney = num;
        footerView.myMoney = sc.money;
        footerView.clickFinishBlock = ^(NSMutableArray *arr){
            [tableView reloadData];

            NSString *sqlStr = [NSString stringWithFormat:@"update user set money = %ld where user_id = 18819258238",sc.money - num];
            OHMySQLQuery *query = [[OHMySQLQuery alloc] initWithUser:self.sqlUser queryString:sqlStr];
            [self.manager executeQuery:query];
            
            for (int i = 0; i < arr.count; i ++) {
                Order *order = [[Order alloc] init];
                ShoppingCartObj *obj = arr[i];
                order.store_id = obj.store_id;
                order.food_id = obj.food_name;
                order.user_id = 18819258238;
                order.arrivaltime = 0;
                order.deliver_id = 0;
                
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                [formatter setDateFormat:@"YYYYMMddHHmm"];
                NSDate *datenow = [NSDate date];
                NSString *currentTimeString = [formatter stringFromDate:datenow];

                order.ordertime = currentTimeString.integerValue;

                for (int j = i+1 ; j < arr.count; j++) {
                    
                    ShoppingCartObj *obj2 = arr[j];
                    if (obj2.store_id == order.store_id) {
                        order.food_id = [NSString stringWithFormat:@"%@,%@",order.food_id,obj2.food_name];
                        [arr removeObjectAtIndex:j];
                        j --;
                    }
                }
                
                
                [self.manager insertInto:@"orders" set:@{
                        @"user_id" : [[NSNumber alloc] initWithInteger:order.user_id] ,
                        @"ordertime" : [[NSNumber alloc] initWithInteger:order.ordertime] ,
                        @"arrivaltime" : [[NSNumber alloc] initWithInteger:order.arrivaltime] ,
                        @"store_id" : [[NSNumber alloc] initWithInteger:order.store_id] ,
                        @"food_id" : order.food_id ,
                        @"deliver_id" : [[NSNumber alloc] initWithInteger:order.deliver_id]
                        }];
            }
            
            [[NSNotificationCenter defaultCenter]postNotificationName:@"kShopingCarNotification" object:nil];
            
        };
        return footerView;
    }else{
        UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"shopCartView"]];
        imgView.frame = CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 49 - 64);
        self.imgView = imgView;
        [self.view.window addSubview:imgView];
        return nil;
    }
    
    
}



- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.imgView removeFromSuperview];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return [ShoppingCart shareInstance].shopCartList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 70;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *shopCartCell = @"shopCartCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:shopCartCell];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:shopCartCell];
    }
    ShoppingCartObj *cartObj = [ShoppingCart shareInstance].shopCartList[indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ --%@",cartObj.food_name,cartObj.store_name];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"$%ld",cartObj.price];
    cell.imageView.image = [UIImage imageNamed:cartObj.food_name];
    return cell;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [[ShoppingCart shareInstance].shopCartList removeObjectAtIndex:indexPath.row];
        [self clickToBuyNotification];
        [tableView reloadData];
        
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
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
