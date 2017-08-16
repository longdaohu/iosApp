//
//  ApplyStatusHistoryCell.m
//  myOffer
//
//  Created by xuewuguojie on 2017/8/14.
//  Copyright © 2017年 UVIC. All rights reserved.
//

#import "ApplyStatusHistoryCell.h"
#import "UIImage+GIF.h"

@interface ApplyStatusHistoryCell ()
@property (weak, nonatomic) IBOutlet UILabel *statusLab;
@property (weak, nonatomic) IBOutlet UILabel *dateLab;
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
    self.dateLab.text = histroyFrame.historyItem.date;
    self.statusLab.textColor = histroyFrame.historyItem.status_color;
    
    
    NSString *name = histroyFrame.historyItem.image_Name;
    if ([name hasSuffix:@".gif"]) {
        
        NSString *path = [[NSBundle mainBundle] pathForResource:@"dot_40x40" ofType:@"gif"];
        NSData *data = [NSData dataWithContentsOfFile:path];
        UIImage *image = [UIImage sd_animatedGIFWithData:data];
        
        self.spodView.image =  image;
        
    }else{
    
        [self.spodView setImage:[UIImage imageNamed:name]];

    }
    

 
    
}

@end
