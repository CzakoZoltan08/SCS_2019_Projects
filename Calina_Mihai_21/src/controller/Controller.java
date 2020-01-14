package controller;

import javax.swing.JOptionPane;

import manager.Manager;
import manager.Strategy;
import model.VirtualAddress;
import model.WrongFormatException;
import view.Window;

public class Controller {
	private Window window;
	private Manager manager;
	private int vpnBits;
	private int ppnBits;
	private int offsetBits;
	private int tlbSize;
	private Strategy strategy;
	private State state;
	private VirtualAddress currentAddress;
	
	public void start() {
		this.window = new Window();
		this.state = State.TLB_SEARCH;
		
		this.initializeActionListeners();
	}
	
	private void validateAddress(String userInput) throws WrongFormatException{
		int inputSize = userInput.length(); //in hex
		int maxAddrVal = this.manager.getMaxAddrVal();
		int userVal;
		int theoreticalSize, addrBits;
		
		addrBits = this.vpnBits + this.offsetBits;
		userVal = Integer.parseInt(userInput, 16);
		
		/*if(addrBits > 32) {
			throw new WrongFormatException("Only addresses of maximum 32 bits are supported");
		}*/
		
		if(addrBits % 4 == 0) {
			theoreticalSize = addrBits / 4;
		}else {
			theoreticalSize = addrBits / 4 + 1;
		}
		
		if(inputSize > theoreticalSize) {
			throw new WrongFormatException("Address too large!");
		}
		
		if(!userInput.matches("^([1-9a-fA-F]{1}[0-9a-fA-F]*)$")) {
			throw new WrongFormatException("Wrong address format!");
		}
	}
	
	private void validateVpnSettings(String userInput) throws WrongFormatException {
		if(!userInput.matches("^([1-9]{1}[0-9]*)$")) {
			throw new WrongFormatException("Only numbers allowed!");
		}
	}
	
	private void validatePpnSettings(String userInput) throws WrongFormatException {
		if(!userInput.matches("^([1-9]{1}[0-9]*)$")) {
			throw new WrongFormatException("Only numbers allowed!");
		}
	}
	
	private void validateOffsetSettings(String userInput) throws WrongFormatException {
		if(!userInput.matches("^([1-9]{1}[0-9]*)$")) {
			throw new WrongFormatException("Only numbers allowed!");
		}
	}
	
	private void validateTlbSizeSettings(String userInput) throws WrongFormatException {
		if(!userInput.matches("^([1-9]{1}[0-9]*)$")) {
			throw new WrongFormatException("Only numbers allowed!");
		}
	}
	
	private void initializeActionListeners() {
		this.window.addSubmitSettingsButtonActionListener(e -> {
			this.vpnBits = Integer.parseInt(this.window.getVpnBitsTextField().getText());
			try {
				this.validateVpnSettings(this.window.getVpnBitsTextField().getText());
			} catch (WrongFormatException e1) {
				JOptionPane.showMessageDialog(this.window, e1.getMessage());
			}
			
			this.ppnBits = Integer.parseInt(this.window.getPpnBitsTextField().getText());
			try {
				this.validatePpnSettings(this.window.getPpnBitsTextField().getText());
			} catch (WrongFormatException e1) {
				JOptionPane.showMessageDialog(this.window, e1.getMessage());
			}
			
			this.offsetBits = Integer.parseInt(this.window.getOffsetBitsTextField().getText());
			try {
				this.validateOffsetSettings(this.window.getOffsetBitsTextField().getText());
			} catch (WrongFormatException e1) {
				JOptionPane.showMessageDialog(this.window, e1.getMessage());
			}
			
			this.tlbSize = Integer.parseInt(this.window.getTlbSizeTextField().getText());
			try {
				this.validateTlbSizeSettings(this.window.getTlbSizeTextField().getText());
			} catch (WrongFormatException e1) {
				JOptionPane.showMessageDialog(this.window, e1.getMessage());
			}
			
			this.strategy = (Strategy) this.window.getStrategyComboBox().getSelectedItem();
			
			this.manager = new Manager(this.strategy, this.vpnBits, this.ppnBits, this.offsetBits, this.tlbSize);
			//log: settings done
			//should I set the log depending on the state?
			this.window.getLogTextPane().setText("Settings done");
		});
		
		this.window.addGenRandomButtonActionListener(e -> {
			this.window.getAddressTextField().setText(Integer.toHexString(this.manager.generateAddress()));
		});
		
		this.window.addSubmitAddrButtonActionListener(e -> {
			//validate user input
			try {
				this.validateAddress(this.window.getAddressTextField().getText());
			} catch (WrongFormatException e1) {
				JOptionPane.showMessageDialog(this.window, e1.getMessage());
			}
			
			String stringAddress;
			int address;
			stringAddress = this.window.getAddressTextField().getText();
			address = Integer.parseInt(stringAddress, 16);
			
			currentAddress = this.manager.createAddress(address);
			//log: address created
			this.window.getLogTextPane().setText("Address created");
			this.state = State.TLB_SEARCH;
			Manager.clock++;
			
		});
		
		//next button will flow through the states
		
		this.window.addNextButtonActionListener(e -> {
			int physicalMemIndex = 0;
			
			switch(this.state) {
				case TLB_SEARCH:
					if(this.manager.tlbSearch(this.currentAddress)) {
						this.state = State.TLB_HIT;
					}else {
						this.state = State.TLB_MISS;
					}
					this.window.getLogTextPane().setText("Searching TLB");
					break;
				case TLB_HIT:
					this.manager.updatePhysicalMem(currentAddress);
					this.window.populatePmTable(this.window.getPmModel(), this.manager.getPhysicalMemory().getPhysicalMemory());
					this.window.getLogTextPane().setText("TLB hit: " + physicalMemIndex);
					this.state = State.END;
					break;
				case TLB_MISS:
					this.state = State.PAGE_TABLE_SEARCH;
					this.window.getLogTextPane().setText("TLB miss");
					break;
				case PAGE_TABLE_SEARCH:
					if(this.manager.pageTableSearch(currentAddress)) {
						this.state = State.PAGE_TABLE_HIT;
					}else {
						this.state = State.PAGE_TABLE_MISS;
					}
					this.window.getLogTextPane().setText("Page table search");
					break;
				case PAGE_TABLE_HIT:
					this.manager.updatePhysicalMem(currentAddress);
					this.manager.updateTlb(currentAddress);
					this.window.getLogTextPane().setText("Page table hit: " + physicalMemIndex);
					this.window.populateTlbTable(this.window.getTlbModel(), this.manager.getTlb().getTlb());
					this.window.populatePmTable(this.window.getPmModel(), this.manager.getPhysicalMemory().getPhysicalMemory());
					this.state = State.END;
					break;
				case PAGE_TABLE_MISS:
					this.state = State.UPDATE_PHYSICAL_MEMORY;
					this.window.getLogTextPane().setText("Page table miss");
					break;
				case UPDATE_TLB:
					this.manager.updateTlb(currentAddress);
					
					this.window.getLogTextPane().setText("Update tlb");
					this.state = State.END;
					this.window.populateTlbTable(this.window.getTlbModel(), this.manager.getTlb().getTlb());
					//updating tlb on GUI too
					break;
				case UPDATE_PAGE_TABLE:
					//physicalMemIndex is ppn
					this.manager.updatePageTable(currentAddress);
					
					this.window.getLogTextPane().setText("Update page table");
					this.state = State.UPDATE_TLB;
					this.window.populatePtTable(this.window.getPtModel(), this.manager.getPageTable().getPageTable());
					//updating page table on GUI too
					break;
				case UPDATE_PHYSICAL_MEMORY:
					
					if(this.manager.isMemFull()) {
						if(this.manager.getDirtyBitStatus()) {
							this.window.getLogTextPane().setText("The memory page is copied first inside the hard disk");
						}else {
							this.window.getLogTextPane().setText("The memory page has not been modified so it is not copied in the hard disk");
						}
					}
					
					this.manager.updatePhysicalMem(currentAddress);
					this.window.getLogTextPane().setText(this.window.getLogTextPane().getText() + "\nUpdate physical memory");
					
					
					this.state = State.UPDATE_PAGE_TABLE;
					this.window.populatePmTable(this.window.getPmModel(), this.manager.getPhysicalMemory().getPhysicalMemory());
					//updating physical memory table on GUI too
					break;
				case END:
					this.window.getLogTextPane().setText("End");
					break;
			}
			
		});
		
	}

}
