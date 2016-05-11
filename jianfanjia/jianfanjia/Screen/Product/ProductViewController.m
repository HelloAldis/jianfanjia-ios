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

@property (strong, nonatomic) UIBarButtonItem *favoriateBarButton;
@property (strong, nonatomic) UIBarButtonItem *unfavoriateBarButton;

@end

@implementation ProductViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerNib:[UINib nibWithNibName:@"ProductInfoCell" bundle:nil] forCellReuseIdentifier:@"ProductInfoCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"ProductImageCell" bundle:nil] forCellReuseIdentifier:@"ProductImageCell"];
    
    self.needRefreshProductViewController = YES;
    self.productPageData = [[ProductPageData alloc] init];
    [self initNav];
    [self initUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.needRefreshProductViewController) {
        [self refresh];
    }
}

#pragma mark - UI
- (void)initNav {
    [self initLeftBackInNav];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"product_favoriate_no"]];
    @weakify(self);
    [imageView addTapBounceAnimation:^{
        @strongify(self);
        [self onClickFavoriate];
    }];
    self.favoriateBarButton = [[UIBarButtonItem alloc] initWithCustomView:imageView];
    
    imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"product_favoriate_yes"]];
    [imageView addTapBounceAnimation:^{
        @strongify(self);
        [self onClickUnfavoriate];
    }];
    self.unfavoriateBarButton = [[UIBarButtonItem alloc] initWithCustomView:imageView];
}

- (void)initUI {
    [self.designerImageView setCornerRadius:15];
    [self.designerImageView setBorder:1 andColor:[[UIColor whiteColor] CGColor]];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.contentInset = UIEdgeInsetsMake(kNavWithStatusBarHeight, 0, 0, 0);
    self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 300;
}

- (void)initUIData {
    [self.designerImageView setUserImageWithId:self.productPageData.product.designer.imageid];
    self.lblName.text = self.productPageData.product.designer.username;
    if ([self.productPageData.product.is_my_favorite boolValue]) {
        [self.navigationItem setRightBarButtonItem:self.unfavoriateBarButton animated:YES];
    } else {
        [self.navigationItem setRightBarButtonItem:self.favoriateBarButton animated:YES];
    }
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

#pragma mark - scroll view delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self adjustTopView];
    
    if (!scrollView.isDecelerating) {
        if (self.presentingViewController && scrollView.contentOffset.y < -(scrollView.contentInset.top + 30)) {
            [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
        }
    }
}

- (void)adjustTopView {
    if (self.tableView.contentOffset.y >= -kNavWithStatusBarHeight && self.tableView.contentOffset.y <= 200) {
        CGFloat dy = self.tableView.contentOffset.y;
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

- (void)onClickFavoriate {
    [[LoginEngine shared] showLogin:^(BOOL logined) {
        if (logined) {
            AddFavoriateProduct *request = [[AddFavoriateProduct alloc] init];
            request._id = self.productPageData.product._id;
            
            @weakify(self);
            [API addFavoriateProduct:request success:^{
                @strongify(self);
                [self.navigationItem setRightBarButtonItem:self.unfavoriateBarButton animated:YES];
                [HUDUtil showSuccessText:@"收藏成功"];
            } failure:^{
            } networkError:^{
            }];
        }
    }];
}

- (void)onClickUnfavoriate {
    [[LoginEngine shared] showLogin:^(BOOL logined) {
        if (logined) {
            DeleteFavoriateProduct *request = [[DeleteFavoriateProduct alloc] init];
            request._id = self.productPageData.product._id;
            
            @weakify(self);
            [API deleteFavoriateProduct:request success:^{
                @strongify(self);
                [self.navigationItem setRightBarButtonItem:self.favoriateBarButton animated:YES];
                [HUDUtil showSuccessText:@"取消收藏成功"];
            } failure:^{
            } networkError:^{
            }];
        }
    }];
}

- (void)onClickBack {
    if (self.presentingViewController) {
        [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    } else {
        [super onClickBack];
    }
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
        [self adjustTopView];
    } failure:^{
    } networkError:^{
        
    }];
}

@end
