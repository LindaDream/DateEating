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
#import "YTimePiker.h"
#import "YRestaurantViewController.h"
#import "YCompleteViewController.h"
@interface YPublishPartyViewController ()<
    UITableViewDataSource,
    UITableViewDelegate,
    UIPickerViewDelegate,
    UIPickerViewDataSource,
    passConcreteValue,
    UITextFieldDelegate
>
// 判断cell上的按钮是否点击
@property(assign,nonatomic)BOOL isSelected;
// 设置聚会人数的视图
@property(strong,nonatomic)UIView *countBackView;
@property(strong,nonatomic)UITableView *countView;
// 聚会人数视图的头部视图
@property(strong,nonatomic)UIView *headView;
// 存放聚会人数选项的数组
@property(strong,nonatomic)NSArray *countArray;
// 聚会对象
@property(strong,nonatomic)NSString *count;
// 显示picker的背景视图
@property(strong,nonatomic)UIView *backView;
// picker视图
@property(strong,nonatomic)UIPickerView *pickerView;
@property(strong,nonatomic)NSMutableString *dateStr;
@property(strong,nonatomic)NSString *message;
@property(strong,nonatomic)NSString *dateTmpStr;
@property(strong,nonatomic)NSString *hourTmpStr;
@property(strong,nonatomic)NSString *minuteTmpStr;
// 聚会时间
@property(strong,nonatomic)NSString *timeStr;
// 聚会主题
@property(strong,nonatomic)NSString *themeStr;
// 聚会说明
@property(strong,nonatomic)NSString *findStr;
// 聚会花费
@property(strong,nonatomic)NSString *concrete;

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
    if (nil != [[AVUser currentUser] objectForKey:@"age"] && nil != [[AVUser currentUser] objectForKey:@"gender"] && nil != [[AVUser currentUser] objectForKey:@"constellation"]) {
        if (nil != self.timeStr && nil != self.themeStr && nil != self.addressStr && nil != self.findStr && nil != self.concrete && nil != self.count) {
            // 发送publishDate通知
            [[NSNotificationCenter defaultCenter] postNotificationName:@"publishDate" object:nil userInfo:@{@"theme":self.themeStr,@"time":self.timeStr,@"address":self.addressStr,@"description":self.findStr}];
            AVObject *object = [AVObject objectWithClassName:@"MyParty"];
            [object setObject:[AVUser currentUser].username forKey:@"userName"];
            [object setObject:self.themeStr forKey:@"theme"];
            [object setObject:self.timeStr forKey:@"time"];
            [object setObject:self.addressStr forKey:@"address"];
            [object setObject:self.findStr forKey:@"description"];
            [object setObject:self.count forKey:@"partyCount"];
            [object setObject:self.concrete forKey:@"concrete"];
            [object setObject:self.businessID forKey:@"businessID"];
            [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (succeeded) {
                    NSLog(@"保存成功");
                }
            }];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"提示" message:@"请完善约会信息!" preferredStyle:(UIAlertControllerStyleAlert)];
            UIAlertAction *doneAction = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            }];
            [alertView addAction:doneAction];
            [self presentViewController:alertView animated:YES completion:nil];
        }
    }else{
        UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"提示" message:@"请先完善资料再来发布聚会!" preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *doneAction = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            YCompleteViewController *completeVC = [YCompleteViewController new];
            [self.navigationController pushViewController:completeVC animated:YES];
        }];
        [alertView addAction:doneAction];
        [self presentViewController:alertView animated:YES completion:nil];
    }
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self.partyTableView reloadData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"发布聚会";
    self.isSelected = YES;
    self.dateStr = @"".mutableCopy;
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
            return 2;
        }else if (section == 1){
            return 1;
        }
        return 3;
    }
    return 4;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.partyTableView) {
        if (indexPath.section == 0) {
            if (indexPath.row == 0) {
                YThemeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:themeCellIdentifier forIndexPath:indexPath];
                cell.themeTF.placeholder = @"请输入聚会主题";
                self.themeStr = cell.themeTF.text;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
            }else{
                YFindeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:findeCellIdentifier forIndexPath:indexPath];
                self.findStr = cell.findeTF.text;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
            }
        }else if (indexPath.section == 1){
            YPartyCountTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:countCellIdentifier forIndexPath:indexPath];
            cell.countLabel.text = self.count;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }else{
            if (indexPath.row == 0) {
                YConcreteTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:concreteCellIdentifier forIndexPath:indexPath];
                cell.delegate = self;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
            }else if (indexPath.row == 1 || indexPath.row == 2){
                YTimeOrAddressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:timeOrAddressCellIdentifier forIndexPath:indexPath];
                if (indexPath.row == 1) {
                    cell.timeOrAddLabel.text = @"时间";
                    cell.addressLabel.text = self.timeStr;
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                }else{
                    cell.timeOrAddLabel.text = @"地点";
                    cell.addressLabel.text = self.addressStr;
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                }
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
    return nil;
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
            self.countBackView = [[UIView alloc] initWithFrame:self.view.frame];
            self.countBackView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
            self.countView = [[UITableView alloc] initWithFrame:CGRectMake(107, 200, 200, 250) style:(UITableViewStylePlain)];
            self.countView.delegate = self;
            self.countView.dataSource = self;
            [self.countView registerClass:[UITableViewCell class] forCellReuseIdentifier:systemCellIdentifier];
            [self addHeadView];
            [self.countBackView addSubview:self.countView];
            [self.view addSubview:self.countBackView];
        }else if (indexPath.section == 2 && indexPath.row == 1){
            [self addPickerView];
        }else if (indexPath.section == 2 && indexPath.row == 2){
            YRestaurantViewController *restaurantVC = [YRestaurantViewController new];
            restaurantVC.passValueBlock = ^(NSString *addressStr,NSString *businessID){
                self.addressStr = addressStr;
                self.businessID = businessID;
                [self.partyTableView reloadData];
            };
            [self.navigationController pushViewController:restaurantVC animated:YES];
        }
        
    }else if (tableView == self.countView){
        [self.countBackView removeFromSuperview];
        self.count = self.countArray[indexPath.row];
        [self.partyTableView reloadData];
    }
    
}
#pragma mark--cell的代理方法实现--
-(void)passConcreteValue:(NSString *)concrete cell:(YConcreteTableViewCell *)cell{
    self.concrete = concrete;
    if (!cell.isSelect) {
        self.isSelected = YES;
    }else{
        self.isSelected = NO;
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
#pragma mark--touchBegin方法移除人数选择视图--
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.countBackView removeFromSuperview];
    [self.backView removeFromSuperview];
}
#pragma mark--搭建picker视图--
- (void)addPickerView{
    self.dateStr = @"".mutableCopy;
    // 背景view
    self.backView = [[UIView alloc] initWithFrame:self.view.frame];
    self.backView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    [self.view addSubview:self.backView];
    
    // pickerView
    self.pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(30, 200, 350, 200)];
    self.pickerView.layer.masksToBounds = YES;
    self.pickerView.layer.cornerRadius = 10;
    self.pickerView.backgroundColor = [UIColor whiteColor];
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
    [self.backView addSubview:self.pickerView];
}
#pragma mark--pickerView的dataSource协议中的方法，返回控件包含几列--
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 3;
}
#pragma mark--设置每行的内容--
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if (component == 0) {
        return [[[YTimePiker sharedYTimePiker] dateArray] objectAtIndex:row];
    }else if(component == 1){
        return [[[YTimePiker sharedYTimePiker] hourArray] objectAtIndex:row];
    }else{
        return [[[YTimePiker sharedYTimePiker] minuteArray] objectAtIndex:row];
    }
}
#pragma mark--放方法决定该控件包含多少个列表项--
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (component == 0) {
        return [[YTimePiker sharedYTimePiker] dateArray].count;
    }else if (component == 1){
        return [[YTimePiker sharedYTimePiker] hourArray].count;
    }else{
        return [[YTimePiker sharedYTimePiker] minuteArray].count;
    }
}
#pragma mark--pickerView点击方法--
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (component == 0) {
        self.dateStr = [self.dateStr stringByAppendingString:[[[YTimePiker sharedYTimePiker] dateArray] objectAtIndex:row]].mutableCopy;
        self.dateTmpStr = [[[YTimePiker sharedYTimePiker] dateArray] objectAtIndex:row];
    }else if (component == 1){
        self.dateStr = [self.dateStr stringByAppendingString:[NSString stringWithFormat:@"%@ ",[[[YTimePiker sharedYTimePiker] hourArray] objectAtIndex:row]]].mutableCopy;
        self.hourTmpStr = [NSString stringWithFormat:@"%@ ",[[[YTimePiker sharedYTimePiker] hourArray] objectAtIndex:row]];
    }
    if (component == 2) {
        self.dateStr = [self.dateStr stringByAppendingString:[NSString stringWithFormat:@": %@",[[[YTimePiker sharedYTimePiker] minuteArray] objectAtIndex:row]]].mutableCopy;
        self.minuteTmpStr = [[[YTimePiker sharedYTimePiker] minuteArray] objectAtIndex:row];
        self.message = [NSString stringWithFormat:@"您选择的时间是%@",self.dateStr];
        [self selectedTime:self.message];
    }
}
- (void)selectedTime:(NSString *)message{
    NSMutableString *str = @"".mutableCopy;
    str = [[[str stringByAppendingString:self.dateTmpStr].mutableCopy stringByAppendingString:self.hourTmpStr].mutableCopy stringByAppendingString:[NSString stringWithFormat:@": %@",self.minuteTmpStr].mutableCopy].mutableCopy;
    if (![self.dateStr isEqualToString:str]) {
        UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"提示" message:@"请选择正确的时间,例如:2016-01-1周五 00 : 00。请依次选择日期和时间!" preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *doneAction = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {
            self.dateStr = @"".mutableCopy;
        }];
        [alertView addAction:doneAction];
        [self presentViewController:alertView animated:YES completion:nil];
    }else{
        UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *doneAction = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            self.timeStr = self.dateStr;
            self.dateStr = @"".mutableCopy;
            [self.backView removeFromSuperview];
            [self.partyTableView reloadData];
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {
            self.dateStr = @"".mutableCopy;
        }];
        [alertView addAction:cancelAction];
        [alertView addAction:doneAction];
        [self presentViewController:alertView animated:YES completion:nil];
    }
}
#pragma mark--设置每列的宽度--
-(CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    if (component == 0) {
        return 200;
    }else if(component == 1){
        return 50;
    }else{
        return 50;
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
