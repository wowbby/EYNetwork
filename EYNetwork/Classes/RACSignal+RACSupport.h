//
//  RACSignal+RACSupport.h
//  AFNetworking
//
//  Created by 郑振兴 on 2018/9/20.
//

#import <ReactiveObjC/ReactiveObjC.h>
#import <ReactiveObjC/RACSignal.h>
@interface RACSignal (RACSupport)
- (RACDisposable *)subscribeStart:(void (^)(NSURLSessionTask *task))start Next:(void (^)(id _Nullable x))nextBlock progress:(void (^)(NSProgress *))progress error:(void (^)(NSError *_Nullable error))errorBlock completed:(void (^)(void))completedBlock;
@end
