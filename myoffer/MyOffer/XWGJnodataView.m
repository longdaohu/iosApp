#import "XWGJnodataView.h"

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


@end
