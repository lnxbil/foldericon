/*
 *  main.m
 *  foldericon
 * 
 * Copyright (C) 2012 Andreas Steinel
 * 
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 * 
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 * 
 */


#import <AppKit/AppKit.h>

void usage(const char *program_name)
{
    fprintf(stderr, "Usage: %s (get|set) <folder1> [ <folder2> ... ]\n\n", program_name);
    fprintf(stderr, "    get:\n");
    fprintf(stderr, "       this program stores the folder icon of the given in folder(s)\n");
    fprintf(stderr, "       to the current directory\n\n");
    fprintf(stderr, "    set:\n");
    fprintf(stderr, "       this program restores the folder icon(s) of the given in folder(s)\n");
    fprintf(stderr, "       from the current directory\n");
    exit(1);
}

void export_images(const char *folder[], int folders)
{
    NSLog(@"Got %i folder(s)", folders-2);
    
    // initialize NSFileManager
    NSFileManager *fm = [NSFileManager defaultManager];
    BOOL exists, isDir;
    
    // loop over all folders
    for (int i=2; i < folders; i++)
    {
        // get the directory path as NSString
        NSString *directory = [ NSString stringWithFormat:@"%s", folder[i] ];
        
        // convert to absolute path if neccessary
        if ( ! [directory isAbsolutePath] ) {
            directory = [NSString stringWithFormat:@"%@/%@",[fm currentDirectoryPath], directory ];
        }
        
        // Abort if file doesn't exists or is not a directory
        exists = [fm fileExistsAtPath:directory isDirectory:&isDir];
        if( !isDir || !exists )
        {
            NSLog(@"File %@ is not a directory!", directory);
            continue;
        }
        
        
        // retrieve image
        NSImage *icon = [[NSWorkspace sharedWorkspace] iconForFile:directory];
        
        // create path for image file
        NSString *image_file = [NSString stringWithFormat:@"%@/%@.png", [fm currentDirectoryPath],
                          [ [NSString stringWithFormat:@"%s",folder[i] ] lastPathComponent]
                         ];
        
        NSLog(@"Trying to write image %@ from folder %@", image_file, directory);
        
        // retrieving data, convert to TIFF and store are PNG
        NSData *imageData = [icon TIFFRepresentation];
        NSBitmapImageRep *imageRep = [NSBitmapImageRep imageRepWithData:imageData];
        NSDictionary *imageProps = [NSDictionary dictionaryWithObject:[NSNumber numberWithFloat:1.0] forKey:NSImageCompressionFactor];
        NSData *bitmapData = NULL;
        bitmapData = [imageRep representationUsingType:NSPNGFileType properties:imageProps];
        [bitmapData writeToFile:image_file atomically:YES];
    }
}

void import_images(const char *folder[], int folders)
{
    NSLog(@"Got %i folder(s)", folders-2);
    
    // initialize NSFileManager
    NSFileManager *fm = [NSFileManager defaultManager];
    BOOL exists, isDir;
    
    // loop over all folders
    for (int i=2; i < folders; i++)
    {
        // get the directory path as NSString
        NSString *directory = [ NSString stringWithFormat:@"%s", folder[i] ];
        NSString *imagefile = [NSString stringWithFormat:@"%@/%@.png", [fm currentDirectoryPath], [directory lastPathComponent] ];
        
        // convert to absolute path if neccessary
        if ( ! [directory isAbsolutePath] ) {
            directory = [NSString stringWithFormat:@"%@/%@",[fm currentDirectoryPath], directory ];
        }
        
        // Abort if file doesn't exists or is not a directory
        exists = [fm fileExistsAtPath:directory isDirectory:&isDir];
        if( !isDir || !exists )
        {
            NSLog(@"File %@ is not a directory!", directory);
            continue;
        } else {
            // Test also if the image file is present
            exists = [fm fileExistsAtPath:imagefile isDirectory:&isDir];
            if( isDir || !exists )
            {
                NSLog(@"No image file %@ present!", directory);
                continue;
            }
        }
        
        NSLog(@"Trying to set the icon %@ for the directory %@", imagefile, directory);


        // load the image
        NSImage *icon = [[NSImage alloc] initWithContentsOfFile:imagefile];
        
        // set the icon
        [[NSWorkspace sharedWorkspace] setIcon:icon forFile:directory options:NSExclude10_4ElementsIconCreationOption];

            }
}


int main(int argc, const char * argv[])
{
    // if there are not at least 3 arguments and the second is either set or get, display help
    if ( argc < 3 || ( strcmp(argv[1], "get") == 0 && strcmp(argv[1], "set") == 0 ))
        usage(argv[0]);

    // export or import depending on the first argument
    if ( strcmp(argv[1], "get") == 0 )
        export_images( argv, argc);
    else
        import_images( argv, argc);

    return 0;
}

