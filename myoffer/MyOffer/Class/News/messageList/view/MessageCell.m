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
#import "messgeNewModel.h"

@interface MessageCell ()
//图片
@property(nonatomic,strong)UIImageView *Logo;
//消息头
@property(nonatomic,strong)UILabel *TitleLab;
//关注数量
@property(nonatomic,strong)UIButton *view_count_Btn;
//消息发布时间
@property(nonatomic,strong)UIButton *update_at_Btn;

@property(nonatomic,strong)UIView *line;


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
        
        self.TitleLab =[UILabel labelWithFontsize:KDUtilSize(16)  TextColor:XCOLOR_BLACK TextAlignment:NSTextAlignmentLeft];
        self.TitleLab.numberOfLines = 2;
        self.TitleLab.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:KDUtilSize(16)];
        [self.contentView addSubview:self.TitleLab];
        
        
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
        
        UIView *line = [UIView new];
        self.line = line;
        line.backgroundColor = XCOLOR_line;
        [self.contentView addSubview:line];
        
        
    }
    return self;
}



-(void)setMessageFrame:(XWGJMessageFrame *)messageFrame
{
    _messageFrame =  messageFrame ;
    
    NSString *path = @"";
    NSString *title = @"";
    NSString *time = @"";
    NSString *count = @"";

    if (messageFrame.News) {
        
        path = messageFrame.News.cover_url_thumbnail.length ? messageFrame.News.cover_url_thumbnail : messageFrame.News.cover_url;
        title = messageFrame.News.title;
        
        NSInteger  length = messageFrame.News.update_at.length > 10 ? 10 : messageFrame.News.update_at.length;
        
        time = [messageFrame.News.update_at substringToIndex:length];
        
        count =   [NSString stringWithFormat:@"%@阅读", messageFrame.News.view_count];
        
    }else{
        
        path = messageFrame.message.cover_url;
        title = messageFrame.message.title;
        time  = messageFrame.message.update_at;
        count =   [NSString stringWithFormat:@"%@阅读", messageFrame.message.view_count];

     }
    
    [self.Logo KD_setImageWithURL:path];
    self.TitleLab.text = title;
    [self.update_at_Btn setTitle:time forState:UIControlStateNormal];
    [self.view_count_Btn setTitle:count forState:UIControlStateNormal];


    self.Logo.frame = messageFrame.LogoFrame;
    self.TitleLab.frame = messageFrame.TitleFrame;
    self.update_at_Btn.frame = messageFrame.TimeFrame;
    self.view_count_Btn.frame = messageFrame.FocusFrame;
    self.line.frame = messageFrame.lineFrame;
    
}



- (void)separatorLineShow:(BOOL)show{
    
    self.line.hidden = show;
}





- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
