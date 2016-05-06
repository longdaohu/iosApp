//
//  ApplySectionView.m
//  MyOffer
//
//  Created by xuewuguojie on 15/10/14.
//  Copyright © 2015年 UVIC. All rights reserved.
//

#import "ApplySectionView.h"

@interface ApplySectionView ()
@property(nonatomic,strong)LogoView *logoImageView;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *subTitleLabel;
@property(nonatomic,strong)UILabel *areaLabel;
@property(nonatomic,strong)UILabel *rankLabel;
@property(nonatomic,strong)UIButton *addButton;
@property(nonatomic,strong)UIButton *cancelButton;
@property(nonatomic,strong)UIView *sectionBackgroud;

@end

@implementation ApplySectionView

-(void)awakeFromNib
{
    [super awakeFromNib];
    
    self.cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(5, 20, 40, 40)];
    self.cancelButton.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -15);
//    [self.cancelButton setImage:[UIImage imageNamed:@"check-icons"] forState:UIControlStateNormal];
    self.cancelButton.tag = 11;
    [self.cancelButton addTarget:self action:@selector(sectionViewButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.cancelButton];
    
    self.sectionBackgroud =[[UIView alloc] initWithFrame:CGRectMake(0,0, APPSIZE.width, 100)];
    self.sectionBackgroud.backgroundColor =[UIColor whiteColor];
    [self addSubview: self.sectionBackgroud];
    
    self.logoImageView =[[LogoView alloc] initWithFrame:CGRectMake(15, 15, 70, 70)];
    [self.sectionBackgroud addSubview:self.logoImageView];
    
    CGFloat tx = CGRectGetMaxX(self.logoImageView.frame) +8;
    CGFloat ty = 15;
    CGFloat tw =  APPSIZE.width - (tx+33);
    CGFloat th = 17;
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(tx,ty,tw,th)];
    self.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [self.sectionBackgroud addSubview:self.titleLabel];
    
    CGFloat sx = tx;
    CGFloat sy = CGRectGetMaxY(self.titleLabel.frame);
    CGFloat sw = tw;
    CGFloat sh = th;
    self.subTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(sx,sy,sw,sh)];
    self.subTitleLabel.font = [UIFont systemFontOfSize:14.0f];
    [self.sectionBackgroud addSubview:self.subTitleLabel];

    CGFloat ax = tx;
    CGFloat ay = CGRectGetMaxY(self.subTitleLabel.frame) + 8;
    CGFloat aw = tw;
    CGFloat ah = 14;
    self.areaLabel = [[UILabel alloc] initWithFrame:CGRectMake(ax,ay,aw,ah)];
    self.areaLabel.font = [UIFont systemFontOfSize:12.0f];
    self.areaLabel.textColor =[UIColor darkGrayColor];
    [self.sectionBackgroud addSubview:self.areaLabel];
    
    
    CGFloat rx = tx;
    CGFloat ry = CGRectGetMaxY(self.areaLabel.frame);
    CGFloat rw = tw;
    CGFloat rh = 14;
    self.rankLabel = [[UILabel alloc] initWithFrame:CGRectMake(rx,ry,rw,rh)];
    self.rankLabel.font = [UIFont systemFontOfSize:12.0f];
    self.rankLabel.textColor =[UIColor darkGrayColor];
    [self.sectionBackgroud addSubview:self.rankLabel];
    
    
     self.addButton =[[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.rankLabel.frame)- 10,35, 30, 30)];
    [self.addButton setImage:[UIImage imageNamed:@"plus"] forState:UIControlStateNormal];
     self.addButton.tag = 10;
    [self.addButton addTarget:self action:@selector(sectionViewButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.sectionBackgroud addSubview:self.addButton];
 
    
}
-(void)sectionViewButtonPressed:(UIButton *)sender
{
    if (sender.tag == 11) {
        NSString *imageName = self.isSelected ? @"check-icons":@"check-icons-yes";
        [self.cancelButton setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
        self.isSelected = !self.isSelected ;
    }
           if (self.actionBlock) {
            self.actionBlock(sender);
         }
    
 }


-(void)setSectionInfo:(NSDictionary *)sectionInfo
{
    _sectionInfo = sectionInfo;
    self.titleLabel.text = sectionInfo[@"name"];
    self.subTitleLabel.text = sectionInfo[@"official_name"];
    
    self.areaLabel.text =[NSString stringWithFormat:@"%@：%@ - %@",GDLocalizedString(@"UniversityDetail-005"), sectionInfo[@"country"], sectionInfo[@"state"]];
    self.rankLabel.text = [NSString stringWithFormat:@"%@：%@",GDLocalizedString(@"ApplicationStutasVC-001"),[sectionInfo[@"ranking_ti"] intValue] == 99999 ? @"暂无排名" : sectionInfo[@"ranking_ti"]];
    [self.logoImageView.logoImageView KD_setImageWithURL:sectionInfo[@"logo"]];
    
}

-(void)setIsEdit:(BOOL)isEdit
{
    _isEdit = isEdit;
    
    if (isEdit) {
            CGPoint center =self.sectionBackgroud.center;
            center.x +=45;
            self.sectionBackgroud.center = center;
     }
    
}

-(void)setIsSelected:(BOOL)isSelected
{
    _isSelected = isSelected;
    NSString *imageName = self.isSelected ? @"check-icons-yes":@"check-icons";
    [self.cancelButton setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
   
    
}

@end
