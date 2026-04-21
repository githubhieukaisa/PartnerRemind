import 'package:flutter/material.dart';
import '../widgets/timer_display.dart';
import '../widgets/break_bank_display.dart';

/// Home screen integrating timer and break bank
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PartnerRemind - Phase 1'),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          spacing: 32,
          children: [
            // Timer section
            const Card(
              elevation: 4,
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Column(
                  spacing: 24,
                  children: [
                    Text(
                      'Precision Timer',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple,
                      ),
                    ),
                    TimerDisplay(),
                    TimerControls(),
                  ],
                ),
              ),
            ),

            // Break Bank section
            const Card(
              elevation: 4,
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Column(
                  spacing: 16,
                  children: [
                    Text(
                      'Break Time Management',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.amber,
                      ),
                    ),
                    BreakBankDisplay(),
                    SizedBox(height: 8),
                    BreakBankControls(),
                  ],
                ),
              ),
            ),

            // Info section
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.blue.withValues(alpha: 0.1),
              ),
              child: const Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'How it works:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '1. Start the timer - it uses precise DateTime calculations\n'
                    '2. The timer continues accurately even if your system sleeps\n'
                    '3. Break time accumulates in the bank as you work\n'
                    '4. Use quick-add buttons or reset your break bank anytime',
                    style: TextStyle(fontSize: 13),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
