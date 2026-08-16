import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:inventory_management/core/errors/app_exception.dart';
import 'package:inventory_management/features/auth/presentation/widgets/auth_text_field.dart';
import 'package:inventory_management/features/items/presentation/providers/add_item_controller.dart';
import '../widgets/category_dropdown.dart';
import '../widgets/date_picker_field.dart';
import '../widgets/warranty_toggle.dart';
import '../widgets/photo_picker_field.dart';
import '../widgets/document_picker_field.dart';

class AddItemScreen extends ConsumerStatefulWidget {
  const AddItemScreen({super.key});

  @override
  ConsumerState<AddItemScreen> createState() => _AddItemScreenState();
}

class _AddItemScreenState extends ConsumerState<AddItemScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _locationController = TextEditingController();

  int? _categoryId;
  DateTime? _purchaseDate;
  bool _hasExpiry = false;
  DateTime? _expiryDate;
  List<File> _photos = [];
  File? _document;

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  void _onSavePressed() {
    if (!_formKey.currentState!.validate()) return;

    if (_purchaseDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select a purchase date.")),
      );
      return;
    }

    if (_hasExpiry && _expiryDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select a warranty end date.")),
      );
      return;
    }

    ref.read(addItemControllerProvider.notifier).saveItem(
          name: _nameController.text.trim(),
          categoryId: _categoryId!,
          purchaseDate: DateFormat('yyyy-MM-dd').format(_purchaseDate!),
          hasExpiry: _hasExpiry,
          expiryDate: _hasExpiry ? DateFormat('yyyy-MM-dd').format(_expiryDate!) : null,
          pricePaid: double.parse(_priceController.text.trim()),
          location: _locationController.text.trim(),
          photos: _photos,
          document: _document,
        );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(addItemControllerProvider);

    ref.listen(addItemControllerProvider, (previous, next) {
      next.whenOrNull(
        data: (result) {
          if (result != null) {
            if (result.warning != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(result.warning!)),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Item saved successfully!")),
              );
            }
          
          }
        },
        error: (err, stack) {
          final message = err is AppException ? err.message : "Something went wrong";
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
        },
      );
    });

    final isLoading = state.isLoading;

    return Scaffold(
      appBar: AppBar(title: const Text("Add New Item")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              AuthTextField(
                label: "Item Name",
                hintText: "e.g. Dell Inspiron 15",
                controller: _nameController,
                validator: (value) => value == null || value.isEmpty ? "Item name is required" : null,
                onChanged: (value) {},
              ),
              const SizedBox(height: 16),

              CategoryDropdown(
                selectedCategoryId: _categoryId,
                onChanged: (value) => setState(() => _categoryId = value),
              ),
              const SizedBox(height: 16),

              DatePickerField(
                label: "Purchase Date",
                selectedDate: _purchaseDate,
                lastDate: DateTime.now(),
                onDateSelected: (date) => setState(() => _purchaseDate = date),
              ),
              const SizedBox(height: 16),

              WarrantyToggle(
                hasExpiry: _hasExpiry,
                onToggleChanged: (value) => setState(() {
                  _hasExpiry = value;
                  if (!value) _expiryDate = null; // No select karne pe purani date clear
                }),
                expiryDate: _expiryDate,
                onExpiryDateSelected: (date) => setState(() => _expiryDate = date),
              ),
              const SizedBox(height: 16),

              AuthTextField(
                label: "Price Paid",
                hintText: "e.g. 52000",
                controller: _priceController,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) return "Price is required";
                  if (double.tryParse(value) == null) return "Enter a valid number";
                  return null;
                },
                onChanged: (value) {},
              ),
              const SizedBox(height: 16),

              AuthTextField(
                label: "Location",
                hintText: "e.g. Bedroom cupboard",
                controller: _locationController,
                validator: (value) => value == null || value.isEmpty ? "Location is required" : null,
                onChanged: (value) {},
              ),
              const SizedBox(height: 16),

              PhotoPickerField(
                photos: _photos,
                onPhotosChanged: (photos) => setState(() => _photos = photos),
              ),
              const SizedBox(height: 16),

              DocumentPickerField(
                document: _document,
                onDocumentChanged: (doc) => setState(() => _document = doc),
              ),
              const SizedBox(height: 30),

              ElevatedButton(
                onPressed: isLoading ? null : _onSavePressed,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                      )
                    : const Text("Save Item"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}