//
//  EYCacheMetadata.h
//  AFNetworking
//
//  Created by 振兴郑 on 2018/11/16.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface EYCacheMetadata : NSObject <NSSecureCoding>
@property (nonatomic, strong) NSDate *creationDate;
@property (nonatomic, strong) NSString *appVersionString;
@end

NS_ASSUME_NONNULL_END
