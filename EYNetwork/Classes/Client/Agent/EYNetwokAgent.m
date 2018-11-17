//
//  EYNetwokAgent.m
//  AFNetworking
//
//  Created by 振兴郑 on 2018/9/20.
//

#import "EYNetwokAgent.h"
#import <EYNetwork/RACSignal+RACSupport.h>
@interface EYNetwokAgent ()
@property (nonatomic, strong) AFHTTPSessionManager *manager;
@property (nonatomic, strong) AFSecurityPolicy *policy;
@end

@implementation EYNetwokAgent
+ (instancetype)shareAgent
{
    static EYNetwokAgent *agent;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
      agent = [[[self class] alloc] init];
    });
    return agent;
}
- (instancetype)init
{
    if (self = [super init]) {
        self.manager.completionQueue = dispatch_queue_create("com.EY.EYNetwokAgent.AFHTTPSessionManager.completionQueue", DISPATCH_QUEUE_CONCURRENT);
    }
    return self;
}
- (AFHTTPSessionManager *)manager
{
    if (!_manager) {
        _manager = ({
            [AFHTTPSessionManager manager];
        });
    }
    return _manager;
}
- (void)setAFSecurityPolicy:(AFSecurityPolicy *)policy
{
    self.policy = policy;
    self.manager.securityPolicy = policy;
}
- (void)setNSURLSessionConfiguration:(NSURLSessionConfiguration *)sessionConfiguration
{
    _manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:sessionConfiguration];
    if (self.policy) {
        _manager.securityPolicy = self.policy;
    }
}
#pragma mark public method
- (RACSignal *)addRequest:(EYRequest *)request
{
    self.manager.requestSerializer = [self createRequestSerializationWith:request];
    self.manager.responseSerializer = [self createResponseSerializationWith:request];
    NSString *URLString = [self createURLStringWithRequest:request];
    if (request.constructingBodyBlock) {

        return [self postWithConstructingBodyBlock:request.constructingBodyBlock URLString:URLString parameters:request.requestArgument];
    }
    else {

        return [self method:request.method URLString:URLString parameters:request.requestArgument];
    }
}
#pragma mark private method
- (RACSignal *)method:(EYRequestMethod)method URLString:(NSString *)urlString parameters:(id)parameters
{

    switch (method) {
        case EYRequestMethodGET:
            return [self.manager GET:urlString parameters:parameters];
            break;
        case EYRequestMethodPOST:
            return [self.manager POST:urlString parameters:parameters];
            break;
        case EYRequestMethodPUT:
            return [self.manager PUT:urlString parameters:parameters];
            break;
        case EYRequestMethodDELETE:
            return [self.manager DELETE:urlString parameters:parameters];
            break;
        case EYRequestMethodPATCH:
            return [self.manager PATCH:urlString parameters:parameters];
            break;
        case EYRequestMethodHEAD:
            return [self.manager HEAD:urlString parameters:parameters];
            break;
        default:
            return [self.manager GET:urlString parameters:parameters];
            break;
    }
    return nil;
}
- (RACSignal *)postWithConstructingBodyBlock:(ConstructingBodyBlock)block URLString:(NSString *)urlstring parameters:(id)parameters
{
    return [self.manager POST:urlstring parameters:parameters constructingBodyWithBlock:block];
}
- (id<AFURLRequestSerialization>)createRequestSerializationWith:(EYRequest *)request
{

    if (request.requestSerializerType == EYRequestSerializerTypeHTTP) {
        AFHTTPRequestSerializer *httpRequestSerializer = [AFHTTPRequestSerializer serializer];
        httpRequestSerializer.timeoutInterval = request.timeoutInterval;
        [request.requestHeaders enumerateKeysAndObjectsUsingBlock:^(NSString *_Nonnull key, NSString *_Nonnull obj, BOOL *_Nonnull stop) {
          [httpRequestSerializer setValue:obj forHTTPHeaderField:key];
        }];
        if (request.authorization != nil) {
            [httpRequestSerializer setAuthorizationHeaderFieldWithUsername:request.authorization.firstObject
                                                                  password:request.authorization.lastObject];
        }
        return httpRequestSerializer;
    }
    else {
        AFJSONRequestSerializer *jsonRequestSerializer = [AFJSONRequestSerializer serializer];
        jsonRequestSerializer.timeoutInterval = request.timeoutInterval;
        [request.requestHeaders enumerateKeysAndObjectsUsingBlock:^(NSString *_Nonnull key, NSString *_Nonnull obj, BOOL *_Nonnull stop) {
          [jsonRequestSerializer setValue:obj forHTTPHeaderField:key];
        }];
        if (request.authorization != nil) {
            [jsonRequestSerializer setAuthorizationHeaderFieldWithUsername:request.authorization.firstObject
                                                                  password:request.authorization.lastObject];
        }
        return jsonRequestSerializer;
    }
}
- (id<AFURLResponseSerialization>)createResponseSerializationWith:(EYRequest *)request
{

    id<AFURLResponseSerialization> responseSerialization;
    switch (request.responseSerializerType) {
        case EYResponseSerializerTypeHTTP:
            responseSerialization = [AFHTTPResponseSerializer serializer];
            break;
        case EYResponseSerializerTypeJSON:
            responseSerialization = [AFJSONResponseSerializer serializer];
            break;
        case EYResponseSerializerTypeXML:
            responseSerialization = [AFXMLParserResponseSerializer serializer];
            break;

        default:
            break;
    }
    return responseSerialization;
}
- (NSString *)createURLStringWithRequest:(EYRequest *)request
{

    NSURL *detailURL = [NSURL URLWithString:request.path];
    if (detailURL && detailURL.scheme && detailURL.host) {
        return request.path;
    }
    NSString *urlString = request.baseURL;
    NSURL *baseURL = [NSURL URLWithString:urlString];
    return [NSURL URLWithString:request.path relativeToURL:baseURL].absoluteString;
}
@end
