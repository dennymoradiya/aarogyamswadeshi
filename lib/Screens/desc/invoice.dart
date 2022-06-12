class Invoice {
  final InvoiceInfo info;
  final Supplier supplier;
  final List<InvoiceItem> items;

  const Invoice({
     this.info,
     this.supplier,
     this.items,
  });
}

class InvoiceInfo {
  // final String name;
  final String number;
  final String date;
  // final DateTime dueDate;

  const InvoiceInfo({
    // required this.name,
     this.number,
     this.date,
    // required this.dueDate,
  });
}

class InvoiceItem {
  final String name;
  final String date;
  final int quantity;
  // final double vat;
  final double unitPrice;

  const InvoiceItem({
     this.name,
     this.date,
     this.quantity,
     this.unitPrice,
  });
}

 

class Supplier {
  final String name;
  // final String address;
  final String paymentInfo;

  const Supplier({
     this.name,
    //  this.address,
     this.paymentInfo,
  });
}
