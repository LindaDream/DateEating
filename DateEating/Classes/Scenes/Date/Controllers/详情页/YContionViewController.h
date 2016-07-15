//
//  YContionViewController.h
//  DateEating
//
//  Created by lanou3g on 16/7/13.
//  Copyright © 2016年 user. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^ChoiceBlock)(NSString *,NSInteger);
@interface YContionViewController : UIAlertController

@property (copy, nonatomic) ChoiceBlock choiceBlock;
@property (strong, nonatomic) NSArray *listArray;

@end
