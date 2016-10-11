//
//  XWGJAaboutHeader.m
//  myOffer
//
//  Created by xuewuguojie on 16/1/27.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import "XWGJAaboutHeader.h"

@interface XWGJAaboutHeader ()
@property (weak, nonatomic) IBOutlet UIImageView *myOfferLogo; //logo图片
@property (weak, nonatomic) IBOutlet UILabel *ProfileLab;      //提示语

@end
@implementation XWGJAaboutHeader

-(void)awakeFromNib
{
    
    [super awakeFromNib];

    self.ProfileLab.text = GDLocalizedString(@"About_profile");
    
//    self.myOfferLogo.image =[UIImage imageNamed:GDLocalizedString(@"About_Logo")];
}

@end
