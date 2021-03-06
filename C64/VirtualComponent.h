/*
 * Author: Dirk W. Hoffmann, 2006 - 2015
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

#ifndef _VIRTUAL_COMPONENT_INC
#define _VIRTUAL_COMPONENT_INC

// Forward declarations
class C64;

#include "basic.h"

/*! @brief   Common functionality of all virtual computer components
 * @abstract This class defines the base functionality of all virtual components.
 *           The class comprises functions for resetting, suspending and resuming the component,
 *           as well as functions for loading and saving state (snapshots).
 */
class VirtualComponent {

public: 

    /*! @brief      Reference to the virtual C64 top-level object
     *  @discussion This reference is setup in the reset method and provides easy access to all 
     *              other components of the same virtual C64. */
    C64 *c64;

    //! Debug level
	/*! Determines which debug message are printed */
	static int debugLevel;	

protected:
	//! Name of this component
	const char *name;
    
private:
	//! Indicates whether the component is currently active.
	/*! All virtual components can be in two states. They can either be running or halted.
	    During normal operation, all components are running. If an error occurrs, or if the
	    user requests the virtual machine to halt in the debugger, the components will enter
	    the "halted" state. 
	*/	
	bool running;

	//! True iff tracing is enabled
	/*! In trace mode, all components are requested to dump debug informatik perodically.
		Only a few components will react to this flag.
	*/
	bool traceMode;
		
	//! The original state before the first call of suspend()
	bool suspendedState;

	//! Number of times the component is suspended  
	/*! The value is equal to the number of suspend calls minus the number of resume calls 
	*/
	int suspendCounter;
				
public:
	//! Log file
	/*! By default, this variable is NULL and all debug and trace messages are sent to
        stdout or stderr. Assign a file handle, if you wish to send debug output to a file
	 */
	FILE *logfile;

	//! Constructor
	VirtualComponent();

	//! Destructor
	virtual ~VirtualComponent();

	//! Assign name
	inline void setName(const char *componentName) { name = componentName; }
		
	//! Reset the component to its initial state.
	/*! The functions is called when a hard reset is performed.
	*/
	virtual void reset(C64 *c64); 
	
    //! Trigger the component to send messages about its current state.
    /*! The GUI invokes this function to update its visual elements, e.g., after loading an image file.
        Only a few components overwrite this function. All others stay silent on default.
     */
    virtual void ping();

	//! Print info about the internal state
	/*! This functions is intended for debugging purposes only. Any derived component should override
	 this method and print out some useful debugging information. 
	 */ 
	virtual void dumpState();
	
	//! Start component
	/*! The function is called when the virtual computer is requested to run
		Some components such as the CPU require asynchronously running threads and will start them here.
		Most of the other components are of a static nature and won't implement additional functionality.
	*/
	virtual void run();

	//! Returns true iff the component is running		
	virtual bool isRunning();
	
	//! Stop component
	/*! The function is called when the virtual computer is requested to freeze
		For example, the CPU will ask its asynchronously running thread to halt.
		Most of the other components are of a static nature and won't implement additional functionality.
	*/	
	virtual void halt();

	//! Returns true iff the component is halted
	virtual bool isHalted();

	// suspend : Current state is saved and CPU halted
	// resume  : Restore saved state
	//           Note: suspend()/resume() calls can be nested, i.e., 
	//           n x suspend() requires n x resume() to make the CPU flying again

	//! Suspend component
	/*! The suspend mechanism is a nested run/halt mechanism. First of all, it works like halt,
		i.e., the component freezes. In contrast to halt, the suspend function remembers whether
		the component was already halted or running. When the resume function is invoked, the original
		running state is reestablished. In other words: If your component is currently running and you
		suspend it 10 times, you'll have to resume it 10 times to make it run again.
	*/	
	void suspend();
	
	//! Resume component
	/*! This functions concludes a suspend operation.
		/seealso suspend. 
	*/
	void resume();

	//! Returns true iff trace mode is enabled
	inline bool tracingEnabled() { return traceMode; }

	//! Enable or disable trace mode
	inline void setTraceMode(bool b) { traceMode = b; }

	//! Print message
	void msg(const char *fmt, ...);
	//! Print debug message
	void debug(const char *fmt, ...);
	//! Print debug message (higher level = less output) 
	void debug(int level, const char *fmt, ...); 
	//! Print warning message
	void warn(const char *fmt, ...);
	//! Print error message and exit
	void panic(const char *fmt, ...);

    // ---------------------------------------------------------------------------------------------
    //                                      Snapshots
    // ---------------------------------------------------------------------------------------------
    
protected:
    
    /*! @brief Fingerprint of a snapshot item
     */
    typedef struct {
        
        void *data;
        unsigned size;
        
    } SnapshotItem;
    
    /*! @brief    List of snapshot items of this component
     *  @abstract Initial value is NULL, indicating that nothing is saved to a snapshot
     */
    SnapshotItem *snapshotItems;
    
    /*! @brief    Snapshot size on disk (in bytes)
     */
    unsigned snapshotSize;
    
    /*! @brief    Registers all snapshot items for this component
     *  @abstract Snaphshot items are usually registered in the constructor of a virtual component.
     *  @param    items Pointer to the first element of a SnapshotItem array. The end of the array
     *            is marked by a NULL pointer in the data field.
     *  @param    legth Size of the SnapshotItem array in bytes.
     */
    void registerSnapshotItems(SnapshotItem *items, unsigned length);
    
public:
    
    /*! @brief    Returns size of internal state in bytes
     */
    virtual uint32_t stateSize() { return snapshotSize; };
    
    /*! @brief    Load internal state from memory buffer
     *  @note     Snapshot items of size 2, 4, or 8 are converted automatically to big endian format.
     *            Take this into account when loading byte arrays of these sizes.
     *  @param    buffer Pointer to next byte to read
     */
    virtual void loadFromBuffer(uint8_t **buffer);
    
    /*! @brief    Save internal state to memory buffer
     *  @note     Snapshot items of size 2, 4, or 8 are converted automatically to big endian format.
     *            Take this into account when saving byte arrays of these sizes.
     *  @param    buffer Pointer to next byte to read
     */
    virtual void saveToBuffer(uint8_t **buffer);
    
    
    /*! @brief    Saves an 8 bit state item in big endian format
     */
    inline void write8(uint8_t **ptr, uint8_t value) { *((*ptr)++) = value; }
    
    /*! @brief    Saves a 16 bit state item in big endian format
     */
    inline void write16(uint8_t **ptr, uint16_t value) {
        write8(ptr, (uint8_t)(value >> 8)); write8(ptr, (uint8_t)value); }
    
    /*! @brief    Saves a 32 bit state item in big endian format
     */
    inline void write32(uint8_t **ptr, uint32_t value) {
        write16(ptr, (uint16_t)(value >> 16)); write16(ptr, (uint16_t)value); }
    
    /*! @brief    Saves a 64 bit state item in big endian format
     */
    inline void write64(uint8_t **ptr, uint64_t value) {
        write32(ptr, (uint32_t)(value >> 32)); write32(ptr, (uint32_t)value); }
    
    /*! @brief    Saves a byte block of arbitarary size
     *  @param    values Pointer the the first byte
     *  @param    length Number of bytes to save.
     */
    inline void writeBlock(uint8_t **ptr, uint8_t *values, size_t length) {
        memcpy(*ptr, values, length); *ptr += length; }
    
    /*! @brief    Saves a word block of arbitarary size in big endian format
     *  @param    values Pointer the the first word
     *  @param    length Size of the word block in bytes.
     */
    inline void writeBlock16(uint8_t **ptr, uint16_t *values, size_t length) {
        for (unsigned i = 0; i < length / sizeof(uint16_t); i++) write16(ptr, values[i]); }
    
    /*! @brief    Reads a 64 bit state item in big endian format
     */
    inline uint8_t read8(uint8_t **ptr) { return (uint8_t)(*((*ptr)++)); }
    
    /*! @brief    Reads a 16 bit state item in big endian format
     */
    inline uint16_t read16(uint8_t **ptr) { return ((uint16_t)read8(ptr) << 8) | (uint16_t)read8(ptr); }
    
    /*! @brief    Reads a 32 bit state item in big endian format
     */
    inline uint32_t read32(uint8_t **ptr) { return ((uint32_t)read16(ptr) << 16) | (uint32_t)read16(ptr); }
    
    /*! @brief    Reads a 64 bit state item in big endian format
     */
    inline uint64_t read64(uint8_t **ptr) { return ((uint64_t)read32(ptr) << 32) | (uint64_t)read32(ptr); }
    
    /*! @brief    Loads a byte block of arbitarary size
     *  @param    values Pointer the the first byte
     *  @param    length Number of bytes to load.
     */
    inline void readBlock(uint8_t **ptr, uint8_t *values, size_t length) { memcpy(values, *ptr, length); *ptr += length; }
    
    /*! @brief    Loads a word block of arbitarary size in big endian format
     *  @param    values Pointer the the first word
     *  @param    length Size of the word block in bytes.
     */
    inline void readBlock16(uint8_t **ptr, uint16_t *values, size_t length) {
        for (unsigned i = 0; i < length / sizeof(uint16_t); i++) values[i] = read16(ptr); }
    

};

#endif

