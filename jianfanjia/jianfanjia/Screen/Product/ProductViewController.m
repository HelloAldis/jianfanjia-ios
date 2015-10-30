//
//  ProductViewController.m
//  jianfanjia
//
//  Created by JYZ on 15/10/29.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "ProductViewController.h"
#import "ProductInfoCell.h"
#import "ProductImageCell.h"

@interface ProductViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ProductViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerNib:[UINib nibWithNibName:@"ProductInfoCell" bundle:nil] forCellReuseIdentifier:@"ProductInfoCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"ProductImageCell" bundle:nil] forCellReuseIdentifier:@"ProductImageCell"];
    
    [self initNav];
    [self refresh];
}

#pragma mark - UI
- (void)initNav {
    self.navigationController.navigationBarHidden = NO;
}


#pragma mark - table view delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1 + [DataManager shared].productPageProduct.images.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        ProductInfoCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"ProductInfoCell"];
        [cell initWithProduct:[DataManager shared].productPageProduct];
        return cell;
    } else {
        ProductImageCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"ProductImageCell"];
        [cell initWithProductImage:[[DataManager shared].productPageProduct imageAtIndex:indexPath.row - 1]];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 245;
    } else {
        return 350;
    }
}

#pragma mark - Util
- (void)refresh {
    ProductHomePage *request = [[ProductHomePage alloc] init];
    request._id = self.productid;
    
    [API productHomeGage:request success:^{
        [self.tableView reloadData];
    } failure:^{
    }];
}


@end
