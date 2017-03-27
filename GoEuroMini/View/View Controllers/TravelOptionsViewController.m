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

@property (weak, nonatomic) IBOutlet UILabel *date;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet TravelModeSelector *travelModeSelector;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sortSelectorBottomConstraint;

@end

@implementation TravelOptionsViewController {
    NSArray <TravelOption *>* busList;
    NSArray <TravelOption *>* flightList;
    NSArray <TravelOption *>* trainList;
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
    for (int i = 0; i < 3; i++) {
        TravelMode travelMode = (TravelMode)i;
        [self fetchTravelOptionsForMode:travelMode];
    }
}

- (void) fetchTravelOptionsForMode:(TravelMode)travelMode
{
    TravelOptionBusiness *travelOptionBusiness = [[TravelOptionBusiness alloc] init];

    [travelOptionBusiness callTravelApiForMode:travelMode onSuccess:^(NSArray *travelData) {
        switch (travelMode) {
            case TravelModeFLIGHT:
                flightList = travelData;
                break;
            case TravelModeTRAIN:
            {
                trainList = travelData;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self loadCurrentSelectionData];
                });}
                break;
            case TravelModeBUS:
                busList = travelData;
                break;
            default:
                break;
        }
    } onFailure:^(NSError *error) {
        //Pick from Cache
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
            displayList = trainList;
            break;
        case TravelModeBUS:
            displayList = busList;
            break;
        case TravelModeFLIGHT:
            displayList = flightList;
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
            trainList = sortedList;
            break;
        case TravelModeBUS:
            busList = sortedList;
            break;
        case TravelModeFLIGHT:
            flightList = sortedList;
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
    currentArray = [currentArray sortedArrayUsingComparator:^NSComparisonResult(TravelOption *object1, TravelOption *object2){
        switch (sortMode) {
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
    [self sortedListForSelectedMode:currentArray];
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
