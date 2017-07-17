#import "ctrupdater.h"

@implementation ctrupdater
{
    BOOL paused;
}

@synthesize game;

-(ctrupdater*)init:(ctrgame*)_game
{
    self = [super init];
    
    game = _game;
    paused = NO;
    
    return self;
}

#pragma mark -
#pragma mark glkcontroller del

-(void)glkViewControllerUpdate:(GLKViewController*)_controller
{
    [game render];
}

-(void)glkViewController:(GLKViewController*)_controller willPause:(BOOL)_pause
{
    if(_pause)
    {
        if(!paused)
        {
            paused = YES;
            [[ctrmain sha].game pausegame];
        }
    }
    else
    {
        paused = NO;
    }
}

@end