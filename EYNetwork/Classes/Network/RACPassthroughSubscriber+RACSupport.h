//
//  RACSubscriber+RACSupport.h
//  AFNetworking
//
//  Created by 郑振兴 on 2018/9/20.
//

#import <ReactiveObjC/ReactiveObjC.h>
#import "ReactiveObjC/RACPassthroughSubscriber.h"

@interface RACPassthroughSubscriber (RACSupport)
- (void)sendProgress:(NSProgress *)progress;
- (void)sendStart:(NSURLSessionTask *)task;
@end
