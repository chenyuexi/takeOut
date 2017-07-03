//
//  EditOrderInfoController.m
//  takeOut
//
//  Created by Yuexi on 2017/6/21.
//  Copyright © 2017年 Yuexi. All rights reserved.
//

#import "EditOrderInfoController.h"
#import "OHMySQL.h"
#import "Deliver.h"
#import "SYTipView.h"
@interface EditOrderInfoController ()<UIPickerViewDelegate,UIPickerViewDataSource>

@property (strong, nonatomic)  NSMutableArray *dataArr;
@property (strong, nonatomic)  OHMySQLManager *manager;
@property (strong, nonatomic)  OHMySQLUser *sqlUser;

@property (strong, nonatomic)  NSString *deliverName;
@property (assign, nonatomic)  NSInteger tag;

@end

@implementation EditOrderInfoController

- (NSMutableArray*)dataArr{
    if (!_dataArr) {
        NSMutableArray *mArr = [NSMutableArray array];
        Deliver *deliver = [[Deliver alloc] init];
        deliver.name = @"";
        self.deliverName = deliver.name;
        self.tag = 0;
        [mArr addObject:deliver];
        OHMySQLQuery *query = [[OHMySQLQuery alloc]initWithUser:self.sqlUser queryString:@"select * from deliver"];
        NSArray *arr = [self.manager executeSELECTQuery:query];
        
        for (int i = 0; i < arr.count; i ++) {
            Deliver *deliver = [[Deliver alloc] init];
            [deliver setValuesForKeysWithDictionary:arr[i]];
            [mArr addObject:deliver];
        }
        _dataArr = mArr;
        
    }
    return _dataArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //链接数据库
    self.sqlUser = [[OHMySQLUser alloc]initWithUserName:@"root" password:@"3306" serverName:@"127.0.0.1" dbName:@"takeOut" port:3306 socket:nil];
    self.manager = [OHMySQLManager sharedManager];
    [self.manager connectWithUser:self.sqlUser];

    self.deliverPickView.delegate = self;
    self.deliverPickView.dataSource = self;
    
    
}

- (void)viewWillAppear:(BOOL)animated{
 
    [super viewWillAppear:animated];
    self.nameLbl.text = self.name;
    self.foodLbl.text = self.food;
    self.ordertimeLbl.text = self.time;
    
    NSLog(@"%@",self.time);
    NSLog(@"%ld",(long)self.order.ordertime);
    
    
}
- (IBAction)doneAction:(id)sender {

    if ([self.deliverName isEqualToString:@""]) {
        [[SYTipView shareInstance]showErrorTipWithText:@"请选择一个外卖员"];
    }else{
        UIAlertController *alt = [UIAlertController alertControllerWithTitle:@"" message:@"你确定要发货吗？" preferredStyle:UIAlertControllerStyleAlert];
        [alt addAction:[UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            Deliver *deliver = self.dataArr[self.tag];

            NSString *sqlStr = [NSString stringWithFormat:@"update orders set deliver_id = %ld where user_id = %ld and ordertime = %ld and store_id = 15819597863",(long)deliver.deliver_id,(long)self.order.user_id,(long)self.order.ordertime];
            OHMySQLQuery *query = [[OHMySQLQuery alloc] initWithUser:self.sqlUser queryString:sqlStr];
            [self.manager executeQuery:query];
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"YYYYMMddHHmm"];
            NSDate *datenow = [NSDate date];
            NSString *currentTimeString = [formatter stringFromDate:datenow];
            sqlStr = [NSString stringWithFormat:@"update orders set arrivaltime = %@ where user_id = %ld and ordertime = %ld and store_id = 15819597863",currentTimeString,(long)self.order.user_id,(long)self.order.ordertime];
            query = [[OHMySQLQuery alloc] initWithUser:self.sqlUser queryString:sqlStr];
            [self.manager executeQuery:query];


            [[SYTipView shareInstance] startWithText:@"发货中..."];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [[SYTipView shareInstance] dismissSuccessWithText:@"发货成功" block:^{
                    
                    [self.navigationController popViewControllerAnimated:YES];
                    
                }];
            });
            
        }]];
        [alt addAction:[UIAlertAction actionWithTitle:@"CANCLE" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {

        }]];
        
        [self presentViewController:alt animated:YES completion:^{
        }];
    }
    
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return self.dataArr.count;
}

- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    Deliver *deliver = self.dataArr[row];
    return deliver.name;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    Deliver *deliver = self.dataArr[row];
    self.deliverName = deliver.name;
    self.tag = row;
    
}


@end
