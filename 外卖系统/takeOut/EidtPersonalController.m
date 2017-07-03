//
//  EidtPersonalController.m
//  takeOut
//
//  Created by Yuexi on 17/4/15.
//  Copyright © 2017年 Yuexi. All rights reserved.
//

#import "EidtPersonalController.h"
#import "User.h"
#import "OHMySQL.h"

@interface EidtPersonalController ()<UIPickerViewDelegate,UIPickerViewDataSource>

@property (strong, nonatomic)  NSMutableArray *dataArr;
@property (strong, nonatomic)  User *user;
@property (strong, nonatomic)  OHMySQLManager *manager;
@property (strong, nonatomic)  OHMySQLUser *sqlUser;

@end

@implementation EidtPersonalController

- (NSMutableArray*)dataArr{
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
        for (int i = 12; i < 70; i++) {
            [_dataArr addObject:[NSNumber numberWithInteger:i]];
        }
    }
    return _dataArr;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];

    
    //链接数据库
    self.sqlUser = [[OHMySQLUser alloc]initWithUserName:@"root" password:@"3306" serverName:@"127.0.0.1" dbName:@"takeOut" port:3306 socket:nil];
    self.manager = [OHMySQLManager sharedManager];
    [self.manager connectWithUser:self.sqlUser];
    
    
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    User *user = [[User alloc] init];
    self.user = user;
    OHMySQLQuery *query = [[OHMySQLQuery alloc]initWithUser:self.sqlUser queryString:@"select * from user where user_id = 18819258238"];
    NSDictionary *dic = [[self.manager executeSELECTQuery:query] firstObject];
    [user setValuesForKeysWithDictionary:dic];
    
    self.nameTxt.text = user.name;
    self.addressTxt.text = user.address;
    self.genderSeg.selectedSegmentIndex = user.gender;
    [self.agePicker selectRow:user.age - 12 inComponent:0 animated:YES];

}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return self.dataArr.count;
}

- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return [NSString stringWithFormat:@"%@",self.dataArr[row]];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    self.user.age = [self.dataArr[row] integerValue];
}

- (IBAction)doneBtn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
    
    NSString *sqlStr = [NSString stringWithFormat:@"update user set gender = %ld where user_id = 18819258238",(long)self.genderSeg.selectedSegmentIndex];
    OHMySQLQuery *query = [[OHMySQLQuery alloc] initWithUser:self.sqlUser queryString:sqlStr];
    [self.manager executeQuery:query];
    sqlStr = [NSString stringWithFormat:@"update user set name = '%@' where user_id = 18819258238",self.nameTxt.text];
    query = [[OHMySQLQuery alloc] initWithUser:self.sqlUser queryString:sqlStr];
    [self.manager executeQuery:query];
    sqlStr = [NSString stringWithFormat:@"update user set address = '%@' where user_id = 18819258238",self.addressTxt.text];
    query = [[OHMySQLQuery alloc] initWithUser:self.sqlUser queryString:sqlStr];
    [self.manager executeQuery:query];
    sqlStr = [NSString stringWithFormat:@"update user set age = %ld where user_id = 18819258238",(long)self.user.age];
    query = [[OHMySQLQuery alloc] initWithUser:self.sqlUser queryString:sqlStr];
    [self.manager executeQuery:query];
    
        
    
}

- (void)dealloc{
    [self.manager disconnect];
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
