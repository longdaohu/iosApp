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
@property (weak, nonatomic) IBOutlet LogoView *logo;
@property (weak, nonatomic) IBOutlet UIImageView *anthorView;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *officalLab;
@property (weak, nonatomic) IBOutlet UILabel *addressLab;
@property (weak, nonatomic) IBOutlet UILabel *qsLab;
@property (weak, nonatomic) IBOutlet UILabel *localLab;
@property (weak, nonatomic) IBOutlet UIImageView *hotView;

+(instancetype)cellWithTableView:(UITableView *)tableView;

@end
