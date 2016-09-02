//
//  UniversityCell.h
//  myOffer
//
//  Created by xuewuguojie on 16/8/25.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UniItemFrame.h"

@interface UniversityCell : UITableViewCell
@property(nonatomic,strong)UniItemFrame *itemFrame;
@property (strong, nonatomic)LogoView *logo;
@property (strong, nonatomic)UIImageView *anthorView;
@property (strong, nonatomic)UILabel *nameLab;
@property (strong, nonatomic)UILabel *officalLab;
@property (strong, nonatomic)UILabel *addressLab;
@property (strong, nonatomic)UILabel *qsLab;
@property (strong, nonatomic)UILabel *localLab;
@property (strong, nonatomic)UIImageView *hotView;
@property (strong, nonatomic)UIView *paddingView;

+(instancetype)cellWithTableView:(UITableView *)tableView;

@end
