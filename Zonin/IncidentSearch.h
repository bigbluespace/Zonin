//
//  IncidentSearch.h
//  Zonin
//
//  Created by Admin on 28/09/15.
//  Copyright © 2015 UBITRIX. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomToolbar.h"
#import "Country.h"

@interface IncidentSearch : UIViewController<CustomToolbarDelegate,UIPickerViewDataSource, UIPickerViewDelegate>

@property Country*currentCountry;
@property Country*currentState;
@property Country*currentParish;

@property BOOL isIncident;


@end
