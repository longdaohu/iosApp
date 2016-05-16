//
//  XuFilerView.h
//  cover
//
//  Created by xuewuguojie on 16/5/11.
//  Copyright © 2016年 小米. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FilerButtonItem.h"

@class XuFilerView;
@protocol  XuFilerViewDelegate <NSObject>
-(void)filerViewItemClick:(FilerButtonItem *)sender;

@end

@interface XuFilerView : UIViewController
@property(nonatomic,weak)id <XuFilerViewDelegate> delegate;
@property(nonatomic,strong)NSArray *groups;
@property(nonatomic,assign)CGRect filerRect;

@end
