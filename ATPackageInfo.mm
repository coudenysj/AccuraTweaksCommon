#import "ATPackageInfo.h"

@implementation ATPackageInfo
-(ATPackageInfo*)initWithPackageIdentifier:(NSString*)identifier{
	if(identifier == nil)
		return nil;

	self = [super init];
	if(self){
		_packageIdentifier = identifier;
	}
	return self;
}

-(ATPackageInfo*)initWithPackageFilePath:(NSString*)filepath{
	NSString* identifier = [ATPackageInfo identifierForPackageContainingFile:filepath];
	if(filepath){
		self = [self initWithPackageIdentifier:identifier];
	}
	return self;
}

-(NSDictionary*)packageDetails{
	//get's details for the package, like version, name and author.
	if(!_packageDetail){

	    NSString* dpkgQuery = [[NSString alloc] initWithFormat:@"dpkg-query -p \"%@\"", _packageIdentifier];
	    FILE* f = popen([dpkgQuery UTF8String], "r");

	    _packageDetail = [NSMutableDictionary dictionary];
	    if (f != NULL) {
	    	//holds the line we're reading right now untill we reached the end of the line or EOF
	        NSMutableData *lineBuffer = [[NSMutableData alloc]init];
		    char buf[1025];
		    size_t maxSize = (sizeof(buf) - 1);
		    while (!feof(f)) {
		    	//as long as we didn't reach EOF
		        if (fgets(buf, maxSize, f)) {
		            buf[maxSize] = '\0';//make sure the string is 0 terminated!

		            //check if we reached the end of the line
		            char *lineBreakLocation = strrchr(buf, '\n');
		            if (lineBreakLocation != NULL) {
		            	//we did find a line break. Add it to lineBuffer and we got the whole line
		                [lineBuffer appendBytes:buf length:(NSUInteger)(lineBreakLocation - buf)];

		                //the whole line is now in the buffer
		                NSString *lineString = [[NSString alloc] initWithData:lineBuffer encoding:NSUTF8StringEncoding];
		                //check if we got a key and a value
		                NSUInteger firstColon = [lineString rangeOfString:@":"].location;
		                if (firstColon != NSNotFound) {
		                    NSUInteger length = [lineString length];
		                    //check if value is not empty
		                    if (length > (firstColon + 1)) {
		                        NSString *key = [lineString substringToIndex:firstColon];
		                        NSString *value = [lineString substringFromIndex:(firstColon + 1)];
		                        //remove any whitespaces from value
		                        value = [value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
		                        if ([value length] > 0) {
		                            [_packageDetail setObject:value forKey:key];
		                        }
		                    }
		                }
		                //reset the lineBuffer
		                [lineBuffer setLength:0];
		            } else {
		            	//we didn't reach the end of the line yet. Buffer everything
		                [lineBuffer appendBytes:buf length:maxSize];
		            }
		        }
		    }
	    }
	    pclose(f);
	}

	

    return _packageDetail;
}

-(NSString*)packageVersion{
	//returns the currently installed version
	if(self.packageDetails){
		NSString* version = [self.packageDetails objectForKey:@"Version"];
		if([version isKindOfClass:[NSString class]]){
			return version;
		}
	}
	return nil;
}

-(NSString*)packageName{
	//returns the package name
	if(self.packageDetails){
		NSString* version = [self.packageDetails objectForKey:@"Name"];
		if([version isKindOfClass:[NSString class]]){
			return version;
		}
	}
	return nil;
}

-(NSString*)currentVersionFromServerForPackageIdentifier:(NSString*)packageIdentifier{
	//get's the version of that package that's in cydia from my server. Currently only thebigboss packages supported.
	NSURL* url = [NSURL URLWithString:[@"http://api.accuratweaks.com/tweaks/package_version.php?p=" stringByAppendingString:packageIdentifier]];
	return [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
}

-(NSString*)currentVersionFromServer{
//get's the version of that current package that's in cydia from my server. Currently only thebigboss packages supported.
	return [self currentVersionFromServerForPackageIdentifier:self.packageIdentifier];
}

+(NSMutableDictionary *)installedDebianPackages{

	static NSMutableDictionary* installedDebianPackages;
	static dispatch_once_t installed_debian_packages_once;
	dispatch_once(&installed_debian_packages_once, ^{
	    FILE* f = popen("dpkg -l", "r");

	   	installedDebianPackages = [[NSMutableDictionary alloc]init];
	    if (f != NULL) {
	    	//holds the line we're reading right now untill we reached the end of the line or EOF
	        NSMutableData *lineBuffer = [[NSMutableData alloc]init];
		    char buf[1025];
		    size_t bufferSize = (sizeof(buf) - 1);
		    while (!feof(f)) {
		    	//as long as we didn't reach EOF
		        if (fgets(buf, bufferSize, f)) {
		            buf[bufferSize] = '\0';//make sure the string is 0 terminated!

		            //check if we reached the end of the line
		            char *lineBreakLocation = strrchr(buf, '\n');
		            if (lineBreakLocation != NULL) {
		            	//we did find a line break. Add it to lineBuffer and we got the whole line
		                [lineBuffer appendBytes:buf length:(NSUInteger)(lineBreakLocation - buf)];
		                NSString *line = [[NSString alloc] initWithData:lineBuffer encoding:NSUTF8StringEncoding];

		                //check if it starts with ii (installed package!)
		                if([line hasPrefix:@"ii"]){
		                	NSArray *package_array = [line componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
							package_array = [package_array filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF != ''"]];
							if([package_array count] >= 3){
								NSString* package_name = package_array[1];
								NSString* package_version = package_array[2];
								installedDebianPackages[package_name] = package_version;
							}
		                }
		                //reset the line buffer
		                [lineBuffer setLength:0];
		            } else {
		            	//we didn't reach the end of the line yet. Buffer everything
		                [lineBuffer appendBytes:buf length:bufferSize];
		            }
		        }
		    }
	    }
	});
    return installedDebianPackages;
}

+(NSString *)identifierForPackageContainingFile:(NSString *)filepath{
	//cache the packages for specific file paths, as reuqests take time and may come frequest
	static NSMutableDictionary* packageCache;
	if(!packageCache){
		packageCache = [[NSMutableDictionary alloc]init];
	}else{
		if([packageCache objectForKey:filepath]){
			//if the package is in cache, use that.
			return [packageCache objectForKey:filepath];
		}
	}
    NSString *packageIdentifier = nil;

    NSString* dpkgQuery = [NSString stringWithFormat:@"dpkg-query -S \"%@\" | head -1", filepath];
    FILE *f = popen([dpkgQuery UTF8String], "r");
    if (f != NULL) {
        // Read until : is hit.
        NSMutableData *packageIdentifierBuffer = [[NSMutableData alloc]init];
        char buf[1025];
        size_t bufferSize = (sizeof(buf) - 1);
        while (!feof(f)) {
        	//read as many chars as possible, but not more as fit in the buffer
            size_t readSize = fread(buf, 1, bufferSize, f);
            buf[readSize] = '\0';//make sure the buffer is 0 terminated

            size_t packageIdentifierSize = strcspn(buf, ":");//output looks like this: me.simonselg.qrmode: /Library/MobileSubstrate/DynamicLibraries/QRMode.dylib
            [packageIdentifierBuffer appendBytes:buf length:packageIdentifierSize];
            if (packageIdentifierSize != bufferSize) {
            	//we found something - no need to read more.
                break;
            }
        }
        if ([packageIdentifierBuffer length] > 0) {
        	//if we found something
            packageIdentifier = [[NSString alloc] initWithData:packageIdentifierBuffer encoding:NSUTF8StringEncoding];
        }
        pclose(f);
    }

    //now compare if the "Package identifier" was dpkg - in that case it's not a hit (dpkg: file not found or somethign, don't remember!)
    if([packageIdentifier isEqualToString:@"dpkg"]){
    	packageIdentifier = nil;
    }else if(packageIdentifier){
    	//cache the result
    	packageCache[filepath] = packageIdentifier;
    }

    return packageIdentifier;
}


-(BOOL)versionIsLowerAs:(NSString*)version{
	//checks if a given version (in format 1.0-5 or 1.5 or 1.5.9.1) is heigher as the installed version
	NSString* installedVersion = [self cleanVersionString:[self packageVersion]];
	NSString* version2Compare = [self cleanVersionString:version];
	if ([version2Compare compare:installedVersion options:NSNumericSearch] == NSOrderedDescending) {
	   return YES;
	}
	return NO;
}

- (NSString *)cleanVersionString:(NSString*)versionString{;
	//replaced "-" with "." and solves the problem that 1.0.0 > 1.0 by removing .0 at the end
    static NSString *const unnessesarySuffix = @".0";
    versionString = [versionString stringByReplacingOccurrencesOfString:@"-" withString:@"."];

    while ([versionString hasSuffix:unnessesarySuffix]) {
        versionString = [versionString substringToIndex:versionString.length - unnessesarySuffix.length];
    }

    return versionString;
}
@end