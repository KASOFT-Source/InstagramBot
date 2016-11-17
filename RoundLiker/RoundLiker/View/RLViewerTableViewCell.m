//
//  RLViewerTableViewCell.m
//  RoundLiker
//
//  Created by Hoang Phuong on 11/11/16.
//  Copyright © 2016 Palmsoft. All rights reserved.
//

#import "RLViewerTableViewCell.h"
#import "Haneke.h"

@interface RLViewerTableViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *instagramImageView;
@property (weak, nonatomic) IBOutlet UIImageView *likeIcon;

@end


@implementation RLViewerTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setMedia:(RLInstagramMedia *)media {
    
    _media = media;
    
    [self.instagramImageView hnk_setImageFromURL:[NSURL URLWithString:media.imageURL]];

}

@end
