//
//  RTSLog.h
//  Kid on Time
//
//  Created by Patrick McGonigle on 2/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#ifndef Kid_on_Time_RTSLog_h
#define Kid_on_Time_RTSLog_h

void RTSLog(NSString* topic, const char* filename, int lineNum, NSString* fmt, ...);

//
// Macros to control logging at compile time
//

// Always log user errors, even for production release
#define LOG_USER_ERROR(...) RTSLog(@"user error", __FILE__, __LINE__, __VA_ARGS__)

#ifdef DEBUG_USER_WARNINGS
#define LOG_USER_WARNING(...) RTSLog(@"user warning", __FILE__, __LINE__, __VA_ARGS__)
#else
#define LOG_USER_WARNING(...)
#endif

#ifdef DEBUG_INFO
#define LOG_INFO(...) RTSLog(@"info", __FILE__, __LINE__, __VA_ARGS__)
#else
#define LOG_INFO(...)
#endif

#ifdef DEBUG_TRACE
#define LOG_TRACE(...) RTSLog(@"trace", __FILE__, __LINE__, __VA_ARGS__)
#else
#define LOG_TRACE(...)
#endif

#ifdef DEBUG_DATABASE
#define LOG_DATABASE(...) RTSLog(@"database", __FILE__, __LINE__, __VA_ARGS__)
#else
#define LOG_DATABASE(...)
#endif

#ifdef DEBUG_TMP_DEBUG
#define LOG_TMP_DEBUG(...) RTSLog(@"tmp debug", __FILE__, __LINE__, __VA_ARGS__)
#else
#define LOG_TMP_DEBUG(...)
#endif

#ifdef DEBUG_INTERNAL_ERROR
#define LOG_INTERNAL_ERROR(...) RTSLog(@"internal error", __FILE__, __LINE__, __VA_ARGS__)
#else
#define LOG_INTERNAL_ERROR(...)
#endif

#ifdef DEBUG_COCOS2D
#define LOG_COCOS2D(...) RTSLog(@"cocos2d", __FILE__, __LINE__, __VA_ARGS__)
#else
#define LOG_COCOS2D(...)
#endif

#ifdef DEBUG_APP_LIFECYCLE
#define LOG_APP_LIFECYCLE(...) RTSLog(@"lifecycle app", __FILE__, __LINE__, __VA_ARGS__)
#else
#define LOG_APP_LIFECYCLE(...)
#endif

#ifdef DEBUG_OBJ_LIFECYCLE
#define LOG_OBJ_LIFECYCLE(...) RTSLog(@"lifecycle obj", __FILE__, __LINE__, __VA_ARGS__)
#else
#define LOG_OBJ_LIFECYCLE(...)
#endif

#ifdef DEBUG_VIEW_LIFECYCLE
#define LOG_VIEW_LIFECYCLE(...) RTSLog(@"lifecycle view", __FILE__, __LINE__, __VA_ARGS__)
#else
#define LOG_VIEW_LIFECYCLE(...)
#endif

#endif
