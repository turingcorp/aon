typedef enum
{
    timerstateactive,
    timerstatepaused
}timerstate;

@protocol timerbgdel <NSObject>

-(void)timerbgtick;

@end