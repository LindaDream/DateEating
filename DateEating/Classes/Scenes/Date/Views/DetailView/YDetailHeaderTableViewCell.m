//
//  YDetailHeaderTableViewCell.m
//  DateEating
//
//  Created by lanou3g on 16/7/13.
//  Copyright © 2016年 user. All rights reserved.
//

#import "YDetailHeaderTableViewCell.h"

@interface YDetailHeaderTableViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *userImage;
@property (weak, nonatomic) IBOutlet UILabel *eventName;
@property (weak, nonatomic) IBOutlet UILabel *eventLocation;
@property (weak, nonatomic) IBOutlet UILabel *distance;
@property (weak, nonatomic) IBOutlet UILabel *eventDateTime;
@property (weak, nonatomic) IBOutlet UILabel *feeDesc;
@property (weak, nonatomic) IBOutlet UILabel *eventDescription;
@property (weak, nonatomic) IBOutlet UILabel *nick;
@property (weak, nonatomic) IBOutlet UILabel *constellation;
@property (weak, nonatomic) IBOutlet UILabel *age;
@property (weak, nonatomic) IBOutlet UILabel *showCount;
@property (weak, nonatomic) IBOutlet UILabel *candidateCount;
@property (weak, nonatomic) IBOutlet UILabel *commentCount;
@property (weak, nonatomic) IBOutlet UILabel *credit;

@property (weak, nonatomic) IBOutlet UILabel *eventNumberDesc;


@end

@implementation YDetailHeaderTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark -- 求cell的高度 --
//+ (CGFloat)getHeightForCellWithActivity:(TheaterModel *)activity {
//    CGSize size = CGSizeMake([UIScreen mainScreen].bounds.size.width -40, 100000);
//    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:14.0f]};
//    
//    // 计算locationLabel的文本高度
//    CGRect titleLabel = [activity.address boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading|NSStringDrawingUsesDeviceMetrics|NSStringDrawingTruncatesLastVisibleLine attributes:dic context:nil];
//    
//    return 40 + 42 + titleLabel.size.height;
//}

@end
