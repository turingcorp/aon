#import "ctrmain.h"

@implementation ctrmain
{
    ctrupdater *upr;
    UIPanGestureRecognizer *pangesture;
    UITapGestureRecognizer *tapgesture;
    CGFloat paninitialx;
    BOOL ispanning;
}

@synthesize game;
@synthesize drawer;
@synthesize hub;

+(ctrmain*)sha
{
    static ctrmain *sha;
    static dispatch_once_t once;
    dispatch_once(&once,
                  ^(void)
                  {
                      sha = [[self alloc] init];
                  });
    return sha;
}

-(ctrmain*)init
{
    self = [super init];
    ispanning = NO;
    
    return self;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self setPauseOnWillResignActive:YES];
    [self setPreferredFramesPerSecond:60];
    [self setResumeOnDidBecomeActive:NO];
    
    GLKView *view = (GLKView*)self.view;
    [view setContext:[[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2]];
    [EAGLContext setCurrentContext:view.context];
    
    vihub *stronghub = [[vihub alloc] init];
    hub = stronghub;
    [self.view addSubview:hub];
    
    game = [[ctrgame alloc] init];
    drawer = [[ctrdrawer alloc] init:game];
    upr = [[ctrupdater alloc] init:game];
    
    [view setDelegate:drawer];
    [self setDelegate:upr];
    
    pangesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panning)];
    [pangesture setDelegate:self];
    tapgesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapping)];
    [tapgesture setDelegate:self];
    
    [view addGestureRecognizer:pangesture];
    [view addGestureRecognizer:tapgesture];
}

-(void)viewDidAppear:(BOOL)_animated
{
    [super viewDidAppear:_animated];
    [self setPaused:YES];
}

-(void)touchesBegan:(NSSet*)_touches withEvent:(UIEvent*)_event
{
    if(_touches.count)
    {
        UITouch *touch = [[_touches objectEnumerator] nextObject];
        
        if(touch.view != hub)
        {
            [self touching];
        }
    }
}

#pragma mark functionality

-(void)touching
{
    [game desiredposition:[tapgesture locationInView:self.view].x];
}

#pragma mark gesture

-(void)panning
{
    switch(pangesture.state)
    {
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateFailed:
            
            ispanning = NO;
            
            break;
            
        default:
            
            [game desiredposition:[pangesture locationInView:self.view].x];
            
            break;
    }
}

-(void)tapping
{
    if(tapgesture.state == UIGestureRecognizerStateRecognized)
    {
        [self touching];
    }
}

#pragma mark -
#pragma mark gesture del

-(BOOL)gestureRecognizer:(UIGestureRecognizer*)_gesture shouldReceiveTouch:(UITouch*)_touch
{
    if(_touch.view == hub)
    {
        return NO;
    }
    
    return YES;
}

@end