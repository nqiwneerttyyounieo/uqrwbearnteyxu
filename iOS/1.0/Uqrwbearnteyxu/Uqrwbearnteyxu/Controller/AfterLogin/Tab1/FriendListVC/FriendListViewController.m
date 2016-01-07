//
//  FriendListViewController.m
//  Uqrwbearnteyxu
//
//  Created by Developer on 05/01/16.
//  Copyright © 2016 Rahul N. Mane. All rights reserved.
//

#import "FriendListViewController.h"
#import "SlideNavigationController.h"
#import "FriendsRequestSwipeableTableViewCell.h"
#import "FriendsSwipeableTableViewCell.h"
#import "VIewUtility.h"

@interface FriendListViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation FriendListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUp];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.navigationController.navigationBar.hidden = YES;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.tabBarController.navigationController.navigationBar.hidden = NO;
    
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

#pragma mark - SetUp
#pragma mark

-(void)setUp{
    [self setUpSearchBar];
}

-(void)setUpSearchBar{
    UISearchBar *searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, 100, 30)];
    searchBar.delegate = self;
    
    UIBarButtonItem *searchBarItem = [[UIBarButtonItem alloc] initWithCustomView:searchBar];
    self.navigationItem.titleView = searchBar;
}

#pragma mark - Tableview delegates
#pragma mark 

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row%2 == 0){
        FriendsSwipeableTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"friendsSwipableCell"];
        
        [VIewUtility addHexagoneShapeMaskFor:cell.imgViewFriendsProfile];
        cell.lblFriendName.text = @"Frank's Further";
        cell.lblLastMessage.text  = @"This was last message from this user";
        
        CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake(0, 48, self.view.frame.size.width, 2);
        layer.backgroundColor = [UIColor colorWithRed:63.0/255.0 green:84.0/255.0 blue:90.0/255.0 alpha:1].CGColor;
        [cell.layer addSublayer:layer];
        
        
        return cell;
    }
    else{
        FriendsRequestSwipeableTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"friendsRequestSwipableCell"];
        [VIewUtility addHexagoneShapeMaskFor:cell.imgViewFriendsProfile];
        cell.lblFriendName.text = @"Frank's Further";
        cell.lblMutualFriend.text  = @"5 Mutual Friends";
        cell.lblMutualSports.text  = @"25 Mutual Sports";
        
        CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake(0, 48, self.view.frame.size.width, 2);
        layer.backgroundColor = [UIColor colorWithRed:63.0/255.0 green:84.0/255.0 blue:90.0/255.0 alpha:1].CGColor;
        [cell.layer addSublayer:layer];

        
        return cell;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}


#pragma mark - Button delegates
#pragma mark 

-(IBAction)btnMenuClicked:(id)sender{
    [[SlideNavigationController sharedInstance] openMenu:MenuRight withCompletion:^{
        
    }];
}

@end
