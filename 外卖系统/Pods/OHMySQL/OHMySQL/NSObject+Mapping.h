//  Created by Oleg on 10/31/15.
//  Copyright © 2015 Oleg Hnidets. All rights reserved.
//

@import Foundation;
#import "OHConstants.h"

@interface NSObject (Mapping)

- (OHResultErrorType)insert;
- (OHResultErrorType)update;
- (OHResultErrorType)updateWithCondition:(nonnull NSString *)condition;
- (OHResultErrorType)deleteObject;
- (void)mapFromResponse:(nonnull NSDictionary *)response;

@end
