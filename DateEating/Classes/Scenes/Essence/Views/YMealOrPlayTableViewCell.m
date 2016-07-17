//
//  YMealTableViewCell.m
//  DateEating
//
//  Created by lanou3g on 16/7/12.
//  Copyright © 2016年 user. All rights reserved.
//

#import "YMealOrPlayTableViewCell.h"

@implementation YMealOrPlayTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
    self.categoryIconImageView.layer.masksToBounds = YES;
    self.categoryIconImageView.layer.cornerRadius = 5;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)setMeal:(YMealModel *)meal{

    _meal = meal;
    NSLog(@"图片的url = %@",_meal.picUrl);
    [self.backImageView setImageWithURL:[NSURL URLWithString:meal.picUrl]];
    self.titleLabel.text = _meal.title;
    self.addressOrDurationLabel.text = _meal.address;
    self.priceStrLabel.text = _meal.priceStr;
    
}

- (void)setPlay:(YPlayModel *)play{

    _play = play;
    NSLog(@"图片的url = %@",_meal.picUrl);
    [self.backImageView setImageWithURL:[NSURL URLWithString:_play.picUrl]];
    self.titleLabel.text = _play.title;
    self.addressOrDurationLabel.text = _play.duration;
    self.priceStrLabel.text = _play.neededCredits;
    [self.categoryIconImageView setImageWithURL:[NSURL URLWithString:_play.categoryIconUrl]];
}



@end
