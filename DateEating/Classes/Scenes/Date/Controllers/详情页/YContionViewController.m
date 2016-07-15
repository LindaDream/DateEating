//
//  YContionViewController.m
//  DateEating
//
//  Created by lanou3g on 16/7/13.
//  Copyright © 2016年 user. All rights reserved.
//

#import "YContionViewController.h"

@interface YContionViewController ()
@property (strong, nonatomic) NSDictionary *dic;

@end

@implementation YContionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    for (NSString *string in self.listArray) {
        [self addAction:[UIAlertAction actionWithTitle:string style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSInteger index = [self.listArray indexOfObject:action.title];
            self.choiceBlock(action.title,index);
            [self dismissViewControllerAnimated:YES completion:nil];
        }]];
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
