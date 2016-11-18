//
//  PipeiCountryCell.m
//  myOffer
//
//  Created by xuewuguojie on 2016/11/18.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import "PipeiCountryCell.h"
#import "PipeiCountryView.h"
@interface PipeiCountryCell ()
@property(nonatomic,strong)PipeiCountryView *uk;
@property(nonatomic,strong)PipeiCountryView *au;

@end


@implementation PipeiCountryCell
+ (instancetype)cellWithTableView:(UITableView *)tableView{
    
    static NSString *identify = @"editCountry";
    
    PipeiCountryCell *cell =[tableView dequeueReusableCellWithIdentifier:identify];
    
    if (!cell) {
        
        cell =[[PipeiCountryCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }
    
    cell.contentView.backgroundColor = XCOLOR_BG;

    return cell;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        PipeiCountryView *uk = [[PipeiCountryView alloc] init];
        uk.contryName = @"英国";
        uk.actionBlock = ^(NSString *country){
        
            [self configrationUI:country];
        };
        self.uk = uk;
        [self.contentView addSubview:uk];
    
        PipeiCountryView *au = [[PipeiCountryView alloc] init];
        au.contryName = @"澳洲";
        au.actionBlock = ^(NSString *country){
            
            [self configrationUI:country];

        };
        self.au = au;
        [self.contentView addSubview:au];

    }
    
    return self;
}


- (void)layoutSubviews{

    [super layoutSubviews];
    
    CGSize contentSize = self.bounds.size;
    
    CGFloat ukX = PADDING_TABLEGROUP;
    CGFloat ukY = 0;
    CGFloat ukW = 0.5 * (contentSize.width - 3 * PADDING_TABLEGROUP);
    CGFloat ukH = contentSize.height;
    self.uk.frame = CGRectMake(ukX, ukY, ukW, ukH);
    
    CGFloat auX = CGRectGetMaxX(self.uk.frame) + PADDING_TABLEGROUP;
    CGFloat auY = ukY;
    CGFloat auW = ukW;
    CGFloat auH = ukH;
    self.au.frame = CGRectMake(auX, auY, auW, auH);
    
    
}


-(void)setCountryName:(NSString *)countryName{

    _countryName = countryName;
    
    if ([countryName isEqualToString:@"英国"]) {
        
        [self.uk countryIsSelected:YES];
     }
    
    if ([countryName isEqualToString:@"澳大利亚"]) {
  
        [self.au countryIsSelected:YES];

    }
 
}

- (void)configrationUI:(NSString *)country{
   
    
    if ([country isEqualToString:@"英国"]) {
        
        [self.uk countryIsSelected:YES];
        [self.au countryIsSelected:NO];

    }else{
    
        [self.uk countryIsSelected:NO];
        [self.au countryIsSelected:YES];
     }
    
}


@end
