//
//  YEditViewController.m
//  DateEating
//
//  Created by lanou3g on 16/7/19.
//  Copyright © 2016年 user. All rights reserved.
//

#import "YEditViewController.h"
#import "YImageCollectionViewCell.h"
#import "ZZPhotoController.h"
#import "YFunnyModel.h"
#import "TransformManager.h"
#import "SVProgressHUD.h"
#import "AppDelegate.h"



@interface YEditViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UITextView *editTextView;

@property (weak, nonatomic) IBOutlet UICollectionView *imgCollectionView;

@property (strong,nonatomic) NSMutableArray *photoArray;

@end

static NSString *const imageCellId = @"imageCellId";

@implementation YEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createCollectionView];
    
    // 右上角添加发布按钮
    [self setRightBarButtonItem];
    // 注册cell
    [self.imgCollectionView registerNib:[UINib nibWithNibName:@"YImageCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:imageCellId];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(editStopAction:) name:UITextViewTextDidChangeNotification object:self.editTextView];
    
}

- (void)editStopAction:(UITextView *)textView{

    if (self.editTextView.text.length <= 0) {
        [self showAlertViewWithMessage:@"请输入文字"];
        self.editTextView.text = @"分享快乐，留住感动";
    }else if (self.editTextView.text.length > 200) {
        [self showAlertViewWithMessage:@"字数超过上限，请精简之后发送"];
        self.editTextView.userInteractionEnabled = NO;
    }else{
        self.editTextView.userInteractionEnabled = YES;
    }
    
    
}


#pragma mark--创建collectionView
- (void)createCollectionView{

    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake(self.imgCollectionView.width / 3 - 9, self.imgCollectionView.width / 3 - 9);
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.sectionInset = UIEdgeInsetsMake(6, 6, 6, 6);
    self.imgCollectionView.collectionViewLayout = flowLayout;
    
}
#pragma mark--添加右上角按钮--
- (void)setRightBarButtonItem{

    UIButton *publishBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    publishBtn.frame = CGRectMake(0, 0, 20, 20);
    [publishBtn setImage:[UIImage imageNamed:@"发布"] forState:(UIControlStateNormal)];
    [publishBtn setImage:[UIImage imageNamed:@"发布-1"] forState:(UIControlStateHighlighted)];
    [publishBtn addTarget:self action:@selector(publishAction) forControlEvents:(UIControlEventTouchUpInside)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:publishBtn];
    
}
#pragma mark--发表趣事--
- (void)publishAction{
    
    // 显示菊花
    [SVProgressHUD showWithMaskType:(SVProgressHUDMaskTypeClear)];
    
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    
    appDelegate.window.userInteractionEnabled = NO;
    
    
    // 获取当前系统时间
    NSString* date;
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"YYYY-MM-dd hh:mm:ss"];
    date = [formatter stringFromDate:[NSDate date]];
    
    // 生成趣事对象
    YFunnyModel *funny = [YFunnyModel new];
    funny.publishName = [AVUser currentUser].username;
    funny.publishContent = self.editTextView.text;
    funny.publishTime = date;
    
    
    AVObject *funnyObject = [[AVObject alloc] initWithClassName:@"funnyObject"];
    [funnyObject setObject:funny.publishName forKey:@"publishName"];
    [funnyObject setObject:funny.publishContent forKey:@"publishContent"];
    [funnyObject setObject:funny.publishTime forKey:@"publishTime"];
    
    if (self.photoArray.count > 0) {
        for (int i = 0; i < self.photoArray.count; i++) {
            NSData *data = UIImageJPEGRepresentation(self.photoArray[i], 1.0);
            AVFile *file = [AVFile fileWithName:@"img.png" data:data];
            [file saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                NSLog(@"%@",file.url);//返回一个唯一的 Url 地址
                [funnyObject setObject:file.url forKey:[NSString stringWithFormat:@"image%d",i]];
                
                if (i == self.photoArray.count - 1) {
                    [self saveObjectWithObject:funnyObject];
                }
            }];
        }
    }else{
        [self saveObjectWithObject:funnyObject];
    }
}

// 保存AVObject
- (void)saveObjectWithObject:(AVObject *)object{

    [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // 隐藏菊花
            [SVProgressHUD dismiss];
            
            AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
            appDelegate.window.userInteractionEnabled = YES;
            if (succeeded) {
                
                [self showAlertViewWithMessage:@"发布趣事成功"];
                self.editTextView.text = @"分享快乐，留住感动";
                [self.photoArray removeAllObjects];
                [self.imgCollectionView reloadData];
            }else{
                [self showAlertViewWithMessage:@"发布趣事失败，请稍后再发"];
                NSLog(@"%ld",error.code);
            }
        });
    }];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark--UICollectionViewDataSource--
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{

    return 1;
    
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    if (self.photoArray.count < 9) {
        return self.photoArray.count + 1;
    }else{
        return 9;
    }
    
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.photoArray.count < 9) {
        if (indexPath.item < self.photoArray.count) {
            YImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:imageCellId forIndexPath:indexPath];
            cell.imgView.image = self.photoArray[indexPath.item];
            return cell;
        }else{
            YImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:imageCellId forIndexPath:indexPath];
            cell.imgView.image = [UIImage imageNamed:@"添加图片"];
            return cell;
        }
        
    }else{
        YImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:imageCellId forIndexPath:indexPath];
        cell.imgView.image = self.photoArray[indexPath.item];
        return cell;
    }
    
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake(self.imgCollectionView.width / 3 - 9, self.imgCollectionView.width / 3 - 9);
    
}
#pragma mark--UICollectionViewDelegate--
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"选择照片" message:nil preferredStyle:(UIAlertControllerStyleActionSheet)];
    UIAlertAction *photoAlert = [UIAlertAction actionWithTitle:@"相册" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        
        self.photoArray = [NSMutableArray array];
        ZZPhotoController *photoController = [[ZZPhotoController alloc]init];
        
        // 最多选择的照片
        photoController.selectPhotoOfMax = 9;
        
        [photoController showIn:self result:^(id responseObject){
            
            NSArray *array = (NSArray *)responseObject;
            NSLog(@"%@",responseObject);
            
            [self.photoArray addObjectsFromArray:array];
            
            [self.imgCollectionView reloadData];
            
        }];
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:nil];
    [alert addAction:cancelAction];
    
    [alert addAction:photoAlert];
    [self presentViewController:alert animated:YES completion:nil];
    
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
