//
//  YFunnyNoImgTableViewCell.m
//  DateEating
//
//  Created by lanou3g on 16/7/21.
//  Copyright © 2016年 user. All rights reserved.
//

#import "YFunnyNoImgTableViewCell.h"
#import "YFunnyModel.h"

#define kContentLabelWith 386
@implementation YFunnyNoImgTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)setFunny:(YFunnyModel *)funny{
    
    _funny = funny;
    self.userName.text = funny.publishName;
    [self.userName sizeToFit];
    self.contentLabel.text = funny.publishContent;
    // self.contentLabel自适应
    CGRect frame = self.contentLabel.frame;
    CGFloat h = [[self class] textHeightFromModel:funny];
    frame.size.height = h;
    self.contentLabel.frame = frame;
    
    self.publishTimeLabel.text = funny.publishTime;
    
}

// 计算文本高度
+ (CGFloat)textHeightFromModel:(YFunnyModel *)funny{
    
    CGRect rect = [funny.publishContent boundingRectWithSize:CGSizeMake(kContentLabelWith, 30) options:(NSStringDrawingUsesLineFragmentOrigin) attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.0]} context:nil];
    NSLog(@"rect.size.height = %lf",rect.size.height);
    return rect.size.height;
    
}

// 计算无图片cell整体的高度
+ (CGFloat)cellHeight:(YFunnyModel *)funny{
    
    // cell固定部分的高度（呆滞实际开发当中不要自适应，有固定高度的控件和间隙所共同战友的高度总和）
    CGFloat staticHeight = 210;
    
    // cell 不固定部分的高度（需要自适应，因内容er变换的空间高度）
    CGFloat dynamicHeight = [self textHeightFromModel:funny];
    
    // cell的高度等于固定值 + 变化部分
    return staticHeight + dynamicHeight;
    
}


@end
