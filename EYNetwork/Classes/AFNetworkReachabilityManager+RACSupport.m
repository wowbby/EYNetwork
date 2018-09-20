//
//  AFNetworkReachabilityManager+RACSupport.m
//  AFNetworking
//
//  Created by 郑振兴 on 2018/9/20.
//

#import "AFNetworkReachabilityManager+RACSupport.h"

@implementation AFNetworkReachabilityManager (RACSupport)
- (RACSignal *)rac_startMonitoring
{

    [self stopMonitoring];
    return [RACSignal createSignal:^RACDisposable *_Nullable(id<RACSubscriber> _Nonnull subscriber) {
      [self startMonitoring];

      [self setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        [subscriber sendNext:@(status)];
      }];
      return [RACDisposable disposableWithBlock:^{

      }];
    }];
}
@end
