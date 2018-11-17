//
//  AFHTTPSessionManager+RACSupport.h
//  AFNetworking
//
//  Created by 郑振兴 on 2018/9/20.
//

#import <AFNetworking/AFNetworking.h>
#import <ReactiveObjC/ReactiveObjC.h>
@interface AFHTTPSessionManager (RACSupport)
- (nonnull RACSignal *)GET:(NSString *)URLString
                parameters:(nullable id)parameters;
- (nonnull RACSignal *)HEAD:(NSString *)URLString
                 parameters:(nullable id)parameters;
- (nonnull RACSignal *)POST:(NSString *)URLString
                 parameters:(nullable id)parameters;
- (nonnull RACSignal *)POST:(NSString *)URLString
                 parameters:(nullable id)parameters
  constructingBodyWithBlock:(nullable void (^)(id<AFMultipartFormData> formData))block;
- (nonnull RACSignal *)PUT:(NSString *)URLString
                parameters:(nullable id)parameters;
- (nonnull RACSignal *)PATCH:(NSString *)URLString
                  parameters:(nullable id)parameters;
- (nonnull RACSignal *)DELETE:(NSString *)URLString
                   parameters:(nullable id)parameters;
- (nonnull RACSignal *)uploadTaskWithRequest:(NSURLRequest *)request
                                    fromFile:(NSURL *)fileURL;
- (nonnull RACSignal *)uploadTaskWithRequest:(NSURLRequest *)request
                                    fromData:(nullable NSData *)bodyData;
- (nonnull RACSignal *)uploadTaskWithStreamedRequest:(NSURLRequest *)request;
- (nonnull RACSignal *)downloadTaskWithRequest:(NSURLRequest *)request
                                   destination:(nullable NSURL * (^)(NSURL *targetPath, NSURLResponse *response))destination;
- (nonnull RACSignal *)downloadTaskWithResumeData:(NSData *)resumeData
                                      destination:(nullable NSURL * (^)(NSURL *targetPath, NSURLResponse *response))destination;
@end
