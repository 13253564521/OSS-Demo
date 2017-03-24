//
//  GSCamera.m
//  OSS对象储存Demo
//
//  Created by 刘高升 on 17/2/21.
//  Copyright © 2017年 刘高升. All rights reserved.
//

#import "GSCamera.h"
@interface GSCamera()<UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@end

@implementation GSCamera
+(void)cameraOpenWithController:(UIViewController *)controller{
    //1、判断相册是否可以打开
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]){
        return;
    }
    //2、创建选择控制器
    UIImagePickerController *ipc = [[UIImagePickerController alloc]init];
    //3. 打开照片的相册类型
    ipc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    //4设置代理
    ipc.delegate = self;
    ipc.allowsEditing = YES;
    //5.modal出这个控制器
    [controller presentViewController:ipc animated:YES completion:nil];
    
}

#pragma mark -- <UIImagePickerControllerDelegate>--
// 获取图片后的操作
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    // 销毁控制器
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    // 设置图片
//    self.imageView.image = info[UIImagePickerControllerOriginalImage];
    NSLog(@"%@",info);
}
@end
