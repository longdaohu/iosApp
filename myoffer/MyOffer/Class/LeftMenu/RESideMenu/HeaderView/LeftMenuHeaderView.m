//
//  LeftMenuHeaderView.m
//  myOffer
//
//  Created by xuewuguojie on 2016/11/1.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import "LeftMenuHeaderView.h"
@interface LeftMenuHeaderView ()
//用户名
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
//头像
@property (weak, nonatomic) IBOutlet UIImageView *iconView;

@end

@implementation LeftMenuHeaderView
+ (instancetype)headerViewWithTap:(LeftBlock)actionBlock{

    LeftMenuHeaderView *header = [[NSBundle mainBundle] loadNibNamed:@"LeftMenuHeaderView" owner:self options:nil].lastObject;
    
    header.actionBlock = actionBlock;
    
    return header;
}


-(void)awakeFromNib
{
    [super awakeFromNib];

    self.iconView.layer.borderColor = [UIColor whiteColor].CGColor;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
    [self.iconView addGestureRecognizer:tap];
    
     
}

- (void)tap{

    if (self.actionBlock) {
        
        self.actionBlock();
    }
    
}


-(void)setResponse:(NSDictionary *)response{

    _response = response;
    
    self.nameLabel.text = response[@"accountInfo"][@"displayname"];
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:response[@"portraitUrl"]] placeholderImage:[UIImage imageNamed:@"default_avatar.jpg"]];
   
}

-(void)headerViewWithUserLoginOut{

    self.nameLabel.text =GDLocalizedString(@"Me-005");//@"点击登录或注册";
    self.iconView.image = [UIImage imageNamed:@"default_avatar.jpg"];
}


- (void)setIconImage:(UIImage *)iconImage{

    _iconImage = iconImage;
    
    self.iconView.image = iconImage;
}


@end

