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

@interface SelectCityViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *provinces;
@property (nonatomic, strong) NSArray *citys;
@property (nonatomic, strong) NSArray *areas;
@property (nonatomic, strong) NSString *selectedProvince;
@property (nonatomic, strong) NSString *selectedCity;
@property (nonatomic, strong) NSString *selectedArea;

@end

@implementation SelectCityViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initData];
}

#pragma mark - init data 
- (void)initData {
    if (self.displayType == kDisplayProvince) {
        self.provinces = @[
                            @{
                                @"name":@"湖北省",
                                @"sub":@[
                                            @{
                                                @"name":@"武汉市",
                                                @"sub":@[
                                                            @"洪山区",
                                                            @"江夏区"
                                                ]
                                            },
                                            
                                            @{
                                                @"name":@"咸宁市",
                                                @"sub":@[
                                                        @"咸安区",
                                                        @"温泉区"
                                                ]
                                            }
                                ]
                             },
                            
                            @{
                                @"name":@"湖北1省",
                                @"sub":@[
                                            @{
                                                @"name":@"武汉1市",
                                                @"sub":@[
                                                            @"洪山1区",
                                                            @"江夏1区"
                                                ]
                                            },
                                            
                                            @{
                                                @"name":@"咸宁1市",
                                                @"sub":@[
                                                        @"咸安1区",
                                                        @"温泉1区"
                                                ]
                                            }
                                ]
                              },
                        ];
    }
    
    if (self.displayType == kDisplayProvince) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:@selector(cancel)];
    }
    
    if (self.displayType == kDisplayArea) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(submit)];
    }
}

#pragma mark - table view delegate
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* ID = @"cityCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        if (self.displayType == kDisplayArea) {
            cell.accessoryType = UITableViewCellAccessoryNone;
        } else{
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    }
    
    if (self.displayType == kDisplayProvince) {
        NSDictionary *province = self.provinces[indexPath.row];
        NSString *provinceName = [province objectForKey:@"name"];
        cell.textLabel.text= provinceName;
    } else if (self.displayType == kDisplayCity){
        NSDictionary *city = self.citys[indexPath.row];
        NSString *cityName = [city objectForKey:@"name"];
        cell.textLabel.text= cityName;
    } else{
        cell.textLabel.text= self.areas[indexPath.row];
        cell.imageView.image = [UIImage imageNamed:@"unchecked"];
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.displayType == kDisplayProvince) {
        NSDictionary *province = self.provinces[indexPath.row];
        NSArray *citys = [province objectForKey:@"sub"];
        self.selectedProvince = [province objectForKey:@"name"];
        
        SelectCityViewController *cityVC = [[SelectCityViewController alloc]init];
        cityVC.displayType = kDisplayCity;//显示模式为城市
        cityVC.citys = citys;
        cityVC.selectedProvince = self.selectedProvince;
        [self.navigationController pushViewController:cityVC animated:YES];
    } else if (self.displayType == kDisplayCity){
        NSDictionary *city = self.citys[indexPath.row];
        self.selectedCity = [city objectForKey:@"name"];
        NSArray *areas = [city objectForKey:@"sub"];
        
        SelectCityViewController *areaVC = [[SelectCityViewController alloc]init];
        areaVC.displayType = kDisplayArea;//显示模式为区域
        areaVC.areas = areas;
        areaVC.selectedCity = self.selectedCity;
        areaVC.selectedProvince = self.selectedProvince;
        [self.navigationController pushViewController:areaVC animated:YES];
    } else{
        //取消上一次选定状态
        UITableViewCell *oldCell =  [tableView cellForRowAtIndexPath:self.selectedIndexPath];
//        oldCell.imageView.image = [UIImage imageNamed:@"unchecked"];
        //勾选当前选定状态
        UITableViewCell *newCell =  [tableView cellForRowAtIndexPath:indexPath];
//        newCell.imageView.image = [UIImage imageNamed:@"checked"];
        //保存
        self.selectedArea = self.areas[indexPath.row];
        self.selectedIndexPath = indexPath;
    }
    
}

-(void)submit{
    [DataManager shared].selectedProvince = self.selectedProvince;
    [DataManager shared].selectedCity = self.selectedCity;
    [DataManager shared].selectedArea = self.selectedArea;
}

-(void)cancel{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
