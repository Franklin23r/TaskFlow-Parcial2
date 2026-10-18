import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:taskflow/main.dart';

void main() {
  testWidgets('TaskFlow inicia correctamente', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: TaskFlowApp(),
      ),
    );

    await tester.pump();

    expect(find.byType(TaskFlowApp), findsOneWidget);
  });
}
