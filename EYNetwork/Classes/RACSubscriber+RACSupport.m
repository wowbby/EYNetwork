//
//  RACSubscriber+RACSupport.m
//  AFNetworking
//
//  Created by 郑振兴 on 2018/9/20.
//

#import "RACSubscriber+RACSupport.h"
#import <objc/runtime.h>
static NSString *const kprogress = @"progress";

@interface RACSubscriber (Progress)
@property (nonatomic, strong) void (^progress)(NSProgress *);
@end

@implementation RACSubscriber (RACSupport)
+ (instancetype)subscriberWithNext:(void (^)(id))next progress:(void (^)(NSProgress *))progress error:(void (^)(NSError *))error completed:(void (^)(void))completed
{

    RACSubscriber *subscriber = [RACSubscriber subscriberWithNext:next error:error completed:completed];
    subscriber.progress = progress;
    return subscriber;
}
- (void)setProgress:(NSProgress *)progress
{

    objc_setAssociatedObject(self, &kprogress, progress, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
- (NSProgress *)progress
{
    return objc_getAssociatedObject(self, &kprogress);
}
- (void)sendProgress:(NSProgress *)progress
{
    if (self.progress) {
        self.progress(progress);
    }
}
@end

@interface RACPassthroughSubscriber ()
// The subscriber to which events should be forwarded.
@property (nonatomic, strong, readonly) id<RACSubscriber> innerSubscriber;
@end

@implementation RACPassthroughSubscriber (RACSupport)
- (void)sendProgress:(NSProgress *)progress
{
    if ([self.innerSubscriber isKindOfClass:[RACSubscriber class]]) {

        RACSubscriber *subscriber = (RACSubscriber *)self.innerSubscriber;

        [subscriber sendProgress:progress];
    }
}
@end
