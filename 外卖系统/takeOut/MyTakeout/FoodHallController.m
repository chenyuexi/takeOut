//
//  FoodHallController.m
//  takeOut
//
//  Created by Yuexi on 2017/6/14.
//  Copyright © 2017年 Yuexi. All rights reserved.
//

#import "FoodHallController.h"
#import "LinkageMenuView.h"
#import "FoodListView.h"
#import "Store.h"
#import "OHMySQL.h"
#import "Menu.h"
#import "ShoppingCart.h"
#import "SearchView.h"
#import "SYTipView.h"
#import "ShoppingCartObj.h"
#define FUll_VIEW_WIDTH  ([[UIScreen mainScreen] bounds].size.width)
#define FUll_VIEW_HEIGHT  ([[UIScreen mainScreen] bounds].size.height)
#define NAVIGATION_HEIGHT 64  //navigationbar height
#define TABBAR_HEIGHT 49  //tabbar height

@interface FoodHallController ()<UISearchBarDelegate>

@property(nonatomic,strong) UISearchBar *searchBar;
@property(nonatomic,strong) UIButton *searchBtn;

@property (strong, nonatomic)  NSMutableArray *storeArr;
@property (strong, nonatomic)  OHMySQLManager *manager;
@property (strong, nonatomic)  OHMySQLUser *sqlUser;

@property (strong, nonatomic)  NSMutableArray *allArr;

@property (strong, nonatomic)  SearchView *searchView;

@end

@implementation FoodHallController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    
    //链接数据库
    self.sqlUser = [[OHMySQLUser alloc]initWithUserName:@"root" password:@"3306" serverName:@"127.0.0.1" dbName:@"takeOut" port:3306 socket:nil];
    self.manager = [OHMySQLManager sharedManager];
    [self.manager connectWithUser:self.sqlUser];
    
    NSMutableArray *mViews = [NSMutableArray array];
    for (int i = 0; i < self.storeArr.count; i++) {
        FoodListView *foodListView = [[FoodListView alloc] initWithFrame:CGRectMake(0, 0, FUll_VIEW_WIDTH - 101, FUll_VIEW_HEIGHT - TABBAR_HEIGHT - NAVIGATION_HEIGHT) style:UITableViewStylePlain];
        foodListView.listTag = i;
        [mViews addObject:foodListView];
    }
    

    
    //if views count less than menu count, leftover views will load the last view of the views
    //如果view数量少于标题数量，剩下的view会默认加载view数组的最后一个view
    LinkageMenuView *lkMenu = [[LinkageMenuView alloc] initWithFrame:CGRectMake(0, 0,FUll_VIEW_WIDTH , FUll_VIEW_HEIGHT - TABBAR_HEIGHT) WithMenu:self.storeArr andViews:mViews];
    [self.view addSubview:lkMenu];
    
    
    UIView *tilView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, FUll_VIEW_WIDTH, 44)];
    _searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(FUll_VIEW_WIDTH / 2 - 100, 10, 160, 24)];
    _searchBar.placeholder = @"搜索外卖";
    _searchBar.delegate = self;
    [tilView addSubview:_searchBar];
    
    
    _searchBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    _searchBtn.frame = CGRectMake(_searchBar.frame.origin.x + _searchBar.frame.size.width + 10, 8, 60, 28);
    [_searchBtn setTitle:@"搜索" forState:UIControlStateNormal];
//    [_searchBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    _searchBtn.layer.borderColor = [UIColor grayColor].CGColor;
//    _searchBtn.layer.borderWidth = 1;
//    _searchBtn.layer.cornerRadius = 4;
    [_searchBtn addTarget:self action:@selector(searchTarget) forControlEvents:UIControlEventTouchUpInside];
    [tilView addSubview:_searchBtn];
    self.navigationItem.titleView = tilView;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(searchBarRegi)];
    [tilView addGestureRecognizer:tap];
    

}

- (void)searchBarRegi{
    
    [self.searchBar resignFirstResponder];

}



- (void)searchTarget{
    
    if (self.searchBar.text.length == 0) {
        [[SYTipView shareInstance] showErrorTipWithText:@"请输入要搜索的外卖"];
    }else{
        OHMySQLQuery *query = [[OHMySQLQuery alloc]initWithUser:self.sqlUser queryString:[NSString stringWithFormat:@"select * from menu where food_id = '%@'",self.searchBar.text]];
        NSArray *arr = [self.manager executeSELECTQuery:query];
        if (arr.count == 0) {
            [[SYTipView shareInstance] showErrorTipWithText:@"搜索不要您想要的外卖"];
        }else{
            [_searchBar resignFirstResponder];
            NSMutableArray *mArr = [NSMutableArray array];
            SearchView *sv = [[SearchView alloc] initWithFrame:CGRectMake(0, NAVIGATION_HEIGHT,FUll_VIEW_WIDTH , FUll_VIEW_HEIGHT - TABBAR_HEIGHT)];
            for (int i = 0; i < arr.count; i++) {
                Menu *menu = [[Menu alloc] init];
                [menu setValuesForKeysWithDictionary:arr[i]];
                ShoppingCartObj *cartObj = [[ShoppingCartObj alloc] init];
                cartObj.store_id = menu.store_id;
                cartObj.food_name = menu.food_id;
                cartObj.price = menu.price;
                for (int j = 0; j < self.allArr.count; j++) {
                    Store *store = self.allArr[j];
                    if (menu.store_id == store.store_id) {
                        cartObj.store_name = store.store_name;
                        break;
                    }
                }
                [mArr addObject:cartObj];
            }
            sv.menuArr = mArr;
            [self.searchView removeFromSuperview];
            self.searchView = sv;
            [self.view addSubview:self.searchView];
            NSLog(@"%@",self.searchView.menuArr);
        }
    }

    
}



- (NSMutableArray *)storeArr{
    if (!_storeArr) {
        NSMutableArray *mArr = [NSMutableArray array];
        OHMySQLQuery *query = [[OHMySQLQuery alloc]initWithUser:self.sqlUser queryString:@"select * from store"];
        NSArray *arr = [self.manager executeSELECTQuery:query];
        
        for (int i = 0; i < arr.count; i ++) {
            Store *store = [[Store alloc] init];
            [store setValuesForKeysWithDictionary:arr[i]];
            NSString *stoName = store.store_name;
            [mArr addObject:stoName];
        }
        _storeArr = mArr;
        
    }
    return _storeArr;
}


- (NSMutableArray *)allArr{
    if (!_allArr) {
        NSMutableArray *mArr = [NSMutableArray array];
        OHMySQLQuery *query = [[OHMySQLQuery alloc]initWithUser:self.sqlUser queryString:@"select * from store"];
        NSArray *arr = [self.manager executeSELECTQuery:query];
        for (int i = 0; i < arr.count; i ++) {
            Store *store = [[Store alloc] init];
            [store setValuesForKeysWithDictionary:arr[i]];
            [mArr addObject:store];
        }
        _allArr = mArr;
        
    }
    return _allArr;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
