//
//  MessageTopicHeaderViewController.h
//  myOffer
//
//  Created by xuewuguojie on 2017/7/10.
//  Copyright © 2017年 UVIC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageTopicHeaderViewController : UIViewController
@property(nonatomic,assign)CGFloat header_Height;
@property(nonatomic,strong)NSArray *topices;
//MessageTopicHeaderViewController 的父View
@property(nonatomic,strong)UIView *contain_View;
@property(nonatomic,assign)BOOL containView_scroll_enable;

@end