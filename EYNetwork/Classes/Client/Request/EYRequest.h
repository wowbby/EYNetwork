//
//  EYRequest.h
//  AFNetworking
//
//  Created by 振兴郑 on 2018/9/20.
//

#import <Foundation/Foundation.h>
#import <EYNetwork/EYNetwork.h>
typedef NS_ENUM(NSInteger, EYRequestMethod) {
    EYRequestMethodGET,
    EYRequestMethodPOST,
    EYRequestMethodPUT,
    EYRequestMethodDELETE,
    EYRequestMethodPATCH,
    EYRequestMethodHEAD
};
typedef NS_ENUM(NSInteger, EYRequestSerializerType) {
    EYRequestSerializerTypeHTTP,
    EYRequestSerializerTypeJSON
};
typedef NS_ENUM(NSInteger, EYResponseSerializerType) {
    EYResponseSerializerTypeHTTP,
    EYResponseSerializerTypeJSON,
    EYResponseSerializerTypeXML
};
typedef NS_ENUM(NSInteger, EYRequestPriority) {
    EYRequestPriorityLow,
    EYRequestPriorityDefault,
    EYRequestPriorityHigh

};

typedef void (^ConstructingBodyBlock)(id<AFMultipartFormData> formData);

@interface EYRequest : NSObject

/**
 EYRequest request and response information
 */
@property (nonatomic, strong, readonly, nonnull) NSURLSessionTask *task;
@property (nonatomic, strong, readonly, nonnull) NSURLRequest *currentRequest;
@property (nonatomic, strong, readonly, nonnull) NSURLRequest *originalRequest;
@property (nonatomic, strong, readonly, nullable) NSURLResponse *response;
@property (nonatomic, assign, readonly) NSInteger statusCode;
@property (nonatomic, strong, readonly, nullable) NSDictionary *reponseHeaders;
@property (nonatomic, strong, readonly, nullable) id responseObject;
@property (nonatomic, strong, readonly, nullable) NSError *error;

/**
 EYRequest configInfo
 */
@property (assign, nonatomic) NSInteger tag;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *baseURL;
@property (strong, nonatomic) NSString *path;
@property (assign, nonatomic) NSTimeInterval timeoutInterval;
@property (assign, nonatomic) EYRequestMethod method;
@property (strong, nonatomic) id requestArgument;
@property (assign, nonatomic) EYRequestSerializerType requestSerializerType;
@property (assign, nonatomic) EYResponseSerializerType responseSerializerType;
@property (strong, nonatomic) NSDictionary<NSString *, NSString *> *requestHeaders;
@property (copy, nonatomic) ConstructingBodyBlock constructingBodyBlock;
@property (strong, nonatomic) NSString *cacheKey;
@property (assign, nonatomic) BOOL ignoreCache;
@property (assign, nonatomic) NSInteger cacheTimeInSeconds;

/**
 @[@"username",@"password"]
 */
@property (strong, nonatomic) NSArray<NSString *> *authorization;
- (RACSignal *)start;
- (void)cancle;
- (void)suspend;
- (void)resume;
@end
