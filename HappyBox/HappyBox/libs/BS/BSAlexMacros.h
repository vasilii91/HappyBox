// App Information
#define AppName                 [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleName"]
#define AppVersion              [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"]
#define AppDelegate(type)       ((type *)[[UIApplication sharedApplication] delegate])


// OS Information
#define IOS_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define IOS_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define IOS_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define IOS_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define IOS_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

// Device Information

#define IS_IPAD   (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_IPHONE_5 (( int )[[ UIScreen mainScreen ] bounds ].size.height - 568 == 0 )

//Size's

#define IPAD_HEIGHT 1024
#define IPAD_WIDTH 768
#define IPAD_TAB_BAR_HEIGHT 84
#define IPAD_NAV_BAR_HEIGHT 44
#define IPAD_KEYBOARD_PORTRAIT_HEIGHT 264
#define IPAD_KEYBOARD_LANDSCAPE_HEIGHT 352

#define IPHONE_HEIGHT (IS_IPHONE_5 ? 568 : 480)
#define IPHONE_WIDTH 320
#define IPHONE_TAB_BAR_HEIGHT 51
#define IPHONE_NAV_BAR_HEIGHT 41
#define IPHONE_KEYBOARD_PORTRAIT_HEIGHT 216
#define IPHONE_KEYBOARD_LANDSCAPE_HEIGHT 162


// Directories
static inline NSString *CachesDirectory()    { return [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0]; }
static inline NSString *LibraryDirectory()   { return [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0]; }
static inline NSString *DocumentsDirectory() { return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]; }
static inline NSString *PicturesDirectory()  { return [NSSearchPathForDirectoriesInDomains(NSPicturesDirectory, NSUserDirectory, YES) objectAtIndex:0]; }

// Actions
#define OpenURL(urlString) [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:urlString]]

// Preferences
#define UDValue(x)              [[NSUserDefaults standardUserDefaults] valueForKey:(x)]
#define UDObject(x)             [[NSUserDefaults standardUserDefaults] objectForKey:(x)]
#define UDBool(x)               [[NSUserDefaults standardUserDefaults] boolForKey:(x)]
#define UDInteger(x)            [[NSUserDefaults standardUserDefaults] integerForKey:(x)]
#define UDSetValue(x, y)        [[NSUserDefaults standardUserDefaults] setValue:(x) forKey:(y)]
#define UDSetObject(x, y)       [[NSUserDefaults standardUserDefaults] setObject:(x) forKey:(y)]
#define UDSetBool(x, y)         [[NSUserDefaults standardUserDefaults] setBool:(x) forKey:(y)]
#define UDSetInteger(x, y)      [[NSUserDefaults standardUserDefaults] setInteger:(x) forKey:(y)]
#define UDSync(ignored)         [[NSUserDefaults standardUserDefaults] synchronize]


// Debugging

#ifndef DEBUG
    #define LOG(...)
#else
    #define LOG(fmt, ...) NSLog((@" ----> " fmt), ##__VA_ARGS__);
//    #define LOG(...) NSLog(__VA_ARGS__)
#endif

#ifdef DEBUG
    #define DLog(fmt, ...) NSLog((@" ----> %s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
    #define DLog(...)
#endif

#define ALog(fmt, ...) NSLog((@" ----> %s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);

#ifdef DEBUG
    #define ULog(fmt, ...)  { UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"%s\n [Line %d] ", __PRETTY_FUNCTION__, __LINE__] message:[NSString stringWithFormat:fmt, ##__VA_ARGS__]  delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil]; [alert show]; }
#else
    #define ULog(...)
#endif

#define LOGAlert(fmt, ...)  { UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:fmt, ##__VA_ARGS__]  delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil]; [alert show]; [alert release]; }


// User Interface Related
#define UIColorFromRGBvalue(rgbValue)       [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define UIColorFromRGB(r, g, b)             [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0]

#define ShowNetworkActivityIndicator()      [UIApplication sharedApplication].networkActivityIndicatorVisible = YES
#define HideNetworkActivityIndicator()      [UIApplication sharedApplication].networkActivityIndicatorVisible = NO

#define NavBar                              self.navigationController.navigationBar
#define TabBar                              self.tabBarController.tabBar
#define NavBarHeight                        self.navigationController.navigationBar.bounds.size.height

#define ViewWidth(v)                        v.frame.size.width
#define ViewHeight(v)                       v.frame.size.height
#define ViewX(v)                            v.frame.origin.x
#define ViewY(v)                            v.frame.origin.y



// Rect stuff
#define CGWidth(rect)                   rect.size.width
#define CGHeight(rect)                  rect.size.height
#define CGOriginX(rect)                 rect.origin.x
#define CGOriginY(rect)                 rect.origin.y

#define CGRectModify(rect,dx,dy,dw,dh)  CGRectMake(rect.origin.x + dx, rect.origin.y + dy, rect.size.width + dw, rect.size.height + dh)
#define NSLogRect(rect)                 NSLog(@"%@", NSStringFromCGRect(rect))
#define NSLogSize(size)                 NSLog(@"%@", NSStringFromCGSize(size))
#define NSLogPoint(point)               NSLog(@"%@", NSStringFromCGPoint(point))
#define NSLogBOOL(arg)                  NSLog(@"Boolean: %@", ( arg == YES ? @"YES" : @"NO" ) );


