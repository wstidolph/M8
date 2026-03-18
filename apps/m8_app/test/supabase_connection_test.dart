import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() {
  const url = 'https://wmryrzbkcjqwmhbqaeus.supabase.co';
  const anonKey = 'sb_publishable_ba6YYsXyaBfpP4QTz-5GDw_kwZQ2TLP';

  test('Ping Supabase and check dynamic_answers table', () async {
    // 1. Direct Postgrest Client (bypasses auth/storage overhead for verification)
    final client = PostgrestClient(
      '$url/rest/v1',
      headers: {
        'apikey': anonKey,
        'Authorization': 'Bearer $anonKey',
      },
    );

    try {
      final response = await client.from('dynamic_answers').select();
      
      print('--- SUPABASE PING RESULTS ---');
      print('Status: SUCCESS');
      print('Items found in dynamic_answers: ${response.length}');
      
      if (response.isNotEmpty) {
        for (var item in response) {
          print('- [${item['category']}] ${item['text']}');
        }
      } else {
        print('Warning: Table is empty. Please run the SQL migration script.');
      }
    } catch (e) {
      print('--- SUPABASE PING FAILED ---');
      print('Error: $e');
      fail('Supabase interaction failed. Ensure the URL/Key are correct and the migration was run.');
    }
  });
}
