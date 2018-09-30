//
//  RoomItemBookHeaderView.m
//  MyOffer
//
//  Created by xuewuguojie on 2018/8/15.
//  Copyright © 2018年 UVIC. All rights reserved.
//

#import "RoomItemBookHeaderView.h"
#import "Masonry.h"
#import "SDCycleScrollView.h"

@interface RoomItemBookHeaderView ()<SDCycleScrollViewDelegate>
@property(nonatomic,strong)UIView *bgView;
@property(nonatomic,strong)SDCycleScrollView *bannerView;
@property (weak, nonatomic) IBOutlet UIButton *countBtn;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *noteLab;
@property (weak, nonatomic) IBOutlet UIView *line;
@property (weak, nonatomic) IBOutlet UILabel *bedLab;
@property (weak, nonatomic) IBOutlet UILabel *typeLab;
@property (weak, nonatomic) IBOutlet UILabel *sizeLab;

@end

@implementation RoomItemBookHeaderView

- (void)awakeFromNib{
    [super awakeFromNib];
    
    [self.countBtn setTitleColor:XCOLOR_TITLE forState:UIControlStateNormal];
    self.countBtn.backgroundColor = XCOLOR_WHITE;
    self.countBtn.titleLabel.font = XFONT(12);
    self.countBtn.layer.cornerRadius = CORNER_RADIUS;
    
    self.noteLab.textColor = XCOLOR_TITLE;
    self.bedLab.textColor = XCOLOR_TITLE;
    self.typeLab.textColor = XCOLOR_TITLE;
    self.sizeLab.textColor = XCOLOR_TITLE;
    self.line.backgroundColor = XCOLOR_line;
}

- (SDCycleScrollView *)bannerView{
    
    if (!_bannerView) {
        
        _bannerView = [SDCycleScrollView  cycleScrollViewWithFrame:CGRectZero delegate:self placeholderImage:[UIImage imageNamed:@"PlaceHolderImage"]];
        _bannerView.bannerImageViewContentMode =  UIViewContentModeScaleAspectFill;
        _bannerView.showPageControl = false;
        [self insertSubview:_bannerView belowSubview:self.countBtn];
    }
    
    return _bannerView;
}


- (void)setItemFrameModel:(RoomTypeItemFrameModel *)itemFrameModel{
  
    _itemFrameModel = itemFrameModel;
    
    self.titleLab.text = itemFrameModel.item.name;
    self.typeLab.text  = [NSString stringWithFormat:@"%@",itemFrameModel.item.type];
    self.sizeLab.text  = [NSString stringWithFormat:@"%@",itemFrameModel.item.size];
    self.bedLab.text  =  [NSString stringWithFormat:@"%@",itemFrameModel.item.bed];
    self.noteLab.text  = [NSString stringWithFormat:@"%@",itemFrameModel.item.desc];
 
    if (itemFrameModel.item.pictures > 0) {
        self.bannerView.frame = CGRectMake(0, 0, XSCREEN_WIDTH, XSCREEN_WIDTH);
        self.bannerView.imageURLStringsGroup = itemFrameModel.item.pictures;
        
        NSString *count = [NSString stringWithFormat:@"1/%ld",self.itemFrameModel.item.pictures.count];
        [self.countBtn setTitle:count forState:UIControlStateNormal];
    }
    
}


#pragma mark : SDCycleScrollViewDelegate

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index{
    
    NSString *count = [NSString stringWithFormat:@"%ld/%ld",(index+1),self.itemFrameModel.item.pictures.count];
    [self.countBtn setTitle:count forState:UIControlStateNormal];
}




@end
