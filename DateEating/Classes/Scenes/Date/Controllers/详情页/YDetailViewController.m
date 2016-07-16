//
//  YDetailViewController.m
//  DateEating
//
//  Created by lanou3g on 16/7/13.
//  Copyright © 2016年 user. All rights reserved.
//

#import "YDetailViewController.h"
#import "YDetailHeaderTableViewCell.h"
#import "YChatTableViewCell.h"
#import "YNetWorkRequestManager.h"
#import "Request_Url.h"
#import "YChatMessageModel.h"
#import "YCaterViewController.h"

@interface YDetailViewController ()
<
    UITableViewDataSource,
    UITableViewDelegate,
    UIScrollViewDelegate,
    YDetailHeaderTableViewCellDelegate
>


@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (strong, nonatomic) NSMutableArray *MessageArray;

@end

@implementation YDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"详情";
    self.automaticallyAdjustsScrollViewInsets = NO;
    // 设置收藏分享按钮
    UIBarButtonItem *saveBtn = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"favorite"] style:UIBarButtonItemStyleDone target:self action:@selector(saveBtnAction:)];
    UIBarButtonItem *shareBtn = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"share"] style:UIBarButtonItemStyleDone target:self action:@selector(shareBtnAction:)];
    self.navigationItem.rightBarButtonItems = @[shareBtn,saveBtn];
    
    // 注册
    [self.tableview registerNib:[UINib nibWithNibName:@"YDetailHeaderTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:YDetailHeaderTableViewCell_Identify];
    [self.tableview registerNib:[UINib nibWithNibName:@"YChatTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:YChatTableViewCell_Indentify];
    // 请求数据
    [self getRequestData];
}

// 懒加载
- (NSMutableArray *)MessageArray {
    if (!_MessageArray) {
        _MessageArray = [NSMutableArray array];
    }
    return _MessageArray;
}

#pragma mark -- 请求聊天信息 --
- (void)getRequestData {
    __weak YDetailViewController *detailVC = self;
    [YNetWorkRequestManager getRequestWithUrl:ChatMessageRequest_Url(self.model.ID) successRequest:^(id dict) {
        detailVC.MessageArray = [YChatMessageModel getDateContentListWithDic:dict];
        dispatch_async(dispatch_get_main_queue(), ^{
            [detailVC reloadData];
        });
    } failurRequest:^(NSError *error) {
        
    }];
}

- (void)reloadData {
    [self.tableview reloadData];
}

#pragma mark -- 分享按钮的响应事件 --
- (void)shareBtnAction:(UIBarButtonItem *)item {
    
}

#pragma mark -- 收藏操作 --
- (void)saveBtnAction:(UIBarButtonItem *)item {
    
}

#pragma mark -- 餐厅详情按钮代理 --
- (void)restaurantBtnDidClicked:(YDetailHeaderTableViewCell *)cell {
    YCaterViewController *caterVC = [[YCaterViewController alloc]init];
    caterVC.businessId = cell.model.caterBusinessId;
    [self.navigationController pushViewController:caterVC animated:YES];
}


#pragma mark -- tableview 实现的代理方法 --
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    return self.MessageArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        YDetailHeaderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:YDetailHeaderTableViewCell_Identify forIndexPath:indexPath];
        cell.delegate = self;
        cell.model = self.model;
        return cell;
    } else {
        YChatTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:YChatTableViewCell_Indentify forIndexPath:indexPath];
        cell.model = self.MessageArray[indexPath.row];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return [YDetailHeaderTableViewCell getHeightForCellWithActivity:self.model];
    }else {
        return [YChatTableViewCell getHeightForCellWithActivity:self.MessageArray[indexPath.row]];
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
