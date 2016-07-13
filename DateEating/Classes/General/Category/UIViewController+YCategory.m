//
//  UIViewController+YCategory.m
//  DateEating
//
//  Created by user on 16/7/13.
//  Copyright © 2016年 user. All rights reserved.
//

#import "UIViewController+YCategory.h"

@implementation UIViewController (YCategory)
-(void)changeToNight{
    [[self.view subviews] lastObject].backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
}
-(void)changeToDay{
    [[self.view subviews] lastObject].backgroundColor = [UIColor whiteColor];
}
@end
