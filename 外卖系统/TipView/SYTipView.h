//
//  SYTipView.h
//  SYTip
//
//  Created by xzineiw on 16-1-8.
//  Copyright © 2016年 99666yx.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SYTipView : NSObject

/**
 *  @brief 返回单例
 */
+ (SYTipView *)shareInstance;

/**
 *  @brief 成功显示
 *
 *  @param tipText 显示文本
 */
- (void)showSuccessTipWithText:(NSString *)tipText;

/**
 *  @brief 失败显示
 *
 *  @param tipText 显示文本
 */
- (void)showErrorTipWithText:(NSString *)tipText;

/**
 *  @brief 开始显示（菊花）
 *
 *  @param tipText 显示文本
 */
- (void)startWithText:(NSString *)tipText;

/**
 *  @brief 撤销成功显示
 *
 *  @param tipText 显示文本
 *  @param action  block操作
 */
- (void)dismissSuccessWithText:(NSString *)tipText block:(void(^)())action;

/**
 *  @brief 撤销失败显示
 *
 *  @param tipText 显示文本
 *  @param action  block操作
 */
- (void)dismissErrorWithText:(NSString *)tipText block:(void(^)())action;

/**
 *  @brief 撤销成功显示框
 */
- (void)removeSuccessTipView;

/**
 *  @brief 撤销失败显示框
 */
- (void)removeErrorTipView;

@end
