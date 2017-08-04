//
//  SMDetailHeaderView.m
//  myOffer
//
//  Created by xuewuguojie on 2017/7/21.
//  Copyright © 2017年 UVIC. All rights reserved.
//

#import "SMDetailHeaderView.h"
#import "myofferTextView.h"
#import <CoreText/CoreText.h>

@interface SMDetailHeaderView ()<UITextViewDelegate>

@property(nonatomic,strong)UILabel *titleLab;
@property(nonatomic,strong)UIView *tagsView;
@property(nonatomic,strong)UILabel *intro_Lab;
@property(nonatomic,strong)UIButton *registBtn;
@property(nonatomic,strong)UIView *line;
@property(nonatomic,strong)UIImageView *headView;
@property(nonatomic,strong)UILabel *nameLab;
@property(nonatomic,strong)UILabel *uni_Lab;
@property(nonatomic,strong)myofferTextView *gest_Lab;
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
    //1 标题
    UILabel *titleLab = [UILabel new];
    self.titleLab = titleLab;
    [self addSubview:titleLab];
    titleLab.numberOfLines = 0;
    titleLab.font = [UIFont systemFontOfSize:16];
    titleLab.textColor = XCOLOR_TITLE;
    
    //2 标签
    UIView *tagsView = [UIView new];
    self.tagsView = tagsView;
    [self addSubview:tagsView];
    
    //3 活动介绍
    UILabel *intro_Lab = [UILabel new];
    self.intro_Lab = intro_Lab;
    intro_Lab.numberOfLines = 0;
    [self addSubview:intro_Lab];
    intro_Lab.font = [UIFont systemFontOfSize:12];
    intro_Lab.textColor = XCOLOR_SUBTITLE;
    
    //4 注册按钮
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
    
    //5 分割线
    UIView *line = [UIView  new];
    line.backgroundColor = XCOLOR_line;
    self.line = line;
    [self addSubview:line];
    
    //6 头像
    UIImageView *headView  = [UIImageView new];
    self.headView = headView;
    headView.backgroundColor = XCOLOR_BG;
    [self addSubview:headView];
    
    //7 用户名
    UILabel *nameLab = [UILabel new];
    self.nameLab = nameLab;
    [self addSubview:nameLab];
    nameLab.font = [UIFont systemFontOfSize:16];
    nameLab.textColor = XCOLOR_TITLE;
    
    //8 学校名称
    UILabel *uni_Lab = [UILabel new];
    self.uni_Lab = uni_Lab;
    [self addSubview:uni_Lab];
    uni_Lab.font = [UIFont systemFontOfSize:12];
    uni_Lab.textColor = XCOLOR_SUBTITLE;

    //9 用户介绍
    myofferTextView *gest_Lab = [myofferTextView new];
    self.gest_Lab = gest_Lab;
    gest_Lab.editable = NO;//不可编辑
    gest_Lab.scrollEnabled = NO;//不可滚动
    gest_Lab.textContainerInset = UIEdgeInsetsMake(0, -5, 0, 0);//设置页边距
    gest_Lab.font = [UIFont systemFontOfSize:12];
    [self addSubview:gest_Lab];
    gest_Lab.delegate = self;
 
    
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
    self.headView.layer.cornerRadius = self.headView.mj_h * 0.5;
    self.headView.layer.masksToBounds =YES;
    self.nameLab.frame = header_frame.name_Frame;
    self.uni_Lab.frame = header_frame.uni_Frame;
    self.bottomView.frame = header_frame.bottom_Frame;
    
    
    if (!header_frame.detailModel.guest_intr_ShowAll) {
        self.gest_Lab.frame = header_frame.guest_hiden_Frame;
    }else{
        self.gest_Lab.frame = header_frame.guest_show_Frame;
    }
    
    self.mj_h = header_frame.header_height;

    
    [self.headView sd_setImageWithURL:[NSURL URLWithString:detail.guest_head_portrait]];
    self.nameLab.text = detail.guest_name;
    self.uni_Lab.text = detail.guest_subject_uni;
  
    //1 标题
    NSMutableAttributedString *titleAttr = [[NSMutableAttributedString alloc] initWithString:detail.main_title];
    
    NSTextAttachment *attach = [[NSTextAttachment alloc] init];
    attach.image = [UIImage imageNamed:header_frame.detailModel.type_imageName];
    attach.bounds = CGRectMake(0, -5,  attach.image.size.width, attach.image.size.height);
    NSAttributedString *audioAttribute = [NSAttributedString attributedStringWithAttachment:attach];
    
    [titleAttr insertAttributedString:audioAttribute atIndex:0];
    
    self.titleLab.attributedText = titleAttr;
    

    //2 活动介绍
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.minimumLineHeight = 18;
    
    NSMutableDictionary *huodong_attributes = [NSMutableDictionary dictionary];
    [huodong_attributes setValue:[UIFont systemFontOfSize:12]  forKey:NSFontAttributeName];
    [huodong_attributes setValue:paragraphStyle forKey:NSParagraphStyleAttributeName];
    self.intro_Lab.attributedText = [[NSAttributedString alloc] initWithString:detail.introduction attributes:huodong_attributes];
  
 
 
   //3 用户介绍
    self.gest_Lab.attributedText = [[NSAttributedString alloc] initWithString:detail.guest_introduction attributes:huodong_attributes];
    
    if (!detail.guest_intr_ShowAll) {
        
       
        NSDictionary *nomal_attributes = [NSDictionary dictionaryWithDictionary:huodong_attributes];
        [huodong_attributes setValue:@"http://baidu.com" forKey:NSLinkAttributeName];
        
        NSMutableAttributedString *more_attributeStr = [[NSMutableAttributedString alloc] initWithString:detail.guest_intr_short_sub attributes:nomal_attributes];
        [more_attributeStr setAttributes:huodong_attributes range:NSMakeRange(detail.guest_intr_short_sub.length - 4,4)];

        
        self.gest_Lab.linkTextAttributes = @{NSForegroundColorAttributeName : XCOLOR_LIGHTBLUE};
        self.gest_Lab.attributedText = more_attributeStr;
        
    }

    self.gest_Lab.textColor = XCOLOR_SUBTITLE;
  
}


- (void)toLogin:(UIButton *)sender{

    if (self.actionBlock)  self.actionBlock(nil,sender);
    
}

- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange interaction:(UITextItemInteraction)interaction {
    
    if (self.actionBlock) self.actionBlock(YES,nil);
    
    return NO;
}

- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange {

    if (self.actionBlock) self.actionBlock(YES,nil);

    return NO;
}




@end

