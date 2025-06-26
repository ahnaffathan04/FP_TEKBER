# Festipass

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Supabase](https://img.shields.io/badge/Supabase-16B981?style=for-the-badge&logo=supabase&logoColor=white)

## Deskripsi Project

Festipass adalah aplikasi Flutter yang dirancang untuk mengelola acara dan tiket, melayani baik pembeli tiket (buyer) maupun penyelenggara acara (organizer). Aplikasi ini memungkinkan pengguna untuk mencari dan membeli tiket konser, serta bagi penyelenggara untuk mengelola konser dan penjualan tiket.

## Cara Menjalankan Program

Untuk menjalankan proyek FestiPass, ikuti langkah-langkah berikut:

### Prasyarat

Sebelum memulai, pastikan Anda telah menginstal yang berikut:

* **Flutter SDK**: Ikuti petunjuk instalasi resmi dari [dokumentasi Flutter](https://flutter.dev/docs/get-started/install).
* **Git**: Diperlukan untuk mengkloning repositori. Anda bisa mengunduhnya dari [situs resmi Git](https://git-scm.com/downloads).

### Langkah-langkah Instalasi dan Menjalankan

1.  **Kloning Repositori**
    Jika proyek Anda berada di repositori Git, kloning ke mesin lokal Anda menggunakan perintah:

    ```bash
    git clone [https://github.com/ahnaffathan04/FP_TEKBER.git](https://github.com/ahnaffathan04/FP_TEKBER.git)
    cd FP_TEKBER-54f9b70bf1da99cf863c7e50da7f11f9e81eed0f
    ```

2.  **Instal Dependensi**
    Setelah menavigasi ke direktori proyek, dapatkan semua dependensi yang diperlukan dengan menjalankan:

    ```bash
    flutter pub get
    ```

3.  **Konfigurasi Supabase & Database Schema**
    Aplikasi ini menggunakan [Supabase](https://supabase.com/) sebagai *backend*. Anda perlu mengatur proyek Supabase Anda sendiri dan memperbarui kredensial di `lib/main.dart`.

    * Buka file `lib/main.dart`.
    * Cari bagian `Supabase.initialize` dan ganti `url` serta `anonKey` dengan kredensial proyek Supabase Anda:

        ```dart
        await Supabase.initialize(
          url: 'YOUR_SUPABASE_URL', // Ganti dengan URL Supabase Anda
          anonKey: 'YOUR_SUPABASE_ANON_KEY', // Ganti dengan kunci anon Supabase Anda
        );
        ```

    * Pastikan Anda telah membuat tabel-tabel yang diperlukan di database Supabase Anda, seperti `profiles`, `konser`, `concert_table`, dan `problem_table`, sesuai dengan skema yang digunakan dalam kode (misalnya, `user_category` di tabel `profiles`).

    Berikut adalah kode untuk membuat skema database Anda:

    ```sql
    -- Table: public.artist_table
    CREATE TABLE public.artist_table (
        artist_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
        artist_name TEXT NOT NULL,
        created_at TIMESTAMPTZ DEFAULT NOW()
    );

    -- Table: public.profiles
    CREATE TABLE public.profiles (
        id UUID REFERENCES auth.users(id) ON DELETE CASCADE UNIQUE,
        user_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
        user_name TEXT NOT NULL,
        user_category TEXT NOT NULL, -- 'buyer' or 'organizer'
        email TEXT NOT NULL UNIQUE,
        phone_number TEXT NOT NULL,
        profile_picture TEXT,
        registration_data TIMESTAMPTZ DEFAULT NOW(),
        is_active BOOLEAN DEFAULT TRUE,
        date_of_birth DATE,
        fullname TEXT,
        created_at TIMESTAMPTZ DEFAULT NOW()
    );

    -- Enable Row Level Security (RLS) for profiles table
    ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;

    -- Policy for profiles table (example - adjust as needed for your app's logic)
    CREATE POLICY "Users can view their own profile." ON public.profiles FOR SELECT USING (auth.uid() = id);
    CREATE POLICY "Users can update their own profile." ON public.profiles FOR UPDATE USING (auth.uid() = id);

    -- Table: public.concert_table
    CREATE TABLE public.concert_table (
        concert_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
        concert_name TEXT NOT NULL,
        concert_date DATE NOT NULL,
        location TEXT NOT NULL,
        description TEXT,
        concert_poster TEXT,
        artist_id UUID REFERENCES public.artist_table(artist_id) ON DELETE SET NULL,
        city TEXT,
        duration TEXT,
        status TEXT, -- e.g., 'upcoming', 'completed', 'cancelled'
        created_at TIMESTAMPTZ DEFAULT NOW()
    );

    -- Table: public.concert_ticket
    CREATE TABLE public.concert_ticket (
        concert_ticket_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
        concert_id UUID REFERENCES public.concert_table(concert_id) ON DELETE CASCADE,
        category TEXT NOT NULL, -- e.g., 'VIP', 'Regular Early', 'VIP Early'
        price NUMERIC(10, 2) NOT NULL,
        availability INT NOT NULL, -- total available tickets for this category
        filled INT DEFAULT 0, -- tickets sold for this category
        max_purchase INT DEFAULT 10, -- max tickets a single user can buy for this category
        created_at TIMESTAMPTZ DEFAULT NOW()
    );

    -- Table: public.purchase_table
    CREATE TABLE public.purchase_table (
        purchase_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
        concert_ticket_id UUID REFERENCES public.concert_ticket(concert_ticket_id) ON DELETE SET NULL,
        ordered_seat_number TEXT, -- Could be an array of text if multiple seats
        order_number TEXT UNIQUE NOT NULL,
        created_at TIMESTAMPTZ DEFAULT NOW(),
        user_id UUID REFERENCES public.profiles(id) ON DELETE SET NULL, -- Link to profiles.id
        total_amount NUMERIC(10, 2) NOT NULL,
        status TEXT NOT NULL, -- e.g., 'pending', 'completed', 'cancelled'
        payment_method TEXT,
        purchase_data TIMESTAMPTZ DEFAULT NOW()
    );

    -- Table: public.feedback_table
    CREATE TABLE public.feedback_table (
        feedback_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
        purchase_id UUID REFERENCES public.purchase_table(purchase_id) ON DELETE CASCADE,
        rating NUMERIC(2, 1) NOT NULL, -- e.g., 4.5
        review TEXT,
        created_at TIMESTAMPTZ DEFAULT NOW()
    );

    -- Table: public.problem_table
    CREATE TABLE public.problem_table (
        problem_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
        purchase_id UUID REFERENCES public.purchase_table(purchase_id) ON DELETE SET NULL,
        email TEXT NOT NULL,
        problem_category TEXT NOT NULL,
        detail TEXT NOT NULL,
        file TEXT, -- URL to an uploaded file (optional)
        created_at TIMESTAMPTZ DEFAULT NOW()
    );
    ```

```bash
flutter run