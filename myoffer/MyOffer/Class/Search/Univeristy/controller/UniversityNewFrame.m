//
//  UniversityNewFrame.m
//  myOffer
//
//  Created by xuewuguojie on 16/8/24.
//  Copyright © 2016年 UVIC. All rights reserved.
//


#import "UniversityNewFrame.h"

@interface UniversityNewFrame ()
@end

@implementation UniversityNewFrame
+ (instancetype)frameWithUniversity:(UniversitydetailNew *)university{

    UniversityNewFrame *UniFrame = [[UniversityNewFrame alloc] init];
    UniFrame.item = university;
    
    return UniFrame;
}



-(void)setItem:(UniversitydetailNew *)item{
    
    _item = item;
    
    
    CGFloat  centerWidth = XSCREEN_WIDTH - 2 * XMARGIN;
    
    // 1、logo图片
    CGFloat logo_X = 15;
    CGFloat logo_Y = 20;
    CGFloat logo_W = XPERCENT * 80;
    CGFloat logo_H = logo_W;
    self.logo_Frame = CGRectMake(logo_X, logo_Y, logo_W, logo_H);
    
    //2、学校名称
    CGFloat name_X = CGRectGetMaxX(self.logo_Frame) + XMARGIN;
    CGFloat name_Y = logo_Y;
    CGFloat name_W = centerWidth - name_X - logo_X;
    CGFloat name_H = XFONT_SIZE(18);
    self.name_Frame = CGRectMake(name_X, name_Y, name_W, name_H);
    
    CGFloat  official_Font_Size = XFONT_SIZE(14);
    //3、英文名称
    CGFloat official_X = name_X;
    CGFloat official_Y = CGRectGetMaxY(self.name_Frame);
    CGFloat official_W = name_W;
    CGFloat officialHeigh   = [self.item.official_name KD_sizeWithAttributeFont:XFONT(official_Font_Size)  maxWidth:official_W].height;
    CGFloat official_H = officialHeigh;
    self.official_nameFrame = CGRectMake(official_X, official_Y, official_W, official_H);
    
    //4、网站名称
    CGFloat web_X = name_X;
    CGFloat web_W = name_W;
    CGFloat web_H =  official_Font_Size;
    CGFloat web_Y = CGRectGetMaxY(self.logo_Frame) - web_H;
    self.website_Frame = CGRectMake(web_X, web_Y, web_W, web_H);
    
    //5、地址名称
    CGFloat address_X = name_X;
    CGFloat address_W = name_W;
    CGFloat address_H =  official_Font_Size;
    CGFloat address_Y = CGRectGetMaxY(self.official_nameFrame) + 0.5 * (web_Y - CGRectGetMaxY(self.official_nameFrame) - address_H);
    self.address_detailFrame = CGRectMake(address_X,address_Y,address_W,address_H);
    
    //----------------------dataView------这里开始-----------------------------------------------
    //6、雅思、学费、就业、本地、国际   容器View;
    CGFloat data_X = logo_X;
    CGFloat data_Y = CGRectGetMaxY(self.logo_Frame) + 2 * XMARGIN;
    CGFloat data_W =  centerWidth - 2 * data_X;
    CGFloat data_item_W =  data_W * 0.25;

    //6-1 子项图片
    CGFloat data_item_icon_X = 0;
    CGFloat data_item_icon_Y = XMARGIN;
    CGFloat data_item_icon_W = data_item_W;
    CGFloat data_item_icon_H = 24;
    self.data_item_iconFrame = CGRectMake(data_item_icon_X, data_item_icon_Y, data_item_icon_W, data_item_icon_H);

    //XFONT_SIZE(14) //6-2 子项标题
    CGFloat data_item_title_X = 0;
    CGFloat data_item_title_Y = data_item_icon_Y + data_item_icon_H + 3;
    CGFloat data_item_title_W = data_item_icon_W;
    CGFloat data_item_title_H = XFONT_SIZE(14);
    self.data_item_titleFrame = CGRectMake(data_item_title_X, data_item_title_Y, data_item_title_W, data_item_title_H);
    //6-3 子项副标题
    CGFloat data_item_sub_X =  data_item_title_X;
    CGFloat data_item_sub_W =  data_item_title_W;
    CGFloat data_item_sub_H =  XFONT_SIZE(12);
    CGFloat data_item_sub_Y =  data_item_title_Y + data_item_title_H;
    self.data_item_subFrame = CGRectMake(data_item_sub_X, data_item_sub_Y, data_item_sub_W, data_item_sub_H);
    
    //6-4 子项数字标题
    CGFloat data_item_count_X = 0;
    CGFloat data_item_count_W = data_item_sub_W;
    CGFloat data_item_count_H = XFONT_SIZE(14);
    CGFloat data_item_count_Y = data_item_sub_H + data_item_sub_Y + 3;
    self.data_item_countFrame = CGRectMake(data_item_count_X, data_item_count_Y, data_item_count_W, data_item_count_H);
    
    //雅思、学费、就业、本地、国际 子项
    NSMutableArray *items_temp = [NSMutableArray array];
    CGFloat data_item_X = 0;
    CGFloat data_item_Y = 0;
    CGFloat data_item_H = data_item_count_Y + data_item_count_H  + XMARGIN;
    for (NSInteger index = 0; index < 4; index++) {
        
        data_item_X  = data_item_W * index;
        
        [items_temp addObject: [NSValue valueWithCGRect:CGRectMake(data_item_X, data_item_Y, data_item_W, data_item_H)]];
        
    }
    
    self.data_item_Frames = [items_temp copy];
    
    CGFloat data_H =  data_item_H;
    self.dataView_Frame = CGRectMake(data_X, data_Y, data_W, data_H);
    
    //-----------------------dataView-------------这里结束---------------------------------------------
    
    
    //7、简介
    CGFloat intro_X = logo_X;
    CGFloat intro_Y = CGRectGetMaxY(self.dataView_Frame) +   2 * XMARGIN;
    CGFloat intro_W = centerWidth - 2 * intro_X;
    CGFloat introductionHeight = [self.item.introduction KD_sizeWithAttributeFont:XFONT(official_Font_Size) maxWidth:intro_W].height;
    CGFloat intro_H = introductionHeight;
    self.introduction_Frame= CGRectMake(intro_X, intro_Y, intro_W, intro_H);
    
    //8、世界 本国排名、 标签容器View
    CGFloat up_X = 0;
    CGFloat up_Y = 0;
    CGFloat up_W = XSCREEN_WIDTH;
    CGFloat up_H =  XPERCENT * 200;
    self.upViewFrame= CGRectMake(up_X, up_Y, up_W, up_H);
    
    //9、标签2
    CGFloat tag2X = 0;
    CGFloat tag2W = XSCREEN_WIDTH;
    CGFloat tag2H = XFONT_SIZE(16);
    CGFloat tag2Y = up_H -  60 - tag2H;
    self.tagsTwoFrame= CGRectMake(tag2X, tag2Y, tag2W, tag2H);
    
    //10、标签1
    CGFloat tag1H = tag2H;
    CGFloat tag1X = tag2X;
    CGFloat tag1Y = tag2Y - tag1H  -  5;
    CGFloat tag1W = XSCREEN_WIDTH;
    self.tagsOneFrame= CGRectMake(tag1X, tag1Y, tag1W, tag1H);
    
    //10、世界排名
    CGFloat QS_W = [@"全球QS排名" KD_sizeWithAttributeFont:XFONT(XFONT_SIZE(16))].width + 5;
    CGFloat QS_H = 46;
    CGFloat QS_X = 0.5 * (XSCREEN_WIDTH - 2 * QS_W - 2 * XMARGIN);
    CGFloat QS_Y =  tag1Y - QS_H - XMARGIN;
    
    //11、本国排名
    CGFloat TIMES_X = QS_X + QS_W + 2 * XMARGIN;
    CGFloat TIMES_Y = QS_Y;
    CGFloat TIMES_H = QS_H;
    CGFloat TIMES_W = QS_W;
    
    self.QS_Frame= CGRectMake(QS_X, QS_Y, QS_W, QS_H);
    
    self.TIMES_Frame= CGRectMake(TIMES_X, TIMES_Y, TIMES_W, TIMES_H);
    
    
    [self updateCenterViewFrame:item];
    
    //12、分享、收藏View
    CGFloat rightW =  80  +  XMARGIN;
    CGFloat rightH =  40;
    CGFloat rightX =  XSCREEN_WIDTH - rightW - 2 * XMARGIN;
    CGFloat rightY = self.centerView_Frame.origin.y - 0.5 * rightH;
    self.rightView_Frame= CGRectMake(rightX, rightY, rightW, rightH);
    
    
    [self oneSectonWithUni:item];
    
}


- (void)updateCenterViewFrame:(UniversitydetailNew *)item{

   
    CGFloat  centerWidth = XSCREEN_WIDTH - 2 * XMARGIN;

    CGFloat more_H = 20;
    
    CGFloat realHeight = 0;
    
    if (self.showMore) {
        
        realHeight = (CGRectGetMaxY(self.introduction_Frame) + more_H + 30);
        
    }else{
        
        realHeight = (CGRectGetMinY(self.introduction_Frame) + more_H + 100);
    }
    
    
    if(CGRectGetHeight(self.introduction_Frame) <= 100){
        
        realHeight = CGRectGetMaxY(self.introduction_Frame) + 2 * XMARGIN;
    }
    
    self.centerHeigh = realHeight;
    
    
    //1、更多名称
    CGFloat more_Y = self.centerHeigh -  more_H - 2 * XMARGIN;
    CGFloat more_W = XPERCENT * 100;
    CGFloat more_X =  0.5 * (centerWidth - more_W);
    CGRect moreNewFrame = self.more_Frame;
    moreNewFrame.size.height = (CGRectGetHeight(self.introduction_Frame) <= 100) ? 0 : more_H;
    moreNewFrame.size.width  = more_W;
    moreNewFrame.origin.x    = more_X;
    moreNewFrame.origin.y    = more_Y;
    self.more_Frame = moreNewFrame;
 
    //2、渐变色
    CGFloat gradient_H = self.centerHeigh - more_Y + 20;
    CGFloat gradient_Y = self.centerHeigh - gradient_H;
    CGFloat gradient_W = centerWidth;
    CGFloat gradient_X = 0;
    CGRect gradientNewRect = self.gradient_Frame;
    
    gradientNewRect.size.height =  (CGRectGetHeight(self.introduction_Frame) <= 100) ? 0 : gradient_H;
    gradientNewRect.size.width  = gradient_W;
    gradientNewRect.origin.x    = gradient_X;
    gradientNewRect.origin.y    = gradient_Y;
    self.gradient_Frame    = gradientNewRect;
 
    
    //2、downView
    CGFloat down_X = 0;
    CGFloat down_Y = self.upViewFrame.size.height;
    CGFloat down_W = self.upViewFrame.size.width;
    CGFloat down_H = self.centerHeigh - 20;
    CGRect downViewNewFrame = self.downViewFrame;
    downViewNewFrame.size.height =  down_H;
    downViewNewFrame.size.width  = down_W;
    downViewNewFrame.origin.x    = down_X;
    downViewNewFrame.origin.y    = down_Y;
    self.downViewFrame = downViewNewFrame;
    
    //中间View
    CGRect centerViewNewFrame = self.centerView_Frame;
    centerViewNewFrame.size.height =  self.centerHeigh;
    centerViewNewFrame.size.width  = XSCREEN_WIDTH  - 2 * XMARGIN;
    centerViewNewFrame.origin.x    = XMARGIN;
    centerViewNewFrame.origin.y    = down_Y - 40;
    self.centerView_Frame =  centerViewNewFrame;
    
    
    //UITableViewHeaderView
    CGRect headerNewRect = self.header_Frame;
    headerNewRect.size.height =  CGRectGetMaxY(self.downViewFrame);
    headerNewRect.size.width  = XSCREEN_WIDTH;
    headerNewRect.origin.x    = 0;
    headerNewRect.origin.y    = 64;
    self.header_Frame = headerNewRect;
    
}


-(void)setShowMore:(BOOL)showMore{

    _showMore = showMore;
    
    [self updateCenterViewFrame:self.item];
    
}



-(void)oneSectonWithUni:(UniversitydetailNew *)item{
    
    _item = item;
    
    //1、校园风光
    CGFloat fenguan_X = 0;
    CGFloat fenguan_Y = XMARGIN * 2;
    CGFloat fenguan_W = XSCREEN_WIDTH;
    CGFloat fenguan_H = 20;
    self.fenguan_Frame = CGRectMake(fenguan_X, fenguan_Y, fenguan_W, fenguan_H);
    
    //校园风光图片容器
    CGFloat collection_X = 0;
    CGFloat collection_Y = CGRectGetMaxY(self.fenguan_Frame) + XMARGIN;
    CGFloat collection_W = XSCREEN_WIDTH;
    CGFloat collection_H = XPERCENT * 100;
    self.collectionView_Frame = CGRectMake(collection_X, collection_Y, collection_W, collection_H);
    
    //校园风光分隔线
    CGFloat lineOne_X = 10;
    CGFloat lineOne_Y = CGRectGetMaxY(self.collectionView_Frame) + XMARGIN;
    CGFloat lineOne_W = XSCREEN_WIDTH - 20;
    CGFloat lineOne_H = 1;
    self.fg_line_Frame = CGRectMake(lineOne_X, lineOne_Y, lineOne_W, lineOne_H);
    
    //王牌领域
    CGFloat key_X = 0;
    CGFloat key_Y = CGRectGetMaxY(self.fg_line_Frame) + XMARGIN * 2;
    CGFloat key_W = XSCREEN_WIDTH;
    CGFloat key_H = fenguan_H;
    self.key_Frame = CGRectMake(key_X, key_Y, key_W, key_H);
    
    //专业Array
    [self makeButtonItems:item.key_subjectArea];
    
    //王牌领域分隔线
    CGFloat lineTwo_X = lineOne_X;
    CGFloat lineTwo_Y = CGRectGetMaxY(self.subject_Bg_Frame) + XMARGIN;
    CGFloat lineTwo_W = lineOne_W;
    CGFloat lineTwo_H = lineOne_H;
    self.key_line_Frame = CGRectMake(lineTwo_X, lineTwo_Y, lineTwo_W, lineTwo_H);
    
    //历史排名
    CGFloat rank_X = 0;
    CGFloat rank_Y = CGRectGetMaxY(self.key_line_Frame) + XMARGIN * 2;
    CGFloat rank_W = lineOne_W;
    CGFloat rank_H = fenguan_H;
    self.rank_Frame = CGRectMake(rank_X, rank_Y, rank_W, rank_H);
    
    //历史排名选择项容器
    CGFloat select_X = 0;
    CGFloat select_Y = CGRectGetMaxY(self.rank_Frame) + XMARGIN;
    CGFloat select_W = XSCREEN_WIDTH;
    CGFloat select_H = 30;
    self.selection_Frame = CGRectMake(select_X, select_Y, select_W, select_H);
    
    //历史排名分隔线
    CGFloat h_lineX = XSCREEN_WIDTH * 0.5;
    CGFloat h_lineY = 0;
    CGFloat h_lineW = 1;
    CGFloat h_lineH = select_H;
    self.history_Line_Frame = CGRectMake(h_lineX, h_lineY, h_lineW, h_lineH);
    
    //世界排名按钮
    CGFloat qs_Y = 0;
    CGFloat qs_W = [@"QS世界排名" KD_sizeWithAttributeFont:XFONT(15)].width + 10;
    CGFloat qs_H = select_H;
    CGFloat qs_X = h_lineX - XMARGIN - qs_W;
    
    //本国排名按钮
    CGFloat times_Y = 0;
    CGFloat times_W = [@"TIMES排名" KD_sizeWithAttributeFont:XFONT(15)].width + 10;
    CGFloat times_H = select_H;
    CGFloat times_X = h_lineX + XMARGIN;
    if([item.country containsString:@"澳"]){
        qs_X      = 0.5 * (XSCREEN_WIDTH -  qs_W);
        times_X   =   XSCREEN_WIDTH;
        h_lineX  = XSCREEN_WIDTH;
    }
    self.history_Line_Frame = CGRectMake(h_lineX, h_lineY, h_lineW, h_lineH);
    self.qs_Frame = CGRectMake(qs_X, qs_Y, qs_W, qs_H);
    self.times_Frame = CGRectMake(times_X, times_Y, times_W, times_H);
    
    
    //图表
    CGFloat chart_Y =   CGRectGetMaxY(self.selection_Frame) + XMARGIN;
    CGFloat chart_W = XSCREEN_WIDTH -20;
    CGFloat chart_H = 150;
    CGFloat chart_X = 5;
    self.chart_Bg_Frame = CGRectMake(chart_X, chart_Y, chart_W, chart_H);
    
    
    self.group_One_Height = CGRectGetMaxY(self.chart_Bg_Frame) + 2 * XMARGIN;
    
}



-(void)makeButtonItems:(NSArray *)options{
    
    NSMutableArray *temp_Arr = [NSMutableArray array];
    
    //第一个 label的起点
    CGFloat itemX = 0;
    CGFloat itemY = 0;
    CGFloat itemW = 0;
    CGFloat itemH = 30;
    //间距
    CGFloat padding = XMARGIN;
    
    CGFloat MAXWidth = XSCREEN_WIDTH - 2 * XMARGIN;
    
    CGFloat MinWidth =  MAXWidth * 0.25;
    
    for (int i = 0; i < options.count; i ++) {
        
        NSString *option = options[i];
        
        itemW = [option KD_sizeWithAttributeFont:[UIFont systemFontOfSize:14]].width + padding;
        itemW = itemW <  MinWidth ? MinWidth : itemW;
        itemW = itemW > MAXWidth ? MAXWidth : itemW;
        
        if (MAXWidth - itemX < itemW) {
            
            itemY += (itemH + padding);
            
            itemX = 0;
        }
        
        
        CGRect  optionFrame =  CGRectMake(itemX, itemY, itemW, itemH);
        
        [temp_Arr addObject:[NSValue valueWithCGRect:optionFrame]];
        
        itemX += (itemW + padding);   //起点 增加
        
    }
    
    self.subjectItemFrames = [temp_Arr copy];
    
    CGFloat bgH  = itemY + itemH;
    CGFloat bgX  = XMARGIN;
    CGFloat bgY  = CGRectGetMaxY(self.key_Frame) + XMARGIN;
    CGFloat bgW  = MAXWidth;
    self.subject_Bg_Frame = CGRectMake(bgX, bgY, bgW, bgH);
    
}













@end
