// // Step 1: Create initial debt
// DebtModel debt = DebtModel(
//   id: 'debt_001',
//   transactionId: 'txn_001',
//   personName: 'John',
//   totalAmount: 100.0,
//   debtType: DebtType.borrowed,
//   expectedReturnDate: DateTime(2025, 03, 01),
//   paidAmount: 0.0,
//   paymentIds: [],
// );

// // Current Status: Owe $100, Paid $0, Remaining $100

// // Step 2: Pay back $50
// DebtPaymentModel payment1 = DebtPaymentModel(
//   id: 'payment_001',
//   debtId: 'debt_001',
//   amount: 50.0,
//   paymentDate: DateTime.now(),
//   note: 'First partial payment',
//   paymentMethod: PaymentMethod.cash,
// );

// // Update debt
// debt.paidAmount += 50.0; // 0 + 50 = 50
// debt.paymentIds.add('payment_001');
// debt.updatedAt = DateTime.now();

// // Current Status: Owe $100, Paid $50, Remaining $50

// // Step 3: Pay back $20
// DebtPaymentModel payment2 = DebtPaymentModel(
//   id: 'payment_002',
//   debtId: 'debt_001',
//   amount: 20.0,
//   paymentDate: DateTime.now(),
//   note: 'Second payment',
//   paymentMethod: PaymentMethod.bank,
// );

// debt.paidAmount += 20.0; // 50 + 20 = 70
// debt.paymentIds.add('payment_002');
// debt.updatedAt = DateTime.now();

// // Current Status: Owe $100, Paid $70, Remaining $30

// // Step 4: Final payment $30
// DebtPaymentModel payment3 = DebtPaymentModel(
//   id: 'payment_003',
//   debtId: 'debt_001',
//   amount: 30.0,
//   paymentDate: DateTime.now(),
//   note: 'Final payment - Debt settled',
//   paymentMethod: PaymentMethod.cash,
// );

// debt.paidAmount += 30.0; // 70 + 30 = 100
// debt.paymentIds.add('payment_003');
// debt.isReturned = true; // Mark as fully paid
// debt.updatedAt = DateTime.now();

// // Final Status: Owe $100, Paid $100, Remaining $0 ✅



// //// ui implementation 
// ///// Debt Detail Screen
// class DebtDetailScreen extends StatelessWidget {
//   final DebtModel debt;

//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text(debt.personName)),
//       body: Column(
//         children: [
//           // Debt Summary Card
//           Card(
//             child: Column(
//               children: [
//                 Text('Total: \$${debt.totalAmount}'),
//                 Text('Paid: \$${debt.paidAmount}'),
//                 Text('Remaining: \$${debt.remainingAmount}'),
//                 LinearProgressIndicator(
//                   value: debt.paymentPercentage / 100,
//                 ),
//               ],
//             ),
//           ),
          
//           // Payment History
//           Expanded(
//             child: FutureBuilder<List<DebtPaymentModel>>(
//               future: getPaymentsForDebt(debt.id),
//               builder: (context, snapshot) {
//                 if (!snapshot.hasData) return CircularProgressIndicator();
                
//                 final payments = snapshot.data!;
//                 return ListView.builder(
//                   itemCount: payments.length,
//                   itemBuilder: (context, index) {
//                     final payment = payments[index];
//                     return ListTile(
//                       leading: Icon(Icons.payment),
//                       title: Text('\$${payment.amount}'),
//                       subtitle: Text(payment.note ?? ''),
//                       trailing: Text(
//                         DateFormat('dd MMM').format(payment.paymentDate),
//                       ),
//                     );
//                   },
//                 );
//               },
//             ),
//           ),
          
//           // Add Payment Button
//           if (!debt.isReturned)
//             ElevatedButton(
//               onPressed: () => showAddPaymentDialog(context, debt),
//               child: Text('Add Payment'),
//             ),
//         ],
//       ),
//     );
//   }
// }

// // Add Payment Dialog
// void showAddPaymentDialog(BuildContext context, DebtModel debt) {
//   showDialog(
//     context: context,
//     builder: (context) => AlertDialog(
//       title: Text('Record Payment'),
//       content: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           TextField(
//             decoration: InputDecoration(
//               labelText: 'Amount',
//               hintText: 'Remaining: \$${debt.remainingAmount}',
//             ),
//             keyboardType: TextInputType.number,
//           ),
//           TextField(
//             decoration: InputDecoration(labelText: 'Note (optional)'),
//           ),
//         ],
//       ),
//       actions: [
//         TextButton(
//           onPressed: () => Navigator.pop(context),
//           child: Text('Cancel'),
//         ),
//         ElevatedButton(
//           onPressed: () {
//             // Save payment
//             // Update debt
//             Navigator.pop(context);
//           },
//           child: Text('Save'),
//         ),
//       ],
//     ),
//   );
// }