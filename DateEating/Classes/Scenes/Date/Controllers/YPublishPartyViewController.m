//
//  YPublishPartyViewController.m
//  DateEating
//
//  Created by user on 16/7/14.
//  Copyright © 2016年 user. All rights reserved.
//

#import "YPublishPartyViewController.h"
#import "YThemeTableViewCell.h"
#import "YPartyCountTableViewCell.h"
#import "YConcreteTableViewCell.h"
#import "YTimeOrAddressTableViewCell.h"
#import "YFindeTableViewCell.h"
@interface YPublishPartyViewController ()<
    UITableViewDataSource,
    UITableViewDelegate
>
// 判断cell上的按钮是否点击
@property(assign,nonatomic)BOOL isSelected;
// 设置聚会人数的视图
@property(strong,nonatomic)UIView *backView;
@property(strong,nonatomic)UITableView *countView;
// 聚会人数视图的头部视图
@property(strong,nonatomic)UIView *headView;
// 存放聚会人数选项的数组
@property(strong,nonatomic)NSArray *countArray;
@property(strong,nonatomic)NSString *count;
@end
// 设置重用标识符
static NSString *const themeCellIdentifier = @"themeCell";
static NSString *const countCellIdentifier = @"countCell";
static NSString *const concreteCellIdentifier = @"concerteCell";
static NSString *const timeOrAddressCellIdentifier = @"timeOrAddressCell";
static NSString *const findeCellIdentifier = @"findeCell";
static NSString *const systemCellIdentifier = @"systemCell";

@implementation YPublishPartyViewController

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
    self.title = @"发布聚会";
    self.isSelected = YES;
    // 注册cell
    [self.partyTableView registerNib:[UINib nibWithNibName:@"YThemeTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:themeCellIdentifier];
    [self.partyTableView registerNib:[UINib nibWithNibName:@"YPartyCountTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:countCellIdentifier];
    [self.partyTableView registerNib:[UINib nibWithNibName:@"YConcreteTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:concreteCellIdentifier];
    [self.partyTableView registerNib:[UINib nibWithNibName:@"YTimeOrAddressTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:timeOrAddressCellIdentifier];
    [self.partyTableView registerNib:[UINib nibWithNibName:@"YFindeTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:findeCellIdentifier];
    
    self.countArray = @[@"3-5人",@"6-10人",@"11-20人",@"20人以上"];
    // Do any additional setup after loading the view from its nib.
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (tableView == self.partyTableView) {
        return 3;
    }
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.partyTableView) {
        if (section == 0) {
            return 1;
        }else if (section == 1){
            return 1;
        }
        return 4;
    }
    return 4;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.partyTableView) {
        if (indexPath.section == 0) {
            YThemeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:themeCellIdentifier forIndexPath:indexPath];
            cell.themeTF.placeholder = @"请输入聚会主题";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }else if (indexPath.section == 1){
            YPartyCountTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:countCellIdentifier forIndexPath:indexPath];

            cell.countLabel.text = self.count;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
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
                cell.desTextView.text = @"请输入聚会简要说明";
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
            }
        }
    }else{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:systemCellIdentifier forIndexPath:indexPath];
        cell.textLabel.text = self.countArray[indexPath.row];
        cell.textLabel.textAlignment = UITextAlignmentCenter;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, cell.contentView.height, self.countView.width, 1)];
        lineView.backgroundColor = [UIColor lightGrayColor];
        lineView.alpha = 0.2;
        [cell.contentView addSubview:lineView];
        return cell;
    }
    
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (tableView == self.partyTableView) {
        if (section == 0) {
            return @"主题";
        }else if (section == 1){
            return @"聚会人数";
        }else{
            return @"具体信息";
        }
    }
    return nil;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.partyTableView) {
        if (indexPath.section == 1) {
            self.backView = [[UIView alloc] initWithFrame:self.view.frame];
            self.backView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
            self.countView = [[UITableView alloc] initWithFrame:CGRectMake(107, 200, 200, 250) style:(UITableViewStylePlain)];
            self.countView.delegate = self;
            self.countView.dataSource = self;
            [self.countView registerClass:[UITableViewCell class] forCellReuseIdentifier:systemCellIdentifier];
            [self addHeadView];
            [self.backView addSubview:self.countView];
            [self.view addSubview:self.backView];
        }
    }else if (tableView == self.countView){
        [self.backView removeFromSuperview];
        self.count = self.countArray[indexPath.row];
        [self.partyTableView reloadData];
    }
    
}
#pragma mark--添加头部视图--
- (void)addHeadView{
    self.headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.countView.width, 50)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(70, 0, 100, 50)];
    label.textColor = [UIColor colorWithRed:243/255.0 green:32/255.0 blue:37/255.0 alpha:1];
    label.text = @"请选择";
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 50, self.countView.width, 1)];
    lineView.backgroundColor = [UIColor colorWithRed:243/255.0 green:32/255.0 blue:37/255.0 alpha:1];
    [self.headView addSubview:label];
    [self.headView addSubview:lineView];
    [self.countView setTableHeaderView:self.headView];
}
#pragma mark--cell上的按钮的点击方法--
- (void)selectAction:(UIButton *)btn{
    if (self.isSelected) {
        [btn setBackgroundImage:[UIImage imageNamed:@"Selected"] forState:(UIControlStateNormal)];
        self.isSelected = NO;
    }else{
        [btn setBackgroundImage:[UIImage imageNamed:@"notSelected"] forState:(UIControlStateNormal)];
        self.isSelected = YES;
    }
}
#pragma mark--touchBegin方法移除人数选择视图--
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.backView removeFromSuperview];
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
