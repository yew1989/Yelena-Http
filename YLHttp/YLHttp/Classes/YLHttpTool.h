//
//  YLHttpTool.h
//  Yelena-Core_Example
//
//  Created by sino on 2019/1/24.
//  Copyright © 2019 LinWei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <YLCore/YLCallBackDefine.h>

@interface YLHttpTool : NSObject

// 设置超时时间
+ (void)setupTimeoutInterval:(CGFloat)timeoutInterval;
// POST请求
+ (void)POST:(NSString *)url
      params:(NSDictionary *)params
     success:(CallBackSucc)success
     failure:(CallBackFail)failure;

// GET请求
+ (void)GET:(NSString *)url
     params:(NSDictionary *)params
    success:(CallBackSucc)success
    failure:(CallBackFail)failure;

// 下载文件
+ (void)downFile:(NSString *)url
        progress:(CallBackProgress)progress
         success:(CallBackURL)success
         failure:(CallBackFail)failure;

// 上传图片
+ (void)uploadPhoto:(NSString*)url
             params:(NSDictionary *)params
              image:(UIImage*)image
                key:(NSString*)key
           progress:(CallBackProgress)progress
            success:(CallBackSucc)success
            failure:(CallBackFail)failure;

// 网络检测
+ (void)starMonitoring:(CallBack)connected
                  lost:(CallBack)lost;

@end
