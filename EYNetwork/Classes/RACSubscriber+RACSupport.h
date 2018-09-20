//
//  RACSubscriber+RACSupport.h
//  AFNetworking
//
//  Created by 郑振兴 on 2018/9/20.
//

#import <ReactiveObjC/ReactiveObjC.h>
#import <ReactiveObjC/RACSubscriber+Private.h>
#import "ReactiveObjC/RACPassthroughSubscriber.h"

@interface RACSubscriber (RACSupport)
+ (instancetype)subscriberWithNext:(void (^)(id))next progress:(void (^)(NSProgress *))progress error:(void (^)(NSError *))error completed:(void (^)(void))completed;
- (void)sendProgress:(NSProgress *)progress;
@end

@interface RACPassthroughSubscriber (RACSupport)
- (void)sendProgress:(NSProgress *)progress;
@end
