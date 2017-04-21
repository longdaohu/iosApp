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
//按钮选项superView
@property(nonatomic,strong)UIView *bgView;
//选中View
@property(nonatomic,strong)UIImageView *focusView;
//按钮数组
@property(nonatomic,strong)NSArray *itemArr;
//选中的按钮
@property(nonatomic,strong)UIButton *lastBtn;
//选中项对应的图片
@property(nonatomic,strong)NSArray *itemImages;

@end

@implementation XBTopToolView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.blackView =[[UIView alloc] init];
        self.blackView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        [self addSubview:self.blackView];
        
        self.bgView =[[UIView alloc] init];
        [self addSubview:self.bgView];
 
        self.focusView =[[UIImageView alloc] init];
        self.focusView.layer.borderWidth = 1;
        self.focusView.layer.borderColor =  [UIColor colorWithWhite:0 alpha:0.5].CGColor;
        self.focusView.layer.masksToBounds = YES;
        [self.bgView addSubview:self.focusView];
        self.focusView.image = self.itemImages[0];
        
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


- (void)setItemNames:(NSArray *)itemNames
{
    _itemArr = itemNames;
    
 
    NSMutableArray *temps = [NSMutableArray array];
    
    for (NSInteger index = 0; index < itemNames.count; index++) {
        
            UIButton *sender =[[UIButton alloc] init];
            [sender setTitle:itemNames[index] forState:UIControlStateNormal];
            [sender setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
            [sender addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
            sender.tag = index;
            [self.bgView addSubview:sender];
            [temps addObject:sender];
   
    }
    
    self.itemArr = [temps copy];
    self.lastBtn = self.itemArr[0];
    self.lastBtn.enabled = NO;
    
   /*
    if (itemNames.count > 2) { //按钮少于3个,中间间隔没有意义
        
        for (int i = 0; i < self.itemArr.count - 1; i++) {
            
            UIView *line =[[UIView alloc] init];
            line.backgroundColor = [UIColor lightGrayColor];
            [self.blackView addSubview:line];
            
        }
       [self lineHidenIndex:0];
        
    }
    */
    
}


-(void)makeView:(UIView *)sender andCornerRadius:(CGFloat)raduis
{
    sender.layer.cornerRadius = raduis;
    sender.layer.masksToBounds = YES;
    
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
        
 
        self.focusView.frame = sender.frame;

        self.focusView.image = self.itemImages[sender.tag];
        
    } completion:^(BOOL finished) {
        
        
    }];
    
}
 
-(void)onClick:(UIButton *)sender
{
   
    [self moveWithButton:sender];
    
    if ([self.delegate respondsToSelector:@selector(XTopToolView:andButtonItem:)]) {
        
        [self.delegate XTopToolView:self andButtonItem:sender];
    }
    
}


- (void)layoutSubviews{

    [super layoutSubviews];
    
    CGSize contentSize = self.bounds.size;
    
    CGFloat blackH = contentSize.height;
    CGFloat blackX = 50;
    CGFloat blackY = 0;
    CGFloat blackW = contentSize.width - 2 * blackX;
    self.blackView.frame = CGRectMake(blackX, blackY, blackW, blackH);
    [self makeView:self.blackView andCornerRadius: blackH * 0.5];

    self.bgView.frame = self.blackView.frame;
    
    
    if (self.itemArr.count) {
        
        CGFloat lineMargin = blackW / self.itemArr.count;
        
        CGFloat btnw = lineMargin;
        CGFloat btnh = blackH;
        CGFloat btny = 0;
        
        for (NSInteger index = 0; index < self.itemArr.count; index++) {
            
            UIButton *sender = self.itemArr[index];
            
            CGFloat btnx = btnw * index;
            
            sender.frame = CGRectMake(btnx, btny,btnw, btnh);
        }
  
        
        CGFloat focusx = 0;
        CGFloat focusy = 0;
        CGFloat focusw = lineMargin;
        CGFloat focush = blackH;
        self.focusView.frame = CGRectMake(focusx, focusy, focusw, focush);
        self.focusView.layer.cornerRadius = blackH * 0.5;

    }
    
}

@end
