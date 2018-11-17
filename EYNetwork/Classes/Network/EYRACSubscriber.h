//
//  EYRACSubscriber.h
//  AFNetworking
//
//  Created by 郑振兴 on 2018/9/20.
//

#import <Foundation/Foundation.h>
#import "RACSubscriber.h"
@interface EYRACSubscriber : NSObject <RACSubscriber>
+ (instancetype)subscriberWithStart:(void (^)(NSURLSessionTask *task))start next:(void (^)(id x))next progress:(void (^)(NSProgress *progress))progress error:(void (^)(NSError *error))error completed:(void (^)(void))completed;
- (void)sendProgress:(NSProgress *)progress;
- (void)sendStart:(NSURLSessionTask *)task;
@end
