//
//  AppDelegate.h
//  RoundLiker
//
//  Created by user on 11/13/14.
//  Copyright (c) 2014 Palmsoft. All rights reserved.
//

#import <UIKit/UIKit.h>

#define INSTAGRAM_AUTHURL                               @"https://api.instagram.com/oauth/authorize/"
#define INSTAGRAM_APIURl                                @"https://api.instagram.com/v1/users/"
#define INSTAGRAM_CLIENT_ID                             @"87238a67a53b4c0c8fd5b5aff14fd8a3"
#define INSTAGRAM_CLIENTSERCRET                         @"f30a8f18db5d48c2b1702cce5ae078a5"
#define INSTAGRAM_REDIRECT_URI                          @"http://test.likelistbot.com"
#define INSTAGRAM_ACCESS_TOKEN                          @"access_token"
#define INSTAGRAM_SCOPE                                 @"likes+public_content"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;


@end

