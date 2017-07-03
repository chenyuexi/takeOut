//
//  ShopCartFooterView.m
//  takeOut

//  Created by Yuexi on 2017/4/18.
//  Copyright © 2017年 Yuexi. All rights reserved.
//

#import "ShopCartFooterView.h"
#import "ShoppingCart.h"
#import "SYTipView.h"
@implementation ShopCartFooterView
- (IBAction)doneClick:(id)sender {
    
    UIAlertController *alter = [UIAlertController alertControllerWithTitle:@"" message:[NSString stringWithFormat:@"You need to pay %@ for it",self.totalPrice.text] preferredStyle:UIAlertControllerStyleAlert];
    [alter addAction:[UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (self.needMoney > self.myMoney) {
            [[SYTipView shareInstance] showErrorTipWithText:@"购买失败，您的金钱不足，请充值后购买"];
        }else{
            NSMutableArray *arr = [[ShoppingCart shareInstance].shopCartList mutableCopy];
            [[ShoppingCart shareInstance].shopCartList removeAllObjects];
            if (self.clickFinishBlock) {
                self.clickFinishBlock(arr);
            }
        }
        
    }]];
    [alter addAction:[UIAlertAction actionWithTitle:@"CANCLE" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [self.window.rootViewController presentViewController:alter animated:YES completion:^{
        
    }];
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
