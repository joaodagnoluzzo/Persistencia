//
//  PERMapViewController.m
//  Persistencia
//
//  Created by João Pedro Cappelletto D'Agnoluzzo on 2/27/14.
//  Copyright (c) 2014 João Pedro Cappelletto D'Agnoluzzo. All rights reserved.
//

#import "PERMapViewController.h"

@interface PERMapViewController ()

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property MKPointAnnotation *dropPin;

@end

@implementation PERMapViewController{
    BOOL firstTimeRenderingMap;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    firstTimeRenderingMap = YES;
    [self.mapView setShowsUserLocation:YES];
    [self.mapView setShowsBuildings:YES];
    [self.mapView setShowsPointsOfInterest:YES];
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    
    self.dropPin = [[MKPointAnnotation alloc] init];
    self.dropPin.coordinate = self.taskLocation;
    [self.dropPin setTitle:self.pinTitle];
    
    
    if(self.dropPin.coordinate.latitude==0){
    
        [self noLocation];
    }
    
    [self.mapView addAnnotation:self.dropPin];
    
    
    
}

- (IBAction)doneAction:(UIButton *)sender {
    
    self.taskLocation = CLLocationCoordinate2DMake(0, 0);
    [self.mapView removeAnnotation:self.dropPin];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"closeMap" object:self];
    
}

-(void)noLocation{
    self.taskLocation = CLLocationCoordinate2DMake(0, 0);
    [[NSNotificationCenter defaultCenter] postNotificationName:@"noLocation" object:self];
}

-(void)mapViewDidFinishRenderingMap:(MKMapView *)mapView fullyRendered:(BOOL)fullyRendered{

    if(firstTimeRenderingMap){
        MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(self.mapView.userLocation.coordinate,1000, 1000);
        [self.mapView setRegion:viewRegion animated:YES];
        firstTimeRenderingMap = NO;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
