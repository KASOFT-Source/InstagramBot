//
//  RLUser.h
//  RoundLiker
//
//  Created by Prescott on 11/15/16.
//  Copyright © 2016 Neuron. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RLUser : NSObject

@property (nonatomic, strong) NSString *userName;
@property (nonatomic) BOOL like;
@property (nonatomic) BOOL invalid;

@end
