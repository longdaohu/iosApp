//
//  ApplySectionView.h
//  MyOffer
//
//  Created by xuewuguojie on 15/10/14.
//  Copyright © 2015年 UVIC. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^sectionBlock)();
@interface ApplySectionView : UIView
@property(nonatomic,strong)NSDictionary *sectionInfo;
@property(nonatomic,copy)sectionBlock actionBlock;
@end
