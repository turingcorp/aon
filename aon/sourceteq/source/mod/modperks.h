#import "appdel.h"

typedef enum
{
    perkstatuspurchased,
    perkstatusnew,
    perkstatuspurchasing,
    perkstatusdeferred
}perkstatus;

@class modperkelement;

@interface modperks:NSObject

+(modperks*)sha;
-(void)refresh;
-(void)loaddouble:(SKProduct*)_product price:(NSString*)_price;
-(NSInteger)count;
-(modperkelement*)perk:(NSInteger)_index;
-(void)productpurchased:(NSString*)_productid;
-(void)productpurchasing:(NSString*)_productid;
-(void)productdeferred:(NSString*)_productid;
-(void)productcanceled:(NSString*)_productid;

@end

@interface modperkelement:NSObject

-(modperkelement*)init:(SKProduct*)_product status:(perkstatus)_status name:(NSString*)_name shortdesc:(NSString*)_shortdesc longdesc:(NSString*)_longdesc price:(NSString*)_price;
-(void)purchase;

@property(nonatomic)perkstatus status;
@property(strong, nonatomic)SKProduct *skproduct;
@property(strong, nonatomic)NSString *name;
@property(strong, nonatomic)NSString *shortdescription;
@property(strong, nonatomic)NSString *longdescription;
@property(strong, nonatomic)NSString *strprice;

@end