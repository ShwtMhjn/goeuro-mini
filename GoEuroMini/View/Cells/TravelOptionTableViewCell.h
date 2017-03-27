//
//  TravelOptionTableViewCell.h
//  GoEuroMini
//
//  Created by Sasha on 26/03/17.
//  Copyright © 2017 ShwtMhjn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TravelOptionTableViewCell : UITableViewCell

+ (NSString *)cellIdentifier;
+ (void)registerWithTableView:(UITableView *)tableView;
+ (CGFloat)cellHeight;
- (void) setUpCellWithTravelResultItem:(id)item;


@end
