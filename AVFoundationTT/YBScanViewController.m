//
//  YBScanViewController.m
//  AVFoundationTT
//
//  Created by shejun.zhou on 15/4/20.
//  Copyright (c) 2015年 YiBan.iOS. All rights reserved.
//

#import "YBScanViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface YBScanViewController ()<AVCaptureMetadataOutputObjectsDelegate>

@property (nonatomic) BOOL isReading;
@property (nonatomic) BOOL qrcodeFlag;
@property (nonatomic, strong) AVCaptureSession *captureSession;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *videoPreviewLayer;

@end

@implementation YBScanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    if (AVAuthorizationStatusAuthorized != [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"无法使用相机"
                                                            message:@"请在iPhone的”设置-隐私-相机“中允许访问相机"
                                                           delegate:nil
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil];
        [alertView show];
        return;
    }else {
        [self startReading];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)btnStartReading:(id)sender {
    [self startReading];
}

- (BOOL)startReading {
    self.isReading = YES;
    NSError *error;
    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&error];
    if (!input) {
        NSLog(@"%@", [error localizedDescription]); return NO;
    }
    self.captureSession = [[AVCaptureSession alloc] init];
    [self.captureSession addInput:input];
    AVCaptureMetadataOutput *captureMetadataOutput = [[AVCaptureMetadataOutput alloc] init];
    [self.captureSession addOutput:captureMetadataOutput];
    dispatch_queue_t dispatchQueue;
    dispatchQueue = dispatch_get_main_queue();
    [captureMetadataOutput setMetadataObjectsDelegate:self queue:dispatchQueue];
    if (self.qrcodeFlag){
        [captureMetadataOutput setMetadataObjectTypes:[NSArray arrayWithObject:AVMetadataObjectTypeQRCode]];
    } else{
        [captureMetadataOutput setMetadataObjectTypes:[NSArray arrayWithObjects:AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code, AVMetadataObjectTypeQRCode, nil]];
    }
    self.videoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.captureSession];
    [self.videoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    [self.videoPreviewLayer setFrame:self.view.layer.bounds];
    [self.view.layer addSublayer:self.videoPreviewLayer];

    [self.captureSession startRunning];
    return YES;
}

-(void)stopReading{
    [self.captureSession stopRunning]; self.captureSession = nil;
//    [_videoPreviewLayer removeFromSuperlayer];
}
-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects
      fromConnection:(AVCaptureConnection *)connection
{
    if (!self.isReading) return;
    if (metadataObjects != nil && [metadataObjects count] > 0) {
        AVMetadataMachineReadableCodeObject *metadataObj = [metadataObjects objectAtIndex:0];
        NSLog(@"metadataObj:%@", metadataObj);
        NSString *strMessage = [NSString stringWithFormat:@"%@", metadataObj.stringValue];
        [self stopReading];
        if (self.myBb) {
            self.myBb(strMessage);
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)returnScanStringValue:(myBlock)bk {
    self.myBb = bk;
}

@end
