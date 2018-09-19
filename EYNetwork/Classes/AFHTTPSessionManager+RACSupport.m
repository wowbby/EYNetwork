//
//  AFHTTPSessionManager+RACSupport.m
//  AFNetworking
//
//  Created by 郑振兴 on 2018/9/19.
//

#import "AFHTTPSessionManager+RACSupport.h"

static NSString *const kRACAFNResponseObjectErrorKey = @"responseObject";

@implementation AFHTTPSessionManager (RACSupport)
- (RACSignal *)rac_requestPath:(NSString *)path parameters:(id)parameters method:(NSString *)method uploadProgress:(nullable void (^)(NSProgress *uploadProgress))uploadProgressBlock downloadProgress:(nullable void (^)(NSProgress *downloadProgress))downloadProgressBlock
{

    return [RACSignal createSignal:^RACDisposable *_Nullable(id<RACSubscriber> _Nonnull subscriber) {
      NSString *URL = [[NSURL URLWithString:path relativeToURL:self.baseURL] absoluteString];
      NSURLRequest *request = [self.requestSerializer requestWithMethod:method URLString:URL parameters:parameters error:nil];
      NSURLSessionDataTask *task = [self dataTaskWithRequest:request
                                              uploadProgress:nil
                                            downloadProgress:nil
                                           completionHandler:^(NSURLResponse *_Nonnull response, id _Nullable responseObject, NSError *_Nullable error) {
                                             if (error) {
                                                 NSMutableDictionary *userInfo = [error.userInfo copy];
                                                 if (responseObject) {
                                                     userInfo[kRACAFNResponseObjectErrorKey] = responseObject;
                                                 }
                                                 NSError *responseError = [NSError errorWithDomain:error.domain code:error.code userInfo:[error.userInfo copy]];
                                                 [subscriber sendError:responseError];
                                             }
                                             else {

                                                 [subscriber sendNext:RACTuplePack(responseObject, response)];
                                             }
                                           }];
      [task resume];

      return [RACDisposable disposableWithBlock:^{
        [task cancel];
      }];
    }];
}
@end
