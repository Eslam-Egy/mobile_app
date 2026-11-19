import 'package:material_ui/material_ui.dart';
import '../../domain/entities/test_sim_entity.dart';

class AddSimDialogWidget extends StatefulWidget {
  final Function(TestSimEntity) onSave;

  const AddSimDialogWidget({super.key, required this.onSave});

  @override
  State<AddSimDialogWidget> createState() => _AddSimDialogWidgetState();
}

class _AddSimDialogWidgetState extends State<AddSimDialogWidget> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _imsiController;
  late final TextEditingController _extController;
  late final TextEditingController _notesController;
  String _cardType = 'Programmable USIM';

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _imsiController = TextEditingController(text: '00101000000000');
    _extController = TextEditingController(text: '100');
    _notesController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _imsiController.dispose();
    _extController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Row(
        children: [
          Icon(Icons.sim_card, color: Colors.teal),
          SizedBox(width: 8),
          Text('Register Test SIM Card'),
        ],
      ),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.red.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red.withValues(alpha: 0.3)),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.security, color: Colors.red, size: 18),
                    SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        'Non-sensitive metadata only. Never enter Ki or OPc secret keys.',
                        style: TextStyle(fontSize: 11, color: Colors.red, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Card Label / Phone Name',
                  hintText: 'e.g. Lab Phone C (Pixel 6a)',
                  border: OutlineInputBorder(),
                ),
                validator: (val) => val == null || val.trim().isEmpty ? 'Enter card name' : null,
              ),
              const SizedBox(height: 12),

              TextFormField(
                controller: _imsiController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'IMSI (15 digits)',
                  hintText: '001010000000003',
                  border: OutlineInputBorder(),
                  helperText: 'For PLMN 001/01: starts with 00101...',
                ),
                validator: (val) => (val == null || val.trim().length < 5) ? 'Invalid IMSI' : null,
              ),
              const SizedBox(height: 12),

              TextFormField(
                controller: _extController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Assigned PBX Extension',
                  hintText: '1003',
                  border: OutlineInputBorder(),
                ),
                validator: (val) => val == null || val.trim().isEmpty ? 'Enter extension' : null,
              ),
              const SizedBox(height: 12),

              DropdownButtonFormField<String>(
                initialValue: _cardType,
                decoration: const InputDecoration(
                  labelText: 'Card Type',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: 'Programmable USIM', child: Text('Programmable USIM (Sysmocom)')),
                  DropdownMenuItem(value: 'Commercial Test SIM', child: Text('Commercial Test SIM')),
                  DropdownMenuItem(value: 'Virtual/Emulated SIM', child: Text('Virtual / Emulated SIM')),
                ],
                onChanged: (val) {
                  if (val != null) setState(() => _cardType = val);
                },
              ),
              const SizedBox(height: 12),

              TextFormField(
                controller: _notesController,
                maxLines: 2,
                decoration: const InputDecoration(
                  labelText: 'Notes / Programming Tool',
                  hintText: 'e.g. Programmed with pySim-shell for WCDMA CS testing',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              final newSim = TestSimEntity(
                id: DateTime.now().millisecondsSinceEpoch.toString(),
                cardName: _nameController.text.trim(),
                imsi: _imsiController.text.trim(),
                extension: _extController.text.trim(),
                cardType: _cardType,
                notes: _notesController.text.trim(),
                createdAt: DateTime.now(),
              );
              widget.onSave(newSim);
              Navigator.of(context).pop();
            }
          },
          child: const Text('Save Card'),
        ),
      ],
    );
  }
}
