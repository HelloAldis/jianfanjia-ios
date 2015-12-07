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

@interface SelectCityViewController () <CLLocationManagerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, assign) int displayType;
@property (nonatomic, strong) NSMutableArray *provinces;
@property (nonatomic, strong) NSMutableArray *citys;
@property (nonatomic, strong) NSMutableArray *areas;
@property (nonatomic, strong) NSString *selectedProvince;
@property (nonatomic, strong) NSString *selectedCity;
@property (nonatomic, strong) NSString *selectedArea;

@property (strong, nonatomic) CLLocationManager* locationManager;
@property (strong, nonatomic) NSString *locationAddress;

@property (strong, nonatomic) NSString *currentAddress;

@end

@implementation SelectCityViewController

#pragma mark - init method 
- (id)initWithAddress:(NSString *)currentAddress valueBlock:(ValueBlock)ValueBlock {
    if (self = [super initWithValueBlock:ValueBlock]) {
        _currentAddress = currentAddress;
    }
    
    return self;
}

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initNav];
    [self initUI];
    [self initData];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (self.displayType == kDisplayProvince) {
        [self startLocation];
    }
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
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellId];
}

#pragma mark - init data 
- (void)initData {
    NSString *currentProvince;
    NSString *currentCity;
    NSString *currentArea;
    if (self.currentAddress) {
        NSArray *addressArr = [self.currentAddress componentsSeparatedByString:@" "];
        currentProvince = addressArr[0];
        currentCity = addressArr[1];
        currentArea = addressArr[2];
    }
    
    if (self.displayType == kDisplayProvince) {
        NSData *allProvinceData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"allprovince" ofType:@"js"]];
        
        self.provinces = [NSJSONSerialization JSONObjectWithData:allProvinceData options:NSJSONReadingMutableContainers error:nil];
        if (currentProvince) {
            [self.provinces removeObject:currentProvince];
            [self.provinces insertObject:currentProvince atIndex:0];
        }
        
    } else if (self.displayType == kDisplayCity) {
        NSData *province2cityData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"province2city" ofType:@"js"]];
        NSDictionary *province2cityDic = [NSJSONSerialization JSONObjectWithData:province2cityData options:NSJSONReadingMutableContainers error:nil];
        
        self.citys = province2cityDic[self.selectedProvince];
        if (currentCity && [self.citys containsObject:currentCity]) {
            [self.citys removeObject:currentCity];
            [self.citys insertObject:currentCity atIndex:0];
        }
    } else if (self.displayType == kDisplayArea) {
        NSData *city2AreaData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"city2area" ofType:@"js"]];
        NSDictionary *city2AreaDic = [NSJSONSerialization JSONObjectWithData:city2AreaData options:NSJSONReadingMutableContainers error:nil];
        
        self.areas = city2AreaDic[self.selectedCity];
        if (currentArea && [self.areas containsObject:currentArea]) {
            [self.areas removeObject:currentArea];
            [self.areas insertObject:currentArea atIndex:0];
        }
    }
}

#pragma mark - location
-(void)startLocation{
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.distanceFilter = 500.0f;
    [self.locationManager requestWhenInUseAuthorization];//使用程序其间允许访问位置数据
    [self.locationManager startUpdatingLocation];
}

-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    [self.locationManager stopUpdatingLocation];
    NSLog(@"location ok");
    
    NSLog(@"%@",[NSString stringWithFormat:@"经度:%3.5f\n纬度:%3.5f",newLocation.coordinate.latitude,newLocation.coordinate.longitude]);
    
    CLGeocoder * geoCoder = [[CLGeocoder alloc] init];
    [geoCoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        for (CLPlacemark * placemark in placemarks) {
            
            NSDictionary *address = [placemark addressDictionary];
            // State(省) City(城市)  SubLocality(区)
            self.locationAddress = [NSString stringWithFormat:@"%@ %@ %@", address[@"State"], address[@"City"], address[@"SubLocality"]];
            UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
            cell.textLabel.text = self.locationAddress;
            cell.selectionStyle = UITableViewCellSelectionStyleBlue;
            break;
        }
    }];
}

#pragma mark - user action
- (void)onClickBack {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - table view delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.displayType == kDisplayProvince) {
        return 2;
    } else {
        return 1;
    }
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    cell.textLabel.font = [UIFont systemFontOfSize:13];
    cell.textLabel.textColor = kTextColor;
    cell.backgroundColor = self.tableView.backgroundColor;
    if (self.displayType == kDisplayProvince && section == 0) {
        cell.textLabel.text = @"定位到的位置";
    } else {
        cell.textLabel.text = @"全部";
    }
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.displayType == kDisplayProvince) {
        if (section == 0) {
            return 1;
        } else {
            return [self.provinces count];
        }
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
        if (indexPath.section == 0) {
            cell.textLabel.text= self.locationAddress ? self.locationAddress : @"正在定位中...";
            cell.selectionStyle = self.locationAddress ? UITableViewCellSelectionStyleBlue : UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryNone;
        } else {
            NSString *provinceName = self.provinces[indexPath.row];
            cell.textLabel.text= provinceName;
//            if (self.currentAddress) {
//                cell.detailTextLabel.font = [UIFont systemFontOfSize:13];
//                cell.detailTextLabel.textColor = kTextColor;
//                cell.detailTextLabel.text = @"已选地区";
//            }
        }
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
        if (indexPath.section == 0) {
            if (self.locationAddress) {
                NSArray *addressArr = [self.locationAddress componentsSeparatedByString:@" "];
                self.selectedProvince = addressArr[0];
                self.selectedCity = addressArr[1];
                self.selectedArea = addressArr[2];
                
                [self submit];
            }
        } else {
            self.selectedProvince = self.provinces[indexPath.row];
            
            SelectCityViewController *cityVC = [[SelectCityViewController alloc] initWithAddress:self.currentAddress valueBlock:self.ValueBlock];
            cityVC.displayType = kDisplayCity;
            cityVC.selectedProvince = self.selectedProvince;
            [self.navigationController pushViewController:cityVC animated:YES];
        }
    } else if (self.displayType == kDisplayCity){
        self.selectedCity = self.citys[indexPath.row];
        
        SelectCityViewController *areaVC = [[SelectCityViewController alloc] initWithAddress:self.currentAddress valueBlock:self.ValueBlock];
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
    if (self.ValueBlock) {
        self.ValueBlock([NSString stringWithFormat:@"%@ %@ %@", self.selectedProvince, self.selectedCity, self.selectedArea]);
    }
    
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
