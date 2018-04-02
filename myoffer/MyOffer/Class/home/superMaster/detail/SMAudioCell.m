//
//  SMAudioCell.m
//  myOffer
//
//  Created by xuewuguojie on 2017/7/21.
//  Copyright © 2017年 UVIC. All rights reserved.
//

#import "SMAudioCell.h"
@interface SMAudioCell ()

@property(nonatomic,strong)UIButton *playBtn;
@property(nonatomic,strong)UIButton *statusBtn;
@property(nonatomic,strong)UILabel *nameLab;
@property(nonatomic,strong)UILabel *timeLab;
@property(nonatomic,strong)UIView *bottom_line;
@property(nonatomic,strong)NSIndexPath *indexPath;

@end


@implementation SMAudioCell

static NSString *identify = @"sm_audio";

+ (instancetype)cellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath{
    
    SMAudioCell *cell =[tableView dequeueReusableCellWithIdentifier:identify];
    
    if (!cell) {
        
        cell =[[SMAudioCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }
    
    cell.indexPath = indexPath;
    
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        [self makeUI];
        
    }
    
    return self;
}


- (void)makeUI{
    
    
    UIButton *play = [UIButton new];
    [play setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
    self.playBtn = play;
    [self.contentView addSubview:play];
    
    
    UIButton *statusBtn = [UIButton new];
    [statusBtn setTitleColor:XCOLOR_LIGHTBLUE forState:UIControlStateNormal];
    statusBtn.titleLabel.font = [UIFont systemFontOfSize:11];
    [statusBtn setImage:[UIImage imageNamed:@"sm_lock_tag"] forState:UIControlStateDisabled];
    self.statusBtn = statusBtn;
    [self.contentView addSubview:statusBtn];


    UILabel *nameLab = [[UILabel alloc] init];
    nameLab.font = [UIFont systemFontOfSize:14];
    nameLab.textColor = XCOLOR_TITLE;
    self.nameLab = nameLab;
    [self.contentView addSubview:nameLab];
    
    
    UILabel *timeLab = [[UILabel alloc] init];
    timeLab.font = [UIFont systemFontOfSize:12];
    timeLab.textColor = XCOLOR_SUBTITLE;
    self.timeLab = timeLab;
    [self.contentView addSubview:timeLab];

    
    UIView *bottom_line = [UIView  new];
    bottom_line.backgroundColor = XCOLOR_line;
    self.bottom_line = bottom_line;
    [self.contentView addSubview:bottom_line];

}

- (void)setAudioFrame:(SMAudioItemFrame *)audioFrame{

    _audioFrame = audioFrame;
    
    self.playBtn.frame = audioFrame.play_Frame;
    self.statusBtn.frame = audioFrame.icon_Frame;
    self.nameLab.frame = audioFrame.name_Frame;
    self.timeLab.frame = audioFrame.time_Frame;
    self.bottom_line.frame = audioFrame.bottom_line_Frame;
    

    [self.playBtn setImage:[UIImage imageNamed:audioFrame.item.play_imageName] forState:UIControlStateNormal];
    [self.statusBtn setTitle:audioFrame.item.status_title forState:UIControlStateNormal];
    self.statusBtn.enabled = audioFrame.item.isCanPlay;
    self.nameLab.text = [NSString stringWithFormat:@"%ld.%@",(long)self.indexPath.row + 1,audioFrame.item.name];
    self.timeLab.text = audioFrame.item.duration;
 
}


- (void)bottomLineWithHiden:(BOOL)hiden{

    self.bottom_line.hidden = hiden;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
