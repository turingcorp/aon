#import "updater.h"

@implementation updater

NSInteger screenwidth;
NSInteger screenwidth_2;
NSInteger screenheight;
NSInteger screenheight_2;
NSInteger displayheight;
CGRect screenrect;
apptype applicationtype;

+(updater*)sha
{
    static updater *sha;
    static dispatch_once_t once;
    dispatch_once(&once,
                  ^(void)
                  {
                      sha = [[self alloc] init];
                  });
    return sha;
}

-(void)update
{
    NSDictionary *defaults = [[NSDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"defs" ofType:@"plist"]];
    NSUserDefaults *properties = [NSUserDefaults standardUserDefaults];
    
    NSInteger def_version = [defaults[@"version"] integerValue];
    NSInteger pro_version = [[properties valueForKey:@"version"] integerValue];
    
    if(def_version != pro_version)
    {
        [properties setValue:@(def_version) forKeyPath:@"version"];
        
        if(pro_version == 0)
        {
            NSString *appid = defaults[@"appid"];
            
            [properties removePersistentDomainForName:NSGlobalDomain];
            [properties removePersistentDomainForName:NSArgumentDomain];
            [properties removePersistentDomainForName:NSRegistrationDomain];
            [properties setValue:@0 forKey:@"visited"];
            [properties setValue:@YES forKey:@"ask"];
            [properties setValue:appid forKey:@"appid"];
            
            [properties setValue:@(perkstatusnew) forKey:proppurdouble];
            [properties setValue:@0 forKey:propmaxscore];
        }
    }
    
    CGSize size = [UIScreen mainScreen].bounds.size;
    screenwidth = size.height;
    screenheight = size.width;
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        applicationtype = apptypepad;
    }
    else
    {
        applicationtype = apptypephone;
    }
    
    if(screenwidth > screenheight)
    {
        screenwidth = size.width;
        screenheight = size.height;
    }
    
    screenwidth_2 = screenwidth / 2;
    screenheight_2 = screenheight / 2;
    displayheight = screenheight - hubheight;
    screenrect = CGRectMake(0, 0, screenwidth, screenheight);
}

-(void)asktorate
{
    NSUserDefaults *properties = [NSUserDefaults standardUserDefaults];
    BOOL ask = [[properties valueForKey:@"ask"] boolValue];
    
    if(ask)
    {
        NSInteger visited = [[properties valueForKey:@"visited"] integerValue];
        [properties setValue:@(visited + 1) forKey:@"visited"];
        [properties synchronize];
        
        if(visited % 3 == 2)
        {
//            [[[UIAlertView alloc] initWithTitle:@"" message:NSLocalizedString(@"alert_message", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"alert_do", nil) otherButtonTitles:NSLocalizedString(@"alert_dontask", nil), NSLocalizedString(@"alert_no", nil), nil] show];
            
                        [[[UIAlertView alloc] initWithTitle:@"" message:NSLocalizedString(@"alert_message", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"alert_do", nil) otherButtonTitles:NSLocalizedString(@"alert_no", nil), nil] show];
        }
    }
}

#pragma mark -
#pragma mark alert del

-(void)alertView:(UIAlertView*)_alert didDismissWithButtonIndex:(NSInteger)_index
{
    NSUserDefaults *properties = [NSUserDefaults standardUserDefaults];
    
    switch(_index)
    {
        case 0:
            
            [[UIApplication sharedApplication] openURL:
             [NSURL URLWithString:[NSString stringWithFormat:@"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%@", [properties valueForKey:@"appid"]]]];
            
            [properties setValue:@NO forKey:@"ask"];
            
            break;
            /*
        case 1:
            
            [properties setValue:@NO forKey:@"ask"];
            
            break;*/
            
        default:
            
            break;
    }
    
    [properties synchronize];
}

@end
