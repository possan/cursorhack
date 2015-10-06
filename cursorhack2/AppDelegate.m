//
//  AppDelegate.m
//  cursorhack2
//
//  Created by Per-Olov Jernberg on 2015-10-04.
//  Copyright © 2015 Per-Olov Jernberg. All rights reserved.
//

#import "AppDelegate.h"
#import "UKSoundFileRecorder.h"

@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;

@end

@implementation AppDelegate

UKSoundFileRecorder*		recorder;
bool updateCursor;
float m_mousesize;
float m_mousedelta;
float m_lastmousesize;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    
    [self performSelector:@selector(initSysPrefs) withObject:self afterDelay:1.0];
    
}

- (void)initSysPrefs {
    NSString *src = @"tell application \"System Preferences\"\n"
    "reveal anchor \"Seeing_Display\" of pane id \"com.apple.preference.universalaccess\"\n"
    "end tell\n";

    NSDictionary *errorDict;
    NSAppleScript *as = [[NSAppleScript alloc] initWithSource:src];
    NSAppleEventDescriptor *ret = [as executeAndReturnError:&errorDict];
    
    NSLog(@"ret: %@", ret);
    NSLog(@"errorDict: %@", errorDict);
    
    if (ret != NULL)
    {
        // successful execution
        if (kAENullEvent != [ret descriptorType])
        {
            // script returned an AppleScript result
            if (cAEList == [ret descriptorType])
            {
                // result is a list of other descriptors
                
            }
            else
            {
                // coerce the result to the appropriate ObjC type
            }
        }
    }
    else
    {
        // no script result, handle error here
    }
    
    recorder = [[UKSoundFileRecorder alloc] init];
    [recorder setOutputFilePath:@"/tmp/hello2.m4a"];
    [recorder start:nil];
    
    m_lastmousesize = 1.0;
    m_mousesize = 0;
    m_mousedelta = 0;
    updateCursor = TRUE;
    
    [self.micsensitivityslider setFloatValue:1000.0];

    [self.cursorbounceslider1 setFloatValue:99.0];
    [self.cursorbounceslider2 setFloatValue:20.0];

    [self performSelector:@selector(tickOnce) withObject:self afterDelay:1.0];
}

- (void)tickOnce {
    float b1 = self.cursorbounceslider1.floatValue / 100.0f;
    float b2 = self.cursorbounceslider2.floatValue / 100.0f;
    
    float aa = [recorder lastAmplitude] * self.micsensitivityslider.floatValue / 100.0;
    aa = fmax(aa, fmin(aa, 100));
    
    float ms = 1.0 + aa * 4.0;
    float nd = ms - m_mousesize;
    
    m_mousedelta = (m_mousedelta * b2) + ((nd) * (1.0 - b2));
    m_mousesize += m_mousedelta * b1;
    
    // NSLog(@"tickOnce: aa=%1.5f, ms=%1.3f, mousesize=%1.3f +∆ %1.3f", aa, ms, m_mousesize, m_mousedelta);
    
    [self.level1 setFloatValue:aa * 100.0 / 1.0];
    [self.level2 setFloatValue:m_mousesize * 100.0 / 5.0];
    
    if (updateCursor) {

        float d = fabs(m_mousesize - m_lastmousesize);
        if (d > 0.05) {
            m_lastmousesize = m_mousesize;

            NSString *src2 = [NSString stringWithFormat:@"tell application \"System Events\"\n"
                              "	set value of slider 1 of window 1 of application process \"System Preferences\" to %1.3f\n"
                              "end tell\n", m_mousesize];
            
            NSDictionary* errorDict;
            NSAppleScript *as2 = [[NSAppleScript alloc] initWithSource:src2];
            NSAppleEventDescriptor *ret2 = [as2 executeAndReturnError:&errorDict];
            
            NSLog(@"ret2: %@", ret2);
            NSLog(@"errorDict: %@", errorDict);
            
            if (ret2 != NULL)
            {
                // successful execution
                if (kAENullEvent != [ret2 descriptorType])
                {
                    // script returned an AppleScript result
                    if (cAEList == [ret2 descriptorType])
                    {
                        // result is a list of other descriptors
                    }
                    else
                    {
                        // coerce the result to the appropriate ObjC type
                    }
                }
            }
            else
            {
                // no script result, handle error here
                
                /*
                 NSAlert *a = [[NSAlert alloc] init];
                 [a setInformativeText:@"Couldn't tell system preferences, probably access problems..."];
                 [a runModal];
                 */ 
                updateCursor = FALSE;
            }
        }
    }

    [self performSelector:@selector(tickOnce) withObject:self afterDelay:0.02];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

@end
