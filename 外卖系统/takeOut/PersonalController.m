//
//  PersonalController.m
//  takeOut
//
//  Created by Yuexi on 17/4/16.
//  Copyright © 2017年 Yuexi. All rights reserved.
//

#import "PersonalController.h"
#import "User.h"
#import "OHMySQL.h"
#import "ShoppingCart.h"
#import "LoginViewController.h"
@interface PersonalController ()

@end

@implementation PersonalController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSLog(@"personal load");

    UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(editPersonal)];
    [self.genderImg addGestureRecognizer:ges];
    self.genderImg.userInteractionEnabled = YES;
    
}

- (void)editPersonal{
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    UIViewController *vc = [sb instantiateViewControllerWithIdentifier:@"EidtPersonalController"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)dealloc{
    
    NSLog(@"personal dealloc");
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    
    
    User *user = [[User alloc] init];
    OHMySQLUser *sqlUser = [[OHMySQLUser alloc]initWithUserName:@"root" password:@"3306" serverName:@"127.0.0.1" dbName:@"takeOut" port:3306 socket:nil];
    OHMySQLManager *manager = [OHMySQLManager sharedManager];
    [manager connectWithUser:sqlUser];
    OHMySQLQuery *query = [[OHMySQLQuery alloc]initWithUser:sqlUser queryString:@"select * from user where user_id = 18819258238"];
    NSDictionary *dic = [[manager executeSELECTQuery:query] firstObject];
    [user setValuesForKeysWithDictionary:dic];
    NSLog(@"%@",user.name);
    self.nameLbl.text = user.name;
    if (user.gender == 0) {
        self.genderImg.image = [UIImage imageNamed:@"man"];
    }else{
        self.genderImg.image = [UIImage imageNamed:@"woman"];
    }
    self.money.text = [NSString stringWithFormat:@"$%ld",user.money];
    
    
}

- (IBAction)logoutAction:(id)sender {
    
    UIAlertController *alterCon = [UIAlertController alertControllerWithTitle:@"" message:@"Are you sure logout?" preferredStyle:UIAlertControllerStyleActionSheet];
                                   
    [alterCon addAction:[UIAlertAction actionWithTitle:@"LOGOUT" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
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
