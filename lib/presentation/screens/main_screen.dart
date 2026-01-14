import 'package:flutter/material.dart';

/// Main content screen
/// This is displayed after successful purchase
/// It shows the actual premium content
class MainScreen extends StatelessWidget {
  final VoidCallback onLogout;

  const MainScreen({
    Key? key,
    required this.onLogout,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Premium Content'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: onLogout,
            tooltip: 'Reset app',
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(isMobile ? 16 : 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Welcome banner with gradient
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(isMobile ? 16 : 24),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.blue.shade600,
                          Colors.blue.shade400,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.celebration,
                          color: Colors.white,
                          size: isMobile ? 32 : 40,
                        ),
                        SizedBox(height: isMobile ? 8 : 12),
                        Text(
                          'Welcome to Premium!',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: isMobile ? 20 : 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: isMobile ? 4 : 8),
                        Text(
                          'You now have access to all premium features',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: isMobile ? 12 : 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: isMobile ? 20 : 32),
                  
                  // Features section
                  Text(
                    'Your Unlocked Features',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontSize: isMobile ? 16 : null,
                    ),
                  ),
                  SizedBox(height: isMobile ? 12 : 16),
                  
                  _FeatureCard(
                    icon: Icons.video_library,
                    title: 'HD Video Streaming',
                    description: 'Stream all content in beautiful HD quality',
                    isMobile: isMobile,
                  ),
                  SizedBox(height: isMobile ? 8 : 12),
                  
                  _FeatureCard(
                    icon: Icons.remove_circle,
                    title: 'Ad-Free Experience',
                    description: 'Enjoy uninterrupted content viewing',
                    isMobile: isMobile,
                  ),
                  SizedBox(height: isMobile ? 8 : 12),
                  
                  _FeatureCard(
                    icon: Icons.download,
                    title: 'Downloads',
                    description: 'Download content to watch offline',
                    isMobile: isMobile,
                  ),
                  SizedBox(height: isMobile ? 8 : 12),
                  
                  _FeatureCard(
                    icon: Icons.people,
                    title: 'Family Sharing',
                    description: 'Share with up to 4 family members',
                    isMobile: isMobile,
                  ),
                  SizedBox(height: isMobile ? 16 : 32),
                  
                  // Featured content
                  Text(
                    'Featured Content',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontSize: isMobile ? 16 : null,
                    ),
                  ),
                  SizedBox(height: isMobile ? 12 : 16),
                ],
              ),
            ),
          ),
          
          // Content grid
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: isMobile ? 16 : 24),
            sliver: SliverGrid(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: isMobile ? 2 : 4,
                crossAxisSpacing: isMobile ? 8 : 12,
                mainAxisSpacing: isMobile ? 8 : 12,
                childAspectRatio: 0.75,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) => _ContentCard(
                  title: 'Content ${index + 1}',
                  color: _getColorForIndex(index),
                ),
                childCount: isMobile ? 6 : 8,
              ),
            ),
          ),
          
          // Bottom padding
          SliverToBoxAdapter(
            child: SizedBox(height: isMobile ? 16 : 32),
          ),
        ],
      ),
    );
  }

  Color _getColorForIndex(int index) {
    final colors = [
      Colors.blue.shade400,
      Colors.purple.shade400,
      Colors.pink.shade400,
      Colors.green.shade400,
      Colors.orange.shade400,
      Colors.red.shade400,
      Colors.cyan.shade400,
      Colors.indigo.shade400,
    ];
    return colors[index % colors.length];
  }
}

/// Widget for displaying a feature card
class _FeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final bool isMobile;

  const _FeatureCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.isMobile,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(isMobile ? 12 : 16),
        child: Row(
          children: [
            Icon(
              icon,
              size: isMobile ? 28 : 32,
              color: Theme.of(context).primaryColor,
            ),
            SizedBox(width: isMobile ? 12 : 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontSize: isMobile ? 14 : null,
                    ),
                  ),
                  SizedBox(height: isMobile ? 2 : 4),
                  Text(
                    description,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontSize: isMobile ? 11 : null,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
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

/// Widget for displaying content cards in grid
class _ContentCard extends StatelessWidget {
  final String title;
  final Color color;

  const _ContentCard({
    required this.title,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
