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
        [titleBtn addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
        [titleBtn setBackgroundImage:[UIImage imageNamed:@"button_light_unable"] forState:UIControlStateNormal];
        [titleBtn setBackgroundImage:[UIImage imageNamed:@"button_blue_nomal"] forState:UIControlStateSelected];
        [titleBtn setBackgroundImage:[UIImage imageNamed:@"button_light_unable"] forState:UIControlStateHighlighted];

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
     self.titleBtn.selected = annotationViewState;
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
