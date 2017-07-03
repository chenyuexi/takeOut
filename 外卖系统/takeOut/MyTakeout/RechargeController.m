//
//  RechargeController.m
//  takeOut
//
//  Created by Yuexi on 2017/6/25.
//  Copyright © 2017年 Yuexi. All rights reserved.
//

#import "RechargeController.h"
#import "SYTipView.h"
#import "OHMySQL.h"
#import "User.h"
@interface RechargeController ()<UITextFieldDelegate>

@property (strong, nonatomic)  OHMySQLManager *manager;
@property (strong, nonatomic)  OHMySQLUser *sqlUser;
@property (assign, nonatomic)  NSInteger payFlag;

@end

@implementation RechargeController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"充值系统";
    
    //链接数据库
    self.sqlUser = [[OHMySQLUser alloc]initWithUserName:@"root" password:@"3306" serverName:@"127.0.0.1" dbName:@"takeOut" port:3306 socket:nil];
    self.manager = [OHMySQLManager sharedManager];
    [self.manager connectWithUser:self.sqlUser];
    
    [self.rechargeTxt becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)doneAction:(id)sender {
    
    if (self.rechargeTxt.text.length == 0) {
        [[SYTipView shareInstance] showErrorTipWithText:@"请输入充值金额"];
    }else{
        UIAlertController *alterCon = [UIAlertController alertControllerWithTitle:@"" message:[NSString stringWithFormat:@"Are you sure to prepaid $%@?",self.rechargeTxt.text] preferredStyle:UIAlertControllerStyleAlert];
        [alterCon addAction:[UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            
            UIAlertController *alter = [UIAlertController alertControllerWithTitle:@"" message:@"请输入支付密码" preferredStyle:UIAlertControllerStyleAlert];
            
            [alter addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
                textField.secureTextEntry = YES;
                textField.delegate = self;
                
            }];
            

            
            [alter addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                if (self.payFlag) {
                    User *user = [[User alloc] init];
                    OHMySQLQuery *query = [[OHMySQLQuery alloc]initWithUser:self.sqlUser queryString:@"select * from user where user_id = 18819258238"];
                    NSDictionary *dic = [[self.manager executeSELECTQuery:query] firstObject];
                    [user setValuesForKeysWithDictionary:dic];
                    NSInteger money = user.money;
                    money += self.rechargeTxt.text.integerValue;
                    NSString *sqlStr = [NSString stringWithFormat:@"update user set money = %ld where user_id = 18819258238",money];
                    query = [[OHMySQLQuery alloc] initWithUser:self.sqlUser queryString:sqlStr];
                    [self.manager executeQuery:query];
                    [[SYTipView shareInstance] startWithText:@"充值中..."];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [[SYTipView shareInstance] dismissSuccessWithText:@"充值成功" block:nil];
                        [self.navigationController popViewControllerAnimated:YES];
                    });

                }else{
                    [[SYTipView shareInstance] showErrorTipWithText:@"密码错误"];
                }
                
            }]];
            
            [self presentViewController:alter animated:YES completion:nil];
            
            
        }]];
        [alterCon addAction:[UIAlertAction actionWithTitle:@"CANCLE" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        [self presentViewController:alterCon animated:YES completion:^{
            
        }];
    }
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField{

    if ([textField.text isEqualToString:@"abc"]) {
        self.payFlag = YES;
    }
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
