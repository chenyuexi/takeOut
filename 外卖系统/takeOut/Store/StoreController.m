//
//  StoreController.m
//  takeOut
//
//  Created by Yuexi on 17/4/21.
//  Copyright © 2017年 Yuexi. All rights reserved.
//

#import "StoreController.h"
#import "OHMySQL.h"
#import "Store.h"
#import "LoginViewController.h"
#import "Order.h"
@interface StoreController ()
@property (weak, nonatomic) IBOutlet UILabel *numLbl;
@property (assign, nonatomic)  NSInteger num;

@end

@implementation StoreController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSLog(@"store load");
}
- (void)dealloc{
    NSLog(@"store dealloc");
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    
    Store *store = [[Store alloc] init];
    OHMySQLUser *sqlUser = [[OHMySQLUser alloc]initWithUserName:@"root" password:@"3306" serverName:@"127.0.0.1" dbName:@"takeOut" port:3306 socket:nil];
    OHMySQLManager *manager = [OHMySQLManager sharedManager];
    [manager connectWithUser:sqlUser];
    OHMySQLQuery *query = [[OHMySQLQuery alloc]initWithUser:sqlUser queryString:@"select * from store where store_id = 15819597863"];
    NSDictionary *dic = [[manager executeSELECTQuery:query] firstObject];
    [store setValuesForKeysWithDictionary:dic];
    
    self.nameLbl.text = store.store_name;
    
    
    query = [[OHMySQLQuery alloc]initWithUser:sqlUser queryString:@"select * from orders where store_id = '15819597863'"];
    NSArray *arr = [manager executeSELECTQuery:query];
    for (int i = 0; i < arr.count; i++) {
        Order *order = [[Order alloc] init];
        [order setValuesForKeysWithDictionary:arr[i]];
        if (order.arrivaltime == 0) {
            self.num ++;
        }
    }
    if (self.num == 0) {
        [self.numLbl setHidden:YES];
    }else{
        self.numLbl.text = [NSString stringWithFormat:@"%ld",self.num];
    }
    
    self.num = 0;
    
        
    
}


- (IBAction)logoutAction:(id)sender {
    
    UIAlertController *alterCon = [UIAlertController alertControllerWithTitle:@"" message:@"Are you sure logout?" preferredStyle:UIAlertControllerStyleAlert];
    
    [alterCon addAction:[UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        window.rootViewController = [[LoginViewController alloc] init];
    }]];
    [alterCon addAction:[UIAlertAction actionWithTitle:@"CANCLE" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        
    }]];
    [self presentViewController:alterCon animated:YES completion:^{
        
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
