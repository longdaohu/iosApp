//
//  UniversityNavView.m
//  myOffer
//
//  Created by xuewuguojie on 16/8/26.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import "UniversityRightView.h"
#import "UniversityNavView.h"
#import "TopNavView.h"


@interface UniversityNavView ()
//标题
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
//背景图片
@property (weak, nonatomic) IBOutlet TopNavView *bgView;
//收藏、分享
@property(nonatomic,strong)UniversityRightView   *rightView;
//客服
@property (weak, nonatomic) IBOutlet UIButton *QQBtn;

@end


@implementation UniversityNavView

+ (instancetype)ViewWithBlock:(UniversityNavViewBlock)actionBlock{
    
    UniversityNavView *topNavigationView = [[NSBundle mainBundle] loadNibNamed:@"UniversityNavView" owner:self options:nil].lastObject;
    
    topNavigationView.frame = CGRectMake(0, 0, XSCREEN_WIDTH, XNAV_HEIGHT);
    
    topNavigationView.actionBlock = actionBlock;
    
    return  topNavigationView;
}

-(void)awakeFromNib{

    [super awakeFromNib];
    
    self.clipsToBounds = YES;
    
    self.bgView.alpha = 0;
    
    self.QQBtn.tag = NavItemStyleQQ;
   
     XWeakSelf
    self.rightView = [UniversityRightView ViewWithBlock:^(UIButton *sender) {
        
        [weakSelf onclick:sender];

    }];
    
    [self.rightView shareButtonWithShadow:NO];
    
    [self insertSubview:self.rightView  aboveSubview:self.bgView];
    
    self.titleLab.font = [UIFont boldSystemFontOfSize:17];
    
}

- (void)layoutSubviews{

    [super layoutSubviews];
    
    CGSize contentSize = self.bounds.size;
    
    CGRect rightRect = self.rightView.frame;
    rightRect.origin.y = contentSize.height;
    rightRect.size.width = 80  +  XMARGIN;
    rightRect.origin.x = contentSize.width - rightRect.size.width - 2 * XMARGIN;
    self.rightView.frame = rightRect;
}


- (IBAction)backClick:(UIButton *)sender {
    
     sender.tag = NavItemStyleBack;
    
     [self onclick:sender];
}

- (void)onclick:(UIButton *)sender{
    

    [self ViewItem:sender];
 
}

- (IBAction)QQButtonOnClick:(UIButton *)sender {
    
 
    [self ViewItem:sender];

}

- (void)ViewItem:(UIButton *)sender{

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

    
    self.bgView.alpha  =  offsetY / contentHeight;
    
    /*
     *   contentHeight  [收藏、分享按钮]的superView 的frame.origin.y  - 导航栏的高度
     *   - 20           20是[收藏、分享按钮]的一半高度
     *   contentHeight - 20   可以在滚动条  滚动到 [收藏、分享按钮]顶部 监听关键点
     */
    CGFloat rightViewDistance = contentHeight - 20 - offsetY ;
    
 
    if (rightViewDistance < 0) {
        
        self.rightView.top =  rightViewDistance <= -44 ? 20 : (XNAV_HEIGHT + rightViewDistance);
        
    }else{
    
        self.rightView.top =  XNAV_HEIGHT;
        
    }
     
}

- (void)scrollViewForGongLueViewContentoffsetY:(CGFloat)offsetY andHeight:(CGFloat)contentHeight{
    
    self.bgView.alpha =  offsetY / contentHeight;
    
}

- (void)navigationWithFavorite:(BOOL)favorite{
    
    [self.rightView noShadowWithFavorited:favorite];
    
}


- (void)navigationWithRightViewHiden:(BOOL)hiden{

    self.rightView.hidden = hiden;
}

- (void)navigationWithQQHiden:(BOOL)hiden{

    self.QQBtn.hidden = hiden;
}



@end


