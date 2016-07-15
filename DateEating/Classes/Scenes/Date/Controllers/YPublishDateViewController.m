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
#import "YTimePiker.h"
@interface YPublishDateViewController ()<
    UITableViewDataSource,
    UITableViewDelegate,
    UIPickerViewDataSource,
    UIPickerViewDelegate
>

@property (weak, nonatomic) IBOutlet UITableView *dateTableView;
// 判断cell上的按钮是否点击
@property(assign,nonatomic)BOOL isSelected;
// 显示picker的背景视图
@property(strong,nonatomic)UIView *backView;
// picker视图
@property(strong,nonatomic)UIPickerView *pickerView;
@property(strong,nonatomic)NSMutableString *dateStr;
@property(strong,nonatomic)NSString *message;
@property(strong,nonatomic)NSString *dateTmpStr;
@property(strong,nonatomic)NSString *hourTmpStr;
@property(strong,nonatomic)NSString *minuteTmpStr;
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
    self.dateStr = @"".mutableCopy;
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
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 2 && indexPath.row == 1) {
        [self addPickerView];
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
            self.dateStr = @"".mutableCopy;
            [self.backView removeFromSuperview];
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
