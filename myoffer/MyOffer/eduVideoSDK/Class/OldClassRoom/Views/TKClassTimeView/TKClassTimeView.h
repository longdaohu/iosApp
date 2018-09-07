//
//  TKClassTimeView.h
//  EduClassPad
//
//  Created by ifeng on 2017/6/8.
//  Copyright © 2017年 beijing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TKMacro.h"
@interface TKClassTimeView : UIView


-(void)setClassTime:(NSTimeInterval)aLocalTime;
-(void)showPromte:(PromptType)aPromptType aPassEndTime:(int)aPassEndTime aPromptTime:(int)aPromptTime;
-(void)hidePromptView;
-(void)setToZeroTime;
@end
