#import "vistore.h"

@implementation vistore

@synthesize col;
@synthesize btnclose;
@synthesize btnrestore;

+(vistore*)show
{
    vistore *store = [[vistore alloc] init];
    [[ctrmain sha].view addSubview:store];
    [store animateshow];
    
    return store;
}

-(vistore*)init
{
    self = [super initWithFrame:screenrect];
    [self setClipsToBounds:YES];
    [self setAlpha:0];
    
    if([UIVisualEffectView class])
    {
        UIVisualEffectView *blur = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
        [blur setFrame:screenrect];
        [blur setUserInteractionEnabled:NO];
        
        [self setBackgroundColor:[UIColor colorWithWhite:1 alpha:0.8]];
        [self addSubview:blur];
    }
    else
    {
        [self setBackgroundColor:[UIColor colorWithWhite:1 alpha:0.97]];
    }
    
    UIButton *strongbtnclose = [[UIButton alloc] initWithFrame:CGRectMake(15, 25, 70, 32)];
    btnclose = strongbtnclose;
    [btnclose setClipsToBounds:YES];
    [btnclose setBackgroundColor:colorred];
    [btnclose setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnclose setTitleColor:[UIColor colorWithWhite:0.6 alpha:1] forState:UIControlStateHighlighted];
    [btnclose setTitle:NSLocalizedString(@"store_close_btn", nil) forState:UIControlStateNormal];
    [btnclose.titleLabel setFont:[UIFont fontWithName:fontname size:12]];
    [btnclose.layer setCornerRadius:6];
    [btnclose addTarget:self action:@selector(actionclose) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:btnclose];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refresh) name:notpurchaseupd object:nil];
    
    return self;
}

#pragma mark actions

-(void)actionclose
{
    [self animatehide];
}

-(void)actionrestore
{
    [[skman sha] restorepurchases];
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

#pragma mark public

-(void)refresh
{
    dispatch_async(dispatch_get_main_queue(),
                   ^(void)
                   {
                       [col reloadData];
                   });
}

-(void)loaddata
{
    vistorecol *strongcol = [[vistorecol alloc] init];
    col = strongcol;
    [col setDataSource:self];
    [col setDelegate:self];
    
    UIButton *strongbtnrestore = [[UIButton alloc] initWithFrame:CGRectMake(screenwidth_2 - 90, 25, 180, 32)];
    btnrestore = strongbtnrestore;
    [btnrestore setBackgroundColor:colorblue];
    [btnrestore setClipsToBounds:YES];
    [btnrestore setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnrestore setTitleColor:[UIColor colorWithWhite:0.6 alpha:1] forState:UIControlStateHighlighted];
    [btnrestore setTitle:NSLocalizedString(@"store_restore_btn", nil) forState:UIControlStateNormal];
    [btnrestore.titleLabel setFont:[UIFont fontWithName:fontname size:14]];
    [btnrestore.layer setCornerRadius:6];
    [btnrestore addTarget:self action:@selector(actionrestore) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:btnrestore];
    [self addSubview:col];
}

-(void)close
{
    [self animatehide];
}

#pragma mark -
#pragma mark col del

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView*)_col
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView*)_col numberOfItemsInSection:(NSInteger)_section
{
    return [[modperks sha] count];
}

-(UICollectionViewCell*)collectionView:(UICollectionView*)_col cellForItemAtIndexPath:(NSIndexPath*)_index
{
    vistorecel *cel = [_col dequeueReusableCellWithReuseIdentifier:celid forIndexPath:_index];
    [cel config:[[modperks sha] perk:_index.item]];
    
    return cel;
}

@end

@implementation vistorecol

@synthesize flow;

-(vistorecol*)init
{
    self = [super initWithFrame:CGRectMake(0, 70, screenwidth, screenheight - 70) collectionViewLayout:[[UICollectionViewFlowLayout alloc] init]];
    [self setBackgroundColor:[UIColor clearColor]];
    [self setClipsToBounds:YES];
    [self setShowsHorizontalScrollIndicator:NO];
    [self registerClass:[vistorecel class] forCellWithReuseIdentifier:celid];
    
    NSInteger padding = (screenwidth - 280) / 2;
    flow = (UICollectionViewFlowLayout*)self.collectionViewLayout;
    [flow setFooterReferenceSize:CGSizeZero];
    [flow setHeaderReferenceSize:CGSizeZero];
    [flow setItemSize:CGSizeMake(280, 450)];
    [flow setMinimumInteritemSpacing:0];
    [flow setMinimumLineSpacing:0];
    [flow setScrollDirection:UICollectionViewScrollDirectionVertical];
    [flow setSectionInset:UIEdgeInsetsMake(30, padding, 30, padding)];
    
    return self;
}

@end

@implementation vistorecel
{
    NSDictionary *attr;
    CGSize boundingsize;
}

@synthesize perk;
@synthesize btnbuy;
@synthesize lblname;
@synthesize lblshortdesc;
@synthesize lbllongdesc;
@synthesize lblprice;
@synthesize lblstatedeferred;
@synthesize lblstatepurchasing;

-(vistorecel*)initWithFrame:(CGRect)_rect
{
    self = [super initWithFrame:_rect];
    [self setClipsToBounds:YES];
    [self setBackgroundColor:[UIColor clearColor]];
    
    UILabel *stronglblname = [[UILabel alloc] initWithFrame:CGRectMake(35, 2, _rect.size.width - 40, 20)];
    lblname = stronglblname;
    [lblname setBackgroundColor:[UIColor clearColor]];
    [lblname setFont:[UIFont fontWithName:fontname size:16]];
    [lblname setTextColor:[UIColor colorWithWhite:0.2 alpha:1]];
    [lblname setUserInteractionEnabled:NO];
    
    UILabel *stronglblshortdesc = [[UILabel alloc] initWithFrame:CGRectMake(35, 22, _rect.size.width - 40, 14)];
    lblshortdesc = stronglblshortdesc;
    [lblshortdesc setBackgroundColor:[UIColor clearColor]];
    [lblshortdesc setFont:[UIFont fontWithName:fontname size:11]];
    [lblshortdesc setTextColor:[UIColor colorWithWhite:0.6 alpha:1]];
    [lblshortdesc setUserInteractionEnabled:NO];
    
    UILabel *stronglbllongdesc = [[UILabel alloc] initWithFrame:CGRectMake(5, 45, _rect.size.width - 10, 300)];
    lbllongdesc = stronglbllongdesc;
    [lbllongdesc setBackgroundColor:[UIColor clearColor]];
    [lbllongdesc setFont:[UIFont fontWithName:fontname size:14]];
    [lbllongdesc setTextColor:[UIColor colorWithWhite:0.4 alpha:1]];
    [lbllongdesc setUserInteractionEnabled:NO];
    [lbllongdesc setNumberOfLines:0];
    
    boundingsize = CGSizeMake(lbllongdesc.frame.size.width, 3000);
    attr = @{NSFontAttributeName:lbllongdesc.font};
    
    UILabel *stronglblprice = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, _rect.size.width - 10, 20)];
    lblprice = stronglblprice;
    [lblprice setBackgroundColor:[UIColor clearColor]];
    [lblprice setTextColor:colorred];
    [lblprice setFont:[UIFont fontWithName:fontname size:18]];
    [lblprice setUserInteractionEnabled:NO];
    
    UIButton *strongbtnbuy = [[UIButton alloc] initWithFrame:CGRectMake(5, 0, 110, 34)];
    btnbuy = strongbtnbuy;
    [btnbuy setBackgroundColor:colorblue];
    [btnbuy setClipsToBounds:YES];
    [btnbuy setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnbuy setTitleColor:[UIColor colorWithWhite:0.8 alpha:1] forState:UIControlStateHighlighted];
    [btnbuy setTitle:NSLocalizedString(@"perksview_btnbuy", nil) forState:UIControlStateNormal];
    [btnbuy.titleLabel setFont:[UIFont fontWithName:fontname size:16]];
    [btnbuy.layer setCornerRadius:6];
    [btnbuy addTarget:self action:@selector(actionpurchase) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *stronglblstatedeferred = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, 290, 34)];
    lblstatedeferred = stronglblstatedeferred;
    [lblstatedeferred setBackgroundColor:[UIColor clearColor]];
    [lblstatedeferred setFont:[UIFont fontWithName:fontname size:14]];
    [lblstatedeferred setTextColor:colorblue];
    [lblstatedeferred setUserInteractionEnabled:NO];
    [lblstatedeferred setText:NSLocalizedString(@"perksview_deferred", nil)];
    
    UILabel *stronglblstatepurchasing = [[UILabel alloc] initWithFrame:lblstatedeferred.frame];
    lblstatepurchasing = stronglblstatepurchasing;
    [lblstatepurchasing setBackgroundColor:[UIColor clearColor]];
    [lblstatepurchasing setFont:[UIFont fontWithName:fontname size:14]];
    [lblstatepurchasing setTextColor:colorblue];
    [lblstatepurchasing setUserInteractionEnabled:NO];
    [lblstatepurchasing setText:NSLocalizedString(@"perksview_purchasing", nil)];
    
    [self addSubview:lblname];
    [self addSubview:lblshortdesc];
    [self addSubview:lbllongdesc];
    [self addSubview:lblprice];
    [self addSubview:lblstatedeferred];
    [self addSubview:lblstatepurchasing];
    [self addSubview:btnbuy];
    
    return self;
}

-(void)drawRect:(CGRect)_rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 2);
    CGContextSetStrokeColorWithColor(context, self.tintColor.CGColor);
    CGContextSetFillColorWithColor(context, self.tintColor.CGColor);
    CGContextAddEllipseInRect(context, CGRectMake(5, 5, 20, 20));
    CGContextDrawPath(context, kCGPathStroke);
    
    switch(perk.status)
    {
        case perkstatusnew:
            
            CGContextMoveToPoint(context, 11, 11);
            CGContextAddLineToPoint(context, 19, 19);
            CGContextMoveToPoint(context, 19, 11);
            CGContextAddLineToPoint(context, 11, 19);
            
            break;
            
        case perkstatuspurchased:
            
            CGContextMoveToPoint(context, 11, 17);
            CGContextAddLineToPoint(context, 15, 19);
            CGContextAddLineToPoint(context, 19, 11);
            
            break;
            
        default:
            
            CGContextMoveToPoint(context, 15, 8);
            CGContextAddLineToPoint(context, 15, 15);
            CGContextAddLineToPoint(context, 22, 15);
            
            break;
    }
    
    CGContextDrawPath(context, kCGPathStroke);
}

-(void)actionpurchase
{
    perk.status = perkstatuspurchasing;
    [self updateui];
    [perk purchase];
}

#pragma mark functionality

-(void)updateui
{
    switch(perk.status)
    {
        case perkstatusnew:
            
            [btnbuy setHidden:NO];
            [self setTintColor:[UIColor colorWithWhite:0.9 alpha:1]];
            [lblstatedeferred setHidden:YES];
            [lblstatepurchasing setHidden:YES];
            [lblprice setHidden:NO];
            
            break;
            
        case perkstatuspurchased:
            
            [btnbuy setHidden:YES];
            [self setTintColor:colorblue];
            [lblstatedeferred setHidden:YES];
            [lblstatepurchasing setHidden:YES];
            [lblprice setHidden:YES];
            
            break;
            
        case perkstatusdeferred:
            
            [btnbuy setHidden:YES];
            [lblstatedeferred setHidden:NO];
            [lblstatepurchasing setHidden:YES];
            [lblprice setHidden:NO];
            
            break;
            
        case perkstatuspurchasing:
            
            [btnbuy setHidden:YES];
            [lblstatedeferred setHidden:YES];
            [lblstatepurchasing setHidden:NO];
            [lblprice setHidden:NO];
            
            break;
    }
    
    [self setNeedsDisplay];
}

#pragma mark public

-(void)config:(modperkelement*)_perk
{
    perk = _perk;
    [lblname setText:perk.name];
    [lblshortdesc setText:perk.shortdescription];
    [lbllongdesc setText:perk.longdescription];
    [lblprice setText:perk.strprice];
    
    CGFloat descheight = [perk.longdescription boundingRectWithSize:boundingsize options:stringdrawing attributes:attr context:nil].size.height;
    CGRect rectlbllong = CGRectMake(lbllongdesc.frame.origin.x, lbllongdesc.frame.origin.y, lbllongdesc.bounds.size.width, descheight);
    CGRect rectlblprice = CGRectMake(lblprice.frame.origin.x, CGRectGetMaxY(rectlbllong) + 15, lblprice.bounds.size.width, lblprice.bounds.size.height);
    CGRect rectbtnbuy = CGRectMake(btnbuy.frame.origin.x, CGRectGetMaxY(rectlblprice) + 10, btnbuy.bounds.size.width, btnbuy.bounds.size.height);
    CGRect rectlbl = CGRectMake(lblstatedeferred.frame.origin.x, rectbtnbuy.origin.y, lblstatedeferred.bounds.size.width, lblstatedeferred.bounds.size.height);
    [lbllongdesc setFrame:rectlbllong];
    [lblprice setFrame:rectlblprice];
    [btnbuy setFrame:rectbtnbuy];
    [lblstatedeferred setFrame:rectlbl];
    [lblstatepurchasing setFrame:rectlbl];
    
    [self updateui];
}

@end