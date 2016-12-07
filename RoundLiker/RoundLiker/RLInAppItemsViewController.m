//
//  RLInAppItemsViewController.m
//  RoundLiker
//
//  Created by Hoang Phuong on 11/11/16.
//  Copyright © 2016 Palmsoft. All rights reserved.
//

#import "RLInAppItemsViewController.h"
#import "AppDelegate.h"
#import "StoreKit/StoreKit.h"
#import "RLInAppItemTableViewCell.h"
#import "RMStore.h"
#import "RLEnumeration.h"

@interface RLInAppItemsViewController ()<UITableViewDelegate, UITableViewDataSource, RLInAppItemTableViewCellProtocol>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@property (nonatomic, strong) NSArray *items;
@property (nonatomic, strong) NSArray *itemIds;


- (IBAction)backButtonClick:(id)sender;

@end

@implementation RLInAppItemsViewController

#pragma mark Initalize and Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.itemIds = ITEMS_ARRAY;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self loadIAPItems];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)backButtonClick:(id)sender;
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark: Load IAP products
- (void)loadIAPItems;
{
    NSSet *products = [NSSet setWithArray:self.itemIds];
    [self.activityIndicator startAnimating];

    [[RMStore defaultStore] requestProducts:products success:^(NSArray *products, NSArray *invalidProductIdentifiers) {
        NSLog(@"Products loaded: %@", products);

        [self.activityIndicator stopAnimating];

        self.items = products;
        [self.tableView reloadData];
        

    } failure:^(NSError *error) {
        NSLog(@"Something went wrong");
        [self.activityIndicator stopAnimating];
    }];
}

- (void)buyItemsAtPosition:(NSUInteger)position;
{
    [self.activityIndicator startAnimating];

    SKProduct *item = self.items[position];
    [[RMStore defaultStore] addPayment:item.productIdentifier success:^(SKPaymentTransaction *transaction) {
        
        [self.activityIndicator stopAnimating];
        // Update the item buyed.

        NSLog(@"Product purchased");
        // Save the trasaction of item.
        
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        
        [ud setObject:item.productIdentifier forKey:kCheckoutKeyIdenfitier];
        [ud setObject:item.localizedTitle forKey:kCheckoutKeyName];
        [ud setObject:item.localizedDescription forKey:kCheckoutKeyDescription];
        [ud setObject:[NSDate date] forKey:kCheckoutDateKey];
        [ud synchronize];
        
        if ([self.delegate respondsToSelector:@selector(buyItemSuccessed)]) {
            [self.delegate buyItemSuccessed];
        }
        
        [self.navigationController popViewControllerAnimated:YES];

    } failure:^(SKPaymentTransaction *transaction, NSError *error) {
        NSLog(@"Something went wrong");
        [self.activityIndicator stopAnimating];
        
        [self showFailMessage: transaction.error.localizedDescription];

    }];
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SKProduct *item = self.items[indexPath.row];

    RLInAppItemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InAppItemTableViewCell"];
    cell.indexPath = indexPath;
    cell.delegate = self;
    
    NSLocale *locale = item.priceLocale;
    NSString *symbol = [locale objectForKey:NSLocaleCurrencySymbol];

    cell.nameLabel.text = [NSString stringWithFormat:@"%@ %@%@", item.localizedTitle, symbol, item.price];
    return cell;
}

#pragma mark RLInAppItemTableViewCellProtocol
- (void)buyButtonClick:(NSIndexPath *)indexPath;
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    if ([ud objectForKey:kCheckoutKeyName] && [ud objectForKey:kCheckoutDateKey]) {
        
        NSDate *date = [ud objectForKey:kCheckoutDateKey];
        
        NSTimeInterval monthInSecond = 60 * 60 * 24 * 29;
        if ([[date dateByAddingTimeInterval: monthInSecond] compare:[NSDate date]] == NSOrderedDescending) {
            
            // Show the alert item still in time
            NSTimeInterval timeRemaining = [[NSDate date] timeIntervalSinceDate:date];
            CGFloat dateRemaining = 30 - timeRemaining / (60 * 60 * 24);
            
            NSString *message = [NSString stringWithFormat:@"You still have %.0f date. Do you want to continue to buy item?", dateRemaining];
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Message"
                                                                           message:message
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"Cancel"
                                                             style:UIAlertActionStyleDefault
                                                           handler:^(UIAlertAction * action) {
                                                               
                                                               [alert dismissViewControllerAnimated:YES completion:nil];
                                                               
                                                           }];
            
            [alert addAction:cancel];
            
            UIAlertAction* buyButton = [UIAlertAction actionWithTitle:@"Buy"
                                                             style:UIAlertActionStyleDefault
                                                           handler:^(UIAlertAction * action) {
                                                               
                                                               [self buyItemsAtPosition: indexPath.row];

                                                               [alert dismissViewControllerAnimated:YES completion:nil];
                                                           }];
            [alert addAction:buyButton];
            
            [self presentViewController:alert animated:YES completion:nil];

        }
        else {
            [self buyItemsAtPosition: indexPath.row];
        }
    }
    else {
        [self buyItemsAtPosition: indexPath.row];
    }
}


- (void)showSuccessMessage;
{
    
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Message"
                                                                   message:@"Thank you for purchase!"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"OK"
                                                     style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction * action) {
                                                       
                                                       if ([self.delegate respondsToSelector:@selector(buyItemSuccessed)]) {
                                                           [self.delegate buyItemSuccessed];
                                                       }
                                                       
                                                       [self.navigationController popViewControllerAnimated:YES];
                                                   }];
    
    [alert addAction:cancel];
    
    [self presentViewController:alert animated:YES completion:nil];

}

- (void)showFailMessage:(NSString *)message;
{
    
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Message"
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"OK"
                                                     style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction * action) {
                                                       
                                                       [alert dismissViewControllerAnimated:YES completion:nil];
                                                   }];
    
    [alert addAction:cancel];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}

@end
