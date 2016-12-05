//
//  RLHomeViewController.m
//  RoundLiker
//
//  Created by Hoang Phuong on 11/11/16.
//  Copyright © 2016 Palmsoft. All rights reserved.
//

#import "RLHomeViewController.h"
#import "RLLoginViewController.h"
#import "RLUserListTableViewCell.h"
#import "RLViewerTableViewCell.h"
#import "RLCreateListUserViewController.h"
#import "RLUser.h"
#import "RLInstagramMedia.h"
#import "RLSaveItemsViewController.h"
#import "RMStore.h"

#define RGB(r, g, b, a) \
[UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:a]
#define kTIMEINTERVAL 2
#define kLIKEPHOTOS 2
#define kMAXLIKEPHOTOS 5

@interface RLHomeViewController () <RLLoginProtocol, RLCreateListUserProtocol,UITableViewDelegate, UITableViewDataSource, RLSaveItemsDelegate>

#pragma mark Properties

@property (weak, nonatomic) IBOutlet UIButton *packageButton;
@property (weak, nonatomic) IBOutlet UIButton *upgradeButton;
@property (weak, nonatomic) IBOutlet UILabel *userListLabel;
@property (weak, nonatomic) IBOutlet UITableView *usersTableView;
@property (weak, nonatomic) IBOutlet UITableView *viewerTableView;
@property (weak, nonatomic) IBOutlet UIButton *saveUsersButton;
@property (weak, nonatomic) IBOutlet UIButton *loadUsersButton;
@property (weak, nonatomic) IBOutlet UIButton *loopButton;

@property (weak, nonatomic) IBOutlet UILabel *instegramViewerNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *intervalLabel;
@property (weak, nonatomic) IBOutlet UILabel *likePhotosLabel;
@property (weak, nonatomic) IBOutlet UIButton *subIntervalButton;
@property (weak, nonatomic) IBOutlet UIButton *addIntervalButton;
@property (weak, nonatomic) IBOutlet UIButton *subLikePhotosButton;
@property (weak, nonatomic) IBOutlet UIButton *addLikePhotosButton;
@property (weak, nonatomic) IBOutlet UIButton *startButton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@property (nonatomic, strong) NSString *authToken;

@property (nonatomic, strong) NSArray *userList;

@property (nonatomic, strong) NSArray *mediaList;
@property (nonatomic, strong) NSMutableDictionary *mediaDictionary;
@property (nonatomic) NSUInteger currentUserId;

@property (nonatomic) NSUInteger timeInterval;
@property (nonatomic) NSUInteger likePhotoNumber;
@property (nonatomic) NSInteger processingPosition;

@property (nonatomic) BOOL stopProcessing;

@property (nonatomic) RLPackageType package;

#pragma mark IBAction
- (IBAction)inforButtonClick:(id)sender;
- (IBAction)powerButtonClick:(id)sender;
- (IBAction)upgradeButtonClick:(id)sender;
- (IBAction)saveUsersButtonClick:(id)sender;
- (IBAction)loadUsersButtonClick:(id)sender;
- (IBAction)subIntervalButtonClick:(id)sender;
- (IBAction)addIntervalButtonClick:(id)sender;
- (IBAction)subLikePhotosButtonClick:(id)sender;
- (IBAction)addLikePhotosButtonClick:(id)sender;
- (IBAction)startButtonClick:(id)sender;

@end

@implementation RLHomeViewController

- (void)viewDidLoad {

    [super viewDidLoad];

    [self loadDefaultSettingValue];
    
    [self updateUI];
    
    // Do any additional setup after loading the view, typically from a nib.
    if (self.authToken || self.authToken.length == 0) {
        [self showLoginViewController];
    }

    self.viewerTableView.estimatedRowHeight = 188;
    self.viewerTableView.rowHeight = UITableViewAutomaticDimension;
    
    self.mediaDictionary = [[NSMutableDictionary alloc] init];
    
    self.package = RLPackageType1;
    self.processingPosition = -1;
    
    [self restoreTransaction];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [UIView animateWithDuration:0.25 animations:^{
        self.view.alpha = 1.0;
    }];
    
    [self loadPurchasePackage];
    
    [self checkButtonStatus];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark: IAP Part
- (void)restoreTransaction;
{
    // Restore the transaction for checking buoght items.
    [[RMStore defaultStore] restoreTransactionsOnSuccess:^(NSArray *transactions){
        NSLog(@"Transactions restored");
    } failure:^(NSError *error) {
        NSLog(@"Something went wrong");
    }];
}

#pragma mark: Load default setting.
- (void)loadDefaultSettingValue;
{
    self.timeInterval = kTIMEINTERVAL;
    self.likePhotoNumber = kLIKEPHOTOS;
}

- (void)loadPurchasePackage;
{
    switch (self.package) {
        case RLPackageTypeFree:
        {
            self.userListLabel.text = @"User List (Allow 1)";
            [self.packageButton setTitle:@"FREE" forState:UIControlStateNormal];
        }
            break;
        case RLPackageType1:
        {
            self.userListLabel.text = @"User List (Allow 5)";
            [self.packageButton setTitle:@"PACKAGE 1: 23 days left" forState:UIControlStateNormal];
            [self.packageButton setImage:nil forState:UIControlStateNormal];
        }
            break;
        case RLPackageType2:
        {
            self.userListLabel.text = @"User List (Allow 10)";
            [self.packageButton setTitle:@"PACKAGE 2: 23 days left" forState:UIControlStateNormal];
            [self.packageButton setImage:nil forState:UIControlStateNormal];

        }
            break;
        case RLPackageType3:
        {
            self.userListLabel.text = @"User List (Allow 15)";
            [self.packageButton setTitle:@"PACKAGE 3: 23 days left" forState:UIControlStateNormal];
            [self.packageButton setImage:nil forState:UIControlStateNormal];

        }
            break;
        case RLPackageType4:
        {
            self.userListLabel.text = @"User List (Unlimited)";
            [self.packageButton setTitle:@"PACKAGE 4: 23 days left" forState:UIControlStateNormal];
            [self.packageButton setImage:nil forState:UIControlStateNormal];

        }
            break;
            
        default:
            break;
    }
    
    // TODO: Load data from Apple server
}

- (void)updateUI;
{
    self.intervalLabel.layer.borderColor = RGB(71, 87, 103, 1).CGColor;
    self.intervalLabel.layer.borderColor = RGB(71, 87, 103, 1).CGColor;
}

- (void)showLoginViewController;
{
    if (self.authToken == nil) {
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        RLLoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginView"];
        loginViewController.delegate = self;
        
        [self presentViewController:loginViewController animated:YES completion:^{}];
    }
}


#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.usersTableView) {
        return self.userList.count + 1;
    }
    else {
        return self.mediaList.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.usersTableView) {

        if (indexPath.row == 0) {
            
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CreatNewListCell"];
            return cell;
        }
        else {
            RLUserListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UserListTableViewCell"];
            
            RLUser *user = self.userList[indexPath.row - 1];
            
            cell.nameLabel.text = user.userName;
            if (indexPath.row == self.processingPosition + 1) {
                cell.contentView.backgroundColor = RGB(71, 87, 103, 1);
            }
            else {
                cell.contentView.backgroundColor = RGB(42, 56, 69, 1);
            }
            
            if (user.like == YES) {
                cell.selectedIcon.hidden = NO;
                cell.selectedIcon.image = [UIImage imageNamed:@"icon_check"];
                cell.nameLabel.textColor = RGB(168, 187, 188, 1);

            }
            else if (user.invalid == YES) {
                cell.selectedIcon.hidden = NO;
                cell.selectedIcon.image = [UIImage imageNamed:@"icon_fail"];
                cell.nameLabel.textColor = [UIColor redColor];
            }
            else {
                cell.selectedIcon.hidden = YES;
                cell.nameLabel.textColor = RGB(168, 187, 188, 1);
            }
            return cell;
        }
    }
    else {
        
        RLViewerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ViewerTableViewCell"];
        RLInstagramMedia *media = [self.mediaList objectAtIndex:indexPath.row];
        cell.media = media;
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    // Select the header: show/hide all item in section.
    if (tableView == self.usersTableView) {
        
        if (indexPath.row == 0) {
            
            // Show new use list
            // Do nothing here
        }
        else {
            
            NSMutableArray *reloadArray = [[NSMutableArray alloc] initWithObjects:indexPath, nil];

            if (self.processingPosition != -1) {
                NSIndexPath* indexPath = [NSIndexPath indexPathForRow:self.processingPosition + 1 inSection:0];
                [reloadArray addObject:indexPath];
            }

            self.processingPosition = indexPath.row - 1;

            [self.usersTableView reloadRowsAtIndexPaths:reloadArray withRowAnimation:UITableViewRowAnimationNone];

            // Get the account of user
            RLUser *user = self.userList[indexPath.row - 1];
            
            // If user is not exist
            if (user.invalid == YES) {

                // Show incorrect user
                self.instegramViewerNameLabel.text = @"Incorrect user";
                self.mediaList = nil;
                [self.viewerTableView reloadData];
                return;
            }
            
            // Case we load user data already.
            if (user.userId && user.userId.length > 0) {
                
                // Get the media list of user.
                if ([self.mediaDictionary valueForKey:user.userId]) {
                    
                    self.instegramViewerNameLabel.text = user.userName;

                    NSArray *mediaArray = [self.mediaDictionary objectForKey:user.userId];
                    self.mediaList = mediaArray;
                    
                    // Reload viewer table with data
                    [self.viewerTableView reloadData];
                }
                else {
                    
                    // Load the user data.
                    self.instegramViewerNameLabel.text = user.userName;
                    
                    // Get the media user list
                    NSArray *mediaArray = [self getMediaOfUserWithId:user.userId];
                    
                    // Save the media of all user (use for case use click in the list to show status again)
                    [self.mediaDictionary setValue:mediaArray forKey:user.userId];

                    self.mediaList = mediaArray;
                    
                    // Reload viewer table with data
                    [self.viewerTableView reloadData];
                }
            }
            else {
                
                // Load user id and user media.
                
                // Show Instagram page of user.
                NSString *userId = [self getUserIdWithName: user.userName];
                
                if (userId) {
                    
                    user.userId = userId;
                    self.instegramViewerNameLabel.text = user.userName;
                    
                    // Get the media user list
                    NSArray *mediaArray = [self getMediaOfUserWithId:userId];
                    
                    // Save the media of all user (use for case use click in the list to show status again)
                    [self.mediaDictionary setValue:mediaArray forKey:user.userId];

                    self.mediaList = mediaArray;
                    
                    // Reload viewer table with data
                    [self.viewerTableView reloadData];
                }
                else {
                    
                    self.instegramViewerNameLabel.text = @"Incorrect user";
                    user.invalid = YES;
                    self.mediaList = nil;
                    [self.viewerTableView reloadData];
                    [self.usersTableView reloadData];
                }

            }
        }
    }
    else {
        
        // Viewer table view
        // Show the detail of instagram item.
    }
}

- (void)likeUserAtPosition:(NSUInteger)position
{
    
    RLUser *user = self.userList[position];
    
    // Show Instagram page of user.
    NSString *userId = [self getUserIdWithName: user.userName];
    self.processingPosition = position;

    if (userId) {

        // Save the user id in user.
        user.userId = userId;
        
        // Get the media user list
        NSArray *mediaArray = [self getMediaOfUserWithId:userId];
        
        // Save the media of all user (use for case use click in the list to show status again)

        self.mediaList = mediaArray;

        dispatch_async(dispatch_get_main_queue(), ^{
            // Reload viewer table with data
            
            self.instegramViewerNameLabel.text = user.userName;

            [self.viewerTableView reloadData];
            [self.usersTableView reloadData];
        });

        for (int i = 0; i < MIN(self.likePhotoNumber, self.mediaList.count); i++) {
            
            RLInstagramMedia *media = [self.mediaList objectAtIndex: i];
            
            RLRequestStatus result = [self likeMediaId:media.mediaId];
            
            // Update status of the viewer
            if (result == RLRequestStatusSuccess) {
                media.likeStatus = RLLikeStatusDone;
            }
            else {
                media.likeStatus = RLLikeStatusFail;
                
                if (result == RLRequestStatusFailByLimited) {
                    
                    self.stopProcessing = YES;

                    // Stop all things and show message alert user back in next hour.
                    
                    [self showLimitedRequestMessage];
                    break;
                }
            }
            
            if (i == MAX(self.likePhotoNumber, self.mediaList.count) - 1) {
                user.like = YES;
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.viewerTableView reloadData];
            });

            [NSThread sleepForTimeInterval:self.timeInterval];
        }
        
        [self.mediaDictionary setValue:self.mediaList forKey:user.userId];

    }
    else {
        
        user.invalid = YES;
        self.mediaList = nil;

        dispatch_async(dispatch_get_main_queue(), ^{
            self.instegramViewerNameLabel.text = @"Un-correct user";
            
            [self.viewerTableView reloadData];
            [self.usersTableView reloadData];
        });
    }
    

}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"CreateNewListSegue"]) {
        RLCreateListUserViewController *controller = (RLCreateListUserViewController *)segue.destinationViewController;
        controller.delegate = self;
    }
    else if ([segue.identifier isEqualToString:@"SaveListSegue"]) {
        
        RLSaveItemsViewController *controller = (RLSaveItemsViewController *)segue.destinationViewController;
        if ((UIButton *)sender == self.saveUsersButton) {
            controller.save = YES;
            controller.userList = self.userList;
        }
        else {
            controller.save = NO;
            controller.delegate = self;

        }
    }
}


#pragma mark IBAction implement
- (IBAction)inforButtonClick:(id)sender {
    // TODO: show the webview with content
    
}

- (IBAction)powerButtonClick:(id)sender {
    
    // Show the confirm message remove product
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Message"
                                                                   message:@"Are you sure you want to logout?"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK"
                                                 style:UIAlertActionStyleDefault
                                               handler:^(UIAlertAction * action) {
                                                   
                                                   [alert dismissViewControllerAnimated:YES completion:nil];

                                                   // Logout
                                                   // Remove cookie of instagram.
                                                   NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
                                                   for (NSHTTPCookie *cookie in cookieStorage.cookies) {
                                                       if ([cookie.domain isEqualToString:@"www.instagram.com"] ||
                                                           [cookie.domain isEqualToString:@"api.instagram.com"]){
                                                           [cookieStorage deleteCookie:cookie];
                                                       }
                                                   }
                                                   
                                                   self.authToken = nil;
                                                   
                                                   // Show login page again.
                                                   [self showLoginViewController];

                                                   
                                               }];
    
    [alert addAction:ok];

    UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"Cancel"
                                                 style:UIAlertActionStyleDefault
                                               handler:^(UIAlertAction * action) {
                                                   
                                                   [alert dismissViewControllerAnimated:YES completion:nil];
                                                   
                                               }];
    
    [alert addAction:cancel];

    [self presentViewController:alert animated:YES completion:nil];
    
}

- (IBAction)upgradeButtonClick:(id)sender {
}

- (IBAction)saveUsersButtonClick:(id)sender {
    [self performSegueWithIdentifier:@"SaveListSegue" sender:sender];
}

- (IBAction)loadUsersButtonClick:(id)sender {
    [self performSegueWithIdentifier:@"SaveListSegue" sender:sender];
}

#pragma mark RLCreateListUserProtocol
- (void)createUserListWithData:(NSArray *)users;
{
    [self loadUserWithData:users];
}

#pragma mark RLSaveItemsDelegate
- (void)loadUserWithData:(NSArray *)users;
{
    self.userList = users;
    [self.usersTableView reloadData];
    
    [self checkButtonStatus];
}

- (void)checkButtonStatus
{
    
    if (self.userList && self.userList.count > 0) {
        
        self.startButton.enabled = YES;
        self.saveUsersButton.enabled = YES;
        
        self.startButton.alpha = 1;
        self.saveUsersButton.alpha = 1;

    }
    else {
        self.startButton.enabled = NO;
        self.saveUsersButton.enabled = NO;
        
        self.startButton.alpha = 0.6;
        self.saveUsersButton.alpha = 0.6;
        
    }
}

#pragma mark IBAction

- (IBAction)subIntervalButtonClick:(id)sender {

    self.timeInterval -= 1;

    if (self.timeInterval == 1) {
        self.subIntervalButton.enabled = NO;
    }
    
    self.intervalLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)self.timeInterval];
}

- (IBAction)addIntervalButtonClick:(id)sender {

    self.timeInterval += 1;
    
    if (self.subIntervalButton.enabled == NO) {
        self.subIntervalButton.enabled = YES;
    }
    
    self.intervalLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)self.timeInterval];

}

- (IBAction)subLikePhotosButtonClick:(id)sender {
    
    self.likePhotoNumber -= 1;
    
    if (self.likePhotoNumber == 1) {
        self.subLikePhotosButton.enabled = NO;
    }
    
    if (self.addLikePhotosButton.enabled == NO) {
        self.addLikePhotosButton.enabled = YES;
    }

    self.likePhotosLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)self.likePhotoNumber];

}

- (IBAction)addLikePhotosButtonClick:(id)sender {
    
    self.likePhotoNumber += 1;
    
    if (self.likePhotoNumber == kMAXLIKEPHOTOS) {
        self.addLikePhotosButton.enabled = NO;
    }
    
    if (self.subLikePhotosButton.enabled == NO) {
        self.subLikePhotosButton.enabled = YES;
    }
    
    self.likePhotosLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)self.likePhotoNumber];
}

- (IBAction)startButtonClick:(id)sender {
    
    // TODO: start check like for all account.
    // When finish -> show the finish message.
    
    // Clean all data when press like button.
    
    
    UIButton *button = (UIButton *)sender;
    if ([button.titleLabel.text isEqualToString:@"START"]) {
        
        self.stopProcessing = NO;
        [self.mediaDictionary removeAllObjects];

        [button setTitle:@"STOP" forState:UIControlStateNormal];
        
        // Don't allow user do in the table until it done.
        self.usersTableView.userInteractionEnabled = NO;
        [self.activityIndicator startAnimating];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            for (int i = 0; i < self.userList.count; i++) {
                [self likeUserAtPosition:i];
                
                if (self.stopProcessing == YES) {
                    return;
                }
            }

            [self showDoneMessage];
        });
    }
    else {
        
        self.usersTableView.userInteractionEnabled = YES;
        [self.activityIndicator stopAnimating];

        self.stopProcessing = YES;

        [button setTitle:@"START" forState:UIControlStateNormal];
    }
}

- (void)showDoneMessage;
{

    dispatch_async(dispatch_get_main_queue(), ^{
        // Reload viewer table with data
        // Show Done message
        
        self.usersTableView.userInteractionEnabled = YES;
        [self.activityIndicator stopAnimating];

        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Message"
                                                                       message:@"Done"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"OK"
                                                         style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction * action) {
                                                           
                                                           [alert dismissViewControllerAnimated:YES completion:nil];
                                                           [self.startButton setTitle:@"START" forState:UIControlStateNormal];

                                                       }];
        
        [alert addAction:cancel];
        
        [self presentViewController:alert animated:YES completion:nil];
    });
}

- (void)showLimitedRequestMessage;
{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        // Reload viewer table with data
        // Show Done message
        
        self.usersTableView.userInteractionEnabled = YES;
        [self.activityIndicator stopAnimating];
        
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Warning"
                                                                       message:@"You met the limit likes in hour. Please get back after one hour"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"OK"
                                                         style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction * action) {
                                                           
                                                           [alert dismissViewControllerAnimated:YES completion:nil];
                                                           [self.startButton setTitle:@"START" forState:UIControlStateNormal];
                                                           
                                                       }];
        
        [alert addAction:cancel];
        
        [self presentViewController:alert animated:YES completion:nil];
    });
}


#pragma mark RLLoginProtocol
- (void)loginFishedWithToken:(NSString *)token;
{
    [self dismissViewControllerAnimated:YES completion:nil];
    self.authToken = token;
}

#pragma mark: Instagram part.
-(NSString *)getUserIdWithName: (NSString *)name{
    
    NSString *strURL = [NSString stringWithFormat:@"https://api.instagram.com/v1/users/search?q=%@&access_token=%@", name,self.authToken];
    
    NSMutableURLRequest *requestData = [NSMutableURLRequest requestWithURL:
                                        [NSURL URLWithString:strURL]];
    [requestData setHTTPMethod:@"GET"];
    
    NSURLResponse *response = NULL;
    NSError *requestError = NULL;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:requestData returningResponse:&response error:&requestError];
    if (responseData) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
        
        if ([dict objectForKey:@"data"] && [dict objectForKey:@"data"] != [NSNull null]) {
            
            NSArray *array = (NSArray *)[dict objectForKey:@"data"];
            if ([array isKindOfClass:[NSArray class]] && array.count > 0) {
                NSDictionary *dataDict = (NSDictionary *)array[0];
                if ([dataDict isKindOfClass:[NSDictionary class]]) {
                    if ([dataDict objectForKey:@"id"]) {
                        NSString *userId = [dataDict objectForKey:@"id"];
                        if (userId && userId.length > 0) {
                            return userId;
                        }
                    }
                }
            }
        }

    }
    return nil;
}


-(NSArray *)getMediaOfUserWithId:(NSString *)userId{
    
    NSString *strURL = [NSString stringWithFormat:@"https://api.instagram.com/v1/users/%@/media/recent/?access_token=%@", userId,self.authToken];
    
    NSMutableURLRequest *requestData = [NSMutableURLRequest requestWithURL:
                                        [NSURL URLWithString:strURL]];
    [requestData setHTTPMethod:@"GET"];
    
    NSURLResponse *response = NULL;
    NSError *requestError = NULL;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:requestData returningResponse:&response error:&requestError];
    if (responseData) {
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
        if ([dict objectForKey:@"data"] && [dict objectForKey:@"data"] != [NSNull null]) {
            
            NSArray *array = (NSArray *)[dict objectForKey:@"data"];
            if ([array isKindOfClass:[NSArray class]] && array.count > 0) {
                
                NSMutableArray *mediaArray = [[NSMutableArray alloc] init];
                
                for (int i = 0; i < array.count; i++) {
                    
                    NSDictionary *dataDict = array[i];
                    RLInstagramMedia *media = [[RLInstagramMedia alloc] initWithJson: dataDict];
                    [mediaArray addObject:media];
                }
                
                NSArray *result  = [NSArray arrayWithArray:mediaArray];
                
                return result;
            }
        }
    }
    return nil;
}

- (RLRequestStatus)likeMediaId:(NSString *)mediaId{
    
    NSString *strURL = [NSString stringWithFormat:@"https://api.instagram.com/v1/media/%@/likes", mediaId];
    
    NSMutableURLRequest *requestData = [NSMutableURLRequest requestWithURL:
                                        [NSURL URLWithString:strURL]];
    [requestData setHTTPMethod:@"POST"];
    NSString *post = [NSString stringWithFormat:@"access_token=%@", self.authToken];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    [requestData setHTTPBody:postData];
    
    NSURLResponse *response = NULL;
    NSError *requestError = NULL;
    
    // Just like and don't care about the resul.
    [NSURLConnection sendSynchronousRequest:requestData returningResponse:&response error:&requestError];
    
    NSData *responseData = [NSURLConnection sendSynchronousRequest:requestData returningResponse:&response error:&requestError];
    if (responseData) {
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
        
        NSLog(@"Response: %@", dict);
        if ([dict objectForKey:@"data"] && [dict objectForKey:@"data"] != [NSNull null]) {
            return RLRequestStatusSuccess;
        }
        else {
            if ([dict objectForKey:@"meta"]) {
                NSDictionary *metaDict = [dict objectForKey:@"meta"];
                
                if ([metaDict objectForKey:@"code"]) {
                    NSUInteger code = [[metaDict objectForKey:@"code"] integerValue];
                    if (code == 429) {
                        // Request limited value.
                        return RLRequestStatusFailByLimited;
                    }
                }
            }
        }
    }
    return RLRequestStatusFail;
    
}

- (BOOL)getLikeStatusOfMediaId:(NSString *)mediaId{
    
    NSString *strURL = [NSString stringWithFormat:@"https://api.instagram.com/v1/media/%@/likes", mediaId];
    
    NSMutableURLRequest *requestData = [NSMutableURLRequest requestWithURL:
                                        [NSURL URLWithString:strURL]];
    [requestData setHTTPMethod:@"GET"];
    NSString *post = [NSString stringWithFormat:@"access_token=%@", self.authToken];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    [requestData setHTTPBody:postData];
    
    NSURLResponse *response = NULL;
    NSError *requestError = NULL;
    
    // Just like and don't care about the resul.
    [NSURLConnection sendSynchronousRequest:requestData returningResponse:&response error:&requestError];
    
    NSData *responseData = [NSURLConnection sendSynchronousRequest:requestData returningResponse:&response error:&requestError];
    
    if (responseData) {
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
        
        NSLog(@"Response: %@", dict);
        if ([dict objectForKey:@"data"] && [dict objectForKey:@"data"] == [NSNull null]) {
            
            NSArray *array = (NSArray *)[dict objectForKey:@"data"];
            
            if ([array isKindOfClass:[NSArray class]] && array.count > 0) {
                for (int i = 0; i < array.count; i++) {
                    
                    NSDictionary *dataDict = array[i];
                    if ([dataDict objectForKey:@"id"]) {
                        NSUInteger likeUserId = [[dataDict objectForKey:@"id"] integerValue];
                        if (likeUserId == 1) {
                            return YES;
                        }
                    }
                }
            }
        }
    }
    return NO;
}

@end
