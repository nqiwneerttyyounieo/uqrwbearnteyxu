//
//  ProfileViewController.m
//  Uqrwbearnteyxu
//
//  Created by Developer on 03/01/16.
//  Copyright © 2016 Rahul N. Mane. All rights reserved.
//

#import "ProfileViewController.h"
#import "SlideNavigationController.h"
#import "VIewUtility.h"
#import "PPImageScrollingTableViewCell.h"

@interface ProfileViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableview;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabBarController.navigationController.navigationBar.hidden =  YES;
    [self.tableview registerClass:[PPImageScrollingTableViewCell class] forCellReuseIdentifier:@"cellImageScolling"];

    // Do any additional setup after loading the view.
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.tabBarController.navigationController.navigationBar.hidden =  NO;
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

#pragma mark - Tableview delegates
#pragma mark 

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 7;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"friendsProfileCell"];
        
        UIImageView *imgviewProfile = (UIImageView *)[cell viewWithTag:100];
        UILabel *lblProfileName = (UILabel *)[cell viewWithTag:101];
        UILabel *lblProfileStatus = (UILabel *)[cell viewWithTag:102];
        UIButton *btnFriendshipStatus = (UIButton *)[cell viewWithTag:103];
        UIButton *btnChat = (UIButton *)[cell viewWithTag:104];
        UIButton *btnMeetup = (UIButton *)[cell viewWithTag:105];

        [VIewUtility addHexagoneShapeMaskFor:imgviewProfile];
        lblProfileName.text = @"Rahul Mane";
        lblProfileStatus.text = @"Yoo yoo I am swimmer";
        [btnFriendshipStatus addTarget:self action:@selector(btnFriendshipStatusClicked:) forControlEvents:UIControlEventTouchDown];
        
        
        return cell;
        
    }
    else if(indexPath.section ==1){
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellSelection"];
        
        return cell;
    }
    else if(indexPath.section ==2){
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellFriendStatus"];
        UILabel *lblProfileName = (UILabel *)[cell viewWithTag:400];
        lblProfileName.text = @"Rahul a das dadjasds adas ndajsndjas dasjd asjd jasdnasd Rahudalmd asdsa das dsad jasd jasda dd as dsad asd as a?d asdas das?";
        lblProfileName.preferredMaxLayoutWidth = 250;
        return cell;
        
    }
    else if(indexPath.section ==3){
        NSArray *array = @[
                        @{ @"category": @"Your sports (25)",
                           @"images":
                               @[
                                   @{ @"name":@"icon29.png", @"title":@"A-0"},
                                   @{ @"name":@"icon29.png", @"title":@"A-1"},
                                   @{ @"name":@"icon29.png", @"title":@"A-2"},
                                   @{ @"name":@"icon29.png", @"title":@"A-3"},
                                   @{ @"name":@"icon29.png", @"title":@"A-4"},
                                   @{ @"name":@"icon29.png", @"title":@"A-5"}
                                   
                                   ]
                           }
                        ];

        
        PPImageScrollingTableViewCell *customCell = [tableView dequeueReusableCellWithIdentifier:@"cellImageScolling" forIndexPath:indexPath];
        [customCell setBackgroundColor:[UIColor clearColor]];
        [customCell setDelegate:self];
        [customCell setTag:[indexPath section]];
        [customCell setImageData:[array objectAtIndex:0]];
       // [customCell setImageTitleTextColor:[UIColor whiteColor] withBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.7]];
       // [customCell setImageTitleLabelWitdh:90 withHeight:45];
        [customCell setCollectionViewBackgroundColor:[UIColor clearColor]];
        
        return customCell;
    }
    else if(indexPath.section ==4){
        NSArray *array = @[
                           @{ @"category": @"Your sports (25)",
                              @"images":
                                  @[
                                      @{ @"name":@"icon29.png", @"title":@"A-0"},
                                      @{ @"name":@"icon29.png", @"title":@"A-1"},
                                      @{ @"name":@"icon29.png", @"title":@"A-2"},
                                      @{ @"name":@"icon29.png", @"title":@"A-3"},
                                      @{ @"name":@"icon29.png", @"title":@"A-4"},
                                      @{ @"name":@"icon29.png", @"title":@"A-5"}
                                      
                                      ]
                              }
                           ];
        
        
        PPImageScrollingTableViewCell *customCell = [tableView dequeueReusableCellWithIdentifier:@"cellImageScolling" forIndexPath:indexPath];
        [customCell setBackgroundColor:[UIColor clearColor]];
        [customCell setDelegate:self];
        [customCell setTag:[indexPath section]];
        [customCell setImageData:[array objectAtIndex:0]];
        // [customCell setImageTitleTextColor:[UIColor whiteColor] withBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.7]];
        // [customCell setImageTitleLabelWitdh:90 withHeight:45];
        [customCell setCollectionViewBackgroundColor:[UIColor clearColor]];
        
        return customCell;
    }
    else if(indexPath.section ==5){
        NSArray *array = @[
                           @{ @"category": @"Your sports (25)",
                              @"images":
                                  @[
                                      @{ @"name":@"icon29.png", @"title":@"A-0"},
                                      @{ @"name":@"icon29.png", @"title":@"A-1"},
                                      @{ @"name":@"icon29.png", @"title":@"A-2"},
                                      @{ @"name":@"icon29.png", @"title":@"A-3"},
                                      @{ @"name":@"icon29.png", @"title":@"A-4"},
                                      @{ @"name":@"icon29.png", @"title":@"A-5"}
                                      
                                      ]
                              }
                           ];
        
        
        PPImageScrollingTableViewCell *customCell = [tableView dequeueReusableCellWithIdentifier:@"cellImageScolling" forIndexPath:indexPath];
        [customCell setBackgroundColor:[UIColor clearColor]];
        [customCell setDelegate:self];
        [customCell setTag:[indexPath section]];
        [customCell setImageData:[array objectAtIndex:0]];
        // [customCell setImageTitleTextColor:[UIColor whiteColor] withBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.7]];
        // [customCell setImageTitleLabelWitdh:90 withHeight:45];
        [customCell setCollectionViewBackgroundColor:[UIColor clearColor]];
        
        return customCell;
    }
    else if(indexPath.section ==6){
        NSArray *array = @[
                           @{ @"category": @"Your sports (25)",
                              @"images":
                                  @[
                                      @{ @"name":@"icon29.png", @"title":@"A-0"},
                                      @{ @"name":@"icon29.png", @"title":@"A-1"},
                                      @{ @"name":@"icon29.png", @"title":@"A-2"},
                                      @{ @"name":@"icon29.png", @"title":@"A-3"},
                                      @{ @"name":@"icon29.png", @"title":@"A-4"},
                                      @{ @"name":@"icon29.png", @"title":@"A-5"},
                                      @{ @"name":@"icon29.png", @"title":@"A-5"},
                                      @{ @"name":@"icon29.png", @"title":@"A-5"},
                                      @{ @"name":@"icon29.png", @"title":@"A-5"},
                                      @{ @"name":@"icon29.png", @"title":@"A-5"},
                                      @{ @"name":@"icon29.png", @"title":@"A-5"}
                                      
                                      ]
                              }
                           ];
        
        
        PPImageScrollingTableViewCell *customCell = [tableView dequeueReusableCellWithIdentifier:@"cellImageScolling" forIndexPath:indexPath];
        [customCell setBackgroundColor:[UIColor clearColor]];
        [customCell setDelegate:self];
        [customCell setTag:[indexPath section]];
        [customCell setImageData:[array objectAtIndex:0]];
        // [customCell setImageTitleTextColor:[UIColor whiteColor] withBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.7]];
        // [customCell setImageTitleLabelWitdh:90 withHeight:45];
        [customCell setCollectionViewBackgroundColor:[UIColor clearColor]];
        
        return customCell;
    }
    else{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellFriendStatus"];

        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
        return 100;
    }
    else if(indexPath.section == 1){
        return 40;
    }
    else if(indexPath.section == 2){
        return 50;
    }
    else if(indexPath.section == 3){
        return 50;
    }
    else if(indexPath.section == 4){
        return 50;
    }
    else if(indexPath.section == 5){
        return 50;
    }

    else if(indexPath.section == 6){
        return 50;
    }
    return 0;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    
    UILabel *lbl = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 250, 20)];
    lbl.textColor = [UIColor whiteColor];
    lbl.font = [UIFont systemFontOfSize:14];
    
    [view addSubview:lbl];
    
    if(section == 3){
        lbl.text = @"Your sports (25)";
    }
    else if(section == 4){
        lbl.text = @"Your friends (235)";
    }
    else if(section == 5){
        lbl.text = @"Your 1:1 meetups (23)";
    }
    
    else if(section == 6){
        lbl.text = @"Your upcoming meetups (12)";

    }
    
    return view;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]init];
    
    if(section == 0){
        view.backgroundColor = [UIColor clearColor];
    }
    else if(section ==1){
        view.backgroundColor = [UIColor clearColor];
    }
    else if(section ==2){
        view.backgroundColor = [UIColor clearColor];
    }
    else if(section ==3){
        view.backgroundColor = [UIColor lightGrayColor];
    }
    else if(section ==4){
        view.backgroundColor = [UIColor lightGrayColor];
    }
    else if(section ==5){
        view.backgroundColor = [UIColor lightGrayColor];
    }
    else if(section ==6){
        view.backgroundColor = [UIColor lightGrayColor];
    }
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if(section == 0){
        return 2;
    }
    else if(section ==1){
        return 2;
    }
    else if(section ==2){
        return 2;
    }
    else if(section ==3){
        return 2;
    }
    else if(section ==4){
        return 2;
    }
    else if(section ==5){
        return 2;
    }
    else if(section ==6){
        return 2;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section == 0){
        return 0;
    }
    else if(section ==1){
        return 0;
    }
    else if(section ==2){
        return 0;
    }
    else if(section ==3){
        return 20;
    }
    else if(section ==4){
        return 20;
    }
    else if(section ==5){
        return 20;
    }
    else if(section ==6){
        return 20;
    }
    return 0;
}


#pragma mark - Button delegates
#pragma mark 

-(void)btnFriendshipStatusClicked:(id)sender{
    NSLog(@"Friednship clicked");
    
}

- (IBAction)btnMenuClicked:(id)sender {
    [[SlideNavigationController sharedInstance] openMenu:MenuRight withCompletion:^{
        
    }];
    
}

#pragma mark - PPImageScrollingTableViewCellDelegate

- (void)scrollingTableViewCell:(PPImageScrollingTableViewCell *)scrollingTableViewCell didSelectImageAtIndexPath:(NSIndexPath*)indexPathOfImage atCategoryRowIndex:(NSInteger)categoryRowIndex{
    
}

@end
