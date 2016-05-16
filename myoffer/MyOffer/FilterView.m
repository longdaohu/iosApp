//
//  FilterView.m
//  
//
//  Created by Blankwonder on 6/17/15.
//
//

#import "FilterView.h"

@implementation FilterView {
    NSArray *_labels, *_buttons, *_icons, *_lines;
    UIView *_subtypeMenuView;
}

-(UIButton *)cover
{
    if (!_cover) {
        
        _cover =[[UIButton alloc] init];
        
    }
    return _cover;
}

- (void)setItems:(NSArray *)items {
    _items = [items copy];
    

    
    _selectedIndex = -1;
    
    for (UIView *subview in self.subviews) {
        [subview removeFromSuperview];
    }
    
    NSMutableArray *labels = [NSMutableArray array];
    NSMutableArray *buttons = [NSMutableArray array];
    NSMutableArray *icons = [NSMutableArray array];
    NSMutableArray *lines = [NSMutableArray array];

    for (NSString *item in items) {
        UILabel *label = [[UILabel alloc] init];
        label.text = item;
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:14];
        [self addSubview:label];
        [labels addObject:label];
        
        UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 12, 12)];
        icon.contentMode = UIViewContentModeCenter;
        [self addSubview:icon];
        [icons addObject:icon];
        
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = [UIColor KD_colorWithCode:0xffd6d6d6];
        [self addSubview:line];
        [lines addObject:line];
        
        KDEasyTouchButton *button = [[KDEasyTouchButton alloc] init];
        button.adjustAllRectWhenHighlighted = YES;
        [button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        [buttons addObject:button];
    }
    
    [lines.lastObject setHidden:YES];
    
    _labels = labels;
    _buttons = buttons;
    _icons = icons;
    _lines = lines;
    
    [self configureIcon];
    [self setNeedsLayout];
}

- (void)layoutSubviews {
   
    
    [super layoutSubviews];
    
    
    CGFloat itemWidth = ceilf(self.frame.size.width / _items.count);
    
    CGFloat height = self.frame.size.height;
    
    
    [_labels enumerateObjectsUsingBlock:^(UILabel *label, NSUInteger idx, BOOL *stop) {
        label.frame = CGRectMake(itemWidth * idx, 0, itemWidth, height);
        
        UIImageView *icon = _icons[idx];
        
        CGSize size = [label sizeThatFits:CGSizeMake(itemWidth, height)];
        icon.center = CGPointMake(itemWidth * idx + itemWidth / 2.0f + size.width / 2.0f + 8.0f, height / 2.0f);
    }];
    
    [_buttons enumerateObjectsUsingBlock:^(UIButton *button, NSUInteger idx, BOOL *stop) {
        button.frame = CGRectMake(itemWidth * idx, 0, itemWidth, height);
    }];
    
    [_lines enumerateObjectsUsingBlock:^(UIView *line, NSUInteger idx, BOOL *stop) {
        line.frame = CGRectMake(itemWidth * (idx + 1), 0, 0.5, height);
    }];
    
    
    
}

- (void)configureIcon {
    
    [_icons enumerateObjectsUsingBlock:^(UIImageView *obj, NSUInteger idx, BOOL *stop) {
        NSArray *subtypes;
        
        if ([self.delegate respondsToSelector:@selector(filterView:subtypesForItemAtIndex:)]) {
            
            subtypes = [self.delegate filterView:self subtypesForItemAtIndex:idx];
            
        }
        
        if (subtypes.count > 0) {
            
            obj.image = [UIImage imageNamed:@"sort-arrows-subtype"];
            
        } else {
            
            if (idx == _selectedIndex) {
            
                obj.image = _descending ? [UIImage imageNamed:@"sort-arrows-down"] : [UIImage imageNamed:@"sort-arrows-up"];
            
            } else {
                
                obj.image = [UIImage imageNamed:@"sort-arrows-none"];
            }
        }
    }];
}

- (void)setSelectedIndex:(NSInteger)selectedIndex {
    _selectedIndex = selectedIndex;
    [self configureIcon];
}

- (void)setDescending:(BOOL)descending {
    _descending = descending;
    [self configureIcon];
}

- (void)buttonPressed:(UIButton *)button {
    NSInteger index = [_buttons indexOfObject:button];
    
    NSArray *subtypes;
    if ([self.delegate respondsToSelector:@selector(filterView:subtypesForItemAtIndex:)]) {
        subtypes = [self.delegate filterView:self subtypesForItemAtIndex:index];
    }
    
    if (subtypes) {
        if (_subtypeMenuView) {
            [self dismissSubtypeMenu];
        }
        if (_selectedIndex != index) {
            [self showSubtypeMenuForItemAtIndex:index subtypes:subtypes];
            self.selectedIndex = index;
        } else {
            self.selectedIndex = -1;
        }
    } else {
        if (index == _selectedIndex) {
            self.descending = !self.descending;
        } else {
            self.descending = NO;
            self.selectedIndex = index;
        }
        
        if ([self.delegate respondsToSelector:@selector(filterView:didSelectItemAtIndex:descending:)]) {
            [self.delegate filterView:self didSelectItemAtIndex:_selectedIndex descending:_descending];
        }
    }
}

- (void)showSubtypeMenuForItemAtIndex:(NSInteger)index subtypes:(NSArray *)subtypes {
 
    
    self.subtypeMenuPresentingView.layer.borderColor = [UIColor redColor].CGColor;
    self.subtypeMenuPresentingView.layer.borderWidth = 1;
    
    
    
    NSAssert(_subtypeMenuView == nil, @"Already has a menu view");
    
    CGRect buttonFrame = [_buttons[index] frame];
    
    const CGFloat buttonHeight = self.frame.size.height;
    
    CGRect frame;
    frame.size.width = buttonFrame.size.width + 0.5;
    frame.size.height = buttonHeight * subtypes.count;
    frame.origin.x = buttonFrame.origin.x;
    frame.origin.y = buttonFrame.origin.y + buttonFrame.size.height - 0.5;
    
    UIView *targetView = self.subtypeMenuPresentingView ?: self;
    frame = [targetView convertRect:frame fromView:self];
    
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = self.backgroundColor;
    view.layer.borderColor =XCOLOR_RED.CGColor;//[UIColor KD_colorWithCode:0xffd6d6d6].CGColor;
    view.layer.borderWidth = 0.5;

    [targetView addSubview:view];
    
    [subtypes enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        KDEasyTouchButton *button = [[KDEasyTouchButton alloc] initWithFrame:CGRectMake(0, buttonHeight * idx, frame.size.width, buttonHeight)];
        button.tag = idx;
        
        [button setTitle:obj forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont systemFontOfSize:12]];
//        [button setTitleColor:[UIColor KD_colorWithCode:0xff6C6C6C] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        button.adjustAllRectWhenHighlighted = YES;
        
        [view addSubview:button];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(10, buttonHeight * idx, frame.size.width - 20, 0.5)];
        line.backgroundColor = [UIColor KD_colorWithCode:0xffd2d2d2];
        [view addSubview:line];
        
        [button addTarget:self action:@selector(subtypeButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    }];
    view.alpha = 0;
    
     _subtypeMenuView = view;
    
    [UIView animateWithDuration:0.3 animations:^{
        
        view.alpha = 1.0;
        
    }];
}

- (void)subtypeButtonPressed:(UIButton *)button {
    if ([self.delegate respondsToSelector:@selector(filterView:didSelectItemAtIndex:subtypeIndex:)]) {
        [self.delegate filterView:self didSelectItemAtIndex:self.selectedIndex subtypeIndex:button.tag];
    }
    [self dismissSubtypeMenu];
    self.selectedIndex = -1;
}

- (void)dismissSubtypeMenu {
    
    UIView *menu = _subtypeMenuView;
    _subtypeMenuView = nil;
    [UIView animateWithDuration:0.3 animations:^{
        menu.alpha = 0;
    } completion:^(BOOL finished) {
        
        [menu removeFromSuperview];
        
    }];
}

@end
