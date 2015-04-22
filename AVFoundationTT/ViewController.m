//
//  ViewController.m
//  AVFoundationTT
//
//  Created by shejun.zhou on 15/4/17.
//  Copyright (c) 2015年 YiBan.iOS. All rights reserved.
//

#import "ViewController.h"
#import "YBScanViewController.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
     YBScanViewController *vc = [segue destinationViewController];
     [vc returnScanStringValue:^(NSString *str) {
         self.labScanStringValue.text = str;
     }];
 }

@end
