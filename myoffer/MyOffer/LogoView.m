//
//  LogoView.m
//  
//
//  Created by Blankwonder on 6/12/15.
//
//

#import "LogoView.h"

@implementation LogoView {
    UIImageView *_borderImageView;
}


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)initialize {
    _borderImageView = [[UIImageView alloc] initWithFrame:self.bounds];
    _borderImageView.image = [[UIImage imageNamed:@"logo_border"] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 20, 20, 20)];;
    [self addSubview:_borderImageView];
    
    _logoImageView = [[UIImageView alloc] init];
    _logoImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:_logoImageView];
}

- (void)layoutSubviews {
    _borderImageView.frame = self.bounds;
    _logoImageView.frame = CGRectMake(0, 0, self.bounds.size.width * 160.0f / 200.0f, self.bounds.size.height * 150.0f / 190.0f);
    [_logoImageView KD_setCenterAtSuperViewCenter];
}

@end
