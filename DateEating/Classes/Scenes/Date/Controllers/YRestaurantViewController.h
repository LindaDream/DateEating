//
//  YRestaurantViewController.h
//  DateEating
//
//  Created by user on 16/7/15.
//  Copyright © 2016年 user. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^passAddress)(NSString *addressStr);

@interface YRestaurantViewController : UITableViewController
@property(copy,nonatomic)passAddress passValueBlock;
@end
