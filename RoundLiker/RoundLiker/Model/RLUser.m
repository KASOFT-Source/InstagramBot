//
//  RLUser.m
//  RoundLiker
//
//  Created by Prescott on 11/15/16.
//  Copyright © 2016 Neuron. All rights reserved.
//

#import "RLUser.h"

@implementation RLUser

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        _userName = [aDecoder decodeObjectForKey:@"userName"];
        _userId = [aDecoder decodeObjectForKey:@"userId"];
    }
    return self;
}

// encode object with coder.
- (void)encodeWithCoder: (NSCoder *)aCoder
{
    [aCoder encodeObject:self.userName forKey:@"userName"];
    [aCoder encodeObject:self.userId forKey:@"userId"];
}
@end
