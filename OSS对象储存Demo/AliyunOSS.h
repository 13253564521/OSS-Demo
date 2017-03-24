//
//  AliyunOSS.h
//  OSS对象储存Demo
//
//  Created by 刘高升 on 17/2/20.
//  Copyright © 2017年 刘高升. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AliyunOSS : NSObject
+ (instancetype)sharedInstance;
//初始化操作
- (void)setupEnvironment;
//异步上传
- (void)uploadObjectAsyncWithImageData:(NSData *)data;
@end
