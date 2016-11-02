//
//  UniversityNavView.m
//  myOffer
//
//  Created by xuewuguojie on 16/8/26.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import "UniversityNavView.h"
@interface UniversityNavView ()
//标题
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
//背景图片
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;

@end


@implementation UniversityNavView

-(void)awakeFromNib{

    
    NSString *path = [[NSHomeDirectory()stringByAppendingPathComponent:@"Documents"]stringByAppendingPathComponent:@"nav.png"];
    self.bgImageView.image =  [UIImage imageWithData:[NSData dataWithContentsOfFile:path]];
    self.clipsToBounds = YES;
    self.bgImageView.alpha = 0;
    
    
    XWeakSelf
    self.rightView = [[NSBundle mainBundle] loadNibNamed:@"UniversityRightView" owner:self options:nil].lastObject;
  
    [self.rightView noShadowWithShare];
    
     self.rightView.actionBlock = ^(UIButton *sender){
         
        [weakSelf onclick:sender];
    
     };
    
    
    [self insertSubview:self.rightView  aboveSubview:self.bgImageView];
    
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
    
    self.titleLab.font = [UIFont boldSystemFontOfSize:17];
    
    [super awakeFromNib];
    
    self.frame = CGRectMake(0, 0, XScreenWidth, XNav_Height);
    
    
    
    CGRect rightRect = self.rightView.frame;
    rightRect.origin.y = XNav_Height;
    rightRect.size.width = 80  +  XMARGIN;
    rightRect.origin.x = XScreenWidth - rightRect.size.width - 2 * XMARGIN;
    self.rightView.frame = rightRect;
    
}

- (IBAction)backClick:(id)sender {
    
    [self onclick:sender];
}

- (void)onclick:(UIButton *)sender{

    if (self.actionBlock) {
        
        self.actionBlock(sender);
    }
}


- (void)setTitleName:(NSString *)titleName{

    _titleName = titleName;
    
    self.titleLab.text = titleName;

}

- (void)setNav_Alpha:(CGFloat)nav_Alpha{

    _nav_Alpha = nav_Alpha;
    
    self.titleLab.alpha  = nav_Alpha;
}


- (void)scrollViewContentoffset:(CGFloat)offsetY  andContenHeight:(CGFloat)contentHeight{

    
    self.bgImageView.alpha  =  offsetY / contentHeight;
    
    /*
     *   contentHeight  [收藏、分享按钮]的superView 的frame.origin.y  - 导航栏的高度
     *   - 20           20是[收藏、分享按钮]的一半高度
     *   contentHeight - 20   可以在滚动条  滚动到 [收藏、分享按钮]顶部 监听关键点
     */
    CGFloat rightViewDistance = contentHeight - 20 - offsetY ;
    
 
    if (rightViewDistance < 0) {
        
        self.rightView.top =  rightViewDistance <= -44 ? 20 : (XNav_Height + rightViewDistance);
        
    }else{
    
        self.rightView.top =  XNav_Height;
        
    }
     
}

- (void)scrollViewForGongLueViewContentoffsetY:(CGFloat)offsetY andHeight:(CGFloat)contentHeight{
    
    self.bgImageView.alpha =  offsetY / contentHeight;
    
}

- (void)navigationWithFavorite:(BOOL)favorite{
    
    [self.rightView noShadowWithFavorited:favorite];
    
}


- (void)layoutSubviews{

    [super layoutSubviews];
    

    
}




@end


