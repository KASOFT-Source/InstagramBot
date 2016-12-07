//
//  RLInAppItemsViewController.h
//  RoundLiker
//
//  Created by Hoang Phuong on 11/11/16.
//  Copyright © 2016 Palmsoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RLInAppItemsViewControllerProfocol <NSObject>

- (void)buyItemSuccessed;

@end

@interface RLInAppItemsViewController : UIViewController

@property (weak, nonatomic) id<RLInAppItemsViewControllerProfocol> delegate;

@end
