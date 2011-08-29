//
//  RootViewController.h
//  places-around-you
//
//  Created by Enzo Zuccolotto on 6/18/11.
//  Copyright 2011 Universidade do Vale do Rio dos Sinos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface RootViewController : UITableViewController <CLLocationManagerDelegate> {

    IBOutlet UIButton *searchButton;
    IBOutlet UITextField *queryField;
    IBOutlet UISwitch *useGPSSwitch;
    IBOutlet UISlider *metersSlider;
    
    CLLocationManager *locationManager;
    CLLocation *lastLocation;
    
}

-(IBAction)aboutApp:(id)sender;
-(IBAction)performSearch:(id)sender;

@end
