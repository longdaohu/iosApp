//
//  TKHelperUtil.m
//  EduClass
//
//  Created by lyy on 2018/4/27.
//  Copyright © 2018年 talkcloud. All rights reserved.
//

#import "TKHelperUtil.h"
#import <Photos/Photos.h>
#import "sys/utsname.h"
#import "TKEduSessionHandle.h"

#define DeviceTheme(args) [@"DeviceType.Default." stringByAppendingString:args]
#define DeviceUDPTheme(args) [@"DeviceType.UdpImpassability." stringByAppendingString:args]

#define ToolsTheme(args) [@"WhiteBoardTools.Default." stringByAppendingString:args]
#define ToolsSelectedTheme(args) [@"WhiteBoardTools.Selected." stringByAppendingString:args]
#define DocumentTypeTheme(args) [@"TKDocumentListView." stringByAppendingString:args]

@implementation TKHelperUtil

+ (NSString *)returnDeviceImageName:(NSString *)devicetype{
    
    return DeviceTheme(devicetype);
    
}
+ (NSString *)returnUDPDeviceImageName:(NSString *)devicetype{
    
    NSString *de = [NSString stringWithFormat:@"%@_udp",devicetype];
    
    return DeviceUDPTheme(de);
    
}

+ (NSString *)returnChooseTypeImageName:(NSString *)chooseType isSelect:(BOOL)isSelect{

    NSString *toolImage = isSelect?ToolsSelectedTheme(chooseType):ToolsTheme(chooseType);

    return toolImage;
}

+ (NSArray *)mp3PlayGif{
    
    NSMutableArray *array  = [NSMutableArray array];
    for (int i = 0; i<40; i++) {
        if (i<10) {
            NSString *str = [TKTheme stringWithPath:@"ClassRoom.TKMediaView.mp3Loading"];
            
            UIImage *img = [UIImage imageNamed:[NSString stringWithFormat:@"%@%d",str,i]];
            [array addObject:img];
        }else{
            NSString *str = [TKTheme stringWithPath:@"ClassRoom.TKMediaView.mp3Loading2"];
            UIImage *img = [UIImage imageNamed:[NSString stringWithFormat:@"%@%d",str,i]];
            [array addObject:img];
        }
    }
    return [NSArray arrayWithArray:array];
}
+ (NSArray *)mp4PlayGif{
    
    NSMutableArray *array  = [NSMutableArray array];
    for (int i = 0; i<38; i++) {
        if (i<10) {
            NSString *str = [TKTheme stringWithPath:@"ClassRoom.TKMediaView.mp4Loading"];
            
            UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%@%d",str,i]];
           
            
            [array addObject:image];
        }else{
            NSString *str = [TKTheme stringWithPath:@"ClassRoom.TKMediaView.mp4Loading2"];
            
            UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%@%d",str,i]];
            
           
            
            [array addObject:image];
        }
    }
    return [NSArray arrayWithArray:array];
}


+(NSString *)docmentOrMediaImage:(NSString*)aType{
    
    NSString *tString = @"icon_user";
    if ([aType isEqualToString:@"whiteboard"]) {
        tString = [TKTheme stringWithPath:DocumentTypeTheme(@"icon_empty")];
        
    }else if ([aType isEqualToString:@"xls"]||[aType isEqualToString:@"xlsx"]||[aType isEqualToString:@"xlt"]||[aType isEqualToString:@"xlsm"]){
        tString = [TKTheme stringWithPath:DocumentTypeTheme(@"icon_excel")];
    }else if ([aType isEqualToString:@"jpg"]|| [aType isEqualToString:@"jpeg"]||[aType isEqualToString:@"png"] ||[aType isEqualToString:@"gif"] || [aType isEqualToString:@"bmp"]){
        tString = [TKTheme stringWithPath:DocumentTypeTheme(@"icon_images")];
    }
    else if ([aType isEqualToString:@"ppt"] || [aType isEqualToString:@"pptx"] || [aType isEqualToString:@"pps"]){
        tString = [TKTheme stringWithPath:DocumentTypeTheme(@"icon_ppt")];
    }
    else if ([aType isEqualToString:@"docx"]|| [aType isEqualToString:@"doc"]){
        tString = [TKTheme stringWithPath:DocumentTypeTheme(@"icon_word")];
    }
    else if ([aType isEqualToString:@"txt"]){
        tString = [TKTheme stringWithPath:DocumentTypeTheme(@"icon_text_pad")];
    }
    else if ([aType isEqualToString:@"pdf"]){
        tString = [TKTheme stringWithPath:DocumentTypeTheme(@"icon_pdf")];
    }
    else if ([aType isEqualToString:@"mp3"]){
        tString = [TKTheme stringWithPath:DocumentTypeTheme(@"icon_mp3")];
    }
    else if ([aType isEqualToString:@"mp4"]){
        tString = [TKTheme stringWithPath:DocumentTypeTheme(@"icon_mp4")];
    } else if ([aType isEqualToString:@"zip"]){
        tString = [TKTheme stringWithPath:DocumentTypeTheme(@"icon_h5")];
    }
    return tString;
    
    
}

// 根据色值匹配图片
+ (NSString *)imageNameWithPrimaryColor:(NSString *)PrimaryColor {
    
    NSString *imageName;
    
    if ([PrimaryColor caseInsensitiveCompare:@"#000000"] == NSOrderedSame) {
        imageName = @"icon_pen_black";
    }else if ([PrimaryColor caseInsensitiveCompare:@"#5ac9fa"] == NSOrderedSame) {
        imageName = @"icon_pen_blue";
    }else if ([PrimaryColor caseInsensitiveCompare:@"#ffcc00"] == NSOrderedSame) {
        imageName = @"icon_pen_yellow";
    }else if ([PrimaryColor caseInsensitiveCompare:@"#ED3E3A"] == NSOrderedSame) {
        imageName = @"icon_pen_red";
    }else if ([PrimaryColor caseInsensitiveCompare:@"#4740D2"] == NSOrderedSame) {
        imageName = @"icon_pen_deep purple";
    }else if ([PrimaryColor caseInsensitiveCompare:@"#007BFF"] == NSOrderedSame) {
        imageName = @"icon_pen_deep blue";
    }else if ([PrimaryColor caseInsensitiveCompare:@"#09C62B"] == NSOrderedSame) {
        imageName = @"icon_pen_green";
    }else if ([PrimaryColor caseInsensitiveCompare:@"#EDEDED"] == NSOrderedSame) {
        imageName = @"icon_pen_ white";
    }
    return imageName;
}


//授权照片
+ (void)phontLibraryAction{
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
    }];
}


+ (UIColor *)colorWithHexColorString:(NSString *)hexColorString{
//    return [UIColor redColor];
    return [TKHelperUtil colorWithHexColorString:hexColorString alpha:1.0f];
}

+ (UIColor *)colorWithHexColorString:(NSString *)hexColorString alpha:(float)alpha
{
    if ([hexColorString length] <6){//长度不合法
        return [UIColor blackColor];
    }
    NSString *tempString=[hexColorString lowercaseString];
    if ([tempString hasPrefix:@"0x"]){//检查开头是0x
        tempString = [tempString substringFromIndex:2];
    }else if ([tempString hasPrefix:@"#"]){//检查开头是#
        tempString = [tempString substringFromIndex:1];
    }
    if ([tempString length] !=6){
        return [UIColor blackColor];
    }
    //分解三种颜色的值
    NSRange range;
    range.location =0;
    range.length =2;
    NSString *rString = [tempString substringWithRange:range];
    range.location =2;
    NSString *gString = [tempString substringWithRange:range];
    range.location =4;
    NSString *bString = [tempString substringWithRange:range];
    //取三种颜色值
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString]scanHexInt:&r];
    [[NSScanner scannerWithString:gString]scanHexInt:&g];
    [[NSScanner scannerWithString:bString]scanHexInt:&b];
    return [UIColor colorWithRed:((float) r /255.0f)
                           green:((float) g /255.0f)
                            blue:((float) b /255.0f)
                           alpha:alpha];
}

+ (CGSize)sizeForString:(NSString *)string font:(UIFont *)font size:(CGSize)size
{
    return [string boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : font} context:nil].size;
}

+ (int)returnTotalPageNum:(NSInteger)totalPage showPage:(NSInteger)pageNum{
    int addition =(int) totalPage/pageNum;
    int remainder = (int)totalPage%pageNum;
    return addition + (remainder==0?0:1);
}

+ (CGFloat)returnClassRoomDpi{
    
    CGFloat dpi = (CGFloat)[[[TKEduSessionHandle shareInstance].roomMgr getRoomProperty].videoheight  integerValue]/[[[TKEduSessionHandle shareInstance].roomMgr getRoomProperty].videowidth  integerValue];
    
    if(isnan(dpi) || !dpi){//如果分辨率不存在默认设置为0     （4 : 3）
        dpi = 3.0/4;
    }
    return dpi;
}

+ (BOOL)isURL:(NSString *)text{
    
    NSString *regex =@"[a-zA-z]+://[^\\s]*";
    NSError *error;
    
    NSRegularExpression *regular = [[NSRegularExpression alloc] initWithPattern:regex options:0 error:&error];
    if (!error) {
        NSArray *results = [regular matchesInString:text options:0 range:NSMakeRange(0, text.length)];
        for (NSTextCheckingResult *result in results) {
            
            return true;
        }
        return false;
    }
    else { // 如果有错误，则把错误打印出来
        TKLog(@"error - %@", error);
        return false;
    }
}

+ (void)setVedioProfile{
//    CGFloat dpi = (CGFloat)[[[TKEduSessionHandle shareInstance].roomMgr getRoomProperty].videoheight  integerValue]/[[[TKEduSessionHandle shareInstance].roomMgr getRoomProperty].videowidth  integerValue];
//
//    if(isnan(dpi) || !dpi){//如果分辨率不存在默认设置为0     （4 : 3）
//        dpi = 3.0/4;
//    }
    
    
    int vcodec = [[[TKEduSessionHandle shareInstance].roomMgr getRoomProperty].vcodec intValue];
    if ((vcodec == 0 || vcodec == 1)) {
        
        NSInteger videoframerate = [[[TKEduSessionHandle shareInstance].roomMgr getRoomProperty].videoframerate integerValue];
//        if (dpi>(480/640.0)) {
//
        TKVideoProfile *profile = [[TKVideoProfile alloc]init];
        profile.width = 640;
        profile.height = 480;
        profile.maxfps = videoframerate;
        
        [[TKEduSessionHandle shareInstance] sessionHandleVideoProfile:profile];
//        }
    }
    
}

+ (UIImage *)resizableImageWithImageName:(NSString *)imageName{

    UIImage *image = [UIImage imageNamed:imageName];
    // 设置端盖的值--其它方向不需要拉伸，只拉伸头部
    CGFloat left = image.size.width * 0.45;
    UIEdgeInsets edgeInsets = UIEdgeInsetsMake(0, left, 0, image.size.width*0.54);
    // 设置拉伸的模式
    UIImageResizingMode mode = UIImageResizingModeStretch;
    // 拉伸图片
    UIImage *newImage = [image resizableImageWithCapInsets:edgeInsets resizingMode:mode];
    return newImage;
    
}

@end
