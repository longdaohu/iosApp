//
//  SMDetailHeaderView.m
//  myOffer
//
//  Created by xuewuguojie on 2017/7/21.
//  Copyright © 2017年 UVIC. All rights reserved.
//

#import "SMDetailHeaderView.h"

@interface SMDetailHeaderView ()
@property(nonatomic,strong)UILabel *titleLab;
@property(nonatomic,strong)UIView *tagsView;
@property(nonatomic,strong)UILabel *intro_Lab;
@property(nonatomic,strong)UIButton *registBtn;
@property(nonatomic,strong)UIView *line;
@property(nonatomic,strong)UIImageView *headView;
@property(nonatomic,strong)UILabel *nameLab;
@property(nonatomic,strong)UILabel *uni_Lab;
@property(nonatomic,strong)UILabel *gest_Lab;
@property(nonatomic,strong)UIView *bottomView;

@end

@implementation SMDetailHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self makeSubViews];
    }
    return self;
}

- (void)makeSubViews{

    self.backgroundColor = XCOLOR_WHITE;
    
    UILabel *titleLab = [UILabel new];
    self.titleLab = titleLab;
    [self addSubview:titleLab];
    titleLab.numberOfLines = 0;
    titleLab.font = [UIFont systemFontOfSize:16];
    titleLab.textColor = XCOLOR_TITLE;
    
    
    UIView *tagsView = [UIView new];
    self.tagsView = tagsView;
    [self addSubview:tagsView];
    
    
    UILabel *intro_Lab = [UILabel new];
    intro_Lab.backgroundColor = XCOLOR_WHITE;
    self.intro_Lab = intro_Lab;
    intro_Lab.numberOfLines = 0;
    [self addSubview:intro_Lab];
    intro_Lab.font = [UIFont systemFontOfSize:12];
    intro_Lab.textColor = XCOLOR_SUBTITLE;
    
    
    UIButton *registBtn = [UIButton new];
    self.registBtn = registBtn;
    [self addSubview:registBtn];
    [registBtn setTitle:@"注册查看完整视频" forState:UIControlStateNormal];
    [registBtn setTitleColor:XCOLOR_WHITE forState:UIControlStateNormal];
    registBtn.backgroundColor = XCOLOR_RED;
    registBtn.layer.cornerRadius = CORNER_RADIUS;
    registBtn.layer.masksToBounds = YES;
    registBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [registBtn addTarget:self action:@selector(toLogin:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *line = [UIView  new];
    line.backgroundColor = XCOLOR_line;
    self.line = line;
    [self addSubview:line];
    
    
    
    UIImageView *headView  = [UIImageView new];
    self.headView = headView;
    [self addSubview:headView];
    
    
    UILabel *nameLab = [UILabel new];
    self.nameLab = nameLab;
    [self addSubview:nameLab];
    nameLab.font = [UIFont systemFontOfSize:16];
    nameLab.textColor = XCOLOR_TITLE;
    
    UILabel *uni_Lab = [UILabel new];
    self.uni_Lab = uni_Lab;
    [self addSubview:uni_Lab];
    uni_Lab.font = [UIFont systemFontOfSize:12];
    uni_Lab.textColor = XCOLOR_SUBTITLE;

    UILabel *gest_Lab = [UILabel new];
    self.gest_Lab = gest_Lab;
    [self addSubview:gest_Lab];
    gest_Lab.numberOfLines = 0;
    gest_Lab.font = [UIFont systemFontOfSize:12];
    gest_Lab.textColor = XCOLOR_SUBTITLE;
    
    UIView *bottomView = [UIView  new];
    bottomView.backgroundColor = XCOLOR_BG;
    self.bottomView = bottomView;
    [self addSubview:bottomView];
    
 }

- (void)setHeader_frame:(SMDetailHeaderFrame *)header_frame{

    _header_frame = header_frame;
    
    SMDetailMedol *detail = header_frame.detailModel;

    
    for (NSInteger index = 0 ; index < detail.tags.count; index++) {
        
        NSValue *tagValue =header_frame.tag_frames[index];
        
        CGRect tagFrame = tagValue.CGRectValue;
        
        UIButton *tagBtn = [[UIButton alloc] initWithFrame:tagFrame];
        [tagBtn setTitle:detail.tags[index]  forState:UIControlStateNormal];
        tagBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        tagBtn.backgroundColor = XCOLOR_BG;
        [tagBtn setTitleColor:XCOLOR_SUBTITLE forState:UIControlStateNormal];
        [self.tagsView addSubview:tagBtn];
        tagBtn.layer.cornerRadius = CORNER_RADIUS;
        tagBtn.layer.masksToBounds =YES;
        
    }
    
    
    self.titleLab.frame = header_frame.title_Frame;
    self.tagsView.frame = header_frame.tagView_Frame;
    self.intro_Lab.frame = header_frame.intro_Frame;
    self.registBtn.frame = header_frame.regist_Frame;
    self.line.frame = header_frame.line_Frame;
    self.headView.frame = header_frame.head_Frame;
    self.nameLab.frame = header_frame.name_Frame;
    self.uni_Lab.frame = header_frame.uni_Frame;
    self.gest_Lab.frame = header_frame.guest_intr_Frame;
    self.bottomView.frame = header_frame.bottom_Frame;
    
    self.mj_h = header_frame.header_height;

    
    
  
    
    NSMutableAttributedString *titleAttr = [[NSMutableAttributedString alloc] initWithString:detail.main_title];
    NSTextAttachment *attach = [[NSTextAttachment alloc] init];
    attach.image = [UIImage imageNamed:header_frame.detailModel.type_name];
    attach.bounds = CGRectMake(0, -5,  attach.image.size.width, attach.image.size.height);
    NSAttributedString *audioAttr = [NSAttributedString attributedStringWithAttachment:attach];
    [titleAttr insertAttributedString:audioAttr atIndex:0];
    self.titleLab.attributedText = titleAttr;
    

    self.intro_Lab.text = detail.introduction;
    [self.headView sd_setImageWithURL:[NSURL URLWithString:detail.guest_head_portrait]];
    self.nameLab.text = detail.guest_name;
    
    self.uni_Lab.text = detail.guest_subject_uni;
    self.gest_Lab.text = detail.guest_introduction;
    
    
}


- (void)toLogin:(UIButton *)sender{

    if (self.actionBlock) {
        
        self.actionBlock();
    }
}


@end

