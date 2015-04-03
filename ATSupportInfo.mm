#import "ATSupportInfo.h"


@implementation ATSupportInfo
-(ATSupportInfo*)initWithPackageIdentifier:(NSString*)identifier{
	self = [super init];
	if(self){
		_packageIdentifier = identifier;
		_packageInfo = [[ATPackageInfo alloc]initWithPackageIdentifier:identifier];
	}
	return self;
}

-(ATSupportInfo*)initWithPackageFilePath:(NSString*)filepath{
	NSString* identifier = [ATPackageInfo identifierForPackageContainingFile:filepath];
	if(filepath){
		self = [self initWithPackageIdentifier:identifier];
	}
	return self;
}


+(NSString*)platform{
	//todo: move this to somewhere else or cache it.
	size_t size;
	sysctlbyname("hw.machine", NULL, &size, NULL, 0);
	char *machine = (char*)malloc(size);
	sysctlbyname("hw.machine", machine, &size, NULL, 0);
	NSString* platform = [NSString stringWithCString:machine encoding:NSUTF8StringEncoding];
	free(machine);
    return platform;
}

-(NSString*)mailSubject{
	//no way to check if it's pirated.
	NSString* mailSubject = [NSString stringWithFormat:@"%@ %@ Support",
	[self.packageInfo packageName], [self.packageInfo packageVersion]];
	return mailSubject;
}

-(NSString*)mailSubjectForPackageIdentifier:(NSString*)packageIdentifier{
	NSString* mailSubject;
	if([packageIdentifier isEqualToString:[self.packageInfo packageIdentifier]]){
		//seems like a legit user.
		mailSubject = [NSString stringWithFormat:@"%@ v%@ Support", [self.packageInfo packageName], [self.packageInfo packageVersion]];
	}else{
		//Most likely pirated. Oh you sneaky source code reader. Now you know my secret.
		mailSubject = [NSString stringWithFormat:@"%@ %@ Support", [self.packageInfo packageName], [self.packageInfo packageVersion]];
	}
	return mailSubject;
}

-(NSData*)supportAttachmentDataForPreferencePath:(NSString*)preferencePath{

	NSMutableDictionary *preferences = [NSMutableDictionary dictionary];
	[preferences addEntriesFromDictionary:[NSDictionary dictionaryWithContentsOfFile:preferencePath]];

	NSString* platform = [ATSupportInfo platform];
	NSDictionary* installedPackages = [ATPackageInfo installedDebianPackages];

	NSDictionary* attachmentDict = @{@"Platform": platform, @"Version": [self.packageInfo packageVersion],
		 @"Preferences" : preferences, @"Installed packages" : installedPackages};

	//todo: find a way for this that does not require writing the dict to disk
	NSString* supportFilePath = [NSString stringWithFormat:@"/var/tmp/%@Support.plist",
		[self.packageInfo packageName]];
	[attachmentDict writeToFile:supportFilePath atomically:YES];
	return [NSData dataWithContentsOfFile:supportFilePath];
}
@end


