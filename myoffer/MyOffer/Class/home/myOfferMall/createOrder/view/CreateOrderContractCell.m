//
//  CreateOrderContractCell.m
//  MyOffer
//
//  Created by xuewuguojie on 2018/7/3.
//  Copyright © 2018年 UVIC. All rights reserved.
//

#import "CreateOrderContractCell.h"

@interface CreateOrderContractCell ()

@property(nonatomic,strong)UILabel *titleLab;
@property(nonatomic,strong)UIImageView *iconView;
@property(nonatomic,strong)UILabel *subLab;
@property(nonatomic,strong)UIButton *statusBtn;
@property(nonatomic,strong)UIButton *lookBtn;
@property(nonatomic,strong)UIButton *downloadBtn;

@end

@implementation CreateOrderContractCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UILabel *titleLab = [UILabel new];
        titleLab.text = @"合同信息";
        self.titleLab = titleLab;
        titleLab.font = XFONT(16);
        titleLab.textColor = XCOLOR_BLACK;
        [self.contentView addSubview:titleLab];
        
        UILabel *subLab = [UILabel new];
        subLab.text = @"合同名称：《留学产品合同》";
        self.subLab = subLab;
        subLab.font = XFONT(12);
        subLab.textColor = XCOLOR(187, 187, 187, 1);
        [self.contentView addSubview:subLab];
        
        UIImageView *iconView = [UIImageView new];
        self.iconView = iconView;
        iconView.image = XImage(@"common_icon_arrow");
        [self.contentView addSubview:iconView];
        
        UIButton *statusBtn = [UIButton new];
        statusBtn.titleLabel.font = XFONT(12);
        [statusBtn setTitle:@"未签署" forState:UIControlStateNormal];
        [statusBtn setTitle:@"已签署" forState:UIControlStateSelected];
        [statusBtn setImage:XImage(@"UnsignedContract") forState:UIControlStateNormal];
        [statusBtn setImage:XImage(@"check-icons-yes") forState:UIControlStateSelected];
        [statusBtn setTitleColor:XCOLOR(187, 187, 187, 1) forState:UIControlStateNormal];
        self.statusBtn = statusBtn;
        [statusBtn.imageView setContentMode:UIViewContentModeScaleAspectFit];
        [self.contentView addSubview:statusBtn];
        [statusBtn sizeToFit];
        statusBtn.userInteractionEnabled = NO;

        UIButton *lookBtn = [UIButton new];
        lookBtn.titleLabel.font = XFONT(12);
        [lookBtn setTitleColor:XCOLOR(51, 51, 51, 1) forState:UIControlStateNormal];
        [lookBtn addTarget:self action:@selector(look) forControlEvents:UIControlEventTouchUpInside];
        lookBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        self.lookBtn = lookBtn;
        [self.contentView addSubview:lookBtn];
        NSString *look = @"查看";
        NSDictionary *attribtDic = @{ NSUnderlineStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
        NSMutableAttributedString *attribt_look = [[NSMutableAttributedString alloc] initWithString:look];
        [attribt_look addAttributes:attribtDic range:NSMakeRange(0, look.length)];
        [lookBtn setAttributedTitle:attribt_look forState:UIControlStateNormal];
        
        UIButton *downloadBtn = [UIButton new];
        NSString *down = @"下载";
        NSString *downing = @"下载中";
        NSString *downed = @"下载完成";
        NSMutableAttributedString *attribt_down = [[NSMutableAttributedString alloc] initWithString:down];
        [attribt_down addAttributes:attribtDic range:NSMakeRange(0, down.length)];
        NSMutableAttributedString *attribt_downing = [[NSMutableAttributedString alloc] initWithString:downing];
        [attribt_downing addAttributes:attribtDic range:NSMakeRange(0, downing.length)];
        NSMutableAttributedString *attribt_downed = [[NSMutableAttributedString alloc] initWithString:downed];
        [attribt_downed addAttributes:attribtDic range:NSMakeRange(0, downed.length)];
        [downloadBtn setAttributedTitle:attribt_down forState:UIControlStateNormal];
        [downloadBtn setAttributedTitle:attribt_downing forState:UIControlStateSelected];
        [downloadBtn setAttributedTitle:attribt_downed forState:UIControlStateDisabled];
        downloadBtn.titleLabel.font = XFONT(12);
        [downloadBtn setTitleColor:XCOLOR(51, 51, 51, 1)  forState:UIControlStateNormal];
        [downloadBtn addTarget:self action:@selector(downLoad) forControlEvents:UIControlEventTouchUpInside];
        self.downloadBtn = downloadBtn;
        [self.contentView addSubview:downloadBtn];

    }
    
    return self;
}

- (void)setContactStatus:(BOOL)contactStatus{
    _contactStatus = contactStatus;
    
    self.statusBtn.selected = contactStatus;
    self.iconView.hidden = contactStatus;
}

- (void)setType:(CreateOrderContractDownloadStyle)type{
    
    _type = type;

    switch (type) {
        case CreateOrderContractDownloadStyleLoaded:
            self.downloadBtn.enabled = NO;
            break;
        case CreateOrderContractDownloadStyleLoading:
            self.downloadBtn.selected = YES;
            break;
        default:
            break;
    }
}

- (void)look{
    if (self.actionBlock) {
        self.actionBlock(NO);
    }
}
- (void)downLoad{
    
    //下载中 、 下载完成都不可以再点击
    if (self.type != CreateOrderContractDownloadStyleNomal) return;
    if (self.actionBlock) {
        self.actionBlock(YES);
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGSize content_size  = self.contentView.bounds.size;
    
    CGFloat title_x = 15;
    CGFloat title_y = 15;
    CGFloat title_w = content_size.width;
    CGFloat title_h = self.titleLab.font.lineHeight;
    self.titleLab.frame = CGRectMake(title_x, title_y, title_w, title_h);
    
    CGFloat icon_y = 15;
    CGFloat icon_w = 17;
    CGFloat icon_h = 17;
    CGFloat icon_x = content_size.width - icon_w - 15;
    self.iconView.frame = CGRectMake(icon_x, icon_y, icon_w, icon_h);
    
    CGFloat sub_x = title_x;
    CGFloat sub_y = title_y + title_h + 5;
    CGSize sub_size = [self.subLab.text stringWithfontSize:12];
    CGFloat sub_w = sub_size.width;
    CGFloat sub_h = sub_size.height;
    self.subLab.frame = CGRectMake(sub_x, sub_y, sub_w, sub_h);
    
    CGFloat status_w = self.statusBtn.mj_w;
    CGFloat status_h = sub_h;
    CGFloat status_y = sub_y;
    CGFloat status_x = sub_x + sub_w + 5;
    self.statusBtn.frame = CGRectMake(status_x, status_y, status_w, status_h);
    
    if (self.contactStatus) {
        
        CGFloat look_w = 60;
        CGFloat look_h = sub_h + 16;
        CGFloat look_y = sub_y + sub_h - 3;
        CGFloat look_x = sub_x;
        self.lookBtn.frame = CGRectMake(look_x, look_y, look_w, look_h);
        
        CGFloat dl_w = 60;
        CGFloat dl_h = look_h;
        CGFloat dl_y = look_y;
        CGFloat dl_x = look_x +  look_w;
        self.downloadBtn.frame = CGRectMake(dl_x, dl_y, dl_w, dl_h);
    
    }
    
}


@end
