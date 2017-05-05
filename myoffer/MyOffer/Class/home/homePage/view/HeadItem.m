//
//  HeadItem.m
//  myOffer
//
//  Created by xuewuguojie on 16/3/22.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import "HeadItem.h"

@interface HeadItem ()
@property(nonatomic,strong)UIImageView *iconView;
@property(nonatomic,strong)UILabel *titleLab;
@property(nonatomic,copy)NSString *icon;
@property(nonatomic,copy)NSString *title;

@end

@implementation HeadItem

+ (instancetype)itemInitWithTitle:(NSString *)title imageName:(NSString *)imageName
{
    HeadItem *item = [[HeadItem alloc] init];
    item.title     = title;
    item.icon      = imageName;
    
    return item;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
 
        [self makeUI];
        
    }
    return self;
}


- (void)makeUI{

    UIImageView *iconView  =[[UIImageView alloc] init];
    iconView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:iconView];
    self.iconView = iconView;
    
    self.titleLab  = [UILabel labelWithFontsize:XFONT_SIZE(14) TextColor:XCOLOR_TITLE TextAlignment:NSTextAlignmentCenter];
    [self addSubview:self.titleLab];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClick)];
    [self addGestureRecognizer:tap];
    
    self.backgroundColor = XCOLOR_WHITE;
    
     
}

- (void)setTitle:(NSString *)title
{
    _title             = title;
    
    self.titleLab.text = title;
}

-(void)setIcon:(NSString *)icon
{
    _icon = icon;
    
    self.iconView.image = [UIImage imageNamed:icon];
    
}


- (void)setHeaderFrame:(HomeHeaderFrame *)headerFrame{
    
    _headerFrame = headerFrame;
    
    self.iconView.frame = headerFrame.icon_frame;
    self.titleLab.frame = headerFrame.title_frame;

}

- (void)setMall_header_Frame:(MyOfferServiceMallHeaderFrame *)mall_header_Frame{

    _mall_header_Frame = mall_header_Frame;
    
    self.iconView.frame = mall_header_Frame.icon_frame;
    self.titleLab.frame = mall_header_Frame.title_frame;

}


-(void)onClick{
    
    if (self.actionBlock)  self.actionBlock(self.tag);
    
}

@end
