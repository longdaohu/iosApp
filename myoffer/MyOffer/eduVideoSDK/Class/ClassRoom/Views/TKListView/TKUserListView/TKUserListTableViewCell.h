//
//  TKUserListTableViewCell.h
//  EduClass
//
//  Created by lyy on 2018/4/26.
//  Copyright © 2018年 talkcloud. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TKUserListTableViewCellDelegate <NSObject>

-(void)removeblock;

@end

@interface TKUserListTableViewCell : UITableViewCell
@property (nonatomic, weak) id<TKUserListTableViewCellDelegate> delegate;

@property (nonatomic, strong) TKRoomUser *roomUser;
@property (weak, nonatomic) IBOutlet UIButton *editBtn;//授权按钮
//-(void)configaration:(id)aModel withFileListType:(FileListType)aFileListType isClassBegin:(BOOL)isClassBegin;

@end
