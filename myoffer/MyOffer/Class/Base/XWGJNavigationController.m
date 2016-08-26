//
//  XWGJNavigationController.m
//  MyOffer
//
//  Created by xuewuguojie on 15/10/15.
//  Copyright © 2015年 UVIC. All rights reserved.
//

#import "XWGJNavigationController.h"

@interface XWGJNavigationController ()<UIGestureRecognizerDelegate>
@property(nonatomic,strong)UIImage *navigationBgImage;

@end

@implementation XWGJNavigationController

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
 
    self.navigationBar.tintColor = XCOLOR_WHITE;
    self.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:XCOLOR_WHITE
                                                                    };
    self.interactivePopGestureRecognizer.delegate =  self;
    [self.navigationBar setBackgroundImage:self.navigationBgImage forBarMetrics:UIBarMetricsDefault];
    self.navigationBar.shadowImage = [[UIImage alloc] init];
    
    
    
}


-(UIImage *)navigationBgImage
{
    if (!_navigationBgImage) {
     
         NSString *path = [[NSHomeDirectory()stringByAppendingPathComponent:@"Documents"]stringByAppendingPathComponent:@"nav.png"];
         UIImage *navImage =[UIImage imageWithData:[NSData dataWithContentsOfFile:path]];
        _navigationBgImage =[self makeNewImageWithRect:CGRectMake(0, 0, XScreenWidth, 64) andImage:navImage];
        
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




/**   ——————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————
 *  能拦截所有push进来的子控制器
 */
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    
    if (self.viewControllers.count > 0) { // 如果现在push的不是栈底控制器(最先push进来的那个控制器)
        
        viewController.hidesBottomBarWhenPushed = YES;
    }
    
    [super pushViewController:viewController animated:animated];
    
     if (self.viewControllers.count > 1) { // 如果现在push的不是栈底控制器(最先push进来的那个控制器)
        
        // 设置导航栏按钮
        viewController.navigationItem.leftBarButtonItem =[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back_arrow"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
        viewController.navigationItem.leftBarButtonItem.imageInsets = UIEdgeInsetsMake(0, -5, 0, 0);
    }
    
   
    
}



- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    
    if (self.viewControllers.count <= 1 ) {
        
        
        return NO;
    }
    
    return YES;
}


- (void)back
{
    [self popViewControllerAnimated:YES];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





@end
