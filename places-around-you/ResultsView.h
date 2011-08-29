//
//  ResultsView.h
//  places-around-you
//
//  Created by Enzo Zuccolotto on 6/19/11.
//  Copyright 2011 Universidade do Vale do Rio dos Sinos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "ASIHTTPRequest.h"
#import "MBProgressHUD.h"

@interface ResultsView : UITableViewController <MBProgressHUDDelegate> {
    
    NSMutableArray *results;

    MBProgressHUD *HUD;
}

@property(assign, nonatomic, readwrite)NSString *query;
@property(assign, nonatomic, readwrite)CLLocation *location;
@property(assign, nonatomic, readwrite)NSNumber *distance;


@end
