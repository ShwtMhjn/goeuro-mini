//
//  TravelOptionsViewController.m
//  GoEuroMini
//
//  Created by Sasha on 25/03/17.
//  Copyright © 2017 ShwtMhjn. All rights reserved.
//

#import "TravelOptionsViewController.h"
#import "GoEuroMini-Swift.h"
#import "TravelOptionBusiness.h"
#import "TravelOptionTableViewCell.h"

@interface TravelOptionsViewController () <UITableViewDelegate, UITableViewDataSource, TravelModeSelectorDelegate>

@property (nonatomic) IBOutlet UILabel *date;
@property (nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) IBOutlet TravelModeSelector *travelModeSelector;
@property (nonatomic) IBOutlet NSLayoutConstraint *sortSelectorBottomConstraint;

@property (nonatomic) NSArray <TravelOption *>* busList;
@property (nonatomic) NSArray <TravelOption *>* flightList;
@property (nonatomic) NSArray <TravelOption *>* trainList;
@end

@implementation TravelOptionsViewController {
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _travelModeSelector.delegate = self;
    [self setUpNavigationBar];
    [self fetchAllTravelOptions];
    [TravelOptionTableViewCell registerWithTableView:self.tableView];
}

- (void) fetchAllTravelOptions {
    [self fetchFlightOptions];
    [self fetchBusOptions];
    [self fetchTrainOptions];
}

- (void)fetchFlightOptions
{
    TravelOptionBusiness *travelOptionBusiness = [[TravelOptionBusiness alloc] init];
    [travelOptionBusiness callTravelApiForMode:TravelModeFLIGHT onSuccess:^(NSArray *travelData) {
        self.flightList = (NSArray *) travelData;
    } onFailure:^(NSError *error) {
        //Failed when even Cache is not there and connection has failed
    }];
}

- (void)fetchBusOptions
{
    TravelOptionBusiness *travelOptionBusiness = [[TravelOptionBusiness alloc] init];
    [travelOptionBusiness callTravelApiForMode:TravelModeBUS onSuccess:^(NSArray *travelData) {
        self.busList = (NSArray *) travelData;
    } onFailure:^(NSError *error) {
        //Failed when even Cache is not there and connection has failed
    }];
}

- (void)fetchTrainOptions
{
    TravelOptionBusiness *travelOptionBusiness = [[TravelOptionBusiness alloc] init];
    [travelOptionBusiness callTravelApiForMode:TravelModeTRAIN onSuccess:^(NSArray *travelData) {
        self.trainList = (NSArray *) travelData;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self loadCurrentSelectionData];
        });
    } onFailure:^(NSError *error) {
        //Failed when even Cache is not there and connection has failed
    }];
}

- (void)loadCurrentSelectionData
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
        [self.tableView setContentOffset:CGPointZero animated:NO];
    });
}

- (NSArray <TravelOption *>*) listForSelectedMode
{
    NSArray *displayList;
    switch (_travelModeSelector.selectedTravelMode) {
        case TravelModeTRAIN:
            displayList = self.trainList;
            break;
        case TravelModeBUS:
            displayList = self.busList;
            break;
        case TravelModeFLIGHT:
            displayList = self.flightList;
            break;
        default:
             displayList = nil;
    }
    return displayList;
}


- (void) sortedListForSelectedMode:(NSArray *)sortedList
{
    switch (_travelModeSelector.selectedTravelMode) {
        case TravelModeTRAIN:
            self.trainList = sortedList;
            break;
        case TravelModeBUS:
            self.busList = sortedList;
            break;
        case TravelModeFLIGHT:
            self.flightList = sortedList;
            break;
        default:
            nil;
    }
    [self loadCurrentSelectionData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -- Navigation Bar --
- (void) setUpNavigationBar
{
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMM dd"];
    _date.text =  [formatter stringFromDate:[NSDate date]];
}

#pragma mark -- Travel Mode Selector --
-(void)travelModeSelectorWithMenuView:(TravelModeSelector *)menuView didSelectItem:(enum TravelMode)item
{
    [self loadCurrentSelectionData];
}

#pragma mark -- Sort --
- (IBAction)sortTapped:(id)sender {
    if (self.sortSelectorBottomConstraint.constant == 0.0f) {
        self.sortSelectorBottomConstraint.constant = 44.0f;
    }
    else
    {
        self.sortSelectorBottomConstraint.constant = 0.0f;
    }
    [self sortParameterTapped:nil];
    [UIView animateWithDuration:0.2 animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (IBAction)sortParameterTapped:(id)sender
{
    UISegmentedControl *segmentedControl = (UISegmentedControl *)sender;
    SortBy sortMode = (SortBy)segmentedControl.selectedSegmentIndex;
    NSArray *currentArray = [self listForSelectedMode];
    currentArray = [self sortedList:currentArray sortType:sortMode];
    [self sortedListForSelectedMode:currentArray];
}

-(NSArray <TravelOption * >*)sortedList:(NSArray <TravelOption * >*)list
                            sortType:(SortBy)sortType {
    list = [list sortedArrayUsingComparator:^NSComparisonResult(TravelOption *object1, TravelOption *object2){
        switch (sortType) {
            case SortByPRICE:
                return [object1.priceInEuros compare:object2.priceInEuros];
                break;
                
            case SortByDURATION:
                return [object1.duration compare:object2.duration];
                break;
                
            case SortByDEPARTURE:
                return [object1.departureTime compare:object2.departureTime];
                break;
                
            default:
                break;
        }
    }];
    
    return list;
}

#pragma mark UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.listForSelectedMode.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TravelOptionTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:[TravelOptionTableViewCell cellIdentifier] forIndexPath:indexPath];
    TravelOption *travelOption = [self.listForSelectedMode objectAtIndex:indexPath.row];
    [cell setUpCellWithTravelResultItem:travelOption];
    return cell;
}

#pragma mark UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [TravelOptionTableViewCell cellHeight];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
