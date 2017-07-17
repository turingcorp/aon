#import "appdel.h"

@class viinstrscol;

@interface viinstrs:UIView<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

+(void)show;

@property(weak, nonatomic)viinstrscol *col;
@property(weak, nonatomic)UIButton *btnclose;
@property(weak, nonatomic)UILabel *lbltitle;

@end

@interface viinstrscol:UICollectionView

@property(weak, nonatomic)UICollectionViewFlowLayout *flow;

@end

@interface viinstrsheader:UICollectionReusableView

@property(weak, nonatomic)UILabel *lbltitle;

@end

@interface viinstrscel:UICollectionViewCell

-(void)config:(NSIndexPath*)_indexpath;

@property(weak, nonatomic)UIImageView *img;
@property(weak, nonatomic)UILabel *lbl;

@end