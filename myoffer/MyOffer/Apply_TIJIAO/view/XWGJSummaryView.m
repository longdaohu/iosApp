//
//  XWGJSummaryView.m
//  myOffer
//
//  Created by sara on 16/3/3.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import "XWGJSummaryView.h"
#define LabFont 16
#define PADDING 15

@implementation XWGJSummaryView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.summaryLab =[[UILabel alloc] init];
        self.summaryLab.font = [UIFont systemFontOfSize:LabFont];
        self.summaryLab.numberOfLines = 0;
        self.summaryLab.lineBreakMode = NSLineBreakByCharWrapping;
        [self addSubview:self.summaryLab];
     }
    return self;
}

-(void)setSummary:(NSString *)summary
{
    _summary = summary;
   
    self.summaryLab.text = summary;
    
    CGSize LabSize = [summary boundingRectWithSize:CGSizeMake(XScreenWidth - 30, 999)
                                         options:NSStringDrawingUsesLineFragmentOrigin
                                      attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:LabFont]}
                                         context:NULL].size;
    
    self.summaryLab.frame = CGRectMake(PADDING, ITEM_MARGIN, XScreenWidth - PADDING * 2, LabSize.height);
    
}



@end
