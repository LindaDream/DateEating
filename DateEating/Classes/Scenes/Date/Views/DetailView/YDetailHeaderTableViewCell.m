//
//  YDetailHeaderTableViewCell.m
//  DateEating
//
//  Created by lanou3g on 16/7/13.
//  Copyright © 2016年 user. All rights reserved.
//

#import "YDetailHeaderTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

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

#pragma mark -- 重写model的set方法赋值 --
- (void)setModel:(YDateContentModel *)model {
    if (_model != model) {
        _model = nil;
        _model = model;
        if (model.user.nick == [AVUser currentUser].username) {
            _eventDateTime.text = model.dateTime;
            if (model.fee == 0) {
                _feeDesc.text = @"我请客";
            }else {
                _feeDesc.text = @"AA";
            }
            _userImage.image = model.img;
        } else {
            NSDateFormatter *formatter =[[NSDateFormatter alloc]init];
            NSDate *date = [NSDate dateWithTimeIntervalSince1970:model.eventDateTime/1000];
            [formatter setDateFormat:@"YYYY-MM-dd HH:mm"];
            NSString *dateString = [formatter stringFromDate:date];
            _eventDateTime.text = [NSString stringWithFormat:@"%@",dateString];
            [_userImage sd_setImageWithURL:[NSURL URLWithString:model.user.userImageUrl] placeholderImage:[UIImage imageNamed:@"DefaultAvatar"]];
            _feeDesc.text = model.feeType.desc;
        }
        
        _eventName.text = model.eventName;
        _eventLocation.text = model.eventLocation;
        _distance.text = @"100km";
        _eventDescription.text = model.eventDescription;
        _nick.text = model.user.nick;
        _constellation.text = model.user.constellation;
        _age.text = [NSString stringWithFormat:@"%ld",model.user.age];
        _showCount.text = [NSString stringWithFormat:@"%ld",model.showCount];
        _candidateCount.text = [NSString stringWithFormat:@"%ld",model.candidateCount];
        _commentCount.text = [NSString stringWithFormat:@"%ld",model.commentCount];
        _credit.text = [NSString stringWithFormat:@"%ld",model.credit];
        
        [_userImage sd_setImageWithURL:[NSURL URLWithString:model.user.userImageUrl] placeholderImage:[UIImage imageNamed:@"DefaultAvatar"]];
        [_userImage addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)]];
        
    }
}

#pragma mark -- 按钮事件 --
// 点击图片
- (void)tapAction:(UITapGestureRecognizer *)tap {
    if (_delegate && [_delegate respondsToSelector:@selector(userImageDidTap:)]) {
        [_delegate userImageDidTap:self.model.userId];
    }
}

// 聊天按钮
- (IBAction)chatBtnAction:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(chatBtnDidClicked:)]) {
        [_delegate chatBtnDidClicked:self];
    }
}

// 餐厅详情
- (IBAction)acterDetailBtn:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(restaurantBtnDidClicked:)]) {
        [_delegate restaurantBtnDidClicked:self];
    }
}

// 举报按钮
- (IBAction)reportBtn:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(reportBtnDidClicked:)]) {
        [_delegate reportBtnDidClicked:self];
    }
}

#pragma mark -- 求cell的高度 --
+ (CGFloat)getHeightForCellWithActivity:(YDateContentModel *)activity {
    CGSize size = CGSizeMake([UIScreen mainScreen].bounds.size.width -155, 100000);
    NSDictionary *nameDic = @{NSFontAttributeName:[UIFont systemFontOfSize:16.0f]};
    
    // 计算eventName的文本高度
    CGRect nameLabel = [activity.eventName boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading|NSStringDrawingUsesDeviceMetrics|NSStringDrawingTruncatesLastVisibleLine attributes:nameDic context:nil];
    
    // 计算eventDescription的文本高度
    CGSize size2 = CGSizeMake([UIScreen mainScreen].bounds.size.width -36, 100000);
    NSDictionary *descDic = @{NSFontAttributeName:[UIFont systemFontOfSize:12.0f]};
    CGRect descLabel = [activity.eventName boundingRectWithSize:size2 options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading|NSStringDrawingUsesDeviceMetrics|NSStringDrawingTruncatesLastVisibleLine attributes:descDic context:nil];
    
    return 285 + nameLabel.size.height + descLabel.size.height;
}

@end
