//
//  UniversityRightView.h
//  myOffer
//
//  Created by xuewuguojie on 16/8/26.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^UniversityRightViewwBlock)(UIButton *sender);
@interface UniversityRightView : UIView
@property(nonatomic,copy)UniversityRightViewwBlock  actionBlock;
//分享
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;
//收藏
@property (weak, nonatomic) IBOutlet UIButton *favoriteBtn;
//是否收藏
@property(nonatomic,assign)BOOL favorited;


@end
