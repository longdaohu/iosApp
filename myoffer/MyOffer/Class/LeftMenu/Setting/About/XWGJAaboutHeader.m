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
    NSURLRequest *req = [NSURLRequest requestWithURL:[NSURL URLWithString:@"https://itunes.apple.com/lookup?id=1016290891"]];
    [NSURLConnection connectionWithRequest:req delegate:self];
}
//检查版本更新
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    
    NSError *error;
    id jsonObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    
    NSDictionary *appInfo = (NSDictionary *)jsonObject;
    NSArray *infoContent = [appInfo objectForKey:@"results"];
    NSString *storeVersion = [[infoContent objectAtIndex:0] objectForKey:@"version"];
    
    self.versionLab.text = [NSString stringWithFormat:@"Version %@",storeVersion];
    
}

@end
