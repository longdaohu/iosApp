//
//  TKOpenUrlViewController.m
//  EduClassPad
//
//  Created by ifeng on 2018/1/12.
//  Copyright © 2018年 beijing. All rights reserved.
//

#import "TKOpenUrlViewController.h"
#import "TKEduClassRoom.h"
#import "TKMacro.h"
#import "AppDelegate.h"
@interface TKOpenUrlViewController ()<TKEduRoomDelegate>
@property (strong, nonatomic) NSString *defaultServer;
@property (strong, nonatomic) NSString *storedServer;
@property (nonatomic, assign) NSInteger serverRequestRt;
@property (nonatomic, assign) BOOL isPlayback;
@property (nonatomic, copy) NSString *urlPath;

@end

@implementation TKOpenUrlViewController

-(void)dealloc{
    TKLog(@"TKOpenUrlViewController dealloc");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor colorWithRed:255 green:255 blue:255 alpha:0]];
//    [self.view setBackgroundColor:[UIColor yellowColor]];
    UIButton *tButton = ({
        
        UIButton *tUserButton = [UIButton buttonWithType:UIButtonTypeCustom];
        tUserButton.frame = CGRectMake(0, 0, ScreenW, ScreenH);
        tUserButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        [tUserButton addTarget:self action:@selector(userButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        tUserButton.backgroundColor = [UIColor colorWithRed:255 green:255 blue:255 alpha:0];
        tUserButton;
        
    });
    [self.view addSubview:tButton];
   
}

-(void)userButtonClicked:(UIButton*)button{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)openUrl:(NSString*)aString{
    
//        aString = @"http://global.talk-cloud.net:80/static/h5/index.html#/replay?host=global.talk-cloud.net&domain=test&serial=2105172330&type=0&path=global.talk-cloud.net:8081/r3/2017-12-15/2105172330/1513309368/";
//    aString = @"http://demo.talk-cloud.net:80/static/h5/index.html#/replay?host=demo.talk-cloud.net&domain=newtest&serial=1370449456&type=0&path=demo.talk-cloud.net:8081/demor1/2018-01-07/1370449456/1515319072/";
//        aString = @"http://demo.talk-cloud.net:80/static/h5/index.html#/replay?host=demo.talk-cloud.net&domain=newtest&serial=1227506405&type=3&path=demo.talk-cloud.net:8081/demor1/2018-01-08/1227506405/1515383539/";
    
    aString = [aString stringByRemovingPercentEncoding];
    self.urlPath = aString;
    
    NSArray *tParamArray = [aString componentsSeparatedByString:@"?"];
    if ([tParamArray count]>1) {
        
        if ([tParamArray[0] containsString:@"replay"]) {
            self.isPlayback = YES;
            // 该链接是回放连接
            NSArray *tParamArray2 = [[tParamArray objectAtIndex:1] componentsSeparatedByString:@"&"];
            NSMutableDictionary *tDic = @{}.mutableCopy;
            
            for (int i = 0; i<[tParamArray2 count]; i++) {
                NSArray *tArray= [[tParamArray2 objectAtIndex:i] componentsSeparatedByString:@"="];
                NSString *tKey = [tArray objectAtIndex:0];
                NSString *tValue = [tArray objectAtIndex:1];
                [tDic setValue:tValue forKey:tKey];
            }
            
#ifdef Debug
            // 截取host的服务器地址段
            NSString *server = [NSString stringWithFormat:@"%@", [[[tDic objectForKey:@"host"] componentsSeparatedByString:@"."] firstObject]];
            if (server) {
                [tDic setValue:server forKey:@"server"];
                self.defaultServer = server;
            }
            
            // 如果本地保存了默认服务器，则从选择本地的服务器
            self.storedServer = [[NSUserDefaults standardUserDefaults] objectForKey:@"server"];
            if (self.storedServer != nil) {
                self.defaultServer = self.storedServer;
            }
#else
            // 截取host的服务器地址段
            NSString *server = [NSString stringWithFormat:@"%@", [[[tDic objectForKey:@"host"] componentsSeparatedByString:@"."] firstObject]];
            if (server) {
                [tDic setValue:server forKey:@"server"];
                self.defaultServer = server;
            }
            
            // 如果本地保存了默认服务器，则从选择本地的服务器
            self.storedServer = [[NSUserDefaults standardUserDefaults] objectForKey:@"server"];
            if (self.storedServer != nil) {
                self.defaultServer = self.storedServer;
            }
#endif
            
            [tDic setObject:@(self.isPlayback) forKey:@"playback"];
            NSString *type = tDic[@"type"];
            if (!type || type.length==0) {
                [tDic setObject:@"3" forKey:@"type"];
            }
            [TKEduClassRoom joinPlaybackRoomWithParamDic:tDic ViewController:self Delegate:self isFromWeb:YES];
        } else {
            self.isPlayback = NO;
            NSArray *tParamArray2 = [[tParamArray objectAtIndex:1] componentsSeparatedByString:@"&"];
            NSMutableDictionary *tDic = @{}.mutableCopy;
            
            for (int i = 0; i<[tParamArray2 count]; i++) {
                NSArray *tArray= [[tParamArray2 objectAtIndex:i] componentsSeparatedByString:@"="];
                
                NSString *tKey = [tArray objectAtIndex:0];
                NSString *tValue = [tArray objectAtIndex:1];
                [tDic setValue:tValue forKey:tKey];
                
            }
            
#ifdef Debug
            // 截取host的服务器地址段
            NSString *server = [NSString stringWithFormat:@"%@", [[[tDic objectForKey:@"host"] componentsSeparatedByString:@"."] firstObject]];
            if (server) {
                [tDic setValue:server forKey:@"server"];
                self.defaultServer = server;
            }
            
            // 如果本地保存了默认服务器，则从选择本地的服务器
            self.storedServer = [[NSUserDefaults standardUserDefaults] objectForKey:@"server"];
            if (self.storedServer != nil) {
                self.defaultServer = self.storedServer;
            }
#else
            // 截取host的服务器地址段
            NSString *server = [NSString stringWithFormat:@"%@", [[[tDic objectForKey:@"host"] componentsSeparatedByString:@"."] firstObject]];
            if (server) {
                [tDic setValue:server forKey:@"server"];
                self.defaultServer = server;
            }
            
            // 如果本地保存了默认服务器，则从选择本地的服务器
            self.storedServer = [[NSUserDefaults standardUserDefaults] objectForKey:@"server"];
            if (self.storedServer != nil) {
                self.defaultServer = self.storedServer;
            }
#endif
            
            [tDic setObject:@(self.isPlayback) forKey:@"playback"];
            
            [TKEduClassRoom joinRoomWithParamDic:tDic ViewController:self Delegate:self isFromWeb:YES];
        }
        
    }else{
        
        TKAlertView *alert = [[TKAlertView alloc]initWithTitle:MTLocalized(@"Prompt.prompt") contentText:MTLocalized(@"Prompt.prompt") confirmTitle:MTLocalized(@"Prompt.Know")];
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [alert show];
        });
    
        
    }
}
#pragma mark 横竖屏
-(BOOL)shouldAutorotate{
    return NO;
}
-(UIInterfaceOrientationMask)supportedInterfaceOrientations{

    if (_orientation == UIInterfaceOrientationPortrait) {
         return UIInterfaceOrientationMaskPortrait;
    }
    
    return UIInterfaceOrientationMaskLandscapeRight;
}
-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    if (_orientation == UIInterfaceOrientationPortrait) {
        return UIInterfaceOrientationPortrait;
    }
    return UIInterfaceOrientationLandscapeRight;
}


#pragma mark TKEduEnterClassRoomDelegate
- (void) onEnterRoomFailed:(int)result Description:(NSString*)desc{
    
}
- (void) onKitout:(EKickOutReason)reason{
    
}
- (void) joinRoomComplete{
    
}
- (void) leftRoomComplete{
    
        dispatch_async(dispatch_get_main_queue(), ^{
            if (![TKEduClassRoom shareInstance].enterClassRoomAgain) {
                [self dismissViewControllerAnimated:NO completion:^{
                    [TKEduClassRoom clearWebUrlData];
                }];
            }
        });
   

}
- (void) onClassBegin{
    
}
- (void) onClassDismiss{
    
}
- (void) onCameraDidOpenError{
    
}
#pragma mark TKOpenUrlDelegate
-(void)closeTheOpenUrlViewController{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self dismissViewControllerAnimated:NO completion:nil];
    });
}

@end
