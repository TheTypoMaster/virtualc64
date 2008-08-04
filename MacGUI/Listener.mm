/*
 * (C) 2008 Dirk W. Hoffmann. All rights reserved.
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
 */

#import "Listener.h"

@implementation MyDocument (Listener)


- (void) loadRomAction:(int)rom
{
	switch (rom) {
		case BASIC_ROM:
			[info setStringValue:@"Basic Rom loaded"];
			break;
		case CHAR_ROM:
			[info setStringValue:@"Character Rom loaded"];
			break;
		case KERNEL_ROM:
			[info setStringValue:@"Kernel Rom loaded"];
			break;
		case VC1541_ROM:
			[info setStringValue:@"VC1541 Rom loaded"];
			break;
	}

	// Update ROM dialog
	if (romDialog != NULL)
		[romDialog update:[c64 missingRoms]];
	
	// Launch emulator when all Roms are loaded...
	if ([c64 numberOfMissingRoms] == 0 && [c64 isHalted]) {
		[screen zoom];
		[c64 run];
	}
}
	
- (void) missingRomAction:(int)missingRoms
{
	// NSString *s;
	
	assert(missingRoms != 0);

#if 0
	s = [NSString stringWithFormat:@"%@ %s%s%s%s",
		 @"If you are a legal owner, please drag and drop the following ROM images into the main screen:\n",
		 missingRoms & BASIC_ROM ? "\n- Basic ROM" : "",
		 missingRoms & CHAR_ROM ? "\n- Character ROM" : "",
		 missingRoms & KERNEL_ROM ? "\n- Kernel ROM" : "",
		 missingRoms & VC1541_ROM ? "\n- VC1541 ROM" : ""];
	
	NSBeginAlertSheet(@"Copyright notice:\nROMs are not part of this distribution", // Title
					  @"OK", // Default button
					  nil, // Alternate button
					  nil, // Other button
					  theWindow, // parent window of the sheet
					  self, // Modal delegate
					  nil, // willEndSelector
					  nil, // didEndSelector
					  nil, // contextInfo
					  s);
#endif
	
	[romDialog initialize:missingRoms];
	
	[NSApp beginSheet:romDialog
	   modalForWindow:theWindow
		modalDelegate:self
	   didEndSelector:NULL
		  contextInfo:NULL];	
}

- (void) runAction
{
	NSAutoreleasePool* arp = [[NSAutoreleasePool alloc] init];

	NSLog(@"runAction");
	[info setStringValue:@""];
	
	// disable user editing 
	[self enableUserEditing:NO];
	
	// disable undo because the internal state changes permanently
	[self updateChangeCount:NSChangeDone];
	[[self undoManager] removeAllActions];

	[self refresh];
	
	[arp release];
}

- (void) haltAction
{
	NSAutoreleasePool* arp = [[NSAutoreleasePool alloc] init];
	
	NSLog(@"haltAction");
	[info setStringValue:@"Emulation halted."];
	[self enableUserEditing:YES];	
	[self refresh];

	[arp release];
}

- (void) cpuAction:(CPU::ErrorState)state;
{
	NSAutoreleasePool* arp = [[NSAutoreleasePool alloc] init];

	NSLog(@"cpuAction");
	switch(state) {
		case CPU::OK: 
			[info setStringValue:@""];
			break;
		case CPU::BREAKPOINT_REACHED:
			[info setStringValue:@"Breakpoint reached."];
			[self enableUserEditing:YES];	
			break;
		case CPU::WATCHPOINT_REACHED:
			[info setStringValue:@"Watchpoint reached."];
			[self enableUserEditing:YES];	
			break;
		case CPU::ILLEGAL_INSTRUCTION:
			[info setStringValue:@"CPU halted due to an illegal instruction."];
			[self enableUserEditing:YES];	
			break;
		default:
			assert(0);
	}
	[self refresh];

	[arp release];
}

- (void) driveAttachedAction:(BOOL)connected
{
	NSAutoreleasePool* arp = [[NSAutoreleasePool alloc] init];

	NSLog(@"driveAttachedAction");
	if (connected)
		[greenLED setImage:[NSImage imageNamed:@"LEDgreen"]];
	else
		[greenLED setImage:[NSImage imageNamed:@"LEDgray"]];

	[arp release];
}

- (void) driveDiscAction:(BOOL)inserted
{
	NSAutoreleasePool* arp = [[NSAutoreleasePool alloc] init];
	
	NSLog(@"driveDiscAction");
	[drive setHidden:!inserted];
	[eject setHidden:!inserted];

	[arp release];
}

- (void) driveLEDAction:(BOOL)on
{
	NSAutoreleasePool* arp = [[NSAutoreleasePool alloc] init];
	
	NSLog(@"driveLEDAction");
	if (on)
		[redLED setImage:[NSImage imageNamed:@"LEDred"]];
	else
		[redLED setImage:[NSImage imageNamed:@"LEDgray"]];
	
	[arp release];	
}

- (void) driveDataAction:(BOOL)transfering
{
	NSAutoreleasePool* arp = [[NSAutoreleasePool alloc] init];

	NSLog(@"driveDataAction");
	// MESSAGE IS NOT SEND YET 
	// don't now how to determine reliably if data is transferred

	[arp release];
}

- (void) driveMotorAction:(BOOL)rotating
{
	NSAutoreleasePool* arp = [[NSAutoreleasePool alloc] init];

	NSLog(@"driveMotorAction");
	if (rotating) {
		[driveBusy setHidden:false];
		[driveBusy startAnimation:self];
	} else {
		[driveBusy stopAnimation:self];
		[driveBusy setHidden:true];
	}
	
	[arp release];
}

- (void) warpmodeAction:(BOOL)warping
{
	NSAutoreleasePool* arp = [[NSAutoreleasePool alloc] init];
	
	NSLog(@"warpmodeAction");

//	if (warping)
//		[warpMode setImage:[NSImage imageNamed:@"warpOff"]];
//	else
//		[warpMode setImage:[NSImage imageNamed:@"warpOn"]];
	
	[arp release];
}

- (void) logAction:(char *)message
{
	NSAutoreleasePool* arp = [[NSAutoreleasePool alloc] init];

	if (consoleController) {
		[consoleController insertText:message];
	}
	
	[arp release];
}

@end