//
//  TKMacro.h
//  whiteBoardDemo
//
//  Created by ifeng on 2017/2/28.
//  Copyright © 2017年 beijing. All rights reserved.
//

#ifndef TKMacro_h
#define TKMacro_h
#ifdef DEBUG
#define TKLog(...) NSLog(__VA_ARGS__)
#else
#define TKLog(...) do { } while (0)
#endif

#import <UIKit/UIKit.h>

#define TKMainWindow  [UIApplication sharedApplication].keyWindow

//色值设置
#define UIColorRGB(rgb) ([[UIColor alloc] initWithRed:(((rgb >> 16) & 0xff) / 255.0f) green:(((rgb >> 8) & 0xff) / 255.0f) blue:(((rgb) & 0xff) / 255.0f) alpha:1.0f])
#define UIColorRGBA(rgb,a) ([[UIColor alloc] initWithRed:(((rgb >> 16) & 0xff) / 255.0f) green:(((rgb >> 8) & 0xff) / 255.0f) blue:(((rgb) & 0xff) / 255.0f) alpha:a])
#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1.0]
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:a]



#define RGBACOLOR_PromptWhite       RGBCOLOR(249, 249, 249)
#define RGBACOLOR_PromptRed         RGBCOLOR(215, 0, 0)
#define RGBACOLOR_PromptYellow      RGBCOLOR(155, 136, 58)
#define RGBACOLOR_PromptYellowDeep  RGBCOLOR(206, 203, 48)
#define RGBACOLOR_PromptBlue        RGBCOLOR(78, 100, 196)

#define RGBACOLOR_teacherTextColor_Red      RGBCOLOR(208, 59, 7)
#define RGBACOLOR_studentTextColor_Yellow   RGBCOLOR(244, 209, 12)
#define RGBACOLOR_ClassBegin_RedDeep        RGBCOLOR(207,65, 21)
#define RGBACOLOR_ClassEnd_Red              RGBCOLOR(121, 69, 67)
#define RGBACOLOR_Title_White               RGBCOLOR(115, 115, 115)
#define RGBACOLOR_RAISEHAND_HOLD            RGBCOLOR(179, 38, 17)

#define RGBACOLOR_ClassBeginAndEnd          UIColorRGB(0xcf4014)
#define RGBACOLOR_muteAudio_Normal          UIColorRGB(0x784442)
#define RGBACOLOR_muteAudio_Select          UIColorRGB(0xd3585e)
#define RGBACOLOR_unMuteAudio_Normal        UIColorRGB(0x375b9e)
#define RGBACOLOR_unMuteAudio_Select        UIColorRGB(0x5068cd)
#define RGBACOLOR_RewardColor               UIColorRGB(0xda7c17)


#define TKFont(s) [UIFont fontWithName:@"PingFang-SC-Light" size:s]

// 屏幕高度
#define ScreenH [UIScreen mainScreen].bounds.size.height
// 屏幕宽度
#define ScreenW [UIScreen mainScreen].bounds.size.width


#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_IPHONE_X ((ScreenW == 812.0f) ? YES : NO)
#define IS_PAD (UI_USER_INTERFACE_IDIOM()== UIUserInterfaceIdiomPad)

// 状态栏高度
#define StatusH 20
//导航栏高度
#define TKNavHeight 54
//屏幕比例，相对pad 1024 * 768
#define Proportion (ScreenH/768.0)

#define TITLE_FONT TKFont(16)
#define TEXT_FONT TKFont(14)
#define Name_FONT TKFont(15)

#define BUNDLE_NAME @ "Resources.bundle"

#define BUNDLE [NSBundle bundleWithPath: [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent: BUNDLE_NAME]]

#define LOADIMAGE(name) [UIImage imageWithContentsOfFile:[[BUNDLE resourcePath] stringByAppendingPathComponent:name]]

#define LOADWAV(name) [[BUNDLE resourcePath] stringByAppendingPathComponent:name]

#define MTLocalized(s) [BUNDLE localizedStringForKey:s value:@"" table:nil]

 #define IS_CH_SYMBOL(chr) ((int)(chr)>127)

//百度翻译
static NSString *const sAPP_ID_BaiDu = @"20180130000119815";
static NSString *const sSECURITY_KEY = @"MeLC5NI37txuT_wtTd0B";
static NSString *const sTRANS_API_HOST = @"http://api.fanyi.baidu.com/api/trans/vip/translate";


static  NSString *const sMobile               = @"mobile";//拍照上传入口
static  NSString *const sTKAppVersion               = @"tkAppVersion";//app的version版本标识
static  NSString *const sLowConsume                 = @"LowConsume";
static  NSString *const sChairmancontrol            = @"chairmancontrol";
static  NSString *const sClassBegin                 = @"ClassBegin";
static  NSString *const sWBPageCount                = @"WBPageCount";//加页
static  NSString *const sAddBoardPage_WBPageCount   = @"AddBoardPage_WBPageCount";
static  NSString *const sWBFullScreen               = @"FullScreen";// 全屏
static  NSString *const sShowPage                   = @"ShowPage";//显示文档
static  NSString *const sDocumentFilePage_ShowPage  = @"DocumentFilePage_ShowPage";
static  NSString *const sActionShow                 = @"show";
static  NSString *const sSharpsChange               = @"SharpsChange";//画笔
static  NSString *const sDocumentChange             = @"DocumentChange";//添加或删除文档
static  NSString *const sStreamFailure              = @"StreamFailure";

static  NSString *const sAllAll             = @"__AllAll";

static  NSString *const sVideoDraghandle            = @"videoDraghandle";//视频拖拽
static  NSString *const sVideoSplitScreen            = @"VideoSplitScreen";//分屏
static  NSString *const sVideoZoom                  = @"VideoChangeSize";//视频缩放

static  NSString *const sSubmitAnswers            = @"submitAnswers";//学生答题
static  NSString *const sUserEnterBackGround      = @"userEnterBackGround";//进入后台
static  NSString *const sChangeServerArea         = @"RemoteControl";
static  NSString *const sServerName               = @"servername";//助教协助切换服务器

static  NSString *const sVolume           = @"volume";
static  NSString *const sUpdateTime          = @"UpdateTime";
static  NSString *const sMuteAudio           = @"MuteAudio";
static  NSString *const sRaisehand           = @"raisehand";
static  NSString *const sPrimaryColor        = @"primaryColor";//画笔颜色值
static  NSString *const sPublishstate        = @"publishstate";
static  NSString *const sTellAll             = @"__all";
static  NSString *const sTellNone            = @"__none";
static  NSString *const sTellAllExpectSender = @"__allExceptSender";//除自己以外的所有人
static  NSString *const sTellAllExpectAuditor = @"__allExceptAuditor";//除旁听用户以外的所有人
static  NSString *const sSuperUsers          = @"__allSuperUsers";
static  NSString *const sGiftNumber          = @"giftnumber";
static  NSString *const sGiftinfo            = @"giftinfo";
static  NSString *const sDisablechat         = @"disablechat";
static  NSString *const sCandraw             = @"candraw";
static  NSString *const sPubMsg       = @"pubMsg";//发送信令
static  NSString *const sDelMsg     = @"delMsg";//删除信令
static  NSString *const sSetProperty         = @"setProperty";//属性设置
static  NSString *const sUdpState            = @"udpstate";//UDP状态发生变化，1是畅通，2是防火墙导致不畅通

static  NSString *const sOnPageFinished      = @"onPageFinished";
static  NSString *const sPrintLogMessage     = @"printLogMessage";
static  NSString *const sChangeWebPageFullScreen      = @"changeWebPageFullScreen";//白板放大事件
static  NSString *const sOnJsPlay            = @"onJsPlay";
static  NSString *const scloseDynamicPptWebPlay    = @"closeDynamicPptWebPlay";//closeNewPptVideo更改为closeDynamicPptWebPlay
static  NSString *const sDisableVideo        = @"disablevideo";
static  NSString *const sDisableAudio        = @"disableaudio";
static  NSString *const sFromId              = @"fromId";
static  NSString *const sUser                = @"User";
static  NSString *const sIsInBackGround      = @"isInBackGround";
static  NSString *const sneedPictureInPictureSmall = @"needPictureInPictureSmall";
// 英练帮公司id
static  NSString *const YLB_COMPANYID        = @"10035";
//公司定义
static  NSString *const DEFAULT_COMPANY      = @"default";
static  NSString *const YLB_COMPANY          = @"yinglianbang";
static  NSString *const ZYW30_COMPANY        = @"zuoyewang30";
static  NSString *const SHARKTOP_COMPANY     = @"sharktop";
static  NSString *const GOGOXMAS_COMPANY     = @"gogoxmas";

//播放mp3，mp4
static  NSString *const sVideo_MediaFilePage_ShowPage   = @"Video_MediaFilePage_ShowPage";
static  NSString *const sAudio_MediaFilePage_ShowPage   = @"Audio_MediaFilePage_ShowPage";
static  NSString *const sMediaProgress                  = @"MediaProgress";
static  NSString *const sMediaProgress_video_1          = @"MediaProgress_video_1";
static  NSString *const sMediaProgress_audio_1          = @"MediaProgress_audio_1";

//大规模教师
static  NSString *const sBigRoom                         =@"BigRoom";
//白板类型
static  NSString *const sVideoWhiteboard                         = @"VideoWhiteboard";
//全体禁言
static  NSString *const sEveryoneBanChat                         = @"EveryoneBanChat";
//音频教室
static  NSString *const sOnlyAudioRoom                           = @"OnlyAudioRoom";
//视频标注相关
static  NSString *const sPrintLogMessage_videoWhiteboardPage     = @"printLogMessage_videoWhiteboardPage";
static  NSString *const sOnPageFinished_videoWhiteboardPage      = @"onPageFinished_videoWhiteboardPage";
static  NSString *const sPubMsg_videoWhiteboardPage              = @"pubMsg_videoWhiteboardPage";
static  NSString *const sDelMsg_videoWhiteboardPage              = @"delMsg_videoWhiteboardPage";

//拍摄照片、选择照片上传
static  NSString *const sTakePhotosUploadNotification = @"sTakePhotosUploadNotification";
static  NSString *const sChoosePhotosUploadNotification = @"sChoosePhotosUploadNotification";

//#define Debug 1;
#define Realese 1;

static  NSString *const sHttp   = @"http";
static  NSString *const sPort   = @"80";
#ifdef Debug
static  NSString *const sHost   = @"global.talk-cloud.neiwang";

#else
static  NSString *const sHost   = @"global.talk-cloud.net";
//static  NSString *const sHost   = @"demo.talk-cloud.net";
#endif

#define iOS7 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
#define iOS7Later ([UIDevice currentDevice].systemVersion.floatValue >= 7.0f)
#define iOS8Later ([UIDevice currentDevice].systemVersion.floatValue >= 8.0f)
#define iOS9Later ([UIDevice currentDevice].systemVersion.floatValue >= 9.0f)
#define iOS9_1Later ([UIDevice currentDevice].systemVersion.floatValue >= 9.1f)
#define iOS10_0Later ([UIDevice currentDevice].systemVersion.floatValue >= 10.0f)

#define tk_weakify(var)   __weak typeof(var) weakSelf = var
#define tk_strongify(var) __strong typeof(var) strongSelf = var

static NSString *const kTKMethodNameKey = @"TKCacheMsg_MethodName"; //缓存函数名
static NSString *const kTKParameterKey = @"TKCacheMsg_Parameter";  //缓存参数

//模板
static NSString *const TKDefaultTPL = @"default";
static NSString *const TKClassicTPL = @"classic";
//皮肤
static NSString *const TKDefaultSkin = @"default";
static NSString *const TKBlackSkin = @"black";
static NSString *const TKOriginSkin = @"origin";

//
static NSString *const TKKickTime = @"TKKickTime";


#endif /* TKMacro_h */
