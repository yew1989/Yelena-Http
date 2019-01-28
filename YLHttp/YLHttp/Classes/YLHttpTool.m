//
//  YLHttpTool.m
//  Yelena-Core_Example
//
//  Created by sino on 2019/1/24.
//  Copyright © 2019 LinWei. All rights reserved.
//
#import "YLHttpTool.h"

#import <YLCore/YLMacro.h>
#import <AFNetworking/AFNetworking.h>
#import <YLCore/YLFileTool.h>


@interface YLHttpToolConfig : NSObject

+ (YLHttpToolConfig *)shareInstace;

// 默认超时时间 30s
@property (nonatomic, assign) CGFloat timeoutInterval;

@end

@implementation YLHttpToolConfig

+ (YLHttpToolConfig *)shareInstace {
    static dispatch_once_t once;
    static YLHttpToolConfig *instance;
    dispatch_once(&once, ^{
        instance = [[YLHttpToolConfig alloc] init];
        instance.timeoutInterval = 30.f;
    });
    return instance;
}

@end

@interface YLHTTPManager : AFHTTPSessionManager

@end

@implementation YLHTTPManager

+ (instancetype)manager {
    YLHTTPManager *mgr = [super manager];
    NSMutableSet *newSet = [NSMutableSet set];
    newSet.set = mgr.responseSerializer.acceptableContentTypes;
    [newSet addObject:@"text/html"];
    [newSet addObject:@"text/plain"];
    [newSet addObject:@"application/javascript"];
    mgr.responseSerializer.acceptableContentTypes = newSet;
    return mgr;
}

@end

@implementation YLHttpTool

+(void)setupTimeoutInterval:(CGFloat)timeoutInterval {
    [YLHttpToolConfig shareInstace].timeoutInterval = timeoutInterval;
}

// 超时时间
+(CGFloat)timeoutInterval {
    return [YLHttpToolConfig shareInstace].timeoutInterval;
}


// POST请求
+ (void)POST:(NSString *)url
      params:(NSDictionary *)params
     success:(CallBackSucc)success
     failure:(CallBackFail)failure {
    if (!url)return;
    YLHTTPManager *manager = [YLHTTPManager manager];
    manager.requestSerializer.timeoutInterval = [YLHttpTool timeoutInterval];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager POST:url parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if(success){
            [YLHttpTool success:success json:responseObject];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if(failure){
            [YLHttpTool failure:failure error:error];
        }
    }];
}

// GET请求
+ (void)GET:(NSString *)url
     params:(NSDictionary *)params
    success:(CallBackSucc)success
    failure:(CallBackFail)failure {
    if (!url)return;
    YLHTTPManager *manager = [YLHTTPManager manager];
    manager.requestSerializer.timeoutInterval = [YLHttpTool timeoutInterval];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager GET:url parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if(success){
            [YLHttpTool success:success json:responseObject];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if(failure){
            [YLHttpTool failure:failure error:error];
        }
    }];
}

// 下载文件
+ (void)downFile:(NSString *)url
        progress:(CallBackProgress)progress
         success:(CallBackURL)success
         failure:(CallBackFail)failure {
    
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    if (!request) return;
    YLHTTPManager *manager = [YLHTTPManager manager];
    NSURLSessionDownloadTask *task = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        if (progress){
            GCD_MAIN(^{
                progress(downloadProgress.fractionCompleted);
            });
        }
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        NSString *downloadPath = [[YLFileTool getDocumentPath]
                                 stringByAppendingPathComponent:@"Download"];
        NSString *filePath     = [downloadPath stringByAppendingPathComponent:response.suggestedFilename];
        BOOL isExitDownloadDir = [YLFileTool creatDirectoryWithPath:downloadPath];
        
        // 存在文件就删除
        BOOL isFileExist = [YLFileTool fileIsExistOfPath:filePath];
        if (isFileExist) {
            [YLFileTool removeFileOfPath:filePath];
        }
        
        if (isExitDownloadDir) {
            return [NSURL fileURLWithPath:filePath];
        }
        return [NSURL fileURLWithPath:@""];
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        // 完成
        if (error)[self failure:nil error:error];
        if (success) {
            success(filePath);
        }
    }];
    [task resume];
}

// 上传图片
+ (void)uploadPhoto:(NSString*)url
            params:(NSDictionary *)params
             image:(UIImage*)image
               key:(NSString*)key
          progress:(CallBackProgress)progress
           success:(CallBackSucc)success
           failure:(CallBackFail)failure {
    if (!url)return;
    YLHTTPManager *manager = [YLHTTPManager manager];
    manager.requestSerializer.timeoutInterval = [YLHttpTool timeoutInterval];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];

    [manager POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSString *fileName =[NSString stringWithFormat:@"Photo%@.png",[YLHttpTool rts]];
        NSString *type = @"image/png";
        [formData appendPartWithFileData:[YLHttpTool zipImage:image] name:key fileName:fileName mimeType:type];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        if (progress){
            GCD_MAIN(^{
                progress(uploadProgress.fractionCompleted);
            });
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if(success){
            [YLHttpTool success:success json:responseObject];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if(failure){
            [YLHttpTool failure:failure error:error];
        }
    }];
}

// 网络检测
+ (void)starMonitoring:(CallBack)connected
                  lost:(CallBack)lost {
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    [manager startMonitoring];
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                // ...
                break;
            case AFNetworkReachabilityStatusNotReachable:
                if (lost) {
                    lost();
                }
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                if (connected) {
                    connected();
                }
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                if (connected) {
                    connected();
                }
                break;
            default:
                break;
        }
    }];
}


// 工具
+ (NSDictionary *)deleteNull:(NSDictionary*)dict {
    NSMutableDictionary *mutableDic = [[NSMutableDictionary alloc] init];
    for (NSString *keyStr in dict.allKeys)
        if ([[dict objectForKey:keyStr] isEqual:[NSNull null]]) {
            NSString *key = [keyStr stringByReplacingOccurrencesOfString:@"_" withString:@""];
            [mutableDic setObject:@"" forKey:key];
        } else {
            NSString *key = [keyStr stringByReplacingOccurrencesOfString:@"_" withString:@""];
            [mutableDic setObject:[dict objectForKey:keyStr] forKey:key];
        }
    return (NSDictionary*)mutableDic;
}

+ (void)success:(CallBackSucc)success json:(NSDictionary *)json {
    json = [self deleteNull:json];
    if (success) {
        success(json);
    }
}

+ (void)failure:(CallBackFail)failure error:(NSError *)error {
    NSString *errorMessage = [error localizedDescription];
    DLog(@"网络请求失败 -> 错误原因: %@", errorMessage)
    if (failure)
        failure(error);
}

+(NSData *)zipImage:(UIImage *)myimage {
    NSData *data=UIImageJPEGRepresentation(myimage, 1.0);
    if (data.length>100*1024) {
        if (data.length>2*1024*1024) {//2M以及以上
            data=UIImageJPEGRepresentation(myimage, 0.05);
        }else if (data.length>1024*1024) {//1M-2M
            data=UIImageJPEGRepresentation(myimage, 0.1);
        }else if (data.length>512*1024) {//0.5M-1M
            data=UIImageJPEGRepresentation(myimage, 0.2);
        }else if (data.length>200*1024) {//0.25M-0.5M
            data=UIImageJPEGRepresentation(myimage, 0.4);
        }
    }
    return data;
}

+(NSString*)rts{
    NSDate *date = [NSDate date];
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyyMMdd-HHmmss"];
    format.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT+0800"];
    NSString*chinaString = [format stringFromDate:date];
    NSDateFormatter *chinaFormat = [[NSDateFormatter alloc] init];
    [chinaFormat setDateFormat:@"yyyyMMdd-HHmmss"];
    NSDate *chinaDate = [chinaFormat dateFromString:chinaString];
    NSTimeInterval time = [chinaDate timeIntervalSince1970];
    return [NSString stringWithFormat:@"%d",(int)time];
}
@end
