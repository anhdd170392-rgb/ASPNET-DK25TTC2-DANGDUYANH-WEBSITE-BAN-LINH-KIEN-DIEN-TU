# ALMOND - Website Bán Linh Kiện Điện Tử

## 1. Giới thiệu

**ALMOND** là website thương mại điện tử bán linh kiện điện tử được xây dựng bằng **ASP.NET MVC 5** với **LINQ to SQL** làm ORM và **SQL Server** làm cơ sở dữ liệu. Website hỗ trợ quản lý bán hàng trực tuyến bao gồm: quản lý sản phẩm, danh mục, giỏ hàng, đặt hàng, thanh toán, khuyến mãi, báo cáo thống kê, và phân quyền người dùng (Admin / Nhân viên / Khách hàng).

---

## 2. Công nghệ sử dụng

| Lớp | Công nghệ |
|---|---|
| Backend | ASP.NET MVC 5 (.NET Framework 4.8) |
| Ngôn ngữ | C# |
| ORM | LINQ to SQL (`.dbml`) |
| Database | SQL Server Express |
| Frontend | HTML5, CSS3, Bootstrap 3, JavaScript, jQuery |
| Font | Google Fonts - Roboto |
| Icon | Font Awesome 5 |
| XLSX Export | ClosedXML |
| Build | MSBuild (Visual Studio 18 Insiders) |

---

## 3. Sơ đồ thư mục dự án

```
DangAnh/
├── BanLinhKienDienTu.sql          # Script SQL schema
├── build.bat                       # Script build (MSBuild)
├── README.md                       # Tài liệu dự án
├── Progress_Report/                # Báo cáo tiến độ
├── thesis/                         # Báo cáo đồ án Word
└── src/                            # Nguồn dự án
    ├── App_Data/
    │   ├── WebDienTu_Clean.sql     # Script tạo DB + dữ liệu mẫu
    │   └── WebDienTu.mdf           # File database
    ├── App_Start/                  # RouteConfig, BundleConfig, FilterConfig
    ├── Areas/
    │   └── Admin/                  # Khu vực quản trị
    │       ├── Controllers/        # AdminController, SanPhamsController, DonHangsController,
    │       │                       # BaoCaoController, KhuyenMaiController, BackupController,
    │       │                       # LoaisController, NhaCungCapsController, PhieuNhapController,
    │       │                       # AccountSettingsController
    │       ├── Model/              # ViewModel (DoanhThu*, CongNo*, PhieuNhap*, ...)
    │       ├── Views/              # Giao diện Admin
    │       ├── Content/            # CSS Admin
    │       └── Scripts/            # JS Admin
    ├── Controllers/
    │   ├── HomeController.cs       # Trang chủ, search, sort
    │   ├── SanPhamController.cs    # Sản phẩm, chi tiết, yêu thích
    │   ├── GioHangController.cs    # Giỏ hàng, đặt hàng, mã giảm giá
    │   ├── NguoiDungController.cs  # Đăng ký, đăng nhập, tài khoản, đơn hàng
    │   ├── LoaiController.cs       # Danh mục
    │   ├── NhaCungCapController.cs # Nhà cung cấp (thương hiệu)
    │   └── PriceHelper.cs          # Helper format giá
    ├── Models/
    │   ├── MyData.dbml             # LINQ to SQL DataContext
    │   ├── MyData.designer.cs      # Auto-generated
    │   ├── GioHang.cs              # CartItem model
    │   └── HomeModel.cs            # Home page model
    ├── Security/
    │   └── VaiTroTuyChinh.cs       # Custom role provider
    ├── Helpers/
    │   └── VnPayLibrary.cs         # VNPay integration helper
    ├── Views/
    │   ├── Home/                   # Index, About, Contact
    │   ├── SanPham/                # ListSanPham, Detail, YeuThich
    │   ├── GioHang/                # GioHang, DatHang, XacNhanDonHang
    │   ├── NguoiDung/              # DangKy, DangNhap, ThongTinCaNhan, LichSuDonHang
    │   ├── Loai/                   # ListLoai, SanPhamLoai
    │   ├── NhaCungCap/             # ListNhaCungCap, Detail
    │   ├── thanhtoan/              # ChonPhuongThuc (VNPay/MoMo)
    │   ├── Shared/                 # _Layout.cshtml (layout chung)
    │   └── Error/
    ├── Content/
    │   ├── images/                 # Tất cả ảnh sản phẩm, banner, logo
    │   ├── Site.css, base.css, grid.css, main.css, responsive.css
    │   └── bootstrap.css
    ├── Scripts/                    # jQuery, Bootstrap JS
    └── Web.config                  # Cấu hình ứng dụng
```

---

## 4. Cài đặt và chạy dự án

### Yêu cầu
- Windows 10/11
- Visual Studio 2019/2022 (hoặc Visual Studio Insiders 18)
- SQL Server Express (instance `localhost\SQLEXPRESS`)
- .NET Framework 4.8
- IIS Express

### Bước 1: Clone / Copy dự án
```
git clone <repo-url>
```
Hoặc copy thư mục `src/` vào máy.

### Bước 2: Tạo database
Mở **SQL Server Management Studio** (hoặc sqlcmd), chạy file:
```
src/App_Data/WebDienTu_Clean.sql
```
File này sẽ:
- Xóa database cũ `WebDienTu` (nếu có)
- Tạo mới database với collation `Vietnamese_CI_AS`
- Tạo tất cả tables, views, stored procedures
- Insert dữ liệu mẫu (sản phẩm, tài khoản, khuyến mãi...)

**Lưu ý:** File phải được chạy với mã hóa UTF-8. Nếu dùng sqlcmd:
```cmd
sqlcmd -S "localhost\SQLEXPRESS" -i WebDienTu_Clean.sql -E -f 65001
```

### Bước 3: Cập nhật Connection String
Mở `src/Web.config`, kiểm tra dòng:
```xml
<add name="webdientuConnectionString"
     connectionString="Server=localhost\SQLEXPRESS;Database=WebDienTu;Integrated Security=True"
     providerName="System.Data.SqlClient" />
```
Sửa `Server=` cho khớp tên instance SQL Server của bạn.

### Bước 4: Build dự án
**Cách 1:** Mở `src/webdientu.sln` bằng Visual Studio → **Build** (Ctrl+Shift+B)

**Cách 2:** Chạy file `build.bat` từ command prompt:
```cmd
D:\DangAnh\DangAnh\build.bat
```

### Bước 5: Chạy trên IIS Express
Trong Visual Studio nhấn **F5** hoặc truy cập:
```
https://localhost:44333/
```

---

## 5. Tài khoản đăng nhập

### Tài khoản mẫu (có sẵn trong database)

| Vai trò | Username | Password | RoleID | Ghi chú |
|---|---|---|---|---|
| **Admin** | `admin` | `admin123` | 1 | Quản trị toàn quyền |
| **Khách hàng** | `user1` | `user123` | 2 | User thường |

### Thêm tài khoản mới
Đăng ký qua trang `/NguoiDung/DangKy`. Tài khoản mới đăng ký mặc định có **RoleID = 2** (Khách hàng).

### Phân quyền chi tiết

| RoleID | Vai trò | Quyền |
|---|---|---|
| 1 | Admin | Quản lý tất cả: sản phẩm, danh mục, đơn hàng, khuyến mãi, báo cáo, user, backup/restore |
| 2 | Khách hàng | Xem sản phẩm, giỏ hàng, đặt hàng, xem lịch sử đơn, yêu thích |

---

## 6. Các link truy cập

### Trang khách hàng
| Trang | URL |
|---|---|
| Trang chủ | `https://localhost:44333/` |
| Danh sách sản phẩm | `https://localhost:44333/SanPham/ListSanPham` |
| Chi tiết sản phẩm | `https://localhost:44333/SanPham/Detail/{id}` |
| Danh mục | `https://localhost:44333/Loai/ListLoai` |
| Thương hiệu (NCC) | `https://localhost:44333/NhaCungCap/ListNhaCungCap` |
| Yêu thích | `https://localhost:44333/SanPham/DanhSachYeuThich` |
| Giỏ hàng | `https://localhost:44333/GioHang/GioHang` |
| Đăng nhập | `https://localhost:44333/NguoiDung/DangNhap` |
| Đăng ký | `https://localhost:44333/NguoiDung/DangKy` |

### Trang quản trị Admin
Đăng nhập bằng tài khoản **admin / admin123** → tự redirect vào Admin.

| Trang | URL |
|---|---|
| Quản lý sản phẩm | `https://localhost:44333/Admin/SanPhams/ListSanPham` |
| Quản lý đơn hàng | `https://localhost:44333/Admin/DonHangs/ListDonHang` |
| Quản lý danh mục | `https://localhost:44333/Admin/Loais/ListLoai` |
| Quản lý NCC | `https://localhost:44333/Admin/NhaCungCaps/ListNhaCungCap` |
| Quản lý khuyến mãi | `https://localhost:44333/Admin/KhuyenMai/Index` |
| Phiếu nhập | `https://localhost:44333/Admin/PhieuNhap/Create` |
| Báo cáo doanh thu ngày | `https://localhost:44333/Admin/BaoCao/DoanhThuNgay` |
| Báo cáo doanh thu tháng | `https://localhost:44333/Admin/BaoCao/DoanhThuThang` |
| Báo cáo tồn kho | `https://localhost:44333/Admin/BaoCao/TonKho` |
| Sản phẩm sắp hết hàng | `https://localhost:44333/Admin/BaoCao/SanPhamHetHang` |
| Top sản phẩm bán chạy | `https://localhost:44333/Admin/BaoCao/TopSanPham` |
| Top khách hàng | `https://localhost:44333/Admin/BaoCao/TopKhachHang` |
| Nhật ký bán hàng | `https://localhost:44333/Admin/BaoCao/NhatKyBanHang` |
| Công nợ | `https://localhost:44333/Admin/BaoCao/CongNo` |
| Theo dõi đơn hàng | `https://localhost:44333/Admin/BaoCao/TheoDoiDonHang` |
| Backup/Restore | `https://localhost:44333/Admin/Backup/Index` |

---

## 7. Chức năng chính

### 7.1. Khách hàng (User)

| Chức năng | Mô tả |
|---|---|
| Đăng ký / Đăng nhập | Tạo tài khoản, xác thực, quản lý session |
| Xem sản phẩm | Danh sách sản phẩm phân trang, tìm kiếm theo tên, sắp xếp theo giá/mới nhất |
| Xem chi tiết sản phẩm | Thông tin chi tiết, giá, mô tả, sản phẩm liên quan |
| Danh mục (Loại) | Lọc sản phẩm theo loại |
| Thương hiệu (NCC) | Xem danh sách và chi tiết nhà cung cấp |
| Yêu thích | Thêm/bỏ sản phẩm yêu thích (cần đăng nhập) |
| Giỏ hàng | Thêm/xóa/sửa số lượng, áp dụng mã giảm giá |
| Đặt hàng | Chọn phương thức thanh toán, địa chỉ giao, ghi chú |
| Lịch sử đơn hàng | Xem chi tiết, hủy đơn (trạng thái chờ giao), trả hàng (đã giao) |
| Thông tin cá nhân | Xem/sửa thông tin, đổi mật khẩu |

### 7.2. Quản trị viên (Admin)

| Chức năng | Mô tả |
|---|---|
| **Quản lý sản phẩm** | CRUD sản phẩm, upload ảnh |
| **Quản lý danh mục** | CRUD loại sản phẩm |
| **Quản lý NCC** | CRUD nhà cung cấp |
| **Quản lý đơn hàng** | Xem danh sách, cập nhật trạng thái (chờ giao → đã giao → trả hàng / hủy) |
| **Quản lý khuyến mãi** | Tạo/sửa/xóa mã giảm giá, áp dụng cho sản phẩm |
| **Phiếu nhập hàng** | Tạo phiếu nhập từ NCC, cập nhật tồn kho |
| **Tìm kiếm toàn cục** | Tìm kiếm sản phẩm, đơn hàng, NCC cùng lúc |
| **Cài đặt tài khoản** | Quản lý thông tin tài khoản admin |

### 7.3. Báo cáo & Thống kê

| Báo cáo | Mô tả |
|---|---|
| Doanh thu theo ngày | Thống kê doanh thu, đơn hàng, khách hàng theo ngày |
| Doanh thu theo tháng | Thống kê theo tháng, biểu đồ theo ngày trong tháng |
| Doanh thu theo loại | Doanh thu phân theo loại sản phẩm |
| Nhật ký bán hàng | Chi tiết từng giao dịch, lợi nhuận |
| Tồn kho | Kiểm kê tồn kho hiện tại, đã bán 30 ngày |
| Sản phẩm sắp hết hàng | Cảnh báo sản phẩm tồn thấp |
| Top sản phẩm bán chạy | Xếp hạng sản phẩm theo doanh thu |
| Top khách hàng | Xếp hạng khách hàng theo giá trị đơn |
| Công nợ | Theo dõi công nợ khách hàng |
| Theo dõi đơn hàng | Theo dõi trạng thái đơn hàng real-time |

### 7.4. Tính năng khác

| Tính năng | Mô tả |
|---|---|
| Backup / Restore database | Sao lưu và khôi phục database qua giao diện Admin |
| Mã giảm giá | Áp dụng mã giảm giá theo % với điều kiện đơn tối thiểu |
| Tự động giảm tồn kho | Khi đặt hàng thành công tự trừ số lượng tồn |
| Merge giỏ hàng | Giỏ hàng Session + Database, merge khi đăng nhập |
| Thanh toán VAT | Tính toán VAT 10%, phí vận chuyển cố định |

---

## 8. Các lỗi thường gặp và cách xử lý

### Lỗi 1: "Could not load type 'LTW.MvcApplication'"
**Nguyên nhân:** File `LTW.dll` không được build (thư mục `bin/` trống).

**Cách sửa:**
1. Mở Visual Studio → Load project → Build (Ctrl+Shift+B)
2. Hoặc chạy `build.bat` từ command prompt

---

### Lỗi 2: "The imported project Microsoft.WebApplication.targets was not found"
**Nguyên nhân:** MSBuild không tìm được Web Application targets. Thường gặp khi build từ command line mà không qua Visual Studio.

**Cách sửa:**
1. Dùng file `build.bat` đã được cấu hình sẵn:
```cmd
D:\DangAnh\DangAnh\build.bat
```
2. Hoặc build qua Visual Studio (đã tự động cấu hình đúng version).

---

### Lỗi 3: "Server Error in '/' Application - Error establishing a database connection"
**Nguyên nhân:** Không kết nối được SQL Server.

**Cách sửa:**
1. Kiểm tra SQL Server Express đang chạy: Services → `SQL Server (SQLEXPRESS)`
2. Kiểm tra Connection String trong `Web.config` khớp tên instance:
```xml
Server=localhost\SQLEXPRESS;Database=WebDienTu;Integrated Security=True
```
3. Nếu dùng tên máy khác, sửa `Server=` cho đúng (hoặc dùng `.` cho localhost).

---

### Lỗi 4: Bảng `NCC` hoặc các bảng mới không tồn tại
**Nguyên nhân:** Database cũ chưa có bảng mới. File `WebDienTu_Clean.sql` sẽ drop và tạo lại.

**Cách sửa:**
```cmd
sqlcmd -S "localhost\SQLEXPRESS" -i WebDienTu_Clean.sql -E -f 65001
```
**Cảnh báo:** Thao tác này sẽ xóa toàn bộ dữ liệu cũ.

---

### Lỗi 5: Tiếng Việt bị lỗi font / hiển thị dấu ?
**Nguyên nhân:** Collation database sai (`SQL_Latin1_General_CP1_CI_AS`) hoặc font chưa load đúng.

**Cách sửa:**
1. Re-import database với collation đúng (`Vietnamese_CI_AS` trong `WebDienTu_Clean.sql`)
2. Kiểm tra file `Content/base.css` có dòng fallback font:
```css
font-family: 'Roboto', 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
```

---

### Lỗi 6: Ảnh sản phẩm không hiển thị (broken image)
**Nguyên nhân:** Giá trị cột `Hinh` trong database không khớp tên file trong `Content/images/`.

**Cách sửa:**
1. Kiểm tra tên file ảnh trong `Content/images/` có trùng khớp với giá trị cột `Hinh` trong bảng `SanPham`
2. Giá trị `Hinh` phải có prefix `Content/images/` (vd: `Content/images/bien-tro1.png`)
3. Re-import database nếu dùng bản `WebDienTu_Clean.sql` mới nhất

---

### Lỗi 7: "Login failed for user" khi chạy trên máy khác
**Nguyên nhân:** Connection String dùng `Integrated Security=True` (Windows Auth), máy khác không có tài khoản SQL Server tương ứng.

**Cách sửa:** Đổi sang SQL Server Authentication trong `Web.config`:
```xml
Server=.\SQLEXPRESS;Database=WebDienTu;User Id=sa;Password=your_password
```

---

### Lỗi 8: Port 44333 bị chiếm
**Nguyên nhân:** Ứng dụng khác đang dùng port 44333.

**Cách sửa:**
1. Đổi port trong project properties: right-click project → Properties → Web →改 port trong HTTPS
2. Hoặc sửa file `Web.config` ở section `<system.webServer>` nếu cần

---

### Lỗi 9: build.bat không chạy / MSBuild path sai
**Nguyên nhân:** Đường dẫn Visual Studio / MSBuild không đúng trên máy bạn.

**Cách sửa:** Sửa file `build.bat`, thay đường dẫn MSBuild cho đúng máy bạn. Tìm MSBuild:
```cmd
where MSBuild.exe
```
Hoặc tìm trong:
```
C:\Program Files\Microsoft Visual Studio\*\*\MSBuild\Current\Bin\MSBuild.exe
C:\Windows\Microsoft.NET\Framework64\v4.0.30319\MSBuild.exe
```

---

### Lỗi 10: jQuery / Bootstrap không hoạt động
**Nguyên nhân:** CDN bị chặn hoặc file JS không load.

**Cách sửa:**
1. Kiểm tra Console trên trình duyệt (F12)
2. Nếu CDN bị chặn: thêm link local fallback
3. Kiểm tra thứ tự load script trong `_Layout.cshtml`: jQuery phải load trước Bootstrap

---

## 9. Dữ liệu mẫu có sẵn trong database

### Sản phẩm (10 sản phẩm)
| MaSP | Tên sản phẩm | Giá |
|---|---|---|
| 1 | CPU Intel Core i5 | 4.500.000đ |
| 2 | RAM DDR4 8GB | 850.000đ |
| 3 | SSD 256GB | 1.200.000đ |
| 4 | Dây cáp USB 3.0 | 150.000đ |
| 5 | Màn hình 24 inch | 3.500.000đ |
| 6 | Biến trở 10K | 5.000đ |
| 7 | Tụ điện 100uF | 3.000đ |
| 8 | Cầu chì 5A | 7.000đ |
| 9 | Cuộn cảm 10uH | 8.000đ |
| 10 | Điện trở 1K | 1.000đ |

### Danh mục
| MaLoai | Tên loại |
|---|---|
| 1 | Linh Kiện Điện Tử |
| 2 | Dây Cáp |
| 3 | Bộ Phận Máy Tính |

### Nhà cung cấp
| MaNCC | Tên NCC |
|---|---|
| 1 | Công Ty ABC |
| 2 | Công Ty XYZ |

### Phương thức thanh toán
| MaTT | Tên |
|---|---|
| 1 | Tiền mặt |
| 2 | Chuyển khoản |
| 3 | Ví điện tử |

---

**Đồ án tốt nghiệp** - Xây dựng website bán linh kiện điện tử bằng ASP.NET MVC
