using System.Web;
using System.Web.Mvc;
using LTW.Models;

namespace LTW.Areas.Admin
{
    public class AdminAuthorizeAttribute : AuthorizeAttribute
    {
        protected override bool AuthorizeCore(HttpContextBase httpContext)
        {
            var user = (KhachHang)httpContext.Session["TaiKhoan"];
            // Cho phép truy cập nếu là Admin (1) hoặc Nhân viên (3)
            return user != null && (user.RoleID == 1 || user.RoleID == 3);
        }

        protected override void HandleUnauthorizedRequest(AuthorizationContext filterContext)
        {
            filterContext.Result = new RedirectResult("/NguoiDung/DangNhap");
        }
    }
}
