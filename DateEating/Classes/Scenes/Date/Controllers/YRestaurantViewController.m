//
//  YRestaurantViewController.m
//  DateEating
//
//  Created by user on 16/7/15.
//  Copyright © 2016年 user. All rights reserved.
//

#import "YRestaurantViewController.h"
#import "YRestaurantDetailViewController.h"
#import "YRestaurantDetailViewCell.h"
#import "YRestaurantListModel.h"
@interface YRestaurantViewController ()<UISearchBarDelegate,passCurrentCell>
@property(strong,nonatomic)UISearchBar *searchBar;
@property(strong,nonatomic)UILabel *cityLabel;
@property(strong,nonatomic)NSArray *dataArray;
@property(strong,nonatomic)YRestaurantListModel *model;
@end

static NSString *const restaurantListCellIndentifier = @"restaurantListCell";

@implementation YRestaurantViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.model = [YRestaurantListModel new];
    self.dataArray = [NSArray new];
    [self.tableView registerNib:[UINib nibWithNibName:@"YRestaurantDetailViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:restaurantListCellIndentifier];
    [self setNavigationBar];
    [self getData];
}
#pragma mark--设置导航栏--
- (void)setNavigationBar{
    // 设置搜索框
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 2, 250, 30)];
    self.searchBar.barStyle = UIBarStyleDefault;
    self.searchBar.delegate = self;
    self.searchBar.placeholder = @"请输入餐厅名称";
    self.searchBar.tintColor = [UIColor whiteColor];
    self.searchBar.autocapitalizationType = UITextAutocorrectionTypeNo;
    [self.searchBar resignFirstResponder];
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(50, 2, 250, 30)];
    [titleView addSubview:self.searchBar];
    self.navigationItem.titleView = titleView;
    // 设置城市按钮
    UIButton *cityBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.width - 50, CGRectGetMinY(titleView.frame), 40, 30)];
    [cityBtn addTarget:self action:@selector(cityListAction:) forControlEvents:(UIControlEventTouchUpInside)];
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 5, 20, 20)];
    imgView.image = [[UIImage imageNamed:@"didian"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    //imgView.tintColor = [UIColor whiteColor];
    [cityBtn addSubview:imgView];
    self.cityLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imgView.frame) + 3, 0, 30, 30)];
    self.cityLabel.text = @"北京";
    self.cityLabel.font = [UIFont systemFontOfSize:13];
    [cityBtn addSubview:self.cityLabel];
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithCustomView:cityBtn];
    self.navigationItem.rightBarButtonItem = rightButton;
}
#pragma mark--城市按钮点击事件--
- (void)cityListAction:(UIButton *)btn{
    
}
#pragma mark--数据请求--
- (void)getData{
    NSString *urlStr = [RestaurantList_URL(self.cityLabel.text) stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    [YRestaurantListModel parsesWithUrl:urlStr successRequest:^(id dict) {
        self.dataArray = dict;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    } failurRequest:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YRestaurantDetailViewCell *cell = [tableView dequeueReusableCellWithIdentifier:restaurantListCellIndentifier forIndexPath:indexPath];
    cell.delegate = self;
    self.model = self.dataArray[indexPath.row];
    cell.model = self.model;
    CGRect rect = cell.nameLabel.frame;
    CGFloat height = [self textHeightForLabel:cell.nameLabel];
    rect.size.height = height;
    cell.nameLabel.frame = rect;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    YRestaurantDetailViewController *detailVC = [YRestaurantDetailViewController new];
    self.model = self.dataArray[indexPath.row];
    detailVC.count = self.model.caterUserCount;
    detailVC.businessId = self.model.businessId;
    detailVC.addressStr = self.model.regionsStr;
    detailVC.nameStr = self.model.name;
    [self.navigationController pushViewController:detailVC animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 200;
}
#pragma mark--点击“吃这家”按钮的代理方法实现--
-(void)passCurrentCell:(YRestaurantDetailViewCell *)cell{
    self.passValueBlock(cell.nameLabel.text);
    [self.navigationController popViewControllerAnimated:YES];
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
