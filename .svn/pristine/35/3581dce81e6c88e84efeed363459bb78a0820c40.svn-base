#import "UIImage+WebCache.h"
#import "PubFunction.h"

@implementation UIImage(UIImage_WebCache)

#define kWebCachePath @"Documents/cache"

+ (void)saveToWebCache:(NSString *)remoteUrl {
	[UIImage imageWithWebCache:remoteUrl];
}

+ (UIImage*)imageWithWebCache:(NSString *)remoteUrl {
    if ([remoteUrl isEqualToString:@""])
        return nil;
    
    NSString *filename = [UIImage localFileInWebCache:remoteUrl];
	if (![[NSFileManager defaultManager] fileExistsAtPath:filename]) {
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:remoteUrl]];
		[data writeToFile:filename atomically:YES];
        UIImage *image = [UIImage imageWithData: data];
        return image;
	} else {
		return [UIImage imageWithContentsOfFile:filename];
	}
}

+ (NSString*)localFileInWebCache:(NSString *)remoteUrl {
    if ([remoteUrl isEqualToString:@""])
        return nil;
	NSString *pngPath = [NSHomeDirectory() stringByAppendingPathComponent: kWebCachePath];
	NSFileManager *fileManager = [NSFileManager defaultManager];
	if (![fileManager fileExistsAtPath:pngPath]) {
		if ( ![fileManager createDirectoryAtPath:pngPath withIntermediateDirectories:YES attributes:nil error:nil] )
        {
            NSLog(@"Failed to creating cache folder.");
        }
	}
    
    NSString *filename = [NSString stringWithFormat:@"%@/%@.png", pngPath, [PubFunction getMd5Value: remoteUrl]];
    return filename;
}

@end
