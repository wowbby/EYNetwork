//
//  EYRequestSampleCache.m
//  AFNetworking
//
//  Created by 振兴郑 on 2018/11/16.
//

#import "EYRequestSampleCache.h"
#import "EYRequest.h"
#import "EYCacheMetadata.h"
static NSString *const kcacheFloderName = @"EYRequestCache";
NSString *const EYRequestCacheErrorDomain = @"com.ey.request.cach";

typedef NS_ENUM(NSInteger, EYRequestCacheError) {

    EYRequestCacheErrorCacheTimeInvalid = 0,
    EYRequestCacheErrorCantFindCachMetadata,
    EYRequestCacheErrorCacheDataInvalid,
    EYRequestCacheErrorCacheDataVersionInvalid,
    EYRequestCacheErrorSaveDataError,


};

@interface EYRequestSampleCache ()
@property (strong, nonatomic) EYCacheMetadata *cacheMetadata;
@property (strong, nonatomic) NSString *cacheKey;
@property (assign, nonatomic) NSInteger cacheTimeInSeconds;
@property (assign, nonatomic) EYResponseSerializerType responseSerializerType;
@property (strong, nonatomic) NSData *cacheData;
@end


@implementation EYRequestSampleCache
- (instancetype)initWithCacheKey:(NSString *)cacheKey cacheTimeInSeconds:(NSInteger)cacheTimeInSeconds responseSerializerType:(EYResponseSerializerType)responseSerializerType
{
    if (self = [super init]) {
        self.cacheKey = cacheKey;
        self.cacheTimeInSeconds = cacheTimeInSeconds;
        self.responseSerializerType = responseSerializerType;
    }
    return self;
}
- (id)loadCachdata
{
    NSError *error;
    [self loadCacheWithError:&error];
    if (error) {
        return nil;
    }
    switch (self.responseSerializerType) {
        case EYResponseSerializerTypeHTTP:
            return self.cacheData;
            break;
        case EYResponseSerializerTypeJSON:
            return [NSJSONSerialization JSONObjectWithData:self.cacheData options:(NSJSONReadingOptions)0 error:&error];
            break;
        case EYResponseSerializerTypeXML:
            return [[NSXMLParser alloc] initWithData:self.cacheData];
            ;
            break;
        default:
            return self.cacheData;
            break;
    }
}
- (void)saveResponseDataToCacheFile:(NSData *)data
{
    if ([self cacheTimeInSeconds] > 0) {
        if (data != nil) {
            @try {
                // New data will always overwrite old data.
                [data writeToFile:[self cacheFilePath] atomically:YES];

                EYCacheMetadata *metadata = [[EYCacheMetadata alloc] init];
                metadata.creationDate = [NSDate date];
                metadata.appVersionString = [self appVersion];
                [NSKeyedArchiver archiveRootObject:metadata toFile:[self cacheMetadataFilePath]];
            }
            @catch (NSException *exception) {
                NSLog(@"Save cache failed, reason = %@", exception.reason);
            }
        }
    }
}
- (BOOL)loadCacheWithError:(NSError *_Nullable __autoreleasing *)error
{
    // Make sure cache time in valid.
    if ([self cacheTimeInSeconds] < 0) {
        if (error) {
            *error = [NSError errorWithDomain:EYRequestCacheErrorDomain code:EYRequestCacheErrorCacheTimeInvalid userInfo:@{ NSLocalizedDescriptionKey : @"Invalid cache time" }];
        }
        return NO;
    }

    // Try load metadata.
    if (![self loadCacheMetadata]) {
        if (error) {
            *error = [NSError errorWithDomain:EYRequestCacheErrorDomain code:EYRequestCacheErrorCantFindCachMetadata userInfo:@{ NSLocalizedDescriptionKey : @"Invalid metadata. Cache may not exist" }];
        }
        return NO;
    }
    //Check if cache is still valid.
    if (![self validateCacheWithError:error]) {
        return NO;
    }

    // Try load cache.
    if (![self loadCacheData]) {
        if (error) {
            *error = [NSError errorWithDomain:EYRequestCacheErrorDomain code:EYRequestCacheErrorCacheDataInvalid userInfo:@{ NSLocalizedDescriptionKey : @"Invalid cache data" }];
        }
        return NO;
    }

    return YES;
}
- (BOOL)validateCacheWithError:(NSError *_Nullable __autoreleasing *)error
{
    // Date
    NSDate *creationDate = self.cacheMetadata.creationDate;
    NSTimeInterval duration = -[creationDate timeIntervalSinceNow];
    if (duration < 0 || duration > [self cacheTimeInSeconds]) {
        if (error) {
            *error = [NSError errorWithDomain:EYRequestCacheErrorDomain code:EYRequestCacheErrorCacheTimeInvalid userInfo:@{ NSLocalizedDescriptionKey : @"Cache expired" }];
        }
        return NO;
    }
    // App version
    NSString *appVersionString = self.cacheMetadata.appVersionString;
    NSString *currentAppVersionString = [self appVersion];
    if (appVersionString || currentAppVersionString) {
        if (appVersionString.length != currentAppVersionString.length || ![appVersionString isEqualToString:currentAppVersionString]) {
            if (error) {
                *error = [NSError errorWithDomain:EYRequestCacheErrorDomain code:EYRequestCacheErrorCacheDataVersionInvalid userInfo:@{ NSLocalizedDescriptionKey : @"App version mismatch" }];
            }
            return NO;
        }
    }
    return YES;
}
- (BOOL)loadCacheData
{
    NSString *path = [self cacheFilePath];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:path isDirectory:nil]) {
        NSData *data = [NSData dataWithContentsOfFile:path];
        _cacheData = data;
        return YES;
    }
    return NO;
}
/**
 加载cacheMetadata

 @return 是否成功
 */
- (BOOL)loadCacheMetadata
{
    NSString *path = [self cacheMetadataFilePath];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:path isDirectory:nil]) {
        @try {
            _cacheMetadata = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
            return YES;
        }
        @catch (NSException *exception) {
            NSLog(@"Load cache metadata failed, reason = %@", exception.reason);
            return NO;
        }
    }
    return NO;
}
/**
 是否需要创建缓存文件夹

 @param path 文件路径
 */
- (void)createDirectoryIfNeeded:(NSString *)path
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir;
    if (![fileManager fileExistsAtPath:path isDirectory:&isDir]) {
        [self createBaseDirectoryAtPath:path];
    }
    else {
        if (!isDir) {
            NSError *error = nil;
            [fileManager removeItemAtPath:path error:&error];
            [self createBaseDirectoryAtPath:path];
        }
    }
}

/**
 创建缓存目录

 @param path 路径
 */
- (void)createBaseDirectoryAtPath:(NSString *)path
{
    NSError *error = nil;
    [[NSFileManager defaultManager] createDirectoryAtPath:path
                              withIntermediateDirectories:YES
                                               attributes:nil
                                                    error:&error];
    if (error) {
        NSLog(@"create cache directory failed, error = %@", error);
    }
    else {
        [self addDoNotBackupAttribute:path];
    }
}

/**
 设置资源不被cloud备份

 @param path 资源路径
 */
- (void)addDoNotBackupAttribute:(NSString *)path
{
    NSURL *url = [NSURL fileURLWithPath:path];
    NSError *error = nil;
    [url setResourceValue:[NSNumber numberWithBool:YES] forKey:NSURLIsExcludedFromBackupKey error:&error];
    if (error) {
        NSLog(@"error to set do not backup attribute, error = %@", error);
    }
}

/**
 缓存文件夹路径

 @return 缓存文件夹路径
 */
- (NSString *)cacheBasePath
{
    NSString *pathOfLibrary = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [pathOfLibrary stringByAppendingPathComponent:kcacheFloderName];
    [self createDirectoryIfNeeded:path];
    return path;
}

/**
 request的Metadata缓存路径

 @return request的Metadata缓存路径
 */
- (NSString *)cacheMetadataFilePath
{
    NSString *cacheMetadataFileName = [NSString stringWithFormat:@"%@.metadata", self.cacheKey];
    NSString *path = [self cacheBasePath];
    path = [path stringByAppendingPathComponent:cacheMetadataFileName];
    return path;
}
/**
 request的缓存路径
 
 @return request的缓存路径
 */
- (NSString *)cacheFilePath
{
    NSString *cacheFileName = self.cacheKey;
    NSString *path = [self cacheBasePath];
    path = [path stringByAppendingPathComponent:cacheFileName];
    return path;
}
- (NSString *)appVersion
{
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *appVersion = [infoDic objectForKey:@"CFBundleShortVersionString"];
    NSString *buildVersion = [infoDic objectForKey:@"CFBundleVersion"];
    return [NSString stringWithFormat:@"%@%@", appVersion, buildVersion];
}
@end
