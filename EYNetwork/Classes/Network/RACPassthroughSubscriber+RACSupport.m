//
//  RACSubscriber+RACSupport.m
//  AFNetworking
//
//  Created by 郑振兴 on 2018/9/20.
//

#import "RACPassthroughSubscriber+RACSupport.h"
#import "EYRACSubscriber.h"

@interface RACPassthroughSubscriber ()
// The subscriber to which events should be forwarded.
@property (nonatomic, strong, readonly) id<RACSubscriber> innerSubscriber;
@end

@implementation RACPassthroughSubscriber (RACSupport)
- (void)sendProgress:(NSProgress *)progress
{
    if ([self.innerSubscriber isKindOfClass:[EYRACSubscriber class]]) {

        EYRACSubscriber *subscriber = (EYRACSubscriber *)self.innerSubscriber;

        [subscriber sendProgress:progress];
    }
}
- (void)sendStart:(NSURLSessionTask *)task
{

    if ([self.innerSubscriber isKindOfClass:[EYRACSubscriber class]]) {

        EYRACSubscriber *subscriber = (EYRACSubscriber *)self.innerSubscriber;

        [subscriber sendStart:task];
    }
}
@end
