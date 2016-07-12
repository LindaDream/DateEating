//
//  YDateContentModel.m
//  DateEating
//
//  Created by lanou3g on 16/7/12.
//  Copyright © 2016年 user. All rights reserved.
//

#import "YDateContentModel.h"

@implementation YDateContentModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if ([key isEqualToString:@"id"]) {
        [self setValue:value forKey:@"ID"];;
    }
    if ([key isEqualToString:@"caterPlatform"]) {
        _caterPlatform = [NSString stringWithFormat:@"%@",value];
    }
    if ([key isEqualToString:@"user"]){
        [_user setValuesForKeysWithDictionary:value];
    }
    if ([key isEqualToString:@"feeType"]) {
        [_feeType setValuesForKeysWithDictionary:value];
    }
}

@end
