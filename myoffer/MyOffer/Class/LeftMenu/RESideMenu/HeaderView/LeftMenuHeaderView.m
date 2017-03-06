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
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;

@end

@implementation LeftMenuHeaderView

-(void)awakeFromNib
{
    [super awakeFromNib];

    self.userIconView.layer.borderColor = [UIColor whiteColor].CGColor;
     
}



-(void)setResponse:(NSDictionary *)response{

    _response = response;
    
    self.userNameLabel.text = response[@"accountInfo"][@"displayname"];
    self.userIconView.image = [UIImage imageNamed:@"default_avatar.jpg"];
    [self.userIconView KD_setImageWithURL:response[@"portraitUrl"]];
         
   
 
}

-(void)headerViewWithUserLoginOut{

    self.userNameLabel.text =GDLocalizedString(@"Me-005");//@"点击登录或注册";
    self.userIconView.image = [UIImage imageNamed:@"default_avatar.jpg"];
}





@end

