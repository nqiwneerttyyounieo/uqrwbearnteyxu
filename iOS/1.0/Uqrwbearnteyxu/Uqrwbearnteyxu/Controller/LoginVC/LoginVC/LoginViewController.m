//
//  LoginViewController.m
//  Uqrwbearnteyxu
//
//  Created by Rahul N. Mane on 06/12/15.
//  Copyright © 2015 Rahul N. Mane. All rights reserved.
//

#import "LoginViewController.h"
#import "VIewUtility.h"
#import "TextFieldValidator.h"
#import "HUD.h"
#import "UserWebServiceClient.h"
#import "WebServiceFramework.h"
#import "Constants.h"
#import "CommansUtility.h"


#define REGEX_EMAIL @"[A-Z0-9a-z._%+-]{3,}+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"


@interface LoginViewController ()<UIAlertViewDelegate>

@property (strong, nonatomic) IBOutlet UIButton *btnGo;
@property (strong, nonatomic) IBOutlet UIView *viewBtnContainer;
@property (strong, nonatomic) IBOutlet TextFieldValidator *txtEmail;
@property (strong, nonatomic) IBOutlet TextFieldValidator *txtPassword;

@end

@implementation LoginViewController{
    UITapGestureRecognizer *tapGuesture;
    UITextField *activeTextfield;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUp];
    self.txtEmail.text = @"rahul44@gmail.com";
    self.txtPassword.text = @"Rahul@123";
    
    // Do any additional setup after loading the view.
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
    [self setUpButtons];
    [self setUptextFields];
}

-(void)setUpButtons{
    [VIewUtility addHexagoneShapeMaskFor:self.btnGo];
    [VIewUtility addHexagoneShapeMaskFor:self.viewBtnContainer];

}

-(void)setUptextFields{
    [self setupAlerts];

    [self addBottomBorder:self.txtEmail];
    [self addBottomBorder:self.txtPassword];

    [self leftPanelView:self.txtPassword withImage:[UIImage imageNamed:@"password.png"]];
    [self leftPanelView:self.txtEmail withImage:[UIImage imageNamed:@"person-icon.png"]];
}
-(void)addBottomBorder:(UIView *)view{
    CALayer *layer=[[CALayer alloc]init];
    layer.frame=CGRectMake(0, view.frame.size.height-1, view.frame.size.width,1);
    layer.backgroundColor=[UIColor whiteColor].CGColor;
    
    [view.layer addSublayer:layer];
}

-(void)leftPanelView:(UITextField *)txt withImage:(UIImage *)image{
    UIView *panel =[[UIView alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
    UIImageView *imageview=[[UIImageView alloc]initWithFrame:panel.bounds];
    imageview.image=image;
    imageview.contentMode = UIViewContentModeScaleAspectFit;
    [panel addSubview:imageview];
    
    txt.leftView = panel;
    txt.leftViewMode =UITextFieldViewModeAlways;
    
}
-(void)setupAlerts{
    [self.txtEmail addRegx:REGEX_EMAIL withMsg:@"The email address is not found or the password is incorrect. Please enter valid credentials"];

    self.txtEmail.isMandatory = YES;
    self.txtPassword.isMandatory = YES;
    self.txtEmail.validateOnCharacterChanged=YES;
    self.txtEmail.validateOnResign=YES;
}

-(void)addTapGuesture{
    if(tapGuesture){
        [self.view removeGestureRecognizer:tapGuesture];
    }
    
    tapGuesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGuestureFired:)];
    [self.view addGestureRecognizer:tapGuesture];
}


#pragma mark Button Delegates

- (IBAction)btnForgotPasswordClicked:(id)sender {
    [self showAlertForForgotPassword];
}

- (IBAction)btnGoClicked:(id)sender {
    //[self performSegueWithIdentifier:segueMakeProfile sender:self];
//    return;
    
    if([self.txtEmail validate] && [self.txtPassword validate]){
        [self webAPIToLogin];
    }
    else{

    }
}

- (IBAction)btnCancelClicked:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

#pragma mark - Forgot password

-(void)showAlertForForgotPassword{
    UIAlertView * forgotPassword=[[UIAlertView alloc] initWithTitle:@"Forgot Password"      message:@"Please enter your email id" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    forgotPassword.alertViewStyle=UIAlertViewStylePlainTextInput;
//    [forgotPassword textFieldAtIndex:0].delegate=self;

    [forgotPassword show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex ==1){
        NSLog(@"ok button clicked in forgot password alert view");
        NSString *femailId=[alertView textFieldAtIndex:0].text;
        if ([femailId isEqualToString:@""]) {
            UIAlertView *display;
            display=[[UIAlertView alloc] initWithTitle:@"Email" message:@"Please enter password for resetting password" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            [display show];
            
        }else{
            if([self NSStringIsValidEmail:femailId]){
                
            }
            else{
                UIAlertView *display;
                display=[[UIAlertView alloc] initWithTitle:@"Email" message:@"Please enter valid email" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                [display show];
                
            }
        }
    }
}

-(BOOL) NSStringIsValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = NO; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
    NSString *stricterFilterString = @"^[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}$";
    NSString *laxString = @"^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}


#pragma mark - Textfield delegates

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    activeTextfield=textField;
    //[self animateTextField:textField up:YES];
    [self addTapGuesture];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    //[self animateTextField:textField up:NO];
    activeTextfield = nil;
}

-(void)tapGuestureFired:(UITapGestureRecognizer *)tap{
    [self.view removeGestureRecognizer:tapGuesture];
    tapGuesture=nil;
    if(activeTextfield){
        [activeTextfield resignFirstResponder];
        //[self animateTextField:activeTextfield up:NO];
    }
}

#pragma mark - Helpers

-(void)animateTextField:(UITextField*)textField up:(BOOL)up
{
    const int movementDistance = -130; // tweak as needed
    const float movementDuration = 0.3f; // tweak as needed
    
    int movement = (up ? movementDistance : -movementDistance);
    
    [UIView beginAnimations: @"animateTextField" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];
}

#pragma mark - Call web service

-(void)webAPIToLogin{
    UserWebServiceClient *service=[[UserWebServiceClient alloc]init];
    //[service signUpUserWithName:@"" emailId:self.txtEmailID.text password:self.txtPassword.text deviceToken:nil target:self onSuccess:@selector(webResponseDidSuccess:) onFailure:@selector(webResponseDidFail:)];
    
    [service signInWithEmailId:self.txtEmail.text  password:self.txtPassword.text deviceToken:nil target:self onSuccess:@selector(webResponseDidSuccess:) onFailure:@selector(webResponseDidFail:)];
    
    [[HUD sharedInstance]showHUD:self.view];
}

-(void)webResponseDidSuccess:(Response *)response{
    [[HUD sharedInstance]hideHUD:self.view];
    [[CommansUtility sharedInstance]saveUserObject:(UserModel *)response.responseObject key:@"loggedInUser"];
    [self performSegueWithIdentifier:segueMakeProfile sender:self];
   // [self showErrorMessage:@"User registered successfully"];
   // [self dismissViewControllerAnimated:YES completion:nil];
    
}

-(void)webResponseDidFail:(Response *)response{
    [[HUD sharedInstance]hideHUD:self.view];
    [self showErrorMessage:@"Error in log in...!!!"];
}

-(void)showErrorMessage:(NSString *)message{
    [[[UIAlertView alloc]initWithTitle:@"UrbanEx" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil]show];
}


@end
