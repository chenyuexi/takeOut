//
//  AddMenuController.m
//  takeOut
//
//  Created by Yuexi on 2017/5/11.
//  Copyright © 2017年 Yuexi. All rights reserved.
//

#import "AddMenuController.h"
#import "OHMySQL.h"
@interface AddMenuController ()

@property (strong, nonatomic)  OHMySQLManager *manager;
@property (strong, nonatomic)  OHMySQLUser *sqlUser;


@end

@implementation AddMenuController

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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)doneBtnAction {
    
    
    NSString *sqlStr = [NSString stringWithFormat:@"insert into menu values ('%@',15819597863,%ld)",self.food_nameLbl.text,self.priceLbl.text.integerValue];
    OHMySQLQuery *query = [[OHMySQLQuery alloc] initWithUser:self.sqlUser queryString:sqlStr];
    [self.manager executeQuery:query];

    
    [self.navigationController popViewControllerAnimated:YES];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
