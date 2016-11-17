//
//  RLInstagramMedia.m
//  RoundLiker
//
//  Created by Prescott on 11/15/16.
//  Copyright © 2016 Neuron. All rights reserved.
//

#import "RLInstagramMedia.h"

@implementation RLInstagramMedia

/*
 {
 "comments": {
 "count": 0
 },
 "caption": {
 "created_time": "1296710352",
 "text": "Inside le truc #foodtruck",
 "from": {
 "username": "kevin",
 "full_name": "Kevin Systrom",
 "type": "user",
 "id": "3"
 },
 "id": "26621408"
 },
 "likes": {
 "count": 15
 },
 "link": "http://instagr.am/p/BWrVZ/",
 "user": {
 "username": "kevin",
 "profile_picture": "http://distillery.s3.amazonaws.com/profiles/profile_3_75sq_1295574122.jpg",
 "id": "3"
 },
 "created_time": "1296710327",
 "images": {
 "low_resolution": {
 "url": "http://distillery.s3.amazonaws.com/media/2011/02/02/6ea7baea55774c5e81e7e3e1f6e791a7_6.jpg",
 "width": 306,
 "height": 306
 },
 "thumbnail": {
 "url": "http://distillery.s3.amazonaws.com/media/2011/02/02/6ea7baea55774c5e81e7e3e1f6e791a7_5.jpg",
 "width": 150,
 "height": 150
 },
 "standard_resolution": {
 "url": "http://distillery.s3.amazonaws.com/media/2011/02/02/6ea7baea55774c5e81e7e3e1f6e791a7_7.jpg",
 "width": 612,
 "height": 612
 }
 },
 "type": "image",
 "users_in_photo": [],
 "filter": "Earlybird",
 "tags": ["foodtruck"],
 "id": "22721881",
 "location": {
 "latitude": 37.778720183610183,
 "longitude": -122.3962783813477,
 "id": "520640",
 "street_address": "",
 "name": "Le Truc"
 }
 */

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
