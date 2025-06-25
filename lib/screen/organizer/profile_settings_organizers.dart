import 'package:flutter/material.dart';

// Import halaman lain jika sudah ada (misal: profile_page.dart, change_password_page.dart)
// import 'package:your_app_name/screens/profile_page.dart';
// import 'package:your_app_name/screens/change_password_page.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Background gelap sesuai gambar
      appBar: AppBar(
        title: const Text(
          'Pengaturan',
          style: TextStyle(color: Colors.white), // Teks putih untuk judul AppBar
        ),
        backgroundColor: Colors.black, // AppBar background gelap
        elevation: 0, // Menghilangkan shadow di bawah AppBar
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white), // Tombol kembali putih
          onPressed: () {
            Navigator.of(context).pop(); // Kembali ke halaman sebelumnya
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Container untuk opsi profil, kata sandi, dan bahasa
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFF1C1C1E), // Warna latar belakang card
                borderRadius: BorderRadius.circular(10), // Sudut membulat
              ),
              child: Column(
                children: [
                  _buildSettingsTile(
                    context,
                    title: 'Profil',
                    onTap: () {
                      // TODO: Navigasi ke halaman Profil
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Navigasi ke Profil')),
                      );
                      // Contoh navigasi ke halaman ProfilePage jika sudah ada
                      // Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfilePage()));
                    },
                  ),
                  _buildDivider(), // Garis pemisah
                  _buildSettingsTile(
                    context,
                    title: 'Ubah Kata Sandi',
                    onTap: () {
                      // TODO: Navigasi ke halaman Ubah Kata Sandi
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Navigasi ke Ubah Kata Sandi')),
                      );
                      // Contoh navigasi ke halaman ChangePasswordPage jika sudah ada
                      // Navigator.push(context, MaterialPageRoute(builder: (context) => const ChangePasswordPage()));
                    },
                  ),
                  _buildDivider(), // Garis pemisah
                  _buildSettingsTile(
                    context,
                    title: 'Ubah Bahasa',
                    onTap: () {
                      // TODO: Navigasi ke halaman Ubah Bahasa
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Navigasi ke Ubah Bahasa')),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20), // Spasi antara blok opsi dan Logout

            // Container untuk tombol Logout
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFF1C1C1E), // Warna latar belakang card
                borderRadius: BorderRadius.circular(10), // Sudut membulat
              ),
              child: _buildSettingsTile(
                context,
                title: 'Logout',
                textColor: Colors.red[400], // Warna teks merah untuk Logout
                onTap: () {
                  // TODO: Lakukan proses Logout (hapus token, dll.)
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Melakukan Logout...')),
                  );
                  // Contoh: Kembali ke halaman login setelah logout
                  // Navigator.pushAndRemoveUntil(
                  //   context,
                  //   MaterialPageRoute(builder: (context) => const LoginPage()), // Ganti LoginPage dengan halaman login Anda
                  //   (Route<dynamic> route) => false,
                  // );
                },
                showArrow: false, // Logout tidak perlu panah
              ),
            ),
          ],
        ),
      ),
      // Optional: Bottom Navigation Bar jika ini bagian dari navigasi utama aplikasi
      // bottomNavigationBar: BottomNavigationBar(
      //   backgroundColor: Colors.black, // Sesuaikan warna background
      //   selectedItemColor: Colors.cyanAccent, // Warna ikon aktif
      //   unselectedItemColor: Colors.grey, // Warna ikon tidak aktif
      //   items: const <BottomNavigationBarItem>[
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.home),
      //       label: 'Home',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.add_circle_outline),
      //       label: 'Add',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.settings),
      //       label: 'Settings',
      //     ),
      //   ],
      //   currentIndex: 2, // Sesuaikan index jika settings adalah item ketiga
      //   onTap: (index) {
      //     // Handle navigasi BottomNavigationBar
      //   },
      // ),
    );
  }

  // Widget helper untuk membuat setiap baris opsi pengaturan
  Widget _buildSettingsTile(
    BuildContext context, {
    required String title,
    required VoidCallback onTap,
    Color? textColor,
    bool showArrow = true, // Default: tampilkan panah
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10), // Agar ripple effect juga bulat
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                color: textColor ?? Colors.white, // Warna teks putih atau sesuai parameter
                fontSize: 16,
              ),
            ),
            if (showArrow)
              const Icon(
                Icons.arrow_forward_ios,
                color: Colors.grey, // Warna panah abu-abu
                size: 18,
              ),
          ],
        ),
      ),
    );
  }

  // Widget helper untuk garis pemisah
  Widget _buildDivider() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      height: 0.5,
      color: Colors.grey[800], // Warna garis pemisah yang lebih gelap
    );
  }
}