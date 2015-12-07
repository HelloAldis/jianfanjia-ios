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
#import "ViewControllerContainer.h"
#import "ProductPageData.h"

@interface ProductViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *designerView;
@property (weak, nonatomic) IBOutlet UIImageView *designerImageView;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;

@property (strong, nonatomic) ProductPageData *productPageData;

@end

@implementation ProductViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerNib:[UINib nibWithNibName:@"ProductInfoCell" bundle:nil] forCellReuseIdentifier:@"ProductInfoCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"ProductImageCell" bundle:nil] forCellReuseIdentifier:@"ProductImageCell"];
    
    self.needRefreshProductViewController = YES;
    self.productPageData = [[ProductPageData alloc] init];
    [self initLeftBackInNav];
    [self initUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.needRefreshProductViewController) {
        [self refresh];
    }
}

#pragma mark - UI
- (void)initUI {
    [self.designerImageView setCornerRadius:15];
    [self.designerImageView setBorder:1 andColor:[[UIColor whiteColor] CGColor]];
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)initUIData {
    [self.designerImageView setUserImageWithId:self.productPageData.product.designer.imageid];
    self.lblName.text = self.productPageData.product.designer.username;
}


#pragma mark - table view delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.productPageData.product) {
            return 1 + self.productPageData.product.images.count;
    } else {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        ProductInfoCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"ProductInfoCell"];
        [cell initWithProduct:self.productPageData.product];
        return cell;
    } else {
        ProductImageCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"ProductImageCell"];
        [cell initWithProductImage:[self.productPageData.product imageAtIndex:indexPath.row - 1]
                          andIndex:indexPath.row - 1
                         andImages:self.productPageData.product.images];
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
    if (scrollView.contentOffset.y >= -64 && scrollView.contentOffset.y <= 200) {
        CGFloat dy = scrollView.contentOffset.y - 39;
        if (dy < 0) {
            dy = 0;
            self.title = nil;
        } else if (dy > 44) {
            dy = 44;
            self.title = self.productPageData.product.cell;
        }
        
        self.topConstraint.constant = 20 + dy;
    }
}


#pragma mark - user action
- (IBAction)onTapDesigner:(id)sender {
    [ViewControllerContainer showDesigner:self.productPageData.product.designer._id];
}

#pragma mark - Util
- (void)refresh {
    ProductHomePage *request = [[ProductHomePage alloc] init];
    request._id = self.productid;
    
    @weakify(self);
    [API productHomePage:request success:^{
        @strongify(self);
        [self.productPageData refresh];
        self.needRefreshProductViewController = NO;
        [self initUIData];
        [self.tableView reloadData];
    } failure:^{
    } networkError:^{
        
    }];
}


@end
