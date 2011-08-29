//
//  PlaceView.m
//  places-around-you
//
//  Created by Enzo Zuccolotto on 6/20/11.
//  Copyright 2011 Universidade do Vale do Rio dos Sinos. All rights reserved.
//

#import "PlaceView.h"
#import "AsyncImageView.h"


@implementation PlaceView

@synthesize place;

- (void)dealloc
{
    [webpageButton release];
    webpageButton = nil;
    [mapsButton release];
    mapsButton = nil;

//    [place release];
//    place = nil;
    
//    [self.tableView release];

    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

-(void)setupMapButton
{
    NSDictionary *location = [place objectForKey:@"point"];
    if(location != nil)
    {
        NSString *latCheck= [[location objectForKey:@"lat"] stringByTrimmingCharactersInSet:[NSCharacterSet  whitespaceAndNewlineCharacterSet]];
        
        NSString *lngCheck= [[location objectForKey:@"lng"] stringByTrimmingCharactersInSet:[NSCharacterSet  whitespaceAndNewlineCharacterSet]];
        
        if((latCheck != nil && ![latCheck isEqualToString:@""] ) && (lngCheck != nil && ![lngCheck isEqualToString:@""]))
        {
            mapsButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            [mapsButton setTitle:@"See om map" forState:UIControlStateNormal];
            [mapsButton setFrame:CGRectMake(0, 0, 300, 45)];
            [mapsButton addTarget:self action:@selector(openMapsURL:) forControlEvents:(UIControlEvents)UIControlEventTouchDown];
            [mapsButton retain];
        }  
    }
}

-(void)setupWebpageButton
{
    NSString *url= [[place objectForKey:@"main_url"] stringByTrimmingCharactersInSet:[NSCharacterSet  whitespaceAndNewlineCharacterSet]];
    
    if(url != nil && ![url isEqualToString:@""]){
        webpageButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [webpageButton setTitle:@"Site" forState:UIControlStateNormal];
        [webpageButton setFrame:CGRectMake(0, 0, 300, 45)];
        [webpageButton addTarget:self action:@selector(openWebpage:) forControlEvents:(UIControlEvents)UIControlEventTouchUpInside];
        [webpageButton retain];
    }
}

-(void)setupButtons
{
    [self setupWebpageButton];
    
    [self setupMapButton];
}

- (void)viewDidLoad
{
    [place retain];
    [self setupButtons];
    
    [super viewDidLoad];
}

- (void)viewDidUnload
{

    [self.tableView release];
    [super viewDidUnload];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if(section < 2)
    {
        return 2;
    }else
        return 0;
                
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    
    if(indexPath.section == 0)
    {
        if(indexPath.row == 0)
        {
            [cell.textLabel setText:[place objectForKey:@"name"]];
        }
        else if(indexPath.row == 1)
        {
            NSMutableString *address = [[place objectForKey:@"address"] objectForKey:@"street"];
            [address appendString:[[place objectForKey:@"address"] objectForKey:@"number"]];
            [cell.textLabel setText:address];
        }
    }
    else if(indexPath.section == 1)
    {
        if(indexPath.row == 0 )
        {
            if (webpageButton != nil) {
                [cell setBackgroundColor:[UIColor clearColor]];
                [cell.contentView addSubview:webpageButton];
            }else{
                [cell.textLabel setText:@"Homepage not available"];
            }
        }
        else if(indexPath.row == 1)
        {
            if (mapsButton != nil) {
                [cell setBackgroundColor:[UIColor clearColor]];
                [cell.contentView addSubview:mapsButton];
            }else{
                [cell.textLabel setText:@"Maps not available"];
            }

        }
    }
    
    return cell;
}

#pragma mark - open buttons
-(IBAction)openMapsURL:(id)sender
{
    NSMutableString *stringURL = [NSMutableString stringWithString:@"http://maps.google.com/maps?ll="];

    NSString *lat = [[[place objectForKey:@"point"] objectForKey:@"lat"] autorelease];
    NSString *lng = [[[place objectForKey:@"point"] objectForKey:@"lng"] autorelease];
    
    [stringURL appendString:lat];
    [stringURL appendString:lng];
    
    UIApplication *app = [UIApplication sharedApplication];
    NSURL *url = [NSURL URLWithString:stringURL];
    
    if([app canOpenURL:url]){
        [app openURL:url];
    }else{
        //alert
    }
    
}

-(IBAction)openWebpage:(id)sender
{
    NSURL *url = [NSURL URLWithString:[place objectForKey:@"main_url"]];
    UIApplication *app = [UIApplication sharedApplication];
    
    if([app canOpenURL:url]){
        [app openURL:url];
    }else{
        //alert
    }
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

@end
