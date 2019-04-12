/*
See LICENSE folder for this sample’s licensing information.

Abstract:
Creates a category for the SKDownload class.
*/

@import StoreKit;

@interface SKDownload (SKDownloadAdditions)
/// - returns: A string representation of the downloadable content length.
-(NSString *)downloadContentSize;
@end
