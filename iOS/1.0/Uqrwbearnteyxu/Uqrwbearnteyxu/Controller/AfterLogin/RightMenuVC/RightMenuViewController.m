//
//  RightMenuViewController.m
//  SlideMenu
//
//  Created by Aryan Gh on 4/26/14.
//  Copyright (c) 2014 Aryan Ghassemi. All rights reserved.
//

#import "RightMenuViewController.h"
#import "VIewUtility.h"

@implementation RightMenuViewController

#pragma mark - UIViewController Methods -

- (void)viewDidLoad
{
	[super viewDidLoad];
	
    self.tableView.separatorColor = [UIColor lightGrayColor];
}


#pragma mark - UITableView Delegate & Datasrouce -

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return 6;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
	UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 20)];
	view.backgroundColor = [UIColor clearColor];
	return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
	return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell ;
	
	switch (indexPath.row)
	{
        case 0:{
            cell = [tableView dequeueReusableCellWithIdentifier:@"profileCell"];
         
            UIImageView *imgView = (UIImageView *)[cell viewWithTag:100];
            UILabel *lblName = (UILabel *)[cell viewWithTag:101];
            
            [VIewUtility addHexagoneShapeMaskFor:imgView];
            lblName.text = @"Rahul Mane";
            break;
        }
		case 1:
            cell = [tableView dequeueReusableCellWithIdentifier:@"searchCell"];
			break;
			
        case 2:{
            cell = [tableView dequeueReusableCellWithIdentifier:@"menuCell"];
            UIImageView *imgView = (UIImageView *)[cell viewWithTag:300];
            UILabel *lblName = (UILabel *)[cell viewWithTag:301];

            imgView.image = [UIImage imageNamed:@"icon29.png"];
            lblName.text = @"Sports";
            
			break;
        }
        case 3:{
            cell = [tableView dequeueReusableCellWithIdentifier:@"menuCell"];
            UIImageView *imgView = (UIImageView *)[cell viewWithTag:300];
            UILabel *lblName = (UILabel *)[cell viewWithTag:301];
            
            imgView.image = [UIImage imageNamed:@"icon29.png"];
            lblName.text = @"Settings";
            
            break;
        }
			
		case 4:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:@"menuCell"];
            UIImageView *imgView = (UIImageView *)[cell viewWithTag:300];
            UILabel *lblName = (UILabel *)[cell viewWithTag:301];
            
            imgView.image = [UIImage imageNamed:@"icon29.png"];
            lblName.text = @"Statistics";
            
            break;
        }
		case 5:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:@"menuCell"];
            UIImageView *imgView = (UIImageView *)[cell viewWithTag:300];
            UILabel *lblName = (UILabel *)[cell viewWithTag:301];
            
            imgView.image = [UIImage imageNamed:@"icon29.png"];
            lblName.text = @"Help";
            
            break;
        }
    }
	
//	cell.backgroundColor = [UIColor clearColor];
	
	return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    int height = 0;
    switch (indexPath.row)
    {
        case 0:
            height = 64;
            break;
            
        case 1:
            height = 60;
            break;
            
        case 2:
                        height = 50;
            break;
            
        case 3:
            height = 50;
            break;
            
        case 4:
            height = 50;
            break;
            
        case 5:
            height = 50;
            break;
    }

    return height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	id <SlideNavigationContorllerAnimator> revealAnimator;
	CGFloat animationDuration = 0;

    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"MainAppStoryboard"
                                                             bundle: nil];

    UIViewController *vc ;

    
	switch (indexPath.row)
	{
		case 0:
			break;
			
		case 1:
			break;
			
		case 2:
            vc = [mainStoryboard instantiateViewControllerWithIdentifier: @"ProfileViewController"];            
			break;
			
		case 3:
			revealAnimator = [[SlideNavigationContorllerAnimatorSlideAndFade alloc] initWithMaximumFadeAlpha:.8 fadeColor:[UIColor blackColor] andSlideMovement:100];
			animationDuration = .19;
			break;
			
		case 4:
			revealAnimator = [[SlideNavigationContorllerAnimatorScale alloc] init];
			animationDuration = .22;
			break;
			
		case 5:
			revealAnimator = [[SlideNavigationContorllerAnimatorScaleAndFade alloc] initWithMaximumFadeAlpha:.6 fadeColor:[UIColor blackColor] andMinimumScale:.8];
			animationDuration = .22;
			break;
			
		default:
			return;
	}

    [self.delegate rightMenuVC:self didSelectMenu:menuProfile];
    
    /*[[SlideNavigationController sharedInstance] popToRootAndSwitchToViewController:vc
                                                             withSlideOutAnimation:YES
                                                                     andCompletion:nil];
*/
    
    
[[SlideNavigationController sharedInstance] closeMenuWithCompletion:^{
//		[SlideNavigationController sharedInstance].menuRevealAnimationDuration = animationDuration;
//		[SlideNavigationController sharedInstance].menuRevealAnimator = revealAnimator;
	}];
}

@end
