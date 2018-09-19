//
//  RACSubscriber+AFProgressCallbacks.m
//  AFNetworking
//
//  Created by 郑振兴 on 2018/9/19.
//

#import "RACSubscriber+AFProgressCallbacks.h"
#import <objc/runtime.h>
static NSString *const kuploadProgress = @"uploadProgress";
static NSString *const kdownloadProgress = @"downloadProgress";

@interface RACSubscriber (AFInternalProgressCallbacks)

@property (nonatomic, copy) void (^uploadProgress)(NSProgress *_Nonnull progress);
@property (nonatomic, copy) void (^downloadProgress)(NSProgress *_Nonnull progress);
@end

@implementation RACSubscriber (AFProgressCallbacks)
+ (instancetype)subscriberWithNext:(void (^)(id))next uploadProgress:(void (^)(NSProgress *_Nonnull))uploadProgress downLoadProgress:(void (^)(NSProgress *_Nonnull))downLoadProgress error:(void (^)(NSError *))error completed:(void (^)(void))completed
{
    RACSubscriber *subscriber = [RACSubscriber subscriberWithNext:next error:error completed:completed];
    subscriber.uploadProgress = uploadProgress;
    subscriber.downloadProgress = downLoadProgress;
    return subscriber;
}
- (void)sendUploadProgress:(NSProgress *)progress
{

    [[self performSelector:@selector(dispose)] dispose];
    if (self.uploadProgress) {
        self.uploadProgress(progress);
    }
}
- (void)sendDownloadProgress:(NSProgress *)progress
{
}
- (void (^)(NSProgress *_Nonnull))uploadProgress
{
    return objc_getAssociatedObject(self, &kuploadProgress);
}
- (void)setUploadProgress:(void (^)(NSProgress *_Nonnull))uploadProgress
{
    objc_setAssociatedObject(self, &kuploadProgress, uploadProgress, OBJC_ASSOCIATION_COPY);
}
- (void (^)(NSProgress *_Nonnull))downloadProgress
{
    return objc_getAssociatedObject(self, &kdownloadProgress);
}
- (void)setDownloadProgress:(void (^)(NSProgress *_Nonnull))downloadProgress
{
    objc_setAssociatedObject(self, &kdownloadProgress, downloadProgress, OBJC_ASSOCIATION_COPY);
}
@end

@implementation RACSignal (RAFNProgressSubscriptions)
//upload
- (RACDisposable *)subscribeUpLoadProgress:(void (^)(NSProgress *_Nonnull progress))uploadProgress next:(void (^)(id x))nextBlock
{

    RACSubscriber *subscriber = [RACSubscriber subscriberWithNext:nextBlock uploadProgress:uploadProgress downLoadProgress:nil error:NULL completed:nil];

    return [self subscribe:subscriber];
}
- (RACDisposable *)subscribeUpLoadProgress:(void (^)(NSProgress *_Nonnull progress))uploadProgress next:(void (^)(id x))nextBlock completed:(void (^)(void))completedBlock
{

    RACSubscriber *subscriber = [RACSubscriber subscriberWithNext:nextBlock uploadProgress:uploadProgress downLoadProgress:nil error:NULL completed:completedBlock];

    return [self subscribe:subscriber];
}
- (RACDisposable *)subscribeUpLoadProgress:(void (^)(NSProgress *_Nonnull progress))uploadProgress next:(void (^)(id x))nextBlock error:(void (^)(NSError *error))errorBlock
{
    RACSubscriber *subscriber = [RACSubscriber subscriberWithNext:nextBlock uploadProgress:uploadProgress downLoadProgress:nil error:errorBlock completed:nil];

    return [self subscribe:subscriber];
}
- (RACDisposable *)subscribeUpLoadProgress:(void (^)(NSProgress *_Nonnull progress))uploadProgress next:(void (^)(id x))nextBlock error:(void (^)(NSError *error))errorBlock completed:(void (^)(void))completedBlock
{
    RACSubscriber *subscriber = [RACSubscriber subscriberWithNext:nextBlock uploadProgress:uploadProgress downLoadProgress:nil error:errorBlock completed:completedBlock];

    return [self subscribe:subscriber];
}
//downLoad
- (RACDisposable *)subscribeDownProgress:(void (^)(NSProgress *_Nonnull progress))downloadProgress next:(void (^)(id x))nextBlock
{
    RACSubscriber *subscriber = [RACSubscriber subscriberWithNext:nextBlock uploadProgress:nil downLoadProgress:downloadProgress error:NULL completed:nil];

    return [self subscribe:subscriber];
}
- (RACDisposable *)subscribeProgress:(void (^)(NSProgress *_Nonnull progress))downloadProgress next:(void (^)(id x))nextBlock completed:(void (^)(void))completedBlock
{
    RACSubscriber *subscriber = [RACSubscriber subscriberWithNext:nextBlock uploadProgress:nil downLoadProgress:downloadProgress error:NULL completed:completedBlock];

    return [self subscribe:subscriber];
}
- (RACDisposable *)subscribeDownProgress:(void (^)(NSProgress *_Nonnull progress))downloadProgress next:(void (^)(id x))nextBlock error:(void (^)(NSError *error))errorBlock
{
    RACSubscriber *subscriber = [RACSubscriber subscriberWithNext:nextBlock uploadProgress:nil downLoadProgress:downloadProgress error:errorBlock completed:nil];

    return [self subscribe:subscriber];
}
- (RACDisposable *)subscribeDownProgress:(void (^)(NSProgress *_Nonnull progress))downloadProgress next:(void (^)(id x))nextBlock error:(void (^)(NSError *error))errorBlock completed:(void (^)(void))completedBlock
{
    RACSubscriber *subscriber = [RACSubscriber subscriberWithNext:nextBlock uploadProgress:nil downLoadProgress:downloadProgress error:errorBlock completed:completedBlock];

    return [self subscribe:subscriber];
}
@end

@implementation RACSubject (RAFNProgressSending)
- (void)sendUploadProgress:(NSProgress *_Nonnull)progress
{

    void (^subscriberBlock)(id<RACSubscriber> subscriber) = ^(id<RACSubscriber> subscriber) {
      [(RACSubscriber *)subscriber sendUploadProgress:progress];
    };

    [self performSelector:@selector(performBlockOnEachSubscriber:) withObject:subscriberBlock];
}
- (void)sendDownloadProgress:(NSProgress *_Nonnull)progress
{
    void (^subscriberBlock)(id<RACSubscriber> subscriber) = ^(id<RACSubscriber> subscriber) {
      [(RACSubscriber *)subscriber sendUploadProgress:progress];
    };

    [self performSelector:@selector(performBlockOnEachSubscriber:) withObject:subscriberBlock];
}
@end
