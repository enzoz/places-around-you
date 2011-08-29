//
//  RootViewController.m
//  places-around-you
//
//  Created by Enzo Zuccolotto on 6/18/11.
//  Copyright 2011 Universidade do Vale do Rio dos Sinos. All rights reserved.
//

#import "RootViewController.h"
#import "AboutView.h"
#import "ResultsView.h"

@implementation RootViewController

- (void) getToolbarItems: (NSMutableArray *) toolbaritens  {
    UIBarButtonItem *aboutButton = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPageCurl target:self action:@selector(aboutApp:)] autorelease];
    UIBarButtonItem *flexSpace = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil] autorelease];
    
    [toolbaritens addObject:flexSpace];
    [toolbaritens addObject:aboutButton];
}

#pragma mark - App Form fields
-(void)setupSearchButton
{
    searchButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [searchButton setTitle:@"Search" forState:UIControlStateNormal];
    [searchButton setFrame:CGRectMake(0, 0, 300, 50)];
    [searchButton addTarget:self action:@selector(performSearch:) forControlEvents:(UIControlEvents)UIControlEventTouchDown];
}

-(void)setupQueryField
{
    queryField = [[UITextField alloc] initWithFrame:CGRectMake(100, 13, 180, 27)];
}

-(void)setupUseGPSSwitch
{
    useGPSSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(198, 12, 94, 27)];
    [useGPSSwitch setOn:NO];
    [useGPSSwitch addTarget:self action:@selector(useGPSswitch:) forControlEvents:UIControlEventValueChanged];
}

-(void)setupMetersSlide
{
    metersSlider = [[UISlider alloc] initWithFrame:CGRectMake(100, 13, 180, 27)];
    metersSlider.backgroundColor = [UIColor clearColor];
    
    metersSlider.minimumValue = 1.0;
    metersSlider.maximumValue = 100.0;
    metersSlider.continuous = NO;
    metersSlider.value = 50.0;
    
}

- (void)viewDidLoad
{

    NSMutableArray *toolbaritens = [[NSMutableArray alloc] init];
    
    [self getToolbarItems: toolbaritens];
    [self setToolbarItems:toolbaritens animated:YES];
    
    self.modalPresentationStyle = UIModalPresentationFullScreen;
    [self.navigationItem setTitle:@"Places around you"];
        
    [self setupSearchButton];
    [self setupQueryField];
    [self setupUseGPSSwitch];
    [self setupMetersSlide];
    
    [super viewDidLoad];
}

#pragma mark - TableView DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0)
    {
        if([useGPSSwitch isOn])
            return 3;
        else
            return 2;
    }
    else if(section == 1)
        return 1;
    else
        return 0;
}

// to determine specific row height for each cell, override this.
// In this example, each row is determined by its subviews that are embedded.
//
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 50.0;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"] autorelease];
    [cell setHighlighted:NO];
    
    if(indexPath.section == 0)
    {
        if(indexPath.row == 0)
        {
            [cell.textLabel setText:@"Search "];
            [cell.contentView addSubview:queryField];
        }
        else if(indexPath.row == 1)
        {
            [cell.textLabel setText:@"Use GPS"];
            [cell.contentView addSubview:useGPSSwitch];
        }
        else if(indexPath.row == 2)
        {
            [cell.textLabel setText:@"Distance"];
            [cell.contentView addSubview:metersSlider];
        }
    }
    else if(indexPath.section == 1)
    {
        [cell setBackgroundColor:[UIColor clearColor]];
        [cell.contentView addSubview:searchButton];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

#pragma mark - SearchButton pressed
-(IBAction)performSearch:(id)sender
{
    NSString *trimmedString = [queryField.text stringByTrimmingCharactersInSet:[NSCharacterSet  whitespaceAndNewlineCharacterSet]];
    
    if(trimmedString == nil || [trimmedString isEqualToString:@""])
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Please enter a valid query term." delegate:self cancelButtonTitle:@"OK!" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }else
    {
        float distance = (metersSlider.value * 100);
        
        ResultsView *result = [[ResultsView alloc] initWithNibName:@"ResultsView" bundle:[NSBundle mainBundle]];
        result.query = queryField.text;
        result.location = lastLocation;
        result.distance = [[NSNumber alloc] initWithFloat:distance];
        
        [self.navigationController pushViewController:result animated:YES];
        [result release];
        
    } 
}

#pragma mark - userGPS perform
-(IBAction)useGPSswitch:(id)sender
{
    if([useGPSSwitch isOn])
    {
        locationManager = [[CLLocationManager alloc] init];
        [locationManager setDelegate:self];
        
        [locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
        [locationManager setDistanceFilter:10];
        
        [locationManager startUpdatingLocation];
        
        lastLocation = [[CLLocation alloc] initWithLatitude:-30.035347 longitude:-51.227124];
    }
    
    [self.tableView reloadData];
}

#pragma mark - About Application Curl
-(IBAction)aboutApp:(id)sender
{
    AboutView *about = [[AboutView alloc] initWithNibName:@"AboutView" bundle:[NSBundle mainBundle]];
    
    about.modalPresentationStyle = UIModalPresentationFullScreen;
    about.modalTransitionStyle = UIModalTransitionStylePartialCurl; 
    
    [self.navigationController presentModalViewController:about animated:YES];
    [about release];
}

#pragma mark - Location Manager Delegate
- (void)locationManager:(CLLocationManager *)manager
	didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    lastLocation = newLocation;
    
    NSString *latlng = [NSString stringWithFormat:@"%f,%f",
                        newLocation.coordinate.latitude,
                        newLocation.coordinate.longitude];
    NSLog(@" %@ ", latlng);
}

#pragma mark - View release
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload
{
    
    [super viewDidUnload];
}

- (void)dealloc
{
    [self.tableView release];
    self.tableView = nil;
    
    [locationManager setDelegate:nil];
    [locationManager release];
    
    [super dealloc];
}


@end
