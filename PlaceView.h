//
//  PlaceView.h
//  places-around-you
//
//  Created by Enzo Zuccolotto on 6/20/11.
//  Copyright 2011 Universidade do Vale do Rio dos Sinos. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface PlaceView : UITableViewController {
 
    IBOutlet UIButton *mapsButton;
    IBOutlet UIButton *webpageButton;
    
}

@property(assign, nonatomic, readwrite)NSDictionary *place;

-(IBAction)openMapsURL:(id)sender;
-(IBAction)openWebpage:(id)sender;

@end
