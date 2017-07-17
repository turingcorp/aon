#import "ctralert.h"

@implementation ctralert
{
    NSTimer *timer;
    UILabel *lbl;
    CGRect rectshown;
    CGRect recthidden;
}

+(void)alert:(alerttype)_type message:(NSString*)_message
{
    [[NSNotificationCenter defaultCenter] postNotificationName:notclosealert object:nil];
    
    dispatch_async(dispatch_get_main_queue(),
                   ^(void)
                   {
                       ctralert *alert = [[ctralert alloc] init:_message type:_type];
                       [[ctrmain sha].view addSubview:alert];
                       
                       [alert display];
                   });
}

-(ctralert*)init:(NSString*)_message type:(alerttype)_type
{
    rectshown = CGRectMake(0, 0, screenwidth, 70);
    recthidden = CGRectMake(0, -70, screenwidth, 70);
    
    self = [super initWithFrame:recthidden];
    [self setClipsToBounds:YES];
    
    switch(_type)
    {
        case alerttypegood:
            
            [self setBackgroundColor:[colorblue colorWithAlphaComponent:0.86]];
            
            break;
            
        case alerttypebad:
            
            [self setBackgroundColor:[colorred colorWithAlphaComponent:0.86]];
            
            break;
    }
    
    lbl = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, screenwidth - 40, 70)];
    [lbl setBackgroundColor:[UIColor clearColor]];
    [lbl setUserInteractionEnabled:NO];
    [lbl setTextAlignment:NSTextAlignmentCenter];
    [lbl setNumberOfLines:0];
    [lbl setFont:[UIFont fontWithName:fontname size:14]];
    [lbl setTextColor:[UIColor whiteColor]];
    [lbl setText:_message];
    
    [self addSubview:lbl];
    [self addTarget:self action:@selector(actionclose) forControlEvents:UIControlEventTouchDown];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hide) name:notclosealert object:nil];
    
    return self;
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark actions

-(void)actionclose
{
    [self hide];
}

#pragma mark functionality

-(void)show
{
    [UIView animateWithDuration:0.5 animations:
     ^(void)
     {
         [self setFrame:rectshown];
     }];
}

-(void)hide
{
    __weak ctralert *weakself = self;
    
    dispatch_async(dispatch_get_main_queue(),
                   ^(void)
                   {
                       [timer invalidate];
                       
                       [UIView animateWithDuration:0.3 animations:
                        ^(void)
                        {
                            [weakself setFrame:recthidden];
                        } completion:
                        ^(BOOL _done)
                        {
                            [[NSNotificationCenter defaultCenter] removeObserver:weakself];
                            [weakself removeFromSuperview];
                        }];
                   });
}

#pragma mark public

-(void)display
{
    [self show];
    timer = [NSTimer scheduledTimerWithTimeInterval:3.5 target:self selector:@selector(hide) userInfo:nil repeats:NO];
}

@end