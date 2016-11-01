//
//  XWGJTabBarController.m
//  MyOffer
//
//  Created by sara on 15/10/14.
//  Copyright © 2015年 UVIC. All rights reserved.
//

#import "XWGJTabBarController.h"
#import "HomeViewContViewController.h"
#import "MeViewController.h"
//#import "DiscoverViewController.h"
#import "MessageViewController.h"
#import "CatigoryViewController.h"

@interface XWGJTabBarController ()
@property(nonatomic,strong)UIImage *navigationBgImage;
@end

@implementation XWGJTabBarController

- (void)viewDidLoad {
    
    [super viewDidLoad];

    [self makeNavImage];
    

    CatigoryViewController *cvc = [[CatigoryViewController alloc] init];
    cvc.title = GDLocalizedString(@"CategoryTitle");//@"分类";
    
    MeViewController *mvc = [[MeViewController alloc] initWithNibName:NSStringFromClass([MeViewController class]) bundle:nil];
    mvc.title = GDLocalizedString(@"MeViewControllerTitle"); //@"申请中心";
    
//    if (USER_EN) {
//        
//        DiscoverViewController *dvc = [[DiscoverViewController alloc] init];
//        dvc.title = GDLocalizedString(@"DiscoverTitle");//@"发现";
//
//        self.viewControllers = @[[[XWGJNavigationController alloc] initWithRootViewController:dvc],
//                                 [[XWGJNavigationController alloc] initWithRootViewController:cvc],
//                                 [[XWGJNavigationController alloc] initWithRootViewController:mvc]
//                                 ];
//        
//        
//        [self tabbaritem:0 nomalImage:@"search_nomal" selectImage:@"search_select"];
//        [self tabbaritem:1 nomalImage:@"catigory_nomal" selectImage:@"catigory_select"];
//        [self tabbaritem:2 nomalImage:@"center_nomal" selectImage:@"center_select"];
//    }else {
    
        MessageViewController *msvc = [[MessageViewController alloc] init];
        msvc.title = @"资讯宝典";
        
        HomeViewContViewController *home =[[HomeViewContViewController alloc] init];
        home.title = GDLocalizedString(@"DiscoverTitle");//@"发现";
        
        self.viewControllers = @[[[XWGJNavigationController alloc] initWithRootViewController:home],
                                 [[XWGJNavigationController alloc] initWithRootViewController:cvc],
                                 [[XWGJNavigationController alloc] initWithRootViewController:msvc],
                                 [[XWGJNavigationController alloc] initWithRootViewController:mvc]
                                 ];
        
        [self tabbaritem:0 nomalImage:@"search_nomal" selectImage:@"search_select"];
        [self tabbaritem:1 nomalImage:@"catigory_nomal" selectImage:@"catigory_select"];
        [self tabbaritem:2 nomalImage:@"liuxue_nomal" selectImage:@"liuxue_select"];
        [self tabbaritem:3 nomalImage:@"center_nomal" selectImage:@"center_select"];
    
//    }
    


    self.tabBar.tintColor = [UIColor colorWithRed:43.0/255 green:193.0/255 blue:245.0/255 alpha:1];
}

-(void)tabbaritem:(NSInteger)index nomalImage:(NSString *)nomalName  selectImage:(NSString *)selectName
{
    UITabBar *tabBar     = self.tabBar;
    UITabBarItem *item   = [tabBar.items objectAtIndex:index];
    item.tag             = index;
    UIImage *NomalImage  = [UIImage imageNamed:nomalName];//@"catigory_nomal"];
    UIImage *SelectImage = [UIImage imageNamed:selectName];//@"catigory_select"];
    item.image           = [NomalImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item.selectedImage   = [SelectImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item.titlePositionAdjustment = UIOffsetMake(0, -2);
}


- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];

}

-(void)makeNavImage
{
    NSString *homePath        = NSHomeDirectory();
    NSString *documentPath    = [homePath stringByAppendingPathComponent:@"Documents"];
    NSFileManager *fileManger = [NSFileManager defaultManager];
    NSArray *fileItems        = [fileManger contentsOfDirectoryAtPath:documentPath error:nil];
    
    if (![fileItems containsObject:@"nav"]) {
        
        CGFloat navHeight         = 124;
        UIView *navView           = [[UIView alloc] initWithFrame:CGRectMake(0, 0,[UIScreen mainScreen].bounds.size.width, navHeight)];
        CAGradientLayer *gradient = [CAGradientLayer layer];
        gradient.frame            = navView.bounds;
        gradient.colors           = [NSArray arrayWithObjects:
                           (id)[UIColor colorWithRed:45/255.0 green:195/255.0 blue:228/255.0 alpha:1].CGColor,
                           (id)[UIColor colorWithRed:154/255.0 green:65/255.0 blue:147/255.0 alpha:1].CGColor,
                           nil];
        gradient.startPoint = CGPointMake(0.4, 0.95);
        gradient.endPoint = CGPointMake(1.0, 1.0);
        [navView.layer insertSublayer:gradient atIndex:0];
        
        self.navImage = [self getImageFromView:navView];
        [self writeToFileWithImage:self.navImage fileName:@"nav"];

      
        NSMutableArray *temps = [NSMutableArray array];
        CGFloat leftMargin    = 10;
        CGFloat btnw          = (XScreenWidth - leftMargin *2)/3;
        CGFloat btnh          = TOP_HIGHT;
        CGFloat btny          = navHeight - btnh - 10;
        for (NSInteger index  = 0; index < 3; index++){
            
            CGFloat btnx = btnw * index + leftMargin;
            UIButton *sender  = [[UIButton alloc] initWithFrame:CGRectMake(btnx, btny ,btnw, btnh)];
            [navView addSubview:sender];
            sender.layer.borderColor   = [UIColor colorWithWhite:0 alpha:0.5].CGColor;
            sender.layer.cornerRadius  = 17;
            sender.layer.masksToBounds = YES;
            sender.tag                 = index;
            [sender setBackgroundImage:[self makeNewImageWithRect:sender.frame] forState:UIControlStateNormal];
            UIImage *senderImage       = [self getItemImageFromView:sender];
            [temps addObject:senderImage];
          }
        
        NSData *senderItemData = [NSKeyedArchiver archivedDataWithRootObject:[temps copy]];
        NSString *item_path    = [[NSHomeDirectory()stringByAppendingPathComponent:@"Documents"]stringByAppendingPathComponent:@"items"];
        [senderItemData writeToFile:item_path atomically:YES];
        
    }
    
}



-(void)writeToFileWithImage:(UIImage *)image fileName:(NSString *)fileName
{
    NSString *path = [[NSHomeDirectory()stringByAppendingPathComponent:@"Documents"]stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png",fileName]];
    [UIImagePNGRepresentation(image) writeToFile:path  atomically:YES];
    
}


//把UIView 转换成图片
-(UIImage *)getImageFromView:(UIView *)view{
    
    UIGraphicsBeginImageContext(view.bounds.size);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}


// 下面方法，第一个参数表示区域大小。第二个参数表示是否是非透明的。如果需要显示半透明效果，需要传NO，否则传YES。第三个参数就是屏幕密度了
-(UIImage*)getItemImageFromView:(UIView*)view{
    
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, NO, [UIScreen mainScreen].scale);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}


//得到部分区域图片
-(UIImage *)makeNewImageWithRect:(CGRect)clipRect
{
    //原图片
    //    UIImage * img = [UIImage imageNamed:@"bg.png"];
    //转化为位图
    CGImageRef temImg = self.navImage.CGImage;
    //根据范围截图
    temImg = CGImageCreateWithImageInRect(temImg, clipRect);
    
    //得到新的图片
    UIImage *newImage = [UIImage imageWithCGImage:temImg];
    //释放位图对象
    CGImageRelease(temImg);
    
    return newImage;
    
}

#pragma mark ——  UITabBarDelegate
//- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
//{
//  
//    if (USER_EN)
//        return;
//   
//    
//    NSString *itemName;
//    
//    if (item.tag == 0) {
//        itemName = @"tabItem_home";
//    }else if (item.tag == 1) {
//        itemName = @"tabItem_catigory";
//    }else if (item.tag == 2) {
//        itemName = @"tabItem_news";
//    }{
//        itemName = @"tabItem_applyCenter";
//    }
//    [MobClick event:itemName];
//    
//}

-(void)contentViewIsOpen:(BOOL)open
{
    
    XWGJNavigationController *nav =  (XWGJNavigationController *)self.selectedViewController;
    switch (self.selectedIndex) {
        case 0:{
            HomeViewContViewController *home = ( HomeViewContViewController *)nav.viewControllers[0];
            home.clickType = HomePageClickItemTypeNoClick;
        }
            break;
        case 1:
            break;
        case 2:
            break;
        case 3:{
            MeViewController *me = ( MeViewController *)nav.viewControllers[0];
            me.clickType = CenterClickItemTypeNoClick;
        }
            break;
        default:
            break;
    }
    
}


@end
