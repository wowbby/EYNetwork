//
//  AFNetworkReachabilityManager+RACSupport.h
//  AFNetworking
//
//  Created by 郑振兴 on 2018/9/20.
//

#import <AFNetworking/AFNetworking.h>
#import <ReactiveObjC/ReactiveObjC.h>
@interface AFNetworkReachabilityManager (RACSupport)
- (RACSignal *)rac_startMonitoring;
@end
