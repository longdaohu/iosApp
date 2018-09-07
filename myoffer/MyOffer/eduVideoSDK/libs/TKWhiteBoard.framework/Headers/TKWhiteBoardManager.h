//
//  TKWhiteBroadManager.h
//  TKWhiteBroad
//
//  Created by MAC-MiNi on 2018/4/9.
//  Copyright © 2018年 MAC-MiNi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "TKWhiteBoardManagerDelegate.h"
#import <TKRoomSDK/TKRoomSDK.h>


typedef void(^loadFinishedBlock) (void);

typedef NS_ENUM(NSUInteger, TKWhiteBoardErrorCode) {
    TKError_OK,
    TKError_Bad_Parameters,
};

typedef UIView TKWhiteBoardView;


@interface TKWhiteBoardManager : NSObject 

@property (nonatomic, strong) NSDictionary *configration;

@property (nonatomic, readonly) NSDictionary *defaultConfig;

@property (nonatomic, assign) NSNumber *currentFileId;//当前文档id

@property (strong, nonatomic) NSMutableArray *cacheMsgPool;//缓存数据

@property (assign, nonatomic) BOOL UIDidAppear;//

@property (strong, nonatomic) NSMutableArray *preLoadingFileCacheMsgPool;//预加载文档缓存数据

@property (assign, nonatomic) BOOL preloadingFished;

+(instancetype)shareInstance;
/**
 销毁白板
 */
+ (void)destory;

- (void)registerDelegate:(id<TKWhiteBoardManagerDelegate>)delegate configration:(NSDictionary *)config;

- (void)setClassBegin:(BOOL)isBegin;

//创建白板视图
- (TKWhiteBoardView *)createWhiteBoardWithFrame:(CGRect)frame
                              loadComponentName:(NSString *)loadComponentName
                              loadFinishedBlock:(loadFinishedBlock)loadFinishedBlock;
//创建视频标注视图
- (TKWhiteBoardView *)createVideoBoardWithFrame:(CGRect)frame
                              loadComponentName:(NSString *)loadComponentName
                              loadFinishedBlock:(loadFinishedBlock)loadFinishedBlock;

//发送缓存的消息
- (void)sendCacheInformation:(NSMutableArray *)array;

// 设置白板配置项
//- (int)changeWhiteBoardConfigration:(NSDictionary *)configration;

//更新地址
- (void)updateWebAddressInfo;

/**
 创建白板

 @param companyid 公司id
 @return 返回白板数据
 */
- (NSDictionary *)createWhiteBoard:(NSNumber *)companyid;


/**
 添加文档

 @param file 文档
 */
- (void)addDocumentWithFile:(NSDictionary *)file;

/**
 设置默认文档
 */
- (void)setTheCurrentDocumentFileID:(NSNumber *)fileId;

/**
 给白板发送预加载的文档
 */
- (void)sendPreLoadingFile;

//切换文档
- (int)changeDocumentWithFileID:(NSNumber *)fileId isBeginClass:(BOOL)isBeginClass isPubMsg:(BOOL)isPubMsg;

/**
 是否显示工具箱

 @param isShow ture显示  false 不显示
 */
- (void)showToolbox:(BOOL)isShow;

/**
 是否显示画笔工具

 @param isShow 是否显示
 */
- (void)choosePen:(BOOL)isShow;

/**
 是否显示自定义奖杯

 @param isShow 是否显示
 */
- (void)showCustomTrophy:(BOOL)isShow;

/**
 下一页

 @return  是否切到上一页
 */
- (int)nextPage:(BOOL)addPage;

/**
 上一页

 @return 是否切到下一页
 */
- (int)prePage;

/**
 跳转到指定页面

 @param pageNum 跳转的页码
 @return 是否跳转成功
 */
- (int)skipToPageNum:(NSNumber *)pageNum;

/**
 放大
 */
- (void)enlargeWhiteboard;

/**
 缩小
 */
- (void)narrowWhiteboard;

/**
 全屏
 */
- (void)fullScreen;

/**
 退出全屏
 */
- (void)exitFullScreen;

/**
 打开备注
 */
- (void)openDocumentRemark;

/**
 关闭备注
 */
- (void)closeDocumentRemark;

/**
 重置白板所有的数据
 */
- (void)resetWhiteBoardAllData;

// 刷新白板
- (void)refreshWhiteBoard;

//关闭动态ppt视频播放
- (void)unpublishNetworkMedia:(id)data;

//断开连接
- (void)disconnect:(NSString *)reason;

/**
 删除白板界面

 @param loadComponentName 白板类型
 */
- (void)deleteView:(NSString *)loadComponentName;

- (void)roomWhiteBoardOnDisconnect:(NSString *)reason;

- (void)clearAllData;
@end
