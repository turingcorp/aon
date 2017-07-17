#import "skman.h"

@implementation skman
{
    NSNotification *notification;
}

@synthesize store;

+(skman*)sha
{
    static skman *sha;
    static dispatch_once_t once;
    dispatch_once(&once,
                  ^(void)
                  {
                      sha = [[self alloc] init];
                  });
    return sha;
}

-(skman*)init
{
    self = [super init];
    notification = [NSNotification notificationWithName:notpurchaseupd object:nil];
    
    return self;
}

#pragma mark public

-(void)checkavailabilities
{
    store = [vistore show];
    NSArray *array = [[NSArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"perks" ofType:@"plist"]];
    
    SKProductsRequest *request = [[SKProductsRequest alloc] initWithProductIdentifiers:[NSSet setWithArray:array]];
    request.delegate = self;
    [request start];
}

-(void)purchase:(SKProduct*)_product
{
    [[SKPaymentQueue defaultQueue] addPayment:[SKMutablePayment paymentWithProduct:_product]];
}

-(void)restorepurchases
{
    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
}

#pragma mark -
#pragma mark sk del

-(void)request:(SKRequest*)_request didFailWithError:(NSError*)_error
{
    [store close];
    [ctralert alert:alerttypebad message:NSLocalizedString(@"sk_error_noconnection", nil)];
}

-(void)productsRequest:(SKProductsRequest*)_request didReceiveResponse:(SKProductsResponse*)_response
{
    NSArray *prods = _response.products;
    NSInteger qty = prods.count;
    
    [[modperks sha] refresh];
    
    if(qty)
    {
        NSNumberFormatter *priceformater = [[NSNumberFormatter alloc] init];
        [priceformater setNumberStyle:NSNumberFormatterCurrencyStyle];
        
        for(NSInteger i = 0; i < qty; i++)
        {
            SKProduct *prod = prods[i];
            [priceformater setLocale:prod.priceLocale];
            NSString *strprice = [priceformater stringFromNumber:prod.price];
            NSString *strtitle = prod.localizedTitle;
            
            if([[tools sha] string:strtitle contains:@"Double"])
            {
                [[modperks sha] loaddouble:prod price:strprice];
            }
        }
    }
    
    [store loaddata];
}

-(void)paymentQueue:(SKPaymentQueue*)_queue updatedTransactions:(NSArray*)_transactions
{
    NSInteger qty = _transactions.count;
    for(NSInteger i = 0; i < qty; i++)
    {
        SKPaymentTransaction *tran = _transactions[i];
        NSString *prodid = tran.payment.productIdentifier;
        
        switch(tran.transactionState)
        {
            case SKPaymentTransactionStateDeferred:
                
                [[modperks sha] productdeferred:prodid];
                
                break;
                
            case SKPaymentTransactionStateFailed:
                
                [[modperks sha] productcanceled:prodid];
                [[SKPaymentQueue defaultQueue] finishTransaction:tran];
                
                break;
                
            case SKPaymentTransactionStatePurchased:
                
                [[modperks sha] productpurchased:prodid];
                [[SKPaymentQueue defaultQueue] finishTransaction:tran];
                
                break;
                
            case SKPaymentTransactionStatePurchasing:
                
                [[modperks sha] productpurchasing:prodid];
                
                break;
                
            case SKPaymentTransactionStateRestored:
                
                [[modperks sha] productpurchased:prodid];
                [[SKPaymentQueue defaultQueue] finishTransaction:tran];
                
                break;
        }
    }
    
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}

-(void)paymentQueue:(SKPaymentQueue*)_queue removedTransactions:(NSArray*)_transactions
{
    NSInteger qty = _transactions.count;
    for(NSInteger i = 0; i < qty; i++)
    {
        SKPaymentTransaction *tran = _transactions[i];
        NSString *prodid = tran.payment.productIdentifier;
        
        switch(tran.transactionState)
        {
            case SKPaymentTransactionStateDeferred:
                
                [[modperks sha] productdeferred:prodid];
                
                break;
                
            case SKPaymentTransactionStateFailed:
                
                [[modperks sha] productcanceled:prodid];
                
                break;
                
            case SKPaymentTransactionStatePurchased:
                
                [[modperks sha] productpurchased:prodid];
                
                break;
                
            case SKPaymentTransactionStatePurchasing:
                
                [[modperks sha] productpurchasing:prodid];
                
                break;
                
            case SKPaymentTransactionStateRestored:
                
                [[modperks sha] productpurchased:prodid];
                
                break;
        }
    }
    
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}

-(void)paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue*)_queue
{
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}

-(void)paymentQueue:(SKPaymentQueue*)_queue restoreCompletedTransactionsFailedWithError:(NSError*)_error
{
    [ctralert alert:alerttypebad message:_error.localizedDescription];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}

@end