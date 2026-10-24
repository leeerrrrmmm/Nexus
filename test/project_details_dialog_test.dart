import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:portfolio/presentation/widgets/project_details_dialog.dart';

void main() {
  testWidgets('project details show role, stack and project highlight', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(780, 1688);
    tester.view.devicePixelRatio = 2;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(412, 917),
        builder: (_, _) => MaterialApp(
          home: Builder(
            builder: (context) => Scaffold(
              body: Center(
                child: TextButton(
                  onPressed: () => showProjectDetailsDialog(
                    context: context,
                    title: 'E-CHAT',
                    subtitle: 'Communication app',
                    description: 'An e-commerce messenger.',
                    imagePath: 'assets/images/echat.png',
                    colors: const [Colors.white, Color(0xFF8095C3)],
                    onOpenProject: () {},
                  ),
                  child: const Text('Open'),
                ),
              ),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();

    expect(find.text('Flutter Developer'), findsOneWidget);
    expect(find.text('Flutter · Dart · Firebase'), findsOneWidget);
    expect(
      find.text(
        'Shopping stays in the conversation: browse product cards, use promo codes, and complete an order without leaving the chat.',
      ),
      findsOneWidget,
    );
    expect(find.text('About the project'), findsOneWidget);
    expect(find.text('Project highlight'), findsOneWidget);

    await tester.ensureVisible(find.text('Open project'));
    await tester.tap(find.text('Open project'));
    await tester.pumpAndSettle();

    expect(find.text('PROJECT CASE'), findsNothing);
  });
}
