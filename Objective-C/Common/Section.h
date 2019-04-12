/*
See LICENSE folder for this sample’s licensing information.

Abstract:
Model class used to represent a list of products/purchases.
*/

@import Foundation;

@interface Section : NSObject
/// Products/Purchases are organized by category.
@property (nonatomic, copy) NSString *name;

/// List of products/purchases.
@property (strong) NSArray *elements;

/// Create a Section object.
-(instancetype)initWithName:(NSString *)name elements:(NSArray *)elements NS_DESIGNATED_INITIALIZER;
@end
