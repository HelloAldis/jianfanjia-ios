//
//  ProcessBusiness.m
//  jianfanjia
//
//  Created by JYZ on 15/10/9.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "ProcessBusiness.h"

static NSDictionary *dictName = nil;

@implementation ProcessBusiness

+ (void)initialize {
    dictName = @{@"kai_gong":@"开工",
                 @"xcjd":@"现场交底",
                 @"qdzmjcl":@"墙地砖面积测量",
                 @"cgdyccl":@"橱柜第一次测量",
                 @"sgxcl":@"石膏线测量",
                 @"mdbcl":@"木地板测量",
                 @"kgmbslcl":@"开关面板数量核算",
                 
                 @"chai_gai":@"拆改",
                 @"cpbh":@"成品保护",
                 @"ztcg":@"主体拆改",
                 @"qpcc":@"墙皮铲除",
                 
                 @"shui_dian":@"水电",
                 @"sdsg":@"水电施工",
                 @"ntsg":@"暖通施工",
                 
                 @"ni_mu":@"泥木",
                 @"sgxaz":@"石膏线安装",
                 @"cwqfssg":@"厨卫全防水施工",
                 @"cwqdzsg":@"厨卫墙地砖施工",
                 @"ktytzsg":@"客厅阳台砖施工",
                 @"dmzp":@"地面找平",
                 @"ddsg":@"吊顶施工",
                 @"gtsg":@"柜体施工",
                 
                 @"you_qi":@"油漆",
                 @"mqqsg":@"木器漆施工",
                 @"qmrjq":@"墙面乳胶漆",
                 
                 @"an_zhuang":@"安装",
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
                 
                 @"jun_gong":@"竣工"};
}



+ (Process *)defaultProcess {
    NSString *json = @"{\"cell\":\"简繁家\",\"sections\":[{\"name\":\"kai_gong\",\"items\":[{\"name\":\"xcjd\",\"status\":\"0\"},{\"name\":\"sgxcl\",\"status\":\"0\"},{\"name\":\"mdbcl\",\"status\":\"0\"},{\"name\":\"cgdyccl\",\"status\":\"0\"},{\"name\":\"qdzmjcl\",\"status\":\"0\"},{\"name\":\"kgmbslcl\",\"status\":\"0\"}],\"status\":\"0\"},{\"name\":\"chai_gai\",\"items\":[{\"name\":\"cpbh\",\"status\":\"0\"},{\"name\":\"ztcg\",\"status\":\"0\"},{\"name\":\"qpcc\",\"status\":\"0\"}],\"status\":\"0\"},{\"name\":\"shui_dian\",\"items\":[{\"name\":\"sdsg\",\"status\":\"0\"},{\"name\":\"ntsg\",\"status\":\"0\"}],\"status\":\"0\"},{\"name\":\"ni_mu\",\"items\":[{\"name\":\"dmzp\",\"status\":\"0\"},{\"name\":\"ddsg\",\"status\":\"0\"},{\"name\":\"gtsg\",\"status\":\"0\"},{\"name\":\"sgxaz\",\"status\":\"0\"},{\"name\":\"cwqfssg\",\"status\":\"0\"},{\"name\":\"cwqdzsg\",\"status\":\"0\"},{\"name\":\"ktytzsg\",\"status\":\"0\"}],\"status\":\"0\"},{\"name\":\"you_qi\",\"items\":[{\"name\":\"mqqsg\",\"status\":\"2\"},{\"name\":\"qmjccl\",\"status\":\"0\"}],\"status\":\"0\"},{\"name\":\"an_zhuang\",\"items\":[{\"name\":\"mdbmmaz\",\"status\":\"0\"},{\"name\":\"cgscaz\",\"status\":\"0\"},{\"name\":\"mbdjaz\",\"status\":\"0\"},{\"name\":\"yjzjaz\",\"status\":\"0\"},{\"name\":\"scaz\",\"status\":\"0\"},{\"name\":\"cwddaz\",\"status\":\"0\"},{\"name\":\"qzpt\",\"status\":\"0\"},{\"name\":\"snzl\",\"status\":\"0\"},{\"name\":\"jjaz\",\"status\":\"0\"},{\"name\":\"wjaz\",\"status\":\"0\"}],\"status\":\"0\"},{\"name\":\"jun_gong\",\"status\":\"0\"}]}";
    NSMutableDictionary *dict = [NSJSONSerialization JSONObjectWithData:[json dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
    return [[Process alloc] initWith:dict];
}

+ (NSString *)nameForKey:(NSString *)key {
    return [dictName objectForKey:key];
}

+ (BOOL)hasYs:(NSInteger)sectionIndex {
    return sectionIndex != 0 || sectionIndex != 1;
}

@end
