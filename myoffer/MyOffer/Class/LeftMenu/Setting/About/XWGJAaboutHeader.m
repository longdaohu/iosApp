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
@property (weak, nonatomic) IBOutlet UILabel *versionLab;

@end
@implementation XWGJAaboutHeader

-(void)awakeFromNib
{
    
    [super awakeFromNib];

     self.ProfileLab.text = GDLocalizedString(@"About_profile");
    
     [self checkAPPVersion];
}

//检查版本更新
-(void)checkAPPVersion
{
  
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    // app名称
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    
     self.versionLab.text = [NSString stringWithFormat:@"Version %@",app_Version];
    
}


@end
