import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:brainace_pro/app_bar.dart';

class TermsOfService extends StatefulWidget {
  const TermsOfService({super.key});

  @override
  State<TermsOfService> createState() => _TermsOfService();
}

class _TermsOfService extends State<TermsOfService> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: appBar(context, ''),
      body: Container(
        margin: EdgeInsets.only(
          left: size.width / 15,
          right: size.width / 15,
        ),
        child: const Markdown(
          data: '''
# Terms of Use for BrainAce.pro app

&nbsp;

## Introduction

Welcome to BrainAce.pro, a brain improvement app designed to help users enhance their cognitive abilities through various brain training exercises. By using our app, you agree to the following terms and conditions. Please read them carefully.

&nbsp;

## General Terms

1. **Acceptance of Terms**
    
    By accessing and using the BrainAce.pro app, you agree to be bound by these Terms of Use, all applicable laws, and regulations. If you do not agree with any part of these terms, you must not use our app.
    
2. **Eligibility**
    
    You must be at least 18 years old to use the BrainAce.pro app. If you are under 18, you may only use the app with the involvement of a parent or guardian.
    
&nbsp;

## Disclaimers

1. **No Guaranteed Improvement**
    
    The brain training plan provided by the BrainAce.pro app is not guaranteed to improve your brain function. Results may vary from user to user.
    
2. **Health and Safety**
    
    If you have any health concerns or experience any issues while using the BrainAce.pro app, you should contact your healthcare professional immediately. The BrainAce.pro team is not responsible for any injuries or problems that may arise from using the app.
    
&nbsp;

## Neurological Basis

1. **Training Concept**
The BrainAce.pro app is based on the neurological concept that says, "What fires together, wires together." This means that the more you practice a certain activity, the better you get at it. The exercises in our app are designed to reinforce neural pathways through repeated practice.

&nbsp;

## User Responsibility

1. **Use at Your Own Risk**
You are using the BrainAce.pro app at your own risk. We do not warrant that the app will meet your specific requirements or that it will be free from errors or interruptions.

&nbsp;

## Contact Information

1. **Contact Details**
If you have any questions or need support, you can contact us at:
    - Email: [appbraintrain@gmail.com](mailto:appbraintrain@gmail.com)
    - Phone: +48 577 568 833

&nbsp;

## Amendments

1. **Changes to Terms**
We reserve the right to modify these Terms of Use at any time. Any changes will be effective immediately upon posting the revised terms within the app. Your continued use of the app after any changes are posted constitutes your acceptance of the new terms.

&nbsp;

## Termination

1. **Termination of Use**
We reserve the right to terminate or suspend your access to the BrainAce.pro app at our sole discretion, without prior notice, for conduct that we believe violates these Terms of Use or is harmful to other users of the app, us, or third parties, or for any other reason.

&nbsp;

## Governing Law

1. **Jurisdiction**
These terms and conditions are governed by and construed in accordance with the laws of the European Union, and you irrevocably submit to the exclusive jurisdiction of the courts in that region.

&nbsp;

By using the BrainAce.pro app, you acknowledge that you have read, understood, and agree to be bound by these Terms of Use.
        ''',
        ),
      ),
    );
  }
}
