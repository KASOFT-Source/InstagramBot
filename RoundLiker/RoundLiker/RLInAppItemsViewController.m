//
//  RLInAppItemsViewController.m
//  RoundLiker
//
//  Created by Hoang Phuong on 11/11/16.
//  Copyright © 2016 Palmsoft. All rights reserved.
//

#import "RLInAppItemsViewController.h"
#import "AppDelegate.h"
#import "RMStore.h"
#import "StoreKit/StoreKit.h"
#define kMySubscriptionFeature @"productId001"
#define sharedSecret @"3a4adc44643f4d46a73c0807c1b13b9b"

@interface RLInAppItemsViewController ()<UITableViewDelegate, UITableViewDataSource, SKProductsRequestDelegate, SKProductsRequestDelegate, SKPaymentTransactionObserver>
{
    SKProduct *proUpgradeProduct;
    SKProductsRequest *productsRequest;
}

@property(weak,nonatomic) IBOutlet UITableView *tableView;

- (IBAction)backButtonClick:(id)sender;

@end

@implementation RLInAppItemsViewController

#pragma mark Initalize and Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
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
//    NSSet *products = [NSSet setWithArray:@[@"com.lykan.LuxuryClosetT.productId001"]];
//    [[RMStore defaultStore] requestProducts:products success:^(NSArray *products, NSArray *invalidProductIdentifiers) {
//        NSLog(@"Products loaded: %@", products);
//    } failure:^(NSError *error) {
//        NSLog(@"Something went wrong");
//    }];
    
    [self requestProUpgradeProductData];
}

- (void)buyItems;
{
    [[RMStore defaultStore] addPayment:@"waxLips" success:^(SKPaymentTransaction *transaction) {
        NSLog(@"Product purchased");
    } failure:^(SKPaymentTransaction *transaction, NSError *error) {
        NSLog(@"Something went wrong");
    }];
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InAppItemTableViewCell"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    // TODO: buy items.
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
    
    NSArray *myProduct = [[NSArray alloc] initWithArray:response.products];
    
    for(SKProduct *item in myProduct)
    {
        
        NSLog(@"Product title: %@" , item.localizedTitle);
        NSLog(@"Product description: %@" , item.localizedDescription);
        NSLog(@"Product price: %@" , item.price);
        NSLog(@"Product id: %@" , item.productIdentifier);
        
        
    }
    
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
