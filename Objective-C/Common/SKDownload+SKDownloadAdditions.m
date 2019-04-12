/*
See LICENSE folder for this sample’s licensing information.

Abstract:
Creates a category for the SKDownload class.
*/

#import "SKDownload+SKDownloadAdditions.h"

@implementation SKDownload (SKDownloadAdditions)
/// - returns: A string representation of the downloadable content length.
-(NSString *)downloadContentSize {
#if TARGET_OS_OSX
	return [NSByteCountFormatter stringFromByteCount:(self.contentLength).longLongValue countStyle:NSByteCountFormatterCountStyleFile];
#else
	return [NSByteCountFormatter stringFromByteCount:self.contentLength countStyle:NSByteCountFormatterCountStyleFile];
#endif
}

@end
