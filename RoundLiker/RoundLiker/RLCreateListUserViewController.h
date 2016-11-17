//
//  RLCreateListUserViewController.h
//  RoundLiker
//
//  Created by Hoang Phuong on 11/11/16.
//  Copyright © 2016 Palmsoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RLCreateListUserProtocol <NSObject>

- (void)createUserListWithData:(NSArray *)users;

@end

@interface RLCreateListUserViewController : UIViewController

@property (nonatomic, weak) id<RLCreateListUserProtocol> delegate;

@end
