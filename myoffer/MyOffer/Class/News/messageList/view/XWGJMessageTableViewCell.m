//
//  MessageTableViewCell.m
//  myOffer
//
//  Created by xuewuguojie on 16/1/14.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import "XWGJMessageTableViewCell.h"
#import "XWGJMessageFrame.h"
#import "NewsItem.h"

@interface XWGJMessageTableViewCell ()
//图片
@property(nonatomic,strong)UIImageView *Logo;
//消息头
@property(nonatomic,strong)UILabel *TitleLabel;
//关注数量
@property(nonatomic,strong)UIButton *FocusBtn;
//消息发布时间
@property(nonatomic,strong)UIButton *TimeBtn;


@end

@implementation XWGJMessageTableViewCell

+(instancetype)cellWithTableView:(UITableView *)tableView
{
    
    XWGJMessageTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"massage"];
    if (!cell) {
        
        cell =[[XWGJMessageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"massage"];
    }

    return cell;
}


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self   =  [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        self.Logo =[[UIImageView alloc] init];
        self.Logo.image =[UIImage imageNamed:@"PlaceHolderImage"];
        self.Logo.clipsToBounds = YES;
        self.Logo.contentMode = UIViewContentModeScaleToFill;
        [self.contentView addSubview:self.Logo];
        
        self.TitleLabel =[UILabel labelWithFontsize:KDUtilSize(16)  TextColor:XCOLOR_BLACK TextAlignment:NSTextAlignmentLeft];
        self.TitleLabel.numberOfLines = 2;
         self.TitleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:KDUtilSize(16)];
        [self.contentView addSubview:self.TitleLabel];
        
        
         self.TimeBtn = [[UIButton alloc] init];
        self.TimeBtn.titleLabel.font = [UIFont systemFontOfSize:12];
         self.TimeBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0);
        self.TimeBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.TimeBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [self.TimeBtn setImage:[UIImage imageNamed:@"Detail_time"] forState:UIControlStateNormal];
         self.TimeBtn.userInteractionEnabled = NO;
        [self.contentView addSubview:self.TimeBtn];
        
        
        self.FocusBtn = [[UIButton alloc] init];
        self.FocusBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
        self.FocusBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0);
        [self.FocusBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        self.FocusBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [self.FocusBtn setImage:[UIImage imageNamed:@"Detail_Focus"] forState:UIControlStateNormal];
        self.FocusBtn.userInteractionEnabled = NO;
        [self.contentView addSubview:self.FocusBtn];
        
        
    }
    return self;
}



-(void)setMessageFrame:(XWGJMessageFrame *)messageFrame
{
    _messageFrame =  messageFrame ;

    [self.Logo KD_setImageWithURL:messageFrame.News.LogoName];
    self.Logo.frame = messageFrame.LogoFrame;

    
    self.TitleLabel.text = messageFrame.News.messageTitle;
    self.TitleLabel.frame = messageFrame.TitleFrame;
    
    NSString *time = [messageFrame.News.Update_time substringToIndex:10];
    [self.TimeBtn setTitle:time forState:UIControlStateNormal];
    self.TimeBtn.frame = messageFrame.TimeFrame;

    
    NSString *count = [NSString stringWithFormat:@"%@",messageFrame.News.FocusCount];
    [self.FocusBtn setTitle:count forState:UIControlStateNormal];
    self.FocusBtn.frame = messageFrame.FocusFrame;
    
}




- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
