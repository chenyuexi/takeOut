//  Created by Oleg on 9/29/15.
//  Copyright © 2015 Oleg Hnidets. All rights reserved.
//

@import Foundation;
#import <mysql.h>

@interface OHMySQLSerialization : NSObject

/**
 *  Serialize C string into an object. Takes into account default value of a field.
 *
 *  @param cString C array of bytes.
 *  @param field Representation of one row of data.
 *
 *  @return Object of NSString or NSSNumber classes, or [NSNull null] if cannot serialize.
 */
+ (nonnull id)objectFromCString:(nullable const char *)cString field:(nonnull MYSQL_FIELD *)field;

@end
