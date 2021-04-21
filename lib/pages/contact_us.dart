import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:gpmkc_mobile_app/utils.dart';
import 'package:package_info/package_info.dart';

import '../constants.dart';

class PageContactUs extends StatelessWidget {
  const PageContactUs({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var contextTheme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        margin: EdgeInsets.all(24.0),
        alignment: Alignment.center,
        child: ListView(
          shrinkWrap: true,
          children: [
            Text(
              kLabelContactUs,
              textAlign: TextAlign.center,
              style: contextTheme.textTheme.headline5
                  .copyWith(color: contextTheme.accentColor),
            ),
            ContactUsForm(),
            ContactTile(
              launchUrl: kGoogleMapsLink,
              assetPathIcon: kAssetPathIconLocation,
              titleText: kTextLocation,
            ),
            ContactTile(
              launchUrl: kWhatsappLink,
              assetPathIcon: kAssetPathIconWhatsapp,
              titleText: kTextWhatsappNumber,
            )
          ],
        ),
      ),
    );
  }
}

// Create a Form widget.
class ContactUsForm extends StatefulWidget {
  @override
  ContactUsFormState createState() {
    return ContactUsFormState();
  }
}

// Create a corresponding State class.
// This class holds data related to the form.
class ContactUsFormState extends State<ContactUsForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a GlobalKey<FormState>,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();

  final emailTextEditingController = TextEditingController();
  final subjectTextEditingController = TextEditingController();
  final messageTextEditingController = TextEditingController();

  @override
  void dispose() {
    emailTextEditingController.dispose();
    subjectTextEditingController.dispose();
    messageTextEditingController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.

    return Container(
      margin: EdgeInsets.symmetric(vertical: 16.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // ContactUsFormField(
            //   validator: (value) {
            //     if (EmailValidator.validate(value)) {
            //       return null;
            //     } else {
            //       return kErrorTextEmail;
            //     }
            //   },
            //   hintText: kHintTextEmail,
            //   textEditingController: emailTextEditingController,
            //   textInputAction: TextInputAction.next,
            // ),
            ContactUsFormField(
              validator: (value) {
                if (value.isEmpty) {
                  return kErrorTextSubject;
                }
                return null;
              },
              hintText: kHintTextSubject,
              textEditingController: subjectTextEditingController,
              textInputAction: TextInputAction.next,
            ),
            ContactUsFormField(
              validator: (value) {
                if (value.isEmpty) {
                  return kErrorTextMessage;
                }
                return null;
              },
              hintText: kHintTextMessage,
              maxLines: 3,
              textEditingController: messageTextEditingController,
            ),
            Container(
              alignment: Alignment.center,
              child: ElevatedButton(
                onPressed: () {
                  // Validate returns true if the form is valid, or false
                  // otherwise.
                  if (_formKey.currentState.validate()) {
                    // If the form is valid, send email.
                    sendEmail(
                        context,
                        messageTextEditingController.text,
                        subjectTextEditingController.text,
                        emailTextEditingController.text);
                  }
                },
                child: Text(kLabelSubmitMessage),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> sendEmail(
      BuildContext context, String body, subject, senderEmail) async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(kTextOpeningMessageApp),
        duration: Duration(seconds: 2),
      ),
    );

    // var emailParameters = {
    //   'subject': subject,
    //   'body':
    //       '$body\n${Utils.getMailTextFooter(appVersion: packageInfo.version)}',
    // };

    // final Uri emailUri = Uri(
    //   scheme: "mailto",
    //   path: kMailAddressGPMKC,
    //   queryParameters: emailParameters,
    // );

    // Utils.launchUniversalLinkIos(emailUri.toString());

    final Email email = Email(
      body:
          '$body\n${Utils.getMailTextFooter(appVersion: packageInfo.version)}',
      subject: subject,
      recipients: [kMailAddressGPMKC],
    );

    String platformResponse, uiResponseText;

    try {
      await FlutterEmailSender.send(email);
      platformResponse = 'email send success';
      uiResponseText = null;
    } catch (error) {
      platformResponse = 'email send error:\n${error.toString()}';
      uiResponseText = kTextMessageSendError;
    }
    print(platformResponse);
    if (uiResponseText != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(uiResponseText),
        ),
      );
    }
  }
}

class ContactUsFormField extends StatelessWidget {
  const ContactUsFormField({
    Key key,
    @required this.validator,
    @required this.hintText,
    @required this.textEditingController,
    this.maxLines = 1,
    this.textInputAction = TextInputAction.unspecified,
  }) : super(key: key);

  final FormFieldValidator<String> validator;
  final String hintText;
  final int maxLines;
  final TextEditingController textEditingController;
  final TextInputAction textInputAction;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 8.0),
      child: TextFormField(
        controller: textEditingController,
        decoration: InputDecoration(
          hintText: hintText,
        ),
        validator: validator,
        maxLines: maxLines,
        textInputAction: textInputAction,
      ),
    );
  }
}

class ContactTile extends StatelessWidget {
  const ContactTile({
    Key key,
    @required this.launchUrl,
    @required this.assetPathIcon,
    @required this.titleText,
  }) : super(key: key);

  final String launchUrl, assetPathIcon, titleText;

  @override
  Widget build(BuildContext context) {
    var textThemeContext = Theme.of(context).textTheme;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.0),
      child: ListTile(
        onTap: () {
          Utils.launchUniversalLinkIos(launchUrl);
        },
        leading: FractionallySizedBox(
          widthFactor: 0.075,
          child: Image.asset(
            assetPathIcon,
            fit: BoxFit.contain,
          ),
        ),
        title: Text(
          titleText,
          style: textThemeContext.headline6.copyWith(
              fontWeight: FontWeight.w400,
              height: 1.05,
              color: textThemeContext.headline6.color.withOpacity(0.47)),
        ),
      ),
    );
  }
}
