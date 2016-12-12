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
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenKeyboard)]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)hiddenKeyboard;
{
    [self.textView resignFirstResponder];
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
    
    if ([self checkLimitAccount: userList] == true) {
    
        // TODO: load the user list back to home page
        if ([self.delegate respondsToSelector:@selector(createUserListWithData:)]) {
            
            // TODO: slipt the input string to get all user.
            [self.delegate createUserListWithData:userList];
        }
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark RLCreateListUserProtocol
- (BOOL)checkLimitAccount:(NSArray *)users;
{
    int limitNumber = 1;
    switch (self.package) {
        case RLPackageTypeFree:
            break;
        case RLPackageType1:
            limitNumber = 5;
            break;
        case RLPackageType2:
            limitNumber = 10;
            break;
        case RLPackageType3:
            limitNumber = 15;
            break;
        case RLPackageType4:
            limitNumber = 10000;
            break;
        default:
            break;
    }
    
    if (users.count > limitNumber) {
        
        [self showLimitMessage:limitNumber];
        return false;
    }
    
    return true;
}

- (void)showLimitMessage: (int)limitNumber;
{
    NSString *msg = [NSString stringWithFormat:@"Current package just allow %d account. Please upgrade for more user", limitNumber];
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Warning"
                                                                   message:msg
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"OK"
                                                     style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction * action) {
                                                       
                                                       [alert dismissViewControllerAnimated:YES completion:nil];
                                                   }];
    
    [alert addAction:cancel];
    
    [self presentViewController:alert animated:YES completion:nil];

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
