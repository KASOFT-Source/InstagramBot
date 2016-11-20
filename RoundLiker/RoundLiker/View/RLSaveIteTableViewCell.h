//
//  RLUserListTableViewCell.h
//  RoundLiker
//
//  Created by Hoang Phuong on 11/11/16.
//  Copyright © 2016 Palmsoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RLSaveIteTableViewCellProtocol <NSObject>

- (void)saveButtonClick:(NSIndexPath *)indexPath;

@end

@interface RLSaveIteTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;

@property (nonatomic, strong) NSIndexPath *indexPath;

@property (weak, nonatomic) id<RLSaveIteTableViewCellProtocol> delegate;;

@end
