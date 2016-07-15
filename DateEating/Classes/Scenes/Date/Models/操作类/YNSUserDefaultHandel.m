//
//  YNSUserDefaultHandel.m
//  DateEating
//
//  Created by lanou3g on 16/7/14.
//  Copyright © 2016年 user. All rights reserved.
//

#import "YNSUserDefaultHandel.h"

@implementation YNSUserDefaultHandel

static YNSUserDefaultHandel *handle = nil;
+ (instancetype)sharedYNSUserDefaultHandel {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        handle = [[[self class]alloc]init];
    });
    return handle;
}



#pragma mark -- 保存值 --
- (void)setBasicCheck:(NSInteger)basicCheck {
    [[NSUserDefaults standardUserDefaults]setInteger:basicCheck forKey:@"basicCheck"];
}
- (void)setCity:(NSInteger)city {
    [[NSUserDefaults standardUserDefaults]setInteger:city forKey:@"city"];
}
- (void)setMulti:(NSInteger)multi {
    [[NSUserDefaults standardUserDefaults]setInteger:multi forKey:@"multi"];
}
- (void)setGender:(NSInteger)gender {
    [[NSUserDefaults standardUserDefaults]setInteger:gender forKey:@"gender"];
}
- (void)setTime:(NSInteger)time {
    [[NSUserDefaults standardUserDefaults]setInteger:time forKey:@"time"];
}
- (void)setAge:(NSInteger)age {
    [[NSUserDefaults standardUserDefaults]setInteger:age forKey:@"age"];
}
- (void)setConstellation:(NSInteger)constellation {
    [[NSUserDefaults standardUserDefaults]setInteger:constellation forKey:@"constellation"];
}
- (void)setOccupation:(NSInteger)occupation {
    [[NSUserDefaults standardUserDefaults]setInteger:occupation forKey:@"occupation"];
}

//basicCheck=0&city=010&multi=0&gender=0&time=0&age=0&constellation=0&occupation=0&start=0&size=20&apiVersion=2.9.0
#pragma mark -- 存值 --
- (NSInteger)basicCheck {
    return [[NSUserDefaults standardUserDefaults]integerForKey:@"basicCheck"];
}

- (NSInteger)city {
    return [[NSUserDefaults standardUserDefaults]integerForKey:@"city"];
}
- (NSInteger)multi {
    return [[NSUserDefaults standardUserDefaults]integerForKey:@"multi"];
}
- (NSInteger)gender {
    return [[NSUserDefaults standardUserDefaults]integerForKey:@"gender"];
}
- (NSInteger)time {
    return [[NSUserDefaults standardUserDefaults]integerForKey:@"time"];
}
- (NSInteger)age {
    return [[NSUserDefaults standardUserDefaults]integerForKey:@"age"];
}
- (NSInteger)constellation {
    return [[NSUserDefaults standardUserDefaults]integerForKey:@"constellation"];
}
- (NSInteger)occupation {
    return [[NSUserDefaults standardUserDefaults]integerForKey:@"occupation"];
}

#pragma mark -- 将更改更新到磁盘 --
- (void)synchronize
{
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark -- 重置所选条件 --
- (void)reSetCondition {
    [self setAge:0];
    [self setConstellation:0];
    [self setMulti:0];
    [self setTime:0];
    [self setOccupation:0];
    [self setGender:0];
}

#pragma mark -- 是否有筛选条件 --
- (BOOL)haveSeekCondition {
    NSInteger num = [self age] + [self constellation] + [self multi] + [self time] + [self occupation] + [self gender];
    if (num > 0) {
        return YES;
    }else {
        return NO;
    }
}

@end

