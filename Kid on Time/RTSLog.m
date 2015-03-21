//
//  RTSLog.m
//  Kid on Time
//
//  Created by Patrick McGonigle on 2/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RTSLog.h"

//
// The main log op -- Adapted from the "iOS Recipes" book
//
void RTSLog(NSString* topic, const char* filename, int lineNum, NSString* fmt, ...) 
{
    va_list args;
    va_start(args, fmt);
    
    NSString* msg = [[NSString alloc] initWithFormat:fmt arguments:args];
    NSString* filePath = [[NSString alloc] initWithUTF8String:filename];
    
    NSLog(@"[%@] (%@:%d) %@", topic, [filePath lastPathComponent], lineNum, msg);
    
    va_end(args);
}
