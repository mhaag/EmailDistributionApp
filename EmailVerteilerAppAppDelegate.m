//
//  EmailVerteilerAppAppDelegate.m
//  EmailVerteilerApp
//
//  Created by Markus Haag on 31.08.10.
//  Copyright 2010 haag elektronix. All rights reserved.
//

#import "EmailVerteilerAppAppDelegate.h"
#import <AddressBook/AddressBook.h>

@implementation EmailVerteilerAppAppDelegate

@synthesize window;

Boolean FindFirstMatch(ABMutableMultiValue *multiValue, NSString *label, int* index);

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	// Insert code here to initialize your application 
    ABAddressBook *AB = [ABAddressBook sharedAddressBook];
    ABSearchElement *namesWithOutEmails =
    [ABPerson searchElementForProperty:kABEmailProperty
                                 label:nil
                                   key:nil
                                 value:@""
                            comparison:kABEqualCaseInsensitive];
    
    NSArray *peopleFound = [AB recordsMatchingSearchElement:namesWithOutEmails];

    ABSearchElement *namesWithEmails =
    [ABPerson searchElementForProperty:kABEmailProperty
                                 label:nil
                                   key:nil
                                 value:@""
                            comparison:kABNotEqualCaseInsensitive];

    NSArray *peopleFoundWithEmail = [AB recordsMatchingSearchElement:namesWithEmails];
    
    ABSearchElement *namesWithStreetAdress =
    [ABPerson searchElementForProperty:kABAddressProperty
                                 label:nil
                                   key:nil
                                 value:@""
                            comparison:kABNotEqualCaseInsensitive];

    NSArray *peopleFoundWithStreetAddress = [AB recordsMatchingSearchElement:namesWithStreetAdress];
    
    NSString *peopleWithEmail = [NSString stringWithFormat:@"%lu",(unsigned long)[peopleFoundWithEmail count]];
    NSString *peopleWithOutEmail = [NSString stringWithFormat:@"%lu",(unsigned long)[peopleFound count]];
    NSString *peopleWithStreetAddress = [NSString stringWithFormat:@"%lu",(unsigned long)[peopleFoundWithStreetAddress count]];
    
    [LabelAdressesWithOutEmails setStringValue:peopleWithOutEmail];
    [LabelAdressesWithEmails    setStringValue:peopleWithEmail];
    [LabelAdressesWithAdresses  setStringValue:peopleWithStreetAddress];
    
//    NSString *homeDir   = [NSString stringWithString:NSHomeDirectory()];
//    NSArray *homeDir = [NSArray arrayWithObjects:NSHomeDirectory()
//    NSMutableString *pathToFile = [NSMutableString stringWithString:homeDir];
//    [pathToFile appendString:@"/AdressenEmails.csv"];
//    [fileNameWithEmails ]
    [fileNameWithEmails  setStringValue:@"AdressenEmails.csv"];
    [fileNameWithOutEmails  setStringValue:@"Adressen.csv"];
    [fileNameWithAddresses  setStringValue:@"AdressenPost.csv"];



}

-(void)selectFileWithEmails:(id)sender {
    NSOpenPanel *op = [NSOpenPanel openPanel];
    if ([op runModal] == NSModalResponseOK)
    {
        [fileNameWithEmails setStringValue:[[op URL] absoluteString]];
        NSLog(@"select the file for email addresses: %@",[fileNameWithEmails stringValue]);
    }
}

-(void)selectFileWithOutEmails:(id)sender {
    NSOpenPanel *op = [NSOpenPanel openPanel];
    if ([op runModal] == NSModalResponseOK)
    {
        [fileNameWithOutEmails setStringValue:[[op URL] absoluteString]];
        NSLog(@"select the files without email addresses: %@",[fileNameWithOutEmails stringValue]);
    }
}

-(void)fileNameWithAddresses:(id)sender {
    NSOpenPanel *op = [NSOpenPanel openPanel];
    if ([op runModal] == NSModalResponseOK)
    {
        [fileNameWithAddresses setStringValue:[[op URL] absoluteString]];
        NSLog(@"select the files without email addresses: %@",[fileNameWithAddresses stringValue]);
    }
}

#pragma mark exportAdressen
-(void)exportAdresses:(id)sender allAddr:(BOOL)allAddresses {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    NSFileHandle *aFileHandle;
    NSString *aFile;
    NSString *tempString;
    ABMutableMultiValue *multiValue;
    int                 index = 0;
    int i=0;

    ABAddressBook *AB = [ABAddressBook sharedAddressBook];
    ABSearchElement *namesFound = nil;
    if ( allAddresses  ) {
        namesFound = [ABPerson searchElementForProperty:kABAddressProperty
                                     label:nil
                                       key:nil
                                     value:@""
                                comparison:kABNotEqualCaseInsensitive];
        
        [[NSFileManager defaultManager] createFileAtPath:[fileNameWithAddresses stringValue]
                                                contents:nil
                                              attributes:nil];
        
        aFile = [NSString stringWithString:[fileNameWithAddresses stringValue]];
        NSLog(@"export the Addresses to the %@",aFile);
        
    } else {
        namesFound = [ABPerson searchElementForProperty:kABEmailProperty
                                     label:nil
                                       key:nil
                                     value:@""
                                comparison:kABEqualCaseInsensitive];
        
        [[NSFileManager defaultManager] createFileAtPath:[fileNameWithOutEmails stringValue]
                                                contents:nil
                                              attributes:nil];
        
        aFile = [NSString stringWithString:[fileNameWithOutEmails stringValue]];
        NSLog(@"export the Addresses to the %@",aFile);
        
    }
 
    aFileHandle = [NSFileHandle fileHandleForWritingAtPath:aFile]; //telling aFilehandle what file write to
    if (aFileHandle == nil) {
        NSLog(@"open File for writing failed");
    }
    NSLog(@"file to write: %@",aFile);
    
    NSArray *peopleFound =
    [AB recordsMatchingSearchElement:namesFound];

    NSEnumerator *e = [peopleFound objectEnumerator];
    id object;
    while (object = [e nextObject]) {
        NSLog(@"found: %@, %@, %@, %@",[object valueForProperty:kABOrganizationProperty],[object valueForProperty:kABTitleProperty],[object valueForProperty:kABFirstNameProperty],[object valueForProperty:kABLastNameProperty]);
        if ( [object valueForProperty:kABLastNameProperty] )
        {
        if ( [object valueForProperty:kABTitleProperty] ) {
            tempString = [NSString stringWithString:[object valueForProperty:kABTitleProperty]];
            tempString = [tempString stringByAppendingFormat:@";"];
        }
            
        tempString = [NSString stringWithString:[object valueForProperty:kABLastNameProperty]];
        tempString = [tempString stringByAppendingFormat:@";"];
        if ( [object valueForProperty:kABFirstNameProperty] ) 
            tempString = [tempString stringByAppendingFormat:[NSString stringWithString:[object valueForProperty:kABFirstNameProperty]]];
        NSLog(@"tempString: %@",tempString);
        tempString = [tempString stringByAppendingFormat:@";"];

        if ( [object valueForProperty:kABAddressProperty] ) 
        {   
            NSLog(@"Address Property found!!!");
            // Create a multiValue and populate it with the items in kABAddressProperty
            multiValue = [object valueForProperty: kABAddressProperty];
            if ( multiValue ) {
                
            
            // Get an index into a multiValue value for the kABAddressHomeLabel label
            if (FindFirstMatch(multiValue, kABAddressHomeLabel, &index))
            {
                // kABAddressHomeLabel is a NSDictionary
                NSMutableDictionary *dict = [[multiValue valueAtIndex: index] mutableCopy];
                if ( [dict valueForKey: kABAddressStreetKey] )
                    tempString = [tempString stringByAppendingFormat:[dict valueForKey: kABAddressStreetKey]];
                tempString = [tempString stringByAppendingFormat:@";"];
                if ( [dict valueForKey: kABAddressZIPKey] )
                    tempString = [tempString stringByAppendingFormat:[dict valueForKey: kABAddressZIPKey]];
                tempString = [tempString stringByAppendingFormat:@";"];
                if ( [dict valueForKey: kABAddressCityKey] )
                    tempString = [tempString stringByAppendingFormat:[dict valueForKey: kABAddressCityKey]];
                tempString = [tempString stringByAppendingFormat:@";"];
                if ( [dict valueForKey: kABAddressCountryKey] )
                    tempString = [tempString stringByAppendingFormat:[dict valueForKey: kABAddressCountryKey]];
                [dict release];
            }
            // Get an index into a multiValue value for the kABWorkHomeLabel label
            if (FindFirstMatch(multiValue, kABAddressWorkLabel, &index))
            {
                // kABAddressHomeLabel is a NSDictionary
                NSMutableDictionary *dict = [[multiValue valueAtIndex: index] mutableCopy];
                if ( [dict valueForKey: kABAddressStreetKey] )
                    tempString = [tempString stringByAppendingFormat:[dict valueForKey: kABAddressStreetKey]];
                tempString = [tempString stringByAppendingFormat:@";"];
                if ( [dict valueForKey: kABAddressZIPKey] )
                    tempString = [tempString stringByAppendingFormat:[dict valueForKey: kABAddressZIPKey]];
                tempString = [tempString stringByAppendingFormat:@";"];
                if ( [dict valueForKey: kABAddressCityKey] )
                    tempString = [tempString stringByAppendingFormat:[dict valueForKey: kABAddressCityKey]];
                tempString = [tempString stringByAppendingFormat:@";"];
                if ( [dict valueForKey: kABAddressCountryKey] )
                    tempString = [tempString stringByAppendingFormat:[dict valueForKey: kABAddressCountryKey]];
                [dict release];
            }
            }
            //write into file
            NSLog(@"%i tempString: %@",i,tempString);
            tempString = [tempString stringByAppendingFormat:@"\r\n"];
            
            [aFileHandle truncateFileAtOffset:[aFileHandle seekToEndOfFile]]; //setting aFileHandle to write at the end of the file
            [aFileHandle writeData:[tempString dataUsingEncoding:NSUnicodeStringEncoding] ];            
        }
        i++;
        } else {
            NSLog(@"NO LASTNAME!!!!");
        }
    }
    [aFileHandle closeFile];
    [object release];
    [pool release];
}

#pragma mark exportEmailAdressen
-(void)exportEmailAdresses:(id)sender {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    NSFileHandle *aFileHandle;
    NSString *aFile;
    NSString *tempString;
    ABMutableMultiValue *multiValue;
    [[NSFileManager defaultManager] createFileAtPath:[fileNameWithEmails stringValue]
                                            contents:nil 
                                          attributes:nil];
    
    aFile = [NSString stringWithString:[fileNameWithEmails stringValue]];
    aFileHandle = [NSFileHandle fileHandleForWritingAtPath:aFile]; //telling aFilehandle what file write to
    if (aFileHandle == nil) {
        NSLog(@"open File for writing failed");
    }
    
 
    //ABMultiValueRef emailAddresses = ABRecordCopyValue(person, kABPersonEmailProperty);
    //CFStringRef email = ABMultiValueCopyValueAtIndex(emailAddresses, j);
    //NSString *emailString = (NSString *)email;
    
    NSLog(@"export the Addresses to the %@",aFile);  
    ABAddressBook *AB = [ABAddressBook sharedAddressBook];
    ABSearchElement *namesWithEmails =
    [ABPerson searchElementForProperty:kABEmailProperty
                                 label:nil
                                   key:nil
                                 value:@""
                            comparison:kABNotEqualCaseInsensitive];
    NSArray *peopleFoundWithEmail =
    [AB recordsMatchingSearchElement:namesWithEmails];
    
    NSEnumerator *e = [peopleFoundWithEmail objectEnumerator];
    id object;
    while (object = [e nextObject]) {
        NSLog(@"found: %@",[object valueForProperty:kABEmailProperty]);
        // Create a multiValue and populate it with the items in kABAddressProperty
        multiValue = [object valueForProperty: kABEmailProperty];
        if ( multiValue ) {
            if ( [multiValue count] < 2) {
                tempString = [ multiValue valueAtIndex:0];
                tempString = [ tempString stringByAppendingString:@";" ];
            } else {
                NSLog(@"more than one EMAIL found!!");
                for (int i=0; i < [ multiValue count ]; i++ ) {
                    NSLog(@"%@", [ multiValue valueAtIndex:i] );
                    tempString = [ tempString stringByAppendingString:[ multiValue valueAtIndex:i] ];
                    tempString = [ tempString stringByAppendingString:@";" ];
                }

            }
        }
        // append string to the file
        [aFileHandle truncateFileAtOffset:[aFileHandle seekToEndOfFile]]; //setting aFileHandle to write at the end of the file
        [aFileHandle writeData:[tempString dataUsingEncoding:NSUnicodeStringEncoding]];
    }
    [aFileHandle closeFile];
    [object release];
    [pool release];
}

- (IBAction)exportAllAdresses:(id)sender {
    [self exportAdresses:nil allAddr:YES];
}

- (IBAction)exportAdresses:(id)sender {
    [self exportAdresses:nil allAddr:NO];
}

#pragma mark FindFirstMatch
Boolean FindFirstMatch(ABMutableMultiValue *multiValue, NSString *label, int* index)
{
    unsigned int        mvCount = 0;
    int                 x;
    
    mvCount = [multiValue count];
    if (mvCount > 0)
    {
        for (x = 0; x < mvCount; x++)
        {
            NSString *text = [multiValue labelAtIndex: x];
            NSComparisonResult result = [text compare: label];
            
            if (result == NSOrderedSame)
            {
                *index = x;
                return true;
            }
        }
    }
    return false;
}

@end
