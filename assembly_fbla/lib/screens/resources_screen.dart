import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Resource {
  final String title;
  final String category;
  final Color categoryColor;
  final String size;
  final String downloads;
  final IconData icon;
  final Color iconColor;
  final Color iconBgColor;
  bool isFavorite;
  final String type;
  final String downloadUrl;

  Resource({
    required this.title,
    required this.category,
    required this.categoryColor,
    required this.size,
    required this.downloads,
    required this.icon,
    required this.iconColor,
    required this.iconBgColor,
    required this.isFavorite,
    required this.type,
    required this.downloadUrl,
  });
}

class ResourcesScreen extends StatefulWidget {
  const ResourcesScreen({super.key});

  @override
  State<ResourcesScreen> createState() => _ResourcesScreenState();
}

class _ResourcesScreenState extends State<ResourcesScreen> {
  String _selectedFilter = 'All';
  String _searchQuery = '';

  final List<Resource> _allResources = [
    Resource(
        title: 'FBLA Competition Guidelines 2026',
        category: 'Competition',
        categoryColor: const Color(0xFFEC4899),
        size: '2.4 MB',
        downloads: '156 downloads',
        icon: Icons.description,
        iconColor: const Color(0xFF2563EB),
        iconBgColor: const Color(0xFFDBEAFE),
        isFavorite: true,
        type: 'Documents',
        downloadUrl: 'https://www.fbla.org/media/2025/05/2025-26-High-School-CE-Changes.pdf'),
    Resource(
        title: 'Business Plan Template',
        category: 'Templates',
        categoryColor: const Color(0xFF8B5CF6),
        size: '1.8 MB',
        downloads: '243 downloads',
        icon: Icons.description,
        iconColor: const Color(0xFF2563EB),
        iconBgColor: const Color(0xFFDBEAFE),
        isFavorite: false,
        type: 'Documents',
        downloadUrl: 'https://www.fbla.org/high-school/competitive-events/'),
    Resource(
        title: 'Leadership Skills Training Video',
        category: 'Training',
        categoryColor: const Color(0xFFF59E0B),
        size: '45 min',
        downloads: '892 views',
        icon: Icons.play_circle_outline,
        iconColor: const Color(0xFFF59E0B),
        iconBgColor: const Color(0xFFFEF3C7),
        isFavorite: true,
        type: 'Videos',
        downloadUrl: 'https://www.fbla.org/high-school/competitive-events/'),
    Resource(
        title: 'Effective Communication Techniques',
        category: 'Skills',
        categoryColor: const Color(0xFF10B981),
        size: '32 min',
        downloads: '654 views',
        icon: Icons.play_circle_outline,
        iconColor: const Color(0xFF10B981),
        iconBgColor: const Color(0xFFD1FAE5),
        isFavorite: false,
        type: 'Videos',
        downloadUrl: 'https://www.fbla.org/high-school/competitive-events/'),
    Resource(
        title: 'FBLA Official Website',
        category: 'Official',
        categoryColor: const Color(0xFF3B82F6),
        size: 'Link',
        downloads: '1.2k clicks',
        icon: Icons.link,
        iconColor: const Color(0xFF3B82F6),
        iconBgColor: const Color(0xFFDBEAFE),
        isFavorite: true,
        type: 'Links',
        downloadUrl: 'https://www.fbla-pbl.org/'),
  ];

  void _toggleFavorite(Resource resource) {
    setState(() {
      resource.isFavorite = !resource.isFavorite;
    });
  }

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri)) {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredResources = _allResources.where((resource) {
      final query = _searchQuery.toLowerCase();
      final titleMatch = resource.title.toLowerCase().contains(query);
      if (_selectedFilter == 'Saved') {
        return titleMatch && resource.isFavorite;
      }
      final typeMatch = _selectedFilter == 'All' || resource.type == _selectedFilter;
      return titleMatch && typeMatch;
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        title: const Text(
          'Resources',
          style: TextStyle(
            color: Color(0xFF111827),
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'Search resources...',
                prefixIcon: const Icon(Icons.search, color: Color(0xFF9CA3AF)),
                filled: true,
                fillColor: const Color(0xFFF3F4F6),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildFilterChip('All'),
                  const SizedBox(width: 8),
                  _buildFilterChip('Documents'),
                  const SizedBox(width: 8),
                  _buildFilterChip('Videos'),
                  const SizedBox(width: 8),
                  _buildFilterChip('Links'),
                  const SizedBox(width: 8),
                  _buildFilterChip('Saved'),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: filteredResources.length,
              separatorBuilder: (context, index) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final resource = filteredResources[index];
                return _ResourceCard(
                  resource: resource,
                  onFavoritePressed: () => _toggleFavorite(resource),
                  onDownloadPressed: () => _launchURL(resource.downloadUrl),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label) {
    final isSelected = _selectedFilter == label;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedFilter = label;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFE0E7FF) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? const Color(0xFF4F46E5) : const Color(0xFFE5E7EB),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: isSelected ? const Color(0xFF4F46E5) : const Color(0xFF374151),
          ),
        ),
      ),
    );
  }
}

class _ResourceCard extends StatelessWidget {
  final Resource resource;
  final VoidCallback onFavoritePressed;
  final VoidCallback onDownloadPressed;

  const _ResourceCard({
    required this.resource,
    required this.onFavoritePressed,
    required this.onDownloadPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: resource.iconBgColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(resource.icon, color: resource.iconColor, size: 24),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              resource.title,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF111827),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: onFavoritePressed,
                            child: Icon(
                              resource.isFavorite ? Icons.bookmark : Icons.bookmark_border,
                              color: resource.isFavorite ? const Color(0xFFF59E0B) : const Color(0xFF9CA3AF),
                              size: 24,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: resource.categoryColor.withAlpha(25),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          resource.category,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: resource.categoryColor,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Text(
                            resource.size,
                            style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
                          ),
                          const SizedBox(width: 4),
                          const Text(
                            '•',
                            style: TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            resource.downloads,
                            style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: Color(0xFFE5E7EB))),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: onDownloadPressed,
                  icon: const Icon(Icons.download, size: 20),
                  label: const Text('Download'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFDBEAFE),
                    foregroundColor: const Color(0xFF2563EB),
                    elevation: 0,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
