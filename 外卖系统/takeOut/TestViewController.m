//
//  TestViewController.m
//  takeOut
//
//  Created by Yuexi on 2017/6/26.
//  Copyright © 2017年 Yuexi. All rights reserved.
//

#import "TestViewController.h"

@interface TestViewController ()

@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSLog(@"view load");
    
    UIButton *ben = [UIButton buttonWithType:UIButtonTypeSystem];
    ben.frame = CGRectMake(100, 100, 100, 100);
    [ben addTarget:self action:@selector(dddd) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:ben];
    
}

- (void)dddd{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)dealloc{
    NSLog(@"view dealloc");
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
