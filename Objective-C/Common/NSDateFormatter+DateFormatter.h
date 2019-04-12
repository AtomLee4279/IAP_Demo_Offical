/*
See LICENSE folder for this sample’s licensing information.

Abstract:
Creates a category for the NSDateFormatter class.
*/

@import Foundation;

@interface NSDateFormatter (DateFormatter)
/// - returns: A date formatter with short time and date style.
+(NSDateFormatter *)shortStyle;

/// - returns: A date formatter with long time and date style.
+(NSDateFormatter *)longStyle;
@end
