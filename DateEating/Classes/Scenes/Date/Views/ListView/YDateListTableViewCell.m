//
//  YDateListTableViewCell.m
//  DateEating
//
//  Created by lanou3g on 16/7/12.
//  Copyright © 2016年 user. All rights reserved.
//

#import "YDateListTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface YDateListTableViewCell ()

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

@end

@implementation YDateListTableViewCell

- (void)awakeFromNib {
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(YDateContentModel *)model {
    if (_model != model) {
        _model = nil;
        _model = model;
        
        _eventName.text = model.eventName;
        _eventLocation.text = model.eventLocation;
        _eventDescription.text = model.eventDescription;
        _distance.text = @"100km";
        NSDateFormatter *formatter =[[NSDateFormatter alloc]init];
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:model.eventDateTime/1000];
        [formatter setDateFormat:@"YYYY-MM-dd HH:mm"];
        NSString *dateString = [formatter stringFromDate:date];
        _eventDateTime.text = [NSString stringWithFormat:@"%@",dateString];
        _nick.text = model.user.nick;
        _constellation.text = model.user.constellation;
        _age.text = [NSString stringWithFormat:@"%ld",model.user.age];
        _showCount.text = [NSString stringWithFormat:@"%ld",model.showCount];
        _candidateCount.text = [NSString stringWithFormat:@"%ld",model.candidateCount];
        _commentCount.text = [NSString stringWithFormat:@"%ld",model.commentCount];
        [_userImage sd_setImageWithURL:[NSURL URLWithString:model.user.userImageUrl] placeholderImage:[UIImage imageNamed:@"DefaultAvatar"]];
    }
}

@end
