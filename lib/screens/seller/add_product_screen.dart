// ===================== lib/screens/seller/add_product_screen.dart =====================
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../models/product.dart';
import '../../providers/product_provider.dart';

class AddProductScreen extends StatefulWidget {
  final Product? existingProduct;

  AddProductScreen({this.existingProduct});

  @override
  _AddProductScreenState createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();

  // Controller for Dynamic Features
  final TextEditingController _featureController = TextEditingController();

  // Form Data
  late String id;
  String name = '';
  double price = 0.0;
  String category = 'General';
  String description = '';
  String brand = '';
  String model = '';
  String unit = 'piece';
  String warranty = '';
  String deliveryEstimate = '2-3 Days';
  double deliveryFee = 0.0;
  bool inStock = true;
  List<String> features = [];
  List<File> selectedImages = [];
  List<String> existingImageUrls = [];

  @override
  void initState() {
    super.initState();
    if (widget.existingProduct != null) {
      final p = widget.existingProduct!;
      id = p.id;
      name = p.name;
      price = p.price;
      category = p.category;
      description = p.description;
      brand = p.brand;
      model = p.model;
      unit = p.unit;
      warranty = p.warranty;
      deliveryEstimate = p.deliveryEstimate;
      deliveryFee = p.deliveryFee;
      inStock = p.inStock;
      features = List.from(p.features);
      existingImageUrls = List.from(p.images);
    } else {
      id = DateTime.now().millisecondsSinceEpoch.toString();
    }
  }

  Future<void> _pickImages() async {
    final List<XFile> images = await _picker.pickMultiImage();
    if (images.isNotEmpty) {
      setState(() {
        selectedImages.addAll(images.map((image) => File(image.path)).toList());
      });
    }
  }

  void _addFeature() {
    if (_featureController.text.isNotEmpty) {
      setState(() {
        features.add(_featureController.text.trim());
        _featureController.clear();
      });
    }
  }

  void saveProduct() {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    // In a real app, you would upload selectedImages to Firebase/S3
    // and get URLs back. For now, we mix existing URLs with local paths.
    List<String> allImages = [...existingImageUrls, ...selectedImages.map((f) => f.path)];

    final newProduct = Product(
      id: id,
      name: name,
      price: price,
      storeId: 'Owner Store', // Usually from AuthProvider
      imageUrl: allImages.isNotEmpty ? allImages[0] : '',
      description: description,
      category: category,
      brand: brand,
      model: model,
      unit: unit,
      warranty: warranty,
      inStock: inStock,
      features: features,
      images: allImages,
      deliveryEstimate: deliveryEstimate,
      deliveryFee: deliveryFee,
      sellerName: 'Premium Merchant',
      sellerRating: 5.0,
    );

    final provider = Provider.of<ProductProvider>(context, listen: false);
    if (widget.existingProduct == null) {
      provider.addProduct(newProduct);
    } else {
      provider.updateProduct(widget.existingProduct!.id, newProduct);
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(widget.existingProduct != null ? 'Edit Product' : 'New Product'),
        actions: [IconButton(icon: Icon(Icons.check), onPressed: saveProduct)],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(16),
          children: [
            _buildImageSection(),
            SizedBox(height: 16),
            _buildSectionCard("Basic Information", [
              _buildTextField("Product Name", (v) => name = v!, initialValue: name),
              Row(
                children: [
                  Expanded(child: _buildTextField("Price", (v) => price = double.parse(v!), isNumber: true, initialValue: price.toString())),
                  SizedBox(width: 10),
                  Expanded(child: _buildTextField("Unit (e.g. kg, pcs)", (v) => unit = v!, initialValue: unit)),
                ],
              ),
              _buildTextField("Category", (v) => category = v!, initialValue: category),
            ]),
            _buildSectionCard("Inventory & Logistics", [
              Row(
                children: [
                  Expanded(child: _buildTextField("Brand", (v) => brand = v!, initialValue: brand)),
                  SizedBox(width: 10),
                  Expanded(child: _buildTextField("Model", (v) => model = v!, initialValue: model)),
                ],
              ),
              _buildTextField("Delivery Estimate", (v) => deliveryEstimate = v!, initialValue: deliveryEstimate),
              _buildTextField("Delivery Fee", (v) => deliveryFee = double.parse(v!), isNumber: true, initialValue: deliveryFee.toString()),
              SwitchListTile(
                title: Text("In Stock"),
                value: inStock,
                onChanged: (v) => setState(() => inStock = v),
              )
            ]),
            _buildSectionCard("Description & Features", [
              _buildTextField("Full Description", (v) => description = v!, maxLines: 4, initialValue: description),
              SizedBox(height: 10),
              Text("Key Features", style: TextStyle(fontWeight: FontWeight.bold)),
              Row(
                children: [
                  Expanded(child: TextField(controller: _featureController, decoration: InputDecoration(hintText: "Add feature..."))),
                  IconButton(icon: Icon(Icons.add_circle, color: Colors.orange), onPressed: _addFeature),
                ],
              ),
              Wrap(
                spacing: 8,
                children: features.map((f) => Chip(
                  label: Text(f),
                  onDeleted: () => setState(() => features.remove(f)),
                )).toList(),
              )
            ]),
            SizedBox(height: 32),
            ElevatedButton(
              onPressed: saveProduct,
              style: ElevatedButton.styleFrom(padding: EdgeInsets.symmetric(vertical: 15), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
              child: Text("SAVE PRODUCT", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionCard(String title, List<Widget> children) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.orange[800])),
            Divider(),
            ...children
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, Function(String?) onSaved, {bool isNumber = false, int maxLines = 1, String? initialValue}) {
    return TextFormField(
      initialValue: initialValue,
      decoration: InputDecoration(labelText: label),
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      maxLines: maxLines,
      onSaved: onSaved,
      validator: (v) => v!.isEmpty ? "Required" : null,
    );
  }

  Widget _buildImageSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Product Images", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        SizedBox(height: 10),
        SizedBox(
          height: 120,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              GestureDetector(
                onTap: _pickImages,
                child: Container(
                  width: 120,
                  decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(12)),
                  child: Icon(Icons.add_a_photo, size: 40, color: Colors.grey[600]),
                ),
              ),
              ...selectedImages.map((file) => _buildImagePreview(FileImage(file), true, file)),
              ...existingImageUrls.map((url) => _buildImagePreview(NetworkImage(url), false, url)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildImagePreview(ImageProvider image, bool isLocal, dynamic key) {
    return Stack(
      children: [
        Container(
          width: 120,
          margin: EdgeInsets.only(left: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            image: DecorationImage(image: image, fit: BoxFit.cover),
          ),
        ),
        Positioned(
          right: 0,
          child: GestureDetector(
            onTap: () => setState(() {
              isLocal ? selectedImages.remove(key) : existingImageUrls.remove(key);
            }),
            child: CircleAvatar(radius: 12, backgroundColor: Colors.red, child: Icon(Icons.close, size: 16, color: Colors.white)),
          ),
        ),
      ],
    );
  }
}