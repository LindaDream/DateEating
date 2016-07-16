//
//  YChatTableViewCell.m
//  DateEating
//
//  Created by lanou3g on 16/7/13.
//  Copyright © 2016年 user. All rights reserved.
//

#import "YChatTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

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

#pragma mark -- 重写model的set方法 --
- (void)setModel:(YChatMessageModel *)model {
    if (_model != model) {
        _model = nil;
        _model = model;
        
        _nick.text = model.user.nick;
        _time.text = model.time;
        if (model.replyUser != nil) {
            _message.text = [NSString stringWithFormat:@"回复%@:%@",model.replyUser.nick,model.content];
        } else {
            _message.text = model.content;
        }
        
        [_userImage sd_setImageWithURL:[NSURL URLWithString:model.user.userImageUrl] placeholderImage:[UIImage imageNamed:@"DefaultAvatar"]];
        
    }
}

+ (CGFloat)getHeightForCellWithActivity:(YChatMessageModel *)activity {
    CGSize size = CGSizeMake([UIScreen mainScreen].bounds.size.width -90, 100000);
    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:15.0f]};

    // 计算locationLabel的文本高度
    CGRect titleLabel = [activity.content boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading|NSStringDrawingUsesDeviceMetrics|NSStringDrawingTruncatesLastVisibleLine attributes:dic context:nil];

    return 60 + titleLabel.size.height;
}

@end
