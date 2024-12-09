import 'package:flutter/material.dart';
import 'package:jelajah_rasa_mobile/add_dish/models/newdish_entry.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:jelajah_rasa_mobile/add_dish/screens/menu.dart';

import 'package:flutter/material.dart';
import 'package:jelajah_rasa_mobile/add_dish/models/newdish_entry.dart';

class EditDish extends StatefulWidget {
  final NewDishEntry dish;

  const EditDish({super.key, required this.dish});

  @override
  State<EditDish> createState() => _EditDishState();
}

class _EditDishState extends State<EditDish> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController dishNameController;
  late TextEditingController vendorNameController;
  late TextEditingController priceController;
  late TextEditingController mapLinkController;
  late TextEditingController addressController;
  late TextEditingController imageUrlController;

  late String flavor;
  late String category;

  final List<String> flavors = ['Salty', 'Sweet'];
  final List<String> categories = ['Food', 'Beverage'];

  @override
  void initState() {
    super.initState();

    dishNameController = TextEditingController(text: widget.dish.name);
    vendorNameController = TextEditingController(text: widget.dish.vendorName);
    priceController = TextEditingController(text: widget.dish.price.toString());
    mapLinkController = TextEditingController(text: widget.dish.mapLink);
    addressController = TextEditingController(text: widget.dish.address);
    imageUrlController = TextEditingController(text: widget.dish.image);

    flavor = widget.dish.flavor;
    category = widget.dish.category;
  }

  @override
  void dispose() {
    dishNameController.dispose();
    vendorNameController.dispose();
    priceController.dispose();
    mapLinkController.dispose();
    addressController.dispose();
    imageUrlController.dispose();
    super.dispose();
  }

  void _saveDish() {
    if (_formKey.currentState?.validate() ?? false) {
      // Update dish data
      NewDishEntry updatedDish = NewDishEntry(
        uuid: widget.dish.uuid,
        name: dishNameController.text,
        flavor: flavor,
        category: category,
        vendorName: vendorNameController.text,
        price: int.tryParse(priceController.text) ?? widget.dish.price,
        mapLink: mapLinkController.text,
        address: addressController.text,
        image: imageUrlController.text,
        isApproved: false,
        isRejected: false,
        status: 'Pending',
        userUsername: widget.dish.userUsername,
      );

      // Return updated dish to the previous screen
      Navigator.pop(context, updatedDish);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(FontAwesomeIcons.chevronLeft),
          onPressed: () {
            Navigator.pop(context); // Navigate back to the previous screen
          },
        ),
        title: const Text(
          'Edit Dish',
          style: TextStyle(
            color: Color(0xFFF4B5A4),
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white70,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildTextField("Dish Name", dishNameController),
              const SizedBox(height: 16),

              _buildDropdown("Flavor", flavor, flavors, (value) {
                setState(() {
                  flavor = value!;
                });
              }),
              const SizedBox(height: 16),

              _buildDropdown("Category", category, categories, (value) {
                setState(() {
                  category = value!;
                });
              }),
              const SizedBox(height: 16),

              _buildTextField("Vendor's Name", vendorNameController),
              const SizedBox(height: 16),

              _buildTextField("Price", priceController, isNumber: true),
              const SizedBox(height: 16),

              _buildTextField("Map Link", mapLinkController),
              const SizedBox(height: 16),

              _buildTextField("Address", addressController),
              const SizedBox(height: 16),

              _buildTextField("Image URL", imageUrlController),
              const SizedBox(height: 16),

              ElevatedButton(
                onPressed: _saveDish,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: const Color(0xFFF18F73),
                ),
                child: const Text('Save', style: TextStyle(color: Colors.white, fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, {bool isNumber = false}) {
    return TextFormField(
      controller: controller,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(labelText: label),
    );
  }

  Widget _buildDropdown(String label, String value, List<String> options, void Function(String?) onChanged) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(labelText: label),
      items: options.map((option) => DropdownMenuItem(value: option, child: Text(option))).toList(),
      onChanged: onChanged,
    );
  }
}
