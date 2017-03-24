//
//  AliyunOSS.m
//  OSS对象储存Demo
//
//  Created by 刘高升 on 17/2/20.
//  Copyright © 2017年 刘高升. All rights reserved.
//

#import "AliyunOSS.h"
#import <AliyunOSSiOS/OSSService.h>
#import <SVProgressHUD.h>
NSString * const AccessKey = @"";
NSString * const SecretKey = @"";
NSString * const endPoint = @"http://oss-cn-shanghai.aliyuncs.com/";

OSSClient * client;
@implementation AliyunOSS
+ (instancetype)sharedInstance {
    static AliyunOSS *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [AliyunOSS new];
    });
    return instance;
}
- (void)setupEnvironment {
    // 打开调试log
    [OSSLog enableLog];
    
    // 初始化sdk
    [self initOSSClient];
}

- (void)initOSSClient {
    
    // 自实现签名，可以用本地签名也可以远程加签
    id<OSSCredentialProvider> credential = [[OSSCustomSignerCredentialProvider alloc] initWithImplementedSigner:^NSString *(NSString *contentToSign, NSError *__autoreleasing *error) {
        NSString *signature = [OSSUtil calBase64Sha1WithData:contentToSign withSecret:SecretKey];
        if (signature != nil) {
            *error = nil;
        } else {
            // construct error object
            *error = [NSError errorWithDomain:NSURLErrorDomain code:OSSClientErrorCodeSignFailed userInfo:nil];
            return nil;
        }
        return [NSString stringWithFormat:@"OSS %@:%@", AccessKey, signature];
    }];
    
    OSSClientConfiguration * conf = [OSSClientConfiguration new];
    conf.maxRetryCount = 2;
    conf.timeoutIntervalForRequest = 30;
    conf.timeoutIntervalForResource = 24 * 60 * 60;
    
    client = [[OSSClient alloc] initWithEndpoint:endPoint credentialProvider:credential clientConfiguration:conf];
}

// 异步上传
- (void)uploadObjectAsyncWithImageData:(NSData *)data {
    OSSPutObjectRequest * put = [OSSPutObjectRequest new];
    
    // required fields
    put.bucketName = @"ecarfinance";
    //文件路径/图片名称
    put.objectKey = [NSString stringWithFormat:@"image/%@.jpg",[self getTimeNow]];;
    put.uploadingData = data;
    // optional fields
    put.uploadProgress = ^(int64_t bytesSent, int64_t totalByteSent, int64_t totalBytesExpectedToSend) {
        NSLog(@"%lld, %lld, %lld", bytesSent, totalByteSent, totalBytesExpectedToSend);

    };
    //选填字段
//    put.contentType = @"";
//    put.contentMd5 = @"";
//    put.contentEncoding = @"";
//    put.contentDisposition = @"";
    
    OSSTask * putTask = [client putObject:put];
    
    [putTask continueWithBlock:^id(OSSTask *task) {
        
        task = [client presignPublicURLWithBucketName:put.bucketName withObjectKey:put.objectKey];
        NSLog(@"objectKey: %@", put.objectKey);
        if (!task.error) {
            NSLog(@"upload object success!");
            [SVProgressHUD showSuccessWithStatus:@"上传成功!"];
        } else {
            NSLog(@"upload object failed, error: %@" , task.error);
        }
        return nil;
    }];
}

/**
 *  返回当前时间
 *
 *  @return <#return value description#>
 */
- (NSString *)getTimeNow
{
    NSString* date;
    NSDateFormatter * formatter = [[NSDateFormatter alloc ] init];
    [formatter setDateFormat:@"YYYYMMddhhmmssSSS"];
    date = [formatter stringFromDate:[NSDate date]];
    //取出个随机数
    int last = arc4random() % 10000;
    NSString *timeNow = [[NSString alloc] initWithFormat:@"%@-%i", date,last];
    return timeNow;
}
@end
