import 'package:flutter/material.dart';

class TransactionView extends StatefulWidget {
  const TransactionView({super.key});

  @override
  State<TransactionView> createState() => _TransactionViewState();
}

class _TransactionViewState extends State<TransactionView> {
  // Mock data representing extracted data from a bank passbook PDF
  final List<Map<String, dynamic>> _transactions = [
    {
      'date': '2026-04-01',
      'particulars': 'TRF FROM JATIN INVESQ',
      'chqNo': '-',
      'withdrawal': 0.0,
      'deposit': 50000.0,
      'balance': 50000.0,
      'status': 'Verified',
    },
    {
      'date': '2026-04-03',
      'particulars': 'UPI-AMAZON PAY-PURCHASE',
      'chqNo': '-',
      'withdrawal': 1250.0,
      'deposit': 0.0,
      'balance': 48750.0,
      'status': 'Verified',
    },
    {
      'date': '2026-04-05',
      'particulars': 'ATM CASH WITHDRAWAL',
      'chqNo': '123456',
      'withdrawal': 10000.0,
      'deposit': 0.0,
      'balance': 38750.0,
      'status': 'Verified',
    },
    {
      'date': '2026-04-10',
      'particulars': 'INTEREST CREDITED',
      'chqNo': '-',
      'withdrawal': 0.0,
      'deposit': 450.0,
      'balance': 39200.0,
      'status': 'Flagged',
    },
    {
      'date': '2026-04-15',
      'particulars': 'ZOMATO OSML',
      'chqNo': '-',
      'withdrawal': 450.0,
      'deposit': 0.0,
      'balance': 38750.0,
      'status': 'Verified',
    },
    {
      'date': '2026-04-20',
      'particulars': 'TRF TO SELF DEPOSIT',
      'chqNo': '-',
      'withdrawal': 5000.0,
      'deposit': 0.0,
      'balance': 33750.0,
      'status': 'Unreconciled',
    },
    {
      'date': '2026-04-25',
      'particulars': 'DIVIDEND - TCS',
      'chqNo': '-',
      'withdrawal': 0.0,
      'deposit': 1500.0,
      'balance': 35250.0,
      'status': 'Verified',
    },
    {
      'date': '2026-04-28',
      'particulars': 'BROKERAGE CHARGES',
      'chqNo': '-',
      'withdrawal': 75.50,
      'deposit': 0.0,
      'balance': 35174.50,
      'status': 'Verified',
    },
  ];

  String _searchQuery = '';
  String _selectedStatus = 'All';
  int? _selectedIndex;
  int? _editingRowIndex;
  String? _editingField;
  DateTime _selectedDate = DateTime(2026, 4, 1);

  static const _months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  @override
  Widget build(BuildContext context) {
    // Filtered list based on search and status
    final filteredTransactions = _transactions.where((tx) {
      final matchesSearch = tx['particulars'].toString().toLowerCase().contains(
        _searchQuery.toLowerCase(),
      );
      final matchesStatus =
          _selectedStatus == 'All' || tx['status'] == _selectedStatus;
      return matchesSearch && matchesStatus;
    }).toList();

    // Calculate totals
    final totalWithdrawals = _transactions.fold<double>(
      0,
      (sum, item) => sum + (item['withdrawal'] as double),
    );
    final totalDeposits = _transactions.fold<double>(
      0,
      (sum, item) => sum + (item['deposit'] as double),
    );
    final netBalance = totalDeposits - totalWithdrawals;

    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6), // Slate 100
      body: Row(
        children: [
          // Left Sidebar - PDF Info & Summary
          _buildSidebar(totalDeposits, totalWithdrawals, netBalance),

          // Right Main Content - Transaction Table
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 24),
                  _buildFilterBar(),
                  const SizedBox(height: 16),
                  Expanded(child: _buildTransactionTable(filteredTransactions)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSidebar(double deposits, double withdrawals, double balance) {
    return Container(
      width: 320,
      color: Colors.white,
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // App/Feature Title
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.indigo.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.account_balance, color: Colors.indigo),
              ),
              const SizedBox(width: 12),
              const Text(
                'Zego Parse',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E293B),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),

          // PDF Source Info Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(
                      Icons.picture_as_pdf,
                      color: Colors.redAccent,
                      size: 20,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Source Document',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Text(
                  'HDFC_Passbook_Q1.pdf',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Extracted on 08 May 2026',
                  style: TextStyle(fontSize: 12, color: Color(0xFF94A3B8)),
                ),
                const SizedBox(height: 12),
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.refresh, size: 16),
                  label: const Text('Re-parse'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.indigo,
                    elevation: 0,
                    side: const BorderSide(color: Colors.indigo),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),

          // Financial Summary
          const Text(
            'Summary',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 16),
          _buildSummaryItem(
            'Total Deposits',
            deposits,
            const Color(0xFF10B981),
          ),
          const SizedBox(height: 12),
          _buildSummaryItem('Total Withdrawals', withdrawals, Colors.redAccent),
          const SizedBox(height: 12),
          const Divider(),
          const SizedBox(height: 12),
          _buildSummaryItem(
            'Net Balance',
            balance,
            Colors.indigo,
            isBold: true,
          ),

          const Spacer(),

          // Action Buttons
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.file_download),
              label: const Text('Export to Excel'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(
    String label,
    double amount,
    Color color, {
    bool isBold = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            color: const Color(0xFF64748B),
          ),
        ),
        Text(
          '₹${amount.toStringAsFixed(2)}',
          style: TextStyle(
            fontSize: 14,
            fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Transactions',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F172A),
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Review and reconcile data extracted from the bank passbook.',
                style: TextStyle(fontSize: 14, color: Color(0xFF64748B)),
              ),
            ],
          ),
        ),
        Row(
          children: [
            OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.help_outline, size: 18),
              label: const Text('Help'),
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFF64748B),
                side: const BorderSide(color: Color(0xFFE2E8F0)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(width: 12),
            ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.check),
              label: const Text('Approve All'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF10B981),
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFilterBar() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // Filter Bar (White Container)
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: Row(
            children: [
              // Search Field
              Expanded(
                child: TextField(
                  textAlignVertical: TextAlignVertical.center,
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                  decoration: const InputDecoration(
                    hintText: 'Search particulars...',
                    hintStyle: TextStyle(
                      color: Color(0xFF94A3B8),
                      fontSize: 14,
                    ),
                    prefixIcon: Icon(
                      Icons.search,
                      color: Color(0xFF94A3B8),
                      size: 20,
                    ),
                    border: InputBorder.none,
                    isDense: true,
                  ),
                ),
              ),
              const SizedBox(width: 16),

              // Status Filter Dropdown
              Container(
                height: 36,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedStatus,
                    borderRadius: BorderRadius.circular(12),
                    dropdownColor: Colors.white,
                    elevation: 3,
                    items: ['All', 'Verified', 'Flagged', 'Unreconciled']
                        .map(
                          (status) => DropdownMenuItem(
                            value: status,
                            child: Text(
                              status,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Color(0xFF0F172A),
                              ),
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedStatus = value!;
                      });
                    },
                    icon: const Icon(Icons.keyboard_arrow_down, size: 18),
                  ),
                ),
              ),
              const SizedBox(width: 12),

              // Date Range Picker Button (Mock)
              OutlinedButton.icon(
                onPressed: () async {
                  final DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: _selectedDate,
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2030),
                  );
                  if (picked != null) {
                    setState(() {
                      _selectedDate = picked;
                    });
                  }
                },
                icon: const Icon(Icons.date_range, size: 16),
                label: Text(
                  '${_months[_selectedDate.month - 1]} ${_selectedDate.year}',
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF0F172A),
                  side: const BorderSide(color: Color(0xFFE2E8F0)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),

        // Actions (Below and Right aligned)
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            // Add Transaction Button
            ElevatedButton.icon(
              onPressed: () => _showAddTransactionDialog(context),
              icon: const Icon(Icons.add, size: 16),
              label: const Text('Add'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF10B981),
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(width: 8),

            // Remove Transaction Button
            OutlinedButton.icon(
              onPressed: () => _removeSelectedTransaction(),
              icon: const Icon(Icons.remove, size: 16),
              label: const Text('Remove'),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.redAccent,
                side: const BorderSide(color: Colors.redAccent),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTransactionTable(List<Map<String, dynamic>> transactions) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        children: [
          // Table Header
          Container(
            color: const Color(0xFFF8FAFC),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: const Row(
              children: [
                Expanded(flex: 2, child: Text('Date', style: _headerStyle)),
                Expanded(
                  flex: 4,
                  child: Text('Particulars', style: _headerStyle),
                ),
                Expanded(flex: 2, child: Text('Chq. No.', style: _headerStyle)),
                Expanded(
                  flex: 2,
                  child: Text('Withdrawal (-)', style: _headerStyle),
                ),
                Expanded(
                  flex: 2,
                  child: Text('Deposit (+)', style: _headerStyle),
                ),
                Expanded(flex: 2, child: Text('Balance', style: _headerStyle)),
                Expanded(flex: 2, child: Text('Status', style: _headerStyle)),
                Expanded(flex: 1, child: Text('Action', style: _headerStyle)),
              ],
            ),
          ),

          // Table Body
          Expanded(
            child: transactions.isEmpty
                ? const Center(
                    child: Text(
                      'No transactions found.',
                      style: TextStyle(color: Color(0xFF64748B)),
                    ),
                  )
                : ListView.separated(
                    itemCount: transactions.length,
                    separatorBuilder: (context, index) =>
                        const Divider(height: 1, color: Color(0xFFE2E8F0)),
                    itemBuilder: (context, index) {
                      final tx = transactions[index];
                      final isWithdrawal = tx['withdrawal'] > 0;

                      return Container(
                        color: _selectedIndex == index
                            ? Colors.indigo.withOpacity(0.05)
                            : Colors.white,
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              _selectedIndex = index;
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 16,
                            ),
                            child: Row(
                              children: [
                                // Date
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    tx['date'],
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Color(0xFF0F172A),
                                    ),
                                  ),
                                ),

                                // Particulars
                                Expanded(
                                  flex: 4,
                                  child: _selectedIndex == index
                                      ? TextField(
                                          controller:
                                              TextEditingController(
                                                  text: tx['particulars'],
                                                )
                                                ..selection =
                                                    TextSelection.collapsed(
                                                      offset: tx['particulars']
                                                          .length,
                                                    ),
                                          style: const TextStyle(fontSize: 14),
                                          decoration: const InputDecoration(
                                            isDense: true,
                                            contentPadding: EdgeInsets.zero,
                                            border: InputBorder.none,
                                          ),
                                          onSubmitted: (value) {
                                            setState(() {
                                              tx['particulars'] = value;
                                              _selectedIndex =
                                                  null; // Deselect on save
                                            });
                                          },
                                        )
                                      : Text(
                                          tx['particulars'],
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            color: Color(0xFF0F172A),
                                          ),
                                        ),
                                ),

                                // Chq No
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    tx['chqNo'],
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Color(0xFF64748B),
                                    ),
                                  ),
                                ),

                                // Withdrawal
                                Expanded(
                                  flex: 2,
                                  child: _selectedIndex == index
                                      ? TextField(
                                          controller:
                                              TextEditingController(
                                                  text: tx['withdrawal']
                                                      .toString(),
                                                )
                                                ..selection =
                                                    TextSelection.collapsed(
                                                      offset: tx['withdrawal']
                                                          .toString()
                                                          .length,
                                                    ),
                                          style: const TextStyle(fontSize: 14),
                                          decoration: const InputDecoration(
                                            isDense: true,
                                            contentPadding: EdgeInsets.zero,
                                            border: InputBorder.none,
                                          ),
                                          keyboardType: TextInputType.number,
                                          onSubmitted: (value) {
                                            setState(() {
                                              tx['withdrawal'] =
                                                  double.tryParse(value) ?? 0.0;
                                              _selectedIndex = null;
                                            });
                                          },
                                        )
                                      : Text(
                                          tx['withdrawal'] > 0
                                              ? '₹${tx['withdrawal'].toStringAsFixed(2)}'
                                              : '-',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: isWithdrawal
                                                ? Colors.redAccent
                                                : const Color(0xFF64748B),
                                            fontWeight: isWithdrawal
                                                ? FontWeight.w600
                                                : FontWeight.normal,
                                          ),
                                        ),
                                ),

                                // Deposit
                                Expanded(
                                  flex: 2,
                                  child: _selectedIndex == index
                                      ? TextField(
                                          controller:
                                              TextEditingController(
                                                  text: tx['deposit']
                                                      .toString(),
                                                )
                                                ..selection =
                                                    TextSelection.collapsed(
                                                      offset: tx['deposit']
                                                          .toString()
                                                          .length,
                                                    ),
                                          style: const TextStyle(fontSize: 14),
                                          decoration: const InputDecoration(
                                            isDense: true,
                                            contentPadding: EdgeInsets.zero,
                                            border: InputBorder.none,
                                          ),
                                          keyboardType: TextInputType.number,
                                          onSubmitted: (value) {
                                            setState(() {
                                              tx['deposit'] =
                                                  double.tryParse(value) ?? 0.0;
                                              _selectedIndex = null;
                                            });
                                          },
                                        )
                                      : Text(
                                          tx['deposit'] > 0
                                              ? '₹${tx['deposit'].toStringAsFixed(2)}'
                                              : '-',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: !isWithdrawal
                                                ? const Color(0xFF10B981)
                                                : const Color(0xFF64748B),
                                            fontWeight: !isWithdrawal
                                                ? FontWeight.w600
                                                : FontWeight.normal,
                                          ),
                                        ),
                                ),

                                // Balance
                                Expanded(
                                  flex: 2,
                                  child: _selectedIndex == index
                                      ? TextField(
                                          controller:
                                              TextEditingController(
                                                  text: tx['balance']
                                                      .toString(),
                                                )
                                                ..selection =
                                                    TextSelection.collapsed(
                                                      offset: tx['balance']
                                                          .toString()
                                                          .length,
                                                    ),
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          decoration: const InputDecoration(
                                            isDense: true,
                                            contentPadding: EdgeInsets.zero,
                                            border: InputBorder.none,
                                          ),
                                          keyboardType: TextInputType.number,
                                          onSubmitted: (value) {
                                            setState(() {
                                              tx['balance'] =
                                                  double.tryParse(value) ?? 0.0;
                                              _selectedIndex = null;
                                            });
                                          },
                                        )
                                      : Text(
                                          '₹${tx['balance'].toStringAsFixed(2)}',
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF0F172A),
                                          ),
                                        ),
                                ),

                                // Status tag
                                Expanded(
                                  flex: 2,
                                  child: _buildStatusTag(tx['status']),
                                ),

                                // Action
                                Expanded(
                                  flex: 1,
                                  child: IconButton(
                                    icon: const Icon(
                                      Icons.more_vert,
                                      color: Color(0xFF64748B),
                                      size: 20,
                                    ),
                                    onPressed: () {},
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),

          // Pagination Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Text(
                  'Rows per page: 10',
                  style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                ),
                const SizedBox(width: 24),
                const Text(
                  '1-8 of 8',
                  style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                ),
                const SizedBox(width: 16),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.chevron_left, size: 20),
                  color: const Color(0xFF64748B),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.chevron_right, size: 20),
                  color: const Color(0xFF64748B),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusTag(String status) {
    Color bgColor;
    Color textColor;

    switch (status) {
      case 'Verified':
        bgColor = const Color(0xFFDCFCE7); // Green 100
        textColor = const Color(0xFF15803D); // Green 700
        break;
      case 'Flagged':
        bgColor = const Color(0xFFFEE2E2); // Red 100
        textColor = const Color(0xFFB91C1C); // Red 700
        break;
      case 'Unreconciled':
        bgColor = const Color(0xFFFEF08A); // Yellow 100
        textColor = const Color(0xFFA16207); // Yellow 700
        break;
      default:
        bgColor = const Color(0xFFE2E8F0);
        textColor = const Color(0xFF475569);
    }

    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          status,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: textColor,
          ),
        ),
      ),
    );
  }

  static const _headerStyle = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.bold,
    color: Color(0xFF64748B),
    letterSpacing: 0.5,
  );

  void _showAddTransactionDialog(BuildContext context) {
    final particularsController = TextEditingController();
    final amountController = TextEditingController();
    String type = 'credit';

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: const Text('Add Transaction'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: particularsController,
                    decoration: const InputDecoration(labelText: 'Particulars'),
                  ),
                  TextField(
                    controller: amountController,
                    decoration: const InputDecoration(labelText: 'Amount'),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Text('Type: '),
                      ChoiceChip(
                        label: const Text('Credit'),
                        selected: type == 'credit',
                        onSelected: (selected) {
                          if (selected) setStateDialog(() => type = 'credit');
                        },
                      ),
                      const SizedBox(width: 8),
                      ChoiceChip(
                        label: const Text('Debit'),
                        selected: type == 'debit',
                        onSelected: (selected) {
                          if (selected) setStateDialog(() => type = 'debit');
                        },
                      ),
                    ],
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    final amount =
                        double.tryParse(amountController.text) ?? 0.0;
                    final newTx = {
                      'date': DateTime.now().toString().split(' ')[0],
                      'particulars': particularsController.text,
                      'chqNo': '-',
                      'withdrawal': type == 'debit' ? amount : 0.0,
                      'deposit': type == 'credit' ? amount : 0.0,
                      'balance': _transactions.isEmpty
                          ? amount
                          : _transactions.last['balance'] +
                                (type == 'credit' ? amount : -amount),
                      'status': 'Unreconciled',
                    };
                    setState(() {
                      _transactions.add(newTx);
                    });
                    Navigator.pop(context);
                  },
                  child: const Text('Add'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showEditTransactionDialog(BuildContext context, int index) {
    final tx = _transactions[index];
    final particularsController = TextEditingController(
      text: tx['particulars'],
    );
    final amountController = TextEditingController(
      text: (tx['withdrawal'] > 0 ? tx['withdrawal'] : tx['deposit'])
          .toString(),
    );
    String type = tx['withdrawal'] > 0 ? 'debit' : 'credit';

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: const Text('Edit Transaction'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: particularsController,
                    decoration: const InputDecoration(labelText: 'Particulars'),
                  ),
                  TextField(
                    controller: amountController,
                    decoration: const InputDecoration(labelText: 'Amount'),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Text('Type: '),
                      ChoiceChip(
                        label: const Text('Credit'),
                        selected: type == 'credit',
                        onSelected: (selected) {
                          if (selected) setStateDialog(() => type = 'credit');
                        },
                      ),
                      const SizedBox(width: 8),
                      ChoiceChip(
                        label: const Text('Debit'),
                        selected: type == 'debit',
                        onSelected: (selected) {
                          if (selected) setStateDialog(() => type = 'debit');
                        },
                      ),
                    ],
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    final amount =
                        double.tryParse(amountController.text) ?? 0.0;
                    setState(() {
                      _transactions[index]['particulars'] =
                          particularsController.text;
                      if (type == 'debit') {
                        _transactions[index]['withdrawal'] = amount;
                        _transactions[index]['deposit'] = 0.0;
                      } else {
                        _transactions[index]['deposit'] = amount;
                        _transactions[index]['withdrawal'] = 0.0;
                      }
                    });
                    Navigator.pop(context);
                  },
                  child: const Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _removeSelectedTransaction() {
    if (_selectedIndex != null) {
      setState(() {
        _transactions.removeAt(_selectedIndex!);
        _selectedIndex = null;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please select a transaction to remove by clicking on it.',
          ),
        ),
      );
    }
  }
}
