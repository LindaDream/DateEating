//
//  NetWorkRequestManager.h
//  DouBanProject
//
//  Created by lanou3g on 16/5/9.
//  Copyright © 2016年 春晓. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Singleton.h"

typedef NS_ENUM(NSInteger,requestType) {
    //GET 1<<2, //这种意思是二进制1左移2位，001变成100，这样做的好处是可以使两个值同时存在并同时使用
    GET,
    POST,
    DELETE,
    PUT
};

typedef void(^successedBlock)(id Data);// 请求正确时候返回data
typedef void(^failedBlock)(NSError * error);// 请求失败时候返回错误信息

@interface NetWorkRequestManager : NSObject

/**
 *  网络请求
 *
 *  @param type           请求方式
 *  @param urlString      URL
 *  @param param          请求参数
 *  @param successedBlock 请求成功之后执行的Block
 *  @param failedBlock    请求失败之后执行的Block
 */
+ (void)requestType:(requestType)type UrlString:(NSString *)urlString param:(NSDictionary *)param Successed:(successedBlock)successedBlock Failed:(failedBlock)failedBlock;


singleton_interface(NetWorkRequestManager);



@end
