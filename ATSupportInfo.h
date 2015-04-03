#include <sys/types.h>
#include <sys/sysctl.h>
#include "ATPackageInfo.h"

@interface ATSupportInfo : NSObject
-(ATSupportInfo*)initWithPackageIdentifier:(NSString*)identifier;
-(ATSupportInfo*)initWithPackageFilePath:(NSString*)filepath;

+(NSString*) platform;
-(NSData*)supportAttachmentDataForPreferencePath:(NSString*)preferencePath;
-(NSString*)mailSubjectForPackageIdentifier:(NSString*)packageIdentifier;
-(NSString*)mailSubject;

@property(nonatomic, readonly)NSString* packageIdentifier;
@property(nonatomic, readonly)ATPackageInfo* packageInfo;
@end


