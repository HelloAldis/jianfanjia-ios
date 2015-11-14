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
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(onClickBack)];
    self.navigationItem.leftBarButtonItem = item;
    
    
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
        NSData *allProvinceData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"allprovince" ofType:@"js"]];
        
        self.provinces = [NSJSONSerialization JSONObjectWithData:allProvinceData options:NSJSONReadingMutableContainers error:nil];
    } else if (self.displayType == kDisplayCity) {
        NSData *province2cityData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"province2city" ofType:@"js"]];
        NSDictionary *province2cityDic = [NSJSONSerialization JSONObjectWithData:province2cityData options:NSJSONReadingMutableContainers error:nil];
        
        self.citys = province2cityDic[self.selectedProvince];
    } else if (self.displayType == kDisplayArea) {
        NSData *city2AreaData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"city2area" ofType:@"js"]];
        NSDictionary *city2AreaDic = [NSJSONSerialization JSONObjectWithData:city2AreaData options:NSJSONReadingMutableContainers error:nil];
        
        self.areas = city2AreaDic[self.selectedCity];
    }
}

#pragma mark - user action
- (void)onClickBack {
    [self.navigationController popViewControllerAnimated:YES];
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
        NSString *provinceName = self.provinces[indexPath.row];
        cell.textLabel.text= provinceName;
    } else if (self.displayType == kDisplayCity){
        NSString *cityName = self.citys[indexPath.row];
        cell.textLabel.text= cityName;
    } else{
        cell.textLabel.text= self.areas[indexPath.row];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.displayType == kDisplayProvince) {
        self.selectedProvince = self.provinces[indexPath.row];
        
        SelectCityViewController *cityVC = [[SelectCityViewController alloc]init];
        cityVC.displayType = kDisplayCity;
        cityVC.selectedProvince = self.selectedProvince;
        [self.navigationController pushViewController:cityVC animated:YES];
    } else if (self.displayType == kDisplayCity){
        self.selectedCity = self.citys[indexPath.row];
        
        SelectCityViewController *areaVC = [[SelectCityViewController alloc]init];
        areaVC.displayType = kDisplayArea;
        areaVC.selectedCity = self.selectedCity;
        areaVC.selectedProvince = self.selectedProvince;
        [self.navigationController pushViewController:areaVC animated:YES];
    } else{
        self.selectedArea = self.areas[indexPath.row];
        [self submit];
    }
    
}

#pragma mark - other
-(void)submit{
    [DataManager shared].requirementPageSelectedProvince = self.selectedProvince;
    [DataManager shared].requirementPageSelectedCity = self.selectedCity;
    [DataManager shared].requirementPageSelectedArea = self.selectedArea;
    
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
