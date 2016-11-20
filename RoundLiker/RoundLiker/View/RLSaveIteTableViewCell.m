//
//  RLSaveIteTableViewCell.m
//  RoundLiker
//
//  Created by Hoang Phuong on 11/11/16.
//  Copyright © 2016 Palmsoft. All rights reserved.
//

#import "RLSaveIteTableViewCell.h"
@interface RLSaveIteTableViewCell()
@end

@implementation RLSaveIteTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    
    self.saveButton.hidden = NO;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)saveButtonClick:(id)sender{
    if ([self.delegate respondsToSelector:@selector(saveButtonClick:)]) {
        [self.delegate saveButtonClick: self.indexPath];
    }
}

@end
