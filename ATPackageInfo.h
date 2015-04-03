#include <sys/types.h>
#include <sys/sysctl.h>

@interface ATPackageInfo : NSObject
+(NSMutableDictionary *)installedDebianPackages;
+(NSString *)identifierForPackageContainingFile:(NSString *)filepath;

-(ATPackageInfo*)initWithPackageIdentifier:(NSString*)identifier;
-(ATPackageInfo*)initWithPackageFilePath:(NSString*)filepath;

-(NSString*)currentVersionFromServer;
-(NSString*)currentVersionFromServerForPackageIdentifier:(NSString*)packageIdentifier;
-(BOOL)versionIsLowerAs:(NSString*)version;
-(NSString*)packageVersion;
-(NSString*)packageName;

@property(nonatomic, readonly)NSString* packageIdentifier;
@property(nonatomic, readonly)NSMutableDictionary* packageDetail;
@end