#import "viinstrs.h"

@implementation viinstrs

+(void)show
{
    viinstrs *instr = [[viinstrs alloc] init];
    [[ctrmain sha].view addSubview:instr];
    [instr animateshow];
}

@synthesize col;
@synthesize btnclose;
@synthesize lbltitle;

-(viinstrs*)init
{
    self = [super initWithFrame:screenrect];
    [self setClipsToBounds:YES];
    [self setAlpha:0];
    
    if([UIVisualEffectView class])
    {
        UIVisualEffectView *blur = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight]];
        [blur setFrame:screenrect];
        [blur setUserInteractionEnabled:NO];
        
        [self addSubview:blur];
    }
    else
    {
        [self setBackgroundColor:[UIColor colorWithWhite:1 alpha:0.98]];
    }
    
    UIButton *strongbtnclose = [[UIButton alloc] initWithFrame:CGRectMake(15, 15, 70, 32)];
    btnclose = strongbtnclose;
    [btnclose setClipsToBounds:YES];
    [btnclose setBackgroundColor:colorblue];
    [btnclose setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnclose setTitleColor:[UIColor colorWithWhite:0.6 alpha:1] forState:UIControlStateHighlighted];
    [btnclose setTitle:NSLocalizedString(@"instr_close_btn", nil) forState:UIControlStateNormal];
    [btnclose.titleLabel setFont:[UIFont fontWithName:fontname size:12]];
    [btnclose.layer setCornerRadius:6];
    [btnclose addTarget:self action:@selector(actionclose) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *stronglbltitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 15, screenwidth, 32)];
    lbltitle = stronglbltitle;
    [lbltitle setBackgroundColor:[UIColor clearColor]];
    [lbltitle setTextAlignment:NSTextAlignmentCenter];
    [lbltitle setUserInteractionEnabled:NO];
    [lbltitle setFont:[UIFont fontWithName:fontname size:16]];
    [lbltitle setTextColor:[UIColor colorWithWhite:0.5 alpha:1]];
    [lbltitle setText:NSLocalizedString(@"instr_title", nil)];
    
    viinstrscol *strongcol = [[viinstrscol alloc] init];
    col = strongcol;
    [col setDelegate:self];
    [col setDataSource:self];
    [col registerClass:[viinstrsheader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerid];
    [col registerClass:[viinstrscel class] forCellWithReuseIdentifier:celid];
    
    [self addSubview:lbltitle];
    [self addSubview:btnclose];
    [self addSubview:col];
    
    return self;
}

#pragma mark actions

-(void)actionclose
{
    [self animatehide];
}

#pragma mark animations

-(void)animateshow
{
    [UIView animateWithDuration:0.4 animations:
     ^(void)
     {
         [self setAlpha:1];
     }];
}

-(void)animatehide
{
    [UIView animateWithDuration:0.3 animations:
     ^(void)
     {
         [self setAlpha:0];
         
     } completion:
     ^(BOOL _done)
     {
         [self removeFromSuperview];
     }];
}

#pragma mark -
#pragma mark col del

-(UIEdgeInsets)collectionView:(UICollectionView*)_col layout:(UICollectionViewLayout*)_layout insetForSectionAtIndex:(NSInteger)_section
{
    switch(_section)
    {
        case 1:
            
            return UIEdgeInsetsMake(0, screenwidth_2 - 140, 80, screenwidth_2 - 140);
            
        case 2:
            
            return UIEdgeInsetsMake(0, 0, 50, 0);
            
        default:
            
            return UIEdgeInsetsZero;
    }
}

-(CGSize)collectionView:(UICollectionView*)_col layout:(UICollectionViewLayout*)_layout sizeForItemAtIndexPath:(NSIndexPath*)_index
{
    switch(_index.section)
    {
        case 0:
            
            return CGSizeMake(screenwidth, 190);
            
        case 1:
            
            switch(_index.item)
            {
                case 0:
                    
                    return CGSizeMake(280, 140);
                    
                default:
                    
                    return CGSizeMake(55, 55);
            }
            
        default:
            
            return CGSizeMake(screenwidth, 130);
    }
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView*)_col
{
    return 3;
}

-(NSInteger)collectionView:(UICollectionView*)_col numberOfItemsInSection:(NSInteger)_section
{
    switch(_section)
    {
        case 0:
            
            return 5;
            
        case 1:
            
            return 11;
            
        default:
            
            return 6;
    }
}

-(UICollectionReusableView*)collectionView:(UICollectionView*)_col viewForSupplementaryElementOfKind:(NSString*)_kind atIndexPath:(NSIndexPath*)_index
{
    viinstrsheader *header = [_col dequeueReusableSupplementaryViewOfKind:_kind withReuseIdentifier:headerid forIndexPath:_index];
    
    switch(_index.section)
    {
        case 0:
            
            [header.lbltitle setText:NSLocalizedString(@"instr_sect_0_title", nil)];
            
            break;
            
        case 1:
            
            [header.lbltitle setText:NSLocalizedString(@"instr_sect_1_title", nil)];
            
            break;
            
        case 2:
            
            [header.lbltitle setText:NSLocalizedString(@"instr_sect_2_title", nil)];
            
            break;
    }
    
    return header;
}

-(UICollectionViewCell*)collectionView:(UICollectionView*)_col cellForItemAtIndexPath:(NSIndexPath*)_index
{
    viinstrscel *cel = [_col dequeueReusableCellWithReuseIdentifier:celid forIndexPath:_index];
    [cel config:_index];
    
    return cel;
}

@end

@implementation viinstrscol

@synthesize flow;

-(viinstrscol*)init
{
    self = [super initWithFrame:CGRectMake(0, 55, screenwidth, screenheight - 55) collectionViewLayout:[[UICollectionViewFlowLayout alloc] init]];
    [self setBackgroundColor:[UIColor clearColor]];
    [self setClipsToBounds:YES];
    
    flow = (UICollectionViewFlowLayout*)self.collectionViewLayout;
    [flow setFooterReferenceSize:CGSizeZero];
    [flow setHeaderReferenceSize:CGSizeMake(screenwidth, 100)];
    [flow setMinimumInteritemSpacing:0];
    [flow setMinimumLineSpacing:0];
    [flow setScrollDirection:UICollectionViewScrollDirectionVertical];
    
    return self;
}

@end

@implementation viinstrsheader

@synthesize lbltitle;

-(viinstrsheader*)initWithFrame:(CGRect)_frame
{
    self = [super initWithFrame:_frame];
    [self setClipsToBounds:YES];
    [self setBackgroundColor:[UIColor clearColor]];
    [self setUserInteractionEnabled:NO];
    
    UILabel *stronglbltitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 60, _frame.size.width, _frame.size.height - 60)];
    lbltitle = stronglbltitle;
    [lbltitle setBackgroundColor:[UIColor clearColor]];
    [lbltitle setFont:[UIFont fontWithName:fontname size:26]];
    [lbltitle setTextColor:[UIColor colorWithWhite:0.2 alpha:1]];
    [lbltitle setTextAlignment:NSTextAlignmentCenter];
    
    [self addSubview:lbltitle];
    
    return self;
}

@end

@implementation viinstrscel

@synthesize img;
@synthesize lbl;

-(viinstrscel*)initWithFrame:(CGRect)_rect
{
    self = [super initWithFrame:_rect];
    [self setClipsToBounds:YES];
    [self setBackgroundColor:[UIColor clearColor]];
    [self setUserInteractionEnabled:NO];
    
    UIImageView *strongimg = [[UIImageView alloc] init];
    img = strongimg;
    [img setContentMode:UIViewContentModeScaleAspectFit];
    [img setClipsToBounds:YES];
    
    UILabel *stronglbl = [[UILabel alloc] init];
    lbl = stronglbl;
    [lbl setBackgroundColor:[UIColor clearColor]];
    [lbl setFont:[UIFont fontWithName:fontname size:16]];
    [lbl setTextColor:[UIColor colorWithWhite:0.4 alpha:1]];
    [lbl setNumberOfLines:0];
    
    [self addSubview:lbl];
    [self addSubview:img];
    
    return self;
}

#pragma mark public

-(void)config:(NSIndexPath*)_indexpath
{
    switch(_indexpath.section)
    {
        case 0:
            
            [img setFrame:CGRectMake(20, 0, 65, self.bounds.size.height)];
            [lbl setFrame:CGRectMake(100, 0, screenwidth - 110, self.bounds.size.height)];
            
            switch(_indexpath.item)
            {
                case 0:
                    
                    [img setImage:[[UIImage imageNamed:@"ball"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
                    [img setTintColor:colorblue];
                    [lbl setText:NSLocalizedString(@"instr_sect_0_0", nil)];
                    
                    break;
                    
                case 1:
                    
                    [img setFrame:CGRectMake(20, 50, 220, 30)];
                    [lbl setFrame:CGRectMake(20, 40, screenwidth - 40, self.bounds.size.height - 55)];
                    
                    [img setImage:[[UIImage imageNamed:@"bar"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
                    [img setTintColor:[UIColor colorWithRed:0.7 green:0.9 blue:0 alpha:1]];
                    [lbl setText:NSLocalizedString(@"instr_sect_0_1", nil)];
                    
                    break;
                    
                case 2:
                    
                    [img setImage:[[UIImage imageNamed:@"brick"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
                    [img setTintColor:[UIColor colorWithRed:1 green:0.6 blue:0 alpha:1]];
                    [lbl setText:NSLocalizedString(@"instr_sect_0_2", nil)];
                    
                    break;
                    
                case 3:
                    
                    [img setImage:[[UIImage imageNamed:@"heart"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
                    [img setTintColor:[UIColor colorWithRed:0.8 green:0.86 blue:0.92 alpha:1]];
                    [lbl setText:NSLocalizedString(@"instr_sect_0_3", nil)];
                    
                    break;
                    
                case 4:
                    
                    [img setImage:[[UIImage imageNamed:@"perk_steelball"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
                    [img setTintColor:colorblue];
                    [lbl setText:NSLocalizedString(@"instr_sect_0_4", nil)];
                    
                    break;
            }
            
            break;
            
        case 1:
            
            switch(_indexpath.item)
            {
                case 0:
                    
                    [lbl setFrame:CGRectMake(0, 0, 280, 140)];
                    [lbl setText:NSLocalizedString(@"instr_sect_1_0", nil)];
                    [img setFrame:CGRectZero];
                    
                    break;
                    
                case 1:
                    
                    [lbl setFrame:CGRectZero];
                    [img setFrame:CGRectMake(10, 10, 35, 35)];
                    [img setImage:[[UIImage imageNamed:@"brick"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
                    [img setTintColor:[UIColor colorWithRed:1 green:0.6 blue:0 alpha:1]];
                    
                    break;
                    
                case 2:
                    
                    [lbl setFrame:CGRectZero];
                    [img setFrame:CGRectMake(10, 10, 35, 35)];
                    [img setImage:[[UIImage imageNamed:@"brick"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
                    [img setTintColor:[UIColor colorWithRed:1 green:0.9 blue:0 alpha:1]];
                    
                    break;
                    
                case 3:
                    
                    [lbl setFrame:CGRectZero];
                    [img setFrame:CGRectMake(10, 10, 35, 35)];
                    [img setImage:[[UIImage imageNamed:@"brick"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
                    [img setTintColor:[UIColor colorWithRed:1 green:0.15 blue:0 alpha:1]];
                    
                    break;
                    
                case 4:
                    
                    [lbl setFrame:CGRectZero];
                    [img setFrame:CGRectMake(10, 10, 35, 35)];
                    [img setImage:[[UIImage imageNamed:@"brick"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
                    [img setTintColor:[UIColor colorWithRed:1 green:0.7 blue:0.7 alpha:1]];
                    
                    break;
                    
                case 5:
                    
                    [lbl setFrame:CGRectZero];
                    [img setFrame:CGRectMake(10, 10, 35, 35)];
                    [img setImage:[[UIImage imageNamed:@"brick"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
                    [img setTintColor:[UIColor colorWithRed:1 green:0.4 blue:0.4 alpha:1]];
                    
                    break;
                    
                case 6:
                    
                    [lbl setFrame:CGRectZero];
                    [img setFrame:CGRectMake(10, 10, 35, 35)];
                    [img setImage:[[UIImage imageNamed:@"brick"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
                    [img setTintColor:[UIColor colorWithRed:0.6 green:0.6 blue:0 alpha:1]];
                    
                    break;
                    
                case 7:
                    
                    [lbl setFrame:CGRectZero];
                    [img setFrame:CGRectMake(10, 10, 35, 35)];
                    [img setImage:[[UIImage imageNamed:@"brick"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
                    [img setTintColor:[UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1]];
                    
                    break;
                    
                case 8:
                    
                    [lbl setFrame:CGRectZero];
                    [img setFrame:CGRectMake(10, 10, 35, 35)];
                    [img setImage:[[UIImage imageNamed:@"brick"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
                    [img setTintColor:[UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:1]];
                    
                    break;
                    
                case 9:
                    
                    [lbl setFrame:CGRectZero];
                    [img setFrame:CGRectMake(10, 10, 35, 35)];
                    [img setImage:[[UIImage imageNamed:@"brick"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
                    [img setTintColor:[UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:1]];
                    
                    break;
                    
                case 10:
                    
                    [lbl setFrame:CGRectZero];
                    [img setFrame:CGRectMake(10, 10, 35, 35)];
                    [img setImage:[[UIImage imageNamed:@"brick"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
                    [img setTintColor:[UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1]];
                    
                    break;
            }
            
            break;
            
        case 2:
            
            [img setFrame:CGRectMake(20, 35, 60, 60)];
            [lbl setFrame:CGRectMake(100, 0, screenwidth - 120, 130)];
            
            switch(_indexpath.item)
            {
                case 0:
                    
                    [img setImage:[UIImage imageNamed:@"perk_bigball"]];
                    [lbl setText:NSLocalizedString(@"instr_sect_2_0", nil)];
                    
                    break;
                    
                case 1:
                    
                    [img setImage:[UIImage imageNamed:@"perk_bigbar"]];
                    [lbl setText:NSLocalizedString(@"instr_sect_2_1", nil)];
                    
                    break;
                    
                case 2:
                    
                    [img setImage:[UIImage imageNamed:@"perk_life"]];
                    [lbl setText:NSLocalizedString(@"instr_sect_2_2", nil)];
                    
                    break;
                    
                case 3:
                    
                    [img setImage:[UIImage imageNamed:@"perk_clock"]];
                    [lbl setText:NSLocalizedString(@"instr_sect_2_3", nil)];
                    
                    break;
                    
                case 4:
                    
                    [img setImage:[UIImage imageNamed:@"perk_steelball"]];
                    [lbl setText:NSLocalizedString(@"instr_sect_2_4", nil)];
                    
                    break;
                    
                case 5:
                    
                    [img setImage:[UIImage imageNamed:@"perk_steellife"]];
                    [lbl setText:NSLocalizedString(@"instr_sect_2_5", nil)];
                    
                    break;
            }
            
            break;
    }
}

@end