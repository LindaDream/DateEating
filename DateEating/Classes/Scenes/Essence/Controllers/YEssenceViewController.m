//
//  XMGEssenceViewController.m
//  百思不得姐
//
//  Created by lanou3g on 16/5/6.
//  Copyright © 2016年 春晓. All rights reserved.
//

#import "YEssenceViewController.h"

@interface YEssenceViewController ()
@property(strong,nonatomic)UIView *VC;
@end

@implementation YEssenceViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(change:) name:@"NotificationNight" object:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // 设置导航栏biaoti
    //self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MainTitle"]];
    // 设置view的背景色
    self.view.backgroundColor = YRGBbg;
    // 设置导航栏左边的按钮
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"MainTagSubIcon" heightImage:@"MainTagSubIconClick" target:self action:@selector(tagClick)];
    self.VC = [[UIView alloc] initWithFrame:self.view.frame];
    self.VC.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.VC];
}
- (void)change:(NSNotification *)notication{
    //NSLog(@"self.notification = %@", notication);
    NSDictionary *userInfo = [notication userInfo];
    if ([[userInfo objectForKey:@"isNight"] isEqualToString:@"1"]) {
        [self changeToNight];
    }else if ([[userInfo objectForKey:@"isNight"] isEqualToString:@"0"]){
        [self changeToDay];
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
