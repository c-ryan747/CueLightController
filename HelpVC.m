//
//  HelpTVC.m
//  CueLight
//
//  Created by Callum Ryan on 27/10/2014.
//  Copyright (c) 2014 Callum Ryan. All rights reserved.
//

#import "HelpVC.h"

@interface HelpVC () {
    NSArray *_helpText;
}

@end

@implementation HelpVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _helpText = @[//    Typical Use
                  @[@"Connecting to operators\nTo connect to an operator, launch the application and touch the button in the far bottom left labeled ‘Search’. Then select available operators from this list by touching their name. This will then send a request to the operator to connect to you. Once the operator has accepted the request they will appear in the main section of the app. To exit from this screen simply press ‘Cancel’ or ‘Done’.\nNote: Both devices WIFI connection will need to be on for this to work.",
                    
                    @"Using the timer\nThe controls for the built in show timer are located at the bottom left corner of the main screen. The start/stop button when touched will then start/stop the timer that visible to the right of it. The pause button when not greyed out will stop the current timer, with the ability to resume it at a later time. The timer will display the time elapsed in the following format, HH:MM:SS.",
                    
                    @"Communicating cue requests\nTo send a cue request to an operator you first need to be connected to them, for instructions on how to do this please refer to 2.7. Once connected in the main screen a row will appear for that operator. To send a ready or go request simply touch the left most button on that row. The buttons text will then change to ‘…’, only transitioning to the next state once the operator has confirmed the request.",
                    
                    @"Communicating other information\nTo communicate any other information with an operator tap on the microphone button on the appropriate operator’s row. Then audibly speak your message, tapping that button again to indicate the end of your message. This audio will then be sent to the operator.\nWhen you receive a message from an operator the microphone button will change to display a speaker symbol. To listen to that message just touch that button and it will start to play. The message will automatically be dismissed at the end but you can prematurely dismiss it by touching the button again.\nNote: A microphone will be needed to send this information, and the volume turned up to receive it.",
                    
                    @"Editing a cue\nTo edit a cues description, touch to the right of a cues number, and then type the description via the onscreen keyboard. When you are finished simply scroll the cue list a small amount or tap away and the keyboard will be removed.",
                    
                    @"Deleting a cue\nTo delete a cue swipe from left to right on the cue in question then touch the red ‘Delete’ button.",
                    
                    @"Communicating cue responses\nWhen the stage manager has sent you a request to get ready or run a cue your device will vibrate and the main button will change its colour and text. You then have to acknowledge that you’ve received this by tapping that button once.",
                    
                    @"Communicating other information\nTo communicate any other information with an operator tap on the microphone button at the top right. Then audibly speak your message, tapping that button again to indicate the end of your message. This audio will then be sent to the operator.\nWhen you receive a message from an operator the microphone button will change to display a speaker symbol. To listen to that message just touch that button and it will start to play. The message will automatically be dismissed at the end but you can prematurely dismiss it by touching the button again.\nNote: A microphone will be needed to send this information, and the volume turned up to receive it"],
                  
                  //    Backup
                  @[@"No show information is stored with this application and so no backup procedure needs to be in place. However please ensure all operators regullarly back up their data as desicribed in the manual"],
                  
                  //    Troubleshooting
                  @[@"Problem: Can’t download application\nCause: No network connection\nFix: Connect to the Hawthorn WIFI network and reattempt",
                    
                    @"Problem: Can’t launch application\nCause: No certificate installed\nFix: Reinstall the application and certificate detailed in section 1",
                    
                    @"Problem: Can’t send an audio message\nCause: Audio permissions not granted\nFix: Go into Settings > Privacy > Microphone and enable CueLightController. Then restart the app.",
                    
                    @"Problem: Can’t connect to an operator\nCause: No network connection\nFix: Connect to the Hawthorn WIFI network and reattempt",
                    
                    @"Problem: An operator doesn’t show up any cues or a name\nCause: The operator hasn’t inputted the required data\nFix: Ask the operator to add the appropriate data in their app"]];
    
    //  Allow for dynamic height cells
    self.tableView.estimatedRowHeight = 44.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
}
- (IBAction)goBack:(id)sender {
    //  Dismiss on back button press
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return [_helpText count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [_helpText[section] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return @"Typical Use";
            break;
        case 1:
            return @"Backup";
            break;
        case 2:
            return @"Troubleshooting";
            break;
        default:
            return nil;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PlainCell" forIndexPath:indexPath];
    cell.textLabel.text = _helpText[indexPath.section][indexPath.row];
    
    return cell;
}

@end
