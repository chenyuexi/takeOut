//
//  SYTipConst.h
//  SYTip
//
//  Created by xzineiw on 16-1-8.
//  Copyright © 2016年 99666yx.com. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *	@brief 获取tips资源
 */
extern NSString *const SYTipsiPhoneBundleName;
extern NSString *const SYTipsiPadBundleName;

//#define SYTipsResSrcName(file)  (isIpad)?[SYTipsiPadBundleName  stringByAppendingPathComponent:file] : [SYTipsiPhoneBundleName  stringByAppendingPathComponent:file]


#define SYTipsResSrcName(file) [SYTipsiPadBundleName  stringByAppendingPathComponent:file]

/**
 *	@brief 获取keyWindow
 */
#define KEYWINDOW [UIApplication sharedApplication].keyWindow

#define GetKeyWindow  KEYWINDOW ? KEYWINDOW : [[UIApplication sharedApplication].windows objectAtIndex:0]

/**
 *	@brief 界面和资源的宽度
 */
#define TIPVIEW_WIDTH 160.0
#define TIPVIEW_HEIGHT 120.0
#define TIPIMAGEVIEW_WIDTH 30.0
