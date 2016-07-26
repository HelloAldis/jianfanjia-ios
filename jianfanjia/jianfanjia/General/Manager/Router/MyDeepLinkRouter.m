//
//  MyDeepLinkRouter.m
//  jianfanjia
//
//  Created by Karos on 16/7/26.
//  Copyright © 2016年 JYZ. All rights reserved.
//

#import "MyDeepLinkRouter.h"
#import "ViewControllerContainer.h"
#import "WebViewController.h"

@implementation MyDeepLinkRouter

- (instancetype)init {
    if (self = [super init]) {
        [self configure];
    }
    
    return self;
}

- (void)configure {
    //jianfanjia://m.jianfanjia.com/jianfanjiaapp/diaryset?diarySetid=577104e90d135f8d2d493eba
    self[@".*\\.jianfanjia\\.com/jianfanjiaapp/diaryset"] = ^(DPLDeepLink *link) {
        NSString *diarySetId = link[@"diarySetid"];
        GetDiarySetDetail *request = [[GetDiarySetDetail alloc] init];
        request.diarySetid = diarySetId;
        [API getDiarySetDetail:request success:^{
            NSMutableDictionary *dic = [DataManager shared].data;
            DiarySet *diarySet = [[DiarySet alloc] initWith:dic];
            [ViewControllerContainer showDiarySetDetail:diarySet fromNewDiarySet:NO];
        } failure:^{
            
        } networkError:^{
            
        }];
    };
    
    //jianfanjia://m.jianfanjia.com/jianfanjiaapp/webview?url=http://devm.jianfanjia.com/weixin/jian/
    self[@".*\\.jianfanjia\\.com/jianfanjiaapp/webview"] = ^(DPLDeepLink *link) {
        NSString *url = link[@"url"];
        [WebViewController show:[ViewControllerContainer getCurrentTopController] withUrl:url shareTopic:@"Link"];
    };
    
    //default
    self[@".*\\.jianfanjia\\.com/jianfanjiaapp/.*"] = ^(DPLDeepLink *link) {
        
    };
}

@end
