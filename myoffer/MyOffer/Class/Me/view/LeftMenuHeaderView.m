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

    LeftMenuHeaderView *header = Bundle(@"LeftMenuHeaderView");
    
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
- (IBAction)userNameOnClick:(id)sender {
    if (LOGIN) return;
    [self tap];
}

- (void)tap{

    if (self.actionBlock) {
        
        self.actionBlock();
    }
    
}

- (void)setUser:(MyofferUser *)user{

    _user = user;
    
    self.nameLabel.text = user.displayname;
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:user.portraitUrl] placeholderImage:[UIImage imageNamed:@"default_avatar.jpg"]];
}


-(void)headerViewWithUserLoginOut{

    self.nameLabel.text = @"点击登录或注册";
    self.iconView.image = [UIImage imageNamed:@"default_avatar.jpg"];
}


- (void)setIconImage:(UIImage *)iconImage{

    _iconImage = iconImage;
    
    self.iconView.image = iconImage;
}


@end

