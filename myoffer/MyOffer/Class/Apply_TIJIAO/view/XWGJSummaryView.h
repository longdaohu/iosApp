//
//  XWGJSummaryView.h
//  myOffer
//
//  Created by sara on 16/3/3.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XWGJSummaryView : UIView
@property(nonatomic,copy)NSString *summary;
@property(nonatomic,strong)UIView *line;

+ (instancetype)ViewWithContent:(NSString *)content;
@end
