//
//  ViewController.m
//  NPUNetworkScaner
//
//  Created by 蒋若峤 on 2018/8/27.
//  Copyright © 2018年 蒋若峤. All rights reserved.
//

#import "ViewController.h"
#import <AppKit/AppKit.h>
#include <ifaddrs.h>
#include <arpa/inet.h>
#include <net/if.h>

@interface ViewController()
@property (nonatomic, strong) NSStatusBar *demotlem;
@end


@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(getInternetface) userInfo:nil repeats:YES];
    [timer fireDate];
    // Do any additional setup after loading the view.
}

- (void)getInternetface
{
    long long hehe = [self getInterfaceBytes];
    NSLog(@"hehe:%lld",hehe);
}

- (long long) getInterfaceBytes
{
    struct ifaddrs *ifa_list = 0, *ifa;
    if (getifaddrs(&ifa_list) == -1)
    {
        return 0;
    }
    uint32_t iBytes = 0;
    uint32_t oBytes = 0;
    for (ifa = ifa_list; ifa; ifa = ifa->ifa_next)
    {
        if (AF_LINK != ifa->ifa_addr->sa_family)
            continue;
        if (!(ifa->ifa_flags & IFF_UP) && !(ifa->ifa_flags & IFF_RUNNING))
            continue;
        if (ifa->ifa_data == 0)
            continue;
        /* Not a loopback device. */
        if (strncmp(ifa->ifa_name, "lo", 2))
        {
            struct if_data *if_data = (struct if_data *)ifa->ifa_data;
            iBytes += if_data->ifi_ibytes;
            oBytes += if_data->ifi_obytes;
        }
    }
    freeifaddrs(ifa_list);
    NSLog(@"\n[getInterfaceBytes-Total]%d,%d",iBytes/1024/1024/2,oBytes/1024/1024/2);
    return iBytes + oBytes;
}

- (void)setRepresentedObject:(id)representedObject
{
    [super setRepresentedObject:representedObject];
    // Update the view, if already loaded.
}


@end
