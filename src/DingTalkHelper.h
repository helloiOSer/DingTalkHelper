//
//  DingTalkHelper.h
//  test2
//
//  Created by fqb on 2017/12/21.
//  Copyright © 2017年 kevliule. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface DTCell : UITableViewCell

@end

@interface DTBaseCellItem : NSObject

@property(nonatomic) double cellHeight; // @synthesize cellHeight=_cellHeight;

@end

@interface DTCellItem : DTBaseCellItem

@property(nonatomic) _Bool isSwitcherOn; // @synthesize isSwitcherOn=_isSwitcherOn;
@property(copy, nonatomic) NSString *textFieldText; // @synthesize textFieldText=_textFieldText;

+ (id)itemWithStyle:(unsigned long long)arg1 cellDidSelectBlock:(id)arg2;
+ (id)cellItemForSelectedStyleWithIcon:(id)arg1 title:(id)arg2 isSelected:(_Bool)arg3 selectedType:(unsigned long long)arg4 cellDidSelectedBlock:(id)arg5;
+ (id)cellItemForTitleOnlyStyleWithTitle:(id)arg1 cellDidSelectedBlock:(id)arg2;
+ (id)cellItemForEditStyleWithTitle:(id)arg1 textFieldHint:(id)arg2 textFieldLimt:(long long)arg3 textFieldHelpBtnNormalImage:(id)arg4 textFieldHelpBtnHighLightImage:(id)arg5 textFieldDidChangeEditingBlock:(id)arg6;
+ (id)cellItemForSwitcherStyleWithTitle:(id)arg1 isSwitcherOn:(_Bool)arg2 switcherValueDidChangeBlock:(id)arg3;
+ (id)cellItemFOrDefaultStyleWithIcon:(id)arg1 title:(id)arg2 titleFont:(id)arg3 detail:(id)arg4 detailFont:(id)arg5 numberOfDetailLine:(long long)arg6 cellDidSelectedBlock:(id)arg7;
+ (id)cellItemForDefaultStyleWithIcon:(id)arg1 title:(id)arg2 image:(id)arg3 showIndicator:(_Bool)arg4 cellDidSelectedBlock:(id)arg5;
+ (id)cellItemForDefaultStyleWithIcon:(id)arg1 title:(id)arg2 detail:(id)arg3 comment:(id)arg4 showBadge:(_Bool)arg5 showIndicator:(_Bool)arg6 cellDidSelectedBlock:(id)arg7;
+ (id)cellItemForDefaultStyleWithIcon:(id)arg1 title:(id)arg2 detail:(id)arg3 comment:(id)arg4 showIndicator:(_Bool)arg5 cellDidSelectedBlock:(id)arg6;
+ (id)cellItemForDefaultStyleWithIcon:(id)arg1 title:(id)arg2 comment:(id)arg3 image:(id)arg4 showIndicator:(_Bool)arg5 cellDidSelectedBlock:(id)arg6;

@end

@interface DTSectionItem : NSObject

@property(copy, nonatomic) id sectionFooterClickBlock; // @synthesize sectionFooterClickBlock=_sectionFooterClickBlock;
@property(copy, nonatomic) id sectionHeaderClickBlock; // @synthesize sectionHeaderClickBlock=_sectionHeaderClickBlock;
@property(copy, nonatomic) NSArray *dataSource; // @synthesize dataSource=_dataSource;

+ (id)itemWithSectionHeader:(NSString *)arg1 sectionFooter:(NSString *)arg2;

@end

@interface DTTableViewDataSource : NSObject

@property(copy, nonatomic) NSArray *tableViewIndexDataSource; // @synthesize tableViewIndexDataSource=_tableViewIndexDataSource;
@property(copy, nonatomic) NSArray *tableViewDataSource; // @synthesize tableViewDataSource=_tableViewDataSource;
- (id)indexTitleAtIndex:(unsigned long long)arg1;
- (id)mutableTableViewIndexDataSource;
- (id)cellItemForSectionIndex:(unsigned long long)arg1 atItemIndex:(unsigned long long)arg2;
- (id)sectionAtIndex:(unsigned long long)arg1;
- (id)mutableTableViewDataSource;

@end

@interface DTTableViewHandler : NSObject

@property(retain, nonatomic) DTTableViewDataSource *dataSource; // @synthesize dataSource=_dataSource;
@property(nonatomic,weak) id delegate; // @synthesize delegate=_delegate;

@end

@interface DTTableViewController : UIViewController

@property(retain, nonatomic) DTTableViewHandler *tableViewHandler; // @synthesize
@property(retain, nonatomic) UITableView *tableView; // @synthesize tableView=_tableView;
@property(retain, nonatomic) DTTableViewDataSource *dataSource;

@end

@interface DTSettingListViewController : DTTableViewController

@end

@class LLPunchConfig,AMapLocationManager;

@interface LLSettingController : DTTableViewController

@property (nonatomic, retain) AMapLocationManager *locationManager;
@property (nonatomic, retain) LLPunchConfig *punchConfig;

- (void)setNavigationBar;
- (void)tidyDataSource;

@end

@interface AMapLocationReGeocode : NSObject

@end

@protocol AMapLocationManagerDelegate <NSObject>

- (void)amapLocationManager:(AMapLocationManager *)arg1 didUpdateLocation:(CLLocation *)arg2 reGeocode:(AMapLocationReGeocode *)arg3;
- (void)amapLocationManager:(AMapLocationManager *)arg1 didUpdateLocation:(CLLocation *)arg2;
- (void)amapLocationManager:(AMapLocationManager *)arg1 didFailWithError:(NSError *)arg2;

@end

@interface AMapLocationManager : NSObject

@property(nonatomic, weak) id <AMapLocationManagerDelegate> delegate; // @synthesize delegate=_delegate;
@property(retain, nonatomic) CLLocationManager *locationManager; // @synthesize locationManager=_locationManager;
@property(nonatomic) double desiredAccuracy;
@property(nonatomic) double distanceFilter;

- (void)startUpdatingLocation;
- (void)stopUpdatingLocation;

- (void)locationManager:(id)arg1 didUpdateLocations:(id)arg2;
- (void)locationManager:(id)arg1 didFailWithError:(id)arg2;

@end
