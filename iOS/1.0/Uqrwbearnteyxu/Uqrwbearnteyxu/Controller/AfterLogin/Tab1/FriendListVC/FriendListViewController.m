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
#import "ProfileViewController.h"

#define kServerPagingLimit 10


@interface FriendListViewController ()<UITableViewDataSource,UITableViewDelegate,WebServiceDelegate,UISearchBarDelegate,FriendsSwipeableTableViewCellDelegate>
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

    UITapGestureRecognizer *tapGuesture;
    UISearchBar *searchBarObj;

    NSMutableArray *arrayOfOpenCell;
 
    FriendModel *selectedFriendRequestModel;
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

    UITabBarController *tabBarController = [self tabBarController];
    UITabBar *tabBar = tabBarController.tabBar;
    
    for (UITabBarItem  *tab in tabBar.items) {
        tab.image = [tab.image imageWithRenderingMode: UIImageRenderingModeAlwaysOriginal];
      //  tab.selectedImage = [tab.image imageWithRenderingMode: UIImageRenderingModeAlwaysOriginal];
    }
    
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.navigationController.navigationBar.hidden = YES;
    [self webAPIForFriendList:0 withSearch:searchBarObj.text];

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
    arrayOfOpenCell = [[NSMutableArray alloc]init];
    
    [self setUpSearchBar];
    [self setUpPullUpToLoadMore];
    
}

-(void)setUpSearchBar{
    searchBarObj = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, 100, 30)];
    searchBarObj.delegate = self;
    searchBarObj.placeholder = @"Search friends";
    UIBarButtonItem *searchBarItem = [[UIBarButtonItem alloc] initWithCustomView:searchBarObj];
    self.navigationItem.titleView = searchBarObj;
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

-(void)webAPIForFriendList:(int)tag withSearch:(NSString *)searchText{
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
    [friendService getFriendListOnUserId:loggedInUser.strUserId andPageNo:currentPageNumber andSearchText:searchText];
    [MBProgressHUD showHUDAddedTo:self.tabBarController.view animated:YES];
    
}

-(void)webAPIAcceptFriend:(FriendModel *)fModel{
    friendService = [[FriendsService alloc]init];
    friendService.tag = 2;
    friendService.delegate=self;
    [friendService acceptFriendRequestFromUserId:loggedInUser.strUserId andTo:fModel.strUserID];
    [MBProgressHUD showHUDAddedTo:self.tabBarController.view animated:YES];
}

-(void)webAPIRejectFriend:(FriendModel *)fModel{
    friendService = [[FriendsService alloc]init];
    friendService.tag = 3;
    friendService.delegate=self;
    [friendService rejectFriendRequestFromUserId:loggedInUser.strUserId andTo:fModel.strUserID];
    [MBProgressHUD showHUDAddedTo:self.tabBarController.view animated:YES];
}



- (void)reloadTableViewDataSource{
    
    _reloading = YES;
    
    [self webAPIForFriendList:1 withSearch:searchBarObj.text];
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
        
        [cell makeItSwipable:YES];
        cell.delegate = self;
        cell.tag = indexPath.row;
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
        [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
        [formatter setDateFormat:@"MM/dd/YYYY"];
  
        NSDate *birthDate = [formatter dateFromString:friendModel.strBithdate];
                NSInteger age = [self ageFromBirthday:birthDate];

        [VIewUtility addHexagoneShapeMaskFor:cell.imgViewFriendsProfile];

        cell.lblLastMessage.text  = @"Monday would be great. Can I bring the whole...";
        

        
        NSMutableAttributedString * string = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ (%ld)",friendModel.strClientUserName,(long)age]];
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
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
        [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
        [formatter setDateFormat:@"MM/dd/YYYY"];
        NSDate *birthDate = [formatter dateFromString:friendModel.strBithdate];
        NSInteger age = [self ageFromBirthday:birthDate];

        
        NSMutableAttributedString * string = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ (%ld)",friendModel.strClientUserName,(long)age]];
        [string addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue-Bold" size:14.0] range:NSMakeRange(0, friendModel.strClientUserName.length)];
        
        cell.lblFriendName.attributedText = string;

        cell.lblMutualFriend.text  = [NSString stringWithFormat:@"%@ mutual friends",friendModel.strMutualFriends];
        cell.lblMutualSports.text  = [NSString stringWithFormat:@"%@ mutual sports",friendModel.strMutualSports];

        cell.btnAcceptRequest.tag = indexPath.row;
        [cell.btnAcceptRequest addTarget:self action:@selector(btnAcceptRequestClicked:) forControlEvents:UIControlEventTouchDown];
        
        cell.btnRejectRequest.tag = indexPath.row;
        [cell.btnRejectRequest addTarget:self action:@selector(btnRejectRequestClicked:) forControlEvents:UIControlEventTouchDown];
        
        
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
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    FriendModel *friendModel = [arrayOFData objectAtIndex:indexPath.row];

    ProfileViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier: @"ProfileViewController"];
    vc.friendModel = friendModel;
    
    [self.navigationController pushViewController:vc animated:YES];

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

#pragma mark - Swibale delegates
#pragma mark 

- (void)cellDidOpen:(UITableViewCell *)cell{
    FriendsSwipeableTableViewCell *frSwipable = (FriendsSwipeableTableViewCell *)cell;
    for (int k=0; k<arrayOfOpenCell.count; k++) {
        FriendsSwipeableTableViewCell *tempCell = [arrayOfOpenCell objectAtIndex:k];
        if(tempCell.tag == frSwipable.tag){
            return;
        }
        [tempCell closeCell];
    }
    [arrayOfOpenCell removeAllObjects];
    [arrayOfOpenCell addObject:frSwipable];
    
}


- (void)cellDidClose:(UITableViewCell *)cell{
    
}

#pragma mark - Search Bar

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if ([searchText length] == 0) {
        [self performSelector:@selector(hideKeyboardWithSearchBar:) withObject:searchBar afterDelay:0];
    }
}

- (void)hideKeyboardWithSearchBar:(UISearchBar *)searchBar{
   // [self webAPIForFriendList:0 andTextToSearch:searchBar.text];
    
    [self webAPIForFriendList:0 withSearch:searchBarObj.text];
    [searchBar resignFirstResponder];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    if(searchBar.text.length){
       // [self webAPIForFriendList:0 andTextToSearch:searchBar.text];
        [self webAPIForFriendList:0 withSearch:searchBarObj.text];
    }
    
    [searchBar resignFirstResponder];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    [self addTapGuesture];
}

-(void)addTapGuesture{
    tapGuesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGuestureFired:)];
    [self.navigationController.view addGestureRecognizer:tapGuesture];
    
}

-(void)tapGuestureFired:(UITapGestureRecognizer *)tap{
    [self.navigationController.view removeGestureRecognizer:tapGuesture];
    [searchBarObj resignFirstResponder];
    
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

-(void)btnAcceptRequestClicked:(id)sender{
    UIButton *btn = (UIButton *)sender;
    FriendModel *frModel = [arrayOFData objectAtIndex:btn.tag];
    if(frModel.isRequestFriend){
        NSLog(@"Accept friedns");
        [self webAPIAcceptFriend:frModel];
    }
}

-(void)btnRejectRequestClicked:(id)sender{
    UIButton *btn = (UIButton *)sender;
    FriendModel *frModel = [arrayOFData objectAtIndex:btn.tag];

    if(frModel.isRequestFriend){
        NSLog(@"Reject friedns");
        selectedFriendRequestModel = frModel;
        [self alerForRejectFriend];
    }
    
}

- (void)alerForRejectFriend {
    // open a alert with an OK and cancel button
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"REJECT FRIEND REQUEST?" message:@"DO YOU REALLY WANT TO REJECT FRIEND REQUEST?" delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil];
    alert.tag = 1;
    [alert show];
}

- (void)alertView:(UIAlertView *)alert clickedButtonAtIndex:(NSInteger)buttonIndex
{
    // the user clicked one of the OK/Cancel buttons
    if(alert.tag == 1)
    {
        if(buttonIndex == alert.cancelButtonIndex)
        {
            NSLog(@"cancel");
        }
        else
        {
            if(selectedFriendRequestModel.isRequestFriend){
                    [self webAPIRejectFriend:selectedFriendRequestModel];
            }
            else{
                [[[UIAlertView alloc]initWithTitle:@"ERROR" message:@"Oops something went wrong.. This should not happen" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil]show];
                
            }
        }
    }
    else if (alert.tag==2){
        if(buttonIndex != alert.cancelButtonIndex){
            
        }
    }
}



#pragma mark - Web service response
#pragma mark

- (void)request:(id)serviceRequest didFailWithError:(NSError *)error{
    [MBProgressHUD hideHUDForView:self.tabBarController.view animated:YES];
    [[[UIAlertView alloc]initWithTitle:@"Error" message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil]show];
}

- (void)request:(id)serviceRequest didSucceedWithArray:(NSMutableArray *)responseData{
    [MBProgressHUD hideHUDForView:self.tabBarController.view animated:YES];
        FriendsService *service=(FriendsService *)serviceRequest;
        if(service.tag==0){
            int friendRequestCounter = 0;
            if(responseData.count>0){
                for(int k=0;k<responseData.count;k++){
                    id model=[responseData objectAtIndex:k];
                    if([model isKindOfClass:[FriendModel class]]){
                        FriendModel *frModel =(FriendModel *)model;
                        if(frModel.isRequestFriend){
                            friendRequestCounter++;
                        }
                        [arrayOFData addObject:frModel];
                    }
                }
            }
            [self.tableview reloadData];
            if(friendRequestCounter>0){
                [[self.tabBarController.tabBar.items objectAtIndex:0] setBadgeValue:[NSString stringWithFormat:@"%d",friendRequestCounter]];
            }
            else{
                [[self.tabBarController.tabBar.items objectAtIndex:0] setBadgeValue:nil];
            }
        }
        else if(service.tag==1){
            int friendRequestCounter = 0;

            if(responseData.count>0){

                for(int k=0;k<responseData.count;k++){
                    
                    id model=[responseData objectAtIndex:k];
                    if([model isKindOfClass:[FriendModel class]]){
                        FriendModel *frModel =(FriendModel *)model;
                        if(frModel.isRequestFriend){
                            friendRequestCounter++;
                        }

                        [arrayOFData addObject:(FriendModel *)model];
                    }
                }
                
            }
            _reloading = NO;
            [refreshHeaderView tableViewPullViewScrollViewDataSourceDidFinishedLoading:self.tableview];
            [self.tableview reloadData];
            
            if(friendRequestCounter>0){
                [[self.tabBarController.tabBar.items objectAtIndex:0] setBadgeValue:[NSString stringWithFormat:@"%d",friendRequestCounter]];
            }
            else{
                [[self.tabBarController.tabBar.items objectAtIndex:0] setBadgeValue:nil];
            }

        }
        else if(service.tag==2){
            [self webAPIForFriendList:0 withSearch:searchBarObj.text];

        }
        else if(service.tag==3){
            [self webAPIForFriendList:0 withSearch:searchBarObj.text];

        }
    
}
- (NSInteger)ageFromBirthday:(NSDate *)birthdate {
    NSDate *today = [NSDate date];
    NSDateComponents *ageComponents = [[NSCalendar currentCalendar]
                                       components:NSYearCalendarUnit
                                       fromDate:birthdate
                                       toDate:today
                                       options:0];
    return ageComponents.year;
}


@end
