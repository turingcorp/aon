#import "tools.h"

@implementation tools
{
    NSNumberFormatter *numfor;
    BOOL contsstring;
}

+(tools*)sha
{
    static tools *sha;
    static dispatch_once_t once;
    dispatch_once(&once,
                  ^(void)
                  {
                      sha = [[self alloc] init];
                  });
    return sha;
}

-(tools*)init
{
    self = [super init];
    
    numfor = [[NSNumberFormatter alloc] init];
    [numfor setNumberStyle:NSNumberFormatterDecimalStyle];
    
    if([[[NSString alloc] init] respondsToSelector:@selector(containsString:)])
    {
        contsstring = YES;
    }
    else
    {
        contsstring = NO;
    }
    
    return self;
}

#pragma mark public

-(BOOL)string:(NSString*)_string contains:(NSString*)_other
{
    if(contsstring)
    {
        return [_string containsString:_other];
    }
    
    return [_string rangeOfString:_other].location != NSNotFound;
}

-(NSNumber*)now
{
    NSInteger now = [[NSDate date] timeIntervalSince1970];
    
    return @(now);
}

-(NSString*)scoretostring:(NSInteger)_score
{
    return [numfor stringFromNumber:@(_score)];
}

@end