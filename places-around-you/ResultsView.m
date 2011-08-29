//
//  ResultsView.m
//  places-around-you
//
//  Created by Enzo Zuccolotto on 6/19/11.
//  Copyright 2011 Universidade do Vale do Rio dos Sinos. All rights reserved.
//

#import "ResultsView.h"
#import "ASIHTTPRequest.h"
#import "JSON.h"
#import "MBProgressHUD.h"
#import "AsyncImageView.h"
#import "PlaceView.h"

@implementation ResultsView


@synthesize distance, location, query;

#pragma mark - View lifecycle
-(void)startLoadingData
{
    
    NSURL *url = nil;
    NSMutableString *searchURL = nil; 
    NSString *qParameter = [query stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    if(location != nil && distance != nil){
        NSString *searchWithGPS = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"SearchPlacesWithPoints"];
        searchURL = [[NSMutableString alloc] initWithString:searchWithGPS];
        
        [searchURL appendString:@"?type=json"];
        [searchURL appendString:@"&limit=20"];        
        [searchURL appendString:@"&q="];
        [searchURL appendString:qParameter];
        
        NSString *lat = [[NSString alloc] initWithFormat:@"%f", location.coordinate.latitude];
        NSString *lng = [[NSString alloc] initWithFormat:@"%f", location.coordinate.longitude];
        NSString *rad = [[NSString alloc] initWithFormat:@"%i", [distance intValue]];

        [searchURL appendString:@"&lat="];
        [searchURL appendString:lat];
        [searchURL appendString:@"&lng="];  
        [searchURL appendString:lng];
        [searchURL appendString:@"&radius_mt="];  
        [searchURL appendString:rad];

        
        [lat release];
        [lng release];
        [rad release];
        
        
    }else{
        NSString *searchWithoutGPS = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"SearchPlaces"];
        searchURL = [[NSMutableString alloc] initWithString:searchWithoutGPS];
    
        [searchURL appendString:@"?type=json"];
        [searchURL appendString:@"&limit=20"];
        [searchURL appendString:@"&q="];
        [searchURL appendString:qParameter];
        
        
    }
        
//    NSLog(@"URL : %@", searchURL);
    
    url = [NSURL URLWithString:searchURL];

   
    NSString *username = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"ConsumerKey"];
    NSString *password = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"ConsumerSecret"];
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request setDelegate:self];
    [request addBasicAuthenticationHeaderWithUsername:username andPassword:password];
    [request startAsynchronous];
    [searchURL release];
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSString *stringData = [[NSString alloc] initWithData:[request responseData] encoding:NSUTF8StringEncoding];        
//    NSLog(@" %@", stringData);
    NSDictionary *result = [[stringData JSONValue] retain];
    NSDictionary *search = [result objectForKey:@"search"];
    
    results = [[search objectForKey:@"places"] retain];
        
    [stringData release];
    [result release];
    [HUD hide:YES];
    [self.tableView reloadData];
    
}

-(void)startLoadingView
{
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:HUD];
    HUD.delegate = self;
    [HUD show:YES];
}

- (void)viewDidLoad
{
    [self startLoadingView];
    [self startLoadingData];
    
    [self.navigationItem setTitle:@"Results"];
    [super viewDidLoad];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [results count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    NSDictionary *place = [[results objectAtIndex:indexPath.row] objectForKey:@"place"];
    
    AsyncImageView *imgView = nil;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
        imgView = [[AsyncImageView alloc] initWithFrame:CGRectMake(5, 5, 60, 60)];
        [imgView setTag:10];
        [cell.contentView addSubview:imgView];
        
        [cell.imageView setImage:[UIImage imageNamed:@"avatar_apontador.png"]];
        
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        
    } else {
        imgView = (AsyncImageView *) [cell.contentView viewWithTag:10];
    }

    [cell.textLabel setText:[place objectForKey:@"name"]];
    
    NSMutableString *address = [[place objectForKey:@"address"] objectForKey:@"street"];
    [address appendString:[[place objectForKey:@"address"] objectForKey:@"number"]];
    [cell.detailTextLabel setText:address];
    
    NSString *photo = [place objectForKey:@"icon_url"];
    
    [imgView loadFromUrl:photo];

    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIView *v = [cell.contentView viewWithTag:10];
    [cell.contentView bringSubviewToFront:v];
}



#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *place = [[results objectAtIndex:indexPath.row] objectForKey:@"place"];
//    NSLog(@" Sending to place view: %@ ", place);
    
    PlaceView *view = [[PlaceView alloc] initWithNibName:@"PlaceView" bundle:[NSBundle mainBundle]];
    view.place = place;
    [self.navigationController pushViewController:view animated:YES];
    [place release];
    [view release];
}


#pragma mark - Release View
- (void)dealloc
{
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload
{    
    [super viewDidUnload];
}


#pragma mark - Loaging view
- (void)hudWasHidden:(MBProgressHUD *)hud
{
    [HUD removeFromSuperview];
    [HUD release];
    HUD = nil;
}


@end
