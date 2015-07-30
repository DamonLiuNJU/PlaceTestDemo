//
//  ViewController.m
//  PlaceTest
//
//  Created by DamonLiu on 15/7/29.
//  Copyright (c) 2015年 DamonLiu. All rights reserved.
//

#import "ViewController.h"
#import "AMapSearchAPI.h"
#import <MapKit/MapKit.h>
//#import "AMapGeoPoint.h"
@interface ViewController ()<AMapSearchDelegate>
@property (nonatomic, strong) CLGeocoder *geocoder;
@end

@implementation ViewController
{
    __weak IBOutlet UITextField *lantitude;
    AMapSearchAPI *_search;
    __weak IBOutlet UITextField *longtitude;
    __weak IBOutlet UITextView *label;
    AMapReGeocodeSearchRequest *regeoRequest ;
    __weak IBOutlet UITextField *place_name;
    __weak IBOutlet UITextView *label2;
    __weak IBOutlet UIButton *searchByNamePressed;
    IBOutlet UIView *view2;
    
}

//- (void)viewDidLoad {
//    [super viewDidLoad];
//    // Do any additional setup after loading the view, typically from a nib.
- (IBAction)searchByName:(id)sender {
    [self hideKeyboard];
    NSString* address = [place_name text];
    AMapGeocodeSearchRequest *geoRequest = [[AMapGeocodeSearchRequest alloc] init];
    geoRequest.searchType = AMapSearchType_Geocode;
    geoRequest.address = address;
//    geoRequest.city = @[@"beijing"];
    //发起正向地理编码
    [_search AMapGeocodeSearch: geoRequest];
}
//}
//实现正向地理编码的回调函数
- (void)onGeocodeSearchDone:(AMapGeocodeSearchRequest *)request response:(AMapGeocodeSearchResponse *)response
{
    if(response.geocodes.count == 0)
    {
        return;
    }
    
    //通过AMapGeocodeSearchResponse对象处理搜索结果
    NSString *strCount = [NSString stringWithFormat:@"count: %d", response.count];
    NSString *strGeocodes = @"";
    for (AMapTip *p in response.geocodes) {
        strGeocodes = [NSString stringWithFormat:@"%@\ngeocode: %@", strGeocodes, p.description];
    }
    NSString *result = [NSString stringWithFormat:@"%@ \n %@", strCount, strGeocodes];
//    NSLog(@"Geocode: %@", result);
    [label2 setText:result];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewDidLoad
{
    [super viewDidLoad];
    
    //apple's service
    self.geocoder = [[CLGeocoder alloc] init];
    
    
    
    //初始化检索对象
    _search = [[AMapSearchAPI alloc] initWithSearchKey:@"6374bcd2a4f8f8659a3fc915dc0d7185" Delegate:self];
    regeoRequest = [[AMapReGeocodeSearchRequest alloc] init];
    //构造AMapReGeocodeSearchRequest对象，location为必选项，radius为可选项
   
    regeoRequest.searchType = AMapSearchType_ReGeocode;
    
    regeoRequest.radius = 10000;
    regeoRequest.requireExtension = YES;
    
    //发起逆地理编码
    UIGestureRecognizer* rec = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideKeyboard)];
    [self.view addGestureRecognizer:rec];
    [view2 addGestureRecognizer:rec];
    [self layoutSubViews];
}
-(void)hideKeyboard{
    [lantitude resignFirstResponder];
    [longtitude resignFirstResponder];
    [place_name resignFirstResponder];
//    [self resignFirstResponder];
}
-(void)layoutSubViews{
    CGRect frame = [UIScreen mainScreen].bounds;
    [longtitude setFrame:CGRectMake(longtitude.frame.origin.x
                                    , longtitude.frame.origin.y, frame.size.width/2-40, longtitude.frame.size.height)];
    [lantitude setFrame:CGRectMake(longtitude.frame.origin.x
                                   +longtitude.frame.size.width+20, lantitude.frame.size.height, frame.size.width/2-40, longtitude.frame.size.height)];
    
    [label setFrame:CGRectMake(label.frame.origin.x
                               ,label.frame.origin.y, frame.size.width/2, label.frame.size.height)];
    
}
- (IBAction)buttonPressed:(id)sender {
    [self hideKeyboard];
    [label setText:@""];
    regeoRequest.location = [AMapGeoPoint locationWithLatitude:lantitude.text.floatValue longitude:longtitude.text.floatValue];
    [_search AMapReGoecodeSearch: regeoRequest];
}


//实现逆地理编码的回调函数
- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response
{
    if(response.regeocode != nil)
    {
        //通过AMapReGeocodeSearchResponse对象处理搜索结果
        NSString *result = [NSString stringWithFormat:@"ReGeocode: %@", response.regeocode];
//        NSLog(@"ReGeo: %@", result);
        [label setText:result];
    }
}

@end
