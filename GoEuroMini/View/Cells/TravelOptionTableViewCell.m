//
//  TravelOptionTableViewCell.m
//  GoEuroMini
//
//  Created by Sasha on 26/03/17.
//  Copyright © 2017 ShwtMhjn. All rights reserved.
//

#import "TravelOptionTableViewCell.h"
#import "GoEuroMini-Swift.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface TravelOptionTableViewCell () {
}

@property (weak, nonatomic) IBOutlet UILabel *duration;
@property (weak, nonatomic) IBOutlet UIImageView *providerImage;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *noOfStops;
@property (weak, nonatomic) IBOutlet UILabel *time;

@end

@implementation TravelOptionTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


+ (NSString *)cellIdentifier
{
    return NSStringFromClass([self class]);
}

+ (void)registerWithTableView:(UITableView *)tableView
{
    [tableView registerNib:[UINib nibWithNibName:[TravelOptionTableViewCell cellIdentifier] bundle:[NSBundle mainBundle]] forCellReuseIdentifier:[TravelOptionTableViewCell cellIdentifier]];
}

+ (CGFloat)cellHeight
{
    return 100;
}


- (void) setUpCellWithTravelResultItem:(id)item
{
    TravelOption *travelOption = (TravelOption *) item;
    [self setUpPriceLabel:travelOption.priceInEuros];
    [self setUpStopsLabel:travelOption.numberOfStops];
    [self setUpTravelTimeAndDuration:travelOption];
    NSURL *url = travelOption.providerLogoUrl;
    [self.providerImage sd_setImageWithURL:url placeholderImage:[UIImage imageNamed: @"fly"]];
//    [self.providerImage sd_setImageWithURL:url];//travelOption.providerLogoUrl];
    
}

- (void) setUpPriceLabel : (NSString *) priceInEuros
{
    NSRange range = [priceInEuros rangeOfString:@"."];
    range.length = priceInEuros.length - range.location;
    NSDictionary *beforeDecimalAttributes = @{ NSFontAttributeName : [UIFont systemFontOfSize:18],
                                               NSForegroundColorAttributeName : [UIColor blackColor] };
    NSDictionary *afterDecimalAttributes = @{ NSFontAttributeName : [UIFont systemFontOfSize:14],
                                              NSForegroundColorAttributeName : [UIColor blackColor] };
    
    NSMutableAttributedString *attributedPriceString = [[NSMutableAttributedString alloc] initWithString:priceInEuros attributes:beforeDecimalAttributes];
    [attributedPriceString setAttributes:afterDecimalAttributes range:range];
    self.price.attributedText = attributedPriceString;
}

- (void) setUpStopsLabel : (NSNumber *) stops
{
    if(stops && [stops intValue]>0)
    {
        self.noOfStops.text = [NSString stringWithFormat:@"%d stops",[stops intValue]];
        if([stops intValue] == 1)
        {
            self.noOfStops.text = @"1 stop";
        }
    }
    else
    {
        self.noOfStops.text = @"Direct";
    }
}

- (void) setUpTravelTimeAndDuration : (TravelOption *)item
{
    NSString *travelTime = [NSString stringWithFormat:@"%@ - %@",item.departureTime, item.arrivalTime];
    NSString *hours = [[item.departureTime componentsSeparatedByString:@":"] firstObject];
    int totalHours = hours.intValue + item.duration.intValue;
    int days = totalHours / 24;
    if(days > 0)
    {
        travelTime = [travelTime stringByAppendingString:[NSString stringWithFormat:@"(+%d)", days]];
    }
    self.time.text = travelTime;
    self.duration.text = item.duration;
}



@end
