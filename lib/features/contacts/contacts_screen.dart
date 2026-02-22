import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme.dart';

/// Local contacts provider for testing
final _contactsProvider = StateProvider<List<_ContactItem>>((ref) => [
  _ContactItem(name: 'Mom', phone: '+1 234 567 8900', relationship: 'Mother', isVerified: true),
  _ContactItem(name: 'Dad', phone: '+1 234 567 8901', relationship: 'Father', isVerified: false),
]);

class _ContactItem {
  final String name, phone, relationship;
  final bool isVerified;
  _ContactItem({required this.name, required this.phone, required this.relationship, this.isVerified = false});
}

class ContactsScreen extends ConsumerStatefulWidget {
  const ContactsScreen({super.key});
  @override
  ConsumerState<ContactsScreen> createState() => _ContactsScreenState();
}

class _ContactsScreenState extends ConsumerState<ContactsScreen> {
  void _showAddContact() {
    final nameCtrl = TextEditingController();
    final phoneCtrl = TextEditingController();
    String selectedRelation = 'Friend';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) {
        final isDark = Theme.of(ctx).brightness == Brightness.dark;
        return StatefulBuilder(builder: (ctx, setSheetState) {
          return Padding(
            padding: EdgeInsets.fromLTRB(24, 24, 24, MediaQuery.of(ctx).viewInsets.bottom + 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(child: Container(width: 40, height: 4,
                    decoration: BoxDecoration(color: AppColors.grey300,
                        borderRadius: BorderRadius.circular(2)))),
                const SizedBox(height: 20),
                Text('Add Contact', style: AppTextStyles.titleLarge(
                    color: isDark ? AppColors.white : AppColors.grey900)),
                const SizedBox(height: 20),
                TextFormField(controller: nameCtrl,
                    decoration: const InputDecoration(
                        labelText: 'Full Name', prefixIcon: Icon(Icons.person_outline, size: 20))),
                const SizedBox(height: 14),
                TextFormField(controller: phoneCtrl,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                        labelText: 'Phone', prefixIcon: Icon(Icons.phone_outlined, size: 20))),
                const SizedBox(height: 14),
                Text('RELATIONSHIP', style: AppTextStyles.overline(color: AppColors.grey400)),
                const SizedBox(height: 8),
                Wrap(spacing: 8, runSpacing: 8,
                    children: ['Mother', 'Father', 'Sibling', 'Partner', 'Friend', 'Other'].map((r) {
                      return GestureDetector(
                        onTap: () => setSheetState(() => selectedRelation = r),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          decoration: BoxDecoration(
                            color: selectedRelation == r ? AppColors.primary : Colors.transparent,
                            borderRadius: BorderRadius.circular(AppDesignTokens.radiusFull),
                            border: Border.all(
                                color: selectedRelation == r ? AppColors.primary :
                                    (isDark ? AppColors.grey700 : AppColors.grey200)),
                          ),
                          child: Text(r, style: AppTextStyles.labelMedium(
                              color: selectedRelation == r ? AppColors.white :
                                  (isDark ? AppColors.grey300 : AppColors.grey600))),
                        ),
                      );
                    }).toList()),
                const SizedBox(height: 24),
                SizedBox(height: 54, child: ElevatedButton(
                  onPressed: () {
                    if (nameCtrl.text.isNotEmpty && phoneCtrl.text.isNotEmpty) {
                      final list = List<_ContactItem>.from(ref.read(_contactsProvider));
                      list.add(_ContactItem(
                          name: nameCtrl.text, phone: phoneCtrl.text,
                          relationship: selectedRelation));
                      ref.read(_contactsProvider.notifier).state = list;
                      Navigator.pop(ctx);
                    }
                  },
                  child: const Text('Add Contact'),
                )),
              ],
            ),
          );
        });
      },
    );
  }

  void _deleteContact(int index) {
    final list = List<_ContactItem>.from(ref.read(_contactsProvider));
    list.removeAt(index);
    ref.read(_contactsProvider.notifier).state = list;
  }

  @override
  Widget build(BuildContext context) {
    final contacts = ref.watch(_contactsProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      appBar: AppBar(
        title: const Text('Emergency Contacts'),
        actions: [
          IconButton(icon: const Icon(Icons.person_add_rounded),
              onPressed: _showAddContact),
        ],
      ),
      body: contacts.isEmpty
          ? Center(child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.people_outline_rounded, size: 64, color: AppColors.grey300),
                const SizedBox(height: 16),
                Text('No contacts yet', style: AppTextStyles.titleMedium(color: AppColors.grey400)),
                const SizedBox(height: 8),
                Text('Add people to alert in emergencies.',
                    style: AppTextStyles.bodySmall(color: AppColors.grey400)),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                    onPressed: _showAddContact,
                    icon: const Icon(Icons.add, size: 20),
                    label: const Text('Add Contact')),
              ],
            ))
          : ListView.builder(
              padding: const EdgeInsets.all(24),
              itemCount: contacts.length,
              itemBuilder: (ctx, i) {
                final c = contacts[i];
                return _ContactCard(
                  contact: c,
                  isDark: isDark,
                  onDelete: () => _deleteContact(i),
                  onVerify: () {
                    final list = List<_ContactItem>.from(ref.read(_contactsProvider));
                    list[i] = _ContactItem(name: c.name, phone: c.phone,
                        relationship: c.relationship, isVerified: true);
                    ref.read(_contactsProvider.notifier).state = list;
                  },
                ).animate().fadeIn(delay: Duration(milliseconds: 100 * i), duration: 400.ms)
                    .slideX(begin: 0.1);
              },
            ),
      floatingActionButton: contacts.isNotEmpty ? FloatingActionButton(
        onPressed: _showAddContact,
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add_rounded, color: AppColors.white),
      ) : null,
    );
  }
}

class _ContactCard extends StatelessWidget {
  final _ContactItem contact;
  final bool isDark;
  final VoidCallback onDelete;
  final VoidCallback onVerify;
  const _ContactCard({required this.contact, required this.isDark,
      required this.onDelete, required this.onVerify});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(18),
      decoration: GlassmorphismDecoration.safeCard(context),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 48, height: 48,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: contact.isVerified
                      ? [AppColors.calmColor, AppColors.calmDark]
                      : [AppColors.grey300, AppColors.grey400]),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Center(child: Text(
                contact.name.isNotEmpty ? contact.name[0].toUpperCase() : '?',
                style: AppTextStyles.titleMedium(
                    color: AppColors.white, weight: FontWeight.w700))),
          ),
          const SizedBox(width: 14),
          // Info
          Expanded(child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                Text(contact.name, style: AppTextStyles.titleSmall(
                    color: isDark ? AppColors.white : AppColors.grey900)),
                const SizedBox(width: 6),
                if (contact.isVerified)
                  const Icon(Icons.verified_rounded, size: 16, color: AppColors.calmColor),
              ]),
              const SizedBox(height: 2),
              Text('${contact.relationship} • ${contact.phone}',
                  style: AppTextStyles.bodySmall(color: AppColors.grey400)),
            ],
          )),
          // Actions
          if (!contact.isVerified)
            TextButton(onPressed: onVerify,
                child: Text('Verify', style: AppTextStyles.labelSmall(color: AppColors.primary))),
          IconButton(
            icon: Icon(Icons.delete_outline, size: 20, color: AppColors.grey400),
            onPressed: () {
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text('Delete Contact?'),
                  content: Text('Remove ${contact.name} from your emergency contacts?'),
                  actions: [
                    TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
                    TextButton(onPressed: () { Navigator.pop(ctx); onDelete(); },
                        child: const Text('Delete', style: TextStyle(color: AppColors.criticalColor))),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
