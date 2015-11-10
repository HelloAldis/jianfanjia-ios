//
//  SelectCityViewController.m
//  jianfanjia
//
//  Created by Karos on 15/11/9.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "SelectCityViewController.h"

#define kDisplayProvince    0
#define kDisplayCity        1
#define kDisplayArea        2

#define kKeyName            @"name"
#define kKeySub             @"sub"

static NSString* cellId = @"cityCell";

@interface SelectCityViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, assign) int displayType;
@property (nonatomic, strong) NSArray *provinces;
@property (nonatomic, strong) NSArray *citys;
@property (nonatomic, strong) NSArray *areas;
@property (nonatomic, strong) NSString *selectedProvince;
@property (nonatomic, strong) NSString *selectedCity;
@property (nonatomic, strong) NSString *selectedArea;
@property (nonatomic, weak) NSIndexPath *selectedIndexPath;

@end

@implementation SelectCityViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initNav];
    [self initUI];
    [self initData];
}

#pragma mark - init Nav
- (void)initNav {
    [[UIBarButtonItem appearance]setBackButtonTitlePositionAdjustment:UIOffsetMake(NSIntegerMin, NSIntegerMin) forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTintColor:[UIColor colorWithR:0x34 g:0x4a b:0x5c]];
    [self.navigationController.navigationItem.titleView setTintColor:[UIColor colorWithR:0x34 g:0x4a b:0x5c]];
    
    if (self.displayType == kDisplayProvince) {
        self.title = @"省份选择";
    } else if (self.displayType == kDisplayCity){
        self.title = @"城市选择";
    } else {
        self.title = @"区域选择";
    }
}

#pragma mark - UI
- (void)initUI {
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellId];
}

#pragma mark - init data 
- (void)initData {
    if (self.displayType == kDisplayProvince) {
        self.provinces = @[
                            @{
                                kKeyName:@"湖北省",
                                kKeySub:@[
                                            @{
                                                kKeyName:@"武汉市",
                                                kKeySub:@[
                                                            @"洪山区",
                                                            @"江夏区"
                                                ]
                                            },
                                            
                                            @{
                                                kKeyName:@"咸宁市",
                                                kKeySub:@[
                                                        @"咸安区",
                                                        @"温泉区"
                                                ]
                                            }
                                ]
                             },
                            
                            @{
                                kKeyName:@"湖北1省",
                                kKeySub:@[
                                            @{
                                                kKeyName:@"武汉1市",
                                                kKeySub:@[
                                                            @"洪山1区",
                                                            @"江夏1区"
                                                ]
                                            },
                                            
                                            @{
                                                kKeyName:@"咸宁1市",
                                                kKeySub:@[
                                                        @"咸安1区",
                                                        @"温泉1区"
                                                ]
                                            }
                                ]
                              },
                        ];
    }
}

#pragma mark - table view delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.displayType == kDisplayProvince) {
        return [self.provinces count];
    } else if (self.displayType == kDisplayCity){
        return [self.citys count];
    } else {
        return [self.areas count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];

    if (self.displayType == kDisplayArea) {
        cell.accessoryType = UITableViewCellAccessoryNone;
    } else{
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }

    
    if (self.displayType == kDisplayProvince) {
        NSDictionary *province = self.provinces[indexPath.row];
        NSString *provinceName = [province objectForKey:kKeyName];
        cell.textLabel.text= provinceName;
    } else if (self.displayType == kDisplayCity){
        NSDictionary *city = self.citys[indexPath.row];
        NSString *cityName = [city objectForKey:kKeyName];
        cell.textLabel.text= cityName;
    } else{
        cell.textLabel.text= self.areas[indexPath.row];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.displayType == kDisplayProvince) {
        NSDictionary *province = self.provinces[indexPath.row];
        NSArray *citys = [province objectForKey:kKeySub];
        self.selectedProvince = [province objectForKey:kKeyName];
        
        SelectCityViewController *cityVC = [[SelectCityViewController alloc]init];
        cityVC.displayType = kDisplayCity;
        cityVC.citys = citys;
        cityVC.selectedProvince = self.selectedProvince;
        [self.navigationController pushViewController:cityVC animated:YES];
    } else if (self.displayType == kDisplayCity){
        NSDictionary *city = self.citys[indexPath.row];
        self.selectedCity = [city objectForKey:kKeyName];
        NSArray *areas = [city objectForKey:kKeySub];
        
        SelectCityViewController *areaVC = [[SelectCityViewController alloc]init];
        areaVC.displayType = kDisplayArea;
        areaVC.areas = areas;
        areaVC.selectedCity = self.selectedCity;
        areaVC.selectedProvince = self.selectedProvince;
        [self.navigationController pushViewController:areaVC animated:YES];
    } else{
        self.selectedArea = self.areas[indexPath.row];
        [self submit];
    }
    
}

-(void)submit{
    [DataManager shared].selectedProvince = self.selectedProvince;
    [DataManager shared].selectedCity = self.selectedCity;
    [DataManager shared].selectedArea = self.selectedArea;
    
    [self navigateToOriginalScreen];
}

- (void)navigateToOriginalScreen {
    NSArray *controllers = [[self.navigationController.viewControllers reverseObjectEnumerator] allObjects];
    UIViewController *purposeController = nil;
    for (UIViewController *controller in controllers) {
        if (![controller isKindOfClass:[SelectCityViewController class]]) {
            purposeController = controller;
            break;
        }
    }
    
    [self.navigationController popToViewController:purposeController animated:YES];
}


@end
