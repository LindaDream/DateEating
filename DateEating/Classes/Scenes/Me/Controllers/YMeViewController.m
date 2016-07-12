//
//  XMGMeViewController.m
//  百思不得姐
//
//  Created by lanou3g on 16/5/6.
//  Copyright © 2016年 春晓. All rights reserved.
//

#import "YMeViewController.h"
#import "YRegisterViewController.h"
@interface YMeViewController ()<
    UITableViewDataSource,
    UITableViewDelegate
>
@property(strong,nonatomic)UITableView *meTableView;
@end



@implementation YMeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置导航栏标题
    self.navigationItem.title = @"我的";
    // 设置view的背景色
    self.view.backgroundColor = YRGBbg;
    // 设置导航栏右边的按钮
    UIBarButtonItem *settingButton = [UIBarButtonItem itemWithImage:@"mine-setting-icon" heightImage:@"mine-setting-icon-click" target:self action:@selector(settingClick)];
    UIBarButtonItem *nightModeButton = [UIBarButtonItem itemWithImage:@"mine-moon-icon" heightImage:@"mine-moon-icon-click" target:self action:@selector(nightModeClick)];
    UIBarButtonItem *registerItem = [[UIBarButtonItem alloc] initWithTitle:@"注册" style:(UIBarButtonItemStylePlain) target:self action:@selector(loginAction:)];
    self.navigationItem.leftBarButtonItem = registerItem;
    self.navigationItem.rightBarButtonItems = @[settingButton,nightModeButton];
    
#pragma mark--设置tableview--
    self.meTableView = [[UITableView alloc] initWithFrame:self.view.frame style:(UITableViewStylePlain)];
    self.meTableView.delegate = self;
    self.meTableView.dataSource = self;
    
}
#pragma mark--登录--
- (void)loginAction:(UIBarButtonItem *)registerItem{
    YRegisterViewController *loginVC = [YRegisterViewController new];
    [self presentViewController:loginVC animated:YES completion:nil];
}
#pragma mark--夜间模式--
- (void)nightModeClick{

    YLogFunc;
    
}
#pragma mark--设置--
- (void)settingClick{

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
