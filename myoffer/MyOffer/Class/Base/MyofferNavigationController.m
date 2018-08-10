//
//  MyofferNavigationController
//  MyOffer
//
//  Created by xuewuguojie on 15/10/15.
//  Copyright © 2015年 UVIC. All rights reserved.
//

#import "MyofferNavigationController.h"

@interface MyofferNavigationController ()<UIGestureRecognizerDelegate>
@property(nonatomic,strong)UIImage *navigationBgImage;

@end

@implementation MyofferNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
 
    self.navigationBar.tintColor = XCOLOR_WHITE;
    self.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:XCOLOR_WHITE,NSFontAttributeName :[UIFont boldSystemFontOfSize:17] };
    self.interactivePopGestureRecognizer.delegate =  self;
    [self.navigationBar setBackgroundImage:self.navigationBgImage forBarMetrics:UIBarMetricsDefault];
 
}


-(UIImage *)navigationBgImage
{
    if (!_navigationBgImage) {
         NSString *path = [[NSHomeDirectory()stringByAppendingPathComponent:@"Documents"]stringByAppendingPathComponent:@"nav.png"];
         UIImage *navImage =[UIImage imageWithData:[NSData dataWithContentsOfFile:path]];
        _navigationBgImage =[self makeNewImageWithRect:CGRectMake(0, 0, XSCREEN_WIDTH, 64) andImage:navImage];
        
    }
    return _navigationBgImage;
}

//得到部分区域图片
-(UIImage *)makeNewImageWithRect:(CGRect)clipRect andImage:(UIImage *)image
{
    //原图片
    //    UIImage * img = [UIImage imageNamed:@"bg.png"];
    //转化为位图
    CGImageRef temImg = image.CGImage;
    //根据范围截图
    temImg=CGImageCreateWithImageInRect(temImg, clipRect);
    //得到新的图片
    UIImage *newImage = [UIImage imageWithCGImage:temImg];
    //释放位图对象
    CGImageRelease(temImg);
    
    return newImage;
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





@end
