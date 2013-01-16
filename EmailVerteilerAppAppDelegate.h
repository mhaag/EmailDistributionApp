//
//  EmailVerteilerAppAppDelegate.h
//  EmailVerteilerApp
//
//  Created by Markus Haag on 31.08.10.
//  Copyright 2010 haag elektronix. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Foundation/NSFileManager.h>
#import <Foundation/NSFileHandle.h>


@interface EmailVerteilerAppAppDelegate : NSObject
#if (MAC_OS_X_VERSION_MAX_ALLOWED >= 1060)
<NSWindowDelegate>
#endif
{
    NSWindow *window;
    IBOutlet NSTextField *LabelAdressesWithOutEmails;
    IBOutlet NSTextField *LabelAdressesWithEmails;
    IBOutlet NSTextField *fileNameWithEmails;
    IBOutlet NSTextField *fileNameWithOutEmails;    
}

- (IBAction)selectFileWithEmails:(id)sender;
- (IBAction)selectFileWithOutEmails:(id)sender;
- (IBAction)exportAdressen:(id)sender;
- (IBAction)exportEmailAdressen:(id)sender;

@property (assign) IBOutlet NSWindow *window;

@end
