//
//  XuFilerView.m
//  cover
//
//  Created by xuewuguojie on 16/5/11.
//  Copyright © 2016年 小米. All rights reserved.
//

#define  BGHEIGHT 40
#define  LEFT_SELECTED  self.sujectButton.bgButton.selected
#import "XuFilerView.h"

@interface XuFilerView ()<UITableViewDelegate,UITableViewDataSource,FilerButtonItemDelegate>
@property(nonatomic,strong)UIView *bgView;
@property(nonatomic,strong)UIView *centerLine;
@property(nonatomic,strong)FilerButtonItem *sujectButton;
@property(nonatomic,strong)FilerButtonItem *xueweiButton;
@property(nonatomic,strong)UIButton *lastButton;
@property(nonatomic,strong)UITableView *subjectTableView;
@property(nonatomic,strong)UITableView *xueweiTableView;
@property(nonatomic,strong)NSArray *subjectArr;
@property(nonatomic,strong)NSArray *xueweiArr;
@property(nonatomic,strong)NSIndexPath *lastSubjecIndexPath;
@property(nonatomic,strong)NSIndexPath *lastXueWeiIndexPath;

@end

@implementation XuFilerView

- (void)viewDidLoad {
 
    [super viewDidLoad];
 
    [self makeUI];
    
    [self showSuperViewFrame:NO];
}

-(void)makeUI
{
    self.view.clipsToBounds = YES;
    self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
    
    
    CGFloat bgW = XScreenWidth;
    CGFloat bgH = BGHEIGHT;
    self.bgView =[[UIView alloc] initWithFrame:CGRectMake(0, 0, bgW, bgH)];
    self.bgView.backgroundColor = XCOLOR_BG;
    [self.view addSubview:self.bgView];
    
    
    CGFloat subjectcW = bgW * 0.5;
    CGFloat subjectcX = subjectcW;
    FilerButtonItem *sujectButton =[[FilerButtonItem alloc] initWithFrame:CGRectMake(subjectcX, 0, subjectcW, bgH)];
    sujectButton.delegate = self;
    self.sujectButton = sujectButton;
    self.sujectButton.tag = 10;
    [self.bgView addSubview:self.sujectButton];
    
    self.xueweiButton =[[FilerButtonItem alloc] initWithFrame:CGRectMake(0, 0,subjectcW, bgH)];
    self.xueweiButton .delegate = self;
    self.xueweiButton.tag = 11;
    [self.bgView addSubview:self.xueweiButton];
    
    self.centerLine =[[UIView alloc] initWithFrame:CGRectMake(bgW * 0.5, 10, 1, 20)];
    self.centerLine.backgroundColor = [UIColor colorWithRed:230.0/255 green:230.0/255 blue:230.0/255 alpha:1];
    [self.bgView addSubview:self.centerLine];
    
    [self makeTableView];

}

-(void)makeTableView
{
    
    CGFloat subjectW = XScreenWidth * 0.5;
    self.subjectTableView =[[UITableView alloc] initWithFrame:CGRectMake(subjectW,BGHEIGHT, subjectW, 0) style:UITableViewStylePlain];
    self.subjectTableView.delegate = self;
    self.subjectTableView.dataSource = self;
    [self.view addSubview:self.subjectTableView];
    
    self.xueweiTableView =[[UITableView alloc] initWithFrame:CGRectMake(0,BGHEIGHT, subjectW, 0) style:UITableViewStylePlain];
    self.xueweiTableView.delegate = self;
    self.xueweiTableView.dataSource = self;
    [self.view addSubview:self.xueweiTableView];
    
}


-(void)setGroups:(NSArray *)groups
{
    _groups = groups;
 
    NSArray *subjectArr = self.groups[0];
    self.sujectButton.title = GDLocalizedString(@"UniCourseDe-005");
    
    
    NSArray *xueweiArr = self.groups[1];
    self.xueweiButton.title = GDLocalizedString(@"UniCourseDe-006");
    
    self.subjectTableView.scrollEnabled = subjectArr.count * BGHEIGHT > XScreenHeight - CGRectGetMaxY(self.filerRect) ? YES : NO;
    
    self.xueweiTableView.scrollEnabled =  xueweiArr.count * BGHEIGHT  > XScreenHeight - CGRectGetMaxY(self.filerRect)  ? YES : NO;
 
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
     [self backbroudViewClick];
}


#pragma mark —————— FilerButtonItemDelegate
-(void)button:(FilerButtonItem *)myButton Click:(UIButton *)sender
{
    
    [self showFilerViewButtonItemClick:myButton];
    
     if (11 == myButton.tag ) {
         
         self.sujectButton.selected = NO;
         
     }else{
         
          self.xueweiButton.selected = NO;
    }

}

-(void)backbroudViewClick
{
    
    if (LEFT_SELECTED) {
        
        self.sujectButton.selected = NO;
        
        [self showFilerViewButtonItemClick:self.sujectButton];
    }else{
        self.xueweiButton.selected = NO;
        
        [self showFilerViewButtonItemClick: self.xueweiButton];
    }
    
}


-(void)showFilerViewButtonItemClick:(FilerButtonItem *)sender
{
   
    BOOL show = sender.bgButton.selected;
    
    if (show) {
        
        [self showSuperViewFrame:YES];
        
    }
    
    CGRect newRect = 11 == sender.tag ? self.xueweiTableView.frame : self.subjectTableView.frame;
    
    NSInteger  index =  11 == sender.tag ?  1 : 0;
    
    CGFloat height  = [self.groups[index] count] * BGHEIGHT   >  XScreenHeight - CGRectGetMaxY(self.filerRect)? XScreenHeight - CGRectGetMaxY(self.filerRect)  : [self.groups[index] count] * BGHEIGHT;
    
    newRect.size.height = show ? height : 0;
    
    CGFloat  tableHeight = 11 == sender.tag ?self.subjectTableView.frame.size.height : self.xueweiTableView.frame.size.height;
    
    
    if (show && tableHeight > 0) {
        
        CGRect  otherNewRect =  11 == sender.tag ? self.subjectTableView.frame : self.xueweiTableView.frame;
        
        otherNewRect.size.height = 0;
        
        
        [UIView animateWithDuration:0.2 animations:^{
            
            
            if (11 == sender.tag) {
                
                self.subjectTableView.frame = otherNewRect;
                
            }else{
                
                self.xueweiTableView.frame = otherNewRect;
                
            }
        }];
        
    }
    
    
    [UIView  animateWithDuration:0.2 animations:^{
        
        if (11 == sender.tag) {
            
            self.xueweiTableView.frame = newRect;
            
        }else{
        
            self.subjectTableView.frame = newRect;

        }
        
        
    } completion:^(BOOL finished) {
        
        if (!self.sujectButton.bgButton.selected && !self.xueweiButton.bgButton.selected) {
            
            [self showSuperViewFrame:NO];
            
        }
    }];
    
}


//self.view.frame   设置
-(void)showSuperViewFrame:(BOOL)show
{
    
    CGRect newRect = self.view.frame;
    
    newRect.size.height = show ? XScreenHeight : BGHEIGHT;
    
    //判断是否打开筛选页面，如果有show == YES 则立即广大 self.view.frame
    if (show) {
        
          self.view.frame = newRect;
     }
    
    [UIView animateWithDuration:0.2 animations:^{
        
        self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:show? 0.5 : 0];
        
    } completion:^(BOOL finished) {
        
          //判断两个按钮item是否还在动画过程中，如果还在动画ing则self.view不缩小
        if (!self.sujectButton.animating && !self.xueweiButton.animating) {
            
            self.view.frame = newRect;
        }
        
    }];
    
}
 

#pragma mark ———— tableViewDelegate tableViewData
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  BGHEIGHT;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   
    if (tableView == self.subjectTableView) {
        
        return   [self.groups[0] count];

    }else{
    
        return [self.groups[1] count];

    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
   UITableViewCell  *cell =[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    
    cell.textLabel.font =[UIFont systemFontOfSize:15];
    
    cell.textLabel.text  =  tableView == self.subjectTableView ? self.groups[0][indexPath.row]:self.groups[1][indexPath.row];
    
    FilerButtonItem *sender =   tableView == self.subjectTableView ? self.sujectButton : self.xueweiButton;
    
    UIColor  *color=   [cell.textLabel.text isEqualToString:sender.title] ? XCOLOR_RED : [UIColor blackColor];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.textColor = color;
    
    if (tableView == self.subjectTableView) {
        
        self.lastSubjecIndexPath = indexPath;
         
    }else{
             
        self.lastXueWeiIndexPath = indexPath;
    }
    
    
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
     [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    NSIndexPath *lastIndexPath = LEFT_SELECTED ? self.lastSubjecIndexPath : self.lastXueWeiIndexPath;
    UITableViewCell *lastCell =[tableView cellForRowAtIndexPath:lastIndexPath];
    lastCell.textLabel.textColor = [UIColor blackColor];
    lastIndexPath = indexPath;
 
    
    if (LEFT_SELECTED) {
        
        self.lastSubjecIndexPath = lastIndexPath;
        
    }else{
        
        self.lastXueWeiIndexPath= lastIndexPath;

    }
    
    
     UITableViewCell *currentCell =[tableView cellForRowAtIndexPath:indexPath];
     currentCell.textLabel.textColor = XCOLOR_RED;
    
    
     FilerButtonItem *sender =   LEFT_SELECTED ? self.sujectButton : self.xueweiButton;
     sender.title =  LEFT_SELECTED ? self.groups[0][indexPath.row]:self.groups[1][indexPath.row];
    
    
     [self backbroudViewClick];
    
     if ([self.delegate respondsToSelector:@selector(filerViewItemClick:)]) {
         
           [self.delegate filerViewItemClick:sender];
     }
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];


}



@end
