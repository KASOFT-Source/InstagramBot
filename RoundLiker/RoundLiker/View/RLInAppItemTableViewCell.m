//
//  RLInAppItemTableViewCell.m
//  RoundLiker
//
//  Created by Hoang Phuong on 11/11/16.
//  Copyright © 2016 Palmsoft. All rights reserved.
//

#import "RLInAppItemTableViewCell.h"
@interface RLInAppItemTableViewCell()


- (IBAction)buyButtonClick:(id)sender;

@end


@implementation RLInAppItemTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)buyButtonClick:(id)sender;
{
    // IAP Here.
    
    if ([self.delegate respondsToSelector:@selector(buyButtonClick:)]) {
        [self.delegate buyButtonClick: self.indexPath];
    }
}

@end
