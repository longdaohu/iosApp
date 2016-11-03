//
//  XUTopToolView.m
//  XUObject
//
//  Created by xuewuguojie on 16/4/18.
//  Copyright © 2016年 xuewuguojie. All rights reserved.
//

#import "XBTopToolView.h"
@interface XBTopToolView ()
//黑色背景
@property(nonatomic,strong)UIView *blackView;
@property(nonatomic,strong)UIView *bgView;
//选中View
@property(nonatomic,strong)UIImageView *focusView;
//按钮数组
@property(nonatomic,strong)NSArray *itemArr;
//按钮Title数组
@property(nonatomic,strong)NSArray *name_itemArr;
//选中的按钮
@property(nonatomic,strong)UIButton *lastBtn;

@end

@implementation XBTopToolView

+(instancetype)View
{
    return [[self alloc] initWithFrame:CGRectMake(0, 60,XScreenWidth, 50)];
}


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        
        self.blackView =[[UIView alloc] init];
        CGFloat blackH = TOP_HIGHT;
        CGFloat blackX = 10;
        CGFloat blackY = 0;
        CGFloat blackW = XScreenWidth - 2*blackX;
        self.blackView.frame = CGRectMake(blackX, blackY, blackW, blackH);
        [self makeView:self.blackView andCornerRadius: blackH * 0.5];
        self.blackView.clipsToBounds = YES;
        UIColor *color =  [UIColor colorWithWhite:0 alpha:0.5];

        self.blackView.backgroundColor = color;
        [self addSubview:self.blackView];
        
        
        CGFloat lineMargin = self.blackView.frame.size.width/3;
        CGFloat linew = 1;
        CGFloat lineh = 20;
        CGFloat liney = (self.blackView.frame.size.height - lineh)*0.5;
        for (int i = 0; i < 2; i++) {
             CGFloat linex = lineMargin * (i+1);
            UIView *line =[[UIView alloc] initWithFrame:CGRectMake(linex, liney,linew, lineh)];
            line.backgroundColor = [UIColor lightGrayColor];
            [self.blackView addSubview:line];
        }
        [self lineHidenIndex:0];

        
        self.bgView =[[UIView alloc] initWithFrame:self.blackView.frame];
        [self addSubview:self.bgView];
        
        
        CGFloat focusx = 0;
        CGFloat focusy = 0;
        CGFloat focusw = lineMargin;
        CGFloat focush = blackH;
        self.focusView =[[UIImageView alloc] initWithFrame:CGRectMake(focusx, focusy, focusw, focush)];
        self.focusView.layer.borderWidth = 1;
        self.focusView.layer.borderColor =  [UIColor colorWithWhite:0 alpha:0.5].CGColor;
        self.focusView.layer.cornerRadius = blackH * 0.5;
        self.focusView.layer.masksToBounds = YES;
        [self.bgView addSubview:self.focusView];
        self.focusView.image = self.itemImages[0];
        
        
        CGFloat btnw = lineMargin;
        CGFloat btnh = blackH;
        CGFloat btny = 0;
        NSMutableArray *temps = [NSMutableArray array];

        for (int i = 0; i < 3; i++) {
            CGFloat btnx = btnw * i;
            UIButton *sender =[[UIButton alloc] initWithFrame:CGRectMake(btnx, btny,btnw, btnh)];
            [sender setTitle:self.name_itemArr[i] forState:UIControlStateNormal];
            [sender setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
            [sender addTarget:self action:@selector(tap:) forControlEvents:UIControlEventTouchUpInside];
            sender.tag = i;
            [self.bgView addSubview:sender];
            [temps addObject:sender];

        }
        self.itemArr = [temps copy];
        
        self.lastBtn = self.itemArr[0];
        self.lastBtn.enabled = NO;
        
     }
    return self;
}

-(NSArray *)itemImages
{
    if (!_itemImages) {
        
        NSString *path = [[NSHomeDirectory()stringByAppendingPathComponent:@"Documents"]stringByAppendingPathComponent:@"items"];
        NSData *imageData_arr =[NSData dataWithContentsOfFile:path];
        _itemImages = [NSKeyedUnarchiver unarchiveObjectWithData:imageData_arr];
    }
    return _itemImages;
}


-(void)makeView:(UIView *)sender andCornerRadius:(CGFloat)raduis
{
    sender.layer.cornerRadius = raduis;
    sender.layer.masksToBounds = YES;
    
}


-(NSArray *)name_itemArr{
    
    if (!_name_itemArr) {
        
        _name_itemArr =@[@"留学流程",@"申请攻略",@"疑难解答"];
    }
    return _name_itemArr;
}


-(void)SelectButtonIndex:(NSInteger)index
{
    UIButton *sender =(UIButton *)self.itemArr[index];
    
    [self moveWithButton:sender];
}



-(void)moveWithButton:(UIButton *)sender
{
    self.lastBtn.enabled = YES;
    self.lastBtn = sender;
    self.lastBtn.enabled = NO;
    
    
    [UIView transitionWithView:self.focusView duration:0.3 options:UIViewAnimationOptionCurveEaseIn |UIViewAnimationOptionTransitionCrossDissolve animations:^{
        
        switch (sender.tag) {
            case 0:{
                [self lineHidenIndex:0];
                [self lineHidenNoIndex:1];
            }
                break;
            case 2:{
                [self lineHidenIndex:1];
                [self lineHidenNoIndex:0];
                
            }
                break;
            default:
            {
                [self lineHidenIndex:0];
                [self lineHidenIndex:1];
                
            }
                break;
        }

        
        self.focusView.frame = sender.frame;

        self.focusView.image = self.itemImages[sender.tag];
        
    } completion:^(BOOL finished) {
        
        
    }];
    
}
 
-(void)tap:(UIButton *)sender
{
   
    [self moveWithButton:sender];
    
    if ([self.delegate respondsToSelector:@selector(XTopToolView:andButtonItem:)]) {
        
        [self.delegate XTopToolView:self andButtonItem:sender];
    }
    
}


-(void)lineHidenIndex:(NSInteger)index{
    UIView *line = (UIView *)self.blackView.subviews[index];
    line.alpha = 0;
}

-(void)lineHidenNoIndex:(NSInteger)index{
    UIView *line = (UIView *)self.blackView.subviews[index];
    line.alpha = 1;
}

@end
