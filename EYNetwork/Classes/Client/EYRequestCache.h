//
//  EYRequestCache.h
//  AFNetworking
//
//  Created by 振兴郑 on 2018/11/16.
//

#import <Foundation/Foundation.h>
#import "EYRequest.h"
NS_ASSUME_NONNULL_BEGIN

@protocol EYRequestCache <NSObject>
- (instancetype)initWithCacheKey:(NSString *)cacheKey cacheTimeInSeconds:(NSInteger)cacheTimeInSeconds responseSerializerType:(EYResponseSerializerType)responseSerializerType;
- (id)loadCachdata;
- (void)saveResponseDataToCacheFile:(NSData *)data;
@end

NS_ASSUME_NONNULL_END
