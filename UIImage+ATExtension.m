#import "UIImage+ATExtension.h"


typedef struct ATColorCubeCell {
    unsigned int hits;
    double red;
    double green;
    double blue;

} ATColorCubeCell;

@interface ATColorCubeMaximum : NSObject
@property (assign, nonatomic) unsigned int hits;
@property (assign, nonatomic) double red;
@property (assign, nonatomic) double green;
@property (assign, nonatomic) double blue;
@end

@implementation ATColorCubeMaximum
@end

@implementation UIImage(ATExtension)
- (NSArray *)findMostUsedColors
{
	//this is based on the idea from here: http://www.pixelogik.de/blog/local-maxima-in-color-histogram

	#define ATColorCube_CellIndex(red,green,blue) (red+green*cubeSize+blue*cubeSize*cubeSize)
	int cubeSize = 30; //determins the accuracity, but also the speed
	int ATColorCubeNeightbourOffsets[27][3] = {
	    { 0, 0, 0},
	    { 0, 0, 1},
	    { 0, 0,-1},

	    { 0, 1, 0},
	    { 0, 1, 1},
	    { 0, 1,-1},

	    { 0,-1, 0},
	    { 0,-1, 1},
	    { 0,-1,-1},

	    { 1, 0, 0},
	    { 1, 0, 1},
	    { 1, 0,-1},

	    { 1, 1, 0},
	    { 1, 1, 1},
	    { 1, 1,-1},

	    { 1,-1, 0},
	    { 1,-1, 1},
	    { 1,-1,-1},

	    {-1, 0, 0},
	    {-1, 0, 1},
	    {-1, 0,-1},

	    {-1, 1, 0},
	    {-1, 1, 1},
	    {-1, 1,-1},

	    {-1,-1, 0},
	    {-1,-1, 1},
	    {-1,-1,-1}
	};

	//allocate space for the cells of the 3d-color cube. cubeSize = the cube size for each color dimension. use calloc to zero the memory.
    ATColorCubeCell* cells = calloc((cubeSize*cubeSize*cubeSize), sizeof(ATColorCubeCell));

    //amount of pixels in the image
    unsigned int pixelCount;
    unsigned char *rawData = [self rawPixelDataWithPixelCount:&pixelCount];
    if (!rawData)
        return nil;

    double red, green, blue, alpha;
    int redIndex, greenIndex, blueIndex, cellIndex, localHitCount;
    BOOL isLocalMaximum;

    // Loop throught all pixels. Put them in the cube.
    for (int k=0; k<pixelCount; k++) {
    	//get the color compenents of that pixel
        red   = (double)rawData[k*4+0]/255.0;
        green = (double)rawData[k*4+1]/255.0;
        blue  = (double)rawData[k*4+2]/255.0;
        alpha  = (double)rawData[k*4+3]/255.0;

        //only care about visible colors for now
        if(alpha == 1){
        	redIndex   = (int)(red*(cubeSize-1.0));
	        greenIndex = (int)(green*(cubeSize-1.0));
	        blueIndex  = (int)(blue*(cubeSize-1.0));

	        // get cell index
	        cellIndex = ATColorCube_CellIndex(redIndex, greenIndex, blueIndex);

	        //increase the values
        	cells[cellIndex].red   += red;
        	cells[cellIndex].green += green;
        	cells[cellIndex].blue  += blue;
		    //Increase hits amount
		    cells[cellIndex].hits++;
        }
    }

    free(rawData);

    // Now get the maxmias
    NSMutableArray *maximas = [NSMutableArray array];

    //  Find every maxima in the cube
    for (int red=0; red<cubeSize; red++) {
        for (int green=0; green<cubeSize; green++) {
            for (int blue=0; blue<cubeSize; blue++) {
                // Get hit count of this cell
                localHitCount = cells[ATColorCube_CellIndex(red, green, blue)].hits;

                //only process it if it has hits (eg there's a pixel with that "color")
                if (localHitCount == 0)
                	continue;

                // It is local maximum until we find a neighbour with a higher hit count
                isLocalMaximum = YES;

                // Check if any neighbour has a higher hit count, if it not, it's a maxima
                for (int neighbourIndex=0; neighbourIndex<27; neighbourIndex++) {
                    redIndex   = red+ATColorCubeNeightbourOffsets[neighbourIndex][0];
                    greenIndex = green+ATColorCubeNeightbourOffsets[neighbourIndex][1];
                    blueIndex  = blue+ATColorCubeNeightbourOffsets[neighbourIndex][2];

                    // Only check valid cell (no out of bound!)
                    if (redIndex >= 0 && greenIndex >= 0 && blueIndex >= 0) {
                        if (redIndex < cubeSize && greenIndex < cubeSize && blueIndex < cubeSize) {
                        	//check if the neightbour has a higher hit count then the current cell
                            if (cells[ATColorCube_CellIndex(redIndex, greenIndex, blueIndex)].hits > localHitCount) {
                            	//use the neightbour instead!
                                isLocalMaximum = NO;
                                break;
                            }
                        }
                    }
                }

                // If this cell is not a maximum (neighbour was found to be a maximum)
                if (!isLocalMaximum)
                	continue;

                // It's maximu, add it to the list. Use a class, structs don't play nice with NSArrays
                ATColorCubeMaximum *maximum = [[ATColorCubeMaximum alloc] init];
                unsigned int cellIndex = ATColorCube_CellIndex(red, green, blue);
                maximum.hits = cells[cellIndex].hits;
                maximum.red   = cells[cellIndex].red / (double)cells[cellIndex].hits;
                maximum.green = cells[cellIndex].green / (double)cells[cellIndex].hits;
                maximum.blue  = cells[cellIndex].blue / (double)cells[cellIndex].hits;
                [maximas addObject:maximum];
            }
        }
    }
    //free the cells, we don't need the cube itself anymore!
    free(cells);

    //Now sort the maximums by hits
    NSArray *sortedMaxima = [maximas sortedArrayUsingComparator:^NSComparisonResult(ATColorCubeMaximum *m1, ATColorCubeMaximum *m2){
        if (m1.hits == m2.hits) return NSOrderedSame;
        return m1.hits > m2.hits ? NSOrderedAscending : NSOrderedDescending;
    }];

    NSMutableArray* colors = [[NSMutableArray alloc]init];

    // For each local maximum generate UIColor and add it to the result array
    for (ATColorCubeMaximum *maximum in sortedMaxima) {
        [colors addObject:[UIColor colorWithRed:maximum.red green:maximum.green blue:maximum.blue alpha:1.0]];
    }
    return [NSArray arrayWithArray:colors];//return a static copy
}


- (NSArray *)ATExtractColors
{
	//returns the most used colors of the image, sorted by usage
    return  [self findMostUsedColors];
}

- (NSArray *)ATMainColor
{
    //returns the most used color of the image
    return [self findMostUsedColors][0];
}


- (UIColor *)ATAverageColor{
	//returns the average color of the image

    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    unsigned char rgba[4];
    CGContextRef context = CGBitmapContextCreate(rgba, 1, 1, 8, 4, colorSpace, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);

    CGContextDrawImage(context, CGRectMake(0, 0, 1, 1), self.CGImage);
    CGColorSpaceRelease(colorSpace);
    CGContextRelease(context);

    if(rgba[3] > 0) {
        CGFloat alpha = ((CGFloat)rgba[3])/255.0;
        CGFloat multiplier = alpha/255.0;
        return [UIColor colorWithRed:((CGFloat)rgba[0])*multiplier
                               green:((CGFloat)rgba[1])*multiplier
                                blue:((CGFloat)rgba[2])*multiplier
                               alpha:alpha];
    }
    else {
        return [UIColor colorWithRed:((CGFloat)rgba[0])/255.0
                               green:((CGFloat)rgba[1])/255.0
                                blue:((CGFloat)rgba[2])/255.0
                               alpha:((CGFloat)rgba[3])/255.0];
    }
}


- (unsigned char *)rawPixelDataWithPixelCount:(unsigned int*)pixelCountPtr
{
    NSUInteger imageWidth = CGImageGetWidth(self.CGImage);
    NSUInteger imageHeight = CGImageGetHeight(self.CGImage);

    unsigned char *rawDataBuffer = (unsigned char *)malloc(imageHeight * imageWidth * 4);//1 byte per data (red,green,blue,a)
    if (!rawDataBuffer)
     return NULL;

    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(rawDataBuffer, imageWidth, imageHeight, 8, 4*imageWidth, colorSpace, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGColorSpaceRelease(colorSpace);

    //draw it
    CGContextDrawImage(context, CGRectMake(0, 0, imageWidth, imageHeight), self.CGImage);
    CGContextRelease(context);

    if(pixelCountPtr){
    	//if supplied, write the amount if of pixels into the pointer
   	 	*pixelCountPtr = (int)imageWidth * (int)imageHeight;
    }
    return rawDataBuffer;
}
@end