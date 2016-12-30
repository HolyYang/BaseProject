//
//  ApiHelper.m
//  BaseProject
//
//  Created by YangY on 2016/12/30.
//  Copyright © 2016年 羊羊. All rights reserved.
//

#import "ApiHelper.h"
@interface ApiHelper()

@property (strong, nonatomic) AFHTTPSessionManager *manager;
@property(nonatomic,strong)NSMutableDictionary * currentDic;//公共参数
@end
@implementation ApiHelper
+ (instancetype)shareInstance
{
    static ApiHelper *helper = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        helper = [[ApiHelper alloc] init];
    });
    
    return helper;
}

-(NSMutableDictionary *)currentDic
{
    if (!_currentDic) {
        
        _currentDic = [[NSMutableDictionary alloc] init];
    }
    return _currentDic;
}


- (AFHTTPSessionManager *)manager
{
    if (!_manager) {
        _manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:@""]];
        //设置超时时间
        _manager.requestSerializer.timeoutInterval = 60;
        
        // 声明上传的是json格式的参数，需要你和后台约定好，不然会出现后台无法获取到你上传的参数问题
        _manager.requestSerializer = [AFHTTPRequestSerializer serializer]; // 上传普通格式
        //    _manager.requestSerializer = [AFJSONRequestSerializer serializer]; // 上传JSON格式
        
        // 声明获取到的数据格式
        _manager.responseSerializer = [AFHTTPResponseSerializer serializer]; // AFN不会解析,数据是data，需要自己解析
//            _manager.responseSerializer = [AFJSONResponseSerializer serializer]; // AFN会JSON解析返回的数据
    }
    return _manager;
}


- (void)requestPostWithApi:(NSString *)api andParams:(NSDictionary *)dic andCallback:(RequestCallBack)callback
{
    [self.currentDic addEntriesFromDictionary:dic];
    
    [self.manager POST:api parameters:_currentDic progress:^(NSProgress * _Nonnull downloadProgress) {
        // 这里可以获取到目前数据请求的进度
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        // 请求成功
        if(responseObject){
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            
            NSLog(@"----------------------\n\n接口Api == %@\nURL == %@\n参数 == %@\n请求结果 == %@\n",api,task.response.URL, dic, dict);
            if (callback) {
                callback(task,dict,nil);
            }
        } else {
            NSLog(@"没有数据");
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        // 请求失败
        callback(task,nil,error);
        NSLog(@"请求失败----%@",error);
    }];
}

- (void)requestGetWithApi:(NSString *)api andParams:(NSDictionary *)dic andCallback:(RequestCallBack)callback
{
    [self.currentDic addEntriesFromDictionary:dic];

    [self.manager GET:api parameters:_currentDic progress:^(NSProgress * _Nonnull downloadProgress) {
        // 这里可以获取到目前数据请求的进度
        NSLog(@"%.2f",downloadProgress.fractionCompleted);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        // 请求成功
        if(responseObject){
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"----------------------\n\n接口Api == %@\nURL == %@\n参数 == %@\n请求结果 == %@\n",api,task.response.URL, dic, dict);
            if (callback) {
                callback(task,dict,nil);
            }
            NSURLCache *sharedCache = [[NSURLCache alloc] initWithMemoryCapacity:2 * 1024 * 1024
                                                                    diskCapacity:100 * 1024 * 1024
                                                                        diskPath:nil];
            [NSURLCache setSharedURLCache:sharedCache];
        } else {
            NSLog(@"没有数据");
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        // 请求失败
        callback(task,nil,error);
        NSLog(@"请求失败----%@",error);
    }];
}

- (void)requestPostWithApi:(NSString *)api andParams:(NSDictionary *)dic andImage:(UIImage *)image andCallback:(RequestCallBack)callback
{
    [self.currentDic addEntriesFromDictionary:dic];
    
    NSData *data = UIImageJPEGRepresentation(image, 0.5);
    
    [self.manager POST:api parameters:_currentDic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:data name:@"avatar" fileName:@"avatar.jpeg" mimeType:@"image/jpeg"];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if(responseObject){
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            
            NSLog(@"----------------------\n\n接口Api == %@\nURL == %@\n参数 == %@\n请求结果 == %@\n",api,task.response.URL, dic, dict);
            if (callback) {
                callback(task,dict,nil);
            }
        } else {
            NSLog(@"没有数据");
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败----%@",error);
    }];
}

- (void)downloadWithUrl:(NSString *)urlstr andProgress:(ProgressCallBack)progress andFinish:(FinishCallBack)finish{
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *urlSessionManager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURL *url = [NSURL URLWithString:urlstr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    NSURLSessionDownloadTask *task = [urlSessionManager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        NSLog(@"%.2f",downloadProgress.fractionCompleted);
        if (progress) {
            progress(downloadProgress);
        }
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        NSLog(@"下载完成");
        NSString *cacheDir = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
        NSString *path = [cacheDir stringByAppendingPathComponent:response.suggestedFilename];
        NSURL *fileURL = [NSURL fileURLWithPath:path];
        if (finish) {
            finish([NSString stringWithFormat:@"下载完成--fileurl=%@",fileURL]);
        }
        return fileURL;
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        NSLog(@"%@ %@", filePath, error);
    }];
    [task resume];
}
- (void)AFNetworkStatus{
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        //这里是监测到网络改变的block  可以写成switch方便
        //在里面可以随便写事件
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                NSLog(@"未知网络状态");
                break;
            case AFNetworkReachabilityStatusNotReachable:
                NSLog(@"无网络");
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                NSLog(@"2G/3G/4G");
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                NSLog(@"WiFi网络");
                break;
            default:
                break;
        }
        
    }] ;
}
@end
