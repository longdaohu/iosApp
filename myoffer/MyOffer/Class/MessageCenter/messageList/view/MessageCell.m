//
//  MessageTableViewCell.m
//  myOffer
//
//  Created by xuewuguojie on 16/1/14.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import "MessageCell.h"
#import "XWGJMessageFrame.h"
#import "MyOfferArticle.h"

@interface MessageCell ()
//图片
@property(nonatomic,strong)UIImageView *Logo;
//消息头
@property(nonatomic,strong)UILabel *titleLab;
//关注数量
@property(nonatomic,strong)UIButton *view_count_Btn;
//消息发布时间
@property(nonatomic,strong)UIButton *update_at_Btn;

@property(nonatomic,strong)UIView *bottom_line;

@property(nonatomic,strong)UIButton *tag_Btn;

@end

@implementation MessageCell

+(instancetype)cellWithTableView:(UITableView *)tableView
{
    
    MessageCell *cell =[tableView dequeueReusableCellWithIdentifier:@"massage"];
    
    if (!cell) {
        
        cell =[[MessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"massage"];
    }

    return cell;
}


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self   =  [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        self.Logo =[[UIImageView alloc] init];
        self.Logo.layer.masksToBounds = YES;
        self.Logo.image =[UIImage imageNamed:@"PlaceHolderImage"];
        self.Logo.clipsToBounds = YES;
        self.Logo.contentMode = UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:self.Logo];
        
        self.titleLab =[UILabel labelWithFontsize:KDUtilSize(16)  TextColor:XCOLOR_BLACK TextAlignment:NSTextAlignmentLeft];
        self.titleLab.numberOfLines = 2;
        self.titleLab.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:KDUtilSize(16)];
        [self.contentView addSubview:self.titleLab];
        
        
         self.update_at_Btn = [[UIButton alloc] init];
         self.update_at_Btn.titleLabel.font = [UIFont systemFontOfSize:12];
         self.update_at_Btn.imageEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0);
        [self.update_at_Btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
         self.update_at_Btn.userInteractionEnabled = NO;
        [self.contentView addSubview:self.update_at_Btn];
        
        
        self.view_count_Btn = [[UIButton alloc] init];
        self.view_count_Btn.contentHorizontalAlignment =  UIControlContentHorizontalAlignmentLeft;
        self.view_count_Btn.imageEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0);
        [self.view_count_Btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        self.view_count_Btn.titleLabel.font = [UIFont systemFontOfSize:12];
        self.view_count_Btn.userInteractionEnabled = NO;
        [self.contentView addSubview:self.view_count_Btn];
        
        
        self.tag_Btn = [[UIButton alloc] init];
        self.tag_Btn.titleLabel.font = [UIFont systemFontOfSize:12];
        [self.tag_Btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        self.tag_Btn.userInteractionEnabled = NO;
        [self.contentView addSubview:self.tag_Btn];
        self.tag_Btn.layer.cornerRadius = CORNER_RADIUS;
        self.tag_Btn.layer.masksToBounds = YES;
        self.tag_Btn.backgroundColor = XCOLOR_BG;
        
        UIView *bottom_line = [UIView new];
        self.bottom_line = bottom_line;
        bottom_line.backgroundColor = XCOLOR_line;
        [self.contentView addSubview:bottom_line];
        
        
    }
    return self;
}



-(void)setMessageFrame:(XWGJMessageFrame *)messageFrame
{
    _messageFrame =  messageFrame ;
    
    NSString *path = @"";
    NSString *time = @"";

    if (messageFrame.News) {
        
        path = messageFrame.News.cover_url_thumbnail.length > 0 ? messageFrame.News.cover_url_thumbnail : messageFrame.News.cover_url;
        
        NSInteger  length = messageFrame.News.update_at.length > 10 ? 10 : messageFrame.News.update_at.length;
        
        time = [messageFrame.News.update_at substringToIndex:length];
        
        
    }else{
        
        path = messageFrame.News.cover_url;
        time  = messageFrame.News.update_at;

     }
    
    [self.Logo KD_setImageWithURL:path];
    self.titleLab.text = messageFrame.News.title;
    [self.update_at_Btn setTitle:time forState:UIControlStateNormal];
    [self.view_count_Btn setTitle:messageFrame.News.view_count forState:UIControlStateNormal];
    [self.tag_Btn setTitle:messageFrame.News.category_thr forState:UIControlStateNormal];


    self.Logo.frame = messageFrame.LogoFrame;
    self.titleLab.frame = messageFrame.TitleFrame;
    self.update_at_Btn.frame = messageFrame.TimeFrame;
    self.view_count_Btn.frame = messageFrame.FocusFrame;
    self.bottom_line.frame = messageFrame.lineFrame;
    self.tag_Btn.frame = messageFrame.tagFrame;
   
}



- (void)separatorLineShow:(BOOL)show{
    
    self.bottom_line.frame = show ? self.messageFrame.lineFrame : CGRectZero;
}

- (void)separatorLinePaddingShow:(BOOL)show{

    self.bottom_line.mj_x =  show ? self.titleLab.mj_x : 0;
}

- (void)tagsShow:(BOOL)show{

    self.tag_Btn.hidden = !show;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
