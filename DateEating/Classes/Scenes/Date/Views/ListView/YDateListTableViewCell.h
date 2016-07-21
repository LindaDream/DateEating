//
//  YDateListTableViewCell.h
//  DateEating
//
//  Created by lanou3g on 16/7/12.
//  Copyright © 2016年 user. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YDateContentModel.h"

#define YDateListTableViewCell_Identify @"YDateListTableViewCell_Identify"

@protocol YDateListTableViewCellDelegate <NSObject>

- (void)clickedUserImage:(NSInteger)userId;

@end

@interface YDateListTableViewCell : UITableViewCell

@property (assign, nonatomic) id<YDateListTableViewCellDelegate>delegate;
@property (weak, nonatomic) IBOutlet UILabel *cellIndex;

@property (strong,nonatomic) YDateContentModel *model;

@end
