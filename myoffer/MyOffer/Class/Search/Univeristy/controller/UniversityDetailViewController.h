 //
//  UniversityDetailViewController.h
//  MyOffer
//
//  Created by Blankwonder on 6/9/15.
//  Copyright (c) 2015 UVIC. All rights reserved.
//

#import "BaseViewController.h"
#import "KDBannerView.h"

typedef void(^UniversityBlock)(NSString *);
@interface UniversityDetailViewController : BaseViewController {
    IBOutlet UILabel *_descLabel, *_chineseNameLabel, *_englishNameLabel, *_rankingLabel, *_setupYearLabel, *_locationLabel;
    IBOutlet LogoView *_logoView;
    
    IBOutlet KDBannerView *_bannerView;
    
    IBOutlet UIScrollView *_scrollView;
    
    IBOutlet UIProgressView *_successProgressView;
    IBOutlet UILabel *_successLabel;
    IBOutlet UIProgressView *_mySuccessProgressView;
    IBOutlet UILabel *_mySuccessLabel;
    
    IBOutlet UIView *_progressContainer;
    
    __weak IBOutlet UILabel *_QSrankLabel;
    
    IBOutlet KDEasyTouchButton *_evaluationButton;
    
}

- (instancetype)initWithUniversityID:(NSString *)ID;

@property (readonly) NSString *universityID;
@property(nonatomic,copy)UniversityBlock actionBlock;
@property(nonatomic,assign)BOOL firstLike;

- (IBAction)viewAllCourses;

@end
