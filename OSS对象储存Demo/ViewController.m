//
//  ViewController.m
//  OSS对象储存Demo
//
//  Created by 刘高升 on 17/2/20.
//  Copyright © 2017年 刘高升. All rights reserved.
//

#import "ViewController.h"
#import "AliyunOSS.h"
#import "GSCamera.h"
@interface ViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UIButton *uploadButoon;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [[AliyunOSS sharedInstance] setupEnvironment];
    [_uploadButoon addTarget:self action:@selector(upLoad) forControlEvents:UIControlEventTouchUpInside];
}

- (void)upLoad{

    [self openCamera];

}
- (void)openCamera{
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
    [self presentViewController:ipc animated:YES completion:nil];


}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    // 销毁控制器
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    self.imageView.image = info[UIImagePickerControllerOriginalImage];
    NSData *data = [[NSData alloc]init];
    //判断图片是不是png格式的文件
    if (UIImagePNGRepresentation(self.imageView.image)) {
        //返回为png图像。
        data = UIImagePNGRepresentation(self.imageView.image);
    }else {
        //返回为JPEG图像。
        data = UIImageJPEGRepresentation(self.imageView.image, 0.1);
    }
    //上传图片
    [[AliyunOSS sharedInstance]uploadObjectAsyncWithImageData:data];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
