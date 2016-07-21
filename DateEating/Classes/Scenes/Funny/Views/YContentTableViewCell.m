//
//  YContentTableViewCell.m
//  DateEating
//
//  Created by lanou3g on 16/7/21.
//  Copyright © 2016年 user. All rights reserved.
//

#import "YContentTableViewCell.h"

#define kContentLabelWith kWidth - 32

@implementation YContentTableViewCell

- (void)awakeFromNib {
    
}

- (void)setContent:(YContent *)content{

    _content = content;
    self.fromToLabel.text = [NSString stringWithFormat:@"FROM:%@",content.fromName];
    self.contentLabel.text = content.contents;
    [YContent getContentAvatarWithUserName:content.fromName SuccessRequest:^(id dict) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.contentAvatarImageView sd_setImageWithURL:[NSURL URLWithString:dict]];
        });
    } failurRequest:^(NSError *error) {
        NSLog(@"%ld",error.code);
    }];
    [self.fromToLabel sizeToFit];
    
    CGRect frame = self.contentLabel.frame;
    frame.size.height = [[self class] textHeightFromModel:content];
    self.contentLabel.frame = frame;
    
}


// 计算有图片cell整体的高度
+ (CGFloat)cellHeight:(YContent *)content{
    
    // cell固定部分的高度（呆滞实际开发当中不要自适应，有固定高度的控件和间隙所共同战友的高度总和）
    CGFloat staticHeight = 56;
    
    // cell 不固定部分的高度（需要自适应，因内容er变换的空间高度）
    CGFloat dynamicHeight = [self textHeightFromModel:content];
    
    // cell的高度等于固定值 + 变化部分
    return staticHeight + dynamicHeight;
    
}


// 计算文本高度
+ (CGFloat)textHeightFromModel:(YContent *)content{
    
    CGRect rect = [content.contents boundingRectWithSize:CGSizeMake(kContentLabelWith, 30) options:(NSStringDrawingUsesLineFragmentOrigin) attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.0]} context:nil];
    
    return rect.size.height;
    
}





- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
