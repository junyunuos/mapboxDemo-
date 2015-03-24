//
//  MBMViewController.m
//  Mapbox Me
//
//  Copyright (c) 2014 Mapbox, Inc. All rights reserved.
//

#import "MBMViewController.h"

#define kRegularSourceID   @"examples.map-z2effxa8"
#define kTerrainSourceID   @"examples.map-zgrqqx0w"
#define kSatelliteSourceID @"examples.map-zyt2v9k2"

#define kTintColor [UIColor colorWithRed:0.120 green:0.550 blue:0.670 alpha:1.000]

@interface MBMViewController ()

@property (nonatomic, strong) IBOutlet RMMapView *mapView;
@property (nonatomic, strong) IBOutlet UISegmentedControl *segmentedControl;

@end

#pragma mark -

@implementation MBMViewController{


    RMAnnotation * _annotation;
}

@synthesize mapView;
@synthesize segmentedControl;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Mapbox Me";
    
    [self.segmentedControl addTarget:self action:@selector(toggleMode:) forControlEvents:UIControlEventValueChanged];
    [self.segmentedControl setSelectedSegmentIndex:0];
    
    [[UINavigationBar appearance] setTintColor:kTintColor];
    [[UISegmentedControl appearance] setTintColor:kTintColor];
    [[UIToolbar appearance] setTintColor:kTintColor];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    [[RMConfiguration configuration] setAccessToken:@"pk.eyJ1IjoianVzdGluIiwiYSI6IlpDbUJLSUEifQ.4mG8vhelFMju6HpIY-Hi5A"];

    self.mapView.tileSource = [[RMMapboxSource alloc] initWithMapID:kRegularSourceID];
    self.mapView.delegate=self;
    
    
    self.navigationItem.rightBarButtonItem = [[RMUserTrackingBarButtonItem alloc] initWithMapView:self.mapView];

    self.navigationItem.rightBarButtonItem.tintColor = kTintColor;
   // CLLocationCoordinate2D theCenter=CLLocationCoordinate2DMake(30.27, 120.13);
    
    //设置坐标
    CLLocationCoordinate2D theCenter=CLLocationCoordinate2DMake(39.9 , 116.3);
    
    
   [mapView setCenterCoordinate:theCenter animated:YES];
    _annotation = [RMAnnotation annotationWithMapView:mapView coordinate:theCenter andTitle:@"杭州黄龙体育馆"];
    [mapView addAnnotation:_annotation];
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait || [UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad);
}

#pragma mark -
- (void)toggleMode:(UISegmentedControl *)sender
{
    NSString *mapID;
    
    if (sender.selectedSegmentIndex == 2)
        mapID = kSatelliteSourceID;
    else if (sender.selectedSegmentIndex == 1)
        mapID = kTerrainSourceID;
    else if (sender.selectedSegmentIndex == 0)
        mapID = kRegularSourceID;
    
    self.mapView.tileSource = [[RMMapboxSource alloc] initWithMapID:mapID];
}

- (RMMapLayer *)mapView:(RMMapView *)mapView layerForAnnotation:(RMAnnotation *)annotation
{
    RMMarker *marker = [[RMMarker alloc] initWithMapboxMarkerImage:@"embassy"];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 32)];
    
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    imageView.image = annotation.userInfo;
    marker.leftCalloutAccessoryView = imageView;
    marker.canShowCallout = YES;
    return marker;
}

@end