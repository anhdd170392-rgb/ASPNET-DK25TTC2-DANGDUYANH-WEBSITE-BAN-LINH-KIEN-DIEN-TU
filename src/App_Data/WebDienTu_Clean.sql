-- ============================================================
-- Database: WebDienTu
-- Ngay tao: 2025-09-04
-- ============================================================

USE [master]
GO

IF EXISTS (SELECT name FROM sys.databases WHERE name = N'WebDienTu')
BEGIN
    ALTER DATABASE [WebDienTu] SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE [WebDienTu];
END
GO

CREATE DATABASE [WebDienTu]
COLLATE Vietnamese_CI_AS
GO

USE [WebDienTu]
GO

-- ============================================================
-- TABLE: Role
-- ============================================================
CREATE TABLE [dbo].[Role] (
    [RoleID] [int] IDENTITY(1,1) NOT NULL,
    [RoleName] [nvarchar](20) NULL,
    CONSTRAINT [PK_Role] PRIMARY KEY CLUSTERED ([RoleID] ASC)
)
GO

-- ============================================================
-- TABLE: Loai
-- ============================================================
CREATE TABLE [dbo].[Loai] (
    [MaLoai] [int] IDENTITY(1,1) NOT NULL,
    [TenLoai] [nvarchar](100) NOT NULL,
    [Hinh] [nvarchar](100) NOT NULL,
    CONSTRAINT [PK_Loai] PRIMARY KEY CLUSTERED ([MaLoai] ASC)
)
GO

-- ============================================================
-- TABLE: NCC (Nha Cung Cap)
-- ============================================================
CREATE TABLE [dbo].[NCC] (
    [MaNCC] [int] IDENTITY(1,1) NOT NULL,
    [TenNCC] [nvarchar](50) NOT NULL,
    [Email] [nvarchar](50) NOT NULL,
    [SDT] [varchar](11) NOT NULL,
    [Diachi] [nvarchar](50) NOT NULL,
    CONSTRAINT [PK_NCC] PRIMARY KEY CLUSTERED ([MaNCC] ASC)
)
GO

-- ============================================================
-- TABLE: KhachHang
-- ============================================================
CREATE TABLE [dbo].[KhachHang] (
    [MaKH] [int] IDENTITY(1,1) NOT NULL,
    [UserName] [varchar](20) NOT NULL,
    [Password] [varchar](20) NOT NULL,
    [TenKhachHang] [nvarchar](100) NOT NULL,
    [Email] [nvarchar](100) NOT NULL,
    [SDT] [varchar](11) NOT NULL,
    [DiaChi] [nvarchar](100) NOT NULL,
    [RoleID] [int] NOT NULL,
    CONSTRAINT [PK_KhachHang] PRIMARY KEY CLUSTERED ([MaKH] ASC),
    CONSTRAINT [FK_KhachHang_Role] FOREIGN KEY ([RoleID]) REFERENCES [dbo].[Role] ([RoleID])
)
GO

-- ============================================================
-- TABLE: ThanhToan
-- ============================================================
CREATE TABLE [dbo].[ThanhToan] (
    [MaTT] [int] IDENTITY(1,1) NOT NULL,
    [TenTT] [nvarchar](50) NOT NULL,
    CONSTRAINT [PK_ThanhToan] PRIMARY KEY CLUSTERED ([MaTT] ASC)
)
GO

-- ============================================================
-- TABLE: SanPham
-- ============================================================
CREATE TABLE [dbo].[SanPham] (
    [MaSP] [int] IDENTITY(1,1) NOT NULL,
    [TenSP] [nvarchar](200) NOT NULL,
    [Hinh] [nvarchar](100) NULL,
    [GiaSP] [int] NOT NULL,
    [GiaVon] [int] NOT NULL,
    [SoLuongTon] [int] NOT NULL,
    [MoTa] [nvarchar](1000) NULL,
    [MaLoai] [int] NOT NULL,
    [MaNCC] [int] NOT NULL,
    [TrangThai] [bit] NULL DEFAULT (1),
    CONSTRAINT [PK_SanPham] PRIMARY KEY CLUSTERED ([MaSP] ASC),
    CONSTRAINT [FK_SanPham_Loai] FOREIGN KEY ([MaLoai]) REFERENCES [dbo].[Loai] ([MaLoai]),
    CONSTRAINT [FK_SanPham_NCC] FOREIGN KEY ([MaNCC]) REFERENCES [dbo].[NCC] ([MaNCC]),
    CONSTRAINT [CK_SanPham_GiaSP] CHECK ([GiaSP]>(0)),
    CONSTRAINT [CK_SanPham_GiaVon] CHECK ([GiaVon]>(0)),
    CONSTRAINT [CK_SanPham_SoLuongTon] CHECK ([SoLuongTon]>=(0))
)
GO

-- ============================================================
-- TABLE: KhuyenMai
-- ============================================================
CREATE TABLE [dbo].[KhuyenMai] (
    [MaKM] [int] IDENTITY(1,1) NOT NULL,
    [TenKM] [nvarchar](200) NOT NULL,
    [MoTa] [nvarchar](500) NULL,
    [NgayBatDau] [datetime] NOT NULL,
    [NgayKetThuc] [datetime] NOT NULL,
    [PhanTramGiam] [float] NOT NULL,
    [DieuKienApDung] [decimal](10,2) NULL,
    [TrangThai] [bit] NULL DEFAULT (1),
    CONSTRAINT [PK_KhuyenMai] PRIMARY KEY CLUSTERED ([MaKM] ASC),
    CONSTRAINT [CK_KhuyenMai_PhanTramGiam] CHECK ([PhanTramGiam]>(0) AND [PhanTramGiam]<=(100))
)
GO

-- ============================================================
-- TABLE: SanPham_KhuyenMai
-- ============================================================
CREATE TABLE [dbo].[SanPham_KhuyenMai] (
    [MaSP] [int] NOT NULL,
    [MaKM] [int] NOT NULL,
    [NgayApDung] [datetime] NULL DEFAULT (getdate()),
    CONSTRAINT [PK_SanPham_KhuyenMai] PRIMARY KEY CLUSTERED ([MaSP] ASC, [MaKM] ASC),
    CONSTRAINT [FK_SPKM_SanPham] FOREIGN KEY ([MaSP]) REFERENCES [dbo].[SanPham] ([MaSP]),
    CONSTRAINT [FK_SPKM_KhuyenMai] FOREIGN KEY ([MaKM]) REFERENCES [dbo].[KhuyenMai] ([MaKM])
)
GO

-- ============================================================
-- TABLE: LichSuGia
-- ============================================================
CREATE TABLE [dbo].[LichSuGia] (
    [MaLSG] [int] IDENTITY(1,1) NOT NULL,
    [MaSP] [int] NOT NULL,
    [GiaCu] [decimal](10,2) NOT NULL,
    [GiaMoi] [decimal](10,2) NOT NULL,
    [NgayCapNhat] [datetime] NULL DEFAULT (getdate()),
    [GhiChu] [nvarchar](200) NULL,
    CONSTRAINT [PK_LichSuGia] PRIMARY KEY CLUSTERED ([MaLSG] ASC),
    CONSTRAINT [FK_LichSuGia_SanPham] FOREIGN KEY ([MaSP]) REFERENCES [dbo].[SanPham] ([MaSP])
)
GO

-- ============================================================
-- TABLE: DonHang
-- ============================================================
CREATE TABLE [dbo].[DonHang] (
    [MaDH] [int] IDENTITY(1,1) NOT NULL,
    [NgayDatHang] [datetime] NOT NULL DEFAULT (getdate()),
    [NgayGiaoHangDuKien] [datetime] NOT NULL DEFAULT (getdate()),
    [TongTienDonHang] [decimal](10,2) NOT NULL,
    [TrangThai] [varchar](20) NOT NULL DEFAULT ('chuagiao'),
    [MaKH] [int] NOT NULL,
    [MaTT] [int] NOT NULL,
    [NgayTao] [datetime] NULL DEFAULT (getdate()),
    [GhiChu] [nvarchar](max) NULL,
    [ChietKhau] [decimal](18,2) NULL,
    [PhiVanChuyen] [decimal](18,2) NULL,
    [DiaChiGiao] [nvarchar](255) NULL,
    [ThueVAT] [decimal](5,2) NULL DEFAULT (0),
    [TienThueVAT] [decimal](18,2) NULL DEFAULT (0),
    [ThanhTienTruocVAT] [decimal](18,2) NULL DEFAULT (0),
    [ThanhTienSauVAT] [decimal](18,2) NULL DEFAULT (0),
    [DaThanhToan] [decimal](18,2) NULL DEFAULT (0),
    [TrangThaiThanhToan] [varchar](20) NULL DEFAULT ('chuathanhtoan'),
    CONSTRAINT [PK_DonHang] PRIMARY KEY CLUSTERED ([MaDH] ASC, [MaTT] ASC),
    CONSTRAINT [FK_DonHang_KhachHang] FOREIGN KEY ([MaKH]) REFERENCES [dbo].[KhachHang] ([MaKH]),
    CONSTRAINT [FK_DonHang_ThanhToan] FOREIGN KEY ([MaTT]) REFERENCES [dbo].[ThanhToan] ([MaTT]),
    CONSTRAINT [CK_DonHang_TrangThaiTT] CHECK ([TrangThaiThanhToan]='chuathanhtoan' OR [TrangThaiThanhToan]='dathanhtoan'),
    CONSTRAINT [CK_DonHang_TrangThai] CHECK ([TrangThai]='trahang' OR [TrangThai]='dahuy' OR [TrangThai]='chuagiao' OR [TrangThai]='dagiao')
)
GO

-- ============================================================
-- TABLE: ChiTietDonHang
-- ============================================================
CREATE TABLE [dbo].[ChiTietDonHang] (
    [MaCTDH] [int] IDENTITY(1,1) NOT NULL,
    [MaDH] [int] NOT NULL,
    [MaTT] [int] NOT NULL,
    [MaSP] [int] NOT NULL,
    [SoLuongMua] [int] NOT NULL,
    [TongTien] [decimal](10,2) NULL,
    CONSTRAINT [PK_ChiTietDonHang] PRIMARY KEY CLUSTERED ([MaCTDH] ASC, [MaDH] ASC, [MaTT] ASC, [MaSP] ASC),
    CONSTRAINT [FK_CTDH_DonHang] FOREIGN KEY ([MaDH], [MaTT]) REFERENCES [dbo].[DonHang] ([MaDH], [MaTT]),
    CONSTRAINT [FK_CTDH_SanPham] FOREIGN KEY ([MaSP]) REFERENCES [dbo].[SanPham] ([MaSP])
)
GO

-- ============================================================
-- TABLE: NhatKyBanHang
-- ============================================================
CREATE TABLE [dbo].[NhatKyBanHang] (
    [MaNK] [int] IDENTITY(1,1) NOT NULL,
    [NgayGiaoDich] [datetime] NULL DEFAULT (getdate()),
    [MaDH] [int] NOT NULL,
    [MaTT] [int] NOT NULL,
    [MaSP] [int] NOT NULL,
    [SoLuong] [int] NOT NULL,
    [DonGia] [decimal](10,2) NOT NULL,
    [ThanhTien] [decimal](10,2) NOT NULL,
    [TrangThai] [nvarchar](50) NULL,
    CONSTRAINT [PK_NhatKyBanHang] PRIMARY KEY CLUSTERED ([MaNK] ASC),
    CONSTRAINT [FK_NKBH_DonHang] FOREIGN KEY ([MaDH], [MaTT]) REFERENCES [dbo].[DonHang] ([MaDH], [MaTT]),
    CONSTRAINT [FK_NKBH_SanPham] FOREIGN KEY ([MaSP]) REFERENCES [dbo].[SanPham] ([MaSP])
)
GO

-- ============================================================
-- TABLE: PhieuNhap
-- ============================================================
CREATE TABLE [dbo].[PhieuNhap] (
    [MaPN] [int] IDENTITY(1,1) NOT NULL,
    [NgayNhap] [datetime] NULL DEFAULT (getdate()),
    [MaNCC] [int] NOT NULL,
    [TongTien] [decimal](10,2) NOT NULL,
    [GhiChu] [nvarchar](500) NULL,
    [NguoiNhap] [int] NOT NULL,
    [TrangThai] [nvarchar](50) NULL DEFAULT (N'Đang nhập'),
    CONSTRAINT [PK_PhieuNhap] PRIMARY KEY CLUSTERED ([MaPN] ASC),
    CONSTRAINT [FK_PhieuNhap_NCC] FOREIGN KEY ([MaNCC]) REFERENCES [dbo].[NCC] ([MaNCC]),
    CONSTRAINT [FK_PhieuNhap_NguoiNhap] FOREIGN KEY ([NguoiNhap]) REFERENCES [dbo].[KhachHang] ([MaKH])
)
GO

-- ============================================================
-- TABLE: ChiTietPhieuNhap
-- ============================================================
CREATE TABLE [dbo].[ChiTietPhieuNhap] (
    [MaCTPN] [int] IDENTITY(1,1) NOT NULL,
    [MaPN] [int] NOT NULL,
    [MaSP] [int] NOT NULL,
    [SoLuong] [int] NOT NULL,
    [DonGia] [decimal](10,2) NOT NULL,
    [ThanhTien] [decimal](10,2) NOT NULL,
    CONSTRAINT [PK_ChiTietPhieuNhap] PRIMARY KEY CLUSTERED ([MaCTPN] ASC),
    CONSTRAINT [FK_CTPN_PhieuNhap] FOREIGN KEY ([MaPN]) REFERENCES [dbo].[PhieuNhap] ([MaPN]),
    CONSTRAINT [FK_CTPN_SanPham] FOREIGN KEY ([MaSP]) REFERENCES [dbo].[SanPham] ([MaSP]),
    CONSTRAINT [CK_ChiTietPhieuNhap_SoLuong] CHECK ([SoLuong]>(0))
)
GO

-- ============================================================
-- TABLE: PhieuXuat
-- ============================================================
CREATE TABLE [dbo].[PhieuXuat] (
    [MaPX] [int] IDENTITY(1,1) NOT NULL,
    [NgayXuat] [datetime] NULL DEFAULT (getdate()),
    [LyDo] [nvarchar](200) NULL,
    [TongTien] [decimal](10,2) NOT NULL,
    [GhiChu] [nvarchar](500) NULL,
    [NguoiXuat] [int] NOT NULL,
    CONSTRAINT [PK_PhieuXuat] PRIMARY KEY CLUSTERED ([MaPX] ASC),
    CONSTRAINT [FK_PhieuXuat_NguoiXuat] FOREIGN KEY ([NguoiXuat]) REFERENCES [dbo].[KhachHang] ([MaKH])
)
GO

-- ============================================================
-- TABLE: ChiTietPhieuXuat
-- ============================================================
CREATE TABLE [dbo].[ChiTietPhieuXuat] (
    [MaCTPX] [int] IDENTITY(1,1) NOT NULL,
    [MaPX] [int] NOT NULL,
    [MaSP] [int] NOT NULL,
    [SoLuong] [int] NOT NULL,
    [DonGia] [decimal](10,2) NOT NULL,
    [ThanhTien] [decimal](10,2) NOT NULL,
    CONSTRAINT [PK_ChiTietPhieuXuat] PRIMARY KEY CLUSTERED ([MaCTPX] ASC),
    CONSTRAINT [FK_CTPX_PhieuXuat] FOREIGN KEY ([MaPX]) REFERENCES [dbo].[PhieuXuat] ([MaPX]),
    CONSTRAINT [FK_CTPX_SanPham] FOREIGN KEY ([MaSP]) REFERENCES [dbo].[SanPham] ([MaSP]),
    CONSTRAINT [CK_ChiTietPhieuXuat_SoLuong] CHECK ([SoLuong]>(0))
)
GO

-- ============================================================
-- TABLE: GioHang
-- ============================================================
CREATE TABLE [dbo].[GioHang] (
    [MaGioHang] [int] IDENTITY(1,1) NOT NULL,
    [MaKH] [int] NOT NULL,
    [NgayTao] [datetime] NULL DEFAULT (getdate()),
    [NgayCapNhat] [datetime] NULL DEFAULT (getdate()),
    [TongTien] [decimal](10,2) NULL DEFAULT (0),
    [TrangThai] [bit] NULL DEFAULT (1),
    CONSTRAINT [PK_GioHang] PRIMARY KEY CLUSTERED ([MaGioHang] ASC),
    CONSTRAINT [FK_GioHang_KhachHang] FOREIGN KEY ([MaKH]) REFERENCES [dbo].[KhachHang] ([MaKH])
)
GO

-- ============================================================
-- TABLE: ChiTietGioHang
-- ============================================================
CREATE TABLE [dbo].[ChiTietGioHang] (
    [MaCTGH] [int] IDENTITY(1,1) NOT NULL,
    [MaGioHang] [int] NOT NULL,
    [MaSP] [int] NOT NULL,
    [SoLuong] [int] NOT NULL,
    [DonGia] [decimal](10,2) NOT NULL,
    [ThanhTien] [decimal](10,2) NOT NULL,
    [NgayThem] [datetime] NULL DEFAULT (getdate()),
    CONSTRAINT [PK_ChiTietGioHang] PRIMARY KEY CLUSTERED ([MaCTGH] ASC),
    CONSTRAINT [FK_CTGH_GioHang] FOREIGN KEY ([MaGioHang]) REFERENCES [dbo].[GioHang] ([MaGioHang]),
    CONSTRAINT [FK_CTGH_SanPham] FOREIGN KEY ([MaSP]) REFERENCES [dbo].[SanPham] ([MaSP]),
    CONSTRAINT [CK_ChiTietGioHang_SoLuong] CHECK ([SoLuong]>(0))
)
GO

-- ============================================================
-- TABLE: CongNo
-- ============================================================
CREATE TABLE [dbo].[CongNo] (
    [MaCN] [int] IDENTITY(1,1) NOT NULL,
    [MaKH] [int] NOT NULL,
    [NgayPhatSinh] [datetime] NULL DEFAULT (getdate()),
    [SoTienNo] [decimal](15,2) NOT NULL DEFAULT (0),
    [DaThanhToan] [decimal](15,2) NOT NULL DEFAULT (0),
    [ConLai] [decimal](15,2) NOT NULL DEFAULT (0),
    [HanThanhToan] [date] NULL,
    [TrangThai] [nvarchar](50) NULL,
    CONSTRAINT [PK_CongNo] PRIMARY KEY CLUSTERED ([MaCN] ASC),
    CONSTRAINT [FK_CongNo_KhachHang] FOREIGN KEY ([MaKH]) REFERENCES [dbo].[KhachHang] ([MaKH])
)
GO

-- ============================================================
-- TABLE: ChiTietCongNo
-- ============================================================
CREATE TABLE [dbo].[ChiTietCongNo] (
    [MaCTCN] [int] IDENTITY(1,1) NOT NULL,
    [MaCN] [int] NOT NULL,
    [MaDH] [int] NULL,
    [MaTT] [int] NULL,
    [NgayPhatSinh] [datetime] NULL DEFAULT (getdate()),
    [SoTien] [decimal](15,2) NOT NULL,
    [LoaiPhatSinh] [nvarchar](50) NULL,
    [GhiChu] [nvarchar](500) NULL,
    CONSTRAINT [PK_ChiTietCongNo] PRIMARY KEY CLUSTERED ([MaCTCN] ASC),
    CONSTRAINT [FK_CTCN_CongNo] FOREIGN KEY ([MaCN]) REFERENCES [dbo].[CongNo] ([MaCN])
)
GO

-- ============================================================
-- TABLE: YeuThich
-- ============================================================
CREATE TABLE [dbo].[YeuThich] (
    [MaKH] [int] NOT NULL,
    [MaSP] [int] NOT NULL,
    [NgayThem] [datetime] NULL DEFAULT (getdate()),
    CONSTRAINT [PK_YeuThich] PRIMARY KEY CLUSTERED ([MaKH] ASC, [MaSP] ASC),
    CONSTRAINT [FK_YeuThich_KhachHang] FOREIGN KEY ([MaKH]) REFERENCES [dbo].[KhachHang] ([MaKH]),
    CONSTRAINT [FK_YeuThich_SanPham] FOREIGN KEY ([MaSP]) REFERENCES [dbo].[SanPham] ([MaSP])
)
GO

-- ============================================================
-- TABLE: DoanhThu
-- ============================================================
CREATE TABLE [dbo].[DoanhThu] (
    [MaDT] [int] IDENTITY(1,1) NOT NULL,
    [NgayBaoCao] [date] NOT NULL,
    [SoDonHang] [int] NOT NULL DEFAULT (0),
    [TongDoanhThu] [decimal](15,2) NOT NULL DEFAULT (0),
    [TongChiPhi] [decimal](15,2) NOT NULL DEFAULT (0),
    [LoiNhuan] [decimal](15,2) NOT NULL DEFAULT (0),
    [GhiChu] [nvarchar](500) NULL,
    CONSTRAINT [PK_DoanhThu] PRIMARY KEY CLUSTERED ([MaDT] ASC)
)
GO

-- ============================================================
-- TABLE: BaoCao
-- ============================================================
CREATE TABLE [dbo].[BaoCao] (
    [MaBaoCao] [int] IDENTITY(1,1) NOT NULL,
    [LoaiBaoCao] [nvarchar](50) NULL,
    [ThoiGianBatDau] [date] NULL,
    [ThoiGianKetThuc] [date] NULL,
    [NgayLap] [datetime] NULL DEFAULT (getdate()),
    [NguoiLap] [int] NULL,
    [TongDoanhThu] [decimal](15,2) NULL,
    [TongChiPhi] [decimal](15,2) NULL,
    [LoiNhuan] [decimal](15,2) NULL,
    [GhiChu] [nvarchar](500) NULL,
    CONSTRAINT [PK_BaoCao] PRIMARY KEY CLUSTERED ([MaBaoCao] ASC),
    CONSTRAINT [FK_BaoCao_NguoiLap] FOREIGN KEY ([NguoiLap]) REFERENCES [dbo].[KhachHang] ([MaKH]),
    CONSTRAINT [CK_BaoCao_LoaiBaoCao] CHECK ([LoaiBaoCao]='BaoCaoKetQuaKinhDoanh' OR [LoaiBaoCao]='BangCanDoiKeToan' OR [LoaiBaoCao]='BaoCaoLuuChuyenTienTe')
)
GO

-- ============================================================
-- TABLE: BaoCaoTonKho
-- ============================================================
CREATE TABLE [dbo].[BaoCaoTonKho] (
    [MaBCTK] [int] IDENTITY(1,1) NOT NULL,
    [NgayBaoCao] [date] NOT NULL,
    [MaSP] [int] NOT NULL,
    [TonDau] [int] NOT NULL DEFAULT (0),
    [NhapTrongKy] [int] NOT NULL DEFAULT (0),
    [XuatTrongKy] [int] NOT NULL DEFAULT (0),
    [TonCuoi] [int] NOT NULL DEFAULT (0),
    [GiaTriTonKho] [decimal](15,2) NOT NULL DEFAULT (0),
    CONSTRAINT [PK_BaoCaoTonKho] PRIMARY KEY CLUSTERED ([MaBCTK] ASC),
    CONSTRAINT [FK_BCTK_SanPham] FOREIGN KEY ([MaSP]) REFERENCES [dbo].[SanPham] ([MaSP])
)
GO

-- ============================================================
-- TABLE: Backup_History
-- ============================================================
CREATE TABLE [dbo].[Backup_History] (
    [BackupID] [int] IDENTITY(1,1) NOT NULL,
    [BackupName] [nvarchar](100) NOT NULL,
    [BackupDate] [datetime] NULL DEFAULT (getdate()),
    [BackupPath] [nvarchar](500) NOT NULL,
    [Description] [nvarchar](500) NULL,
    CONSTRAINT [PK_Backup_History] PRIMARY KEY CLUSTERED ([BackupID] ASC)
)
GO

-- ============================================================
-- VIEWS
-- ============================================================

-- View: v_NhatKyBanHang
CREATE VIEW [dbo].[v_NhatKyBanHang]
AS
SELECT
    nk.MaNK,
    nk.NgayGiaoDich,
    nk.MaDH,
    sp.TenSP,
    nk.SoLuong,
    nk.DonGia,
    nk.ThanhTien,
    dh.TrangThai,
    tt.TenTT AS ThanhToan,
    sp.GiaVon,
    sp.GiaSP,
    (nk.ThanhTien - (sp.GiaVon * nk.SoLuong)) AS LoiNhuan
FROM NhatKyBanHang nk
JOIN SanPham sp ON nk.MaSP = sp.MaSP
JOIN DonHang dh ON nk.MaDH = dh.MaDH
JOIN ThanhToan tt ON nk.MaTT = tt.MaTT
GO

-- View: v_ThongKeKhachHang
CREATE VIEW [dbo].[v_ThongKeKhachHang]
AS
SELECT
    kh.MaKH,
    kh.TenKhachHang,
    kh.Email,
    kh.SDT,
    COUNT(dh.MaDH) AS SoDonHang,
    SUM(dh.TongTienDonHang) AS TongGiaTri,
    MAX(dh.NgayDatHang) AS MuaGanNhat
FROM KhachHang kh
LEFT JOIN DonHang dh ON kh.MaKH = dh.MaKH AND dh.TrangThai = 'dagiao'
GROUP BY kh.MaKH, kh.TenKhachHang, kh.Email, kh.SDT
GO

-- View: v_ThongKeSanPham
CREATE VIEW [dbo].[v_ThongKeSanPham]
AS
SELECT
    sp.MaSP,
    sp.TenSP,
    sp.Hinh,
    l.TenLoai AS LoaiSP,
    ncc.TenNCC AS NhaCungCap,
    COUNT(DISTINCT ctdh.MaDH) AS SoDonHang,
    SUM(ctdh.SoLuongMua) AS SoLuongBan,
    SUM(ctdh.TongTien) AS DoanhThu,
    sp.GiaVon,
    SUM(ctdh.TongTien - (ctdh.SoLuongMua * sp.GiaVon)) AS LoiNhuan,
    MAX(dh.NgayDatHang) AS BanGanNhat
FROM SanPham sp
LEFT JOIN ChiTietDonHang ctdh ON sp.MaSP = ctdh.MaSP
LEFT JOIN DonHang dh ON ctdh.MaDH = dh.MaDH AND dh.TrangThai = 'dagiao'
JOIN Loai l ON sp.MaLoai = l.MaLoai
JOIN NCC ncc ON sp.MaNCC = ncc.MaNCC
GROUP BY sp.MaSP, sp.TenSP, sp.Hinh, l.TenLoai, ncc.TenNCC, sp.GiaVon
GO

-- View: v_TonKho
CREATE VIEW [dbo].[v_TonKho]
AS
SELECT
    sp.MaSP,
    sp.TenSP,
    l.TenLoai AS LoaiSP,
    ncc.TenNCC AS NhaCungCap,
    sp.SoLuongTon,
    sp.GiaVon,
    ISNULL((
        SELECT SUM(ctdh.SoLuongMua)
        FROM ChiTietDonHang ctdh
        JOIN DonHang dh ON ctdh.MaDH = dh.MaDH
        WHERE ctdh.MaSP = sp.MaSP AND dh.TrangThai = 'dagiao'
        AND dh.NgayDatHang >= DATEADD(DAY, -30, GETDATE())
    ), 0) AS DaBan30Ngay,
    ISNULL((
        SELECT SUM(ctpn.SoLuong)
        FROM ChiTietPhieuNhap ctpn
        JOIN PhieuNhap pn ON ctpn.MaPN = pn.MaPN
        WHERE ctpn.MaSP = sp.MaSP
        AND (pn.TrangThai = N'Đang nhập' OR pn.TrangThai IS NULL)
    ), 0) AS DangDatHang
FROM SanPham sp
JOIN Loai l ON sp.MaLoai = l.MaLoai
JOIN NCC ncc ON sp.MaNCC = ncc.MaNCC
GO

-- View: v_DoanhThuSanPham
CREATE VIEW [dbo].[v_DoanhThuSanPham]
AS
SELECT
    sp.MaSP,
    sp.TenSP,
    COUNT(DISTINCT nk.MaDH) AS SoDonHang,
    SUM(nk.SoLuong) AS TongSoLuongBan,
    SUM(nk.ThanhTien) AS TongDoanhThu
FROM SanPham sp
LEFT JOIN NhatKyBanHang nk ON sp.MaSP = nk.MaSP
GROUP BY sp.MaSP, sp.TenSP
GO

-- View: v_CongNoKhachHang
CREATE VIEW [dbo].[v_CongNoKhachHang]
AS
SELECT
    kh.MaKH,
    kh.TenKhachHang,
    SUM(cn.SoTienNo) AS TongNo,
    SUM(cn.DaThanhToan) AS TongDaThanhToan,
    SUM(cn.ConLai) AS TongConLai
FROM KhachHang kh
LEFT JOIN CongNo cn ON kh.MaKH = cn.MaKH
GROUP BY kh.MaKH, kh.TenKhachHang
GO

-- View: v_DoanhThuTheoGio
CREATE VIEW [dbo].[v_DoanhThuTheoGio]
AS
SELECT
    DATEPART(HOUR, dh.NgayDatHang) AS Gio,
    COUNT(DISTINCT dh.MaDH) AS SoDonHang,
    SUM(dh.TongTienDonHang) AS DoanhThu,
    COUNT(DISTINCT dh.MaKH) AS SoKhachHang
FROM DonHang dh
WHERE dh.TrangThai = 'dagiao'
GROUP BY DATEPART(HOUR, dh.NgayDatHang)
GO

-- View: v_DoanhThuTheoThang
CREATE VIEW [dbo].[v_DoanhThuTheoThang]
AS
SELECT
    DATEPART(MONTH, dh.NgayDatHang) AS Thang,
    DATEPART(YEAR, dh.NgayDatHang) AS Nam,
    COUNT(DISTINCT dh.MaDH) AS SoDonHang,
    SUM(dh.TongTienDonHang) AS TongDoanhThu,
    COUNT(DISTINCT dh.MaKH) AS SoKhachHang,
    SUM(dh.TongTienDonHang) / NULLIF(COUNT(DISTINCT dh.MaDH), 0) AS TrungBinhDonHang,
    SUM(ct.SoLuongMua * sp.GiaVon) AS TongChiPhi
FROM DonHang dh
JOIN ChiTietDonHang ct ON dh.MaDH = ct.MaDH
JOIN SanPham sp ON ct.MaSP = sp.MaSP
WHERE dh.TrangThai = 'dagiao'
GROUP BY DATEPART(MONTH, dh.NgayDatHang), DATEPART(YEAR, dh.NgayDatHang)
GO

-- View: v_DoanhThuTheoLoai
CREATE VIEW [dbo].[v_DoanhThuTheoLoai]
AS
SELECT
    l.MaLoai,
    l.TenLoai,
    COUNT(DISTINCT dh.MaDH) AS SoDonHang,
    SUM(ctdh.SoLuongMua) AS SoLuongBan,
    SUM(ctdh.TongTien) AS DoanhThu,
    SUM(ctdh.SoLuongMua * sp.GiaVon) AS TongChiPhi
FROM DonHang dh
JOIN ChiTietDonHang ctdh ON dh.MaDH = ctdh.MaDH
JOIN SanPham sp ON ctdh.MaSP = sp.MaSP
JOIN Loai l ON sp.MaLoai = l.MaLoai
WHERE dh.TrangThai = 'dagiao'
GROUP BY l.MaLoai, l.TenLoai
GO

-- ============================================================
-- STORED PROCEDURES
-- ============================================================

-- SP: sp_BaoCaoCongNo
CREATE PROCEDURE [dbo].[sp_BaoCaoCongNo]
    @MaKH INT = NULL,
    @TrangThai NVARCHAR(50) = NULL
AS
BEGIN
    SELECT
        cn.MaCN,
        kh.TenKhachHang,
        cn.NgayPhatSinh,
        cn.SoTienNo,
        cn.DaThanhToan,
        cn.ConLai,
        cn.TrangThai
    FROM CongNo cn
    JOIN KhachHang kh ON cn.MaKH = kh.MaKH
    WHERE (@MaKH IS NULL OR cn.MaKH = @MaKH)
    AND (@TrangThai IS NULL OR cn.TrangThai = @TrangThai)
END
GO

-- SP: sp_BaoCaoDoanhThu
CREATE PROCEDURE [dbo].[sp_BaoCaoDoanhThu]
    @TuNgay DATE,
    @DenNgay DATE
AS
BEGIN
    SELECT
        NgayBaoCao,
        SoDonHang,
        TongDoanhThu,
        TongChiPhi,
        LoiNhuan
    FROM DoanhThu
    WHERE NgayBaoCao BETWEEN @TuNgay AND @DenNgay
    ORDER BY NgayBaoCao DESC
END
GO

-- SP: sp_BaoCaoDoanhThuNgay
CREATE PROCEDURE [dbo].[sp_BaoCaoDoanhThuNgay]
    @NgayBaoCao DATE
AS
BEGIN
    -- Thong ke tong quan
    SELECT
        COUNT(DISTINCT dh.MaDH) AS SoDonHang,
        SUM(dh.TongTienDonHang) AS DoanhThu,
        COUNT(DISTINCT dh.MaKH) AS SoKhachHang,
        CASE
            WHEN COUNT(DISTINCT dh.MaDH) > 0
            THEN SUM(dh.TongTienDonHang) / COUNT(DISTINCT dh.MaDH)
            ELSE 0
        END AS TrungBinhDonHang
    FROM DonHang dh
    WHERE CONVERT(DATE, dh.NgayDatHang) = @NgayBaoCao
    AND dh.TrangThai = 'dagiao';

    -- Thong ke theo gio
    SELECT
        DATEPART(HOUR, dh.NgayDatHang) AS Gio,
        SUM(dh.TongTienDonHang) AS DoanhThu
    FROM DonHang dh
    WHERE CONVERT(DATE, dh.NgayDatHang) = @NgayBaoCao
    AND dh.TrangThai = 'dagiao'
    GROUP BY DATEPART(HOUR, dh.NgayDatHang)
    ORDER BY Gio;
END
GO

-- SP: sp_BaoCaoDoanhThuThang
CREATE PROCEDURE [dbo].[sp_BaoCaoDoanhThuThang]
    @Thang INT,
    @Nam INT
AS
BEGIN
    -- Thong ke tong quan
    SELECT
        COUNT(DISTINCT dh.MaDH) AS SoDonHang,
        SUM(dh.TongTienDonHang) AS TongDoanhThu,
        COUNT(DISTINCT dh.MaKH) AS SoKhachHang,
        SUM(ct.SoLuongMua * sp.GiaVon) AS TongChiPhi,
        SUM(dh.TongTienDonHang) - SUM(ct.SoLuongMua * sp.GiaVon) AS LoiNhuan
    FROM DonHang dh
    JOIN ChiTietDonHang ct ON dh.MaDH = ct.MaDH
    JOIN SanPham sp ON ct.MaSP = sp.MaSP
    WHERE MONTH(dh.NgayDatHang) = @Thang
    AND YEAR(dh.NgayDatHang) = @Nam
    AND dh.TrangThai = 'dagiao';

    -- Thong ke theo ngay trong thang
    SELECT
        DAY(dh.NgayDatHang) AS Ngay,
        COUNT(DISTINCT dh.MaDH) AS SoDonHang,
        SUM(dh.TongTienDonHang) AS DoanhThu
    FROM DonHang dh
    WHERE MONTH(dh.NgayDatHang) = @Thang
    AND YEAR(dh.NgayDatHang) = @Nam
    AND dh.TrangThai = 'dagiao'
    GROUP BY DAY(dh.NgayDatHang)
    ORDER BY Ngay;
END
GO

-- SP: sp_BaoCaoDoanhThuTheoLoai
CREATE PROCEDURE [dbo].[sp_BaoCaoDoanhThuTheoLoai]
    @TuNgay DATE,
    @DenNgay DATE
AS
BEGIN
    SELECT
        l.MaLoai,
        l.TenLoai AS LoaiSP,
        COUNT(DISTINCT dh.MaDH) AS SoDonHang,
        SUM(ctdh.SoLuongMua) AS SoLuongBan,
        SUM(ctdh.TongTien) AS DoanhThu,
        SUM(ctdh.SoLuongMua * sp.GiaVon) AS TongChiPhi
    FROM DonHang dh
    JOIN ChiTietDonHang ctdh ON dh.MaDH = ctdh.MaDH
    JOIN SanPham sp ON ctdh.MaSP = sp.MaSP
    JOIN Loai l ON sp.MaLoai = l.MaLoai
    WHERE dh.TrangThai = 'dagiao'
    AND dh.NgayDatHang BETWEEN @TuNgay AND @DenNgay
    GROUP BY l.MaLoai, l.TenLoai
    ORDER BY DoanhThu DESC;
END
GO

-- SP: sp_BaoCaoNhatKyBanHang
CREATE PROCEDURE [dbo].[sp_BaoCaoNhatKyBanHang]
    @TuNgay DATE,
    @DenNgay DATE,
    @TrangThai NVARCHAR(50) = NULL
AS
BEGIN
    -- Thong ke tong quan
    SELECT
        COUNT(DISTINCT MaDH) AS SoDonHang,
        SUM(ThanhTien) AS DoanhThu,
        SUM(SoLuong) AS SoSanPham,
        SUM(ThanhTien - (DonGia / 2 * SoLuong)) AS LoiNhuan
    FROM v_NhatKyBanHang
    WHERE NgayGiaoDich BETWEEN @TuNgay AND @DenNgay
    AND (@TrangThai IS NULL OR TrangThai = @TrangThai);

    -- Chi tiet nhat ky
    SELECT *
    FROM v_NhatKyBanHang
    WHERE NgayGiaoDich BETWEEN @TuNgay AND @DenNgay
    AND (@TrangThai IS NULL OR TrangThai = @TrangThai)
    ORDER BY NgayGiaoDich DESC;

    -- Thong ke theo ngay
    SELECT
        CAST(NgayGiaoDich AS DATE) AS Ngay,
        COUNT(DISTINCT MaDH) AS SoDonHang,
        SUM(ThanhTien) AS DoanhThu,
        SUM(SoLuong) AS SoSanPham
    FROM v_NhatKyBanHang
    WHERE NgayGiaoDich BETWEEN @TuNgay AND @DenNgay
    AND (@TrangThai IS NULL OR TrangThai = @TrangThai)
    GROUP BY CAST(NgayGiaoDich AS DATE)
    ORDER BY Ngay;
END
GO

-- SP: sp_BaoCaoSanPhamSapHet
CREATE PROCEDURE [dbo].[sp_BaoCaoSanPhamSapHet]
    @MucTonToiThieu INT = 10
AS
BEGIN
    -- Thong ke tong quan
    SELECT
        COUNT(CASE WHEN SoLuongTon = 0 THEN 1 END) AS HetHang,
        COUNT(CASE WHEN SoLuongTon BETWEEN 1 AND @MucTonToiThieu THEN 1 END) AS SapHet,
        COUNT(CASE WHEN DangDatHang > 0 THEN 1 END) AS DaDatHang,
        SUM(CASE
            WHEN DaBan30Ngay > 0 THEN CEILING(DaBan30Ngay * 1.5) - SoLuongTon
            ELSE @MucTonToiThieu - SoLuongTon
        END * GiaVon) AS GiaTriCanNhap
    FROM v_TonKho
    WHERE SoLuongTon <= @MucTonToiThieu;

    -- Chi tiet san pham sap het
    SELECT
        MaSP,
        TenSP,
        LoaiSP,
        NhaCungCap,
        SoLuongTon,
        DaBan30Ngay,
        GiaVon,
        CASE
            WHEN DaBan30Ngay > 0 THEN CEILING(DaBan30Ngay * 1.5) - SoLuongTon
            ELSE @MucTonToiThieu - SoLuongTon
        END AS SoLuongCanNhap,
        CASE
            WHEN SoLuongTon = 0 THEN N'Het hang'
            ELSE N'Sap het'
        END AS TrangThai,
        DangDatHang
    FROM v_TonKho
    WHERE SoLuongTon <= @MucTonToiThieu
    ORDER BY SoLuongTon;

    -- Thong ke theo loai
    SELECT
        LoaiSP,
        COUNT(*) AS SoLuong
    FROM v_TonKho
    WHERE SoLuongTon <= @MucTonToiThieu
    GROUP BY LoaiSP
    ORDER BY SoLuong DESC;
END
GO

-- SP: sp_BaoCaoTonKhoSanPham
CREATE PROCEDURE [dbo].[sp_BaoCaoTonKhoSanPham]
    @MaSP INT = NULL
AS
BEGIN
    SELECT
        sp.MaSP,
        sp.TenSP,
        sp.SoLuongTon,
        ISNULL(bctk.NhapTrongKy, 0) AS NhapTrongKy,
        ISNULL(bctk.XuatTrongKy, 0) AS XuatTrongKy
    FROM SanPham sp
    LEFT JOIN BaoCaoTonKho bctk ON sp.MaSP = bctk.MaSP
    WHERE (@MaSP IS NULL OR sp.MaSP = @MaSP)
END
GO

-- SP: sp_BaoCaoTopKhachHang
CREATE PROCEDURE [dbo].[sp_BaoCaoTopKhachHang]
    @TuNgay DATE,
    @DenNgay DATE,
    @Top INT = 10
AS
BEGIN
    WITH KhachHangTrongKy AS (
        SELECT
            kh.MaKH,
            kh.TenKhachHang,
            kh.Email,
            kh.SDT,
            COUNT(dh.MaDH) AS SoDonHang,
            SUM(dh.TongTienDonHang) AS TongGiaTri,
            MAX(dh.NgayDatHang) AS MuaGanNhat
        FROM KhachHang kh
        LEFT JOIN DonHang dh ON kh.MaKH = dh.MaKH
            AND dh.TrangThai = 'dagiao'
            AND dh.NgayDatHang BETWEEN @TuNgay AND @DenNgay
        GROUP BY kh.MaKH, kh.TenKhachHang, kh.Email, kh.SDT
    )
    SELECT TOP (@Top)
        *,
        CASE
            WHEN SUM(TongGiaTri) OVER() > 0
            THEN (TongGiaTri * 100.0 / SUM(TongGiaTri) OVER())
            ELSE 0
        END AS TyTrong
    FROM KhachHangTrongKy
    WHERE TongGiaTri > 0
    ORDER BY TongGiaTri DESC;

    -- Thong ke theo ngay
    SELECT
        CAST(dh.NgayDatHang AS DATE) AS Ngay,
        COUNT(DISTINCT dh.MaDH) AS SoDonHang,
        SUM(dh.TongTienDonHang) AS DoanhThu
    FROM DonHang dh
    WHERE dh.TrangThai = 'dagiao'
    AND dh.NgayDatHang BETWEEN @TuNgay AND @DenNgay
    GROUP BY CAST(dh.NgayDatHang AS DATE)
    ORDER BY Ngay;
END
GO

-- SP: sp_BaoCaoTopSanPham
CREATE PROCEDURE [dbo].[sp_BaoCaoTopSanPham]
    @TuNgay DATE,
    @DenNgay DATE,
    @Top INT = 10,
    @TrangThai NVARCHAR(50) = NULL
AS
BEGIN
    WITH SanPhamTrongKy AS (
        SELECT
            sp.MaSP,
            sp.TenSP,
            sp.Hinh,
            l.TenLoai AS LoaiSP,
            COUNT(DISTINCT ctdh.MaDH) AS SoDonHang,
            SUM(ctdh.SoLuongMua) AS SoLuongBan,
            SUM(ctdh.TongTien) AS DoanhThu
        FROM SanPham sp
        LEFT JOIN ChiTietDonHang ctdh ON sp.MaSP = ctdh.MaSP
        LEFT JOIN DonHang dh ON ctdh.MaDH = dh.MaDH
            AND dh.NgayDatHang BETWEEN @TuNgay AND @DenNgay
            AND (@TrangThai IS NULL OR dh.TrangThai = @TrangThai)
        JOIN Loai l ON sp.MaLoai = l.MaLoai
        GROUP BY sp.MaSP, sp.TenSP, sp.Hinh, l.TenLoai
    )
    SELECT TOP (@Top)
        *,
        CASE
            WHEN SUM(DoanhThu) OVER() > 0
            THEN (DoanhThu * 100.0 / SUM(DoanhThu) OVER())
            ELSE 0
        END AS TyTrong
    FROM SanPhamTrongKy
    WHERE DoanhThu > 0
    ORDER BY DoanhThu DESC;
END
GO

-- SP: sp_XuLyCongNo_HuyDonHang
CREATE PROCEDURE [dbo].[sp_XuLyCongNo_HuyDonHang]
    @MaDH INT,
    @MaTT INT
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION

        -- Cap nhat trang thai cong no
        UPDATE cn
        SET TrangThai = N'Đã hủy',
            ConLai = 0
        FROM CongNo cn
        JOIN ChiTietCongNo ct ON cn.MaCN = ct.MaCN
        WHERE ct.MaDH = @MaDH AND ct.MaTT = @MaTT;

        -- Them chi tiet cong no cho viec huy
        INSERT INTO ChiTietCongNo (MaCN, MaDH, MaTT, NgayPhatSinh, SoTien, LoaiPhatSinh, GhiChu)
        SELECT
            cn.MaCN,
            @MaDH,
            @MaTT,
            GETDATE(),
            0,
            N'Hủy đơn hàng',
            N'Hủy đơn hàng ' + CAST(@MaDH AS NVARCHAR(10))
        FROM CongNo cn
        JOIN ChiTietCongNo ct ON cn.MaCN = ct.MaCN
        WHERE ct.MaDH = @MaDH AND ct.MaTT = @MaTT;

        COMMIT TRANSACTION
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION
        THROW;
    END CATCH
END
GO

-- ============================================================
-- INSERT DATA MAU
-- ============================================================

-- Role
SET IDENTITY_INSERT [dbo].[Role] ON;
INSERT INTO [dbo].[Role] ([RoleID], [RoleName]) VALUES (1, N'Admin');
INSERT INTO [dbo].[Role] ([RoleID], [RoleName]) VALUES (2, N'KhachHang');
SET IDENTITY_INSERT [dbo].[Role] OFF;

-- Loai
SET IDENTITY_INSERT [dbo].[Loai] ON;
INSERT INTO [dbo].[Loai] ([MaLoai], [TenLoai], [Hinh]) VALUES (1, N'Linh Kiện Điện Tử', N'Content/images/CamBien&module.png');
INSERT INTO [dbo].[Loai] ([MaLoai], [TenLoai], [Hinh]) VALUES (2, N'Dây Cáp', N'Content/images/bien-ap.jpg');
INSERT INTO [dbo].[Loai] ([MaLoai], [TenLoai], [Hinh]) VALUES (3, N'Bộ Phận Máy Tính', N'Content/images/logoA.png');
SET IDENTITY_INSERT [dbo].[Loai] OFF;

-- NCC
SET IDENTITY_INSERT [dbo].[NCC] ON;
INSERT INTO [dbo].[NCC] ([MaNCC], [TenNCC], [Email], [SDT], [Diachi]) VALUES (1, N'Công Ty ABC', N'abc@gmail.com', '0909123456', N'TP.HCM');
INSERT INTO [dbo].[NCC] ([MaNCC], [TenNCC], [Email], [SDT], [Diachi]) VALUES (2, N'Công Ty XYZ', N'xyz@gmail.com', '0909987654', N'Hà Nội');
SET IDENTITY_INSERT [dbo].[NCC] OFF;

-- KhachHang
SET IDENTITY_INSERT [dbo].[KhachHang] ON;
INSERT INTO [dbo].[KhachHang] ([MaKH], [UserName], [Password], [TenKhachHang], [Email], [SDT], [DiaChi], [RoleID])
VALUES (1, N'admin', N'admin123', N'Quản Trị', N'admin@web.com', '0909123456', N'TP.HCM', 1);
INSERT INTO [dbo].[KhachHang] ([MaKH], [UserName], [Password], [TenKhachHang], [Email], [SDT], [DiaChi], [RoleID])
VALUES (2, N'user1', N'user123', N'Nguyễn Văn A', N'nguyen@gmail.com', '0912345678', N'Bình Dương', 2);
SET IDENTITY_INSERT [dbo].[KhachHang] OFF;

-- ThanhToan
SET IDENTITY_INSERT [dbo].[ThanhToan] ON;
INSERT INTO [dbo].[ThanhToan] ([MaTT], [TenTT]) VALUES (1, N'Tiền mặt');
INSERT INTO [dbo].[ThanhToan] ([MaTT], [TenTT]) VALUES (2, N'Chuyển khoản');
INSERT INTO [dbo].[ThanhToan] ([MaTT], [TenTT]) VALUES (3, N'Ví điện tử');
SET IDENTITY_INSERT [dbo].[ThanhToan] OFF;

-- SanPham
SET IDENTITY_INSERT [dbo].[SanPham] ON;
INSERT INTO [dbo].[SanPham] ([MaSP], [TenSP], [Hinh], [GiaSP], [GiaVon], [SoLuongTon], [MoTa], [MaLoai], [MaNCC], [TrangThai])
VALUES (1, N'CPU Intel Core i5', N'Content/images/CamBien&module.png', 4500000, 3800000, 20, N'Bộ xử lý Intel Core i5 thế hệ 12', 1, 1, 1);
INSERT INTO [dbo].[SanPham] ([MaSP], [TenSP], [Hinh], [GiaSP], [GiaVon], [SoLuongTon], [MoTa], [MaLoai], [MaNCC], [TrangThai])
VALUES (2, N'RAM DDR4 8GB', N'Content/images/dientro.png', 850000, 650000, 50, N'RAM DDR4 8GB Bus 3200MHz', 1, 1, 1);
INSERT INTO [dbo].[SanPham] ([MaSP], [TenSP], [Hinh], [GiaSP], [GiaVon], [SoLuongTon], [MoTa], [MaLoai], [MaNCC], [TrangThai])
VALUES (3, N'SSD 256GB', N'Content/images/tu-dien.png', 1200000, 900000, 35, N'Ổ SSD 256GB SATA III', 1, 2, 1);
INSERT INTO [dbo].[SanPham] ([MaSP], [TenSP], [Hinh], [GiaSP], [GiaVon], [SoLuongTon], [MoTa], [MaLoai], [MaNCC], [TrangThai])
VALUES (4, N'Dây cáp USB 3.0', N'Content/images/bien-ap.jpg', 150000, 80000, 100, N'Dây cáp USB 3.0 dài 1m', 2, 1, 2);
INSERT INTO [dbo].[SanPham] ([MaSP], [TenSP], [Hinh], [GiaSP], [GiaVon], [SoLuongTon], [MoTa], [MaLoai], [MaNCC], [TrangThai])
VALUES (5, N'Màn hình 24 inch', N'Content/images/logoA.png', 3500000, 2800000, 15, N'Màn hình LED 24 inch Full HD', 3, 2, 1);
INSERT INTO [dbo].[SanPham] ([MaSP], [TenSP], [Hinh], [GiaSP], [GiaVon], [SoLuongTon], [MoTa], [MaLoai], [MaNCC], [TrangThai])
VALUES (6, N'Biến trở 10K', N'Content/images/bien-tro1.png', 5000, 2000, 200, N'Biến trở 10K ohm', 1, 1, 1);
INSERT INTO [dbo].[SanPham] ([MaSP], [TenSP], [Hinh], [GiaSP], [GiaVon], [SoLuongTon], [MoTa], [MaLoai], [MaNCC], [TrangThai])
VALUES (7, N'Tụ điện 100uF', N'Content/images/tu_dien1.png', 3000, 1000, 300, N'Tụ điện phân cực 100uF 25V', 1, 2, 1);
INSERT INTO [dbo].[SanPham] ([MaSP], [TenSP], [Hinh], [GiaSP], [GiaVon], [SoLuongTon], [MoTa], [MaLoai], [MaNCC], [TrangThai])
VALUES (8, N'Cầu chì 5A', N'Content/images/cau-chi.jpg', 7000, 3000, 150, N'Cầu chì thuỷ tinh 5A', 1, 1, 1);
INSERT INTO [dbo].[SanPham] ([MaSP], [TenSP], [Hinh], [GiaSP], [GiaVon], [SoLuongTon], [MoTa], [MaLoai], [MaNCC], [TrangThai])
VALUES (9, N'Cuộn cảm 10uH', N'Content/images/cuon-cam.jpg', 8000, 4000, 120, N'Cuộn cảm 10uH', 1, 2, 1);
INSERT INTO [dbo].[SanPham] ([MaSP], [TenSP], [Hinh], [GiaSP], [GiaVon], [SoLuongTon], [MoTa], [MaLoai], [MaNCC], [TrangThai])
VALUES (10, N'Điện trở 1K', N'Content/images/dien-tro1.png', 1000, 300, 500, N'Điện trở 1K ohm 1/4W', 1, 1, 1);
SET IDENTITY_INSERT [dbo].[SanPham] OFF;

-- KhuyenMai
SET IDENTITY_INSERT [dbo].[KhuyenMai] ON;
INSERT INTO [dbo].[KhuyenMai] ([MaKM], [TenKM], [MoTa], [NgayBatDau], [NgayKetThuc], [PhanTramGiam], [DieuKienApDung], [TrangThai])
VALUES (1, N'Khuyen Mai Thang 9', N'Giam gia 10% cho tat ca san pham', '2025-09-01', '2025-09-30', 10, 500000, 1);
SET IDENTITY_INSERT [dbo].[KhuyenMai] OFF;

USE [master]
GO
ALTER DATABASE [WebDienTu] SET READ_WRITE
GO
