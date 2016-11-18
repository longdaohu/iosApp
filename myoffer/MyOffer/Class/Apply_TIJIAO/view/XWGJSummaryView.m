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

@interface XWGJSummaryView ()
@property(nonatomic,strong)UILabel *summaryLab;

@end

@implementation XWGJSummaryView

+ (instancetype)ViewWithContent:(NSString *)content{

    
    XWGJSummaryView *sum_View = [[XWGJSummaryView alloc] init];
    
    sum_View.summary = content;
    
    return sum_View;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.summaryLab =[[UILabel alloc] init];
        self.summaryLab.font = [UIFont systemFontOfSize:LabFont];
        self.summaryLab.numberOfLines = 0;
        self.summaryLab.lineBreakMode = NSLineBreakByCharWrapping;
        [self addSubview:self.summaryLab];

        UIView *line = [[UIView alloc] init];
        line.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:line];
        self.line = line;
        line.hidden = YES;
     
    }
    return self;
}

-(void)setSummary:(NSString *)summary
{
    _summary = summary;
   
    self.summaryLab.text = summary;
    
    CGSize contentSize = [summary boundingRectWithSize:CGSizeMake(XScreenWidth - PADDING * 2, MAXFLOAT)
                                         options:NSStringDrawingUsesLineFragmentOrigin
                                      attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:LabFont]}
                                         context:NULL].size;
    
    self.summaryLab.frame = CGRectMake(PADDING, ITEM_MARGIN, XScreenWidth - PADDING * 2, contentSize.height);
    
    self.frame = CGRectMake(0, 0, XScreenWidth, contentSize.height + 2 * ITEM_MARGIN);

    self.line.frame = CGRectMake(PADDING, CGRectGetMaxY(self.frame)-1, XScreenWidth - PADDING * 2, 1);
}



@end

