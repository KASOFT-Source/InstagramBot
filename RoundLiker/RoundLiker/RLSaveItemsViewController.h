//
//  RLSaveItemsViewController.h
//  RoundLiker
//
//  Created by Hoang Phuong on 11/11/16.
//  Copyright © 2016 Palmsoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RLSaveItemsDelegate <NSObject>

- (void)loadUserWithData:(NSArray *)users;

@end

@interface RLSaveItemsViewController : UIViewController

@property (nonatomic, strong) NSArray *userList;
@property (nonatomic) BOOL save;
@property (nonatomic, weak) id<RLSaveItemsDelegate> delegate;

@end
