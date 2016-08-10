//
//  DoneButton.m
//  MyOffer
//
//  Created by Blankwonder on 6/29/15.
//  Copyright © 2015 UVIC. All rights reserved.
//

#import "DoneButton.h"

@implementation DoneButton

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
    self.layer.cornerRadius = 2;
    self.layer.masksToBounds = YES;
    self.adjustAllRectWhenHighlighted = YES;
}


@end
