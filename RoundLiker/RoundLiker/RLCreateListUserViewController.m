//
//  RLCreateListUserViewController.m
//  RoundLiker
//
//  Created by Hoang Phuong on 11/11/16.
//  Copyright © 2016 Palmsoft. All rights reserved.
//

#import "RLCreateListUserViewController.h"
#import "AppDelegate.h"
#import "RLUser.h"

#define PLACE_HOLDER_TEXT @"Enter user accounts here ..."
@interface RLCreateListUserViewController () <UITextViewDelegate>

@property(weak,nonatomic) IBOutlet UITextView *textView;
@property(weak,nonatomic) IBOutlet UIButton *createButton;

- (IBAction)backButtonClick:(id)sender;
- (IBAction)createButtonClick:(id)sender;

@end

@implementation RLCreateListUserViewController

#pragma mark Initalize and Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if ([self.textView.text isEqualToString:PLACE_HOLDER_TEXT]) {
        self.textView.textColor = [UIColor lightGrayColor];
        
        self.createButton.enabled = NO;
        self.createButton.alpha = 0.6;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark: UITextViewDelegate
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:PLACE_HOLDER_TEXT]) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor]; //optional
    }
    [textView becomeFirstResponder];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@""]) {
        textView.text = PLACE_HOLDER_TEXT;
        textView.textColor = [UIColor lightGrayColor]; //optional
    }
    [textView resignFirstResponder];
}

- (void)textViewDidChange:(UITextView *)textView;
{
    if (textView.text.length > 0) {
        self.createButton.enabled = YES;
        self.createButton.alpha = 1;

    }
    else {
        self.createButton.enabled = NO;
        self.createButton.alpha = 0.6;
    }
}

- (IBAction)backButtonClick:(id)sender;
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)createButtonClick:(id)sender;
{
    NSString *str = [self.textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    NSArray *tempList = [str componentsSeparatedByString:@","];
    NSMutableArray *userList = [[NSMutableArray alloc] init];
    
    for (NSString *userName in tempList) {
        RLUser *user = [[RLUser alloc] init];
        user.userName = userName;
        [userList addObject:user];
    }
    
    // TODO: load the user list back to home page
    if ([self.delegate respondsToSelector:@selector(createUserListWithData:)]) {
        
        // TODO: slipt the input string to get all user.
        [self.delegate createUserListWithData:userList];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


@end
