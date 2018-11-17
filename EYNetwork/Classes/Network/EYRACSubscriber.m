//
//  EYRACSubscriber.m
//  AFNetworking
//
//  Created by 郑振兴 on 2018/9/20.
//

#import "EYRACSubscriber.h"
#import "RACCompoundDisposable.h"
#import <ReactiveObjC/RACEXTScope.h>
@interface EYRACSubscriber ()

// These callbacks should only be accessed while synchronized on self.
@property (nonatomic, copy) void (^next)(id value);
@property (nonatomic, copy) void (^error)(NSError *error);
@property (nonatomic, copy) void (^progress)(NSProgress *progress);
@property (nonatomic, copy) void (^completed)(void);
@property (nonatomic, copy) void (^start)(NSURLSessionTask *task);

@property (nonatomic, strong, readonly) RACCompoundDisposable *disposable;
@end

@implementation EYRACSubscriber

#pragma mark Lifecycle

+ (instancetype)subscriberWithStart:(void (^)(NSURLSessionTask *task))start next:(void (^)(id x))next progress:(void (^)(NSProgress *progress))progress error:(void (^)(NSError *error))error completed:(void (^)(void))completed
{
    EYRACSubscriber *subscriber = [[self alloc] init];

    subscriber->_start = [start copy];
    subscriber->_progress = [progress copy];
    subscriber->_next = [next copy];
    subscriber->_error = [error copy];
    subscriber->_completed = [completed copy];

    return subscriber;
}

- (instancetype)init
{
    self = [super init];

    @unsafeify(self);

    RACDisposable *selfDisposable = [RACDisposable disposableWithBlock:^{
      @strongify(self);

      @synchronized(self)
      {
          self.next = nil;
          self.error = nil;
          self.completed = nil;
          self.progress = nil;
      }
    }];

    _disposable = [RACCompoundDisposable compoundDisposable];
    [_disposable addDisposable:selfDisposable];

    return self;
}

- (void)dealloc
{
    [self.disposable dispose];
}

#pragma mark RACSubscriber
- (void)sendStart:(NSURLSessionTask *)task
{
    @synchronized(self)
    {
        void (^startBlock)(id) = [self.start copy];
        if (startBlock == nil)
            return;

        startBlock(task);
    }
}
- (void)sendNext:(id)value
{
    @synchronized(self)
    {
        void (^nextBlock)(id) = [self.next copy];
        if (nextBlock == nil)
            return;

        nextBlock(value);
    }
}

- (void)sendError:(NSError *)e
{
    @synchronized(self)
    {
        void (^errorBlock)(NSError *) = [self.error copy];
        [self.disposable dispose];

        if (errorBlock == nil)
            return;
        errorBlock(e);
    }
}

- (void)sendCompleted
{
    @synchronized(self)
    {
        void (^completedBlock)(void) = [self.completed copy];
        [self.disposable dispose];

        if (completedBlock == nil)
            return;
        completedBlock();
    }
}
- (void)sendProgress:(NSProgress *)progress
{

    @synchronized(self)
    {
        void (^progressBlock)(NSProgress *progress) = [self.progress copy];
        if (progress == nil)
            return;
        progressBlock(progress);
    }
}
- (void)didSubscribeWithDisposable:(RACCompoundDisposable *)otherDisposable
{
    if (otherDisposable.disposed)
        return;

    RACCompoundDisposable *selfDisposable = self.disposable;
    [selfDisposable addDisposable:otherDisposable];

    @unsafeify(otherDisposable);

    // If this subscription terminates, purge its disposable to avoid unbounded
    // memory growth.
    [otherDisposable addDisposable:[RACDisposable disposableWithBlock:^{
                       @strongify(otherDisposable);
                       [selfDisposable removeDisposable:otherDisposable];
                     }]];
}
@end
