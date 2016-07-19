//
//  UIViewController+YCategory.m
//  DateEating
//
//  Created by user on 16/7/13.
//  Copyright © 2016年 user. All rights reserved.
//

#import "UIViewController+YCategory.h"
#import "YPublishDateViewController.h"
#import "YPublishPartyViewController.h"
#import "YTabBar.h"
#import "AppDelegate.h"
@implementation UIViewController (YCategory)
-(void)changeToNight{
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    app.window.alpha = 0.6;
}

-(void)changeToDay{
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    app.window.alpha = 1.0;
}

-(void)addDateBtnAndPartyBtn{
    UIButton *dateBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    dateBtn.frame = CGRectMake(207, 696.5, 100, 100);
    [dateBtn setBackgroundImage:[UIImage imageNamed:@"event_single"] forState:(UIControlStateNormal)];
    [dateBtn addTarget:self action:@selector(addDate:) forControlEvents:(UIControlEventTouchUpInside)];
    dateBtn.tag = 101;
    [self.view addSubview:dateBtn];
    
    UIButton *partyBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    partyBtn.frame = CGRectMake(207, 696.5, 100, 100);
    [partyBtn setBackgroundImage:[UIImage imageNamed:@"event_multi"] forState:(UIControlStateNormal)];
    [partyBtn addTarget:self action:@selector(addParty:) forControlEvents:(UIControlEventTouchUpInside)];
    partyBtn.tag = 102;
    [self.view addSubview:partyBtn];
    [UIView animateKeyframesWithDuration:1 delay:0 options:(UIViewKeyframeAnimationOptionCalculationModeLinear) animations:^{
        // 第一帧
        dateBtn.center = CGPointMake(103, 500);
        partyBtn.center = CGPointMake(311, 500);
    } completion:^(BOOL finished) {
        
    }];
}
- (void)addDate:(UIButton *)btn{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"changeIsClickedValue" object:nil userInfo:@{@"isClicked":[NSNumber numberWithBool:1]}];
    YPublishDateViewController *dateVC = [YPublishDateViewController new];
    UIButton *dateBtn = (UIButton *)[self.view viewWithTag:101];
    UIButton *partyBtn = (UIButton *)[self.view viewWithTag:102];
    [dateBtn removeFromSuperview];
    [partyBtn removeFromSuperview];
    UIButton *addBtn = [self.tabBarController.tabBar.subviews objectAtIndex:1];
    [UIView animateWithDuration:0.5 animations:^{
        addBtn.transform = CGAffineTransformRotate(addBtn.transform, -M_PI_4);
        
    }];
    [[self.view subviews] lastObject].userInteractionEnabled = YES;
    [self.tabBarController.tabBar.subviews objectAtIndex:2].userInteractionEnabled = YES;
    [self.tabBarController.tabBar.subviews objectAtIndex:3].userInteractionEnabled = YES;
    [self.tabBarController.tabBar.subviews objectAtIndex:4].userInteractionEnabled = YES;
    [self.tabBarController.tabBar.subviews objectAtIndex:5].userInteractionEnabled = YES;
    [self.navigationController pushViewController:dateVC animated:YES];
}
- (void)addParty:(UIButton *)btn{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"changeIsClickedValue" object:nil userInfo:@{@"isClicked":[NSNumber numberWithBool:1]}];
    YPublishPartyViewController *partyVC = [YPublishPartyViewController new];
    UIButton *dateBtn = (UIButton *)[self.view viewWithTag:101];
    UIButton *partyBtn = (UIButton *)[self.view viewWithTag:102];
    [dateBtn removeFromSuperview];
    [partyBtn removeFromSuperview];
    UIButton *addBtn = [self.tabBarController.tabBar.subviews objectAtIndex:1];
    [UIView animateWithDuration:0.5 animations:^{
        addBtn.transform = CGAffineTransformRotate(addBtn.transform, -M_PI_4);
        
    }];
    [[self.view subviews] lastObject].userInteractionEnabled = YES;
    [self.tabBarController.tabBar.subviews objectAtIndex:2].userInteractionEnabled = YES;
    [self.tabBarController.tabBar.subviews objectAtIndex:3].userInteractionEnabled = YES;
    [self.tabBarController.tabBar.subviews objectAtIndex:4].userInteractionEnabled = YES;
    [self.tabBarController.tabBar.subviews objectAtIndex:5].userInteractionEnabled = YES;
    [self.navigationController pushViewController:partyVC animated:YES];
}
-(void)removeDateBtnAndPartyBtn{
    UIButton *dateBtn = (UIButton *)[self.view viewWithTag:101];
    UIButton *partyBtn = (UIButton *)[self.view viewWithTag:102];
    [dateBtn removeFromSuperview];
    [partyBtn removeFromSuperview];
}
#pragma mark--高度自适应--
-(CGFloat)textHeightForLabel:(UILabel *)label{
    CGRect rect = [label.text boundingRectWithSize:CGSizeMake(label.frame.size.width, 500) options:(NSStringDrawingUsesLineFragmentOrigin) attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.0]} context:nil];
    return rect.size.height;
}
@end
