
#define __Noti                                [NSNotificationCenter defaultCenter]
#define _Noti_Add(__ob, __sel, __n, __o)      [__Noti addObserver:__ob selector:__sel name:__n object:__o]

#define _COLOR_RGB(rgbValue) [UIColor colorWith\
Red     :(rgbValue & 0xFF0000)     / (float)0xFF0000 \
green   :(rgbValue & 0xFF00)       / (float)0xFF00 \
blue    :(rgbValue & 0xFF)         / (float)0xFF \
alpha   :1.0]
#define _kFont(x)   [UIFont systemFontOfSize:(x)]

#define ScreenWidth CGRectGetWidth([UIScreen mainScreen].bounds)

