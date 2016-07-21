//
//  YContent.m
//  DateEating
//
//  Created by lanou3g on 16/7/21.
//  Copyright © 2016年 user. All rights reserved.
//

#import "YContent.h"

@implementation YContent


- (void)setValue:(id)value forUndefinedKey:(NSString *)key{

    
    
}



+ (void)parsesContentWithOwnerId:(NSString *)ownerId SuccessRequest:(successRequest)success failurRequest:(failureRequest)failure{
    
    NSMutableArray *mArr = [NSMutableArray array];
    [AVQuery doCloudQueryInBackgroundWithCQL:[NSString stringWithFormat:@"select * from ContentObject where ownerId = '%@'",ownerId] callback:^(AVCloudQueryResult *result, NSError *error) {
        if (result != nil) {
            for (AVObject *obj in result.results) {
                
                NSDictionary *dic = [obj dictionaryForObject];
                YContent *content = [YContent new];
                [content setValuesForKeysWithDictionary:dic];
                
                [mArr addObject:content];
                
            }
            success(mArr);
        }else if(error != nil){
            
            failure(error);
            
        }else{
            
            NSLog(@"没有数据");
            
        }
    }];
    
}


+ (void)getContentAvatarWithUserName:(NSString *)userName SuccessRequest:(successRequest)success failurRequest:(failureRequest)failure{
    
    AVQuery *query = [AVQuery queryWithClassName:@"_User"];
    [query whereKey:@"username" equalTo:userName];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        NSArray<AVObject *> *priorityEqualsZeroTodos = objects;// 符合 priority = 0 的 Todo 数组
        
        if (error != nil) {
            NSLog(@"%ld",error.code);
        }else{
            AVObject *user = priorityEqualsZeroTodos[0];
            NSLog(@"%@",user);
            AVFile *file = [user objectForKey:@"avatar"];
            NSLog(@"%@",file.url);
            success(file.url);
        }
        
    }];
    
    
    
    
    
//    [AVQuery doCloudQueryInBackgroundWithCQL:[NSString stringWithFormat:@"select * from _User where username='%@'",userName] callback:^(AVCloudQueryResult *result, NSError *error) {
//        NSLog(@"result = %@",result.results);
//        if (result.results != nil) {
//            
//            AVUser *user = result.results.firstObject;
//            AVFile *file = [user objectForKey:@"avatar"];
//            [file getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
//                UIImage *img = [UIImage imageWithData:data];
//                NSLog(@"%@",img);
//                success(img);
//            }];
//            
//        }else if(error != nil){
//            NSLog(@"%ld",error.code);
//            failure(error);
//            
//        }else{
//            
//            NSLog(@"没有数据");
//            
//        }
//    }];
    
}



@end
