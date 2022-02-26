#include <verilated_vcd_c.h>
template<class MODULE>	class TESTBENCH {
	    public:

	unsigned long	m_tickcount;
	MODULE	*m_core;
    VerilatedVcdC	*m_trace;

	TESTBENCH(void) {
        Verilated::traceEverOn(true);
		m_core = new MODULE;
		m_tickcount = 0l;
	}

	virtual ~TESTBENCH(void) {
		delete m_core;
		m_core = nullptr;
	}

	virtual void	reset(void) {
		// m_core->i_reset = 1;
		// Make sure any inheritance gets applied
		this->tick();
		// m_core->i_reset = 0;
	}

    	// Open/create a trace file
	virtual	void opentrace(const char *vcdname) {
		if (!m_trace) {
			m_trace = new VerilatedVcdC;
			m_core->trace(m_trace, 99);
			m_trace->open(vcdname);
		}
	}

	// Close a trace file
	virtual void	close(void) {
		if (m_trace) {
			m_trace->close();
			m_trace = NULL;
		}
	}

	virtual void tick(void) {
		// Increment our own internal time reference
		m_tickcount++;

		// Make sure any combinatorial logic depending upon
		// inputs that may have changed before we called tick()
		// has settled before the rising edge of the clock.
		m_core->CLK = 0;
		m_core->eval();

// Here's the new item:
		//
		//	Dump values to our trace file
		//
		if(m_trace) m_trace->dump(10*m_tickcount-2);

		// Repeat for the positive edge of the clock
		m_core->CLK = 1;
		m_core->eval();
		if(m_trace) m_trace->dump(10*m_tickcount);

		// Now the negative edge
		m_core->CLK = 0;
		m_core->eval();
		if (m_trace) {
			// This portion, though, is a touch different.
			// After dumping our values as they exist on the
			// negative clock edge ...
			m_trace->dump(10*m_tickcount+5);
			//
			// We'll also need to make sure we flush any I/O to
			// the trace file, so that we can use the assert()
			// function between now and the next tick if we want to.
			m_trace->flush();
		}
	}

    virtual void address(bool A3, bool A2, bool A1, bool A0){
        m_core->A0 = A0;
        m_core->A1 = A1;
        m_core->A2 = A2;
        m_core->A3 = A3;
    }

    virtual void write(uint8_t addr, uint8_t data){
        m_core->R_W = 0;
        m_core->A0 = (addr & 0x1);
        m_core->A1 = ((addr >> 1) & 0x1);
        m_core->A2 = ((addr >> 2) & 0x1);
        m_core->A3 = ((addr >> 3) & 0x1);
        m_core->_CS = 0;
        m_core->DATA_IN = data;
        tick();
        tick();
        m_core->_CS = 1;        
        m_core->DATA_IN = 0x00;   
    }
    virtual char read(uint8_t addr){
        m_core->R_W = 1;
        m_core->A0 = (addr & 0x1);
        m_core->A1 = ((addr >> 1) & 0x1);
        m_core->A2 = ((addr >> 2) & 0x1);
        m_core->A3 = ((addr >> 3) & 0x1);
		tick();
        m_core->_CS = 0;
        tick();
        m_core->_CS = 1;        
		return m_core->DATA_OUT;
    }

	virtual bool	done(void) { return (Verilated::gotFinish()); }
};
