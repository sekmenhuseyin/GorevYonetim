using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.Linq;
using GorevYonetim.App_Data;

namespace GorevYonetim.Pages
{
    public partial class LockScreen : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Page.IsPostBack)
            {
                labKullanici.Text = Global.Kullanici.AdSoyad;
                ScriptManager.RegisterStartupScript(this, typeof(string), "open", "ParolaBosalt()", true);
            }
        }

        protected void btnGiris_Click(object sender, EventArgs e)
        {
            try
            {
                using (DataContext Context = Global.DBContext)
                {
                    Kullanici Kul = Context.GetTable<Kullanici>().Where(x => x.KulKodu == Global.Kullanici.KulKodu && x.Pass == txtSifre.Text.Trim()).SingleOrDefault();

                    if (Kul.IsNotNull())
                    {
                        Global.Kullanici = Kul;
                        //Response.Redirect("../Main.aspx");
                        Response.Redirect("../Gorev.aspx");
                    }
                    else
                    {
                       
                    }
                }
            }
            catch (Exception hata)
            {
                hata.HataYaz();
            }
        }
    }
}