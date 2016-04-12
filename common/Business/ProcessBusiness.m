//
//  ProcessBusiness.m
//  jianfanjia
//
//  Created by JYZ on 15/10/9.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "ProcessBusiness.h"
NSString * const KAI_GONG = @"kai_gong";
NSString * const CHAI_GAI = @"chai_gai";
NSString * const SHUI_DIAN = @"shui_dian";
NSString * const NI_MU = @"ni_mu";
NSString * const YOU_QI = @"you_qi";
NSString * const AN_ZHUANG = @"an_zhuang";
NSString * const JUN_GONG = @"jun_gong";
NSString * const DBYS = @"dbys";

static NSArray *sectionsName = nil;

@implementation ProcessBusiness

//+ (void)initialize {
//    sectionsName = @[KAI_GONG, CHAI_GAI, SHUI_DIAN, NI_MU, YOU_QI, AN_ZHUANG, JUN_GONG];
//}

+ (Process *)defaultProcess {
    NSString *json = @"{\"cell\":\"简繁家\",\"sections\":[{\"name\":\"kai_gong\",\"items\":[{\"name\":\"xcjd\",\"status\":\"0\",\"label\":\"现场交底\"},{\"name\":\"cgdyccl\",\"status\":\"0\",\"label\":\"橱柜第一次测量 \"},{\"name\":\"qdzmjcl\",\"status\":\"0\",\"label\":\"墙地砖面积测量 \"},{\"name\":\"sgxcl\",\"status\":\"0\",\"label\":\"石膏线测量\"},{\"name\":\"mdbcl\",\"status\":\"0\",\"label\":\"木地板测量\"},{\"name\":\"kgmbslcl\",\"status\":\"0\",\"label\":\"开关面板数量核算\"}],\"status\":\"0\",\"label\":\"开工\"},{\"name\":\"chai_gai\",\"items\":[{\"name\":\"cpbh\",\"status\":\"0\",\"label\":\"成品保护\"},{\"name\":\"ztcg\",\"status\":\"0\",\"label\":\"主体拆改\"},{\"name\":\"qpcc\",\"status\":\"0\",\"label\":\"墙皮铲除\"}],\"status\":\"0\",\"label\":\"折改\"},{\"name\":\"shui_dian\",\"items\":[{\"name\":\"sdsg\",\"status\":\"0\",\"label\":\"水电施工\"},{\"name\":\"ntsg\",\"status\":\"0\",\"label\":\"暖通施工\"}],\"status\":\"0\",\"label\":\"水电\"},{\"name\":\"ni_mu\",\"items\":[{\"name\":\"sgxaz\",\"status\":\"0\",\"label\":\"石膏线安装\"},{\"name\":\"cwqfssg\",\"status\":\"0\",\"label\":\"厨卫全防水施工\"},{\"name\":\"cwqdzsg\",\"status\":\"0\",\"label\":\"厨卫墙地砖施工\"},{\"name\":\"ktytzsg\",\"status\":\"0\",\"label\":\"客厅阳台砖施工\"},{\"name\":\"dmzp\",\"status\":\"0\",\"label\":\"地面找平\"},{\"name\":\"ddsg\",\"status\":\"0\",\"label\":\"吊顶施工\"},{\"name\":\"gtsg\",\"status\":\"0\",\"label\":\"柜体施工\"}],\"status\":\"0\",\"label\":\"泥木\"},{\"name\":\"you_qi\",\"items\":[{\"name\":\"mqqsg\",\"status\":\"0\",\"label\":\"木器漆施工\"},{\"name\":\"qmrjq\",\"status\":\"0\",\"label\":\"墙面乳胶漆\"}],\"status\":\"0\",\"label\":\"油漆\"},{\"name\":\"an_zhuang\",\"items\":[{\"name\":\"scaz\",\"status\":\"0\",\"label\":\"石材安装\"},{\"name\":\"jjaz\",\"status\":\"0\",\"label\":\"洁具安装\"},{\"name\":\"cwddaz\",\"status\":\"0\",\"label\":\"厨卫吊顶安装\"},{\"name\":\"wjaz\",\"status\":\"0\",\"label\":\"五金安装\"},{\"name\":\"cgscaz\",\"status\":\"0\",\"label\":\"橱柜、水槽安装\"},{\"name\":\"yjzjaz\",\"status\":\"0\",\"label\":\"烟机灶具安装\"},{\"name\":\"mdbmmaz\",\"status\":\"0\",\"label\":\"木地板、木门安装\"},{\"name\":\"qzpt\",\"status\":\"0\",\"label\":\"墙纸铺贴\"},{\"name\":\"mbdjaz\",\"status\":\"0\",\"label\":\"面板灯具安装\"},{\"name\":\"snzl\",\"status\":\"0\",\"label\":\"室内整理\"}],\"status\":\"0\",\"label\":\"安装\"},{\"name\":\"jun_gong\",\"items\":[],\"status\":\"0\",\"label\":\"竣工\"}]}";
    NSMutableDictionary *dict = [NSJSONSerialization JSONObjectWithData:[json dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
    return [[Process alloc] initWith:dict];
}

//+ (NSString *)nameForKey:(NSString *)key {
//    return [dictName objectForKey:key];
//}

+ (BOOL)hasYs:(NSInteger)sectionIndex {
    return !(sectionIndex == 0 || sectionIndex == 1);
}

//+ (NSArray *)allSectionName {
//    return sectionsName;
//}

+ (BOOL)isAllSectionItemsFinished:(Section *)section {
    __block BOOL finished = YES;
    
    NSArray *arr = [section.data objectForKey:@"items"];
    [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        Item *item = [[Item alloc] initWith:obj];
        if (![item.status isEqualToString:kSectionStatusAlreadyFinished]) {
            finished = NO;
            *stop = YES;
        }
    }];
    
    return finished;
}

@end
