//
//  XMGNewViewController.m
//  百思不得姐
//
//  Created by lanou3g on 16/5/6.
//  Copyright © 2016年 春晓. All rights reserved.
//

#import "YDateViewController.h"
#import "YDateListTableViewCell.h"
#import "YDetailViewController.h"
#import "YSeekConditionViewController.h"
#import "YNSUserDefaultHandel.h"
#import "YNetWorkRequestManager.h"
#import "Request_Url.h"
#import "YDateContentModel.h"
#import <MJRefreshAutoNormalFooter.h>
#import <MJRefreshNormalHeader.h>
#import "YUserDetailViewController.h"
#import "YCityTableViewController.h"

@interface YDateViewController ()
<
    UITableViewDataSource,
    UITableViewDelegate,
    UIScrollViewDelegate,
    YSeekConditionViewControllerDelegate,
    YDateListTableViewCellDelegate,
    YCityTableViewControllerDelegate
>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITableView *hotTableView;
@property (weak, nonatomic) IBOutlet UITableView *nearbyTableView;
@property (strong,nonatomic) UISegmentedControl *titleViewSegment;

@property (strong,nonatomic) UIBarButtonItem *barButton;
@property (strong,nonatomic) NSMutableArray *hotArray;
@property (strong,nonatomic) NSMutableArray *nearByArray;
@property (strong,nonatomic) NSMutableArray *ourServerData;
@property (strong, nonatomic) YNSUserDefaultHandel *handle;
@property (assign, nonatomic) NSInteger hotCount;
@property (assign,nonatomic) NSInteger nearbyCount;
@property (assign,nonatomic) BOOL isHotDown;
@property (assign,nonatomic) BOOL isNearByDown;
@property (strong, nonatomic) UIButton *button;

@end

@implementation YDateViewController

- (void)viewWillDisappear:(BOOL)animated {
    [self.button removeFromSuperview];
}
- (void)viewWillAppear:(BOOL)animated {
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(15, 7, 50, 30)];
    [button setImage:[UIImage imageNamed:@"NaviList"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"NaviList_"] forState:UIControlStateHighlighted];
    [button setTitleColor:YRGBColor(248, 89, 64) forState:UIControlStateNormal];
    [button setTitleColor:YRGBColor(0, 89, 64) forState:UIControlStateHighlighted];
    button.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    button.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 3);
    button.titleEdgeInsets = UIEdgeInsetsMake(0, 3, 0, 0);
    [button addTarget:self action:@selector(cityListAction:) forControlEvents:UIControlEventTouchUpInside];
    NSString *name = [self.handle city].allKeys.firstObject;
    [button setTitle:name forState:UIControlStateNormal];
    self.button = button;
    [self.navigationController.navigationBar addSubview:button];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = YRGBbg;
    self.handle = [YNSUserDefaultHandel sharedYNSUserDefaultHandel];
    // 接收夜间模式转换通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(change:) name:@"NotificationNight" object:nil];
    // 接收加号按钮点击通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dateView:) name:@"DateButtonClicked" object:nil];
    // 设置navigtationbar的头视图
    [self setNavigationBar];
    // 设置上拉加载下拉刷新
    [self refrushData];
    
    // 注册cell
    [self.hotTableView registerNib:[UINib nibWithNibName:@"YDateListTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:YDateListTableViewCell_Identify];
    [self.nearbyTableView registerNib:[UINib nibWithNibName:@"YDateListTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:YDateListTableViewCell_Identify];
    // 数据请求
    [self getData:@"MyDate"];
    [self getData:@"MyParty"];
    [self requestHotDataWithDic:[_handle city] start:0];
    [self requestNearByDataWithUrl:0];
    
    
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
        self.scrollView.userInteractionEnabled = NO;
        [self addDateBtnAndPartyBtn];
    }else{
        self.scrollView.userInteractionEnabled = YES;
        [self removeDateBtnAndPartyBtn];
    }
}

// 懒加载
- (NSMutableArray *)hotArray {
    if (!_hotArray) {
        _hotArray = [NSMutableArray array];
    }
    return _hotArray;
}
- (NSMutableArray *)nearByArray {
    if (!_nearByArray) {
        _nearByArray = [NSMutableArray array];
    }
    return _nearByArray;
}
- (NSMutableArray *)ourServerData {
    if (!_ourServerData) {
        _ourServerData = [NSMutableArray array];
    }
    return _ourServerData;
}

#pragma mark -- 从自己的服务器获取数据 --
- (void)getData:(NSString *)className{
    __weak YDateViewController *dateVC = self;
    AVQuery *query = [AVQuery queryWithClassName:className];
    [query whereKey:@"userName" equalTo:[AVUser currentUser].username];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (dateVC.isHotDown) {
            [dateVC.ourServerData removeAllObjects];
            dateVC.isHotDown = NO;
        }
        if (objects.count != 0) {
            for (AVObject *object in objects) {
                NSDictionary *dict = [object dictionaryForObject];
                YDateContentModel *model = [YDateContentModel new];
                model.eventName = [dict objectForKey:@"theme"];
                model.eventLocation = [dict objectForKey:@"address"];
                model.dateTime = [dict objectForKey:@"time"];
                if ([[dict objectForKey:@"concrete"] isEqualToString:@"我请客"]) {
                    model.fee = 0;
                }else{
                    model.fee = 1;
                }
                model.eventDescription = [dict objectForKey:@"description"];
                model.caterBusinessId = [dict objectForKey:@"businessID"];
                model.user = [[YActionUserModel alloc]init];
                [model.user setValue:[AVUser currentUser].username forKey:@"nick"];
                model.user.gender = [[[AVUser currentUser] objectForKey:@"gender"] integerValue];
                model.user.constellation = [[AVUser currentUser] objectForKey:@"constellation"];
                AVFile *file = [[AVUser currentUser] objectForKey:@"avatar"];
                [file getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                    UIImage *img = [UIImage imageWithData:data];
                    model.img = img;
                }];
                dispatch_async(dispatch_get_main_queue(), ^{
                    if ([className isEqualToString:@"MyDate"]) {
                        //SLog(@"%@asfasfasdfa",model);
                        [self.ourServerData addObject:model];
                        [self.hotTableView reloadData];
                    }else{
                        [self.ourServerData addObject:model];
                        [self.hotTableView reloadData];
                    }
                });
            }
        }
    }];
}


#pragma mark -- 数据查询 --
- (void)requestHotDataWithDic:(NSDictionary *)dic start:(NSInteger)start {
    __weak YDateViewController *dateVC = self;
    NSNumber *city = dic[@"city"];
    [YNetWorkRequestManager getRequestWithUrl:HotRequest_Url(@"010",[_handle multi], [_handle gender], [_handle time], [_handle age], [_handle constellation], [_handle occupation], start) successRequest:^(id dict) {
        NSNumber *count = dict[@"data"][@"total"];
        dateVC.hotCount = count.integerValue;
        if (dateVC.isHotDown) {
            [dateVC.hotArray removeAllObjects];
            dateVC.isHotDown = NO;
        }
        [dateVC.hotArray addObjectsFromArray:[YDateContentModel getDateContentListWithDic:dict]];
        dispatch_async(dispatch_get_main_queue(), ^{
            [dateVC reloadAllData];
        });
    } failurRequest:^(NSError *error) {
        
    }];
}
- (void)requestNearByDataWithUrl:(NSInteger )start {
    __weak YDateViewController *dateVC = self;
    [YNetWorkRequestManager getRequestWithUrl:NearByRequest_Url([_handle multi], [_handle gender], [_handle time], [_handle age], [_handle constellation], [_handle occupation], start) successRequest:^(id dict) {
        NSNumber *count = dict[@"data"][@"total"];
        dateVC.nearbyCount = count.integerValue;
        if (dateVC.isNearByDown) {
            [dateVC.nearByArray removeAllObjects];
            dateVC.isNearByDown = NO;
        }
        [dateVC.nearByArray addObjectsFromArray:[YDateContentModel getDateContentListWithDic:dict]];
        dispatch_async(dispatch_get_main_queue(), ^{
            [dateVC reloadAllData];
        });
    } failurRequest:^(NSError *error) {
        
    }];
}

#pragma mark -- 刷新数据 --
- (void)reloadAllData {
    [self.hotTableView reloadData];
    [self.nearbyTableView reloadData];
}

#pragma mark -- 上拉加载 --
- (void)refrushData {
    // 尾
    MJRefreshAutoNormalFooter *footerHot = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreHotData:)];
    [footerHot setTitle:@"" forState:MJRefreshStateIdle];
    [footerHot setTitle:@"正在加载..." forState:MJRefreshStateRefreshing];
    [footerHot setTitle:@"没有更多了" forState:MJRefreshStateNoMoreData];
    footerHot.stateLabel.font = [UIFont systemFontOfSize:17];
    footerHot.stateLabel.textColor = YRGBColor(248, 89, 64);
    self.hotTableView.mj_footer = footerHot;
    
    MJRefreshAutoNormalFooter *footerNearBy = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreNearByData:)];
    [footerNearBy setTitle:@"" forState:MJRefreshStateIdle];
    [footerNearBy setTitle:@"正在加载..." forState:MJRefreshStateRefreshing];
    [footerNearBy setTitle:@"没有更多了" forState:MJRefreshStateNoMoreData];
    footerNearBy.stateLabel.font = [UIFont systemFontOfSize:17];
    footerNearBy.stateLabel.textColor = YRGBColor(248, 89, 64);
    self.nearbyTableView.mj_footer = footerNearBy;
    // 头
    __weak typeof(self) weakSelf = self;
    MJRefreshNormalHeader *headerHot = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.isHotDown = YES;
        [self getData:@"MyDate"];
        [self getData:@"MyParty"];
        [weakSelf requestHotDataWithDic:[weakSelf.handle city] start:0];
        [weakSelf.hotTableView.mj_header endRefreshing];
    }];
    self.hotTableView.mj_header = headerHot;
    
    MJRefreshNormalHeader *headerNearBy = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.isNearByDown = YES;
        [weakSelf requestNearByDataWithUrl:0];
        [weakSelf.nearbyTableView.mj_header endRefreshing];
    }];
    self.nearbyTableView.mj_header = headerNearBy;
}

- (void)loadMoreHotData:(MJRefreshAutoNormalFooter *)footer {
    if (self.hotArray.count >= self.hotCount) {
        footer.state = MJRefreshStateNoMoreData;
        return;
    }
    [self requestHotDataWithDic:[self.handle city] start:self.hotArray.count];
    [footer endRefreshing];
    
}
- (void)loadMoreNearByData:(MJRefreshAutoNormalFooter *)footer {
    if (self.nearByArray.count >= self.nearbyCount) {
        footer.state = MJRefreshStateNoMoreData;
        return;
    }
    [self requestNearByDataWithUrl:self.nearByArray.count];
    [footer endRefreshing];
}

#pragma mark -- 设置导航栏上的各功能按钮 --
- (void)setNavigationBar {
    
    // 设置右边的按钮
    NSString *imgString = nil;
    if ([self.handle haveSeekCondition]) {
        imgString = @"NaviFiltered";
    } else {
        imgString = @"NaviUnFiltered";
    }
    self.barButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:imgString] style:UIBarButtonItemStyleDone target:self action:@selector(seekByConditionAction:)];
    self.navigationItem.rightBarButtonItem = _barButton;
    
    // 设置头视图
    self.titleViewSegment = [[UISegmentedControl alloc]initWithItems:@[@"热门",@"附近"]];
    _titleViewSegment.selectedSegmentIndex = 0;
    [_titleViewSegment addTarget:self action:@selector(titleViewSegmentAction:) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = _titleViewSegment;
}



#pragma mark -- segment触发的事件，关联滚动视图 --
- (void)titleViewSegmentAction:(UISegmentedControl *)segment {
    if (segment.selectedSegmentIndex == 0) {
        self.button.hidden = NO;
        self.scrollView.contentOffset = CGPointMake(0, 0);
    } else {
        self.button.hidden = YES;
        self.scrollView.contentOffset = CGPointMake(self.view.width, 0);
    }
}

#pragma mark -- 滚动视图实现的代理方法 --
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView == self.scrollView) {
        if (scrollView.contentOffset.x >= self.view.width) {
            self.titleViewSegment.selectedSegmentIndex = 1;
        } else {
            self.titleViewSegment.selectedSegmentIndex = 0;
        }
    }
}

#pragma mark -- 按条件查询数据 --
- (void)seekByConditionAction:(UIBarButtonItem *)item {
    YSeekConditionViewController *seekVC = [[YSeekConditionViewController alloc]init];
    seekVC.delegate = self;
    [self.navigationController pushViewController:seekVC animated:YES];
}

#pragma mark -- 选择查询条件后的代理回调 --
- (void)passSeekCondition {
    if ([self.handle haveSeekCondition]) {
        [self.barButton setImage:[UIImage imageNamed:@"NaviFiltered"]];
    } else {
        [self.barButton setImage:[UIImage imageNamed:@"NaviUnFiltered"]];
    }
    [self.hotArray removeAllObjects];
    [self.nearByArray removeAllObjects];
    [self requestHotDataWithDic:[self.handle city] start:0];
    [self requestNearByDataWithUrl:0];
}
#pragma mark -- 切换城市 --
- (void)cityListAction:(UIButton *)button {
    YCityTableViewController *cityVC = [[YCityTableViewController alloc]init];
    cityVC.delegate = self;
    [self.navigationController pushViewController:cityVC animated:YES];
}

#pragma mark -- 确定城市后的回调 --
- (void)didSelectCity:(YCityListModel *)model {
    // 设置button上显示的城市名
    self.button.titleLabel.text = model.city_name;
    [self.hotArray removeAllObjects];
    [self requestHotDataWithDic:[self.handle city] start:0];
}

#pragma mark -- 点击头像跳转个人详情页 --
- (void)clickedUserImage:(NSInteger)userId {
    YUserDetailViewController *userDetailVC = [[YUserDetailViewController alloc]init];
    userDetailVC.userId = userId;
    [self.navigationController pushViewController:userDetailVC animated:YES];
}


- (void)tagClick{
    
    YLogFunc;
    
}


#pragma mark -- tableview实现的代理方法 --
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (tableView == self.hotTableView) {
        return self.hotArray.count + self.ourServerData.count;
    }else {
        return self.nearByArray.count;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YDateListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:YDateListTableViewCell_Identify forIndexPath:indexPath];
    if (tableView == self.hotTableView) {
        if(indexPath.section < self.ourServerData.count) {
            cell.model = self.ourServerData[indexPath.section];
        } else {
            cell.model = self.hotArray[indexPath.section - self.ourServerData.count];
        }
    }else {
        cell.model = self.nearByArray[indexPath.section];
    }
    cell.delegate = self;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 200;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    YDetailViewController *detailVC = [[YDetailViewController alloc]init];
    if (tableView == self.hotTableView) {
        if(indexPath.section < self.ourServerData.count) {
            detailVC.model = self.ourServerData[indexPath.section];
        } else {
            detailVC.model = self.hotArray[indexPath.section - self.ourServerData.count];
        }
    } else {
        detailVC.model = self.nearByArray[indexPath.section];
    }
    [self.navigationController pushViewController:detailVC animated:YES];
}

// 间隔 （头部视图）
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 20;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 20)];
    headerView.backgroundColor = [UIColor clearColor];
    return headerView;
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
