//
//  RACSignal+RACSupport.m
//  AFNetworking
//
//  Created by 郑振兴 on 2018/9/20.
//

#import "RACSignal+RACSupport.h"
#import "RACPassthroughSubscriber+RACSupport.h"
#import "EYRACSubscriber.h"
@implementation RACSignal (RACSupport)
- (RACDisposable *)subscribeNext:(void (^)(id _Nullable x))nextBlock progress:(void (^)(NSProgress *))progress error:(void (^)(NSError *_Nullable error))errorBlock completed:(void (^)(void))completedBlock
{

    id<RACSubscriber> subscriber = [EYRACSubscriber subscriberWithNext:nextBlock progress:progress error:errorBlock completed:completedBlock];
    return [self subscribe:subscriber];
}
@end
