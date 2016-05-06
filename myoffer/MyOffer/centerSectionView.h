//
//  centerSectionView.h
//  myOffer
//
//  Created by xuewuguojie on 15/11/24.
//  Copyright © 2015年 UVIC. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^centerSectionViewBlock)(UIButton *sender);
@interface centerSectionView : UIView
@property(nonatomic,copy)centerSectionViewBlock sectionBlock;
@property (weak, nonatomic) IBOutlet UILabel *pipeiLabel;
@property (weak, nonatomic) IBOutlet UILabel *pipeiCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *favorLabel;
@property (weak, nonatomic) IBOutlet UILabel *favorCountLabel;

@end
