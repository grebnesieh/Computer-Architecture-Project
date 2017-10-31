# Computer-Architecture-Project
Way Prediciton | FIFO | Write Through | 2 Way Set-Associative | 512B size | 32B cache line

(Note: the cache design is pretty shit, well, not shit, but not really representative of how it would look like from the hardware perspective, might wanna change that. Everything apart from this note is exactly how it was when I submitted the project ~2 years ago.)

32 8-bit registers make up a cache block, 16 blocks -- 8 sets make up the cache<br />
each block has a<br />
&nbsp;&nbsp;&nbsp;&nbsp;	tag: 		24 bits<br />
&nbsp;&nbsp;&nbsp;&nbsp;	index: 		3 bits<br />
&nbsp;&nbsp;&nbsp;&nbsp;	offset:		5 bits<br />
each set has a<br />
&nbsp;&nbsp;&nbsp;&nbsp;	mru: 		1 bit<br />
&nbsp;&nbsp;&nbsp;&nbsp;	first_in: 	1 bit

the cache has an input signal - active - which must be set for any access (read/write)<br />
the cache gives an output signal - busy - when high, the external service must wait for data to be fetched/located<br />
on a miss the cache reads data from a memory, 1 byte at a time (+32 cycle delay)

the internal logic operates on a 3 state fsm<br />
state 00 <br />
&nbsp;&nbsp;&nbsp;&nbsp;	the first state for any read/write<br />
&nbsp;&nbsp;&nbsp;&nbsp;	generates the 'active block' based on a combination of index and the mru bit or the set<br />
&nbsp;&nbsp;&nbsp;&nbsp;	checks tag and validity, if a match, data will be retrived via the circuits in place<br />
&nbsp;&nbsp;&nbsp;&nbsp;	if invalid, we can assume that the other block is invalid as well (this being the mru) so immediately begin fetching the block from memory (state 10)<br />
state 01<br />
&nbsp;&nbsp;&nbsp;&nbsp;	pretty much the same as 00, just check ~mru<br />
state 10<br />
&nbsp;&nbsp;&nbsp;&nbsp;	fetching phase<br />
&nbsp;&nbsp;&nbsp;&nbsp;	uses a counter to fetch the bytes from memory one by one<br />
revert to state 00 when finished, no need for a final state - the busy flag handles that signal

--the cache is currently used over the data memory whereas the instruction memory is being used directly<br />
--a 1K memory instantiation serves as the backdrop of cache<br />
--the data memory in instantiated to a value equivalent to twice that of its address, to have some values to play with<br />
--instructions can be hard coded into instruction memory for testing<br />

testbenches:
-- cache_tester has hardcoded cache accesses which will showcase the stall, mru, fifo, and fetching capabilities, comment out the monitor line from cache block to observe how the tags change for the first 4 blocks over time<br />
		3 memory blocks are loaded into the cache, all belonging to same set, resulting in 3 cache misses for each of them, reading from the mru is in same cycle whereas reading from ~mru takes an extra cycle, similarily loading into the empty set takes 32 cycles whereas 33 for a partially or fully filled set<br />
-- datapath_tester is a basic bench providing clock and reset<br />
&nbsp;&nbsp;&nbsp;&nbsp;	instructions need to be loaded into instruction memory<br />
&nbsp;&nbsp;&nbsp;&nbsp;	a monitor statement runs over the cycle_number and the entirety of the regfile<br />
&nbsp;&nbsp;&nbsp;&nbsp;	several test files are present to take instructions for testing, with comments as to their purpose<br />
