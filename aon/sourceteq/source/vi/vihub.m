#import "vihub.h"

@implementation vihub

@synthesize pausebtn;
@synthesize lblpoints;

-(vihub*)init
{
    self = [super initWithFrame:CGRectMake(0, displayheight, screenwidth, hubheight)];
    [self setClipsToBounds:YES];
    [self setBackgroundColor:[UIColor colorWithWhite:0.95 alpha:1]];
    
    UILabel *stronglblpoints = [[UILabel alloc] initWithFrame:CGRectMake(screenwidth - 270, 0, 250, hubheight)];
    lblpoints = stronglblpoints;
    [lblpoints setBackgroundColor:[UIColor clearColor]];
    [lblpoints setFont:[UIFont fontWithName:fontname size:20]];
    [lblpoints setTextAlignment:NSTextAlignmentRight];
    [lblpoints setTextColor:[UIColor colorWithWhite:0.6 alpha:1]];
    [lblpoints setUserInteractionEnabled:NO];
    
    vibtnpause *strongpausebtn = [[vibtnpause alloc] init:0 ypos:10];
    pausebtn = strongpausebtn;
    [pausebtn addTarget:self action:@selector(actionpause) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:lblpoints];
    [self addSubview:pausebtn];
    
    return self;
}

#pragma mark actions

-(void)actionpause
{
    [[ctrmain sha] setPaused:YES];
}

#pragma mark public

-(void)newscore:(NSString*)_score
{
    [lblpoints setText:_score];
}

@end