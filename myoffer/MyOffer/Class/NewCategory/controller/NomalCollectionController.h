//
//  NomalCollectionController.h
//  myOffer
//
//  Created by xuewuguojie on 2017/3/3.
//  Copyright © 2017年 UVIC. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum {
    CollectionTypeFQ, //留学小白 ： 疑难解读
    CollectionTypeSubject  //留学搜索  ： 留学专业
}CollectionType;

@interface NomalCollectionController : BaseViewController

@property(nonatomic,strong)NSArray *items;

@property(nonatomic,assign)CollectionType type;

@end
