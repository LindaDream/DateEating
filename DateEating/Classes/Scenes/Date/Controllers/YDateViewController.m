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

@interface YDateViewController ()
<
    UITableViewDataSource,
    UITableViewDelegate,
    UIScrollViewDelegate,
    YSeekConditionViewControllerDelegate
>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITableView *hotTableView;
@property (weak, nonatomic) IBOutlet UITableView *nearbyTableView;
@property (strong,nonatomic) UISegmentedControl *titleViewSegment;

@property (strong,nonatomic) UIBarButtonItem *barButton;
@property (strong,nonatomic) NSMutableArray *hotArray;
@property (strong,nonatomic) NSMutableArray *nearByArray;
@property (strong, nonatomic) YNSUserDefaultHandel *handle;

@end

@implementation YDateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = YRGBbg;
    self.handle = [YNSUserDefaultHandel sharedYNSUserDefaultHandel];
    
    // 设置navigtationbar的头视图
    [self setNavigationBar];
    // 注册cell
    [self.hotTableView registerNib:[UINib nibWithNibName:@"YDateListTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:YDateListTableViewCell_Identify];
    [self.nearbyTableView registerNib:[UINib nibWithNibName:@"YDateListTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:YDateListTableViewCell_Identify];
    // 数据请求
    [self requestHotDataWithUrl];
    [self requestNearByDataWithUrl];
    
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

#pragma mark -- 数据查询 --
- (void)requestHotDataWithUrl {
    __weak YDateViewController *dateVC = self;
    [YNetWorkRequestManager getRequestWithUrl:HotRequest_Url([_handle multi], [_handle gender], [_handle time], [_handle age], [_handle constellation], [_handle occupation]) successRequest:^(id dict) {
        dateVC.hotArray = [YDateContentModel getDateContentListWithDic:dict];
        dispatch_async(dispatch_get_main_queue(), ^{
            [dateVC reloadAllData];
        });
    } failurRequest:^(NSError *error) {
        
    }];
}
- (void)requestNearByDataWithUrl {
    __weak YDateViewController *dateVC = self;
    [YNetWorkRequestManager getRequestWithUrl:NearByRequest_Url([_handle multi], [_handle gender], [_handle time], [_handle age], [_handle constellation], [_handle occupation]) successRequest:^(id dict) {
        dateVC.nearByArray = [YDateContentModel getDateContentListWithDic:dict];
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

#pragma mark -- 设置导航栏上的各功能按钮 --
- (void)setNavigationBar {
    
    // 设置导航栏左边的按钮
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"MainTagSubIcon" heightImage:@"MainTagSubIconClick" target:self action:@selector(tagClick)];
    // 设置右边的按钮
    self.barButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"NaviUnFiltered"] style:UIBarButtonItemStyleDone target:self action:@selector(seekByConditionAction:)];
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
        self.scrollView.contentOffset = CGPointMake(0, 0);
    } else {
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
    [self requestHotDataWithUrl];
    [self requestNearByDataWithUrl];
}

- (void)tagClick{
    
    YLogFunc;
    
}


#pragma mark -- tableview实现的代理方法 --
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (tableView == self.hotTableView) {
        return self.hotArray.count;
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
        cell.model = self.hotArray[indexPath.section];
    }else {
        cell.model = self.nearByArray[indexPath.section];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 200;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    YDetailViewController *detailVC = [[YDetailViewController alloc]init];
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
    UIImageView *creditImage = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.width -56, 6, 46, 46)];
    creditImage.image = [UIImage imageNamed:@"event_ranking_credit"];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 28, 28)];
    label.numberOfLines = 2;
    label.text = @"信用10";
    label.font = [UIFont systemFontOfSize:10];
    label.textAlignment = NSTextAlignmentCenter;
    label.center = creditImage.center;
    [headerView addSubview:creditImage];
    [headerView addSubview:label];
    return headerView;
}

//去掉UItableview headerview黏性
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    if (scrollView == self.hotTableView || scrollView == self.nearbyTableView)
//    {
//        CGFloat sectionHeaderHeight = 12;
//        if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
//            scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
//        } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
//            scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
//        }
//    }
//}


// 设置尾视图
- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
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
