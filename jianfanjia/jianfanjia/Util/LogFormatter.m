//
//  LogFormatter.m
//  TestCocoaLumberjack
//
//  Created by MacMiniS on 5/22/14.
//  Copyright (c) 2014 Aldis. All rights reserved.
//

#import "LogFormatter.h"

#define DATE_FORMAT @"yyyy/MM/dd HH:mm:ss:SSS"
#define LOG_FORMAT @"%@ %@ %@ treadId:%@ queueLabel:%@ message:%@"

@interface LogFormatter ()

@property(nonatomic, retain) NSDateFormatter *dateFromatter;

@end

@implementation LogFormatter

- (id)init {
  if (self = [super init]) {
    _dateFromatter = [[NSDateFormatter alloc] init];
    [_dateFromatter setFormatterBehavior:NSDateFormatterBehavior10_4];
    [_dateFromatter setDateFormat:DATE_FORMAT];
  }
  
  return self;
}

- (NSString *)formatLogMessage:(DDLogMessage *)logMessage {
  NSString *date = [self.dateFromatter stringFromDate:logMessage->_timestamp];
  NSString *level = [LogFormatter getLogFlagString:logMessage->_flag];
  
    return [NSString stringWithFormat:LOG_FORMAT, date, level, logMessage->_function, logMessage->_threadID, logMessage->_queueLabel, logMessage->_message];
}

+ (NSString *)getLogFlagString:(int)flag{
  switch (flag) {
    case DDLogFlagVerbose:
      return @"V";
    case DDLogFlagDebug:
      return @"D";
    case DDLogFlagInfo:
      return @"I";
    case DDLogFlagWarning:
      return @"W";
    case DDLogFlagError:
      return @"E";
    default:
      break;
  }
  
  return @"Unknown";
}

@end
