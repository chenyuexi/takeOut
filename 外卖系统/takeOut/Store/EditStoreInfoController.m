//
//  EditStoreInfoController.m
//  takeOut
//
//  Created by Yuexi on 17/4/21.
//  Copyright © 2017年 Yuexi. All rights reserved.
//

#import "EditStoreInfoController.h"
#import "OHMySQL.h"
#import "Store.h"

@interface EditStoreInfoController ()

@property (strong, nonatomic)  Store *store;
@property (strong, nonatomic)  OHMySQLManager *manager;
@property (strong, nonatomic)  OHMySQLUser *sqlUser;

@end

@implementation EditStoreInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //链接数据库
    self.sqlUser = [[OHMySQLUser alloc]initWithUserName:@"root" password:@"3306" serverName:@"127.0.0.1" dbName:@"takeOut" port:3306 socket:nil];
    self.manager = [OHMySQLManager sharedManager];
    [self.manager connectWithUser:self.sqlUser];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneBtnAction)];
    self.navigationItem.rightBarButtonItem = item;
    
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.store = [[Store alloc] init];
    OHMySQLQuery *query = [[OHMySQLQuery alloc]initWithUser:self.sqlUser queryString:@"select * from store where store_id = 15819597863"];
    NSDictionary *dic = [[self.manager executeSELECTQuery:query] firstObject];
    [self.store setValuesForKeysWithDictionary:dic];
    
    self.nameLbl.text = self.store.store_name;
    self.phoneLbl.text = [NSString stringWithFormat:@"%ld",self.store.store_id];
    self.addressLbl.text = self.store.address;
    
}


- (void)doneBtnAction {
    [self.navigationController popViewControllerAnimated:YES];
    
    NSString *sqlStr = [NSString stringWithFormat:@"update store set store_name = '%@' where store_id = 15819597863",self.nameLbl.text];
    OHMySQLQuery *query = [[OHMySQLQuery alloc] initWithUser:self.sqlUser queryString:sqlStr];
    [self.manager executeQuery:query];
    sqlStr = [NSString stringWithFormat:@"update store set address = '%@' where store_id = 15819597863",self.addressLbl.text];
    query = [[OHMySQLQuery alloc] initWithUser:self.sqlUser queryString:sqlStr];
    [self.manager executeQuery:query];
    
    
}






@end
