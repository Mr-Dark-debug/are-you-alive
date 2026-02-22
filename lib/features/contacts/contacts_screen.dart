import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme.dart';
import '../../core/widgets/widgets.dart';
import '../../core/utils/snackbar_helper.dart';
import '../../models/models.dart';

/// Contacts Screen - Manage emergency contacts
class ContactsScreen extends ConsumerStatefulWidget {
  const ContactsScreen({super.key});

  @override
  ConsumerState<ContactsScreen> createState() => _ContactsScreenState();
}

class _ContactsScreenState extends ConsumerState<ContactsScreen> {
  final List<EmergencyContact> _contacts = [
    EmergencyContact(
      id: '1',
      userId: 'user1',
      name: 'Mom',
      phone: '+1234567890',
      email: 'mom@example.com',
      relationship: 'Mother',
      isVerified: true,
      priority: 1,
      createdAt: DateTime.now(),
    ),
  ];

  void _addContact() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppDesignTokens.radius24),
        ),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(ctx).viewInsets.bottom,
          left: AppDesignTokens.spacing24,
          right: AppDesignTokens.spacing24,
          top: AppDesignTokens.spacing24,
        ),
        child: _AddContactForm(
          onAdd: (contact) {
            setState(() {
              _contacts.add(contact);
            });
            Navigator.pop(ctx);
            SnackBarHelper.showSuccess(
              context,
              'Verification email sent to ${contact.email ?? contact.phone}',
            );
          },
        ),
      ),
    );
  }

  void _deleteContact(int index) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Remove Contact'),
        content: Text(
          'Are you sure you want to remove ${_contacts[index].name} from your emergency contacts?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.criticalColor,
            ),
            onPressed: () {
              Navigator.pop(ctx);
              setState(() {
                _contacts.removeAt(index);
              });
              SnackBarHelper.showInfo(context, 'Contact removed');
            },
            child: const Text('Remove'),
          ),
        ],
      ),
    );
  }

  void _resendVerification(EmergencyContact contact) {
    SnackBarHelper.showInfo(
      context,
      'Verification email resent to ${contact.email ?? contact.phone}',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Emergency Contacts'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _addContact,
            tooltip: 'Add Contact',
          ),
        ],
      ),
      body: _contacts.isEmpty ? _buildEmptyState() : _buildContactsList(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addContact,
        icon: const Icon(Icons.add),
        label: const Text('Add Contact'),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppDesignTokens.spacing32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: AppColors.grey100,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.contacts_outlined,
                size: 60,
                color: AppColors.grey400,
              ),
            ),
            const SizedBox(height: AppDesignTokens.spacing24),
            Text(
              'No Emergency Contacts',
              style: AppTextStyles.headlineSmall(),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppDesignTokens.spacing12),
            Text(
              'Add trusted contacts who will be notified in case of an emergency.',
              style: AppTextStyles.bodyLarge(color: AppColors.grey500),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppDesignTokens.spacing32),
            PrimaryButton(
              text: 'Add Your First Contact',
              icon: Icons.add,
              onPressed: _addContact,
              width: 280,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactsList() {
    return ListView.builder(
      padding: const EdgeInsets.all(AppDesignTokens.spacing16),
      itemCount: _contacts.length,
      itemBuilder: (context, index) {
        final contact = _contacts[index];
        return _ContactCard(
          contact: contact,
          onDelete: () => _deleteContact(index),
          onResendVerification: () => _resendVerification(contact),
        );
      },
    );
  }
}

class _ContactCard extends StatelessWidget {
  const _ContactCard({
    required this.contact,
    required this.onDelete,
    required this.onResendVerification,
  });

  final EmergencyContact contact;
  final VoidCallback onDelete;
  final VoidCallback onResendVerification;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppDesignTokens.spacing12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDesignTokens.radius16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppDesignTokens.spacing16),
        child: Row(
          children: [
            // Avatar
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                child: Text(
                  contact.initials,
                  style: AppTextStyles.headlineSmall(
                    color: AppColors.primary,
                    weight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(width: AppDesignTokens.spacing16),

            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        contact.name,
                        style: AppTextStyles.titleSmall(),
                      ),
                      if (!contact.isVerified) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.warningBackground,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            'Pending',
                            style: AppTextStyles.labelSmall(
                              color: AppColors.warningDark,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    contact.relationship,
                    style: AppTextStyles.bodySmall(color: AppColors.grey500),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    contact.email ?? contact.phone,
                    style: AppTextStyles.bodySmall(color: AppColors.grey400),
                  ),
                ],
              ),
            ),

            // Actions
            Column(
              children: [
                if (!contact.isVerified)
                  TextButton(
                    onPressed: onResendVerification,
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      minimumSize: const Size(0, 32),
                    ),
                    child: const Text('Resend'),
                  ),
                IconButton(
                  icon: const Icon(
                    Icons.delete_outline,
                    color: AppColors.criticalColor,
                  ),
                  onPressed: onDelete,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _AddContactForm extends StatefulWidget {
  const _AddContactForm({required this.onAdd});

  final Function(EmergencyContact) onAdd;

  @override
  State<_AddContactForm> createState() => _AddContactFormState();
}

class _AddContactFormState extends State<_AddContactForm> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  String _selectedRelationship = 'Friend';
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final contact = EmergencyContact(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        userId: 'user1',
        name: _nameController.text,
        phone: _phoneController.text,
        email: _emailController.text.isNotEmpty ? _emailController.text : null,
        relationship: _selectedRelationship,
        isVerified: false,
        priority: 1,
        createdAt: DateTime.now(),
      );
      widget.onAdd(contact);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.grey300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: AppDesignTokens.spacing24),

          Text(
            'Add Emergency Contact',
            style: AppTextStyles.headlineSmall(),
          ),
          const SizedBox(height: AppDesignTokens.spacing24),

          TextFormField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'Name',
              prefixIcon: Icon(Icons.person_outline),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a name';
              }
              return null;
            },
          ),

          const SizedBox(height: AppDesignTokens.spacing16),

          TextFormField(
            controller: _phoneController,
            keyboardType: TextInputType.phone,
            decoration: const InputDecoration(
              labelText: 'Phone Number',
              prefixIcon: Icon(Icons.phone_outlined),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a phone number';
              }
              return null;
            },
          ),

          const SizedBox(height: AppDesignTokens.spacing16),

          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              labelText: 'Email (optional)',
              prefixIcon: Icon(Icons.email_outlined),
            ),
          ),

          const SizedBox(height: AppDesignTokens.spacing16),

          DropdownButtonFormField<String>(
            initialValue: _selectedRelationship,
            decoration: const InputDecoration(
              labelText: 'Relationship',
              prefixIcon: Icon(Icons.people_outline),
            ),
            items: [
              'Mother',
              'Father',
              'Sister',
              'Brother',
              'Spouse',
              'Partner',
              'Friend',
              'Colleague',
              'Other',
            ].map((r) => DropdownMenuItem(value: r, child: Text(r))).toList(),
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  _selectedRelationship = value;
                });
              }
            },
          ),

          const SizedBox(height: AppDesignTokens.spacing24),

          PrimaryButton(
            text: 'Add & Send Verification',
            onPressed: _submit,
          ),

          const SizedBox(height: AppDesignTokens.spacing24),
        ],
      ),
    );
  }
}
