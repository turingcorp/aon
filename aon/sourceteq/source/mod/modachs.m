#import "modachs.h"

@implementation modachs
{
    NSMutableArray *array;
    NSInteger qty;
}

+(modachs*)sha
{
    static modachs *sha;
    static dispatch_once_t once;
    dispatch_once(&once,
                  ^(void)
                  {
                      sha = [[self alloc] init];
                  });
    return sha;
}

-(modachs*)init
{
    self = [super init];
    
    array = [NSMutableArray array];
    NSArray *plist = [[NSArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"achs" ofType:@"plist"]];
    qty = plist.count;
    
    for(NSInteger i = 0; i < qty; i++)
    {
        NSDictionary *pl = plist[i];
        [array addObject:[[modach alloc] init:pl[@"id"] points:pl[@"points"]]];
    }
    
    return self;
}

#pragma mark public

-(NSArray*)achievementsids:(NSInteger)_score
{
    NSMutableArray *inarr = [NSMutableArray array];
    
    for(NSInteger i = 0; i < qty; i++)
    {
        modach *ach = array[i];
        
        if(_score >= ach.points)
        {
            [inarr addObject:ach.achid];
        }
    }
    
    return inarr;
}

@end

@implementation modach

@synthesize achid;
@synthesize points;

-(modach*)init:(NSString*)_achid points:(NSNumber*)_points
{
    self = [super init];
    
    achid = _achid;
    points = _points.integerValue;
    
    return self;
}

@end