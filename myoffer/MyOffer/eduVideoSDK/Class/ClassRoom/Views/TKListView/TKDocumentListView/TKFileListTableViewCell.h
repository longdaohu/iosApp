//
//  TKFileListTableViewCell.h
//  EduClass
//
//  Created by lyy on 2018/4/27.
//  Copyright © 2018年 talkcloud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TKMacro.h"
@class TKMediaDocModel,TKDocmentDocModel,RoomUser;


@protocol listProtocol <NSObject>

-(void)watchFile:(UIButton *)aButton aIndexPath:(NSIndexPath*)aIndexPath;
-(void)deleteFile:(UIButton *)aButton aIndexPath:(NSIndexPath*)aIndexPath;

@end

@interface TKFileListTableViewCell : UITableViewCell

@property (weak, nonatomic) id<listProtocol> delegate;

@property (weak, nonatomic) IBOutlet UIButton *watchBtn;

@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;

@property (nonatomic,assign)  FileListType  iFileListType;
@property (nonatomic, strong) NSString *text;
@property (strong, nonatomic) TKMediaDocModel *iMediaDocModel;
@property (strong, nonatomic) TKDocmentDocModel *iDocmentDocModel;
@property (strong, nonatomic) RoomUser *iRoomUserModel;
@property (strong, nonatomic) NSIndexPath *iIndexPath;

@property (nonatomic, assign) BOOL hiddenDeleteBtn;

-(void)configaration:(id)aModel withFileListType:(FileListType)aFileListType isClassBegin:(BOOL)isClassBegin;

@end
