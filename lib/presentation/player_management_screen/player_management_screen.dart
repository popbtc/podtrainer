import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_icon_widget.dart';
import './widgets/player_card_widget.dart';
import './widgets/player_search_bar_widget.dart';
import './widgets/players_empty_state_widget.dart';

class PlayerManagementScreen extends StatefulWidget {
  const PlayerManagementScreen({super.key});

  @override
  State<PlayerManagementScreen> createState() => _PlayerManagementScreenState();
}

class _PlayerManagementScreenState extends State<PlayerManagementScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  bool _isLoading = false;
  List<Map<String, dynamic>> _filteredPlayers = [];

  // Mock players data
  final List<Map<String, dynamic>> _allPlayers = [
    {
      "id": "1",
      "name": "Emma Johnson",
      "age": 16,
      "sport": "Soccer",
      "avatar":
          "https://images.unsplash.com/photo-1663229047996-8f858d3335cd",
      "semanticLabel":
          "Young teenage girl with brown hair in soccer uniform smiling at camera",
      "lastTraining": "2024-10-23",
      "isActive": true,
      "podAssigned": "Pod A",
      "trainingCount": 24,
    },
    {
      "id": "2",
      "name": "Marcus Rodriguez",
      "age": 17,
      "sport": "Basketball",
      "avatar":
          "https://images.unsplash.com/photo-1649030703034-3b51d940fde2",
      "semanticLabel":
          "Hispanic teenage boy with short black hair in basketball jersey holding a ball",
      "lastTraining": "2024-10-22",
      "isActive": true,
      "podAssigned": null,
      "trainingCount": 18,
    },
    {
      "id": "3",
      "name": "Sarah Chen",
      "age": 15,
      "sport": "Tennis",
      "avatar": "https://images.unsplash.com/photo-1616531013323-b54b4a9cc555",
      "semanticLabel":
          "Asian teenage girl with long black hair in white tennis outfit with racket",
      "lastTraining": "2024-10-20",
      "isActive": false,
      "podAssigned": "Pod B",
      "trainingCount": 31,
    },
    {
      "id": "4",
      "name": "Alex Thompson",
      "age": 16,
      "sport": "Running",
      "avatar":
          "https://images.unsplash.com/photo-1582062041660-a37770a99e83",
      "semanticLabel":
          "Young boy with blonde hair in red running gear stretching outdoors",
      "lastTraining": "2024-10-24",
      "isActive": true,
      "podAssigned": "Pod C",
      "trainingCount": 12,
    },
  ];

  @override
  void initState() {
    super.initState();
    _filteredPlayers = List.from(_allPlayers);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _handleSearch(String query) {
    setState(() {
      _searchQuery = query;
      if (query.isEmpty) {
        _filteredPlayers = List.from(_allPlayers);
      } else {
        _filteredPlayers = _allPlayers.where((player) {
          final name = player['name'].toString().toLowerCase();
          final sport = player['sport'].toString().toLowerCase();
          final searchLower = query.toLowerCase();
          return name.contains(searchLower) || sport.contains(searchLower);
        }).toList();
      }
    });
  }

  void _clearSearch() {
    setState(() {
      _searchQuery = '';
      _searchController.clear();
      _filteredPlayers = List.from(_allPlayers);
    });
  }

  Future<void> _handleRefresh() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate network call
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _isLoading = false;
    });

    HapticFeedback.lightImpact();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Player data refreshed'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void _handlePlayerEdit(Map<String, dynamic> player) {
    Navigator.pushNamed(
      context,
      '/add-player-screen',
      arguments: player,
    ).then((result) {
      if (result == true) {
        _handleRefresh();
      }
    });
  }

  void _handlePlayerDelete(Map<String, dynamic> player) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Player'),
          content: Text(
              'Are you sure you want to delete ${player['name']}? This action cannot be undone.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _confirmDeletePlayer(player);
              },
              style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.error,
              ),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  void _confirmDeletePlayer(Map<String, dynamic> player) {
    setState(() {
      _allPlayers.removeWhere((p) => p['id'] == player['id']);
      _filteredPlayers.removeWhere((p) => p['id'] == player['id']);
    });

    HapticFeedback.lightImpact();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${player['name']} has been removed'),
        duration: const Duration(seconds: 3),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            setState(() {
              _allPlayers.add(player);
              _handleSearch(_searchQuery);
            });
          },
        ),
      ),
    );
  }

  void _handleAddPlayer() {
    Navigator.pushNamed(context, '/add-player-screen').then((result) {
      if (result == true) {
        _handleRefresh();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: CustomAppBar(
        variant: CustomAppBarVariant.withBackButton,
        title: 'Manage Players',
        showBackButton: true,
        actions: [
          IconButton(
            onPressed: _handleAddPlayer,
            icon: CustomIconWidget(
              iconName: 'person_add',
              color: theme.colorScheme.primary,
              size: 24,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: EdgeInsets.all(4.w),
            child: PlayerSearchBarWidget(
              controller: _searchController,
              onChanged: _handleSearch,
              onClear: _clearSearch,
            ),
          ),

          // Players List
          Expanded(
            child: _filteredPlayers.isEmpty
                ? _searchQuery.isNotEmpty
                    ? _buildNoResultsState()
                    : const PlayersEmptyStateWidget()
                : RefreshIndicator(
                    onRefresh: _handleRefresh,
                    child: ListView.separated(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding:
                          EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                      itemCount: _filteredPlayers.length,
                      separatorBuilder: (context, index) =>
                          SizedBox(height: 1.h),
                      itemBuilder: (context, index) {
                        final player = _filteredPlayers[index];
                        return PlayerCardWidget(
                          player: player,
                          onEdit: () => _handlePlayerEdit(player),
                          onDelete: () => _handlePlayerDelete(player),
                        );
                      },
                    ),
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _handleAddPlayer,
        backgroundColor: theme.colorScheme.primary,
        child: CustomIconWidget(
          iconName: 'add',
          color: theme.colorScheme.onPrimary,
          size: 24,
        ),
      ),
    );
  }

  Widget _buildNoResultsState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(8.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: 'search_off',
              size: 64,
              color: Theme.of(context).colorScheme.outline,
            ),
            SizedBox(height: 2.h),
            Text(
              'No players found',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            SizedBox(height: 1.h),
            Text(
              'Try adjusting your search terms or add a new player.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}