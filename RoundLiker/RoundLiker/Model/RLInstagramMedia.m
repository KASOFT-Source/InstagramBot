//
//  RLInstagramMedia.m
//  RoundLiker
//
//  Created by Prescott on 11/15/16.
//  Copyright © 2016 Neuron. All rights reserved.
//

#import "RLInstagramMedia.h"

@implementation RLInstagramMedia

- (id)initWithJson:(NSDictionary *)dict {
    
    self = [super init];
    
    if (self) {
        
        if ([dict objectForKey:@"id"]) {
            self.mediaId = [dict objectForKey:@"id"];
            
            if ([dict objectForKey:@"type"]) {
                self.type = [dict objectForKey:@"type"];
            }
            
            if ([dict objectForKey:@"caption"]) {
                NSDictionary *captionDict = [dict objectForKey:@"caption"];
                if ([captionDict isKindOfClass:[NSDictionary class]] && [captionDict objectForKey:@"text"]) {
                    self.caption = [captionDict objectForKey:@"text"];
                }
            }

            if ([dict objectForKey:@"likes"]) {
                NSDictionary *likeDict = [dict objectForKey:@"likes"];
                if ([likeDict isKindOfClass:[NSDictionary class]] && [likeDict objectForKey:@"count"]) {
                    self.likeCount = [[likeDict objectForKey:@"count"] integerValue];
                }
            }
            
            if ([dict objectForKey:@"images"]) {
                NSDictionary *imageDict = [dict objectForKey:@"images"];
                
                if ([imageDict isKindOfClass:[NSDictionary class]] && [imageDict objectForKey:@"thumbnail"]) {
                    
                    NSDictionary *thumbnailDict = [imageDict objectForKey:@"thumbnail"];

                    if ([thumbnailDict isKindOfClass:[NSDictionary class]] && [thumbnailDict objectForKey:@"url"]) {
                        self.imageURL = [thumbnailDict objectForKey:@"url"];
                    }
                }
            }
        }
    }
    
    return self;
}
@end
