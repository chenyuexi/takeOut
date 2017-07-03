//
//  MenuController.m
//  takeOut
//
//  Created by Yuexi on 2017/5/8.
//  Copyright © 2017年 Yuexi. All rights reserved.
//

#import "MenuController.h"
#import "OHMySQL.h"
#import "Menu.h"
@interface MenuController ()

@property (strong, nonatomic)  NSMutableArray *menuArr;
@property (strong, nonatomic)  OHMySQLManager *manager;
@property (strong, nonatomic)  OHMySQLUser *sqlUser;

@end

@implementation MenuController


//- (NSMutableArray*)menuArr{
//    if (!_menuArr) {
//        OHMySQLQuery *query = [[OHMySQLQuery alloc]initWithUser:self.sqlUser queryString:@"select * from menu where store_id = 15819597863"];
//        NSArray *arr = [self.manager executeSELECTQuery:query];
//        NSMutableArray *tempMutArr = [NSMutableArray array];
//        for (int i = 0; i < arr.count; i++) {
//            Menu *menu = [[Menu alloc] init];
//            [menu setValuesForKeysWithDictionary:arr[i]];
//            [tempMutArr addObject:menu];
//        }
//        _menuArr = tempMutArr;
//    }
//    return _menuArr;
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //链接数据库
    self.sqlUser = [[OHMySQLUser alloc]initWithUserName:@"root" password:@"3306" serverName:@"127.0.0.1" dbName:@"takeOut" port:3306 socket:nil];
    self.manager = [OHMySQLManager sharedManager];
    [self.manager connectWithUser:self.sqlUser];
    [self.tableView setSeparatorColor:[UIColor clearColor]];
    NSLog(@"menu load");
    
}

-(void)dealloc{
    NSLog(@"menu dealloc");
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    OHMySQLQuery *query = [[OHMySQLQuery alloc]initWithUser:self.sqlUser queryString:@"select * from menu where store_id = 15819597863"];
    NSArray *arr = [self.manager executeSELECTQuery:query];
    NSMutableArray *tempMutArr = [NSMutableArray array];
    for (int i = 0; i < arr.count; i++) {
        Menu *menu = [[Menu alloc] init];
        [menu setValuesForKeysWithDictionary:arr[i]];
        [tempMutArr addObject:menu];
    }
    _menuArr = tempMutArr;

    [self.tableView reloadData];
}

#pragma mark - Table view data source



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.menuArr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *menuReuseCell = @"menuReuseCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:menuReuseCell];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:menuReuseCell];
    }
    Menu *menu = self.menuArr[indexPath.row];
    cell.textLabel.text = menu.food_id;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"$%ld",(long)menu.price];
    cell.imageView.image = [UIImage imageNamed:menu.food_id];
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        Menu *menu = self.menuArr[indexPath.row];
        [self.menuArr removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        NSString *sqlStr = [NSString stringWithFormat:@"delete from menu where food_id = '%@'",menu.food_id];
        OHMySQLQuery *query = [[OHMySQLQuery alloc] initWithUser:self.sqlUser queryString:sqlStr];
        [self.manager executeQuery:query];

    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

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
