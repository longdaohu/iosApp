//
//  RoomTextSpodCell.m
//  MyOffer
//
//  Created by xuewuguojie on 2018/8/14.
//  Copyright © 2018年 UVIC. All rights reserved.
//

#import "RoomTextSpodCell.h"

@interface RoomTextSpodCell ()
@property(nonatomic,strong)UIImageView *spodView;

@end

@implementation RoomTextSpodCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        UIImageView *spodView = [UIImageView new];
        spodView.image = XImage(@"blue_spod_home");
        spodView.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:spodView];
        self.spodView = spodView;
        
    }
    
    return  self;
}


- (void)layoutSubviews{
    [super layoutSubviews];
    
    if (self.itemFrameModel) {
         self.spodView.frame = self.itemFrameModel.promotion_spod_frame;
         self.textLabel.frame = self.itemFrameModel.promotion_frame;
    }
}




@end
