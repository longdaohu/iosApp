//
//  ApplySectionView.h
//  MyOffer
//
//  Created by xuewuguojie on 15/10/14.
//  Copyright © 2015年 UVIC. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^sectionBlock)(UIButton *);
@interface ApplySectionView : UIView
@property (weak, nonatomic) IBOutlet UIView *sectionContentView;
@property(nonatomic,strong)NSDictionary *sectionInfo;
@property(nonatomic,assign)BOOL isEdit;
@property(nonatomic,copy)sectionBlock actionBlock;
@property(nonatomic,assign)BOOL isSelected;

@end
