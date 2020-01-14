package view;

import javax.swing.JFrame;
import javax.swing.JPanel;
import javax.swing.JScrollPane;
import javax.swing.JLabel;
import javax.swing.JTextField;
import javax.swing.table.DefaultTableModel;

import manager.Strategy;
import model.PageTableEntry;
import model.PhysicalMemoryPage;
import model.PhysicalPageNumber;
import model.VirtualPageNumber;

import java.awt.event.ActionListener;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;

import javax.swing.JButton;
import javax.swing.JTable;
import javax.swing.JTextPane;
import javax.swing.JComboBox;

public class Window extends JFrame{
	private JTextField vpnBitsTextField;
	private JTextField ppnBitsTextField;
	private JTextField offsetBitsTextField;
	private JTextField tlbSizeTextField;
	private JPanel initialSettingsPanel;
	private JLabel vpnBitsLabel;
	private JLabel ppnBitsLabel;
	private JLabel offsetBitsLabel;
	private JLabel tlbSizeLabel;
	private JLabel initialSettingsLabel;
	private JButton submitButton;
	private JLabel strategyLabel;
	private JComboBox strategyComboBox;
	
	private JPanel tlbPanel;
	private JLabel tlbLabel;
	private JScrollPane tlbScrollPane;
	private JTable tlbTable;
	private DefaultTableModel tlbModel;
	
	private JPanel loadPanel;
	private JLabel loadInstructionLabel;
	private JLabel loadLabel;
	private JTextField addressTextField;
	private JButton submitAddrButton;
	private JButton genRandomButton;
	
	private JPanel physicalMemPanel;
	private JLabel physicalMemoryLabel;
	private JScrollPane pmScrollPane;
	private JTable pmTable;
	private DefaultTableModel pmModel;
	
	private JPanel pageTablePanel;
	private JLabel pageTableLabel;
	private JScrollPane ptScrollPane;
	private JTable ptTable;
	private DefaultTableModel ptModel;
	
	private JPanel logPanel;
	private JTextPane logTextPane;
	private JLabel logLabel;
	private JButton nextButton;
	
	public Window()
	{
		System.out.println("Here's GUI, nice to meet you!");
		getContentPane().setLayout(null);
		
		initialSettingsPanel = new JPanel();
		initialSettingsPanel.setBounds(22, 13, 167, 394);
		getContentPane().add(initialSettingsPanel);
		initialSettingsPanel.setLayout(null);
		
		vpnBitsLabel = new JLabel("VPN bits:");
		vpnBitsLabel.setBounds(12, 38, 56, 16);
		initialSettingsPanel.add(vpnBitsLabel);
		
		vpnBitsTextField = new JTextField();
		vpnBitsTextField.setBounds(12, 65, 116, 22);
		initialSettingsPanel.add(vpnBitsTextField);
		vpnBitsTextField.setColumns(10);
		
		ppnBitsLabel = new JLabel("PPN bits:");
		ppnBitsLabel.setBounds(12, 100, 56, 16);
		initialSettingsPanel.add(ppnBitsLabel);
		
		ppnBitsTextField = new JTextField();
		ppnBitsTextField.setColumns(10);
		ppnBitsTextField.setBounds(12, 129, 116, 22);
		initialSettingsPanel.add(ppnBitsTextField);
		
		offsetBitsLabel = new JLabel("Offset bits:");
		offsetBitsLabel.setBounds(12, 164, 71, 16);
		initialSettingsPanel.add(offsetBitsLabel);
		
		offsetBitsTextField = new JTextField();
		offsetBitsTextField.setColumns(10);
		offsetBitsTextField.setBounds(12, 193, 116, 22);
		initialSettingsPanel.add(offsetBitsTextField);
		
		tlbSizeLabel = new JLabel("TLB size:");
		tlbSizeLabel.setBounds(12, 228, 56, 16);
		initialSettingsPanel.add(tlbSizeLabel);
		
		tlbSizeTextField = new JTextField();
		tlbSizeTextField.setBounds(12, 257, 116, 22);
		initialSettingsPanel.add(tlbSizeTextField);
		tlbSizeTextField.setColumns(10);
		
		initialSettingsLabel = new JLabel("Initial Settings");
		initialSettingsLabel.setBounds(46, 9, 94, 16);
		initialSettingsPanel.add(initialSettingsLabel);
		
		submitButton = new JButton("Submit");
		submitButton.setBounds(31, 356, 97, 25);
		initialSettingsPanel.add(submitButton);
		
		strategyComboBox = new JComboBox(Strategy.values());
		strategyComboBox.setBounds(12, 321, 71, 22);
		initialSettingsPanel.add(strategyComboBox);
		
		strategyLabel = new JLabel("Strategy:");
		strategyLabel.setBounds(12, 292, 56, 16);
		initialSettingsPanel.add(strategyLabel);
		
		tlbPanel = new JPanel();
		tlbPanel.setBounds(12, 424, 341, 287);
		getContentPane().add(tlbPanel);
		tlbPanel.setLayout(null);
		
		tlbLabel = new JLabel("TLB");
		tlbLabel.setBounds(160, 13, 32, 16);
		tlbPanel.add(tlbLabel);
		
		tlbModel = new DefaultTableModel();
		tlbTable = new JTable(tlbModel);
		
		tlbScrollPane = new JScrollPane(tlbTable);
		tlbScrollPane.setBounds(12, 55, 317, 217);
		tlbPanel.add(tlbScrollPane);
		
		physicalMemPanel = new JPanel();
		physicalMemPanel.setBounds(718, 424, 316, 287);
		getContentPane().add(physicalMemPanel);
		physicalMemPanel.setLayout(null);
		
		physicalMemoryLabel = new JLabel("Physical Memory");
		physicalMemoryLabel.setBounds(115, 13, 102, 16);
		physicalMemPanel.add(physicalMemoryLabel);
		
		pmModel = new DefaultTableModel();
		pmTable = new JTable(pmModel);
		
		pmScrollPane = new JScrollPane(pmTable);
		pmScrollPane.setBounds(12, 55, 292, 219);
		physicalMemPanel.add(pmScrollPane);
		
		pageTablePanel = new JPanel();
		pageTablePanel.setBounds(365, 424, 341, 287);
		getContentPane().add(pageTablePanel);
		pageTablePanel.setLayout(null);
		
		pageTableLabel = new JLabel("Page Table");
		pageTableLabel.setBounds(136, 13, 64, 16);
		pageTablePanel.add(pageTableLabel);
		
		ptModel = new DefaultTableModel();
		ptTable = new JTable(ptModel);
		
		ptScrollPane = new JScrollPane(ptTable);
		ptScrollPane.setBounds(12, 53, 317, 221);
		pageTablePanel.add(ptScrollPane);
		
		logPanel = new JPanel();
		logPanel.setBounds(201, 157, 495, 250);
		getContentPane().add(logPanel);
		logPanel.setLayout(null);
		
		logTextPane = new JTextPane();
		logTextPane.setBounds(12, 42, 471, 157);
		logPanel.add(logTextPane);
		
		logLabel = new JLabel("Log");
		logLabel.setBounds(243, 13, 28, 16);
		logPanel.add(logLabel);
		
		nextButton = new JButton("Next");
		nextButton.setBounds(209, 212, 97, 25);
		logPanel.add(nextButton);
		
		loadPanel = new JPanel();
		loadPanel.setBounds(201, 13, 495, 133);
		getContentPane().add(loadPanel);
		loadPanel.setLayout(null);
		
		loadInstructionLabel = new JLabel("Load Instruction");
		loadInstructionLabel.setBounds(205, 13, 100, 16);
		loadPanel.add(loadInstructionLabel);
		
		loadLabel = new JLabel("Load: ");
		loadLabel.setBounds(12, 53, 56, 16);
		loadPanel.add(loadLabel);
		
		addressTextField = new JTextField();
		addressTextField.setBounds(49, 50, 172, 22);
		loadPanel.add(addressTextField);
		addressTextField.setColumns(10);
		
		genRandomButton = new JButton("Gen. Random");
		genRandomButton.setBounds(258, 95, 116, 25);
		loadPanel.add(genRandomButton);
		
		submitAddrButton = new JButton("Submit");
		submitAddrButton.setBounds(386, 95, 97, 25);
		loadPanel.add(submitAddrButton);
		
		this.populateTlbTableInitially(tlbModel);
		this.populatePmTableInitially(pmModel);
		this.populatePtTableInitially(ptModel);
		
		this.setSize(1056, 760);
		this.setVisible(true);
		this.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
	}
	
	private void populateTlbTableInitially(DefaultTableModel model) {
		model.setDataVector(new Object[0][0], new Object[0]);
		model.addColumn("VPN");
		model.addColumn("PPN");
		model.addColumn("Clock");
	}
	
	public void populateTlbTable(DefaultTableModel model, HashMap<VirtualPageNumber, PhysicalPageNumber> tlb) {
		model.setDataVector(new Object[0][0], new Object[0]);
		model.addColumn("VPN");
		model.addColumn("PPN");
		model.addColumn("Clock");
		
		HashSet<VirtualPageNumber> vpnSet =  new HashSet(tlb.keySet());
		Iterator<VirtualPageNumber> it = vpnSet.iterator();
		VirtualPageNumber currentVpn; 
		PhysicalPageNumber ppn;
		
		while(it.hasNext()) {
			currentVpn = it.next();
			ppn = tlb.get(currentVpn);
			
			Object rowData[] = {currentVpn.getPageNumber(), ppn.getPhysicalPageNumber(), currentVpn.getClock()};
			model.addRow(rowData);
		}
	}
	
	private void populatePtTableInitially(DefaultTableModel model) {
		model.setDataVector(new Object[0][0], new Object[0]);
		model.addColumn("No.");
		model.addColumn("Valid");
		model.addColumn("PPN");
	}
	
	public void populatePtTable(DefaultTableModel model, HashMap<VirtualPageNumber, PageTableEntry> pageTable) {
		model.setDataVector(new Object[0][0], new Object[0]);
		model.addColumn("No.");
		model.addColumn("Valid");
		model.addColumn("PPN");
		
		HashSet<VirtualPageNumber> vpnSet =  new HashSet(pageTable.keySet());
		Iterator<VirtualPageNumber> it = vpnSet.iterator();
		VirtualPageNumber currentVpn; 
		PageTableEntry pte;
		
		while(it.hasNext()) {
			currentVpn = it.next();
			pte = pageTable.get(currentVpn);
			
			Object rowData[] = {currentVpn.getPageNumber(), pte.isValid(), pte.getPpn().getPhysicalPageNumber()};
			model.addRow(rowData);
		}
	}
	
	private void populatePmTableInitially(DefaultTableModel model) {
		model.setDataVector(new Object[0][0], new Object[0]);
		model.addColumn("No.");
		model.addColumn("DB");
		model.addColumn("VPN");
		model.addColumn("Clock");
	}
	
	public void populatePmTable(DefaultTableModel model, HashMap<PhysicalPageNumber, PhysicalMemoryPage>  physicalMemory) {
		model.setDataVector(new Object[0][0], new Object[0]);
		
		model.addColumn("No.");
		model.addColumn("DB");
		model.addColumn("VPN");
		model.addColumn("Clock");
		
		HashSet<PhysicalPageNumber> ppnSet =  new HashSet(physicalMemory.keySet());
		Iterator<PhysicalPageNumber> it = ppnSet.iterator();
		PhysicalPageNumber currentPpn; 
		PhysicalMemoryPage pmp;
		
		while(it.hasNext()) {
			currentPpn = it.next();
			pmp = physicalMemory.get(currentPpn);
			
			Object rowData[] = {currentPpn.getPhysicalPageNumber(), pmp.isDirtyBit(), pmp.getVirtualPageNumber().getPageNumber(), pmp.getClock()};
			model.addRow(rowData);
		}
		
	}
	
	public void addSubmitSettingsButtonActionListener(final ActionListener al) {
		this.submitButton.addActionListener(al);
	}
	
	public void addGenRandomButtonActionListener(final ActionListener al) {
		this.genRandomButton.addActionListener(al);
	}
	
	public void addSubmitAddrButtonActionListener(final ActionListener al) {
		this.submitAddrButton.addActionListener(al);
	}
	
	public void addNextButtonActionListener(final ActionListener al) {
		this.nextButton.addActionListener(al);
	}

	public JTextField getVpnBitsTextField() {
		return vpnBitsTextField;
	}

	public JTextField getPpnBitsTextField() {
		return ppnBitsTextField;
	}

	public JTextField getOffsetBitsTextField() {
		return offsetBitsTextField;
	}

	public JTextField getTlbSizeTextField() {
		return tlbSizeTextField;
	}

	public JTextField getAddressTextField() {
		return addressTextField;
	}

	public JComboBox getStrategyComboBox() {
		return strategyComboBox;
	}

	public JTextPane getLogTextPane() {
		return logTextPane;
	}

	public DefaultTableModel getTlbModel() {
		return tlbModel;
	}

	public DefaultTableModel getPmModel() {
		return pmModel;
	}

	public DefaultTableModel getPtModel() {
		return ptModel;
	}
	
	
}
