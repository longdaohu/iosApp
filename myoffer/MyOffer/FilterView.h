//
//  FilterView.h
//  
//
//  Created by Blankwonder on 6/17/15.
//
//

#import <UIKit/UIKit.h>

@protocol FilterViewDelegate;
@interface FilterView : UIView

@property (copy, nonatomic) NSArray *items;

@property (nonatomic) NSInteger selectedIndex;
@property (nonatomic,strong) UIButton *cover;
@property (nonatomic) BOOL descending;

@property (weak) IBOutlet id <FilterViewDelegate> delegate;
@property (weak) IBOutlet UIView *subtypeMenuPresentingView;

@end

@protocol FilterViewDelegate <NSObject>
@optional
- (void)filterView:(FilterView *)filterView didSelectItemAtIndex:(NSInteger)index descending:(BOOL)descending;
- (NSArray *)filterView:(FilterView *)filterView subtypesForItemAtIndex:(NSInteger)index;
- (void)filterView:(FilterView *)filterView didSelectItemAtIndex:(NSInteger)index subtypeIndex:(NSInteger)subtypeIndex;

@end 