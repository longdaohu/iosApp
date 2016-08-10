//
//  XWGJNODATASHOWView.h
//  myOffer
//
//  Created by xuewuguojie on 16/1/26.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^NOdataBlock)();
@interface XWGJNODATASHOWView : UIView
@property(nonatomic,assign)CGFloat bgViewY;
@property(nonatomic,copy)NOdataBlock ActionBlock;
@end
