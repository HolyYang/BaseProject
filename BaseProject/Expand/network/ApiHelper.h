//
//  ApiHelper.h
//  BaseProject
//
//  Created by YangY on 2016/12/30.
//  Copyright © 2016年 羊羊. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
typedef void(^RequestCallBack)(NSURLSessionDataTask *operation,id requestObj,NSError *error);

typedef void(^ProgressCallBack)(NSProgress *progress);

typedef void(^FinishCallBack)(NSString *str);

@interface ApiHelper : NSObject

+ (instancetype)shareInstance;

- (void)requestPostWithApi:(NSString *)api andParams:(NSDictionary *)dic andCallback:(RequestCallBack)callback;

- (void)requestGetWithApi:(NSString *)api andParams:(NSDictionary *)dic andCallback:(RequestCallBack)callback;
//上传图片
- (void)requestPostWithApi:(NSString *)api andParams:(NSDictionary *)dic andImage:(UIImage *)image andCallback:(RequestCallBack)callback;

- (void)downloadWithUrl:(NSString *)urlstr andProgress:(ProgressCallBack)progress andFinish:(FinishCallBack)finish;

- (void)AFNetworkStatus;
@end
