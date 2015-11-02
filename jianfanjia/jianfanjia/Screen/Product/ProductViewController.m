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
@property (weak, nonatomic) IBOutlet UIView *designerView;
@property (weak, nonatomic) IBOutlet UIImageView *designerImageView;
@property (weak, nonatomic) IBOutlet UILabel *lblName;

@end

@implementation ProductViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerNib:[UINib nibWithNibName:@"ProductInfoCell" bundle:nil] forCellReuseIdentifier:@"ProductInfoCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"ProductImageCell" bundle:nil] forCellReuseIdentifier:@"ProductImageCell"];
    
    [self initNav];
    [self initUI];
    [self refresh];
}

#pragma mark - UI
- (void)initNav {
    self.navigationController.navigationBarHidden = NO;
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(onClickBack)];
    self.navigationItem.leftBarButtonItem = item;
}

- (void)initUI {
    [self.designerImageView setCornerRadius:15];
    [self.designerImageView setBorder:1 andColor:[[UIColor whiteColor] CGColor]];
    self.designerView.alpha = 0;
    
}

- (void)initUIData {
    [self.designerImageView setUserImageWithId:[DataManager shared].productPageProduct.designer.imageid];
    self.lblName.text = [DataManager shared].productPageProduct.designer.username;
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

#pragma mark - scroll view delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    DDLogDebug(@"%f", scrollView.contentOffset.y);
    if (scrollView.contentOffset.y >= -5 && scrollView.contentOffset.y <= 55) {
        float x = (scrollView.contentOffset.y - -5)/60;
        self.designerView.alpha = x;
    }
}


#pragma mark - user action
- (void)onClickBack {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Util
- (void)refresh {
    ProductHomePage *request = [[ProductHomePage alloc] init];
    request._id = self.productid;
    
    [API productHomeGage:request success:^{
        [self initUIData];
        [self.tableView reloadData];
    } failure:^{
    }];
}


@end
