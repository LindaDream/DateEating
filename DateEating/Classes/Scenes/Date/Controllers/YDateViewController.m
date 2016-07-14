//
//  XMGNewViewController.m
//  百思不得姐
//
//  Created by lanou3g on 16/5/6.
//  Copyright © 2016年 春晓. All rights reserved.
//

#import "YDateViewController.h"
@interface YDateViewController ()
@end

@implementation YDateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 接收夜间模式转换通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(change:) name:@"NotificationNight" object:nil];
    // 接收加号按钮点击通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dateView:) name:@"DateButtonClicked" object:nil];
    
    // 设置view的背景色
    self.view.backgroundColor = YRGBbg;
    // 设置导航栏左边的按钮
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"MainTagSubIcon" heightImage:@"MainTagSubIconClick" target:self action:@selector(tagClick)];
    
}
#pragma mark--夜间模式通知方法--
- (void)change:(NSNotification *)notication{
    NSDictionary *userInfo = [notication userInfo];
    if ([[userInfo objectForKey:@"isNight"] isEqualToString:@"1"]) {
        [self changeToNight];
    }else if ([[userInfo objectForKey:@"isNight"] isEqualToString:@"0"]){
        [self changeToDay];
    }
    
}
#pragma mark--加号按钮通知方法--
- (void)dateView:(NSNotification *)notification{
    NSDictionary *userInfo = [notification userInfo];
    NSNumber *num = [userInfo objectForKey:@"isClicked"];
    if (num.boolValue) {
        [self addDateBtnAndPartyBtn];
    }else{
        [self removeDateBtnAndPartyBtn];
    }
}

- (void)tagClick{
    
    YLogFunc;
    
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
