//
//  JHAnnotationView.m
//  newOffer
//
//  Created by xuewuguojie on 2018/9/21.
//  Copyright © 2018年 徐金辉. All rights reserved.
//

#import "JHAnnotationView.h"
@interface  JHAnnotationView ()
@property (strong, nonatomic) UIButton *titleBtn;
@end
//
@implementation JHAnnotationView

- (instancetype)initWithAnnotation:(id<MGLAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        UIButton *titleBtn =[UIButton new];
         [titleBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [titleBtn setTitleColor:[UIColor blueColor] forState:UIControlStateDisabled];
        titleBtn.titleLabel.font = XFONT(14);
        [titleBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 7, 0)];
        [titleBtn addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
        [titleBtn setBackgroundImage:[UIImage imageNamed:@"map_anchor_white"] forState:UIControlStateNormal];
        [titleBtn setBackgroundImage:[UIImage imageNamed:@"map_anchor_white"] forState:UIControlStateHighlighted];

        [titleBtn setTitleColor:XCOLOR_WHITE forState:UIControlStateSelected];
        [titleBtn setTitleColor:XCOLOR_LIGHTBLUE forState:UIControlStateNormal];
        [self addSubview:titleBtn];
        self.titleBtn = titleBtn;
    }
    return self;
}

- (void)onClick:(UIButton *)sender{
    
    if (self.actionBlock) {
        self.actionBlock(self.annotation);
    }
}

- (void)setAnnotationViewState:(BOOL)annotationViewState{
    
    _annotationViewState = annotationViewState;
    
    UIColor *title_color = annotationViewState ?  XCOLOR_WHITE : XCOLOR_LIGHTBLUE;
    NSString *name = annotationViewState ?  @"map_anchor_blue" : @"map_anchor_white";
    [self.titleBtn setBackgroundImage:[UIImage imageNamed:name] forState:UIControlStateNormal];
    [self.titleBtn setBackgroundImage:[UIImage imageNamed:name] forState:UIControlStateHighlighted];
    [self.titleBtn setTitleColor:title_color  forState:UIControlStateNormal];
}

- (void)setTitle:(NSString *)title{
    _title = title;
    [self.titleBtn setTitle:title forState:UIControlStateNormal];
}

- (void)layoutSubviews{

    [super layoutSubviews];
    self.titleBtn.frame = self.bounds;
}


@end
