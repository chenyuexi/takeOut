//
//  LoginViewController.m
//  takeOut
//
//  Created by Yuexi on 2017/6/20.
//  Copyright © 2017年 Yuexi. All rights reserved.
//

#import "LoginViewController.h"
#import "PersonalController.h"
#import "SYTipView.h"
#import "RegisterViewController.h"
@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UIButton *modeBtn;
@property (weak, nonatomic) IBOutlet UIImageView *bgImgView;
@property (assign, nonatomic)  BOOL mode;
@property (strong, nonatomic)  NSString *modeTypeStr;
@property (weak, nonatomic) IBOutlet UILabel *modeLbl;
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    self.modeTypeStr = @"mainTabbarID";  //storeModeID
    NSLog(@"login load");
  
    
}

- (void)dealloc{
    NSLog(@"login dealloc");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)loginAction:(id)sender {
//    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
//    UIWindow *window = [UIApplication sharedApplication].keyWindow;
//    window.rootViewController = [sb instantiateViewControllerWithIdentifier:@"mainTabbarID"];
    if ([self.accountTxt.text isEqualToString:@"18819258238"] && [self.passwordTxt.text isEqualToString:@"abc"] && [self.modeTypeStr isEqualToString:@"mainTabbarID"]) {
        
        
        [[SYTipView shareInstance] startWithText:@"logging..."];

        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [[SYTipView shareInstance] dismissSuccessWithText:@"login success" block:^{
                UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
                UIWindow *window = [UIApplication sharedApplication].keyWindow;
                window.rootViewController = [sb instantiateViewControllerWithIdentifier:@"mainTabbarID"];
            }];
            
        });
        
    }else if ([self.accountTxt.text isEqualToString:@"15819597863"] && [self.passwordTxt.text isEqualToString:@"abc"] && [self.modeTypeStr isEqualToString:@"storeModeID"]){
        
        [[SYTipView shareInstance] startWithText:@"logging..."];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [[SYTipView shareInstance] dismissSuccessWithText:@"login success" block:^{
                UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
                UIWindow *window = [UIApplication sharedApplication].keyWindow;
                window.rootViewController = [sb instantiateViewControllerWithIdentifier:@"storeModeID"];
            }];
            
        });

        
    }else if (self.accountTxt.text.length > 0){
        [[SYTipView shareInstance] showErrorTipWithText:@"wrong password"];
    }else{
        [[SYTipView shareInstance] showErrorTipWithText:@"please enter account"];
    }
    
    
}
- (IBAction)registerAction:(id)sender {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    window.rootViewController = [[RegisterViewController alloc] init];
    
}
- (IBAction)forgetAction:(id)sender {
}
- (IBAction)modeChangeAction:(id)sender {
    
    self.mode = !self.mode;
    if (self.mode) {
        [self.modeBtn setTitle:@"User Mode" forState:UIControlStateNormal];
        self.bgImgView.image = [UIImage imageNamed:@"loginViewAdmin"];
        self.modeTypeStr = @"storeModeID";
        self.modeLbl.text = @"Admin Mode";
        [self.registerBtn setHidden:YES];
    }else{
        [self.modeBtn setTitle:@"Admin Mode" forState:UIControlStateNormal];
        self.bgImgView.image = [UIImage imageNamed:@"loginView"];
        self.modeTypeStr = @"mainTabbarID";
        self.modeLbl.text = @"User Mode";
        [self.registerBtn setHidden:NO];
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
