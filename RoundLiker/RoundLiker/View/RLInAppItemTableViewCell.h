//
//  RLInAppItemTableViewCell.h
//  RoundLiker
//
//  Created by Hoang Phuong on 11/11/16.
//  Copyright © 2016 Palmsoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RLInAppItemTableViewCellProtocol <NSObject>

- (void)buyButtonClick:(NSIndexPath *)indexPath;

@end


@interface RLInAppItemTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UIButton *buyButton;

@property (nonatomic, strong) NSIndexPath *indexPath;

@property (weak, nonatomic) id<RLInAppItemTableViewCellProtocol> delegate;


@end

