//
//  SMDetailHeaderView.h
//  myOffer
//
//  Created by xuewuguojie on 2017/7/21.
//  Copyright © 2017年 UVIC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMDetailHeaderFrame.h"

typedef void(^SMDetailHeaderBlock)(BOOL show_guest_intro,UIButton *sender);
@interface SMDetailHeaderView : UIView

@property(nonatomic,strong)SMDetailHeaderFrame *header_frame;
@property(nonatomic,copy)SMDetailHeaderBlock actionBlock;


@end
