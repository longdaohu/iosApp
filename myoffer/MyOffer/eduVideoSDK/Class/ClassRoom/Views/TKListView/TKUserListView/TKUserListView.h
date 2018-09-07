//
//  TKUserListView.h
//  EduClass
//
//  Created by lyy on 2018/5/31.
//  Copyright © 2018年 talkcloud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TKBaseView.h"

@interface TKUserListView : TKBaseView

- (id)initWithFrame:(CGRect)frame userList:(NSString *)userListController;
- (void)dismissAlert;

@end
