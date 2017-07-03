//
//  HomePageController.m
//  takeOut
//
//  Created by Yuexi on 17/4/15.
//  Copyright © 2017年 Yuexi. All rights reserved.
//

#import "HomePageController.h"
#import "Store.h"
#import "OHMySQL.h"
#import "StoreHeaderView.h"
#import "Menu.h"

@interface HomePageController ()<UIAlertViewDelegate>

@property (strong, nonatomic)  NSMutableArray *storeArr;
@property (strong, nonatomic)  OHMySQLManager *manager;
@property (strong, nonatomic)  OHMySQLUser *sqlUser;
@property (strong, nonatomic)  UIImageView *imgView;
@end

@implementation HomePageController

- (NSMutableArray *)storeArr{
    if (!_storeArr) {
        NSMutableArray *mArr = [NSMutableArray array];
        OHMySQLQuery *query = [[OHMySQLQuery alloc]initWithUser:self.sqlUser queryString:@"select * from store"];
        NSArray *arr = [self.manager executeSELECTQuery:query];
        
        query = [[OHMySQLQuery alloc]initWithUser:self.sqlUser queryString:@"select * from menu"];
        NSMutableArray *menuArr = [NSMutableArray arrayWithArray:[self.manager executeSELECTQuery:query]];
        
        for (int i = 0; i < arr.count; i ++) {
            Store *store = [[Store alloc] init];
            [store setValuesForKeysWithDictionary:arr[i]];
            NSMutableArray *tempArr = [NSMutableArray array];
            for (int j = 0; j < menuArr.count; j++) {
                Menu *menu = [[Menu alloc] init];
                [menu setValuesForKeysWithDictionary:menuArr[j]];
                if (menu.store_id == store.store_id) {
                    [tempArr addObject:menu];
                }
            }
            store.menuArr = tempArr;
            [mArr addObject:store];
        }
        _storeArr = mArr;
        
    }
    return _storeArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //链接数据库
    self.sqlUser = [[OHMySQLUser alloc]initWithUserName:@"root" password:@"3306" serverName:@"127.0.0.1" dbName:@"takeOut" port:3306 socket:nil];
    self.manager = [OHMySQLManager sharedManager];
    [self.manager connectWithUser:self.sqlUser];

    
    [self.tableView registerNib:[UINib nibWithNibName:@"StoreHeaderView" bundle:[NSBundle mainBundle]] forHeaderFooterViewReuseIdentifier:@"storeHeader"];

    [self prefersStatusBarHidden];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.tabBarController.tabBar.backgroundColor = [UIColor whiteColor];
    
        
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"homePageView"]];
    imgView.frame = CGRectMake(0, 20, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 20 - 49);
    self.imgView = imgView;
    [self.view.window addSubview:imgView];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.imgView removeFromSuperview];
}

- (BOOL)prefersStatusBarHidden{
    return NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return self.storeArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    Store *store = self.storeArr[section];
    return store.menuArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 72;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    StoreHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"storeHeader"];
    Store *store = self.storeArr[section];
    headerView.store_name.text = store.store_name;
    headerView.store_id.text = [NSString stringWithFormat:@"%ld",store.store_id];
    headerView.address.text = store.address;
    
    return headerView;
    
}




- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *storeCell = @"storeCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:storeCell];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:storeCell];
    }
    Store *store = self.storeArr[indexPath.section];
    Menu *menu = store.menuArr[indexPath.row];
    cell.textLabel.text = menu.food_id;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"$%ld",(long)menu.price];
    cell.imageView.image = [UIImage imageNamed:menu.food_id];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UIAlertView *alterView = [[UIAlertView alloc] initWithTitle:@"Welcome you" message:@"Do you want to pay $18 for a hamburger?" delegate:self cancelButtonTitle:@"cancel" otherButtonTitles:@"yes", nil];
    [alterView show];
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSLog(@"%ld",(long)buttonIndex);
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
