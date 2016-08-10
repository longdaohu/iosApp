//
//  Mybutton.h
//  cover
//
//  Created by sara on 16/5/12.
//  Copyright © 2016年 小米. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FilerButtonItem;
@protocol FilerButtonItemDelegate <NSObject>
-(void)button:(FilerButtonItem *)myButton Click:(UIButton *)sender;
@end

@interface FilerButtonItem : UIView
@property(nonatomic,strong)UIImageView *imageView;
@property(nonatomic,strong)UILabel *titleLab;
@property(nonatomic,strong)UIButton *bgButton;
@property(nonatomic,copy)NSString *title;
@property(nonatomic,strong)UIImage *image;
@property(nonatomic,assign)BOOL selected;
@property(nonatomic,assign)BOOL animating;
 @property(nonatomic,weak)id <FilerButtonItemDelegate> delegate;
@end
