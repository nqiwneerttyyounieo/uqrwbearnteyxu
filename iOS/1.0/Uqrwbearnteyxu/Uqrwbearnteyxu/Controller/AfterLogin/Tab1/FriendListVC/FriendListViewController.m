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
#import "FriendsService.h"
#import "UserModel.h"
#import "CommansUtility.h"
#import "MBProgressHUD.h"
#import "FriendModel.h"
#import "BlockOperationWithIdentifier.h"
#import "TableViewPullView.h"

#define kServerPagingLimit 10


@interface FriendListViewController ()<UITableViewDataSource,UITableViewDelegate,WebServiceDelegate>
@property(nonatomic,weak)IBOutlet UITableView *tableview;
@property (nonatomic, strong) NSCache *eventImageCache;
@property (nonatomic, strong) NSOperationQueue *eventImageOperationQueue;

@end

@implementation FriendListViewController{
    FriendsService *friendService;
    UserModel *loggedInUser;
    NSMutableArray *arrayOFData;
    TableViewPullView *refreshHeaderView;
    BOOL _reloading;
    int currentPageNumber;
    int previousPageEventCount;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUp];
    self.eventImageCache=[[NSCache alloc]init];
    self.eventImageOperationQueue = [[NSOperationQueue alloc]init];
    self.eventImageOperationQueue.maxConcurrentOperationCount = 2;

    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }

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
    [self setUpPullUpToLoadMore];
    [self webAPIForFriendList:0];
    
}

-(void)setUpSearchBar{
    UISearchBar *searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, 100, 30)];
    searchBar.delegate = self;
    
    UIBarButtonItem *searchBarItem = [[UIBarButtonItem alloc] initWithCustomView:searchBar];
    self.navigationItem.titleView = searchBar;
}

-(void)setUpPullUpToLoadMore{
    if (refreshHeaderView == nil) {
        
        refreshHeaderView = [[TableViewPullView alloc] initWithFrame:CGRectMake(0, self.tableview.frame.size.height, 320, 50)];
        refreshHeaderView.delegate = self;
        //[self.tableview addSubview:refreshHeaderView];
        
        [self.tableview setTableFooterView:refreshHeaderView];
        [self.tableview.tableFooterView setHidden:YES];
        
    }
    //  update the last update date
    [refreshHeaderView refreshLastUpdatedDate];
    
}

#pragma mark - Call web service
#pragma mark

-(void)webAPIForFriendList:(int)tag{
    if(tag==0){  // that means we are loading events freshly
        previousPageEventCount=0;
        currentPageNumber=0;
        [arrayOFData removeAllObjects];
        arrayOFData=[[NSMutableArray alloc]init];
    }
    else{ // that means we are loading more events
        currentPageNumber++;
        previousPageEventCount=(int)arrayOFData.count;
    }

    loggedInUser = [[CommansUtility sharedInstance]loadUserObjectWithKey:@"loggedInUser"];

    
    friendService = [[FriendsService alloc]init];
    friendService.delegate=self;
    friendService.tag = tag;
    [friendService getFriendListOnUserId:loggedInUser.strUserId andPageNo:currentPageNumber];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
}

- (void)reloadTableViewDataSource{
    
    _reloading = YES;
    
    [self webAPIForFriendList:1];
}



#pragma mark - Tableview delegates
#pragma mark 

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(arrayOFData.count>=kServerPagingLimit && arrayOFData.count>previousPageEventCount){
        // that means there are no more events available.
        // we need to hide load more view
        [self.tableview.tableFooterView setHidden:NO];
    }
    else{
        [self.tableview.tableFooterView setHidden:YES];
    }

    return arrayOFData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FriendModel *friendModel = [arrayOFData objectAtIndex:indexPath.row];
    
    if(!friendModel.isRequestFriend){
        FriendsSwipeableTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"friendsSwipableCell"];
        
        [VIewUtility addHexagoneShapeMaskFor:cell.imgViewFriendsProfile];
        
        cell.lblLastMessage.text  = @"";
        
        NSMutableAttributedString * string = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ (%@)",friendModel.strClientUserName,friendModel.strMutualFriends]];
        [string addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue-Bold" size:14.0] range:NSMakeRange(0, friendModel.strClientUserName.length)];

        cell.lblFriendName.attributedText = string;
        
        
        
        CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake(0, 48, self.view.frame.size.width, 2);
        layer.backgroundColor = [UIColor colorWithRed:63.0/255.0 green:84.0/255.0 blue:90.0/255.0 alpha:1].CGColor;
        [cell.layer addSublayer:layer];
        
        
        UIImage *imageFromCache = [self.eventImageCache objectForKey:[NSString stringWithFormat:@"%@",friendModel.strUserID]];
        if (imageFromCache) {
            cell.imgViewFriendsProfile.image=imageFromCache;
        }else{
            
            cell.imgViewFriendsProfile.image = nil;//user a placeholder later
            BlockOperationWithIdentifier *operation = [BlockOperationWithIdentifier blockOperationWithBlock:^{
                
                NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:friendModel.strThumbImgPath]];
                
                UIImage *img = [UIImage imageWithData:imageData];
                if (img) {
                    [self.eventImageCache setObject:img forKey:[NSString stringWithFormat:@"%@",friendModel.strUserID]];
                }
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    FriendsSwipeableTableViewCell *updateCell =(FriendsSwipeableTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
                    if (updateCell) {
                        
                        
                        updateCell.imgViewFriendsProfile.layer.cornerRadius=3;
                        updateCell.imgViewFriendsProfile.layer.borderColor=[UIColor lightGrayColor].CGColor;
                        updateCell.imgViewFriendsProfile.layer.borderWidth=0.75;
                        updateCell.imgViewFriendsProfile.image = img;
                        
                        CATransition *transition = [CATransition animation];
                        transition.duration = 0.75f;
                        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
                        transition.type = kCATransitionFade;
                        
                        [updateCell.imgViewFriendsProfile.layer addAnimation:transition forKey:nil];
                        updateCell.imgViewFriendsProfile.clipsToBounds = YES;
                        
                    }
                }];
            }];
            operation.queuePriority = NSOperationQueuePriorityNormal;
            operation.identifier=friendModel.strThumbImgPath;
            [self.eventImageOperationQueue addOperation:operation];
        }

        
        

        
        return cell;
    }
    else{
        FriendsRequestSwipeableTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"friendsRequestSwipableCell"];
        [VIewUtility addHexagoneShapeMaskFor:cell.imgViewFriendsProfile];
        cell.lblFriendName.text = friendModel.strUserName;
        cell.lblMutualFriend.text  = [NSString stringWithFormat:@"%@ mutual friends",friendModel.strMutualFriends];
        cell.lblMutualSports.text  = [NSString stringWithFormat:@"%@ mutual friends",friendModel.strMutualSports];
        
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

#pragma mark - Tableview Scroll view Delegate.
#pragma mark -

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if(arrayOFData.count>=kServerPagingLimit  && !self.tableview.tableFooterView.hidden){
        [refreshHeaderView tableViewPullViewScrollViewDidScroll:scrollView];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    if(arrayOFData.count>=kServerPagingLimit  && !self.tableview.tableFooterView.hidden){
        [refreshHeaderView tableViewPullViewScrollViewDidEndDragging:scrollView];
    }
    if(!decelerate)
    {
    }
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
}


#pragma mark - Handling Load more for table view.
#pragma mark -
- (void)TableViewPullDidTriggerRefresh:(TableViewPullView *)view{
    //NSLog(@"Loaded......");
    [self reloadTableViewDataSource];
    //[self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:3.0];
    
}

- (BOOL)TableViewPullDataSourceIsLoading:(TableViewPullView *)view{
    return _reloading; // should return if data source model is reloading
    
}

- (NSDate*)TableViewPullDataSourceLastUpdated:(TableViewPullView *)view{
    
    return [NSDate date]; // should return date data source was last changed
    
}


#pragma mark - Button delegates
#pragma mark 

-(IBAction)btnMenuClicked:(id)sender{
    [[SlideNavigationController sharedInstance] openMenu:MenuRight withCompletion:^{
        
    }];
}

#pragma mark - Web service response
#pragma mark

- (void)request:(id)serviceRequest didFailWithError:(NSError *)error{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
}
- (void)request:(id)serviceRequest didSucceedWithArray:(NSMutableArray *)responseData{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    
        FriendsService *service=(FriendsService *)serviceRequest;
        if(service.tag==0){
            if(responseData.count>0){
                for(int k=0;k<responseData.count;k++){
                    id model=[responseData objectAtIndex:k];
                    if([model isKindOfClass:[FriendModel class]]){
                        [arrayOFData addObject:(FriendModel *)model];
                    }
                }
            }
            [self.tableview reloadData];
            
        }
        else if(service.tag==1){
            if(responseData.count>0){
                for(int k=0;k<responseData.count;k++){
                    
                    id model=[responseData objectAtIndex:k];
                    if([model isKindOfClass:[FriendModel class]]){
                        [arrayOFData addObject:(FriendModel *)model];
                    }
                }
                
            }
            _reloading = NO;
            [refreshHeaderView tableViewPullViewScrollViewDataSourceDidFinishedLoading:self.tableview];
            [self.tableview reloadData];
        }
}


@end
