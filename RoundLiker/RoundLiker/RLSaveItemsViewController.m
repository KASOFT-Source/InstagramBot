//
//  RLSaveItemsViewController.m
//  RoundLiker
//
//  Created by Hoang Phuong on 11/11/16.
//  Copyright © 2016 Palmsoft. All rights reserved.
//

#import "RLSaveItemsViewController.h"
#import "RLSaveIteTableViewCell.h"
#define FOLDER_SETTING @"Setting"
#define settingFileName @"RLSetting.plist"

@interface RLSaveItemsViewController ()<UITableViewDelegate, UITableViewDataSource, RLSaveIteTableViewCellProtocol>

@property(weak,nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSArray *slot1;
@property (nonatomic, strong) NSArray *slot2;
@property (nonatomic, strong) NSArray *slot3;
@property (nonatomic, strong) NSArray *slot4;
@property (nonatomic, strong) NSArray *slot5;
@property (nonatomic, strong) NSArray *containerArray;


- (IBAction)backButtonClick:(id)sender;

@end

@implementation RLSaveItemsViewController

#pragma mark Initalize and Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self loadSavedData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backButtonClick:(id)sender;
{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Show the listing slot
    RLSaveIteTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SaveIteTableViewCell"];
    cell.nameLabel.text = [NSString stringWithFormat:@"Slot %ld", (long)indexPath.row];
    cell.delegate = self;
    cell.indexPath = indexPath;
    
    if (self.containerArray && self.containerArray.count > indexPath.row){
        NSArray *slotData = self.containerArray[indexPath.row];
        if (slotData && slotData.count > 0) {
            
            if (self.save == YES) {
                [cell.saveButton setTitle:@"REPLACE" forState:UIControlStateNormal];
            }
            else {
                [cell.saveButton setTitle:@"LOAD" forState:UIControlStateNormal];
            }
        }
        else {
            if (self.save == YES) {
                [cell.saveButton setTitle:@"SAVE" forState:UIControlStateNormal];
            }
            else {
                
                cell.saveButton.hidden = YES;
            }
        }
    }
    return cell;
}


- (void)saveButtonClick:(NSIndexPath *)indexPath
{
    if (self.save == YES) {
        switch (indexPath.row) {
            case 0:
                self.slot1 = self.userList;
                break;
            case 1:
                self.slot2 = self.userList;
                break;
            case 2:
                self.slot3 = self.userList;
                break;
            case 3:
                self.slot4 = self.userList;
                break;
            default:
                self.slot5 = self.userList;
                break;
        }
        
        [self saveUserData];
    }
    else {
        
        // Load the saved list.
        switch (indexPath.row) {
            case 0:
                self.userList = self.slot1;
                break;
            case 1:
                self.userList = self.slot2;
                break;
            case 2:
                self.userList = self.slot3;
                break;
            case 3:
                self.userList = self.slot4;
                break;
            default:
                self.userList = self.slot5;
                break;
        }
        
        if ([self.delegate respondsToSelector:@selector(loadUserWithData:)]) {
            [self.delegate loadUserWithData:self.userList];
        }
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (void)loadSavedData {
    NSString *filePath = [self settingArchivePath];
    NSDictionary *settingDict = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
    if (settingDict) {
        
        if ([settingDict objectForKey:@"slot1"]){
            self.slot1 = [settingDict objectForKey:@"slot1"];
        }
        else {
            self.slot1 = @[];
        }
        if ([settingDict objectForKey:@"slot2"]){
            self.slot2 = [settingDict objectForKey:@"slot2"];
        }
        else {
            self.slot2 = @[];
        }

        if ([settingDict objectForKey:@"slot3"]){
            self.slot3 = [settingDict objectForKey:@"slot3"];
        }
        else {
            self.slot3 = @[];
        }

        if ([settingDict objectForKey:@"slot4"]){
            self.slot4 = [settingDict objectForKey:@"slot4"];
        }
        else {
            self.slot4 = @[];
        }

        if ([settingDict objectForKey:@"slot5"]){
            self.slot5 = [settingDict objectForKey:@"slot5"];
        }
        else {
            self.slot5 = @[];
        }
        
        self.containerArray = @[self.slot1, self.slot2, self.slot3, self.slot4, self.slot5];
    }
    else {
        self.containerArray = @[@[], @[], @[], @[], @[]];
    }
}

#pragma mark: save setting part.
- (void)saveUserData;
{
    NSMutableDictionary *settingDict = [NSMutableDictionary new];
    NSString *filePath = [self settingArchivePath];
    
    if (self.slot1 && self.slot1.count > 0) {
        settingDict[@"slot1"] = self.slot1;
    }
    if (self.slot2 && self.slot2.count > 0) {
        settingDict[@"slot2"] = self.slot2;
    }
    if (self.slot3 && self.slot3.count > 0) {
        settingDict[@"slot3"] = self.slot3;
    }
    if (self.slot4 && self.slot4.count > 0) {
        settingDict[@"slot4"] = self.slot4;
    }
    if (self.slot5 && self.slot5.count > 0) {
        settingDict[@"slot5"] = self.slot1;
    }

    BOOL saveSuccess =[NSKeyedArchiver archiveRootObject:settingDict
                                                  toFile:filePath];
    if (saveSuccess) {
        NSLog(@"saveSetting");
        
        // TODO: show message.
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Message"
                                                                       message:@"Saved."
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"OK"
                                                         style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction * action) {
                                                           [self.navigationController popViewControllerAnimated:YES];
                                                       }];
        
        [alert addAction:cancel];
        
        [self presentViewController:alert animated:YES completion:nil];

    }
    else {

        // TODO: show message.

        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Message"
                                                                       message:@"Cannot save data. Please try it later."
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"OK"
                                                         style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction * action) {
                                                           [self.navigationController popViewControllerAnimated:YES];
                                                       }];
        
        [alert addAction:cancel];
        
        [self presentViewController:alert animated:YES completion:nil];

    }
}


- (NSString *)settingArchivePath
{
    // Make sure that the first argument is NSDocumentDirectory and not NSDocumantationDirectory.
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    // Get the one document directory from that list.
    NSString *documentDirectory = [documentDirectories firstObject];
    documentDirectory= [documentDirectory  stringByAppendingPathComponent:FOLDER_SETTING];
    
    //Create folder
    if (![[NSFileManager defaultManager] fileExistsAtPath:documentDirectory]){
        [[NSFileManager defaultManager] createDirectoryAtPath:documentDirectory
                                  withIntermediateDirectories:NO
                                                   attributes:nil
                                                        error:nil];
    }
    
    return [documentDirectory  stringByAppendingPathComponent:settingFileName];
}


@end
