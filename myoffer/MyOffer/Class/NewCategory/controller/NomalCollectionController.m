//
//  NomalCollectionController.m
//  myOffer
//
//  Created by xuewuguojie on 2017/3/3.
//  Copyright © 2017年 UVIC. All rights reserved.
//

#import "NomalCollectionController.h"
#import "CatigorySubjectCell.h"
#import "CatigorySubject.h"
#import "XNewSearchViewController.h"


@interface NomalCollectionController ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property(nonatomic,strong)UICollectionView *collectionView;

@end

@implementation NomalCollectionController

static NSString * const reuseIdentifier = @"subjectCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // self.clearsSelectionOnViewWillAppear = NO;
    CGFloat item_width = (XSCREEN_WIDTH - 4) / 3;
    
    UICollectionViewFlowLayout *flowlayout = [[UICollectionViewFlowLayout alloc] init];
    flowlayout.itemSize = CGSizeMake(item_width, item_width);
    flowlayout.minimumLineSpacing = 2;
    flowlayout.minimumInteritemSpacing = 2;
//    flowlayout.sectionInset = UIEdgeInsetsMake(0, ITEM_MARGIN, 0, ITEM_MARGIN);
    [flowlayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:flowlayout];
//    self.collectionView.contentInset = UIEdgeInsetsMake(ITEM_MARGIN,0, 0, 0);
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    [self.view addSubview:self.collectionView];
  
    // Register cell classes
    [self.collectionView registerNib:[UINib nibWithNibName:@"CatigorySubjectCell" bundle:nil] forCellWithReuseIdentifier:reuseIdentifier];
    self.collectionView.backgroundColor = XCOLOR_BG;
    
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.items.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CatigorySubjectCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    cell.subject = self.items[indexPath.row];
    
    
    return cell;
}

#pragma mark <UICollectionViewDelegate>
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (self.type == CollectionTypeSubject) {
        
        [self caseSubjectWithIndexPath:indexPath];
        
        return;
    }
    
    WebViewController *help = [[WebViewController alloc] init];
    
    help.path    = [NSString stringWithFormat:@"%@faq#index=%ld",DOMAINURL,(long)indexPath.row];
    
    [self.navigationController pushViewController:help animated:YES];
    
}

//留学专业
-(void)caseSubjectWithIndexPath:(NSIndexPath *)indexPath{
    
    CatigorySubject *subject = self.items[indexPath.row];
    
    XNewSearchViewController *vc = [[XNewSearchViewController alloc] initWithFilter:@"area" value:subject.TitleName orderBy:RANK_QS];
    
    vc.CoreArea = subject.TitleName;
    
    [self.navigationController pushViewController:vc animated:YES];
    
}





/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

@end


/*
 #pragma mark ——— UICollectionViewDataSource UICollectionViewDelegate
 
 - (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
 
 return 1;
 }
 
 - (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
 
 return self.helpItems.count;
 
 }
 
 - (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
 
 CatigorySubjectCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:subjectIdentify forIndexPath:indexPath];
 
 cell.subject = self.helpItems[indexPath.row];
 
 return cell;
 }
 
 
 
 
 - (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
 
 return CGSizeMake(0, 0);
 }
 
 - (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
 
 [collectionView deselectItemAtIndexPath:indexPath animated:YES];
 
 WebViewController *help = [[WebViewController alloc] init];
 
 help.path    = [NSString stringWithFormat:@"%@faq#index=%ld",DOMAINURL,(long)indexPath.row];
 
 [self.navigationController pushViewController:help animated:YES];
 
 NSLog(@"did select");
 }
 
 
 
 
 - (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath{
 
 UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
 cell.contentView.backgroundColor = [UIColor redColor];
 NSLog(@"11111111");
 return YES;
 }
 
 - (void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath{
 
 NSLog(@"222222");
 
 }
 
 - (void)collectionView:(UICollectionView *)collectionView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath{
 
 
 UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
 [UIView animateWithDuration:0.5 animations:^{
 
 cell.contentView.backgroundColor = [UIColor whiteColor];
 }];
 
 
 NSLog(@"333333");
 
 }
 - (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath{
 
 UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
 
 cell.contentView.backgroundColor = [UIColor greenColor];
 
 return YES;
 }

 */

