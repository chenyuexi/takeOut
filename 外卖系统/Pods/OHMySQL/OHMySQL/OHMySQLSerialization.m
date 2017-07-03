//  Created by Oleg on 9/29/15.
//  Copyright © 2015 Oleg Hnidets. All rights reserved.
//

#import "OHMySQLSerialization.h"

@implementation OHMySQLSerialization

+ (id)objectFromCString:(const char *)cString field:(MYSQL_FIELD *)field {
    BOOL notNull = field->flags & NOT_NULL_FLAG;
    BOOL isNumber = IS_NUM(field->type);
    
    if (isNumber) {
        NSNumber *number = [OHMySQLSerialization numberFromCString:cString];
        
        if (number) {
            return number;
        } else if (notNull) {
            return [OHMySQLSerialization numberFromCString:field->def_length ? field->def : "0"];
        }
    } else if (notNull) {
        return [NSString stringWithUTF8String:cString ?: (field->def_length ? field->def : "")];
    }
    
    return [NSNull null];
}

+ (NSNumber *)numberFromCString:(const char *)cString {
    NSString *numberString = [NSString stringWithUTF8String:cString];
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    NSNumber *number = [formatter numberFromString:numberString];
    
    return number;
}

@end
