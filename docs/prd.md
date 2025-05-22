# **Product Requirements Document (PRD) – Aplikasi Eskulku**

---

## **1. Informasi Umum**

* **Nama Aplikasi**: Eskulku
* **Platform**: Mobile (Flutter, Android & iOS)
* **Backend**: Supabase (Auth, Database, Storage, Realtime)
* **Target Pengguna**:

  * Sekolah (Admin Ekstrakurikuler)
  * Siswa SMP

---

## **2. Tujuan Produk**
  
Eskulku bertujuan menjadi platform digital yang memudahkan pengelolaan kegiatan ekstrakurikuler di tingkat SMP. Aplikasi ini membantu sekolah dalam mengatur dan mendata kegiatan ekstrakurikuler, serta membantu siswa untuk mendaftar, mengikuti, dan memantau kegiatan dengan mudah dan menyenangkan.

---

## **3. Tipe Pengguna & Peran**

### 3.1. **Akun Sekolah**

* Mendaftar dan login menggunakan email dan password
* Mendapatkan Short ID unik
* Dapat membuat, mengedit, menghapus ekstrakurikuler
* Melihat daftar siswa yang mendaftar di setiap eskul

### 3.2. **Akun Siswa**

* Mendaftar menggunakan Short ID sekolah, nama, email, dan password
* Login untuk melihat dan mendaftar ke ekstrakurikuler yang tersedia di sekolahnya
* Melihat jadwal, kuota, dan status pendaftaran

---

## **4. Alur Pengguna (User Flow)**

### **4.1 Landing Page**

* Pilihan jenis akun:

  * [ ] Masuk sebagai Sekolah
  * [ ] Masuk sebagai Siswa

---

### **4.2. Alur Sekolah**

#### a. Registrasi Sekolah

* Input:

  * Nama Sekolah
  * Email
  * Password
* Output:

  * Akun sekolah dibuat
  * Redirect ke halaman login
* Setelah login:

  * Sistem membuat Short ID otomatis, contoh: `skl-X8TR2L`
  * User diarahkan ke Dashboard

#### b. Login Sekolah

* Input: Email, Password
* Aksi: Autentikasi via Supabase
* Output: Masuk ke Dashboard Sekolah

#### c. Dashboard Sekolah

Fitur:

* CRUD ekstrakurikuler:

  * Nama, Deskripsi, Pembimbing, Jadwal, Kategori, Kuota
* Lihat siswa terdaftar di setiap eskul
* Lihat dan kelola sisa kuota

---

### **4.3. Alur Siswa**

#### a. Registrasi Siswa

* Input:

  * Short ID Sekolah
  * Nama
  * Email
  * Password
* Validasi:

  * Short ID cocok dengan data sekolah
* Output:

  * Akun siswa dibuat
  * Redirect ke halaman login siswa

#### b. Login Siswa

* Input: Email, Password
* Output: Masuk ke Dashboard Siswa

#### c. Dashboard Siswa

Fitur:

* Melihat semua ekstrakurikuler dari sekolahnya
* Melihat detail: nama, deskripsi, pembimbing, jadwal, kuota tersisa
* Daftar ke beberapa ekstrakurikuler

  * Cek kuota
  * Cek bentrok jadwal
  * Cek batas maksimal eskul

---

## **5. Fitur Utama (Detail)**

### 5.1. **Manajemen Ekstrakurikuler (Sekolah)**

* Tambah/Edit/Hapus eskul
* Field:

  * Nama
  * Deskripsi
  * Pembimbing
  * Kategori (Olahraga, Seni, Akademik, dll.)
  * Jadwal (hari & jam)
  * Kuota

### 5.2. **Pendaftaran Eskul (Siswa)**

* Menampilkan eskul dari sekolah sesuai Short ID
* Menampilkan detail lengkap
* Tombol “Daftar” dengan validasi:

  * Tidak bentrok jadwal
  * Kuota masih tersedia
  * Belum mencapai batas maksimal jumlah eskul

### 5.3. **Monitoring Pendaftaran (Sekolah)**

* Lihat siapa saja yang sudah mendaftar tiap eskul
* Jumlah peserta dan sisa kuota

---

## **6. Struktur Database (Supabase)**

### **Tabel `schools`**

| Field          | Tipe   | Deskripsi                     |
| -------------- | ------ | ----------------------------- |
| id             | UUID   | ID unik sekolah               |
| name           | String | Nama sekolah                  |
| email          | String | Email login                   |
| password\_hash | String | Password yang di-hash         |
| short\_id      | String | Kode unik sekolah (`skl-XXX`) |

---

### **Tabel `students`**

| Field          | Tipe   | Deskripsi             |
| -------------- | ------ | --------------------- |
| id             | UUID   | ID siswa              |
| school\_id     | UUID   | FK ke `schools.id`    |
| name           | String | Nama lengkap siswa    |
| email          | String | Email login           |
| password\_hash | String | Password yang di-hash |

---

### **Tabel `extracurriculars`**

| Field       | Tipe    | Deskripsi                      |
| ----------- | ------- | ------------------------------ |
| id          | UUID    | ID eskul                       |
| school\_id  | UUID    | FK ke `schools.id`             |
| name        | String  | Nama eskul                     |
| description | Text    | Deskripsi                      |
| instructor  | String  | Nama pembimbing                |
| category    | String  | Kategori (Olahraga, Seni, dll) |
| schedule    | JSON    | Hari dan jam latihan           |
| quota       | Integer | Kuota maksimal peserta         |

---

### **Tabel `registrations`**

| Field               | Tipe      | Deskripsi                   |
| ------------------- | --------- | --------------------------- |
| id                  | UUID      | ID pendaftaran              |
| student\_id         | UUID      | FK ke `students.id`         |
| extracurricular\_id | UUID      | FK ke `extracurriculars.id` |
| created\_at         | Timestamp | Tanggal daftar              |

---

## **7. Non-Fungsional Requirements**

* Aplikasi ringan dan responsif
* Validasi dan keamanan data login via Supabase Auth
* Penggunaan RLS (Row-Level Security) di Supabase untuk keamanan data antar sekolah
* UI ramah anak SMP, mudah digunakan

---

## **8. Roadmap Pengembangan**

| Tahap | Deskripsi                       |
| ----- | ------------------------------- |
| 1     | Desain UI/UX dan Flow Diagram   |
| 2     | Setup Supabase (Auth, DB, RLS)  |
| 3     | Pendaftaran dan Login Sekolah   |
| 4     | Dashboard Sekolah & CRUD Eskul  |
| 5     | Pendaftaran dan Login Siswa     |
| 6     | Dashboard Siswa & Daftar Eskul  |
| 7     | Validasi kuota & bentrok jadwal |
| 8     | Testing dan Deployment          |

---

## **9. Pengukuran Keberhasilan (Success Metrics)**

* Jumlah sekolah yang mendaftar
* Jumlah siswa aktif mingguan
* Rata-rata jumlah eskul per sekolah
* Feedback pengguna dari siswa dan pembina

---

