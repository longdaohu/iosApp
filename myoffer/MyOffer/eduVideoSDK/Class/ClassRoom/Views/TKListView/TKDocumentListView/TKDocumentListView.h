//
//  TKDocumentListView.h
//  EduClassPad
//
//  Created by ifeng on 2017/6/13.
//  Copyright © 2017年 beijing. All rights reserved.
//  课件库

#import <UIKit/UIKit.h>
#import "TKMacro.h"
#import "TKEduSessionHandle.h"
#import "TKEduRoomProperty.h"
@class TKOneToMoreRoomController;

@protocol TKDocumentListDelegate <NSObject>
- (void)watchFile;
- (void)deleteFile;
@end

@interface TKDocumentListView : UIView<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, weak) id<TKDocumentListDelegate> documentDelegate;

@property (nonatomic,weak)TKOneToMoreRoomController*  delegate;

@property (nonatomic, copy) void(^titleBlock)(NSString *title);

@property (nonatomic, assign) BOOL isShow;

-(instancetype)initWithFrame:(CGRect)frame;

-(void)show:(FileListType)aFileListType isClassBegin:(BOOL)isClassBegin;

-(void)hide;

- (void)reloadData;
@end
