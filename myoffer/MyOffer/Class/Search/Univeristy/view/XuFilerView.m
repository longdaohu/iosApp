//
//  XuFilerView.m
//  cover
//
//  Created by xuewuguojie on 16/5/11.
//  Copyright © 2016年 小米. All rights reserved.
//

#define  BGHEIGHT 40
#define  LEFT_SELECTED  self.leftButton.bgButton.selected
#import "XuFilerView.h"

@interface XuFilerView ()<UITableViewDelegate,UITableViewDataSource,FilerButtonItemDelegate>
@property(nonatomic,strong)UIView *bgView;
@property(nonatomic,strong)UIView *centerLine;
@property(nonatomic,strong)FilerButtonItem *leftButton;
@property(nonatomic,strong)FilerButtonItem *rightButton;
@property(nonatomic,strong)UIButton *lastButton;
@property(nonatomic,strong)UITableView *leftTableView;
@property(nonatomic,strong)UITableView *rightTableView;
@property(nonatomic,strong)NSArray *leftArr;
@property(nonatomic,strong)NSArray *rightArr;
@property(nonatomic,strong)NSIndexPath *lastLeftIndexPath;
@property(nonatomic,strong)NSIndexPath *lastRightIndexPath;

@end

@implementation XuFilerView


- (void)viewDidLoad {
 
    [super viewDidLoad];
    
    self.view.clipsToBounds = YES;
    
    self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
 
    [self makeUI];
    
    [self showSuperViewFrame:NO];
}

-(void)makeUI
{
    self.bgView =[[UIView alloc] initWithFrame:CGRectMake(0, 0, XScreenWidth, BGHEIGHT)];
    self.bgView.backgroundColor = BACKGROUDCOLOR;
    [self.view addSubview:self.bgView];
    
    
    FilerButtonItem *leftButton =[[FilerButtonItem alloc] initWithFrame:CGRectMake(XScreenWidth * 0.5, 0, XScreenWidth * 0.5, BGHEIGHT)];
    leftButton.delegate = self;
    self.leftButton = leftButton;
    self.leftButton.tag = 10;
    [self.bgView addSubview:self.leftButton];
    
    self.rightButton =[[FilerButtonItem alloc] initWithFrame:CGRectMake(0, 0, XScreenWidth * 0.5, BGHEIGHT)];
    self.rightButton .delegate = self;
    self.rightButton.tag = 11;
    [self.bgView addSubview:self.rightButton];
    
    
    self.centerLine =[[UIView alloc] initWithFrame:CGRectMake(XScreenWidth * 0.5, 10, 1, 20)];
    self.centerLine.backgroundColor =[UIColor lightGrayColor];
    [self.bgView addSubview:self.centerLine];
    
    
    [self makeTableView];

}

-(void)makeTableView
{
    self.leftTableView =[[UITableView alloc] initWithFrame:CGRectMake(XScreenWidth * 0.5,BGHEIGHT, XScreenWidth * 0.5, 0) style:UITableViewStylePlain];
    self.leftTableView.delegate = self;
    self.leftTableView.dataSource = self;
    [self.view addSubview:self.leftTableView];
    
    self.rightTableView =[[UITableView alloc] initWithFrame:CGRectMake(0,BGHEIGHT, XScreenWidth * 0.5, 0) style:UITableViewStylePlain];
    self.rightTableView.delegate = self;
    self.rightTableView.dataSource = self;
    [self.view addSubview:self.rightTableView];
}


-(void)setGroups:(NSArray *)groups
{
    _groups = groups;
 
    NSArray *leftArr = self.groups[0];
    self.leftButton.title = GDLocalizedString(@"UniCourseDe-005");
    
    
    NSArray *rightArr = self.groups[1];
    self.rightButton.title = GDLocalizedString(@"UniCourseDe-006");
    
    self.leftTableView.scrollEnabled = leftArr.count * BGHEIGHT > APPSIZE.height - CGRectGetMaxY(self.filerRect) ? YES : NO;
    self.rightTableView.scrollEnabled =  rightArr.count * BGHEIGHT  > APPSIZE.height - CGRectGetMaxY(self.filerRect)  ? YES : NO;
 
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
         self.leftButton.selected = NO;
     }else{
          self.rightButton.selected = NO;
    }

}

-(void)backbroudViewClick
{
    
    if (LEFT_SELECTED) {
        
        self.leftButton.selected = NO;
        
        [self showFilerViewButtonItemClick:self.leftButton];
    }else{
        self.rightButton.selected = NO;
        
        [self showFilerViewButtonItemClick: self.rightButton];
    }
    
}


-(void)showFilerViewButtonItemClick:(FilerButtonItem *)sender
{
   
    BOOL show = sender.bgButton.selected;
    
    if (show) {
        
        [self showSuperViewFrame:YES];
        
    }
    
    CGRect newRect = 11 == sender.tag ? self.rightTableView.frame : self.leftTableView.frame;
    
    NSInteger  index =  11 == sender.tag ?  1 : 0;
    
    CGFloat height  = [self.groups[index] count] * BGHEIGHT   >  APPSIZE.height - CGRectGetMaxY(self.filerRect)? APPSIZE.height - CGRectGetMaxY(self.filerRect)  : [self.groups[index] count] * BGHEIGHT;
    
    newRect.size.height = show ? height : 0;
    
    CGFloat  tableHeight = 11 == sender.tag ?self.leftTableView.frame.size.height : self.rightTableView.frame.size.height;
    
    
    if (show && tableHeight > 0) {
        
        CGRect  otherNewRect =  11 == sender.tag ? self.leftTableView.frame : self.rightTableView.frame;
        
        otherNewRect.size.height = 0;
        
        
        [UIView animateWithDuration:0.2 animations:^{
            
            
            if (11 == sender.tag) {
                
                self.leftTableView.frame = otherNewRect;
                
            }else{
                
                self.rightTableView.frame = otherNewRect;
                
            }
        }];
        
    }
    
    
    [UIView  animateWithDuration:0.2 animations:^{
        
        if (11 == sender.tag) {
            
            self.rightTableView.frame = newRect;
            
        }else{
        
            self.leftTableView.frame = newRect;

        }
        
        
    } completion:^(BOOL finished) {
        
        if (!self.leftButton.bgButton.selected && !self.rightButton.bgButton.selected) {
            
            [self showSuperViewFrame:NO];
            
        }
    }];
    
}


//self.view.frame   设置
-(void)showSuperViewFrame:(BOOL)show
{
    
    CGRect newRect = self.view.frame;
    
    newRect.size.height = show ? APPSIZE.height : BGHEIGHT;
    
    //判断是否打开筛选页面，如果有show == YES 则立即广大 self.view.frame
    if (show) {
        
          self.view.frame = newRect;
     }
    
    [UIView animateWithDuration:0.2 animations:^{
        
        self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:show? 0.5 : 0];
        
    } completion:^(BOOL finished) {
        
          //判断两个按钮item是否还在动画过程中，如果还在动画ing则self.view不缩小
        if (!self.leftButton.animating && !self.rightButton.animating) {
            
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
   
    if (tableView == self.leftTableView) {
        
        return   [self.groups[0] count];

    }else{
    
        return [self.groups[1] count];

    }
    
 }

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
   UITableViewCell  *cell =[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    
    cell.textLabel.font =[UIFont systemFontOfSize:15];
    
    
    cell.textLabel.text  =  tableView == self.leftTableView ? self.groups[0][indexPath.row]:self.groups[1][indexPath.row];
    
    FilerButtonItem *sender =   tableView == self.leftTableView ? self.leftButton : self.rightButton;
    
    UIColor  *color=   [cell.textLabel.text isEqualToString:sender.title] ? XCOLOR_RED : [UIColor blackColor];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.textColor = color;
    
//    if ([cell.textLabel.text isEqualToString:sender.title]) {
    
         if (tableView == self.leftTableView) {
        
             self.lastLeftIndexPath = indexPath;
         
         }else{
             
              self.lastRightIndexPath = indexPath;
        }
//     }
    
    
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
     [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    NSIndexPath *lastIndexPath = LEFT_SELECTED ? self.lastLeftIndexPath : self.lastRightIndexPath;
    UITableViewCell *lastCell =[tableView cellForRowAtIndexPath:lastIndexPath];
    lastCell.textLabel.textColor = [UIColor blackColor];
    lastIndexPath = indexPath;
 
    
    if (LEFT_SELECTED) {
        
        self.lastLeftIndexPath = lastIndexPath;
        
    }else{
        
        self.lastRightIndexPath= lastIndexPath;

    }
    
    
     UITableViewCell *currentCell =[tableView cellForRowAtIndexPath:indexPath];
     currentCell.textLabel.textColor = XCOLOR_RED;
    
    
     FilerButtonItem *sender =   LEFT_SELECTED ? self.leftButton : self.rightButton;
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
