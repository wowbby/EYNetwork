//
//  RACSubscriber+AFProgressCallbacks.h
//  AFNetworking
//
//  Created by 郑振兴 on 2018/9/19.
//

#import <ReactiveObjC/ReactiveObjC.h>
#import <ReactiveObjC/RACSubscriber+Private.h>
@interface RACSubscriber (AFProgressCallbacks)
+ (instancetype)subscriberWithNext:(void (^)(id x))next uploadProgress:(void (^)(NSProgress *_Nonnull progress))uploadProgress downLoadProgress:(void (^)(NSProgress *_Nonnull progress))downLoadProgress error:(void (^)(NSError *error))error completed:(void (^)(void))completed;

- (void)sendUploadProgress:(NSProgress *_Nonnull)progress;
- (void)sendDownloadProgress:(NSProgress *_Nonnull)progress;
@end

@interface RACSignal (RAFNProgressSubscriptions)
//upload
- (RACDisposable *)subscribeUpLoadProgress:(void (^)(NSProgress *_Nonnull progress))uploadProgress next:(void (^)(id x))nextBlock;
- (RACDisposable *)subscribeUpLoadProgress:(void (^)(NSProgress *_Nonnull progress))uploadProgress next:(void (^)(id x))nextBlock completed:(void (^)(void))completedBlock;
- (RACDisposable *)subscribeUpLoadProgress:(void (^)(NSProgress *_Nonnull progress))uploadProgress next:(void (^)(id x))nextBlock error:(void (^)(NSError *error))errorBlock;
- (RACDisposable *)subscribeUpLoadProgress:(void (^)(NSProgress *_Nonnull progress))uploadProgress next:(void (^)(id x))nextBlock error:(void (^)(NSError *error))errorBlock completed:(void (^)(void))completedBlock;
//downLoad
- (RACDisposable *)subscribeDownProgress:(void (^)(NSProgress *_Nonnull progress))downloadProgress next:(void (^)(id x))nextBlock;
- (RACDisposable *)subscribeProgress:(void (^)(NSProgress *_Nonnull progress))downloadProgress next:(void (^)(id x))nextBlock completed:(void (^)(void))completedBlock;
- (RACDisposable *)subscribeDownProgress:(void (^)(NSProgress *_Nonnull progress))downloadProgress next:(void (^)(id x))nextBlock error:(void (^)(NSError *error))errorBlock;
- (RACDisposable *)subscribeDownProgress:(void (^)(NSProgress *_Nonnull progress))downloadProgress next:(void (^)(id x))nextBlock error:(void (^)(NSError *error))errorBlock completed:(void (^)(void))completedBlock;
@end

@interface RACSubject (RAFNProgressSending)
- (void)sendUploadProgress:(NSProgress *_Nonnull)progress;
- (void)sendDownloadProgress:(NSProgress *_Nonnull)progress;
@end
