//
//  AppDelegate.h
//  SonyMusicUnlimited
//
//  Created by Jeremy Blaker on 8/20/13.
//  Copyright (c) 2013 blakerdesign. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;
@property (weak) IBOutlet WebView *webView;
@property (weak) IBOutlet NSImageView *smuLogo;
@property (weak) IBOutlet NSMenuItem *nowPlayingMenuItem;

- (IBAction)togglePlayback:(id)sender;
- (IBAction)previousTrack:(id)sender;
- (IBAction)nextTrack:(id)sender;
- (IBAction)likeTrack:(id)sender;
- (IBAction)dislikeTrack:(id)sender;

+ (AppDelegate *)appDelegate;

@end
