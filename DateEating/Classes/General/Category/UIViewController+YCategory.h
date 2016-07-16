//
//  UIViewController+YCategory.h
//  DateEating
//
//  Created by user on 16/7/13.
//  Copyright © 2016年 user. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (YCategory)
// 转变为夜间模式
- (void)changeToNight;
// 转变为白天模式
- (void)changeToDay;
// 按钮动画
- (void)addDateBtnAndPartyBtn;
- (void)removeDateBtnAndPartyBtn;
// label高度自适应
- (CGFloat)textHeightForLabel:(UILabel *)label;
@end
