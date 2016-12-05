#import "XWGJnodataView.h"
@interface XWGJnodataView ()
@property (weak, nonatomic) IBOutlet UIImageView *DuangImageView;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@end

@implementation XWGJnodataView

+(instancetype)noDataView
{
    
    XWGJnodataView *noData =[[NSBundle mainBundle] loadNibNamed:@"XWGJnodataView" owner:self options:nil].lastObject;
    
    noData.frame = CGRectMake(0, -64, XScreenWidth, XScreenHeight);
    
    noData.contentLabel.text = GDLocalizedString(@"NetRequest-noNetWork");

    return noData;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        
    }
    return self;
}

-(void)setErrorStr:(NSString *)errorStr{

    _errorStr = errorStr;
    
    self.contentLabel.text = errorStr;

}



@end


