using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.Linq;
using GorevYonetim.App_Data;

namespace GorevYonetim
{
    public partial class Default : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Page.IsPostBack)
            {
               
            }
        }

      
        protected void btnGiris_Click(object sender, EventArgs e)
        {
            try
            {
                using (DataContext Context = Global.DBContext)
                {
                    Kullanici Kul = Context.GetTable<Kullanici>().Where(x => x.KulKodu == txtKullaniciAdi.Text.Trim() && x.Pass == txtSifre.Text.Trim()).SingleOrDefault();

                    if (Kul.IsNotNull())
                    {
                        Session["GorevFiltre"] = null;
                        Session["CalismaFiltre"] = null;
                        Global.Kullanici = Kul;           
                        Response.Redirect("../Gorev.aspx");
                    }
                    else
                    {
                        lblHata.Text = "Kullanıcı bulunamadı...";
                    }
                }
            }
            catch(Exception hata)
            {
                hata.HataYaz();
                lblHata.Text = hata.Message;
              
            }
           
        }
    }
}
