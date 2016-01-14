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
#import "UserModel.h"
#import "CommansUtility.h"
#import "BlockOperationWithIdentifier.h"

@interface ProfileViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (nonatomic, strong) NSCache *eventImageCache;
@property (nonatomic, strong) NSOperationQueue *eventImageOperationQueue;


@end

@implementation ProfileViewController{
    UserModel *loggedInUser;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    loggedInUser = [[CommansUtility sharedInstance]loadUserObjectWithKey:@"loggedInUser"];

    self.tabBarController.navigationController.navigationBar.hidden =  YES;
    [self.tableview registerClass:[PPImageScrollingTableViewCell class] forCellReuseIdentifier:@"cellImageScolling"];

    // Do any additional setup after loading the view.
    
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
    
    [self setUpBackButton];
    self.eventImageCache=[[NSCache alloc]init];
    self.eventImageOperationQueue = [[NSOperationQueue alloc]init];
    self.eventImageOperationQueue.maxConcurrentOperationCount = 2;

}

-(void)setUpBackButton{
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *backBtnImage = [UIImage imageNamed:@"backCpy.png"];
    [backBtn setBackgroundImage:backBtnImage forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    backBtn.frame = CGRectMake(0, 0, 25, 25);
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithCustomView:backBtn] ;
    self.navigationItem.leftBarButtonItem = backButton;
}

- (void)backButtonClicked
{
    [self.navigationController popViewControllerAnimated:YES];
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
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OwnProfileCell"];
        
        UIImageView *imgviewProfile = (UIImageView *)[cell viewWithTag:200];
        UILabel *lblProfileName = (UILabel *)[cell viewWithTag:201];
        UILabel *lblProfileStatus = (UILabel *)[cell viewWithTag:202];
        UIButton *btnFriendshipStatus = (UIButton *)[cell viewWithTag:203];
        UIButton *btnChat = (UIButton *)[cell viewWithTag:204];
        UIButton *btnMeetup = (UIButton *)[cell viewWithTag:205];

        [VIewUtility addHexagoneShapeMaskFor:imgviewProfile];
        lblProfileName.text = loggedInUser.strClientUserName;
        lblProfileStatus.text = loggedInUser.strEmailID;
        [btnFriendshipStatus addTarget:self action:@selector(btnFriendshipStatusClicked:) forControlEvents:UIControlEventTouchDown];
        
        
        
        if(loggedInUser.strProfileURLThumb.length==0){
            
        }
        UIImage *imageFromCache = [self.eventImageCache objectForKey:[NSString stringWithFormat:@"%@",loggedInUser.strUserId]];
        if (imageFromCache) {
            imgviewProfile.image=imageFromCache;
        }else{
            
            imgviewProfile.image = nil;//user a placeholder later
            BlockOperationWithIdentifier *operation = [BlockOperationWithIdentifier blockOperationWithBlock:^{
                
                NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:loggedInUser.strProfileURL]];
                
                UIImage *img = [UIImage imageWithData:imageData];
                if (img) {
                    [self.eventImageCache setObject:img forKey:[NSString stringWithFormat:@"%@",loggedInUser.strProfileURL]];
                }
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    imgviewProfile.layer.cornerRadius=3;
                    imgviewProfile.layer.borderColor=[UIColor lightGrayColor].CGColor;
                    imgviewProfile.layer.borderWidth=0.75;
                    imgviewProfile.image = img;
                    
                    CATransition *transition = [CATransition animation];
                    transition.duration = 0.75f;
                    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
                    transition.type = kCATransitionFade;
                    
                    [imgviewProfile.layer addAnimation:transition forKey:nil];
                    imgviewProfile.contentMode=UIViewContentModeScaleAspectFit;
                    imgviewProfile.clipsToBounds = YES;
                }];
            }];
            operation.queuePriority = NSOperationQueuePriorityNormal;
            operation.identifier=loggedInUser.strProfileURL;
            [self.eventImageOperationQueue addOperation:operation];
        }
        
        
        
        return cell;
        
    }
    else if(indexPath.section ==1){
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellSelection"];
        
        return cell;
    }
    else if(indexPath.section ==2){
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellFriendStatus"];
        UILabel *lblProfileName = (UILabel *)[cell viewWithTag:400];
        lblProfileName.text = @"Apple leads the world in innovation with iPhone, iPad, Mac, Apple Watch, iOS, OS X, watchOS and more. Visit the site to learn, buy and get support.";
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
                                   @{ @"name":@"", @"title":@"A-2"},
                                   @{ @"name":@"", @"title":@"A-3"},
                                   @{ @"name":@"", @"title":@"A-4"},
                                   @{ @"name":@"", @"title":@"A-5"}
                                   
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
