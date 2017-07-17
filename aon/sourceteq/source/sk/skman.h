#import "appdel.h"

@class vistore;

@interface skman:NSObject<SKProductsRequestDelegate, SKPaymentTransactionObserver, SKRequestDelegate>

+(skman*)sha;
-(void)checkavailabilities;
-(void)purchase:(SKProduct*)_product;
-(void)restorepurchases;

@property(weak, nonatomic)vistore *store;

@end