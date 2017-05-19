//
//  DefaultTableView.m
//  OfferDemo
//
//  Created by xuewuguojie on 2016/12/23.
//  Copyright © 2016年 xuewuguojie. All rights reserved.
//

#import "DefaultTableView.h"
#import "EmptyDataView.h"

@interface DefaultTableView ()
@property(nonatomic,strong)EmptyDataView  *emptyView;

@end
@implementation DefaultTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self) {
        
        [self makeUI];

    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{

    self = [super initWithCoder:aDecoder];
    
    if (self) {
        
        [self makeUI];

    }
    
    return self;
}

- (void)makeUI{
    

    self.separatorColor = XCOLOR_line;
    
    self.emptyView  =[EmptyDataView emptyViewWithBlock:^{
        
        if (self.actionBlock) self.actionBlock();
        
    }];
    
    self.emptyView.hidden = YES;
    [self addSubview:self.emptyView];
    self.emptyView.center = self.center;
}

- (void)emptyViewWithHiden:(BOOL)hiden{

    self.emptyView.hidden = hiden;
}

- (void)emptyViewWithError:(NSString *)error{
    
    self.emptyView.hidden = NO;
    self.emptyView.errorStr =  error;

    
}




@end
