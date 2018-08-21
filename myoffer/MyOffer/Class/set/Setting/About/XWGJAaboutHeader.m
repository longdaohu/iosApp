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

     self.backgroundColor = XCOLOR_BG;
     self.ProfileLab.text = @"myOffer ®是全球留学生的在线“留学+”服务生态圈平台，一个跨境的全球留学生服务生态圈。";
     [self checkAPPVersion];
}

//检查版本更新
-(void)checkAPPVersion
{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    self.versionLab.text = [NSString stringWithFormat:@"Version %@",app_Version];
}


@end
