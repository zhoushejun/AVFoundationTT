//
//  YBScanViewController.h
//  AVFoundationTT
//
//  Created by shejun.zhou on 15/4/20.
//  Copyright (c) 2015年 YiBan.iOS. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^myBlock)(NSString *str);

@interface YBScanViewController : UIViewController

@property (nonatomic, copy) myBlock myBb;

- (void)returnScanStringValue:(myBlock)bk;

@end
