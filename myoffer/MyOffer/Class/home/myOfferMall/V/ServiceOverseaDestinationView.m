//
//  ServiceOverseaDestinationView.m
//  myOffer
//
//  Created by xuewuguojie on 2017/5/24.
//  Copyright © 2017年 UVIC. All rights reserved.
//

#import "ServiceOverseaDestinationView.h"
#import "ServiceOverSeaDestination.h"

@interface ServiceOverseaDestinationView ()
@property(nonatomic,strong)UIView *line;
@property(nonatomic,strong)UIView *bgView;
@end

@implementation ServiceOverseaDestinationView

+ (instancetype)overseaView{

   return   [[ServiceOverseaDestinationView alloc] initWithFrame:CGRectMake(0, 0, XSCREEN_WIDTH, 0)];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
   
        UIView *line = [[UIView alloc] init];
        self.line = line;
        line.backgroundColor = XCOLOR_BG;
        [self addSubview:line];
        
        UIView *bgView = [[UIView alloc] init];
        self.bgView = bgView;
        [self addSubview:bgView];
        
    }
    return self;
}


- (void)setGroup:(NSArray *)group{

    _group = group;
    
    for(NSInteger index = 0 ;index <  group.count ; index++){
        
        ServiceOverSeaDestination  *sea  = group[index];
        
        UIButton *sender = [[UIButton alloc] init];
        
        [sender setBackgroundImage:XImage(sea.image) forState:UIControlStateNormal];
        
        [sender setTitle:sea.name forState:UIControlStateNormal];
        
        [sender setTitleColor:XCOLOR(0, 0, 0, 0) forState:UIControlStateNormal];
        
        [sender addTarget:self action:@selector(destinationOnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.bgView addSubview:sender];
    }
    
}




- (void)destinationOnClick:(UIButton *)sender{

    if (self.actionBlock) self.actionBlock(sender.currentTitle);
}


- (void)layoutSubviews{

    [super layoutSubviews];
    
    if (self.group.count == 0) return;
    
    
    ServiceOverSeaDestination *item = self.group.firstObject;
    
    UIImage *image = [UIImage imageNamed:item.image];
    
    CGSize contentSize = self.bounds.size;
    
    
    CGFloat margin = 10;
    
    CGFloat W =  (contentSize.width - 3 * margin) * 0.5;
    CGFloat H =  W * (image.size.height / image.size.width);
    CGFloat X = 0;
    CGFloat Y = 0;
    
    for(NSInteger index = 0 ;index < self.bgView.subviews.count ; index++){
        
        UIButton *sender = (UIButton *)self.bgView.subviews[index];
        
        NSInteger  column = index % 2;
        
        NSInteger  row = index / 2;
        
        X = margin + (margin + W) * column;
        
        Y = row * ( H  + margin);
        
        sender.frame = CGRectMake(X, Y, W, H);
    }
    
    
    if (self.bgView.subviews.count > 0) {
        
        UIButton *sender = (UIButton *)self.bgView.subviews[self.group.count - 1];
        
        self.bgView.frame = CGRectMake(0, 0, contentSize.width, CGRectGetMaxY(sender.frame));
        
        self.line.frame = CGRectMake(0, CGRectGetMaxY(self.bgView.frame) + 15, contentSize.width, 15);
        
        self.mj_h =  CGRectGetMaxY( self.line.frame);
        
    }
}



@end
