//
//  PersonInfoVC.m
//  BackOffice
//
//  Created by Эльвира Чекменева on 04.02.14.
//  Copyright (c) 2014 Эльвира Чекменева. All rights reserved.
//
#import <MessageUI/MessageUI.h>
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import "PersonInfoVC.h"

@interface PersonInfoVC ()

@end

@implementation PersonInfoVC

@synthesize departmentLabel, photo, nameLabel, positionLabel, emailButton,callButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    userInfo = [[NSUserDefaults standardUserDefaults] objectForKey:@"personInfo"];
    NSLog(@"UserInfo %@", userInfo);
	// Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [departmentLabel setText:[userInfo objectForKey:@"departName"]];
    [nameLabel setText:[NSString stringWithFormat:@"%@ %@",
                        [userInfo objectForKey:@"firstName"],
                        [userInfo objectForKey:@"lastName"]]];
    [positionLabel setText:[NSString stringWithFormat:@"%@, %@",
                           [userInfo objectForKey:@"position"],
                           [userInfo objectForKey:@"employeestatus"]]];
   // callButton.titleLabel.text = [userInfo objectForKey:@"cellphone"];
    //[callButton.titleLabel setText:[userInfo objectForKey:@"cellphone"]];
    [callButton setTitle:[userInfo objectForKey:@"cellphone"] forState:UIControlStateNormal];
    [emailButton setTitle:[userInfo objectForKey:@"email"] forState:UIControlStateNormal];
    //[emailButton.titleLabel setText:[userInfo objectForKey:@"email"]];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                         NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString* path = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat: @"%@.png",
                                                                        [userInfo objectForKey:@"userID"]]];
    if ([UIImage imageWithContentsOfFile:path]){
        UIImage* image = [UIImage imageWithContentsOfFile:path];
        photo.image = image;
        photo.layer.cornerRadius = 6;
    }else {
        NSString * photoURLString = [userInfo objectForKey:@"imageURL"];
        UIImage* image = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:photoURLString]]];
        photo.image = image;
        photo.layer.cornerRadius = 6;
        NSData* data = UIImagePNGRepresentation(image);
        [data writeToFile:path atomically:YES];
    }

}

- (void)viewWillDisappear:(BOOL)animated {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"personInfo"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)callButtonPressed:(id)sender {
    NSLog(@"phone number %@",[userInfo objectForKey:@"cellphone"]);
    NSString *phNo = [userInfo objectForKey:@"cellphone"];
    NSURL *phoneUrl = [NSURL URLWithString:[NSString  stringWithFormat:@"telprompt:%@",phNo]];
    UIAlertView * calert;
    if ([[UIApplication sharedApplication] canOpenURL:phoneUrl]) {
        [[UIApplication sharedApplication] openURL:phoneUrl];
    } else {
        calert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Call facility is not available!!!" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
        [calert show];
    }
}


- (IBAction)emailButtonPressed:(id)sender {
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController * emailController = [[MFMailComposeViewController alloc] init];
        emailController.mailComposeDelegate = self;
        NSArray* recipients = [NSArray arrayWithObject:[userInfo objectForKey:@"email"]];
        [emailController setSubject:@"theme"];
        [emailController setMessageBody:@"Hi!" isHTML:YES];
        [emailController setToRecipients:recipients];
        [self presentViewController:emailController animated:YES completion:nil];
        
    }
    // Show error if no mail account is active
    else {
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"Warning" message:@"You must have a mail account in order to send an email" delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", @"OK") otherButtonTitles:nil];
        [alertView show];
    }
    
    
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_3_0){
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)saveContact:(id)sender {
//    ABRecordRef person = ABPersonCreate();
//    ABRecordSetValue(<#ABRecordRef record#>, <#ABPropertyID property#>, <#CFTypeRef value#>, <#CFErrorRef *error#>)
//    
//    ABMutableMultiValueRef multiAddress = ABMultiValueCreateMutable(kABMultiDictionaryPropertyType);
//    NSMutableDictionary *addressDictionary = [[NSMutableDictionary alloc] init];
//    
//    ABUnknownPersonViewController *controller = [[ABUnknownPersonViewController alloc] init];
//    
//    controller.displayedPerson = person;
//    controller.allowsAddingToAddressBook = YES;
//    
//    // current view must have a navigation controller
//    
//    [self.navigationController pushViewController:controller animated:YES];
//    
//    CFRelease(person);
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(nil, nil);
    if (addressBook != NULL) {
        if ([self doesPersonExistWithFirstName:[userInfo objectForKey:@"firstName"] lastName:[userInfo objectForKey:@"lastName"] inAddressBook:addressBook]) {
            NSLog(@"This contact exists in the address book");
        } else {
            NSLog(@"this contact does not exist");
            NSData* imageData = UIImagePNGRepresentation(photo.image);
            ABRecordRef newContact = [self newPersonWithFirstName:[userInfo objectForKey:@"firstName"]
                                                         lastName:[userInfo objectForKey:@"lastName"]
                                                        cellphone:[userInfo objectForKey:@"cellphone"]
                                                            email:[userInfo objectForKey:@"email"]
                                                        imageData:imageData                                                     inAddressBook:addressBook];
            if (newContact != NULL) {
                NSLog(@"successfuly created a record for new contact");
                CFRelease(newContact);
            } else {
                NSLog(@"failed to create a record for new contact");
            }
        }
        
        CFRelease(addressBook);
    }
}


- (ABRecordRef) newPersonWithFirstName:(NSString*) paramFirstName lastName:(NSString*) paramLastName cellphone:(NSString*) paramCellphone email:(NSString*)paramEmail imageData:(NSData*)paramImageData inAddressBook:(ABAddressBookRef)paramAddressBook {
    ABRecordRef result = NULL;
    if (paramAddressBook == NULL) {
        NSLog(@"The address book is Null");
        return  NULL;
    }
    if ([paramFirstName length] == 0 && [paramLastName length] == 0) {
        NSLog(@"FirstName and LastName are both empty");
        return NULL;
    }
    
    result = ABPersonCreate();
    
    if (result == NULL) {
        NSLog(@"Failed to create a new person");
        return NULL;
    }
    
    BOOL couldSetFirstName = NO;
    BOOL couldSetLastName = NO;
    CFErrorRef setFirstNameError = NULL;
    CFErrorRef setLastNameError = NULL;
    CFErrorRef setCellphoneError = NULL;
    CFErrorRef setEmailError = NULL;
    CFErrorRef setPersonImageError = NULL;
    
    couldSetFirstName = ABRecordSetValue(result, kABPersonFirstNameProperty, (__bridge CFTypeRef) paramFirstName, &setFirstNameError);
    couldSetLastName = ABRecordSetValue(result, kABPersonLastNameProperty, (__bridge CFTypeRef) paramLastName, &setLastNameError);
    ABMutableMultiValueRef multiPhone = ABMultiValueCreateMutable(kABMultiStringPropertyType);
    
    ABMultiValueAddValueAndLabel(multiPhone, (__bridge CFTypeRef)(paramCellphone), kABPersonPhoneMobileLabel, NULL);
    ABRecordSetValue(result, kABPersonPhoneProperty, multiPhone,&setCellphoneError);
    
    ABMutableMultiValueRef multiEmail = ABMultiValueCreateMutable(kABMultiStringPropertyType);
    ABMultiValueAddValueAndLabel(multiEmail,(__bridge CFTypeRef)(paramEmail), kABWorkLabel, NULL);
    ABRecordSetValue(result, kABPersonEmailProperty, multiEmail, &setEmailError);
    CFRelease(multiEmail);
    
    ABPersonSetImageData(result, (__bridge CFDataRef)(paramImageData), &setPersonImageError);
    
    CFErrorRef couldAddPersonError = NULL;
    BOOL couldAddPerson = ABAddressBookAddRecord(paramAddressBook, result, &couldAddPersonError);
    if (couldAddPerson) {
        NSLog(@"succesfully added the person");
    } else {
        NSLog(@"failed to add the person");
        CFRelease(result);
        result = NULL;
        return result;
    }
    if (ABAddressBookHasUnsavedChanges(paramAddressBook)){
        CFErrorRef couldSaveAddressBookError = NULL;
        BOOL couldSaveAddressBook = ABAddressBookSave(paramAddressBook, &couldSaveAddressBookError);
        if (couldSaveAddressBook){
            NSLog(@"successfully saved the address book");
        } else {
            NSLog(@"failed to save the address book");
        }
    }
    
    if (couldSetFirstName && couldSetLastName){
        NSLog(@"successfully set the first name and last name of the person");
    } else{
        NSLog(@"failed to set the first name and/or last name of the person");
    }
    return result;
}

- (BOOL) doesPersonExistWithFirstName:(NSString*) paramFirstName
                             lastName:(NSString*) paramLastName
                        inAddressBook:(ABRecordRef) paramAddressBook {
    BOOL result = NO;
    if (paramAddressBook == NULL) {
        NSLog(@"The address book is null");
        return NO;
    }
    NSArray* allPeople = (__bridge NSArray*) ABAddressBookCopyArrayOfAllPeople(paramAddressBook);
    NSUInteger peopleCounter = 0;
    for (peopleCounter = 0; peopleCounter < [allPeople count]; peopleCounter ++) {
        ABRecordRef person = (__bridge  ABRecordRef) [allPeople objectAtIndex:peopleCounter];
        NSString *firstName = (__bridge NSString*) ABRecordCopyValue(person, kABPersonFirstNameProperty);
        NSString* lastName = (__bridge NSString*) ABRecordCopyValue(person, kABPersonLastNameProperty);
        BOOL firstNameIsEqual = NO;
        BOOL lastNameIsEqual = NO;
        if ([firstName length] == 0 && [paramFirstName length] == 0) {
            firstNameIsEqual = YES;
        } else if ([firstName isEqualToString:paramFirstName]){
            firstNameIsEqual = YES;
        }
        
        if ([lastName length] == 0 && [paramLastName length] == 0) {
            lastNameIsEqual = YES;
        }else if ([lastName isEqualToString:paramLastName]) {
            lastNameIsEqual = YES;
        }
        
        if (firstNameIsEqual && lastNameIsEqual) {
            return YES;
        }
    }
    return result;
}

@end
