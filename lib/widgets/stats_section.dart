import 'package:flutter/material.dart';
import '../models/checkin_model.dart';

class StatsSection extends StatelessWidget {
  final CheckinManager checkinManager;

  const StatsSection({
    super.key,
    required this.checkinManager,
  });

  @override
  Widget build(BuildContext context) {
    final stats = checkinManager.getStats();
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildStatItem('进度', '${stats['completed']}/${stats['total']}'),
        _buildStatItem('累计积分', '${stats['points']}'),
        _buildStatItem('累计现金', '${stats['cash']}'),
        _buildStatItem('累计会员', '${stats['memberDays']}天'),
      ],
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Expanded(
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
        ],
      ),
    );
  }
}
