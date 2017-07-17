#import "modperks.h"

@implementation modperks
{
    NSMutableArray *array;
}

+(modperks*)sha
{
    static modperks *sha;
    static dispatch_once_t once;
    dispatch_once(&once,
                  ^(void)
                  {
                      sha = [[self alloc] init];
                  });
    return sha;
}

-(modperks*)init
{
    self = [super init];
    
    return self;
}

#pragma mark functionality

-(void)editstatus:(NSString*)_productid status:(perkstatus)_status
{
    NSInteger qty = array.count;
    
    for(NSInteger i = 0; i < qty; i++)
    {
        modperkelement *e = array[i];
        
        if([e.skproduct.productIdentifier isEqualToString:_productid])
        {
            e.status = _status;
        }
    }
    
    if([[tools sha] string:_productid contains:@"Double"])
    {
        [[NSUserDefaults standardUserDefaults] setValue:@(_status) forKey:proppurdouble];
    }
}

#pragma mark public

-(void)refresh
{
    array = [NSMutableArray array];
}

-(void)loaddouble:(SKProduct*)_product price:(NSString*)_price
{
    [array addObject:[[modperkelement alloc] init:_product status:(perkstatus)[[[NSUserDefaults standardUserDefaults] valueForKey:proppurdouble] integerValue] name:NSLocalizedString(@"perks_double_name", nil) shortdesc:NSLocalizedString(@"perks_double_shortdescription", nil) longdesc:NSLocalizedString(@"perks_double_longdescription", nil) price:_price]];
}

-(NSInteger)count
{
    return array.count;
}

-(modperkelement*)perk:(NSInteger)_index
{
    return array[_index];
}

-(void)productpurchased:(NSString*)_productid
{
    [self editstatus:_productid status:perkstatuspurchased];
}

-(void)productpurchasing:(NSString*)_productid
{
    [self editstatus:_productid status:perkstatuspurchasing];
}

-(void)productdeferred:(NSString*)_productid
{
    [self editstatus:_productid status:perkstatusdeferred];
}

-(void)productcanceled:(NSString*)_productid
{
    [self editstatus:_productid status:perkstatusnew];
}

@end

@implementation modperkelement

@synthesize status;
@synthesize skproduct;
@synthesize name;
@synthesize shortdescription;
@synthesize longdescription;
@synthesize strprice;

-(modperkelement*)init:(SKProduct*)_product status:(perkstatus)_status name:(NSString*)_name shortdesc:(NSString*)_shortdesc longdesc:(NSString*)_longdesc price:(NSString*)_price
{
    self = [super init];
    skproduct = _product;
    status = _status;
    name = _name;
    shortdescription = _shortdesc;
    longdescription = _longdesc;
    strprice = _price;
    
    return self;
}

#pragma mark public

-(void)purchase
{
    [[skman sha] purchase:skproduct];
}

@end