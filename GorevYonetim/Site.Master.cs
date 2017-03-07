using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace GorevYonetim
{
    public partial class SiteMaster : System.Web.UI.MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            Global.Kullanici.IsNull();  /// Eğer Kullanici Null ise get gloğunda Default.aspx sayfasına yönleniyor..       
            if (!Page.IsPostBack)
            {
                labKullanici.Text = "<b>" + Global.Kullanici.KulKodu + "&nbsp</b> <span style='color:red; font-weight:bold'> [" + Yetki.GetYetkiAciklama(Global.Kullanici.YetkiKod) + "]</span>";
            }
        }

        protected void btnCikis_Click(object sender, EventArgs e)
        {
            Global.Kullanici = null;  /// Güvenli Çıkış  
        }
    }
}
