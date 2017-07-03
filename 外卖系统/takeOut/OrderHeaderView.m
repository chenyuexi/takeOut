//
//  OrderHeaderView.m
//  takeOut
//
//  Created by Yuexi on 17/4/19.
//  Copyright © 2017年 Yuexi. All rights reserved.
//

#import "OrderHeaderView.h"

@implementation OrderHeaderView


-(void)setBtnlbl:(NSString *)btnlbl{
    _btnlbl = btnlbl;
    [self.headerBtn setTitle:_btnlbl forState:UIControlStateNormal];

}

- (IBAction)clickHeaderBtn:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(clickOrderHeaderView:)]) {
        [self.delegate clickOrderHeaderView:self];
    }
}


@end
