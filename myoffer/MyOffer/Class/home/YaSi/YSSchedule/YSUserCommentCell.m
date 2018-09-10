//
//  YSUserCommentCell.m
//  MyOffer
//
//  Created by xuewuguojie on 2018/8/31.
//  Copyright © 2018年 UVIC. All rights reserved.
//

#import "YSUserCommentCell.h"
#import "YSCommentItem.h"

@interface YSUserCommentCell()
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UIStackView *bgView;

@end

@implementation YSUserCommentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    for (NSInteger index = 0; index < self.bgView.subviews.count; index++) {
        UIButton *item = self.bgView.subviews[index];
        item.tag = (index + 1);
        [item setImage:XImage(@"star_selected") forState:UIControlStateSelected];
        [item setImage:XImage(@"star_nomal") forState:UIControlStateNormal];
        item.userInteractionEnabled = NO;
    }

}


- (void)setItem:(YSCommentItem *)item{
    _item = item;
    self.titleLab.text = item.title;
    item.index_selected = 0;
    for (NSInteger index = 0; index < self.bgView.subviews.count; index++) {
        UIButton *sender = self.bgView.subviews[index];
        sender.selected = NO;
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    UITouch *touch = touches.anyObject;
    [self starViewWithTouch:touch];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
 
    UITouch *touch = touches.anyObject;
    [self starViewWithTouch:touch];
}

- (void)starViewWithTouch:(UITouch *)touch{
    
    CGPoint pt = [touch locationInView:self.bgView];
    if (pt.x <= 0 ) return;
    for (UIButton *item in self.bgView.subviews) {
        if (pt.x >= item.frame.origin.x) {
            item.selected = YES;
            self.item.index_selected = item.tag;
        }else{
            item.selected = NO;
        }
    }
}


@end
