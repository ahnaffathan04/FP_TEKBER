import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TambahTiketScreen extends StatefulWidget {
  final int concertId;

  const TambahTiketScreen({Key? key, required this.concertId})
      : super(key: key);

  @override
  State<TambahTiketScreen> createState() => _TambahTiketScreenState();
}

class _TambahTiketScreenState extends State<TambahTiketScreen> {
  final _formKey = GlobalKey<FormState>();
  final _hargaController = TextEditingController();
  final _jumlahController = TextEditingController();

  bool isLoading = false;
  String? _existingTicketId;

  final List<String> _kategoriList = [
    'Regular Early',
    'VIP Early',
    'Regular',
    'VIP',
  ];
  String? _selectedKategori;

  @override
  void dispose() {
    _hargaController.dispose();
    _jumlahController.dispose();
    super.dispose();
  }

  Future<void> _loadTicketData(String category) async {
    setState(() {
      isLoading = true;
      _hargaController.clear();
      _jumlahController.clear();
      _existingTicketId = null;
    });

    try {
      final response = await Supabase.instance.client
          .from('concert_ticket')
          .select('concert_ticket_id, price, availability')
          .eq('concert_id', widget.concertId)
          .eq('category', category)
          .single();

      _existingTicketId = response['concert_ticket_id'] as String?;
      _hargaController.text = (response['price'] as int).toString();
      _jumlahController.text = (response['availability'] as int).toString();
    } on PostgrestException catch (e) {
      if (e.code == 'PGRST116') {
        _hargaController.clear();
        _jumlahController.clear();
        _existingTicketId = null;
      } else {
        debugPrint('Error loading ticket data: $e');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to load ticket data: ${e.message}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      debugPrint('An unexpected error occurred: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('An unexpected error occurred: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _simpanTiket() async {
    if (_formKey.currentState!.validate()) {
      setState(() => isLoading = true);
      try {
        final ticketData = {
          'category': _selectedKategori,
          'price': int.parse(_hargaController.text),
          'availability': int.parse(_jumlahController.text),
          'concert_id': widget.concertId,
          'filled': 0,
          'max_purchase': 10,
        };

        if (_existingTicketId != null) {
          await Supabase.instance.client
              .from('concert_ticket')
              .update(ticketData)
              .eq('concert_ticket_id', _existingTicketId!);

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Tiket berhasil diupdate!',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                ),
              ),
              backgroundColor: Color(0xFF10C7EF),
              duration: Duration(seconds: 2),
            ),
          );
        } else {
          await Supabase.instance.client
              .from('concert_ticket')
              .insert(ticketData);

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Tiket berhasil disimpan!',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                ),
              ),
              backgroundColor: Color(0xFF10C7EF),
              duration: Duration(seconds: 2),
            ),
          );
        }
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal menyimpan tiket: $e'),
            backgroundColor: Colors.red,
          ),
        );
      } finally {
        setState(() => isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0E0F1A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0E0F1A),
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Color(0xFF2EE6FF),
            size: 24,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Tambah Tiket',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Color(0xFFC8EFF8),
          ),
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Dropdown Nama Kategori
              const Text(
                'Nama Kategori',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFFC8EFF8),
                ),
              ),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1B2E),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.1),
                    width: 1,
                  ),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: DropdownButtonFormField<String>(
                  value: _selectedKategori,
                  icon: const Icon(Icons.keyboard_arrow_down,
                      color: Color(0xFF8F9BB3)),
                  dropdownColor: const Color(0xFF1A1B2E),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                  ),
                  style: const TextStyle(
                    color: Colors.white,
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                  items: _kategoriList
                      .map((kategori) => DropdownMenuItem(
                            value: kategori,
                            child: Text(kategori),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedKategori = value;
                    });
                    if (value != null) {
                      _loadTicketData(value);
                    }
                  },
                  validator: (value) =>
                      value == null ? 'Pilih kategori tiket' : null,
                ),
              ),
              const SizedBox(height: 16),

              // Harga
              _buildTextField(
                label: 'Harga (Dalam Rp.)',
                controller: _hargaController,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),

              // Jumlah Tersedia
              _buildTextField(
                label: 'Jumlah Tersedia',
                controller: _jumlahController,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 32),

              // Tombol Aksi
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Batal
                  Container(
                    width: 120,
                    height: 50,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF2D55),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFFF2D55).withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        context.pop();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Batal',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF04181D),
                        ),
                      ),
                    ),
                  ),
                  // Simpan
                  Container(
                    width: 120,
                    height: 50,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFF10C7EF),
                          Color(0xFF44E3EF),
                        ],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF10C7EF).withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      onPressed: isLoading
                          ? null
                          : _simpanTiket, // Call _simpanTiket on press
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: isLoading
                          ? const CircularProgressIndicator(
                              color: Color(0xFF04181D))
                          : const Text(
                              'Simpan',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF04181D),
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFFC8EFF8),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFF1A1B2E),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.white.withOpacity(0.1),
              width: 1,
            ),
          ),
          child: TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.white,
              height: 1.4,
            ),
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.all(16),
              border: InputBorder.none,
            ),
            validator: (value) =>
                value == null || value.isEmpty ? 'Wajib diisi' : null,
          ),
        ),
      ],
    );
  }
}
