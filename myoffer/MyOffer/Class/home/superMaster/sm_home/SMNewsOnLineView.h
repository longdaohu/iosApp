//
//  SMNewsOnLineView.h
//  myOffer
//
//  Created by xuewuguojie on 2017/7/20.
//  Copyright © 2017年 UVIC. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SMNewsOnLineViewBlock)(NSString *urlStr);
@interface SMNewsOnLineView : UIView

@property(nonatomic,strong)NSDictionary *offline;

@property(nonatomic,copy)SMNewsOnLineViewBlock actionBlock;

 
@end
