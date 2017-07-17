#import "gkman.h"

@implementation gkman
{
    NSString *leaderid;
}

+(gkman*)sha
{
    static gkman *sha;
    static dispatch_once_t once;
    dispatch_once(&once,
                  ^(void)
                  {
                      sha = [[self alloc] init];
                  });
    return sha;
}

#pragma mark public

-(void)login
{
    __weak GKLocalPlayer *locplayer = [GKLocalPlayer localPlayer];
    locplayer.authenticateHandler = ^(UIViewController *_controller, NSError *_error)
    {
        if(_controller)
        {
            [[ctrmain sha] presentViewController:_controller animated:YES completion:nil];
        }
        else if(locplayer.isAuthenticated)
        {
            [[GKLocalPlayer localPlayer] loadDefaultLeaderboardIdentifierWithCompletionHandler:
             ^(NSString *_leadid, NSError *_error)
             {
                 if(!_error)
                 {
                     leaderid = _leadid;
                 }
             }];
        }
        else
        {
            leaderid = nil;
        }
    };
}

-(void)showleaders
{
    GKGameCenterViewController *controller = [[GKGameCenterViewController alloc] init];
    if(controller)
    {
        controller.gameCenterDelegate = self;
        [controller setGameCenterDelegate:self];
        [[ctrmain sha] presentViewController:controller animated:YES completion:nil];
    }
}

-(void)newscore:(NSInteger)_score
{
    if(leaderid)
    {
        GKScore *score = [[GKScore alloc] initWithLeaderboardIdentifier:leaderid];
        [score setValue:_score];
        [score setContext:0];
        [GKScore reportScores:@[score] withCompletionHandler:nil];
        
        NSArray *arr = [[modachs sha] achievementsids:_score];
        NSMutableArray *acharr = [NSMutableArray array];
        NSInteger qty = arr.count;
        
        for(NSInteger i = 0; i < qty; i++)
        {
            NSString *achid = arr[i];
            GKAchievement *ach = [[GKAchievement alloc] initWithIdentifier:achid];
            
            if(ach)
            {
                [ach setPercentComplete:100];
                [acharr addObject:ach];
            }
        }
        
        if(acharr.count)
        {
            [GKAchievement reportAchievements:acharr withCompletionHandler:nil];
        }
    }
}

#pragma mark -
#pragma mark game del

-(void)gameCenterViewControllerDidFinish:(GKGameCenterViewController*)_game
{
    [[ctrmain sha] dismissViewControllerAnimated:YES completion:nil];
}

@end