//
//  YChatTableViewCell.m
//  DateEating
//
//  Created by lanou3g on 16/7/13.
//  Copyright © 2016年 user. All rights reserved.
//

#import "YChatTableViewCell.h"

@interface YChatTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *userImage;
@property (weak, nonatomic) IBOutlet UILabel *nick;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *message;


@end

@implementation YChatTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


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
