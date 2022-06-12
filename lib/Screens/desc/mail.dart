import 'dart:io';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';

Future<String> sentMail(Map data) async {
  String username = 'hddeveloper123@gmail.com';
  String password = "\$denisharsh7096";

  final smtpServer = gmail(username, password);
  final message = Message()
    ..from = Address(username, 'Hello ${data["customername"]}')
    ..recipients.add(data["customermail"])
    ..subject = 'Order Invoice From aarogyamswadeshi'
    ..text = 'This is the plain text.\nThis is line 2 of the text part.'
    ..html = "<h1>aarogyamswadeshi</h1>\n<p>Hey! Here's Your Order Bill</p>"
    ..attachments = [
      FileAttachment(File(data["filepath"]))
        ..location = Location.inline
        ..cid = '<myimg@3.141>'
    ];

  // final equivalentMessage = Message()
  //   ..from = Address(username, 'Your name 😀')
  //   ..recipients.add(Address('destination@example.com'))
  //   ..ccRecipients
  //       .addAll([Address('destCc1@example.com'), 'destCc2@example.com'])
  //   ..bccRecipients.add('bccAddress@example.com')
  //   ..subject = 'Test Dart Mailer library :: 😀 :: ${DateTime.now()}'
  //   ..text = 'This is the plain text.\nThis is line 2 of the text part.'
  //   ..html =
  //       '<h1>Test</h1>\n<p>Hey! Here is some HTML content</p><img src="cid:myimg@3.141"/>'
  //   ..attachments = [
  //     FileAttachment(File('exploits_of_a_mom.png'))
  //       ..location = Location.inline
  //       ..cid = '<myimg@3.141>'
  //   ];
  // final sendReport2 = await send(equivalentMessage, smtpServer);
  // var connection = PersistentConnection(smtpServer);
  // await connection.send(message);
  // await connection.send(equivalentMessage);
  // await connection.close();
  try {
    final sendReport = await send(message, smtpServer);
    print('Message sent: ' + sendReport.toString());
    
    return "Invoice Sent To Your Mail";
  } on MailerException catch (e) {
    print(e);
    return "There Is Some problem To Sent You Invoice In Mail";

    
  }

}
