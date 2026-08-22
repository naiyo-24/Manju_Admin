import 'package:flutter_test/flutter_test.dart';
import 'package:manju_admin/main.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  testWidgets('App initialization test', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: ManjuAdminApp()));
    expect(find.text('Manju Medical Admin'), findsNothing);
  });
}
