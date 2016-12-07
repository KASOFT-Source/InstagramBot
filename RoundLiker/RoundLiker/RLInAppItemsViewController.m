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

#define kMySubscriptionFeature @"studio.kensai.pro10"

@interface RLInAppItemsViewController ()<UITableViewDelegate, UITableViewDataSource, SKProductsRequestDelegate, SKProductsRequestDelegate, SKPaymentTransactionObserver, RLInAppItemTableViewCellProtocol>
{
    SKProduct *proUpgradeProduct;
    SKProductsRequest *productsRequest;
    
}

@property(weak,nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *items;


- (IBAction)backButtonClick:(id)sender;

@end

@implementation RLInAppItemsViewController

#pragma mark Initalize and Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self requestProductData];
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
//- (void)loadIAPItems;
//{
//    NSSet *products = [NSSet setWithArray:@[@"studio.kensai.pro10"]];
//    [[RMStore defaultStore] requestProducts:products success:^(NSArray *products, NSArray *invalidProductIdentifiers) {
//        NSLog(@"Products loaded: %@", products);
//    } failure:^(NSError *error) {
//        NSLog(@"Something went wrong");
//    }];
//}

//- (void)buyItems;
//{
//    [[RMStore defaultStore] addPayment:@"studio.kensai.pro10" success:^(SKPaymentTransaction *transaction) {
//        NSLog(@"Product purchased");
//    } failure:^(SKPaymentTransaction *transaction, NSError *error) {
//        NSLog(@"Something went wrong");
//    }];
//}

- (void)buyItemsAtPosition:(NSUInteger)position;
{
    
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
    cell.nameLabel.text = item.localizedTitle;
    cell.indexPath = indexPath;
    cell.delegate = self;
    
//    NSLog(@"Product title: %@" , item.localizedTitle);
//    NSLog(@"Product description: %@" , item.localizedDescription);
//    NSLog(@"Product price: %@" , item.price);
//    NSLog(@"Product id: %@" , item.productIdentifier);

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    // TODO: buy items.
//    [self buyItems];
}

#pragma mark RLInAppItemTableViewCellProtocol
- (void)buyButtonClick:(NSIndexPath *)indexPath;
{
    [self buyItemsAtPosition: indexPath.row];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void) requestProductData
{
    
    NSLog(@"requestProductData");
    SKProductsRequest *request= [[SKProductsRequest alloc] initWithProductIdentifiers: [NSSet setWithObject:kMySubscriptionFeature]];
    request.delegate = self;
    [request start];
}

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    NSLog(@"productsRequest");
    
    self.items = [[NSArray alloc] initWithArray:response.products];
    
    [self.tableView reloadData];
    /*
     for(NSString *invalidProduct in response.invalidProductIdentifiers)
     NSLog(@"Problem in iTunes connect configuration for product: %@", invalidProduct);
     */
    
    for (NSString *invalidProductId in response.invalidProductIdentifiers)
    {
        NSLog(@"Problem in iTunes connect configuration for product: %@" , invalidProductId);
    }
    
}

#pragma mark - PaymentQueue

-(void)paymentQueue:(SKPaymentQueue *)queue removedTransactions:(NSArray *)transactions
{
}

-(void)paymentQueue:(SKPaymentQueue *)queue restoreCompletedTransactionsFailedWithError:(NSError *)error
{
}

-(void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
}

-(void)paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue
{
}

#pragma mark - Other


- (void)requestProUpgradeProductData
{
    NSSet *productIdentifiers = [NSSet setWithObject:kMySubscriptionFeature];
    productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:productIdentifiers];
    productsRequest.delegate = self;
    [productsRequest start];
    
    // we will release the request object in the delegate callback
}



@end
