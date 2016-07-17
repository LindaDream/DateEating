//
//  YViewController.m
//  DateEating
//
//  Created by lanou3g on 16/7/13.
//  Copyright © 2016年 user. All rights reserved.
//

#import "YEssenceViewController.h"
#import "YMealOrPlayTableViewCell.h"
#import "YPopView.h"
#import "YTabBar.h"
#import "YMealModel.h"
#import "YPlayModel.h"
#import "YPlayDetailModel.h"
#import "YCityModel.h"
#import "PlayDetailsViewControllerViewController.h"
#import "MealDetailsViewController.h"


@interface YEssenceViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UISegmentedControl *segment;

@property (weak, nonatomic) IBOutlet UIScrollView *scroll;

@property (weak, nonatomic) IBOutlet UITableView *mealTableView;

@property (weak, nonatomic) IBOutlet UITableView *playTableView;

@property(strong,nonatomic)UIView *VC;

// 是否已经弹框
@property (assign,nonatomic) BOOL isSelected;
// 弹框
@property (strong,nonatomic) YPopView *popView;
// 点击手势，用于使弹框消失
@property (strong,nonatomic) UITapGestureRecognizer *tap;
// 在美食界面还是在完了界面
@property (strong,nonatomic) NSString *isMeal;
// 美食界面的model数组
@property (strong,nonatomic) NSMutableArray *mealArr;
// 玩乐界面的model数组
@property (strong,nonatomic) NSMutableArray *playArr;
// 城市界面的model数组
@property (strong,nonatomic) NSArray *cityArr;

@property (weak, nonatomic) IBOutlet UITableView *cityTableView;

@property (weak, nonatomic) IBOutlet UIView *managerView;
// 城市Id
@property (assign,nonatomic) NSInteger cityId;
// 类型
@property (strong,nonatomic) NSString *categoryId;
// 判断是上啦还是下拉
@property (strong,nonatomic) NSString *howRefresh;
// 美食页请求数据的页码
@property (strong,nonatomic) NSNumber *mealPage;
// 玩乐页请求数据的页码
@property (strong,nonatomic) NSNumber *playPage;
// 数据总条数
@property (strong,nonatomic) NSString *rows;


@end


// 重用标识符
static NSString *const mealCellId = @"mealCellId";
static NSString *const playCellId = @"playCellId";
static NSString *const cityCellId = @"cityCellId";


@implementation YEssenceViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 接收夜间模式转换通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(change:) name:@"NotificationNight" object:nil];
    // 接收加号按钮点击通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dateView:) name:@"DateButtonClicked" object:nil];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    // 设置view的背景色
    self.view.backgroundColor = YRGBbg;
    // 设置导航栏左边的按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"城市" style:(UIBarButtonItemStylePlain) target:self action:@selector(tagClick)];
    
    // 设置导航栏右侧按钮
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImage:@"MainTagSubIcon" heightImage:@"MainTagSubIconClick" target:self action:@selector(rightClick)];
    
    // 测试视图（要删掉）
    self.VC = [[UIView alloc] initWithFrame:self.view.frame];
    self.VC.backgroundColor = [UIColor whiteColor];
    //[self.view addSubview:self.VC];
    
    // 初始化isSelected等
    self.isSelected = NO;
    self.isMeal = @"美食";
    self.categoryId = @"";
    self.cityId = 3;
    self.mealPage = @(1);
    self.playPage = @(1);
    // 初始化数组
    self.mealArr = [NSMutableArray array];
    self.playArr = [NSMutableArray array];
    // 刚加载时请求数据
    [self requestMealWithCityId:self.cityId categoryId:self.categoryId page:[NSString stringWithFormat:@"%d",self.mealPage.intValue]];
    [self requestPlayWithCityId:self.cityId categoryId:self.categoryId page:[NSString stringWithFormat:@"%d",self.playPage.intValue]];
    [self requestCity];
    
    // 注册cell
    [self.mealTableView registerNib:[UINib nibWithNibName:@"YMealOrPlayTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:mealCellId];
    [self.playTableView registerNib:[UINib nibWithNibName:@"YMealOrPlayTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:playCellId];
    [self.cityTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cityCellId];
    
    self.scroll.delegate = self;
    
    // 为分段控制器添加方法
    [self.segment addTarget:self action:@selector(changePage:) forControlEvents:UIControlEventValueChanged];
    
    // 自定义点击手势，使_popView消失
    _tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    
    __weak typeof(self) weakSelf = self;
    // 下拉刷新
    self.mealTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.howRefresh = @"下拉刷新";
        //[weakSelf.mealArr removeAllObjects];
        [weakSelf requestMealWithCityId:weakSelf.cityId categoryId:weakSelf.categoryId page:@"1"];
        [weakSelf.mealTableView.mj_header endRefreshing];
    }];
    self.playTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.howRefresh = @"下拉刷新";
        //[weakSelf.playArr removeAllObjects];
        [weakSelf requestPlayWithCityId:weakSelf.cityId categoryId:weakSelf.categoryId page:@"1"];
        [weakSelf.playTableView.mj_header endRefreshing];
    }];
    // 上啦加载
    self.mealTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        weakSelf.howRefresh = @"上拉加载";
        [weakSelf requestMealWithCityId:weakSelf.cityId categoryId:weakSelf.categoryId page:[NSString stringWithFormat:@"%d",weakSelf.mealPage.intValue]];
        [weakSelf.mealTableView.mj_footer endRefreshing];
        
    }];
    self.playTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        weakSelf.howRefresh = @"上拉加载";
        [weakSelf requestPlayWithCityId:weakSelf.cityId categoryId:weakSelf.categoryId page:[NSString stringWithFormat:@"%d",weakSelf.playPage.intValue]];
        [weakSelf.playTableView.mj_footer endRefreshing];
    }];
    
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


// 请求美食界面的数据
- (void)requestMealWithCityId:(NSInteger)cityId categoryId:(NSString *)categoryId page:(NSString *)page{

    // 拼接路径
    NSString *mealStr = kMealUrl(cityId,categoryId,page);
    //NSString *mealStr = @"https://api.yhouse.com/m/meal/list?cityId=3&categoryId=&page=1&pageSize=20";
    
    // 为两个数组赋值
    [YMealModel parsesWithUrl:mealStr successRequest:^(id dict) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (self.isSelected || [self.howRefresh isEqualToString:@"下拉刷新"]){
                [self.mealArr removeAllObjects];
            }

            [self.mealArr addObjectsFromArray:dict];
            self.mealPage = ((YMealModel *)self.mealArr.lastObject).nextPage;
            [self.mealTableView reloadData];
        });
        
    } failurRequest:^(NSError *error) {
        
    }];
    
    
}

// 请求玩乐界面的数据
- (void)requestPlayWithCityId:(NSInteger)cityId categoryId:(NSString *)categoryId page:(NSString *)page{
    
    // 拼接路径
    NSString *playStr = kPlayUrl(page,cityId,categoryId);
    
    // 为两个数组赋值
    [YPlayModel parsesWithUrl:playStr successRequest:^(id dict) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.isSelected || [self.howRefresh isEqualToString:@"下拉刷新"]) {
                [self.playArr removeAllObjects];
            }
//            if ([self.howRefresh isEqualToString:@"上拉加载"]) {
//                for (YPlayModel *play in dict) {
//                    if (play.ID == ) {
//                        <#statements#>
//                    }
//                }
//            }
            
            
            NSNumber *nextPage = ((YMealModel *)((NSArray *)dict).lastObject).nextPage;
//            if ([self.playPage compare:nextPage] == 0) {
//                NSLog(@"已经是最后一条了");
//            }else{
                [self.playArr addObjectsFromArray:dict];
                self.playPage = nextPage;
            NSNumber *p = ((YMealModel *)self.playArr.lastObject).nextPage;
            NSLog(@"nextPage = %@ p = %@",self.playPage,p);
            //}
            [self.playTableView reloadData];
        });
        
    } failurRequest:^(NSError *error) {
        
    }];
}

// 请求城市界面的数据
- (void)requestCity{
    
    // 为两个数组赋值
    [YCityModel parsesWithUrl:kCityIDUrl successRequest:^(id dict) {
        self.cityArr = dict;
        NSLog(@"=============%@",self.cityArr);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.cityTableView reloadData];
        });
        
    } failurRequest:^(NSError *error) {
        
    }];
}



- (void)tagClick{
    
    if (self.managerView.x == 0) {
        self.managerView.x = 130;
    }else{
        self.managerView.x = 0;
    }
    
    
}

// 导航栏右侧按钮触发的方法
- (void)rightClick{
    
    if (!self.isSelected) {
        
        _popView = [[YPopView alloc] initWithStr:self.isMeal];
        _popView.center = CGPointMake(kWidth, 0);
        [self.view addSubview:_popView];
        // 动画
        [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.2 initialSpringVelocity:3 options:(UIViewAnimationOptionCurveEaseInOut) animations:^{
            
            _popView.center = self.view.center;
            
            _popView.transform = CGAffineTransformMakeScale(1.1, 1.1);
            
        } completion:^(BOOL finished) {
            
        }];

        [self.popView addGestureRecognizer:self.tap];
        self.isSelected = YES;
        
        // 点击btn触发的事件
        __weak typeof(self) __weakSelf = self;
        self.popView.ba = ^(NSInteger tag){
            NSLog(@"点击了btn的tag = %ld",tag);
            __weakSelf.categoryId = [NSString stringWithFormat:@"%ld",tag];
            if (tag == 0) {
                __weakSelf.categoryId = @"";
            }

            if ([__weakSelf.isMeal isEqualToString:@"美食"]) {
                //[__weakSelf.mealArr removeAllObjects];
                [__weakSelf requestMealWithCityId:__weakSelf.cityId categoryId:__weakSelf.categoryId page:@"1"];
                
            }else{
                //[__weakSelf.playArr removeAllObjects];
                [__weakSelf requestPlayWithCityId:__weakSelf.cityId categoryId:__weakSelf.categoryId page:@"1"];
            
            }
            [__weakSelf.popView removeFromSuperview];
            
            __weakSelf.popView.center = CGPointMake(kWidth, 0);
            __weakSelf.isSelected = NO;
        };
        
    }else{
        
        [_popView removeFromSuperview];
        
        _popView.center = CGPointMake(kWidth, 0);
        self.isSelected = NO;
        
    }
    
    
}

// 点击手势触发的方法
- (void)tapAction{

    if (self.isSelected) {
        
        [self.popView removeFromSuperview];
        _popView.center = CGPointMake(kWidth, 0);
        self.isSelected = NO;
    }
    
}

#pragma mark -- scrollde 代理方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{

    if (self.scroll == scrollView) {
        self.segment.selectedSegmentIndex = scrollView.contentOffset.x / kWidth;
        if (self.segment.selectedSegmentIndex == 0) {
            self.isMeal = @"美食";
            //[self requestMealWithCityId:self.cityId categoryId:self.categoryId];
        }else{
            self.isMeal = @"玩乐";
            //[self requestPlayWithCityId:self.cityId categoryId:self.categoryId];
        }

    }
    
}
#pragma mark -- segment滑动换页
- (void)changePage:(UISegmentedControl *)segment{
    
    self.scroll.contentOffset = CGPointMake(kWidth * self.segment.selectedSegmentIndex, 0);
    if (self.segment.selectedSegmentIndex == 0) {
        self.isMeal = @"美食";
        //[self requestMealWithCityId:self.cityId categoryId:self.categoryId];
    }else{
        self.isMeal = @"玩乐";
        //[self requestPlayWithCityId:self.cityId categoryId:self.categoryId];
    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (tableView == self.mealTableView) {
        return self.mealArr.count;
    }else if (tableView == self.playTableView) {
        NSLog(@"%ld",self.playArr.count);
        return self.playArr.count;
    }else {
        return self.cityArr.count;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == self.mealTableView) {
        
        YMealOrPlayTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:mealCellId forIndexPath:indexPath];
        cell.meal = self.mealArr[indexPath.row];
        return cell;
        
    }else if (tableView == self.playTableView) {
        
        YMealOrPlayTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:playCellId forIndexPath:indexPath];
        cell.play = self.playArr[indexPath.row];
        return cell;
    }else{
    
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cityCellId forIndexPath:indexPath];
        cell.textLabel.text = ((YCityModel *)self.cityArr[indexPath.row]).name;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
        
    }
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == self.mealTableView || tableView == self.playTableView) {
        return 189;
    }else{
        return 50;
    }
    
    
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == self.mealTableView) {
        

        
        MealDetailsViewController *mealVC = [[MealDetailsViewController alloc] init];
        
        if ([self.mealArr count] != 0) {
            YMealModel *model = self.mealArr[indexPath.row];
            mealVC.ID = [NSString stringWithFormat:@"%ld", model.ID];
            
        }
        mealVC.model = nil;
        
        [self.navigationController pushViewController:mealVC animated:YES];
        
    }else if (tableView == self.playTableView) {
        
        
        
        PlayDetailsViewControllerViewController *playVC = [[PlayDetailsViewControllerViewController alloc] init];
        if ([self.playArr count] != 0) {
            YPlayModel *model = self.playArr[indexPath.row];
            playVC.ID = [NSString stringWithFormat:@"%ld", model.ID];
        }
        playVC.isWhat = YES;
        
        [self.navigationController pushViewController:playVC animated:YES];
        
        
    }else{
        self.cityId = ((YCityModel *)self.cityArr[indexPath.row]).baseCityId;
        self.navigationItem.leftBarButtonItem.title = ((YCityModel *)self.cityArr[indexPath.row]).name;
        self.managerView.x = 0;
        [self requestMealWithCityId:self.cityId categoryId:self.categoryId page:@"1"];
        [self requestPlayWithCityId:self.cityId categoryId:self.categoryId page:@"1"];
    }
    
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
