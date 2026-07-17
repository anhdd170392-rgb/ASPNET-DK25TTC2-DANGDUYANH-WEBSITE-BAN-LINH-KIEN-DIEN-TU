# ALMOND - Website Bán Linh Kiện Điện Tử

Đồ án môn **Lập trình Web** — Xây dựng website thương mại điện tử bán linh kiện điện tử với đầy đủ tính năng: quản lý sản phẩm, giỏ hàng, đặt hàng, thanh toán trực tuyến, khuyến mãi, báo cáo thống kê và phân quyền người dùng.

---

## 1. Giới thiệu

**ALMOND** là website thương mại điện tử mô phỏng cửa hàng bán linh kiện điện tử (điện trở, tụ điện, cuộn cảm, cáp, linh kiện máy tính,...). Hệ thống gồm hai phần chính:

- **Front-end (Khách hàng):** Duyệt sản phẩm, tìm kiếm, sắp xếp theo giá/ngày, xem chi tiết, thêm vào giỏ hàng, áp dụng mã giảm giá, đặt hàng, thanh toán (tiền mặt / chuyển khoản / ví điện tử VNPay), quản lý tài khoản, lịch sử đơn hàng, yêu thích.
- **Back-end (Admin):** Quản lý sản phẩm, danh mục, nhà cung cấp, đơn hàng, khuyến mãi, phiếu nhập hàng, báo cáo doanh thu (ngày/tháng/theo loại), tồn kho, top sản phẩm, top khách hàng, công nợ, nhật ký bán hàng, backup/restore database.

---

## 2. Công nghệ sử dụng

| Lớp | Công nghệ |
|---|---|
| Backend | ASP.NET MVC 5 (.NET Framework 4.8) |
| Ngôn ngữ | C# |
| ORM | LINQ to SQL (`.dbml`) |
| Database | SQL Server Express (`.\SQLEXPRESS`) |
| Frontend | HTML5, CSS3, Bootstrap 3/5, JavaScript, jQuery |
| Font / Icon | Google Fonts (Roboto), Font Awesome 5 |
| Export Excel | ClosedXML |
| Thanh toán | VNPay (tích hợp sẵn `VnPayLibrary.cs`) |
| Build | MSBuild (Visual Studio 2022 / Insiders 18) |

---

## 3. Sơ đồ thư mục dự án

```
DangAnh/
├── BanLinhKienDienTu.sql              # Script SQL schema đầy đủ
├── README.md                           # Tài liệu dự án
├── Progress_Report/                    # Báo cáo tiến độ đồ án
├── thesis/                             # File báo cáo Word (.doc/.docx)
└── src/                                # Mã nguồn dự án
    ├── webdientu.sln                   # Solution file
    ├── webdientu.csproj                # Project file
    ├── Web.config                      # Cấu hình kết nối DB, route, auth
    ├── App_Data/
    │   ├── WebDienTu_Clean.sql         # Script tạo DB + dữ liệu mẫu (UTF-8)
    │   ├── WebDienTu.mdf               # File database
    │   └── BanLinhKienDienTu.sql       # Script schema (bản khác)
    ├── App_Start/
    │   ├── RouteConfig.cs              # Cấu hình route mặc định
    │   ├── BundleConfig.cs             # Cấu hình JS/CSS bundle
    │   └── FilterConfig.cs             # Cấu hình filter
    ├── Controllers/                    # Controllers phía khách hàng
    │   ├── HomeController.cs           # Trang chủ, search, sort
    │   ├── SanPhamController.cs        # Xem sản phẩm, chi tiết, yêu thích
    │   ├── GioHangController.cs        # Giỏ hàng, đặt hàng, mã giảm giá, VNPay
    │   ├── NguoiDungController.cs      # Đăng ký, đăng nhập, tài khoản, đơn hàng
    │   ├── LoaiController.cs           # Danh mục sản phẩm
    │   ├── NhaCungCapController.cs     # Nhà cung cấp (thương hiệu)
    │   ├── ErrorController.cs          # Trang lỗi
    │   └── PriceHelper.cs              # Helper format giá
    ├── Models/
    │   ├── MyData.dbml                 # LINQ to SQL DataContext
    │   ├── MyData.designer.cs          # Auto-generated
    │   ├── GioHang.cs                  # CartItem model
    │   └── HomeModel.cs                # Home page model
    ├── Helpers/
    │   └── VnPayLibrary.cs             # Helper tích hợp thanh toán VNPay
    ├── Security/
    │   └── VaiTroTuyChinh.cs           # Custom Role Provider
    ├── Areas/Admin/                    # Khu vực quản trị
    │   ├── Controllers/
    │   │   ├── AdminController.cs       # Tìm kiếm toàn cục
    │   │   ├── SanPhamsController.cs    # CRUD sản phẩm
    │   │   ├── DonHangsController.cs    # Quản lý đơn hàng
    │   │   ├── LoaisController.cs       # CRUD danh mục
    │   │   ├── NhaCungCapsController.cs # CRUD nhà cung cấp
    │   │   ├── KhuyenMaiController.cs   # Quản lý khuyến mãi
    │   │   ├── PhieuNhapController.cs   # Phiếu nhập hàng
    │   │   ├── BaoCaoController.cs      # Báo cáo thống kê (10 loại)
    │   │   ├── BackupController.cs      # Backup/Restore DB
    │   │   └── AccountSettingsController.cs # Cài đặt tài khoản
    │   ├── Model/                       # ViewModels cho báo cáo
    │   ├── Views/                       # Giao diện Admin
    │   ├── Content/                     # CSS Admin
    │   └── Scripts/                     # JS Admin (jQuery, Bootstrap)
    ├── Views/                           # Views phía khách hàng
    │   ├── Home/                        # Index, About, Contact
    │   ├── SanPham/                     # ListSanPham, Detail, YeuThich
    │   ├── GioHang/                     # GioHang, DatHang, XacNhanDonHang
    │   ├── NguoiDung/                   # DangKy, DangNhap, ThongTinCaNhan, LichSuDonHang
    │   ├── Loai/                        # ListLoai, SanPhamLoai
    │   ├── NhaCungCap/                  # ListNhaCungCap, Detail
    │   ├── thanhtoan/                   # ChonPhuongThuc (VNPay)
    │   ├── Shared/                      # _Layout.cshtml (layout chung)
    │   └── Error/
    ├── Content/
    │   ├── images/                      # Ảnh sản phẩm, banner, logo
    │   ├── Site.css, base.css, grid.css, main.css, responsive.css
    │   └── bootstrap.css
    ├── Scripts/                         # jQuery 3.4.1, Bootstrap JS, Modernizr
    └── packages.config                  # NuGet packages
```

---

## 4. Cài đặt và chạy dự án

### Yêu cầu hệ thống
- Windows 10/11
- Visual Studio 2019/2022 (hoặc Visual Studio Insiders 18)
- SQL Server Express — instance `.\SQLEXPRESS`
- .NET Framework 4.8
- IIS Express (kèm Visual Studio)

### Bước 1: Clone dự án
```bash
git clone https://github.com/anhdd170392-rgb/DangAnh.git
```

### Bước 2: Tạo database
Mở **SQL Server Management Studio** (hoặc `sqlcmd`), chạy file:
```
src/App_Data/WebDienTu_Clean.sql
```
Script này sẽ tự động:
- Xoá database cũ `WebDienTu` (nếu có)
- Tạo mới database với collation `Vietnamese_CI_AS`
- Tạo toàn bộ bảng, khóa ngoại
- Insert dữ liệu mẫu (sản phẩm, tài khoản, danh mục, khuyến mãi,...)

```cmd
sqlcmd -S ".\SQLEXPRESS" -i "src\App_Data\WebDienTu_Clean.sql" -E -f 65001
```

> **Lưu ý:** File `.sql` phải được chạy với mã hoá UTF-8 (`-f 65001`).

### Bước 3: Kiểm tra Connection String
Mở `src/Web.config`, dòng kết nối hiện tại:
```xml
<add name="webdientuConnectionString"
     connectionString="Server=.\SQLEXPRESS;Database=WebDienTu;Integrated Security=True"
     providerName="System.Data.SqlClient" />
```
Nếu SQL Server của bạn có tên instance khác, sửa `Server=` cho phù hợp.

### Bước 4: Mở Solution và Build
1. Mở `src/webdientu.sln` bằng Visual Studio
2. Chọn **Build > Build Solution** (Ctrl+Shift+B)
3. Chờ build thành công (0 lỗi)

### Bước 5: Chạy dự án
Nhấn **F5** trong Visual Studio. IIS Express sẽ khởi động, trình duyệt mở ra tại:
```
https://localhost:44333/
```

---

## 5. Tài khoản đăng nhập

### Tài khoản mẫu (có sẵn trong database)

| Vai trò | Username | Password | RoleID | Ghi chú |
|---|---|---|---|---|
| **Admin** | `admin` | `admin123` | 1 | Quản trị toàn quyền, đăng nhập sẽ redirect vào trang Admin |
| **Khách hàng** | `user1` | `user123` | 2 | Tài khoản khách hàng thường |

### Đăng ký tài khoản mới
- Truy cập `/NguoiDung/DangKy`
- Tài khoản mới đăng ký mặc định **RoleID = 2** (Khách hàng)

### Phân quyền

| RoleID | Vai trò | Quyền hạn |
|---|---|---|
| 1 | Admin | Quản lý toàn bộ: sản phẩm, danh mục, đơn hàng, khuyến mãi, báo cáo, backup/restore |
| 2 | Khách hàng | Xem sản phẩm, giỏ hàng, đặt hàng, lịch sử đơn, yêu thích |
| 3 | Nhân viên | Truy cập khu vực Admin (cùng quyền với Admin) |

---

## 6. Các link truy cập

> Port mặc định: `44333` (có thể khác tuỳ cấu hình Visual Studio)

### Trang khách hàng

| Trang | URL |
|---|---|
| Trang chủ | `/` |
| Danh sách sản phẩm | `/SanPham/ListSanPham` |
| Chi tiết sản phẩm | `/SanPham/Detail/{id}` |
| Danh mục | `/Loai/ListLoai` |
| Thương hiệu (Nhà cung cấp) | `/NhaCungCap/ListNhaCungCap` |
| Sản phẩm yêu thích | `/SanPham/DanhSachYeuThich` |
| Giỏ hàng | `/GioHang/GioHang` |
| Đặt hàng | `/GioHang/DatHang` |
| Chọn phương thức thanh toán | `/thanhtoan/ChonPhuongThuc` |
| Đăng nhập | `/NguoiDung/DangNhap` |
| Đăng ký | `/NguoiDung/DangKy` |
| Thông tin cá nhân | `/NguoiDung/ThongTinCaNhan` |
| Lịch sử đơn hàng | `/NguoiDung/LichSuDonHang` |

### Trang quản trị Admin (cần đăng nhập quyền Admin/Nhân viên)

| Trang | URL |
|---|---|
| Quản lý sản phẩm | `/Admin/SanPhams/ListSanPham` |
| Thêm sản phẩm | `/Admin/SanPhams/Create` |
| Quản lý đơn hàng | `/Admin/DonHangs/ListDonHang` |
| Quản lý danh mục | `/Admin/Loais/ListLoai` |
| Quản lý nhà cung cấp | `/Admin/NhaCungCaps/ListNhaCungCap` |
| Quản lý khuyến mãi | `/Admin/KhuyenMai/Index` |
| Tạo khuyến mãi | `/Admin/KhuyenMai/Create` |
| Tạo phiếu nhập hàng | `/Admin/PhieuNhap/Create` |
| Tìm kiếm toàn cục | `/Admin/Admin/Search?keyword=...` |
| Cài đặt tài khoản | `/Admin/AccountSettings/Index` |
| Backup/Restore DB | `/Admin/Backup/Index` |

### Báo cáo thống kê (Admin)

| Báo cáo | URL |
|---|---|
| Doanh thu theo ngày | `/Admin/BaoCao/DoanhThuNgay` |
| Doanh thu theo tháng | `/Admin/BaoCao/DoanhThuThang` |
| Doanh thu theo loại sản phẩm | `/Admin/BaoCao/DoanhThuLoai` |
| Nhật ký bán hàng | `/Admin/BaoCao/NhatKyBanHang` |
| Tồn kho | `/Admin/BaoCao/TonKho` |
| Sản phẩm sắp hết hàng | `/Admin/BaoCao/SanPhamHetHang` |
| Top sản phẩm bán chạy | `/Admin/BaoCao/TopSanPham` |
| Top khách hàng | `/Admin/BaoCao/TopKhachHang` |
| Công nợ | `/Admin/BaoCao/CongNo` |
| Theo dõi đơn hàng | `/Admin/BaoCao/TheoDoiDonHang` |

---

## 7. Chức năng chính

### 7.1. Khách hàng

| Chức năng | Mô tả |
|---|---|
| Đăng ký / Đăng nhập | Tạo tài khoản mới, xác thực bằng UserName + Password, quản lý session |
| Xem sản phẩm | Danh sách sản phẩm phân trang, tìm kiếm theo tên, sắp xếp theo giá tăng/giảm/mới nhất |
| Chi tiết sản phẩm | Thông tin đầy đủ: giá, mô tả, hình ảnh, sản phẩm liên quan |
| Danh mục | Lọc sản phẩm theo loại |
| Thương hiệu | Xem danh sách nhà cung cấp và chi tiết |
| Yêu thích | Thêm/bỏ sản phẩm yêu thích (yêu cầu đăng nhập) |
| Giỏ hàng | Thêm / xoá / cập nhật số lượng, xoá tất cả. Giỏ hàng lưu cả Session và Database, tự động merge khi đăng nhập |
| Mã giảm giá | Áp dụng mã khuyến mãi theo %, kiểm tra điều kiện đơn tối thiểu |
| Đặt hàng | Chọn ngày giao, ghi chú, phương thức thanh toán, địa chỉ giao hàng. Tính VAT 10% + phí vận chuyển cố định 25.000đ |
| Thanh toán VNPay | Tích hợp thanh toán trực tuyến qua VNPay |
| Lịch sử đơn hàng | Xem danh sách và chi tiết đơn hàng đã đặt |
| Hủy đơn | Hủy đơn khi trạng thái "chờ giao" |
| Trả hàng | Yêu cầu trả hàng khi trạng thái "đã giao" (tự động hoàn tồn kho) |
| Thông tin cá nhân | Cập nhật thông tin, đổi mật khẩu |

### 7.2. Quản trị viên (Admin / Nhân viên)

| Chức năng | Mô tả |
|---|---|
| Quản lý sản phẩm | Thêm / sửa / xoá sản phẩm, upload hình ảnh |
| Quản lý danh mục | CRUD loại sản phẩm |
| Quản lý nhà cung cấp | CRUD nhà cung cấp (thương hiệu) |
| Quản lý đơn hàng | Xem danh sách, cập nhật trạng thái: `chuagiao` → `dagiao` → `trahang` / `dahuy` |
| Quản lý khuyến mãi | Tạo / sửa / xoá mã giảm giá, áp dụng cho sản phẩm cụ thể, có điều kiện đơn tối thiểu |
| Phiếu nhập hàng | Tạo phiếu nhập từ nhà cung cấp, tự động cập nhật tồn kho |
| Tìm kiếm toàn cục | Tìm kiếm đồng thời sản phẩm, đơn hàng, nhà cung cấp theo từ khoá |
| Cài đặt tài khoản | Quản lý thông tin tài khoản admin |
| Backup/Restore | Sao lưu và khôi phục database qua giao diện web |
| Export Excel | Xuất báo cáo ra file Excel (ClosedXML) |

### 7.3. Báo cáo & Thống kê

| Báo cáo | Chi tiết |
|---|---|
| Doanh thu theo ngày | Tổng doanh thu, số đơn, lợi nhuận, biểu đồ theo khung giờ |
| Doanh thu theo tháng | Thống kê theo tháng, biểu đồ doanh thu theo ngày trong tháng |
| Doanh thu theo loại | Phân tích doanh thu theo từng loại sản phẩm |
| Nhật ký bán hàng | Chi tiết từng giao dịch bán, giá vốn, lợi nhuận |
| Tồn kho | Kiểm kê tồn kho hiện tại, số lượng đã bán trong 30 ngày |
| Sản phẩm sắp hết hàng | Cảnh báo sản phẩm tồn kho thấp |
| Top sản phẩm bán chạy | Xếp hạng sản phẩm theo doanh thu |
| Top khách hàng | Xếp hạng khách hàng theo giá trị đơn hàng |
| Công nợ | Theo dõi công nợ khách hàng |
| Theo dõi đơn hàng | Theo dõi trạng thái đơn hàng |

---

## 8. Các lỗi thường gặp và cách xử lý

### Lỗi 1: "Could not load type 'LTW.MvcApplication'"
**Nguyên nhân:** Chưa build project, thư mục `bin/` trống.

**Cách sửa:**
1. Mở Visual Studio → Load solution `webdientu.sln` → **Build** (Ctrl+Shift+B)
2. Chờ build thành công, chạy lại (F5)

---

### Lỗi 2: "The imported project Microsoft.WebApplication.targets was not found"
**Nguyên nhân:** MSBuild không tìm thấy Web Application targets (thường gặp khi build ngoài Visual Studio).

**Cách sửa:**
- Dùng Visual Studio để build thay vì command line
- Hoặc tìm đường dẫn MSBuild đúng: `C:\Program Files\Microsoft Visual Studio\2022\*\MSBuild\Current\Bin\MSBuild.exe`

---

### Lỗi 3: Không kết nối được database
**Nguyên nhân:** SQL Server Express không chạy hoặc instance name sai.

**Cách sửa:**
1. Kiểm tra SQL Server Express đang chạy: **Services** → `SQL Server (SQLEXPRESS)`
2. Kiểm tra connection string trong `src/Web.config`:
```xml
Server=.\SQLEXPRESS;Database=WebDienTu;Integrated Security=True
```
3. Đổi `Server=` cho đúng instance trên máy bạn

---

### Lỗi 4: Bảng không tồn tại / Schema cũ
**Nguyên nhân:** Database chưa được tạo hoặc schema cũ, thiếu bảng mới.

**Cách sửa:**
```cmd
sqlcmd -S ".\SQLEXPRESS" -i "src\App_Data\WebDienTu_Clean.sql" -E -f 65001
```
> **Cảnh báo:** Thao tác này xoá toàn bộ dữ liệu cũ và tạo lại từ đầu.

---

### Lỗi 5: Tiếng Việt bị lỗi font / hiển thị dấu `?`
**Nguyên nhân:** Collation database sai.

**Cách sửa:**
1. Re-import database bằng `WebDienTu_Clean.sql` (đã cấu hình `Vietnamese_CI_AS`)
2. Kiểm tra file `Content/base.css` có sử dụng font hỗ trợ tiếng Việt

---

### Lỗi 6: Ảnh sản phẩm không hiển thị
**Nguyên nhân:** Giá trị cột `Hinh` trong bảng `SanPham` không khớp tên file trong `Content/images/`.

**Cách sửa:**
1. Kiểm tra tên file ảnh trong `src/Content/images/`
2. Giá trị `Hinh` trong DB phải có định dạng `Content/images/tenfile.png`
3. Re-import DB nếu dùng bản `WebDienTu_Clean.sql` mới nhất

---

### Lỗi 7: "Login failed for user" khi chạy trên máy khác
**Nguyên nhân:** Connection String dùng `Integrated Security=True` (Windows Auth).

**Cách sửa:** Đổi sang SQL Server Authentication trong `src/Web.config`:
```xml
Server=.\SQLEXPRESS;Database=WebDienTu;User Id=sa;Password=your_password
```

---

### Lỗi 8: Port bị chiếm
**Nguyên nhân:** Ứng dụng khác đang dùng port 44333.

**Cách sửa:**
1. Right-click project → **Properties** → **Web** → đổi port trong mục HTTPS
2. Hoặc dừng ứng dụng đang chiếm port

---

### Lỗi 9: jQuery / Bootstrap không hoạt động
**Nguyên nhân:** CDN bị chặn hoặc thứ tự load script sai.

**Cách sửa:**
1. Mở Console trình duyệt (F12) để kiểm tra lỗi cụ thể
2. Kiểm tra thứ tự load script trong `Views/Shared/_Layout.cshtml`: jQuery phải load trước Bootstrap
3. Nếu CDN bị chặn: thay bằng file local trong `Scripts/`

---

### Lỗi 10: Đăng nhập không redirect vào Admin
**Nguyên nhân:** Tài khoản có `RoleID` khác 1 hoặc 3.

**Cách sửa:**
- Kiểm tra giá trị `RoleID` trong bảng `KhachHang` trong database
- Admin phải có `RoleID = 1`, Nhân viên `RoleID = 3`, Khách hàng `RoleID = 2`

---

## 9. Dữ liệu mẫu có sẵn trong database

### Danh mục sản phẩm (bảng `Loai`)

| MaLoai | Tên loại |
|---|---|
| 1 | Linh Kiện Điện Tử |
| 2 | Dây Cáp |
| 3 | Bộ Phận Máy Tính |

### Nhà cung cấp (bảng `NCC`)

| MaNCC | Tên NCC |
|---|---|
| 1 | Công Ty ABC |
| 2 | Công Ty XYZ |

### Sản phẩm (bảng `SanPham`)

| MaSP | Tên sản phẩm | Giá | Loại |
|---|---|---|---|
| 1 | CPU Intel Core i5 | 4.500.000đ | Bộ Phận Máy Tính |
| 2 | RAM DDR4 8GB | 850.000đ | Bộ Phận Máy Tính |
| 3 | SSD 256GB | 1.200.000đ | Bộ Phận Máy Tính |
| 4 | Dây cáp USB 3.0 | 150.000đ | Dây Cáp |
| 5 | Màn hình 24 inch | 3.500.000đ | Bộ Phận Máy Tính |
| 6 | Biến trở 10K | 5.000đ | Linh Kiện Điện Tử |
| 7 | Tụ điện 100uF | 3.000đ | Linh Kiện Điện Tử |
| 8 | Cầu chì 5A | 7.000đ | Linh Kiện Điện Tử |
| 9 | Cuộn cảm 10uH | 8.000đ | Linh Kiện Điện Tử |
| 10 | Điện trở 1K | 1.000đ | Linh Kiện Điện Tử |

### Tài khoản người dùng (bảng `KhachHang`)

| MaKH | UserName | Password | RoleID | Vai trò |
|---|---|---|---|---|
| 1 | `admin` | `admin123` | 1 | Admin |
| 2 | `user1` | `user123` | 2 | Khách hàng |

### Phương thức thanh toán (bảng `ThanhToan`)

| MaTT | Tên phương thức |
|---|---|
| 1 | Tiền mặt |
| 2 | Chuyển khoản |
| 3 | Ví điện tử (VNPay) |

### Trạng thái đơn hàng

| Giá trị `TrangThai` | Ý nghĩa |
|---|---|
| `chuagiao` | Chờ giao hàng |
| `dagiao` | Đã giao |
| `dahuy` | Đã huỷ |
| `trahang` | Trả hàng |

### Trạng thái thanh toán

| Giá trị `TrangThaiThanhToan` | Ý nghĩa |
|---|---|
| `chuathanhtoan` | Chưa thanh toán |
| `dathanhtoan` | Đã thanh toán |

---

**Đồ án Lập trình Web** — Website bán linh kiện điện tử ALMOND
