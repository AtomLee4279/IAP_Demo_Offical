/*
See LICENSE folder for this sample’s licensing information.

Abstract:
Model class used to represent a list of products/purchases.
*/


#import "Section.h"

@implementation Section

-(instancetype)init {
	return [self initWithName:nil elements:@[]];
}

-(instancetype)initWithName:(NSString *)name elements:(NSArray *)elements {
	self = [super init];

	if(self != nil) {
		_name = [name copy];
		_elements = elements;
	}
	return self;
}
@end
