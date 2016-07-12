//
//  NetWorkRequestManager.m
//  DouBanProject
//
//  Created by lanou3g on 16/5/9.
//  Copyright © 2016年 春晓. All rights reserved.
//

#import "NetWorkRequestManager.h"



@implementation NetWorkRequestManager




/**
 *  网络请求
 *
 *  @param type           请求方式
 *  @param urlString      URL
 *  @param param          请求参数
 *  @param successedBlock 请求成功之后执行的Block
 *  @param failedBlock    请求失败之后执行的Block
 */
+ (void)requestType:(requestType)type UrlString:(NSString *)urlString param:(NSDictionary *)param Successed:(successedBlock)successedBlock Failed:(failedBlock)failedBlock{

    switch (type) {
        case GET:
        {
            NetWorkRequestManager *manager = [NetWorkRequestManager sharedNetWorkRequestManager];
            [manager getWithUrlString:urlString param:param seccessed:successedBlock failed:failedBlock];
        }
            break;
        case POST:
            
            break;
        case DELETE:
            
            break;
        case PUT:
            
            break;
            
        default:
            break;
    }
    
}

singleton_implementaton(NetWorkRequestManager);

// GET请求
- (void)getWithUrlString:(NSString *)urlString param:(NSDictionary *)dic seccessed:(successedBlock)success failed:(failedBlock)fail {

    // 使用NSURLSession
    // 1.获得session对象
    NSURLSession *session = [NSURLSession sharedSession];
    // 2.拼接字符串
    NSMutableString *urlStr = [NSMutableString stringWithString:urlString];
    if (dic) {// dic不是空的，那么就要拼接问号和请求参数（请求参数就是URL问号后面的字符串）
        
        // 拼接问号
        [urlStr appendString:@"?"];
        
        // 枚举器，枚举dic中的key和value
        [dic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            [urlStr appendString:[NSString stringWithFormat:@"%@=%@&",key,obj]];
        }];
        // 取字符串，从0到urlStr.length - 2
        [urlStr substringFromIndex:urlStr.length - 2];
    }else{// dict是空的，那么urlString就是带请求参数的（请求参数就是URL问号后面的字符串）
    }
    
    // 3.转码 可变字符串变成不可变字符串
    NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:urlStr];
    NSString *url = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:set];
    
    // 设置request
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    // 设置请求方式
    request.HTTPMethod = @"GET";
    // 连接并发送请求
    NSURLSessionDataTask *dataTask= [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (data && !error) {
            success(data);
        }else{
            if (!data) {
                NSLog(@"请求数据为空");
            }
            if (error) {
                fail(error);
            }
            
        }
        
    }];
    [dataTask resume];
}




@end
