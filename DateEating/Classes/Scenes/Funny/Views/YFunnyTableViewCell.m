//
//  YFunnyTableViewCell.m
//  DateEating
//
//  Created by lanou3g on 16/7/18.
//  Copyright © 2016年 user. All rights reserved.
//

#import "YFunnyTableViewCell.h"
#import "YFunnyModel.h"

#define kContentLabelWith 386

@interface YFunnyTableViewCell ()<SDCycleScrollViewDelegate, UIScrollViewDelegate>


@end

@implementation YFunnyTableViewCell
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (NSMutableArray *)mArr{

    if (!_mArr) {
        _mArr = [NSMutableArray array];
    }
    return _mArr;
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
    
    if (funny.imgArr.count == 1) {
        self.imgView.hidden = NO;
        self.scrollView.hidden = NO;
        [self.imgView sd_setImageWithURL:funny.imgArr[0]];
    }else {
        self.scrollView.hidden = NO;
        self.imgView.hidden = YES;
            
        // 用网络图片实现
        NSArray *imageURLString = funny.imgArr; // 解析数据时得到的轮播图数组
        
        // 创建代标题的轮播图
        _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:self.scrollView.frame imageURLStringsGroup:nil];
        
        // 设置代理
        _cycleScrollView.delegate = self;
        // 设置小圆点的位置
        _cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
        // 设置小圆点动画效果
        _cycleScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleClassic;
        // 小圆点颜色
        _cycleScrollView.pageDotColor = [UIColor whiteColor];
        _cycleScrollView.currentPageDotColor = [UIColor greenColor];
        // 把图片数组赋值给每个图片
        _cycleScrollView.imageURLStringsGroup = imageURLString;
        
        // 几秒钟换图片
        _cycleScrollView.autoScrollTimeInterval = 3;
        
        [self.scrollView addSubview:_cycleScrollView];
    }
    
}


// 计算有图片cell整体的高度
+ (CGFloat)cellHeight:(YFunnyModel *)funny{
    
    // cell固定部分的高度（呆滞实际开发当中不要自适应，有固定高度的控件和间隙所共同战友的高度总和）
    CGFloat staticHeight = 292;
    
    // cell 不固定部分的高度（需要自适应，因内容er变换的空间高度）
    CGFloat dynamicHeight = [self textHeightFromModel:funny];
    
    // cell的高度等于固定值 + 变化部分
    return staticHeight + dynamicHeight;
    
}


// 计算文本高度
+ (CGFloat)textHeightFromModel:(YFunnyModel *)funny{
    
    CGRect rect = [funny.publishContent boundingRectWithSize:CGSizeMake(kContentLabelWith, 500) options:(NSStringDrawingUsesLineFragmentOrigin) attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.0]} context:nil];
    
    return rect.size.height;
    
}




@end
