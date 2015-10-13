//
//  PersonSectionView.m
//  MyOffer
//
//  Created by xuewuguojie on 15/10/9.
//  Copyright © 2015年 UVIC. All rights reserved.
//

#import "PersonSectionView.h"
@interface PersonSectionView ()
@property (weak, nonatomic) IBOutlet UIView *xxxV;
@property (weak, nonatomic) IBOutlet UIProgressView *xxxProv;

@end

@implementation PersonSectionView
-(void)awakeFromNib
{
    self.xxxV.clipsToBounds = YES;
    self.xxxV.layer.cornerRadius = 10;
    
    

}

-(void)setProgressValue:(CGFloat)ProgressValue
{
    _ProgressValue = ProgressValue;
    
    
    self.xxxProv.progress = ProgressValue;
    
}

@end
