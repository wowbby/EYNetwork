//
//  AFHTTPSessionManager+RACSupport.m
//  AFNetworking
//
//  Created by 郑振兴 on 2018/9/20.
//

#import "AFHTTPSessionManager+RACSupport.h"
#import "RACPassthroughSubscriber+RACSupport.h"
#import <EYRACSubscriber.h>
@implementation AFHTTPSessionManager (RACSupport)
- (RACSignal *)GET:(NSString *)URLString parameters:(id)parameters
{
    return [RACSignal createSignal:^RACDisposable *_Nullable(id<RACSubscriber> _Nonnull subscriber) {

      NSURLSessionDataTask *task = [self GET:URLString
          parameters:parameters
          progress:^(NSProgress *_Nonnull downloadProgress) {
            [(EYRACSubscriber *)subscriber sendProgress:downloadProgress];
          }
          success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {
            [subscriber sendNext:RACTuplePack(task, responseObject)];
            [subscriber sendCompleted];
          }
          failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
            [subscriber sendError:error];
            [subscriber sendCompleted];
          }];
      [(EYRACSubscriber *)subscriber sendStart:task];
      return [RACDisposable disposableWithBlock:^{
        [task cancel];
      }];
    }];
}
- (RACSignal *)HEAD:(NSString *)URLString
         parameters:(nullable id)parameters
{
    return [RACSignal createSignal:^RACDisposable *_Nullable(id<RACSubscriber> _Nonnull subscriber) {

      NSURLSessionDataTask *task = [self HEAD:URLString
          parameters:parameters
          success:^(NSURLSessionDataTask *_Nonnull task) {
            [subscriber sendNext:task];
            [subscriber sendCompleted];
          }
          failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
            [subscriber sendError:error];
            [subscriber sendCompleted];
          }];
      [(EYRACSubscriber *)subscriber sendStart:task];
      return [RACDisposable disposableWithBlock:^{
        [task cancel];
      }];
    }];
}
- (RACSignal *)POST:(NSString *)URLString
         parameters:(nullable id)parameters
{
    return [RACSignal createSignal:^RACDisposable *_Nullable(id<RACSubscriber> _Nonnull subscriber) {

      NSURLSessionDataTask *task = [self POST:URLString
          parameters:parameters
          progress:^(NSProgress *_Nonnull uploadProgress) {
            [(EYRACSubscriber *)subscriber sendProgress:uploadProgress];
          }
          success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {
            [subscriber sendNext:RACTuplePack(task, responseObject)];
            [subscriber sendCompleted];
          }
          failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
            [subscriber sendError:error];
            [subscriber sendCompleted];
          }];
      [(EYRACSubscriber *)subscriber sendStart:task];
      return [RACDisposable disposableWithBlock:^{
        [task cancel];
      }];
    }];
}
- (RACSignal *)POST:(NSString *)URLString
                   parameters:(nullable id)parameters
    constructingBodyWithBlock:(nullable void (^)(id<AFMultipartFormData> formData))block
{
    return [RACSignal createSignal:^RACDisposable *_Nullable(id<RACSubscriber> _Nonnull subscriber) {
      NSURLSessionDataTask *task = [self POST:URLString
          parameters:parameters
          constructingBodyWithBlock:block
          progress:^(NSProgress *_Nonnull uploadProgress) {
            [(EYRACSubscriber *)subscriber sendProgress:uploadProgress];
          }
          success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {
            [subscriber sendNext:RACTuplePack(task, responseObject)];
            [subscriber sendCompleted];
          }
          failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
            [subscriber sendError:error];
            [subscriber sendCompleted];
          }];
      [(EYRACSubscriber *)subscriber sendStart:task];
      return [RACDisposable disposableWithBlock:^{
        [task cancel];
      }];
    }];
}
- (nonnull RACSignal *)PUT:(NSString *)URLString
                parameters:(nullable id)parameters
{
    return [RACSignal createSignal:^RACDisposable *_Nullable(id<RACSubscriber> _Nonnull subscriber) {
      NSURLSessionDataTask *task = [self PUT:URLString
          parameters:parameters
          success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {
            [subscriber sendNext:RACTuplePack(task, responseObject)];
            [subscriber sendCompleted];
          }
          failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
            [subscriber sendError:error];
            [subscriber sendCompleted];
          }];
      [(EYRACSubscriber *)subscriber sendStart:task];
      return [RACDisposable disposableWithBlock:^{
        [task cancel];
      }];
    }];
}
- (RACSignal *)PATCH:(NSString *)URLString parameters:(id)parameters
{
    return [RACSignal createSignal:^RACDisposable *_Nullable(id<RACSubscriber> _Nonnull subscriber) {
      NSURLSessionDataTask *task = [self PATCH:URLString
          parameters:parameters
          success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {
            [subscriber sendNext:RACTuplePack(task, responseObject)];
            [subscriber sendCompleted];
          }
          failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
            [subscriber sendError:error];
            [subscriber sendCompleted];
          }];
      [(EYRACSubscriber *)subscriber sendStart:task];
      return [RACDisposable disposableWithBlock:^{
        [task cancel];
      }];
    }];
}
- (RACSignal *)DELETE:(NSString *)URLString parameters:(id)parameters
{
    return [RACSignal createSignal:^RACDisposable *_Nullable(id<RACSubscriber> _Nonnull subscriber) {
      NSURLSessionDataTask *task = [self DELETE:URLString
          parameters:parameters
          success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {
            [subscriber sendNext:RACTuplePack(task, responseObject)];
            [subscriber sendCompleted];
          }
          failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
            [subscriber sendError:error];
            [subscriber sendCompleted];
          }];
      [(EYRACSubscriber *)subscriber sendStart:task];
      return [RACDisposable disposableWithBlock:^{
        [task cancel];
      }];
    }];
}
- (nonnull RACSignal *)uploadTaskWithRequest:(NSURLRequest *)request
                                    fromFile:(NSURL *)fileURL
{
    return [RACSignal createSignal:^RACDisposable *_Nullable(id<RACSubscriber> _Nonnull subscriber) {

      NSURLSessionUploadTask *task = [self uploadTaskWithRequest:request
          fromFile:fileURL
          progress:^(NSProgress *_Nonnull uploadProgress) {
            [(EYRACSubscriber *)subscriber sendProgress:uploadProgress];
          }
          completionHandler:^(NSURLResponse *_Nonnull response, id _Nullable responseObject, NSError *_Nullable error) {
            if (error) {
                [subscriber sendError:error];
                [subscriber sendCompleted];
            }
            else {
                [subscriber sendNext:RACTuplePack(response, responseObject)];
                [subscriber sendCompleted];
            }
          }];
      [(EYRACSubscriber *)subscriber sendStart:task];
      return [RACDisposable disposableWithBlock:^{
        [task cancel];
      }];
    }];
}
- (nonnull RACSignal *)uploadTaskWithRequest:(NSURLRequest *)request
                                    fromData:(nullable NSData *)bodyData
{

    return [RACSignal createSignal:^RACDisposable *_Nullable(id<RACSubscriber> _Nonnull subscriber) {

      NSURLSessionUploadTask *task = [self uploadTaskWithRequest:request
          fromData:bodyData
          progress:^(NSProgress *_Nonnull uploadProgress) {
            [(EYRACSubscriber *)subscriber sendProgress:uploadProgress];
          }
          completionHandler:^(NSURLResponse *_Nonnull response, id _Nullable responseObject, NSError *_Nullable error) {
            if (error) {
                [subscriber sendError:error];
                [subscriber sendCompleted];
            }
            else {
                [subscriber sendNext:RACTuplePack(response, responseObject)];
                [subscriber sendCompleted];
            }
          }];
      [(EYRACSubscriber *)subscriber sendStart:task];
      return [RACDisposable disposableWithBlock:^{
        [task cancel];
      }];
    }];
}
- (nonnull RACSignal *)uploadTaskWithStreamedRequest:(NSURLRequest *)request
{
    return [RACSignal createSignal:^RACDisposable *_Nullable(id<RACSubscriber> _Nonnull subscriber) {

      NSURLSessionUploadTask *task = [self uploadTaskWithStreamedRequest:request
          progress:^(NSProgress *_Nonnull uploadProgress) {
            [(EYRACSubscriber *)subscriber sendProgress:uploadProgress];
          }
          completionHandler:^(NSURLResponse *_Nonnull response, id _Nullable responseObject, NSError *_Nullable error) {
            if (error) {
                [subscriber sendError:error];
                [subscriber sendCompleted];
            }
            else {
                [subscriber sendNext:RACTuplePack(response, responseObject)];
                [subscriber sendCompleted];
            }

          }];
      [(EYRACSubscriber *)subscriber sendStart:task];
      return [RACDisposable disposableWithBlock:^{
        [task cancel];
      }];
    }];
}
- (nonnull RACSignal *)downloadTaskWithRequest:(NSURLRequest *)request
                                   destination:(nullable NSURL * (^)(NSURL *targetPath, NSURLResponse *response))destination
{
    return [RACSignal createSignal:^RACDisposable *_Nullable(id<RACSubscriber> _Nonnull subscriber) {

      NSURLSessionDownloadTask *task = [self downloadTaskWithRequest:request
          progress:^(NSProgress *_Nonnull downloadProgress) {
            [(EYRACSubscriber *)subscriber sendProgress:downloadProgress];
          }
          destination:destination
          completionHandler:^(NSURLResponse *_Nonnull response, NSURL *_Nullable filePath, NSError *_Nullable error) {
            if (error) {
                [subscriber sendError:error];
                [subscriber sendCompleted];
            }
            else {
                [subscriber sendNext:RACTuplePack(response, filePath)];
                [subscriber sendCompleted];
            }

          }];
      [(EYRACSubscriber *)subscriber sendStart:task];
      return [RACDisposable disposableWithBlock:^{
        [task cancel];
      }];
    }];
}
- (nonnull RACSignal *)downloadTaskWithResumeData:(NSData *)resumeData
                                      destination:(nullable NSURL * (^)(NSURL *targetPath, NSURLResponse *response))destination
{

    return [RACSignal createSignal:^RACDisposable *_Nullable(id<RACSubscriber> _Nonnull subscriber) {

      NSURLSessionDownloadTask *task = [self downloadTaskWithResumeData:resumeData
          progress:^(NSProgress *_Nonnull downloadProgress) {
            [(EYRACSubscriber *)subscriber sendProgress:downloadProgress];
          }
          destination:destination
          completionHandler:^(NSURLResponse *_Nonnull response, NSURL *_Nullable filePath, NSError *_Nullable error) {
            if (error) {
                [subscriber sendError:error];
                [subscriber sendCompleted];
            }
            else {
                [subscriber sendNext:RACTuplePack(response, filePath)];
                [subscriber sendCompleted];
            }

          }];
      [(EYRACSubscriber *)subscriber sendStart:task];
      return [RACDisposable disposableWithBlock:^{
        [task cancel];
      }];
    }];
}
@end
