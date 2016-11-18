//
//  RLInstagramMedia.h
//  RoundLiker
//
//  Created by Prescott on 11/15/16.
//  Copyright © 2016 Neuron. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RLEnumeration.h"

@interface RLInstagramMedia : NSObject

@property (nonatomic, strong) NSString *mediaId;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *imageURL;
@property (nonatomic, strong) NSString *caption;
@property (nonatomic) NSUInteger likeCount;
@property (nonatomic) RLLikeStatus likeStatus;

- (id)initWithJson:(NSDictionary *)dict;

@end
