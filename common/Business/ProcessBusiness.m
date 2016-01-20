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

static NSDictionary *dictName = nil;
static NSArray *sectionsName = nil;

@implementation ProcessBusiness

+ (void)initialize {
    sectionsName = @[KAI_GONG, CHAI_GAI, SHUI_DIAN, NI_MU, YOU_QI, AN_ZHUANG, JUN_GONG];
    
    dictName = @{KAI_GONG:@"开工",
                 @"xcjd":@"现场交底",
                 @"qdzmjcl":@"墙地砖面积测量",
                 @"cgdyccl":@"橱柜第一次测量",
                 @"sgxcl":@"石膏线测量",
                 @"mdbcl":@"木地板测量",
                 @"kgmbslcl":@"开关面板数量核算",
                 
                 CHAI_GAI:@"拆改",
                 @"cpbh":@"成品保护",
                 @"ztcg":@"主体拆改",
                 @"qpcc":@"墙皮铲除",
                 
                 SHUI_DIAN:@"水电",
                 @"sdsg":@"水电施工",
                 @"ntsg":@"暖通施工",
                 
                 NI_MU:@"泥木",
                 @"sgxaz":@"石膏线安装",
                 @"cwqfssg":@"厨卫全防水施工",
                 @"cwqdzsg":@"厨卫墙地砖施工",
                 @"ktytzsg":@"客厅阳台砖施工",
                 @"dmzp":@"地面找平",
                 @"ddsg":@"吊顶施工",
                 @"gtsg":@"柜体施工",
                 
                 YOU_QI:@"油漆",
                 @"mqqsg":@"木器漆施工",
                 @"qmrjq":@"墙面乳胶漆",
                 
                 AN_ZHUANG:@"安装",
                 @"scaz":@"石材安装",
                 @"jjaz":@"洁具安装",
                 @"cwddaz":@"厨卫吊顶安装",
                 @"wjaz":@"五金安装",
                 @"cgscaz":@"橱柜水槽安装",
                 @"yjzjaz":@"烟机灶具安装",
                 @"mdbmmaz":@"木地板木门安装",
                 @"qzpt":@"墙纸铺贴",
                 @"mbdjaz":@"面板灯具安装",
                 @"snzl":@"室内整理",
                 
                 JUN_GONG:@"竣工",
                 
                 DBYS:@"对比验收"};
}



+ (Process *)defaultProcess {
    NSString *json = @"{\"cell\":\"简繁家\",\"sections\":[{\"name\":\"kai_gong\",\"items\":[{\"name\":\"xcjd\",\"status\":\"0\"},{\"name\":\"sgxcl\",\"status\":\"0\"},{\"name\":\"mdbcl\",\"status\":\"0\"},{\"name\":\"cgdyccl\",\"status\":\"0\"},{\"name\":\"qdzmjcl\",\"status\":\"0\"},{\"name\":\"kgmbslcl\",\"status\":\"0\"}],\"status\":\"0\"},{\"name\":\"chai_gai\",\"items\":[{\"name\":\"cpbh\",\"status\":\"0\"},{\"name\":\"ztcg\",\"status\":\"0\"},{\"name\":\"qpcc\",\"status\":\"0\"}],\"status\":\"0\"},{\"name\":\"shui_dian\",\"items\":[{\"name\":\"sdsg\",\"status\":\"0\"},{\"name\":\"ntsg\",\"status\":\"0\"}],\"status\":\"0\"},{\"name\":\"ni_mu\",\"items\":[{\"name\":\"dmzp\",\"status\":\"0\"},{\"name\":\"ddsg\",\"status\":\"0\"},{\"name\":\"gtsg\",\"status\":\"0\"},{\"name\":\"sgxaz\",\"status\":\"0\"},{\"name\":\"cwqfssg\",\"status\":\"0\"},{\"name\":\"cwqdzsg\",\"status\":\"0\"},{\"name\":\"ktytzsg\",\"status\":\"0\"}],\"status\":\"0\"},{\"name\":\"you_qi\",\"items\":[{\"name\":\"mqqsg\",\"status\":\"0\"},{\"name\":\"qmjccl\",\"status\":\"0\"}],\"status\":\"0\"},{\"name\":\"an_zhuang\",\"items\":[{\"name\":\"mdbmmaz\",\"status\":\"0\"},{\"name\":\"cgscaz\",\"status\":\"0\"},{\"name\":\"mbdjaz\",\"status\":\"0\"},{\"name\":\"yjzjaz\",\"status\":\"0\"},{\"name\":\"scaz\",\"status\":\"0\"},{\"name\":\"cwddaz\",\"status\":\"0\"},{\"name\":\"qzpt\",\"status\":\"0\"},{\"name\":\"snzl\",\"status\":\"0\"},{\"name\":\"jjaz\",\"status\":\"0\"},{\"name\":\"wjaz\",\"status\":\"0\"}],\"status\":\"0\"},{\"name\":\"jun_gong\",\"status\":\"0\"}]}";
    NSMutableDictionary *dict = [NSJSONSerialization JSONObjectWithData:[json dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
    return [[Process alloc] initWith:dict];
}

+ (NSString *)nameForKey:(NSString *)key {
    return [dictName objectForKey:key];
}

+ (BOOL)hasYs:(NSInteger)sectionIndex {
    return !(sectionIndex == 0 || sectionIndex == 1);
}

+ (NSArray *)allSectionName {
    return sectionsName;
}

@end
