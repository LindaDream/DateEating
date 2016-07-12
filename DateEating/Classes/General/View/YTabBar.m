//
//  XMGTabBar.m
//  百思不得姐
//
//  Created by lanou3g on 16/5/6.
//  Copyright © 2016年 春晓. All rights reserved.
//

#import "YTabBar.h"

@interface YTabBar ()

@property (strong,nonatomic)UIButton *publishButton;

@end

@implementation YTabBar

- (instancetype)initWithFrame:(CGRect)frame{

    if (self = [super initWithFrame:frame]) {
        // 设置tabBar背景图片
        [self setBackgroundImage:[UIImage imageNamed:@"tabbar-light"]];
#pragma mark -- 添加中间的加号按钮
        self.publishButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [self.publishButton setBackgroundImage:[UIImage imageNamed:@"tabBar_publish_icon"] forState:(UIControlStateNormal)];
        [self.publishButton setBackgroundImage:[UIImage imageNamed:@"tabBar_publish_click_icon"] forState:(UIControlStateHighlighted)];
        self.publishButton.size = CGSizeMake(self.publishButton.currentBackgroundImage.size.width + 30, self.publishButton.currentBackgroundImage.size.height + 30);
        
        [self addSubview:self.publishButton];
        
    }
    return self;
}

- (void)layoutSubviews{

    [super layoutSubviews];
    
    CGFloat width = self.width;
    CGFloat height = self.height;
    
    // 设置发布按钮的frame
    self.publishButton.center = CGPointMake(width/2, height/2 - 10);
    
    // 设置其他UITabBarButton的frame
    CGFloat buttonY = 0;
    CGFloat buttonW = width / 5;
    CGFloat buttonH = height;
    NSInteger index = 0;
    for (UIView *button in self.subviews) {
        if (![button isKindOfClass:NSClassFromString(@"UITabBarButton")] || button == self.publishButton) {
            continue;
        }
        
        // 计算按钮的x值
        CGFloat buttonX = buttonW * ((index > 1)?(index + 1):index);
        button.frame = CGRectMake(buttonX, buttonY, buttonW, buttonH);
        // 增加索引
        index++;
    }
    
}

@end
