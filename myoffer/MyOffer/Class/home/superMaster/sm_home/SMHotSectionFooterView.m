
//
//  SMHotSectionFooterView.m
//  myOffer
//
//  Created by xuewuguojie on 2017/7/24.
//  Copyright © 2017年 UVIC. All rights reserved.
//

#import "SMHotSectionFooterView.h"

@interface SMHotSectionFooterView ()
@property (weak, nonatomic) IBOutlet UIButton *loadMoreBtn;

@end


@implementation SMHotSectionFooterView

+ (instancetype)footerWithTitle:(NSString *)title action:(SMHotSectionFooterBlock)action{

    SMHotSectionFooterView *footer = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([SMHotSectionFooterView class]) owner:self options:nil].firstObject;

    footer.moreTitle = title;
    
    footer.actionBlock = action;
    
    return footer;
}

- (void)awakeFromNib{

    [super awakeFromNib];
    
    self.loadMoreBtn.backgroundColor = XCOLOR_RED;
}

- (IBAction)loadMore:(UIButton *)sender {
    
     if (self.actionBlock) {
        
        self.actionBlock();
    }
}

- (void)setMoreColor:(UIColor *)moreColor{

    _moreColor = moreColor;
    
    self.loadMoreBtn.backgroundColor = moreColor;

}

- (void)setMoreTitle:(NSString *)moreTitle{

    _moreTitle = moreTitle;
    
    [self.loadMoreBtn setTitle:moreTitle forState:UIControlStateNormal];
}

- (void)setMoreTitleColor:(UIColor *)moreTitleColor{

    _moreTitleColor = moreTitleColor;
    
    [self.loadMoreBtn setTitleColor:moreTitleColor forState:UIControlStateNormal];
}

@end
