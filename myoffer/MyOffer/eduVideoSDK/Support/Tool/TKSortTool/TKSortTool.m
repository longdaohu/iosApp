//
//  TKSortTool.m
//  XPWGLQIANTAI
//
//  Created by  杭州信配iOS开发 on 2017/4/27.
//  Copyright © 2017年  杭州信配iOS开发. All rights reserved.
//

#import "TKSortTool.h"
#import "TKSortByNameCore.h"
#import "TKDocmentDocModel.h"
#import "TKMediaDocModel.h"

typedef NS_ENUM(NSInteger, SortType) {//排序类型
    NameSort,
    TypeSort,
    TimeSort,
};


@implementation TKSortTool
+(instancetype )shareInstance{
    
    static TKSortTool *singleton = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^
                  {
                      singleton = [[TKSortTool alloc] init];
                  });
    
    return singleton;
}

+ (void)sortByNameWithArray:(NSArray*)array
               fileListType:(FileListType)fileListType
                    sortWay:(SortFileType)sortWay
               sectionBlock:(TXSectionBlock)sectionBlock
        sortTheValueOfBlock:(TXSortTheValueOfBlock)sortTheValueOfBlock{
    
    [[TKSortTool shareInstance] sorWithArray:array sortType:NameSort fileListType:fileListType sortWay:sortWay sectionBlock:sectionBlock sortTheValueOfBlock:sortTheValueOfBlock];
}


+ (void)sortByTypeWithArray:(NSArray *)array
               fileListType:(FileListType)fileListType
                    sortWay:(SortFileType)sortWay
               sectionBlock:(TXSectionBlock)sectionBlock
        sortTheValueOfBlock:(TXSortTheValueOfBlock)sortTheValueOfBlock{
    
    
    [[TKSortTool shareInstance] sorWithArray:array sortType:TypeSort fileListType:fileListType sortWay:sortWay sectionBlock:sectionBlock sortTheValueOfBlock:sortTheValueOfBlock];
    
}

+ (void)sortByTimeWithArray:(NSArray *)array
               fileListType:(FileListType)fileListType
                    sortWay:(SortFileType)sortWay
               sectionBlock:(TXSectionBlock)sectionBlock
        sortTheValueOfBlock:(TXSortTheValueOfBlock)sortTheValueOfBlock{
    
    [[TKSortTool shareInstance] sorWithArray:array sortType:TimeSort fileListType:fileListType sortWay:sortWay sectionBlock:sectionBlock sortTheValueOfBlock:sortTheValueOfBlock];
}


- (void)sorWithArray:(NSArray*)array
            sortType:(SortType)sortType
        fileListType:(FileListType)fileListType
            sortWay:(SortFileType)sortWay
        sectionBlock:(TXSectionBlock)sectionBlock
 sortTheValueOfBlock:(TXSortTheValueOfBlock)sortTheValueOfBlock{
    
//    NSArray *arr = [NSArray arrayWithArray:array];
//    [arr removeObserver: arr.firstObject forKeyPath:0];
    
    
    if (array) {
        //姓名容器
        NSMutableArray        * names  = [NSMutableArray array];
        //数据容器
        NSMutableArray        * datas  = [NSMutableArray array];
        
        
        switch (fileListType) {
            case FileListTypeAudioAndVideo:
                //向容器中添加数据
                for (TKMediaDocModel * media  in array) {
                    
                    switch (sortType) {
                        case NameSort:
                            
                            [names addObject:[NSString stringWithFormat:@"%@",media.filename]];
                            break;
                        case TypeSort:
                            
                            [names addObject:[NSString stringWithFormat:@"%@",media.filetype]];
                            break;
                        case TimeSort:
                            
                            [names addObject:[NSString stringWithFormat:@"%@",media.fileid]];
                            break;
                        default:
                            break;
                    }
                    
                    [datas addObject:media];
                };
                break;
            case FileListTypeDocument:
                //向容器中添加数据
                for (TKDocmentDocModel * doc  in array) {
                    
                    switch (sortType) {
                        case NameSort:
                            
                            [names addObject:[NSString stringWithFormat:@"%@",doc.filename]];
                            break;
                        case TypeSort:
                            
                            [names addObject:[NSString stringWithFormat:@"%@",doc.filetype]];
                            break;
                        case TimeSort:
                            
                            [names addObject:[NSString stringWithFormat:@"%@",doc.fileid]];
                            break;
                        default:
                            break;
                    }
                    
                    [datas addObject:doc];
                };
                break;
            default:
                break;
        }
        
        //分类
        NSComparisonResult comResult;
        if (sortWay == Sort_Descending) {
            comResult =NSOrderedDescending;
            
        }else{
            comResult = NSOrderedAscending;
        }
        NSArray * sort =[TKSortByNameCore sortDataByFirstLetterWithArray:names isIncludeKeys:YES comparisonResult:comResult];
        
        //创建section容器
        NSMutableArray * keyArray=[NSMutableArray array];
        
        for (NSDictionary * dict in sort) {
            [keyArray addObject:dict[@"key"]];
        }
        
        if (sectionBlock) {
            sectionBlock(keyArray);
        }
        /**
         ** 重点:排序
         **/
        NSMutableArray * sortTheValueOfArray=[NSMutableArray array];
        
        for (int index=0; index<sort.count; index++) {
            //创建容器
            NSMutableArray * array=[NSMutableArray array];
            //取出value
            NSDictionary * dict= sort[index];
            NSArray      * values=dict[@"value"];
            
            for (NSString * name in values) {
                for (int i=0; i<datas.count; i++) {
                    
                    switch (fileListType) {
                        case FileListTypeAudioAndVideo:
                        {
                            TKMediaDocModel * data=datas[i];
                            
                            NSString *file;
                            switch (sortType) {
                                case NameSort:
                                    file = [NSString stringWithFormat:@"%@",data.filename];
                                    break;
                                case TypeSort:
                                    
                                    file = [NSString stringWithFormat:@"%@",data.filetype];
                                    break;
                                case TimeSort:
                                    
                                    file = [NSString stringWithFormat:@"%@",data.fileid];
                                    break;
                                default:
                                    break;
                            }
                            if ([name isEqualToString:file]) {
                                [array addObject:data];
                                //添加一条数据就必须减少一条数据。
                                [datas removeObject:data];
                            };
                        }
                            break;
                        case FileListTypeDocument:
                        {
                            TKDocmentDocModel * data=datas[i];
                            NSString *file;
                            switch (sortType) {
                                case NameSort:
                                    file = [NSString stringWithFormat:@"%@",data.filename];
                                    break;
                                case TypeSort:
                                    
                                    file = [NSString stringWithFormat:@"%@",data.filetype];
                                    break;
                                case TimeSort:
                                    
                                    file = [NSString stringWithFormat:@"%@",data.fileid];
                                    break;
                                default:
                                    break;
                            }
                            if ([name isEqualToString:file]) {
                                [array addObject:data];
                                //添加一条数据就必须减少一条数据。
                                [datas removeObject:data];
                            };
                        }
                            break;
                        default:
                            break;
                    }
                    
                }
            }
            [sortTheValueOfArray addObject:array];
        }
      
        
        NSMutableArray *sortArray = [NSMutableArray array];
        
        switch (fileListType) {
            case FileListTypeAudioAndVideo:
            {
                for (NSArray *array in sortTheValueOfArray) {
                    
                    for (TKMediaDocModel *media in array) {
                        
                        [sortArray addObject:media];
                    }
                    
                }
                
            }
                
                break;
            case FileListTypeDocument:
                
            {
                for (NSArray *array in sortTheValueOfArray) {
                    
                    for (TKDocmentDocModel *doc in array) {
                        
                        [sortArray addObject:doc];
                    }
                    
                }
                
            }
                break;
            default:
                break;
        }
        
        
        if (sortTheValueOfBlock) {
            sortTheValueOfBlock(sortArray);
        }
    }

}

@end
