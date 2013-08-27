//
//  SMUManager.m
//  SonyMusicUnlimited
//
//  Created by Jeremy Blaker on 8/22/13.
//  Copyright (c) 2013 blakerdesign. All rights reserved.
//

#import "SMUManager.h"
#import "AppDelegate.h"

#define kApplicationName  @"Sony Music Unlimited"
#define kNowPlayingClass  @"GBJWNX1BGBC"
#define kIndexForTitle    0
#define kIndexForArtist   4
#define kIndexForAlbum    2

@interface SMUManager () {
  WebView *_webView;
  NSMenuItem *_nowPlayingMenuItem;
  NSMenuItem *_artistNameMenuItem;
  NSMenuItem *_trackNameMenuItem;
  NSMenuItem *_playbackToggleMenuItem;
  NSMenuItem *_previousTrackMenuItem;
  NSMenuItem *_nextTrackMenuItem;
  NSMenuItem *_likeTrackMenuItem;
  NSMenuItem *_dislikeTrackMenuItem;
  NSMenu *_dockMenu;
  BOOL _isPlaying;
  int _previousTimeStamp;
  NSString *_trackName;
  NSString *_artistName;
}

@end

@implementation SMUManager

+ (SMUManager *)sharedInstance {
  static SMUManager *sharedInstance = nil;
  if (sharedInstance) {
    return sharedInstance;
  }
  sharedInstance = [[SMUManager alloc] init];
  return sharedInstance;
}

- (void)setup {
  
  _nowPlayingMenuItem = [[AppDelegate appDelegate] nowPlayingMenuItem];
  [_nowPlayingMenuItem setTitle:@"Nothing Playing"];
  
  _webView = [[AppDelegate appDelegate] webView];
  [_webView setFrameLoadDelegate:self];
  
  _dockMenu = [[AppDelegate appDelegate] dockMenu];
  _trackNameMenuItem = [[AppDelegate appDelegate] trackNameMenuItem];
  _artistNameMenuItem = [[AppDelegate appDelegate] artistNameMenuItem];
  
  _playbackToggleMenuItem = [[AppDelegate appDelegate] playbackToggleMenuItem];
  _previousTrackMenuItem = [[AppDelegate appDelegate] previousTrackMenuItem];
  _nextTrackMenuItem = [[AppDelegate appDelegate] nextTrackMenuItem];
  _likeTrackMenuItem = [[AppDelegate appDelegate] likeTrackMenuItem];
  _dislikeTrackMenuItem = [[AppDelegate appDelegate] dislikeTrackMenuItem];
  
  [self shouldShowTrackInfoMenuItems:NO];
  [self shouldEnableMenuItems:NO];
  
  [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(displayNowPlaying) userInfo:nil repeats:YES];
}

// This delegate method gets triggered every time the page loads, but before the JavaScript runs
- (void)webView:(WebView *)webView windowScriptObjectAvailable:(WebScriptObject *)windowScriptObject {
	// Allow this class to be usable through the "window.app" object in JavaScript
	// This could be any Objective-C class
	[windowScriptObject setValue:self forKey:@"app"];
}

- (void)togglePlayback {
  [self triggerJavascriptEvent:@"click" forElementID:@"PlayerPlayPause"];
}

- (void)previousTrack {
  [self triggerJavascriptEvent:@"click" forElementID:@"PlayerPrevious"];
}

- (void)nextTrack {
  [self triggerJavascriptEvent:@"click" forElementID:@"PlayerNext"];
}

- (void)likeTrack {
  [self triggerJavascriptEvent:@"click" forElementID:@"PlayerLike"];
}

- (void)dislikeTrack {
  [self triggerJavascriptEvent:@"click" forElementID:@"PlayerDislike"];
}

- (void)triggerJavascriptEvent:(NSString *)eventName forElementID:(NSString *)elementID {
  NSString *javascriptCommand = [NSString stringWithFormat:@"var event = document.createEvent(\"HTMLEvents\"); event.initEvent(\"%@\", true, true); document.getElementById('%@').dispatchEvent(event)", eventName, elementID];
  [[_webView windowScriptObject] evaluateWebScript:javascriptCommand];
}

- (void)shouldShowTrackInfoMenuItems:(BOOL)b {
  if (b) {
    [_dockMenu insertItem:_trackNameMenuItem atIndex:1];
    [_dockMenu insertItem:_artistNameMenuItem atIndex:1];
  } else {
    [_dockMenu removeItem:_trackNameMenuItem];
    [_dockMenu removeItem:_artistNameMenuItem];
  }
}

- (void)shouldEnableMenuItems:(BOOL)b {
  [_playbackToggleMenuItem setEnabled:b];
  [_previousTrackMenuItem setEnabled:b];
  [_nextTrackMenuItem setEnabled:b];
  [_likeTrackMenuItem setEnabled:b];
  [_dislikeTrackMenuItem setEnabled:b];
}

- (void)displayNowPlaying {
  NSString *currentTrackName = [self innerHTMLForElementWithClassName:kNowPlayingClass atIndex:kIndexForTitle];
  if ( ![currentTrackName isEqualToString:_trackName] ) {
    _previousTimeStamp = 0;
  }
  _trackName = currentTrackName;
  _artistName = [self innerHTMLForElementWithClassName:kNowPlayingClass atIndex:kIndexForArtist];
  
  if ( _trackName.length == 0 ) {
    [_nowPlayingMenuItem setTitle:@"Nothing Playing"];
    if ( _isPlaying == YES ) {
      [self shouldShowTrackInfoMenuItems:NO];
      [self shouldEnableMenuItems:NO];
      _isPlaying = NO;
    }
  } else {
    [self updateMenuItem:_artistNameMenuItem withTitle:_artistName];
    [self updateMenuItem:_trackNameMenuItem withTitle:_trackName];
    [self updateMenuItem:_nowPlayingMenuItem withTitle:@"Now Playing"];
    
    if ( _isPlaying == NO ) {
      [self shouldShowTrackInfoMenuItems:YES];
      [self shouldEnableMenuItems:YES];
      _isPlaying = YES;
    }
    
    NSString *currentTimeString = [self innerHTMLForElementWithClassName:@"GBJWNX1BOY" atIndex:0];
    int currentTimeStamp = [[currentTimeString stringByReplacingOccurrencesOfString:@":" withString:@""] intValue];
    if ( currentTimeStamp > _previousTimeStamp ) {
      [self updateMenuItem:_playbackToggleMenuItem withTitle:@"Pause"];
    } else {
      [self updateMenuItem:_playbackToggleMenuItem withTitle:@"Play"];
    }
    _previousTimeStamp = currentTimeStamp;
    
  }
}

- (void)updateMenuItem:(NSMenuItem *)menuItem withTitle:(NSString *)title {
  if ( ![[menuItem title] isEqualToString:title] ) {
    [menuItem setTitle:title];
  }
}

- (NSString *)innerHTMLForElementWithClassName:(NSString *)className atIndex:(int)index {
  return [_webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"document.getElementsByClassName('%@')[%i].innerHTML", className, index]];
}

@end
