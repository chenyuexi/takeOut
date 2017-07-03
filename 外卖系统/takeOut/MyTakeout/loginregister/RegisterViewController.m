//
//  RegisterViewController.m
//  takeOut
//
//  Created by Yuexi on 2017/6/20.
//  Copyright © 2017年 Yuexi. All rights reserved.
//

#import "RegisterViewController.h"
#import "LoginViewController.h"
#import "SYTipView.h"
@interface RegisterViewController ()
@property (weak, nonatomic) IBOutlet UITextField *accountTxt;
@property (weak, nonatomic) IBOutlet UITextField *passwordTxt;
@property (weak, nonatomic) IBOutlet UITextField *confirmPswTxt;

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)registerAction:(id)sender {
    
    if (self.passwordTxt.text.length > 0 && [self.passwordTxt.text isEqualToString:self.confirmPswTxt.text] && self.accountTxt.text.length == 11) {
        [[SYTipView shareInstance] startWithText:@"registering..."];
        
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [[SYTipView shareInstance] dismissSuccessWithText:@"register success" block:^{
                UIWindow *window = [UIApplication sharedApplication].keyWindow;
                window.rootViewController = [[LoginViewController alloc] init];
            }];
            
        });
    }else if (![self.passwordTxt.text isEqualToString:self.confirmPswTxt.text] && self.accountTxt.text.length == 11){
        [[SYTipView shareInstance] showErrorTipWithText:@"please confirm password"];
    }else{
        [[SYTipView shareInstance] showErrorTipWithText:@"register fail"];
    }
    
}
- (IBAction)backAction:(id)sender {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    window.rootViewController = [[LoginViewController alloc] init];
    
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
