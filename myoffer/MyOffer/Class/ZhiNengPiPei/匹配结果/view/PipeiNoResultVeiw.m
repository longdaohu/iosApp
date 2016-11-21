//
//  PipeiNoResultVeiw.m
//  myOffer
//
//  Created by xuewuguojie on 2016/11/21.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import "PipeiNoResultVeiw.h"
#define Content_FontSize  18

@interface PipeiNoResultVeiw ()
@property(nonatomic,strong)UIImageView *logoView;
@property(nonatomic,strong)UILabel *contentLab;
@property(nonatomic,strong)UIView *line;
@property(nonatomic,strong)UIButton *pipeiBnt;
@end
@implementation PipeiNoResultVeiw
+ (instancetype)viewWithActionBlock:(PipeiNoResultVeiwBlock)actionBlock{

    PipeiNoResultVeiw *noDataView = [[PipeiNoResultVeiw alloc] initWithFrame:CGRectMake(0, 0, XScreenWidth, XScreenHeight - 64)];

    noDataView.actionBlock = actionBlock;
    
    return noDataView;
}


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    
        UIImageView  *logoView = [[UIImageView alloc] init];
        self.logoView = logoView;
        logoView.contentMode = UIViewContentModeScaleAspectFit;
        logoView.image = XImage(@"pipeiNoData");
        [self addSubview:logoView];
        
        UILabel *contentLab = [UILabel labelWithFontsize:Content_FontSize TextColor:XCOLOR_BLACK TextAlignment:NSTextAlignmentCenter];
        [self addSubview:contentLab];
        contentLab.text = @"木有任何匹配院校哦！\n温馨提示：同学请认真填写背景信息，\n或者加把劲拿个好分数哈~";
        contentLab.numberOfLines = 0;
        self.contentLab = contentLab;
        
        
        UIView *line = [[UIView alloc] init];
        self.line = line;
        line.backgroundColor = XCOLOR_LIGHTGRAY;
        [self addSubview:line];
        
        UIButton *pipeiBnt = [[UIButton alloc] init];
        [self addSubview:pipeiBnt];
        [pipeiBnt setTitle:@"重新评估" forState:UIControlStateNormal];
        [pipeiBnt setTitleColor:XCOLOR_WHITE forState:UIControlStateNormal];
        pipeiBnt.backgroundColor = XCOLOR_RED;
        [pipeiBnt setTitleColor:XCOLOR_LIGHTGRAY forState:UIControlStateHighlighted];
        [pipeiBnt addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
        pipeiBnt.layer.cornerRadius = CORNER_RADIUS;
        self.pipeiBnt = pipeiBnt;
        
        self.backgroundColor = XCOLOR_WHITE;
    }
    return self;
}

- (void)layoutSubviews{

    [super layoutSubviews];
    
    CGSize contentSize  = self.bounds.size;
    
    UIImage *logoImage = XImage(@"pipeiNoData");
    CGFloat logoX = 0;
    CGFloat logoW = contentSize.width - 2 * logoX;
    CGFloat logoH = logoImage.size.height  * logoImage.size.width / logoW;
    CGFloat logoY = contentSize.height - logoH;
    self.logoView.frame = CGRectMake(logoX, logoY, logoW, logoH);
    
    
    CGSize contentLabSize = [self.contentLab.text boundingRectWithSize:CGSizeMake(contentSize.width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:Content_FontSize]} context:nil].size;
    CGFloat contentX = 0;
    CGFloat contentW = contentSize.width - 2 * contentX;
    CGFloat contentH = contentLabSize.height;
    CGFloat contentY = 30;
    self.contentLab.frame = CGRectMake(contentX, contentY, contentW, contentH);
    
    CGFloat lineX = PADDING_TABLEGROUP;
    CGFloat lineW = contentSize.width - 2 * PADDING_TABLEGROUP;
    CGFloat lineH = 1;
    CGFloat lineY = CGRectGetMaxY(self.contentLab.frame) + contentY;
    self.line.frame = CGRectMake(lineX, lineY, lineW, lineH);
    
    CGFloat pipeiBntX = 2 * PADDING_TABLEGROUP;
    CGFloat pipeiBntY = CGRectGetMaxY(self.line.frame) + contentY;
    CGFloat pipeiBntW = contentSize.width - pipeiBntX * 2;
    CGFloat pipeiBntH = 50;
    self.pipeiBnt.frame = CGRectMake(pipeiBntX, pipeiBntY, pipeiBntW, pipeiBntH);
    
    
}

- (void)onClick:(UIButton *)sender{

    if (self.actionBlock) {
        
        self.actionBlock();
    }
    
}




@end
