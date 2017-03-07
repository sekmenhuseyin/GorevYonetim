using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using GorevYonetim.App_Data;
using System.Data.Linq;
using System.Web.Services;
using CustomDropDown;
using AjaxControlToolkit;
using System.IO;
using System.Drawing;

namespace GorevYonetim
{
    public partial class IzinTakvimi : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Page.IsPostBack)  /// Sayfa ilk kez yükleniyorsa
            {
                GetData();
            }
        }

        void GetData()
        {
            try
            { 
                using (GorevDataDataContext Context = new GorevDataDataContext(Global.ConStr))
                {
                    List<TatilGunleri> tatilList = Context.TatilGunleris.OrderBy(x => x.Gun).ToList();

                    gridIzinTakvimi.DataSource = tatilList;
                    gridIzinTakvimi.DataBind();
                }

                ///Bu kodla pager kısmı sürekli gözüküyor...
                if (gridIzinTakvimi != null)
                {
                    GridViewRow pagerRow = (GridViewRow)gridIzinTakvimi.BottomPagerRow;
                    if (pagerRow != null)
                    {
                        pagerRow.Visible = true;
                    }
                }
                //ScriptManager.RegisterStartupScript(this, typeof(string), "open", "ToplamKayit("+kayitAdet+");", true); 
            }
            catch (Exception hata)
            {
                MesajVer(hata: hata);
            }
        }

        /// <summary>
        /// Hafta sayısına göre bugünden başlayarak haftanın başlangıç tarihini bulur.
        /// </summary>
        List<DateTime> TarihleriBul(int HaftaSayisi=1)
        {
            List<DateTime> Tarihler = new List<DateTime>();
            int kacGunOnce = 0;
            switch(DateTime.Today.DayOfWeek)
            {
                case DayOfWeek.Monday:
                    kacGunOnce = 0;
                    break;
                case DayOfWeek.Tuesday:
                    kacGunOnce = -1;
                    break;
                case DayOfWeek.Wednesday:
                    kacGunOnce = -2;
                    break;
                case DayOfWeek.Thursday:
                    kacGunOnce = -3;
                    break;
                case DayOfWeek.Friday:
                    kacGunOnce = -4;
                    break;
                case DayOfWeek.Saturday:
                    kacGunOnce = -5;
                    break;
                case DayOfWeek.Sunday:
                    kacGunOnce = -6;
                    break;
            }

            kacGunOnce = kacGunOnce + (-7 * (HaftaSayisi - 1));

            DateTime dtBaslangic = DateTime.Today.AddDays(kacGunOnce);
            DateTime dtBitis = DateTime.Today;

            Tarihler.Add(dtBaslangic);
            Tarihler.Add(dtBitis);

            return Tarihler;
        }
   
        void InsertGorevCalisma(GorevCalisma gorCalisma)
        {
            using (DataContext Context = Global.DBContext)
            {
                Context.GetTable<GorevCalisma>().InsertOnSubmit(gorCalisma);
                Context.SubmitChanges();
            }
        }

        void UpdateGorevCalisma(GorevCalisma upGorevCalisma, int grvCalID)
        {
            using (DataContext Context = Global.DBContext)
            {
                GorevCalisma gorCalisma = Context.GetTable<GorevCalisma>().Where(x => x.ID == grvCalID).SingleOrDefault();
                gorCalisma.Sorumlular = upGorevCalisma.Sorumlular;
              
                gorCalisma.GorevID = upGorevCalisma.GorevID;
                gorCalisma.Tarih1 = upGorevCalisma.Tarih1;
                gorCalisma.Tarih2 = upGorevCalisma.Tarih2;
                gorCalisma.CalismaSure = upGorevCalisma.CalismaSure;
                gorCalisma.Calisma = upGorevCalisma.Calisma;
                Context.SubmitChanges();
            }
        }

        void DeleteGorevCalisma(int grvCalID)
        {
            using (DataContext Context = Global.DBContext)
            {
                GorevCalisma gorCalisma = Context.GetTable<GorevCalisma>().Where(x => x.ID == grvCalID).SingleOrDefault();
                Context.GetTable<GorevCalisma>().DeleteOnSubmit(gorCalisma);
                Context.SubmitChanges();
            }
        }

        protected void gridIzinTakvimi_DataBinding(object sender, EventArgs e)
        {
            
        }

        protected void gridIzinTakvimi_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            pnlHata.Visible = false;
            pnlBasarili.Visible = false;
            gridIzinTakvimi.PageIndex = e.NewPageIndex;
                 
        } 
   
        void MesajVer(Global.MesajTip mtip = Global.MesajTip.None, Exception hata = null, string Mesaj = null)
        {
            //ScriptManager.RegisterStartupScript(this, typeof(string), "open", "panelBilgiKapan();", true); 
            switch (mtip)
            {
                case Global.MesajTip.None:
                    if (hata != null)
                    {
                        pnlBasarili.Visible = false;
                        pnlHata.Visible = true;
                        lblHata.Text = "<b>Hata :</b>" + hata.Message;
                    }
                    break;
                case Global.MesajTip.Bilgi:
                    pnlBasarili.Visible = true;
                    pnlHata.Visible = false;
                    if (Mesaj == null)
                        lblBasarili.Text = "<b>Bilgi :</b> İşlem başarıyla gerçekleştirildi.";
                    else
                        lblBasarili.Text = Mesaj;
                    break;
                case Global.MesajTip.Hata:
                    pnlBasarili.Visible = false;
                    pnlHata.Visible = true;
                    lblHata.Text = "<b>Hata :</b> " + hata.Message;
                    break;
                case Global.MesajTip.Uyari:
                    pnlBasarili.Visible = false;
                    pnlHata.Visible = true;
                    lblHata.Text = "<b>Uyarı :</b> " + Mesaj;
                    break;
                default:
                    break;
            }
        }

        protected void timer1_Tick(object sender, EventArgs e)
        {
            ///Bu timer bir kereliğine çalışacak sadece Gridin Width özelliğini düzeltebilmek için kullandım.        
            timer1.Enabled = false;
            if (!Page.IsPostBack)
            {
                gridIzinTakvimi.Width = 1055;          
            }
            ScriptManager.RegisterStartupScript(this, typeof(string), "open", "GetTakvim();", true);          
        }

     

        protected void gridIzinTakvimi_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                             
            }   
        }

        protected void btnEkle_Click(object sender, EventArgs e)
        {
            try
            {
                if (hfSecilenIzinliler.Value.IsNullEmpty() || hfSecilenIzinliler.Value.ToString2().Length < 1)
                {
                    throw new Exception(" Herhangi bir izinli seçimi yapmadınız !!");
                }

                string izinli = hfSecilenIzinliler.Value.ToString2();
                izinli = izinli.Remove(izinli.Length - 1, 1);

                DateTime DT1 = txtTarih1.Text.ToDatetime();
                DateTime DT2 = txtTarih2.Text.ToDatetime();

                if (txtTarih1.Text.IsNullEmpty())
                {
                    throw new Exception(" İlk Tarih değerini boş geçemezsiniz !!");
                }

                if (txtTarih2.Text.IsNotNullEmpty())
                {
                    if (DT1 > DT2)
                    {
                        throw new Exception(" İlk Tarih Son Tarih değerinden büyük olamaz !!");
                    }

                    if ((DT2 - DT1).TotalDays > 15)
                    {
                        throw new Exception(" 15 günden fazla tarih aralığı seçemezsiniz !!");
                    }
                }
                else
                {
                    DT2 = DT1;
                }

                string aciklama = txtAciklama.Text.ToString2();


                using (GorevDataDataContext Context = new GorevDataDataContext(Global.ConStr))
                {
                    DateTime dt = DT1.Date;
                    while (dt <= DT2)
                    {
                        TatilGunleri tGun = new TatilGunleri();
                        tGun.Izinliler = izinli;
                        tGun.Gun = dt;
                        tGun.Aciklama = aciklama;
                        dt = dt.AddDays(1);
                        Context.TatilGunleris.InsertOnSubmit(tGun);
                    }
                    Context.SubmitChanges();
                }

                GetData();
                ScriptManager.RegisterStartupScript(this, typeof(string), "open", "Temizle();", true);
                MesajVer(Global.MesajTip.Bilgi);
            
            }
            catch (Exception ex)
            {
                MesajVer(hata: ex);
            }
        }

        protected void btnDelete_Click(object sender, ImageClickEventArgs e)
        {
            try
            {
                using (GorevDataDataContext Context = new GorevDataDataContext(Global.ConStr))
                {
                  
                    ImageButton lnkRemove = (ImageButton)sender;
                    int tGunID = lnkRemove.CommandArgument.ToInt32();
                    TatilGunleri tGunSil = Context.TatilGunleris.Where(x => x.ID == tGunID).FirstOrDefault();

                    if (tGunSil.IsNotNull())
                    {
                        Context.TatilGunleris.DeleteOnSubmit(tGunSil);
                        Context.SubmitChanges();
                        GetData();
                        MesajVer(Global.MesajTip.Bilgi);
                    }
                    else
                    {
                        MesajVer(Global.MesajTip.Uyari, Mesaj: "Kayıt bulunamadı !");
                    }
                   
                }
            }
            catch (Exception hata)
            {
                MesajVer(hata: hata);
            }
        }

      


    }
}