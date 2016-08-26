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
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;
@property (weak, nonatomic) IBOutlet UIButton *favoriteBtn;
@property(nonatomic,assign)BOOL favorited;


@end
