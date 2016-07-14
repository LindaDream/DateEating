//
//  YPublishDateViewController.m
//  DateEating
//
//  Created by user on 16/7/14.
//  Copyright © 2016年 user. All rights reserved.
//

#import "YPublishDateViewController.h"
#import "YThemeTableViewCell.h"
#import "YObjectTableViewCell.h"
#import "YConcreteTableViewCell.h"
#import "YTimeOrAddressTableViewCell.h"
#import "YFindeTableViewCell.h"
@interface YPublishDateViewController ()<
    UITableViewDataSource,
    UITableViewDelegate
>

@property (weak, nonatomic) IBOutlet UITableView *dateTableView;
// 判断cell上的按钮是否点击
@property(assign,nonatomic)BOOL isSelected;
@end

// 设置重用标识符
static NSString *const themeCellIdentifier = @"themeCell";
static NSString *const objectCellIdentifier = @"objectCell";
static NSString *const concreteCellIdentifier = @"concerteCell";
static NSString *const timeOrAddressCellIdentifier = @"timeOrAddressCell";
static NSString *const findeCellIdentifier = @"findeCell";

@implementation YPublishDateViewController

-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:(UIBarButtonItemStylePlain) target:self action:@selector(backAction)];
        self.navigationItem.rightBarButtonItem.tintColor = [UIColor colorWithRed:243/255.0 green:32/255.0 blue:37/255.0 alpha:1];
    }
    return self;
}
#pragma mark--返回方法--
- (void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"发布约会";
    self.isSelected = YES;
    // 注册cell
    [self.dateTableView registerNib:[UINib nibWithNibName:@"YThemeTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:themeCellIdentifier];
    [self.dateTableView registerNib:[UINib nibWithNibName:@"YObjectTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:objectCellIdentifier];
    [self.dateTableView registerNib:[UINib nibWithNibName:@"YConcreteTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:concreteCellIdentifier];
    [self.dateTableView registerNib:[UINib nibWithNibName:@"YTimeOrAddressTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:timeOrAddressCellIdentifier];
    [self.dateTableView registerNib:[UINib nibWithNibName:@"YFindeTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:findeCellIdentifier];
    // Do any additional setup after loading the view from its nib.
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }else if (section == 1){
        return 1;
    }
    return 4;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        YThemeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:themeCellIdentifier forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if (indexPath.section == 1){
        YObjectTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:objectCellIdentifier forIndexPath:indexPath];
        [cell.girlBtn addTarget:self action:@selector(selectAction:) forControlEvents:(UIControlEventTouchUpInside)];
        [cell.manBtn addTarget:self action:@selector(selectAction:) forControlEvents:(UIControlEventTouchUpInside)];
        [cell.anyBtn addTarget:self action:@selector(selectAction:) forControlEvents:(UIControlEventTouchUpInside)];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        if (indexPath.row == 0) {
            YConcreteTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:concreteCellIdentifier forIndexPath:indexPath];
            [cell.meBtn addTarget:self action:@selector(selectAction:) forControlEvents:(UIControlEventTouchUpInside)];
            [cell.AABtn addTarget:self action:@selector(selectAction:) forControlEvents:(UIControlEventTouchUpInside)];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }else if (indexPath.row == 1 || indexPath.row == 2){
            YTimeOrAddressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:timeOrAddressCellIdentifier forIndexPath:indexPath];
            if (indexPath.row == 1) {
                cell.timeOrAddLabel.text = @"时间";
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }else{
                cell.timeOrAddLabel.text = @"地点";
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
            return cell;
        }else{
            YFindeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:findeCellIdentifier forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
    }
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return @"主题";
    }else if (section == 1){
        return @"约会的对象";
    }else{
        return @"具体信息";
    }
}
#pragma mark--cell上的按钮点击方法--
- (void)selectAction:(UIButton *)btn{
    if (self.isSelected) {
        [btn setBackgroundImage:[UIImage imageNamed:@"Selected"] forState:(UIControlStateNormal)];
        self.isSelected = NO;
    }else{
        [btn setBackgroundImage:[UIImage imageNamed:@"notSelected"] forState:(UIControlStateNormal)];
        self.isSelected = YES;
    }
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
