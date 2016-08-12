//
//  LeftButtonView.h
//  NewFeatureProject
//
//  Created by xuewuguojie on 16/7/18.
//  Copyright © 2016年 xuewuguojie. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^LeftBarButtonItemViewBlock)(UIButton *sender);
@interface LeftBarButtonItemView : UIView
@property(nonatomic,strong)UIButton *iconView;
@property(nonatomic,strong)UILabel  *countLab;
@property(nonatomic,copy)NSString   *countStr;
@property(nonatomic,copy)LeftBarButtonItemViewBlock actionBlock;
+(instancetype)leftView;
@end
