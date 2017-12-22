#import "DingTalkHelper.h"
#import "LLPunchConfig.h"
#import "LLPunchManager.h"

%hook LAWebViewContainer
- (BOOL)pluginInstance:(id)arg1 jsapiShouldCall:(id)arg2{
    //objc_msgSend(self,@selector(showText:y:),[NSString stringWithFormat:@"%s,%@",__FUNCTION__,arg2],200);
    return %orig;
}
%end

%hook DTWebViewController

- (BOOL)pluginInstance:(id)arg1 jsapiShouldCall:(id)arg2{
    //objc_msgSend(self,@selector(showText:y:),[NSString stringWithFormat:@"%s",__FUNCTION__],100);
    return YES;
}

%end

%hook LAPluginInstanceCollector

- (void)handleJavaScriptRequest:(id)arg2 callback:(void(^)(id dic))arg3{
    if(![LLPunchManager shared].punchConfig.isOpenPunchHelper){
        %orig;
    } else if([arg2[@"action"] isEqualToString:@"getInterface"]){
        id callback = ^(id dic){
            NSDictionary *retDic = @{
                @"errorCode" : @"0",
                @"errorMessage": @"",
                @"keep": @"0",
                @"result": @{
                    @"macIp": [LLPunchManager shared].punchConfig.wifiMacIp,
                    @"ssid": [LLPunchManager shared].punchConfig.wifiName
                }
            };
            arg3(![LLPunchManager shared].punchConfig.isLocationPunchMode ? retDic : dic);
        };
        %orig(arg2,callback);
    } else if([arg2[@"action"] isEqualToString:@"start"]){
        id callback = ^(id dic){
            NSDictionary *retDic = @{
                @"errorCode" : @"0",
                @"errorMessage": @"",
                @"keep": @"1",
                @"result": @{
                    @"aMapCode": @"0",
                    @"accuracy": [LLPunchManager shared].punchConfig.accuracy,
                    @"latitude": [LLPunchManager shared].punchConfig.latitude,
                    @"longitude": [LLPunchManager shared].punchConfig.longitude,
                    @"netType": @"",
                    @"operatorType": @"unknown",
                    @"resultCode": @"0",
                    @"resultMessage": @""
                }
            }; 
            arg3([LLPunchManager shared].punchConfig.isLocationPunchMode ? retDic : dic);
        };
        %orig(arg2,callback);
    } else {
        %orig;
    }
}

%end

%hook DTSettingListViewController

- (void)tidyDatasource{
    %orig;
    DTCellItem *cellItem = [%c(DTCellItem) cellItemForDefaultStyleWithIcon:nil title:@"钉钉小助手" image:nil showIndicator:YES cellDidSelectedBlock:^{
        LLSettingController *settingVC = [[%c(LLSettingController) alloc] init];
        [self.navigationController pushViewController:settingVC animated:YES];
    }];
    DTSectionItem *sectionItem = [%c(DTSectionItem) itemWithSectionHeader:nil sectionFooter:nil];
    NSMutableArray *sectionDataSource = [NSMutableArray array];
    [sectionDataSource addObject:cellItem];
    sectionItem.dataSource = sectionDataSource;
    NSMutableArray *dataSourceArr = [self.dataSource.tableViewDataSource mutableCopy];
    [dataSourceArr insertObject:sectionItem atIndex:0];
    self.dataSource.tableViewDataSource = dataSourceArr;
}

%end

%subclass LLSettingController : DTTableViewController <AMapLocationManagerDelegate>

%property (nonatomic, retain) AMapLocationManager *locationManager;
%property (nonatomic, retain) LLPunchConfig *punchConfig;

- (id)init{
    self = %orig;
    if(self){
        self.locationManager = [[%c(AMapLocationManager) alloc] init];
        self.locationManager.delegate = (id<AMapLocationManagerDelegate>)self;
        self.punchConfig = [[LLPunchManager shared].punchConfig copy];
    }
    return self;
}

- (void)viewDidLoad {
    %orig;

    [self setNavigationBar];
    [self tidyDataSource];
}

%new
- (void)setNavigationBar{
    self.title = @"钉钉小助手";
    self.view.backgroundColor = [UIColor whiteColor];
}

%new
- (void)tidyDataSource{
    NSMutableArray <DTSectionItem *> *sectionItems = [NSMutableArray array];
    
    DTCellItem *openPunchCellItem = [NSClassFromString(@"DTCellItem") cellItemForSwitcherStyleWithTitle:@"是否开启打卡助手" isSwitcherOn:self.punchConfig.isOpenPunchHelper switcherValueDidChangeBlock:^(DTCellItem *item,DTCell *cell,UISwitch *aSwitch){
        self.punchConfig.isOpenPunchHelper = aSwitch.on;
    }];
    DTCellItem *punchModeCellItem = [NSClassFromString(@"DTCellItem") cellItemForSwitcherStyleWithTitle:@"打卡模式定位/WIFI" isSwitcherOn:self.punchConfig.isLocationPunchMode switcherValueDidChangeBlock:^(DTCellItem *item,DTCell *cell,UISwitch *aSwitch){
        self.punchConfig.isLocationPunchMode = aSwitch.on;
    }];
    DTSectionItem *switchSectionItem = [NSClassFromString(@"DTSectionItem") itemWithSectionHeader:nil sectionFooter:nil];
    switchSectionItem.dataSource = @[openPunchCellItem,punchModeCellItem];
    [sectionItems addObject:switchSectionItem];
    
    NSArray <NSString *> *titles = @[@"Wi-Fi 名称",@"Wi-Fi MAC地址",@"精度",@"经度",@"纬度"];
    NSArray <NSString *> *hints  = @[@"请输入Wi-Fi名称",@"请输入Wi-Fi MAC地址",@"请输入定位精度",@"请输入定位经度",@"请输入定位纬度"];
    NSArray <NSString *> *texts    = @[self.punchConfig.wifiName?:@"",self.punchConfig.wifiMacIp?:@"",self.punchConfig.accuracy?:@"",self.punchConfig.latitude?:@"",self.punchConfig.longitude?:@""];
    
    NSMutableArray <DTCellItem *> *cellItems = [NSMutableArray array];

    for (int i = 0; i < 5; i++) {
        DTCellItem *cellItem = [NSClassFromString(@"DTCellItem") cellItemForEditStyleWithTitle:titles[i] textFieldHint:hints[i] textFieldLimt:NSIntegerMax textFieldHelpBtnNormalImage:nil textFieldHelpBtnHighLightImage:nil textFieldDidChangeEditingBlock:^(DTCellItem *item,DTCell *cell,UITextField *textField){
            switch(i){
                case 0:
                    self.punchConfig.wifiName = textField.text;
                    break;
                case 1:
                    self.punchConfig.wifiMacIp = textField.text;
                    break;
                case 2:
                    self.punchConfig.accuracy = textField.text;
                    break;
                case 3:
                    self.punchConfig.latitude = textField.text;
                    break;
                case 4:
                    self.punchConfig.longitude = textField.text;
                    break;
            }
        }];
        cellItem.textFieldText = texts[i];
        [cellItems addObject:cellItem];
        if (i == 1 || i== 4) {
            DTSectionItem *sectionItem = [NSClassFromString(@"DTSectionItem") itemWithSectionHeader:nil sectionFooter:nil];
            sectionItem.dataSource = cellItems;
            [sectionItems addObject:sectionItem];
            if (i == 1) {
                cellItems = [NSMutableArray array];
            }
        }
    }
    
    DTCellItem *locationCellItem = [NSClassFromString(@"DTCellItem") cellItemForTitleOnlyStyleWithTitle:@"开始定位" cellDidSelectedBlock:^{
        if(![[LLPunchManager shared] isLocationAuth]){
            [[LLPunchManager shared] showMessage:@"请先打开钉钉定位权限" completion:^(BOOL isClickConfirm){
                if(isClickConfirm){
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                }
            }];
            return;
        }
        [self.locationManager startUpdatingLocation];
    }];
    DTCellItem *wifiCellItem = [NSClassFromString(@"DTCellItem") cellItemForTitleOnlyStyleWithTitle:@"开始识别Wi-Fi" cellDidSelectedBlock:^{
        NSDictionary *ssidInfoDic = [[LLPunchManager shared] SSIDInfo];
        NSString *wifiName = ssidInfoDic[@"SSID"];
        NSString *wifiMac = ssidInfoDic[@"BSSID"];
        if (!wifiName.length || !wifiMac){
            [[LLPunchManager shared] showMessage:@"请先连接打卡WI-FI" completion:^(BOOL isClickConfirm){
                if(isClickConfirm){
                    //跳转到系统wifi列表
                    [[LLPunchManager shared] jumpToWifiList];
                }
            }];
            return;
        }
        self.punchConfig.wifiName = wifiName;
        self.punchConfig.wifiMacIp = wifiMac;
        //刷新页面
        [self tidyDataSource];
    }];
    DTSectionItem *recognizeSectionItem = [NSClassFromString(@"DTSectionItem") itemWithSectionHeader:nil sectionFooter:nil];
    recognizeSectionItem.dataSource = @[locationCellItem,wifiCellItem];
    [sectionItems addObject:recognizeSectionItem];

    DTCellItem *saveCellItem = [NSClassFromString(@"DTCellItem") cellItemForTitleOnlyStyleWithTitle:@"保存" cellDidSelectedBlock:^{
        [[LLPunchManager shared] saveUserSetting:self.punchConfig];
        [self.navigationController popViewControllerAnimated:YES];
    }];
    DTSectionItem *saveSectionItem = [NSClassFromString(@"DTSectionItem") itemWithSectionHeader:nil sectionFooter:nil];
    saveSectionItem.dataSource = @[saveCellItem];
    [sectionItems addObject:saveSectionItem];
    
    DTTableViewDataSource *dataSource = [[NSClassFromString(@"DTTableViewDataSource") alloc] init];
    dataSource.tableViewDataSource = sectionItems;
    self.dataSource = dataSource;

    [self.tableView reloadData];
}

%new
- (void)amapLocationManager:(AMapLocationManager *)arg1 didUpdateLocation:(id)arg2 reGeocode:(id)arg3{
    [self.locationManager stopUpdatingLocation];
    CLLocation *location = (CLLocation *)arg2;
    self.punchConfig.latitude  = [NSString stringWithFormat:@"%@",@(location.coordinate.latitude)];
    self.punchConfig.longitude = [NSString stringWithFormat:@"%@",@(location.coordinate.longitude)];
    self.punchConfig.accuracy  = [NSString stringWithFormat:@"%@",@(fmax(location.horizontalAccuracy,location.verticalAccuracy))];
    //刷新页面
    [self tidyDataSource];
}

%end
