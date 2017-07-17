#import "appdel.h"

@class vistorecol;
@class modperkelement;

@interface vistore:UIView<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

+(vistore*)show;
-(void)refresh;
-(void)loaddata;
-(void)close;

@property(weak, nonatomic)vistorecol *col;
@property(weak, nonatomic)UIButton *btnclose;
@property(weak, nonatomic)UIButton *btnrestore;

@end

@interface vistorecol:UICollectionView

@property(weak, nonatomic)UICollectionViewFlowLayout *flow;

@end

@interface vistorecel:UICollectionViewCell

-(void)config:(modperkelement*)_perk;

@property(weak, nonatomic)modperkelement *perk;
@property(weak, nonatomic)UIButton *btnbuy;
@property(weak, nonatomic)UILabel *lblname;
@property(weak, nonatomic)UILabel *lblshortdesc;
@property(weak, nonatomic)UILabel *lbllongdesc;
@property(weak, nonatomic)UILabel *lblprice;
@property(weak, nonatomic)UILabel *lblstatedeferred;
@property(weak, nonatomic)UILabel *lblstatepurchasing;

@end