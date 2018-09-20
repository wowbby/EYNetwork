//
//  EYViewController.m
//  EYNetwork
//
//  Created by wowbby on 09/19/2018.
//  Copyright (c) 2018 wowbby. All rights reserved.
//

#import "EYViewController.h"
#import "AFNetworkReachabilityManager+RACSupport.h"
#import "AFHTTPSessionManager+RACSupport.h"
#import "RACSignal+RACSupport.h"

@interface EYViewController ()
@property (nonatomic, assign) BOOL start;
@end

@implementation EYViewController
- (IBAction)btnAction:(id)sender
{

    if (!_start) {

        [self rac_startMonitoring];
    }
    else {
        [[AFNetworkReachabilityManager sharedManager] stopMonitoring];
    }
    _start = !_start;
}
- (void)rac_startMonitoring
{

    [[[AFNetworkReachabilityManager sharedManager] rac_startMonitoring] subscribeNext:^(id _Nullable x) {

      NSLog(@"%@", x);
    }];
    ;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    //http://api01.bitspaceman.com:8000/news/qihoo?apikey=6Vw54sUQ1woFrPFsUeRtjPk6CSWIJRBnQKJV6DJ1BjD5Xo4zDyLpE38w7R8nkjUs
    RACSignal *signal = [[AFHTTPSessionManager manager] GET:@"https://dldir1.qq.com/qqfile/QQforMac/QQ_V6.5.1.dmg"
                                                 parameters:@{}];

    [signal subscribeNext:^(id _Nullable x) {
      NSLog(@"请求成功：%@", x);
    }
        progress:^(NSProgress *progress) {
          NSLog(@"请求过程");
        }
        error:^(NSError *_Nullable error) {
          NSLog(@"请求失败：%@", error);
        }
        completed:^{
          NSLog(@"请求完成");
        }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
