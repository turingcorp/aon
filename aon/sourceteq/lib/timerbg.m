#import "timerbg.h"

@implementation timerbg
{
    dispatch_source_t timer;
}

@synthesize delegate;
@synthesize state;

-(timerbg*)init:(id<timerbgdel>)_delegate milis:(NSInteger)_millis leeway:(NSInteger)_leeway background:(BOOL)_background
{
    self = [super init];
    
    delegate = _delegate;
    state = timerstatepaused;
    
    dispatch_queue_t queue;
    
    if(_background)
    {
        queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0);
    }
    else
    {
        queue = dispatch_get_main_queue();
    }
    
    timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, _millis * NSEC_PER_MSEC, _leeway);
    dispatch_source_set_event_handler
    (timer,
     ^{
         [delegate timerbgtick];
     });
    
    return self;
}

#pragma mark static

+(timerbg*)millis:(NSInteger)_millis delegate:(id<timerbgdel>)_delegate background:(BOOL)_background
{
    return [timerbg millis:_millis leeway:10 * NSEC_PER_MSEC delegate:_delegate background:_background];
}

+(timerbg*)millis:(NSInteger)_millis leeway:(NSInteger)_leeway delegate:(id<timerbgdel>)_delegate background:(BOOL)_background
{
    return [[timerbg alloc] init:_delegate milis:_millis leeway:_leeway background:_background];
}

#pragma mark public

-(void)pause
{
    if(state != timerstatepaused)
    {
        state = timerstatepaused;
        dispatch_suspend(timer);
    }
}

-(void)resume
{
    if(state != timerstateactive)
    {
        state = timerstateactive;
        dispatch_resume(timer);
    }
}

@end