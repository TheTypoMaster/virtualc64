//
//  C64ProxyColors.mm
//  V64
//
//  Created by Dirk Hoffmann on 17.08.15.
//
//

#import "C64GUI.h"

@implementation C64Proxy(Colors)

- (int)colorScheme
{
    return colorScheme;
}

- (void) setColorScheme:(int)scheme
{
    assert(scheme >= 0 && scheme < 16);

    uint8_t rgb[12][16][3] = {
        
        /* CCS64 */
        {
            { 0x10, 0x10, 0x10 },
            { 0xff, 0xff, 0xff },
            { 0xe0, 0x40, 0x40 },
            { 0x60, 0xff, 0xff },
            { 0xe0, 0x60, 0xe0 },
            { 0x40, 0xe0, 0x40 },
            { 0x40, 0x40, 0xe0 },
            { 0xff, 0xff, 0x40 },
            { 0xe0, 0xa0, 0x40 },
            { 0x9c, 0x74, 0x48 },
            { 0xff, 0xa0, 0xa0 },
            { 0x54, 0x54, 0x54 },
            { 0x88, 0x88, 0x88 },
            { 0xa0, 0xff, 0xa0 },
            { 0xa0, 0xa0, 0xff },
            { 0xc0, 0xc0, 0xc0 }
        },
        
        /* VICE */
        {
            { 0x00, 0x00, 0x00 },
            { 0xff, 0xff, 0xff },
            { 0xbd, 0x18, 0x21 },
            { 0x31, 0xe7, 0xc6 },
            { 0xb5, 0x18, 0xe7 },
            { 0x18, 0xd6, 0x18 },
            { 0x21, 0x18, 0xad },
            { 0xde, 0xf7, 0x08 },
            { 0xbd, 0x42, 0x00 },
            { 0x6b, 0x31, 0x00 },
            { 0xff, 0x4a, 0x52 },
            { 0x42, 0x42, 0x42 },
            { 0x73, 0x73, 0x6b },
            { 0x5a, 0xff, 0x5a },
            { 0x5a, 0x52, 0xff },
            { 0xa5, 0xa5, 0xa5 }
        },
        
        /* FRODO */
        {
            { 0x00, 0x00, 0x00 },
            { 0xff, 0xff, 0xff },
            { 0xcc, 0x00, 0x00 },
            { 0x00, 0xff, 0xcc },
            { 0xff, 0x00, 0xff },
            { 0x00, 0xcc, 0x00 },
            { 0x00, 0x00, 0xcc },
            { 0xff, 0xff, 0x00 },
            { 0xff, 0x88, 0x00 },
            { 0x88, 0x44, 0x00 },
            { 0xff, 0x88, 0x88 },
            { 0x44, 0x44, 0x44 },
            { 0x88, 0x88, 0x88 },
            { 0x88, 0xff, 0x88 },
            { 0x88, 0x88, 0xff },
            { 0xcc, 0xcc, 0xcc }
        },
        
        /* PC64 */
        {
            { 0x21, 0x21, 0x21 },
            { 0xff, 0xff, 0xff },
            { 0xb5, 0x21, 0x21 },
            { 0x73, 0xff, 0xff },
            { 0xb5, 0x21, 0xb5 },
            { 0x21, 0xb5, 0x21 },
            { 0x21, 0x21, 0xb5 },
            { 0xff, 0xff, 0x21 },
            { 0xb5, 0x73, 0x21 },
            { 0x94, 0x42, 0x21 },
            { 0xff, 0x73, 0x73 },
            { 0x73, 0x73, 0x73 },
            { 0x94, 0x94, 0x94 },
            { 0x73, 0xff, 0x73 },
            { 0x73, 0x73, 0xff },
            { 0xb5, 0xb5, 0xb5 }
        },
        
        /* C64S */
        {
            { 0x00, 0x00, 0x00 },
            { 0xfc, 0xfc, 0xfc },
            { 0xa8, 0x00, 0x00 },
            { 0x54, 0xfc, 0xfc },
            { 0xa8, 0x00, 0xa8 },
            { 0x00, 0xa8, 0x00 },
            { 0x00, 0x00, 0xa8 },
            { 0xfc, 0xfc, 0x00 },
            { 0xa8, 0x54, 0x00 },
            { 0x80, 0x2c, 0x00 },
            { 0xfc, 0x54, 0x54 },
            { 0x54, 0x54, 0x54 },
            { 0x80, 0x80, 0x80 },
            { 0x54, 0xfc, 0x54 },
            { 0x54, 0x54, 0xfc },
            { 0xa8, 0xa8, 0xa8 }
        },
        
        /* ALEC64 */
        {
            { 0x00, 0x00, 0x00 },
            { 0xfc, 0xfc, 0xfc },
            { 0x9c, 0x00, 0x00 },
            { 0x00, 0xbc, 0xbc },
            { 0xbc, 0x00, 0xbc },
            { 0x00, 0x9c, 0x00 },
            { 0x00, 0x00, 0x9c },
            { 0xfc, 0xfc, 0x00 },
            { 0xfc, 0x58, 0x00 },
            { 0x78, 0x38, 0x00 },
            { 0xfc, 0x00, 0x00 },
            { 0x3c, 0x3c, 0x3c },
            { 0x7c, 0x7c, 0x7c },
            { 0x00, 0xfc, 0x00 },
            { 0x00, 0x00, 0xfc },
            { 0xbc, 0xbc, 0xbc }
        },
        
        /* WIN64 */
        {
            { 0x00, 0x00, 0x00 },
            { 0xff, 0xff, 0xff },
            { 0x68, 0x00, 0x14 },
            { 0x00, 0xc0, 0xac },
            { 0x94, 0x00, 0x98 },
            { 0x5c, 0x98, 0x5e }, // exchanged with LTGREEN
            { 0x04, 0x10, 0xb0 },
            { 0xfc, 0xfc, 0x00 },
            { 0xf9, 0x9a, 0x1a },
            { 0x50, 0x20, 0x14 },
            { 0xfc, 0x50, 0x80 },
            { 0x46, 0x46, 0x46 },
            { 0x73, 0x73, 0x73 },
            { 0x24, 0xf0, 0x00 }, // exchanged with GREEN
            { 0x5e, 0x70, 0xf2 },
            { 0xac, 0xac, 0xac }
        },
        
        /* C64ALIVE */
        {
            { 0x00, 0x00, 0x00 },
            { 0xfc, 0xfc, 0xfc },
            { 0xb0, 0x00, 0x00 },
            { 0x00, 0xb8, 0xb8 },
            { 0xa0, 0x00, 0xa0 },
            { 0x00, 0xbc, 0x00 },
            { 0x00, 0x00, 0xa0 },
            { 0xf8, 0xfc, 0x50 },
            { 0xcc, 0x64, 0x00 },
            { 0x98, 0x4c, 0x28 },
            { 0xf4, 0x88, 0x90 },
            { 0x58, 0x58, 0x58 },
            { 0x94, 0x94, 0x94 },
            { 0x68, 0xfc, 0x80 },
            { 0x68, 0x80, 0xf8 },
            { 0xd8, 0xd8, 0xd8 }
        },
        
        /* GODOT */
        {
            { 0x00, 0x00, 0x00 },
            { 0xff, 0xff, 0xff },
            { 0x88, 0x00, 0x00 },
            { 0xaa, 0xff, 0xee },
            { 0xcc, 0x44, 0xcc },
            { 0x00, 0xcc, 0x55 },
            { 0x00, 0x00, 0xaa },
            { 0xee, 0xee, 0x77 },
            { 0xdd, 0x88, 0x55 },
            { 0x66, 0x44, 0x00 },
            { 0xfe, 0x77, 0x77 },
            { 0x33, 0x33, 0x33 },
            { 0x77, 0x77, 0x77 },
            { 0xaa, 0xff, 0x66 },
            { 0x00, 0x88, 0xff },
            { 0xbb, 0xbb, 0xbb }
        },
        
        /* C64SALLY */
        {
            { 0x00, 0x00, 0x00 },
            { 0xfc, 0xfc, 0xfc },
            { 0xc8, 0x00, 0x00 },
            { 0x00, 0xfc, 0xfc },
            { 0xfc, 0x00, 0xfc },
            { 0x00, 0xc8, 0x00 },
            { 0x00, 0x00, 0xc8 },
            { 0xfc, 0xfc, 0x00 },
            { 0xfc, 0x64, 0x00 },
            { 0xc0, 0x64, 0x00 },
            { 0xfc, 0x64, 0x64 },
            { 0x40, 0x40, 0x40 },
            { 0x80, 0x80, 0x80 },
            { 0x64, 0xfc, 0x64 },
            { 0x64, 0x64, 0xf0 },
            { 0xc0, 0xc0, 0xc0 }
        },
        
        /* PEPTO */
        {
            { 0x00, 0x00, 0x00 },
            { 0xff, 0xff, 0xff },
            { 0x68, 0x37, 0x2b },
            { 0x70, 0xa4, 0xb2 },
            { 0x6f, 0x3d, 0x86 },
            { 0x58, 0x8d, 0x43 },
            { 0x35, 0x28, 0x79 },
            { 0xb8, 0xc7, 0x6f },
            { 0x6f, 0x4f, 0x25 },
            { 0x43, 0x39, 0x00 },
            { 0x9A, 0x67, 0x59 },
            { 0x44, 0x44, 0x44 },
            { 0x6c, 0x6c, 0x6c },
            { 0x9a, 0xd2, 0x84 },
            { 0x6c, 0x5e, 0xb5 },
            { 0x95, 0x95, 0x95 }
        },
        
        /* GRAYSCALE. DEPRECATED. REMOVE ONCE OPENGL FILTERS ARE IMPLEMENTED */
        {
            { 0x10, 0x10, 0x10 },
            { 0xff, 0xff, 0xff },
            { 0x70, 0x70, 0x70 },
            { 0xE1, 0xE1, 0xE1 },
            { 0x8c, 0x8c, 0x8c },
            { 0xB9, 0xB9, 0xB9 },
            { 0x55, 0x55, 0x55 },
            { 0xed, 0xed, 0xed },
            { 0xa5, 0xa5, 0xa5 },
            { 0x78, 0x78, 0x78 },
            { 0xb4, 0xb4, 0xb4 },
            { 0x54, 0x54, 0x54 },
            { 0x88, 0x88, 0x88 },
            { 0xdc, 0xdc, 0xdc },
            { 0xa7, 0xa7, 0xa7 },
            { 0xc0, 0xc0, 0xc0 }
        }
    };

    colorScheme = scheme;
    for (unsigned i = 0; i < 16; i++) {
        c64->vic->setColor(i, LO_LO_HI_HI(rgb[scheme][i][0],rgb[scheme][i][1],rgb[scheme][i][2],0xFF));
    }
}

@end