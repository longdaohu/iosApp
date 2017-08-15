//
//  ApplyStatusHistoryCell.m
//  myOffer
//
//  Created by xuewuguojie on 2017/8/14.
//  Copyright © 2017年 UVIC. All rights reserved.
//

#import "ApplyStatusHistoryCell.h"

@interface ApplyStatusHistoryCell ()
@property (weak, nonatomic) IBOutlet UILabel *statusLab;
@property (weak, nonatomic) IBOutlet UILabel *dateLab;
@property (weak, nonatomic) IBOutlet UIView *line;
@property (weak, nonatomic) IBOutlet UIImageView *spodView;

@end

@implementation ApplyStatusHistoryCell
+ (instancetype)cellWithTableView:(UITableView *)talbeView{
    
    ApplyStatusHistoryCell *cell = [talbeView dequeueReusableCellWithIdentifier:NSStringFromClass([ApplyStatusHistoryCell class])];
    
    if (!cell) {
        
        cell = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([ApplyStatusHistoryCell class]) owner:self options:nil].firstObject;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    
}
 
- (void)setHistroyFrame:(ApplyStatusHistoryItemFrame *)histroyFrame{

    _histroyFrame = histroyFrame;
    
    self.statusLab.text = histroyFrame.historyItem.status;
    self.dateLab.text = histroyFrame.historyItem.date_time;
    self.statusLab.textColor = histroyFrame.historyItem.status_color;
    
    [self.spodView setImage:[UIImage imageNamed:histroyFrame.historyItem.image_Name]];
}

@end
