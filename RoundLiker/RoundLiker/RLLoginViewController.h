//
//  RLLoginViewController.h
//  RoundLiker
//
//  Created by Hoang Phuong on 11/11/16.
//  Copyright © 2016 Palmsoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RLLoginProtocol <NSObject>

- (void)loginFishedWithToken:(NSString *)token;

@end

@interface RLLoginViewController : UIViewController<UIWebViewDelegate>

@property (nonatomic, weak) id <RLLoginProtocol> delegate;

@end
