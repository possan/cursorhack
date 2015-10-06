//
//  AppDelegate.h
//  cursorhack2
//
//  Created by Per-Olov Jernberg on 2015-10-04.
//  Copyright © 2015 Per-Olov Jernberg. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (weak) IBOutlet NSLevelIndicator *level1;
@property (weak) IBOutlet NSLevelIndicator *level2;
@property (weak) IBOutlet NSSlider *micsensitivityslider;
@property (weak) IBOutlet NSSlider *cursorbounceslider1;
@property (weak) IBOutlet NSSlider *cursorbounceslider2;

@end

