//
//  YFunnyDetailViewController.m
//  DateEating
//
//  Created by lanou3g on 16/7/21.
//  Copyright © 2016年 user. All rights reserved.
//

#import "YFunnyDetailViewController.h"
#import "YFunnyModel.h"
#import "AppDelegate.h"
#import "SVProgressHUD.h"
#import "YContent.h"
#import "YContentTableViewCell.h"

@interface YFunnyDetailViewController ()<SDCycleScrollViewDelegate, UIScrollViewDelegate, UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *publishName;

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;


@property (weak, nonatomic) IBOutlet UITableView *contentTableView;

@property (weak, nonatomic) IBOutlet UITextField *contentTextField;

@property (weak, nonatomic) IBOutlet UIButton *sendContentBtn;

@property (weak, nonatomic) IBOutlet UIScrollView *contentScorllView;

@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;


@property (nonatomic, strong) SDCycleScrollView *cycleScrollView;
// 该页发布者的唯一标识
@property (strong,nonatomic) NSString *ownerId;

// 存放评论的数组
@property (strong,nonatomic) NSArray *contentArr;
@end


// 重用标识符
static NSString *const contentCellId = @"contentCellId";


@implementation YFunnyDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置view
    [self setTheView];
    
    // 去掉cell的系统分割线
    self.contentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    // 初始化ownerId
    self.ownerId = [NSString stringWithFormat:@"%@%@",_funny.publishName,_funny.publishTime];

    
    
    // 注册cell
    [self.contentTableView registerNib:[UINib nibWithNibName:@"YContentTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:contentCellId];
    
    
}

// 设置view
- (void)setTheView{

    self.publishName.text = _funny.publishName;
    self.contentLabel.text = _funny.publishContent;
    [self.publishName sizeToFit];
    
    if (_funny.imgArr.count == 0) {
        
        self.scrollView.hidden = YES;
        self.scrollView.height = 0;
    }else if (_funny.imgArr.count == 1){
        
        self.scrollView.hidden = NO;
        
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.scrollView.width, self.scrollView.height)];
        [imgView sd_setImageWithURL:[NSURL URLWithString:_funny.imgArr[0]]];
        [self.scrollView addSubview:imgView];
        
    }else{
        self.scrollView.hidden = NO;
        // 用网络图片实现
        NSArray *imageURLString = _funny.imgArr; // 解析数据时得到的轮播图数组
        
        // 创建代标题的轮播图
        _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:self.scrollView.frame imageURLStringsGroup:nil];
        
        // 设置代理
        _cycleScrollView.delegate = self;
        // 设置小圆点的位置
        _cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
        // 设置小圆点动画效果
        _cycleScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleClassic;
        // 小圆点颜色
        _cycleScrollView.pageDotColor = [UIColor whiteColor];
        _cycleScrollView.currentPageDotColor = [UIColor greenColor];
        // 把图片数组赋值给每个图片
        _cycleScrollView.imageURLStringsGroup = imageURLString;
        
        // 几秒钟换图片
        _cycleScrollView.autoScrollTimeInterval = 3;
        
        [self.scrollView addSubview:_cycleScrollView];
    }
    
    [YContent getContentAvatarWithUserName:self.publishName.text SuccessRequest:^(id dict) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"%@",dict);
            [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:dict]];
        });
    } failurRequest:^(NSError *error) {
        NSLog(@"获取头像失败");
    }];

    
}


- (void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    [self getAllContent];
    
}



#pragma mark--获取评论--
- (void)getAllContent{

    
    [YContent parsesContentWithOwnerId:self.ownerId SuccessRequest:^(id dict) {
        
        self.contentArr = dict;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.contentTableView reloadData];
        });
        
        
    } failurRequest:^(NSError *error) {
        [self showAlertViewWithMessage:@"获取评论失败"];
    }];
    
}




#pragma mark--发送评论--
- (IBAction)sendContentAction:(id)sender {
    
    if (self.contentTextField.text.length == 0) {
        [self showAlertViewWithMessage:@"请填写评论，再发送"];
    }else{
        
        // 显示菊花
        [SVProgressHUD showWithMaskType:(SVProgressHUDMaskTypeClear)];
        
        AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
        
        appDelegate.window.userInteractionEnabled = NO;
        
        NSString *fromName = [AVUser currentUser].username;
        NSString *ownerId = [NSString stringWithFormat:@"%@%@",_funny.publishName,_funny.publishTime];
        AVObject *contentObject = [[AVObject alloc] initWithClassName:@"ContentObject"];
        [contentObject setObject:ownerId forKey:@"ownerId"];
        [contentObject setObject:fromName forKey:@"fromName"];
        [contentObject setObject:_funny.publishName forKey:@"toName"];
        [contentObject setObject:self.contentTextField.text forKey:@"contents"];
        
        [contentObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                // 隐藏菊花
                [SVProgressHUD dismiss];
                
                AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
                appDelegate.window.userInteractionEnabled = YES;
                
                if (succeeded) {
                    [self showAlertViewWithMessage:@"评论成功"];
                    
                    [self getAllContent];
                    
                }else{
                    [self showAlertViewWithMessage:@"评论失败，请稍后重试"];
                    NSLog(@"%ld",error.code);
                }
            });
        }];
        
    }
    
}


#pragma mark--UITableViewDataSource--
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.contentArr.count;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    YContent *content = self.contentArr[indexPath.row];
    YContentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:contentCellId forIndexPath:indexPath];
    cell.content = content;
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    YContent *content = self.contentArr[indexPath.row];
    return [YContentTableViewCell cellHeight:content];
    
}









// 弹框
- (void)showAlertViewWithMessage:(NSString *)message
{
    UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    
    // 1秒后回收
    [self performSelector:@selector(dismissAlertView:) withObject:alertView afterDelay:1.5];
    [self presentViewController:alertView animated:YES completion:nil];
}
- (void)dismissAlertView:(UIAlertController *)alertView
{
    [alertView dismissViewControllerAnimated:YES completion:nil];
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
