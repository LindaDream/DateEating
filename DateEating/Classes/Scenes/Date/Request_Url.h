//
//  Request_Url.h
//  DateEating
//
//  Created by lanou3g on 16/7/14.
//  Copyright © 2016年 user. All rights reserved.
//

#ifndef Request_Url_h
#define Request_Url_h

#define array0 @[@"不限",@"18-22",@"13-26",@"27-35",@"35以上"]
#define array1 @[@"不限",@"白羊座",@"金牛座",@"双子座",@"巨蟹座",@"狮子座",@"处女座",@"天秤座",@"天蝎座",@"射手座",@"摩羯座",@"水瓶座",@"双鱼座"]
#define array2 @[@"不限",@"计算机/互联网/通信",@"生产/工艺/制造",@"商业/服务业/个体经营",@"金融/银行/投资/保险",@"文化/广播/传媒",@"娱乐/艺术/表演",@"医护/制药",@"律师/法务",@"教育/培训",@"公务员/事业单位",@"学生"]

#define HotRequest_Url(multi,gender,time,age,constellation,occupation) [NSString stringWithFormat:@"http://api.qingchifan.com/api/event/city.json?access_token=6916a7ab1f71e43ac4eadf40a51b4ab16CBEB96E84AF9926E7406CC46FF121FD&basicCheck=0&city=010&multi=%ld&gender=%ld&time=%ld&age=%ld&constellation=%ld&occupation=%ld&start=0&size=20&apiVersion=2.9.0",multi,gender,time,age,constellation,occupation]
#define NearByRequest_Url(multi,gender,time,age,constellation,occupation) [NSString stringWithFormat:@"http://api.qingchifan.com/api/event/nearby.json?access_token=6916a7ab1f71e43ac4eadf40a51b4ab16CBEB96E84AF9926E7406CC46FF121FD&basicCheck=0&lat=40.030482&lon=116.343562&multi=%ld&gender=%ld&time=%ld&age=%ld&constellation=%ld&occupation=%ld&start=0&size=20&apiVersion=2.9.0",multi,gender,time,age,constellation,occupation]

#endif /* Request_Url_h */
