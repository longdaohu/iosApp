//
//  PersonSectionView.m
//  MyOffer
//
//  Created by xuewuguojie on 15/10/9.
//  Copyright © 2015年 UVIC. All rights reserved.
//

#import "PersonSectionView.h"
@interface PersonSectionView ()
@property (weak, nonatomic) IBOutlet UIImageView *secionIcon;

@end

@implementation PersonSectionView


-(void)setSectionNumber:(NSInteger )sectionNumber{
    _sectionNumber = sectionNumber;
    
    if (sectionNumber ==0 ) {
        
        
       self.sectionTitleLabel.text =  GDLocalizedString(@"ApplicationProfile-002");//@"请您选择你的留学意向";
        
        [self.secionIcon  setImage:[UIImage imageNamed:@"uni-list"]];
        
    }else
    {
        self.sectionTitleLabel.text =   GDLocalizedString(@"ApplicationProfile-0013");// @"请填写您的背景资料";
         [self.secionIcon  setImage:[UIImage imageNamed:@"world_map"]];

    }
}
@end
