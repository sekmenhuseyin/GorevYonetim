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
    public partial class Calismalar : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Page.IsPostBack)  /// Sayfa ilk kez yükleniyorsa
            {
                GetData();
              
            }
        }

        void GetData(int editIndex=-1,bool FirmaSorumluGetir=true, bool FilterRowIcin=false, bool ExportExcel=false)
        {
            try
            {
                int kayitAdet = 0;
              
                using (GorevDataDataContext Context = new GorevDataDataContext(Global.ConStr))
                {

                    CalismaFiltre Filtre = new CalismaFiltre();
                    Kullanici Kul = Global.Kullanici;
                    hfYetkiKodu.Value = Kul.YetkiKod.ToString2();
                    bool TumSorumlular = false;

                    if (Kul.YetkiKod > 0)
                    {
                        TumSorumlular = true;
                    }

                    #region Firma Sorumlu DropDownList Set Blok
                    if (FirmaSorumluGetir)
                    {
                        List<FirmaMin> MusteriList = (from musteri in Context.Musteris
                                                      where musteri.FID == 0
                                                      orderby musteri.Firma ascending
                                                      select new FirmaMin { ID = musteri.ID, Firma = musteri.Firma }).ToList();

                        ///Popup Dürbün İçin
                        ddlDFirma.DataSource = MusteriList;
                        ddlDFirma.DataTextField = "Firma";
                        ddlDFirma.DataValueField = "Firma";
                        ddlDFirma.DataBind();
                        ddlDFirma.Items.Insert(0, new ListItem("Tümü (*)", "*"));

                        ///Filter Row İçin
                        ddlfilterFirma.DataSource = MusteriList;
                        ddlfilterFirma.DataTextField = "Firma";
                        ddlfilterFirma.DataValueField = "Firma";
                        ddlfilterFirma.DataBind();
                        ddlfilterFirma.Items.Insert(0, new ListItem("Tümü", "*"));
                  

                        IQueryable<Kullanici> listSorumlu = (from sorumlu in Context.Kullanicis
                                                             where sorumlu.YetkiKod!=1
                                                             select sorumlu);
                        ///Popup Dürbün İçin
                        ddlDSorumlu.DataSource = listSorumlu;
                        ddlDSorumlu.DataTextField = "AdSoyad";
                        ddlDSorumlu.DataValueField = "KulKodu";
                        ddlDSorumlu.DataBind();
                        ddlDSorumlu.Items.Insert(0, new ListItem("Tümü (*)", "*"));

                        ddlDKaydeden.DataSource = listSorumlu;
                        ddlDKaydeden.DataTextField = "AdSoyad";
                        ddlDKaydeden.DataValueField = "KulKodu";
                        ddlDKaydeden.DataBind();
                        ddlDKaydeden.Items.Insert(0, new ListItem("Tümü (*)", "*"));

                        ///Filter Row İçin
                        ddlfilterSorumlu.DataSource = listSorumlu;
                        ddlfilterSorumlu.DataTextField = "KulKodu";
                        ddlfilterSorumlu.DataValueField = "KulKodu";
                        ddlfilterSorumlu.DataBind();
                        ddlfilterSorumlu.Items.Insert(0, new ListItem("Tümü", "*"));

                        ddlfilterKaydeden.DataSource = listSorumlu;
                        ddlfilterKaydeden.DataTextField = "KulKodu";
                        ddlfilterKaydeden.DataValueField = "KulKodu";
                        ddlfilterKaydeden.DataBind();
                        ddlfilterKaydeden.Items.Insert(0, new ListItem("Tümü", "*"));

                    }
                    #endregion Firma Sorumlu DropDownList Set Blok SON

                    if (Session["CalismaFiltre"].IsNull())
                    {
                        ///List<DateTime> Tarihler = TarihleriBul(2);
                        if (Kul.YetkiKod < 3)
                        {
                            ddlDKaydeden.Items.FindByValue(Kul.KulKodu.IsNullEmptySetValue("*")).Selected = true;
                           
                            ///Çalışmalarda dünü ve bugünü görebilecek şekilde tarihler ayarlanıyor..
                            txtDCalismaTarih1.Text = DateTime.Now.AddDays(-3).ToShortDateString();
                            txtDCalismaTarih2.Text = DateTime.Now.ToShortDateString();               
                        }

                    }

                    if (Page.IsPostBack || Session["CalismaFiltre"].IsNull())
                    {
                        Filtre.Kaydeden = ddlDKaydeden.SelectedValue.Trim2('*');
                        Filtre.Sorumlu = ddlDSorumlu.SelectedValue.Trim2('*');
                        Filtre.Firma = ddlDFirma.SelectedValue.Trim2('*');
                        Filtre.Proje = ddlDProje.SelectedValue.Trim2('*');
                        Filtre.Form = ddlDForm.SelectedValue.Trim2('*');
                        Filtre.Gorev = txtDGorev.Text.Trim2();
                        Filtre.CalismaTarihi1 = txtDCalismaTarih1.Text.ToDatetimeNull();
                        Filtre.CalismaTarihi2 = txtDCalismaTarih2.Text.ToDatetimeNull();
                        Filtre.KayitTarihi1 = txtDKayitTarih1.Text.ToDatetimeNull();
                        Filtre.KayitTarihi2 = txtDKayitTarih2.Text.ToDatetimeNull();

                        Session["CalismaFiltre"] = Filtre;
                    }
                    ///Sayfaya girilmiş sonra başka bir sayfadan tekrar bu sayfaya gelinmişse filtre korunur.
                    else if (Session["CalismaFiltre"].IsNotNull()) 
                    {
                        Filtre = (CalismaFiltre)Session["CalismaFiltre"];
                        ddlDKaydeden.Items.FindByValue(Filtre.Kaydeden.IsNullEmptySetValue("*")).Selected = true;
                        ddlDSorumlu.Items.FindByValue(Filtre.Sorumlu.IsNullEmptySetValue("*")).Selected = true;
                        ddlDFirma.Items.FindByValue(Filtre.Firma.IsNullEmptySetValue("*")).Selected = true;
                        
                        if (Filtre.KayitTarihi1 != null)
                            txtDKayitTarih1.Text = Filtre.KayitTarihi1.Value.ToShortDateString();
                        if (Filtre.KayitTarihi2 != null)
                            txtDKayitTarih2.Text = Filtre.KayitTarihi2.Value.ToShortDateString();

                        if (Filtre.CalismaTarihi1 != null)
                            txtDCalismaTarih1.Text = Filtre.CalismaTarihi1.Value.ToShortDateString();
                        if (Filtre.CalismaTarihi2 != null)
                            txtDCalismaTarih2.Text = Filtre.CalismaTarihi2.Value.ToShortDateString();
                        
                        txtDGorev.Text = Filtre.Gorev.ToString2();
                    }

                    DateTime? sonKayitTarih1 = null;
                    DateTime? sonKayitTarih2 = null;

                    if (Filtre.KayitTarihi1.IsNotNullEmpty() && Filtre.KayitTarihi2.IsNotNullEmpty())
                    {
                        sonKayitTarih1 = new DateTime(Filtre.KayitTarihi1.Value.Year, Filtre.KayitTarihi1.Value.Month, Filtre.KayitTarihi1.Value.Day, 0, 0, 0);
                        sonKayitTarih2 = new DateTime(Filtre.KayitTarihi2.Value.Year, Filtre.KayitTarihi2.Value.Month, Filtre.KayitTarihi2.Value.Day, 23, 59, 59);
                    }
                    else if (Filtre.KayitTarihi1.IsNotNullEmpty())
                    {
                        sonKayitTarih1 = new DateTime(Filtre.KayitTarihi1.Value.Year, Filtre.KayitTarihi1.Value.Month, Filtre.KayitTarihi1.Value.Day, 0, 0, 0);
                        sonKayitTarih2 = new DateTime(Filtre.KayitTarihi1.Value.Year, Filtre.KayitTarihi1.Value.Month, Filtre.KayitTarihi1.Value.Day, 23, 59, 59);
                    }
                    else if (Filtre.KayitTarihi2.IsNotNullEmpty())
                    {
                        sonKayitTarih1 = new DateTime(Filtre.KayitTarihi2.Value.Year, Filtre.KayitTarihi2.Value.Month, Filtre.KayitTarihi2.Value.Day, 0, 0, 0);
                        sonKayitTarih2 = new DateTime(Filtre.KayitTarihi2.Value.Year, Filtre.KayitTarihi2.Value.Month, Filtre.KayitTarihi2.Value.Day, 23, 59, 59);
                    }

                    DateTime? sonCalismaTarih1 = null;
                    DateTime? sonCalismaTarih2 = null;

                    if (Filtre.CalismaTarihi1.IsNotNullEmpty() && Filtre.CalismaTarihi2.IsNotNullEmpty())
                    {
                        sonCalismaTarih1 = new DateTime(Filtre.CalismaTarihi1.Value.Year, Filtre.CalismaTarihi1.Value.Month, Filtre.CalismaTarihi1.Value.Day, 0, 0, 0);
                        sonCalismaTarih2 = new DateTime(Filtre.CalismaTarihi2.Value.Year, Filtre.CalismaTarihi2.Value.Month, Filtre.CalismaTarihi2.Value.Day, 23, 59, 59);
                    }
                    else if (Filtre.CalismaTarihi1.IsNotNullEmpty())
                    {
                        sonCalismaTarih1 = new DateTime(Filtre.CalismaTarihi1.Value.Year, Filtre.CalismaTarihi1.Value.Month, Filtre.CalismaTarihi1.Value.Day, 0, 0, 0);
                        sonCalismaTarih2 = new DateTime(Filtre.CalismaTarihi1.Value.Year, Filtre.CalismaTarihi1.Value.Month, Filtre.CalismaTarihi1.Value.Day, 23, 59, 59);
                    }
                    else if (Filtre.CalismaTarihi2.IsNotNullEmpty())
                    {
                        sonCalismaTarih1 = new DateTime(Filtre.CalismaTarihi2.Value.Year, Filtre.CalismaTarihi2.Value.Month, Filtre.CalismaTarihi2.Value.Day, 0, 0, 0);
                        sonCalismaTarih2 = new DateTime(Filtre.CalismaTarihi2.Value.Year, Filtre.CalismaTarihi2.Value.Month, Filtre.CalismaTarihi2.Value.Day, 23, 59, 59);
                    }

                    IQueryable<GorevCalismaEx> Query;

                    if (FilterRowIcin)
                    {
                        if (chkTumKayitlarda.Checked)
                        {
                            Query = (from calisma in Context.GorevCalismas
                                     join gorevs in Context.Gorevlers on calisma.GorevID equals gorevs.ID
                                     where (TumSorumlular ? true : calisma.Kaydeden == Kul.KulKodu)
                                     && (ddlfilterKaydeden.SelectedValue.Trim2('*').IsNullEmpty() ? true : calisma.Kaydeden == ddlfilterKaydeden.SelectedValue)
                                     && (ddlfilterSorumlu.SelectedValue.Trim2('*').IsNullEmpty() ? true : calisma.Sorumlular.Contains(ddlfilterSorumlu.SelectedValue))
                                     && (ddlfilterFirma.SelectedValue.Trim2('*').IsNullEmpty() ? true : gorevs.Firma == ddlfilterFirma.SelectedValue)
                                     && (ddlfilterProje.SelectedValue.Trim2('*').IsNullEmpty() ? true : gorevs.Proje == ddlfilterProje.SelectedValue)
                                     && (ddlfilterForm.SelectedValue.Trim2('*').IsNullEmpty() ? true : gorevs.Form == ddlfilterForm.SelectedValue)
                                     && (txtfilterGorev.Text.IsNullEmpty() ? true : gorevs.Gorev.Contains(txtfilterGorev.Text.Trim2()))
                                     && (txtfilterTarih1.Text.IsNullEmpty() ? true : calisma.Tarih1 >= txtfilterTarih1.Text.ToDatetime(0) && calisma.Tarih1 < txtfilterTarih1.Text.ToDatetime(0).AddDays(1))
                                     && (txtCalismaSure.Text.IsNullEmpty() ? true : calisma.CalismaSure == txtCalismaSure.Text.ToInt32())
                                     orderby calisma.Tarih1 ascending
                                     select new GorevCalismaEx
                                     {
                                         ID = calisma.ID,
                                         Firma = gorevs.Firma,
                                         Proje = gorevs.Proje,
                                         Form = gorevs.Form,
                                         Gorev = gorevs.Gorev,
                                         Aciklama = gorevs.Aciklama,
                                         Kaydeden = calisma.Kaydeden,
                                         Sorumlular = calisma.Sorumlular,
                                         Tarih1 = calisma.Tarih1,
                                         Tarih2 = calisma.Tarih2,
                                         CalismaSure = calisma.CalismaSure,
                                         Calisma = calisma.Calisma,
                                         Durum = calisma.Durum,
                                     });
                        }
                        else
                        {
                            Query = (from calisma in Context.GorevCalismas
                                     join gorevs in Context.Gorevlers on calisma.GorevID equals gorevs.ID
                                     where (TumSorumlular ? true : calisma.Kaydeden == Kul.KulKodu)
                                     && (ddlfilterKaydeden.SelectedValue.Trim2('*').IsNullEmpty() ? true : calisma.Kaydeden == ddlfilterKaydeden.SelectedValue)
                                     && (ddlfilterSorumlu.SelectedValue.Trim2('*').IsNullEmpty() ? true : calisma.Sorumlular.Contains(ddlfilterSorumlu.SelectedValue))
                                     && (ddlfilterFirma.SelectedValue.Trim2('*').IsNullEmpty() ? true : gorevs.Firma == ddlfilterFirma.SelectedValue)
                                     && (ddlfilterProje.SelectedValue.Trim2('*').IsNullEmpty() ? true : gorevs.Proje == ddlfilterProje.SelectedValue)
                                     && (ddlfilterForm.SelectedValue.Trim2('*').IsNullEmpty() ? true : gorevs.Form == ddlfilterForm.SelectedValue)
                                     && (txtfilterGorev.Text.IsNullEmpty() ? true : gorevs.Gorev.Contains(txtfilterGorev.Text.Trim2()))
                                     && (txtfilterTarih1.Text.IsNullEmpty() ? true : calisma.Tarih1 >= txtfilterTarih1.Text.ToDatetime(0) && calisma.Tarih1 < txtfilterTarih1.Text.ToDatetime(0).AddDays(1))
                                     && (txtCalismaSure.Text.IsNullEmpty() ? true : calisma.CalismaSure == txtCalismaSure.Text.ToInt32())
                                     && (calisma.Tarih1>=DateTime.Today.AddDays(-30))
                                     orderby calisma.Tarih1 ascending
                                     select new GorevCalismaEx
                                     {
                                         ID = calisma.ID,
                                         Firma = gorevs.Firma,
                                         Proje = gorevs.Proje,
                                         Form = gorevs.Form,
                                         Gorev = gorevs.Gorev,
                                         Aciklama = gorevs.Aciklama,
                                         Kaydeden = calisma.Kaydeden,
                                         Sorumlular = calisma.Sorumlular,
                                         Tarih1 = calisma.Tarih1,
                                         Tarih2 = calisma.Tarih2,
                                         CalismaSure = calisma.CalismaSure,
                                         Calisma = calisma.Calisma,
                                         Durum = calisma.Durum,
                                     });
                        }
                    }
                    else   ///Popup Dürbün İçin
                    {
                        if (chkTumKayitlarda.Checked)
                        {
                            Query = (from calisma in Context.GorevCalismas
                                     join gorevs in Context.Gorevlers on calisma.GorevID equals gorevs.ID
                                     where (TumSorumlular ? true : calisma.Kaydeden == Kul.KulKodu)
                                     && (Filtre.Kaydeden.IsNullEmpty() ? true : calisma.Kaydeden == Filtre.Kaydeden)
                                     && (Filtre.Sorumlu.IsNullEmpty() ? true : calisma.Sorumlular.Contains(Filtre.Sorumlu))
                                     && (Filtre.Firma.IsNullEmpty() ? true : gorevs.Firma == Filtre.Firma)
                                     && (Filtre.Proje.IsNullEmpty() ? true : gorevs.Proje == Filtre.Proje)
                                     && (Filtre.Form.IsNullEmpty() ? true : gorevs.Form == Filtre.Form)
                                     && (Filtre.Gorev.IsNullEmpty() ? true : gorevs.Gorev.Contains(Filtre.Gorev))
                                     && (sonCalismaTarih1.IsNullEmpty() ? true : calisma.Tarih1 >= sonCalismaTarih1)
                                     && (sonCalismaTarih2.IsNullEmpty() ? true : calisma.Tarih1 <= sonCalismaTarih2)
                                     && (sonKayitTarih1.IsNullEmpty() ? true : calisma.KayitTarih >= sonKayitTarih1)
                                     && (sonKayitTarih2.IsNullEmpty() ? true : calisma.KayitTarih <= sonKayitTarih2)
                                     orderby calisma.Tarih1 ascending
                                     select new GorevCalismaEx
                                     {
                                         ID = calisma.ID,
                                         Firma = gorevs.Firma,
                                         Proje = gorevs.Proje,
                                         Form = gorevs.Form,
                                         Gorev = gorevs.Gorev,
                                         Aciklama = gorevs.Aciklama,
                                         Kaydeden = calisma.Kaydeden,
                                         Sorumlular = calisma.Sorumlular,
                                         Tarih1 = calisma.Tarih1,
                                         Tarih2 = calisma.Tarih2,
                                         CalismaSure = calisma.CalismaSure,
                                         Calisma = calisma.Calisma,
                                         Durum = calisma.Durum,
                                     });
                        }
                        else
                        {
                            Query = (from calisma in Context.GorevCalismas
                                     join gorevs in Context.Gorevlers on calisma.GorevID equals gorevs.ID
                                     where (TumSorumlular ? true : calisma.Kaydeden == Kul.KulKodu)
                                     && (Filtre.Kaydeden.IsNullEmpty() ? true : calisma.Kaydeden == Filtre.Kaydeden)
                                     && (Filtre.Sorumlu.IsNullEmpty() ? true : calisma.Sorumlular.Contains(Filtre.Sorumlu))
                                     && (Filtre.Firma.IsNullEmpty() ? true : gorevs.Firma == Filtre.Firma)
                                     && (Filtre.Proje.IsNullEmpty() ? true : gorevs.Proje == Filtre.Proje)
                                     && (Filtre.Form.IsNullEmpty() ? true : gorevs.Form == Filtre.Form)
                                     && (Filtre.Gorev.IsNullEmpty() ? true : gorevs.Gorev.Contains(Filtre.Gorev))
                                     && (sonCalismaTarih1.IsNullEmpty() ? true : calisma.Tarih1 >= sonCalismaTarih1)
                                     && (sonCalismaTarih2.IsNullEmpty() ? true : calisma.Tarih1 <= sonCalismaTarih2)
                                     && (sonKayitTarih1.IsNullEmpty() ? true : calisma.KayitTarih >= sonKayitTarih1)
                                     && (sonKayitTarih2.IsNullEmpty() ? true : calisma.KayitTarih <= sonKayitTarih2)
                                     && (calisma.Tarih1>=DateTime.Today.AddDays(-30))
                                     orderby calisma.Tarih1 ascending
                                     select new GorevCalismaEx
                                     {
                                         ID = calisma.ID,
                                         Firma = gorevs.Firma,
                                         Proje = gorevs.Proje,
                                         Form = gorevs.Form,
                                         Gorev = gorevs.Gorev,
                                         Aciklama = gorevs.Aciklama,
                                         Kaydeden = calisma.Kaydeden,
                                         Sorumlular = calisma.Sorumlular,
                                         Tarih1 = calisma.Tarih1,
                                         Tarih2 = calisma.Tarih2,
                                         CalismaSure = calisma.CalismaSure,
                                         Calisma = calisma.Calisma,
                                         Durum = calisma.Durum,
                                     });
                        }
                    }

                    if (Query.Any())
                    {
                        int toplamSure = Query.Select(x => x.CalismaSure).Sum().ToInt32();
                        DateTime ilkTarih = Query.Select(x => x.Tarih1).Min().ToDatetime();
                        DateTime sonTarih = Query.Select(x => x.Tarih1).Max().ToDatetime();
                        TimeSpan tsFark = sonTarih - ilkTarih;
                        int toplamGun = tsFark.TotalDays.ToInt32() + 1;

                        int saat = toplamSure / 60;
                        int dakika = toplamSure % 60;

                        string sureIfade = "";
                        if (saat > 0)
                        {
                            sureIfade = saat.ToString2() + " : ";
                        }
                        if (dakika > 0)
                        {
                            sureIfade += dakika.ToString2() + " Dk";
                        }

                        gridCalisma.DataSource = Query;
                        gridCalisma.EditIndex = editIndex;
                        gridCalisma.DataBind();

                        ((Label)gridCalisma.FooterRow.FindControl("labToplamSure")).Text = sureIfade;
                        ((Label)gridCalisma.FooterRow.FindControl("labTarihFark")).Text = toplamGun.ToString2() + " Gün";

                        kayitAdet = Query.Count();
                    }
                    else
                    {
                        gridCalisma.DataSource = Query;
                        gridCalisma.EditIndex = editIndex;
                        gridCalisma.DataBind();

                        kayitAdet = 0;
                    }

                    if (ExportExcel)
                    {
                        if (chkTumKayitlarda.Checked)
                        {
                            var QueryEx = (from calisma in Context.GorevCalismas
                                           join gorevs in Context.Gorevlers on calisma.GorevID equals gorevs.ID
                                           where (TumSorumlular ? true : calisma.Kaydeden == Kul.KulKodu)
                                              && (Filtre.Kaydeden.IsNullEmpty() ? true : calisma.Kaydeden == Filtre.Kaydeden)
                                              && (Filtre.Sorumlu.IsNullEmpty() ? true : calisma.Sorumlular.Contains(Filtre.Sorumlu))
                                              && (Filtre.Firma.IsNullEmpty() ? true : gorevs.Firma == Filtre.Firma)
                                              && (Filtre.Proje.IsNullEmpty() ? true : gorevs.Proje == Filtre.Proje)
                                              && (Filtre.Form.IsNullEmpty() ? true : gorevs.Form == Filtre.Form)
                                              && (Filtre.Gorev.IsNullEmpty() ? true : gorevs.Gorev.Contains(Filtre.Gorev))
                                              && (sonCalismaTarih1.IsNullEmpty() ? true : calisma.Tarih1 >= sonCalismaTarih1)
                                              && (sonCalismaTarih2.IsNullEmpty() ? true : calisma.Tarih1 <= sonCalismaTarih2)
                                              && (sonKayitTarih1.IsNullEmpty() ? true : calisma.KayitTarih >= sonKayitTarih1)
                                              && (sonKayitTarih2.IsNullEmpty() ? true : calisma.KayitTarih <= sonKayitTarih2)
                                           orderby calisma.Tarih1 ascending

                                           select new GorevCalismaEx
                                           {
                                               ID = calisma.ID,
                                               Firma = gorevs.Firma,
                                               Proje = gorevs.Proje,
                                               Form = gorevs.Form,
                                               Gorev = gorevs.Gorev,
                                               Aciklama = gorevs.Aciklama,
                                               Kaydeden = calisma.Kaydeden,
                                               Sorumlular = calisma.Sorumlular,
                                               Tarih1 = calisma.Tarih1,
                                               Tarih2 = calisma.Tarih2,
                                               CalismaSure = calisma.CalismaSure,
                                               Calisma = calisma.Calisma,
                                               Durum = calisma.Durum,
                                           });

                            gridExport.DataSource = QueryEx;
                            gridExport.DataBind();
                        }
                        else
                        {
                            var QueryEx = (from calisma in Context.GorevCalismas
                                           join gorevs in Context.Gorevlers on calisma.GorevID equals gorevs.ID
                                           where (TumSorumlular ? true : calisma.Kaydeden == Kul.KulKodu)
                                               && (Filtre.Kaydeden.IsNullEmpty() ? true : calisma.Kaydeden == Filtre.Kaydeden)
                                               && (Filtre.Sorumlu.IsNullEmpty() ? true : calisma.Sorumlular.Contains(Filtre.Sorumlu))
                                               && (Filtre.Firma.IsNullEmpty() ? true : gorevs.Firma == Filtre.Firma)
                                               && (Filtre.Proje.IsNullEmpty() ? true : gorevs.Proje == Filtre.Proje)
                                               && (Filtre.Form.IsNullEmpty() ? true : gorevs.Form == Filtre.Form)
                                               && (Filtre.Gorev.IsNullEmpty() ? true : gorevs.Gorev.Contains(Filtre.Gorev))
                                               && (sonCalismaTarih1.IsNullEmpty() ? true : calisma.Tarih1 >= sonCalismaTarih1)
                                               && (sonCalismaTarih2.IsNullEmpty() ? true : calisma.Tarih1 <= sonCalismaTarih2)
                                               && (sonKayitTarih1.IsNullEmpty() ? true : calisma.KayitTarih >= sonKayitTarih1)
                                               && (sonKayitTarih2.IsNullEmpty() ? true : calisma.KayitTarih <= sonKayitTarih2)
                                               && (calisma.Tarih1 >= DateTime.Today.AddDays(-30))
                                           orderby calisma.Tarih1 ascending

                                           select new GorevCalismaEx
                                           {
                                               ID = calisma.ID,
                                               Firma = gorevs.Firma,
                                               Proje = gorevs.Proje,
                                               Form = gorevs.Form,
                                               Gorev = gorevs.Gorev,
                                               Aciklama = gorevs.Aciklama,
                                               Kaydeden = calisma.Kaydeden,
                                               Sorumlular = calisma.Sorumlular,
                                               Tarih1 = calisma.Tarih1,
                                               Tarih2 = calisma.Tarih2,
                                               CalismaSure = calisma.CalismaSure,
                                               Calisma = calisma.Calisma,
                                               Durum = calisma.Durum,
                                           });

                            gridExport.DataSource = QueryEx;
                            gridExport.DataBind();
                        }
                    }
          
                }

                ///Bu kodla pager kısmı sürekli gözüküyor...
                if (gridCalisma != null)
                {

                    GridViewRow pagerRow = (GridViewRow)gridCalisma.BottomPagerRow;
                    if (pagerRow != null)
                    {
                        pagerRow.Visible = true;
                    }
                }

                ScriptManager.RegisterStartupScript(this, typeof(string), "open", "ToplamKayit("+kayitAdet+");", true); 
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
   
        protected void gridCalisma_DataBinding(object sender, EventArgs e)
        {
            
        }

        protected void gridCalisma_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            pnlHata.Visible = false;
            pnlBasarili.Visible = false;
            gridCalisma.PageIndex = e.NewPageIndex;
            GetData(FirmaSorumluGetir: false);     
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
                gridCalisma.Width = 1075;          
            }
            ScriptManager.RegisterStartupScript(this, typeof(string), "open", "GetTakvim();", true);          
        }

        protected void btnDuzenle_Click(object sender, ImageClickEventArgs e)
        {
            pnlBasarili.Visible = false;
            pnlHata.Visible = false;
        }

        protected void btnCalismaKaydet_Click(object sender, EventArgs e)
        {
            int calismaID = hfCalismaID.Value.ToInt32();
            try
            {
                if (calismaID > 0)
                {
                    GorevCalisma gorevCalis = new GorevCalisma();
                    gorevCalis.Calisma = txtcCalisma.Text.Trim2();
                    gorevCalis.Tarih1 = txtcTarih.Text.ToDatetime();
                    //gorevCalis.Tarih2 = txtcTarih2.Text.ToDatetimeNull();
                    gorevCalis.CalismaSure = txtcSure.Text.ToInt32();


                    if (Methods.NullEmptyKontrol(gorevCalis.Calisma, gorevCalis.Tarih1, gorevCalis.CalismaSure))
                    {
                        using (GorevDataDataContext Context = new GorevDataDataContext(Global.ConStr))
                        {
                            GorevCalisma gorCalis = Context.GorevCalismas.Where(x => x.ID == calismaID).FirstOrDefault();
                            if (gorCalis.IsNotNull())
                            {
                                gorCalis.Calisma = gorevCalis.Calisma;
                                gorCalis.CalismaSure = gorevCalis.CalismaSure;
                                gorCalis.Tarih1 = gorevCalis.Tarih1;
                                //gorCalis.Tarih2 = gorevCalis.Tarih2;
                                gorCalis.Degistiren = Global.Kullanici.KulKodu;
                                gorCalis.DegisTarih = DateTime.Now;
                                Context.SubmitChanges();
                            }                         
                        }
                        GetData(FirmaSorumluGetir: false);
                        mPopupCalisma.Hide();
                        MesajVer(Global.MesajTip.Bilgi);
                        
                    }
                    else
                    {
                        MesajVer(Global.MesajTip.Uyari, Mesaj: "Çalışma, Çalışma Tarihi ve Süre alanları zorunludur boş geçilemez !");
                    }
                }
            }
            catch (Exception ex)
            {
                MesajVer(hata: ex);
            }
        }

        #region DÜRBÜN İÇİNDEKİ METODLAR
        protected void ddlDFirma_SelectedIndexChanged(object sender, EventArgs e)
        {
            try
            {
                using (GorevDataDataContext Context = new GorevDataDataContext(Global.ConStr))
                {
                    IQueryable<ProjeForm> ProjeBaslik = (from pro in Context.ProjeForms
                                                         where pro.Firma == ddlDFirma.SelectedValue && pro.PID == 0
                                                         orderby pro.Proje ascending
                                                         select pro);
                    ddlDProje.DataSource = ProjeBaslik;
                    ddlDProje.DataTextField = "Proje";
                    ddlDProje.DataValueField = "Proje";
                    ddlDProje.DataBind();
                    ddlDProje.Items.Insert(0, new ListItem("Tümü (*)", "*"));
                }
                pnlBasarili.Visible = false;
                pnlHata.Visible = false;
            }
            catch (Exception ex)
            {
                MesajVer(hata: ex);
            }
        }

        protected void ddlDProje_SelectedIndexChanged(object sender, EventArgs e)
        {
            try
            {
                using (GorevDataDataContext Context = new GorevDataDataContext(Global.ConStr))
                {
                    IQueryable<ProjeForm> FormList = (from pro in Context.ProjeForms
                                                      where pro.Firma == ddlDFirma.SelectedValue &&
                                                            pro.Proje == ddlDProje.SelectedValue && pro.PID != 0
                                                      orderby pro.Form ascending
                                                      select pro);
                    ddlDForm.DataSource = FormList;
                    ddlDForm.DataTextField = "Form";
                    ddlDForm.DataValueField = "Form";
                    ddlDForm.DataBind();
                    ddlDForm.Items.Insert(0, new ListItem("Tümü (*)", "*"));
                }
                pnlBasarili.Visible = false;
                pnlHata.Visible = false;
            }
            catch (Exception ex)
            {
                MesajVer(hata: ex);
            }
        }

        public class CalismaFiltre
        {
            public string Kaydeden { get; set; }
            public string Sorumlu { get; set; }
            public string Firma { get; set; }
            public string Proje { get; set; }
            public string Form { get; set; }
            public string Gorev { get; set; }
            public DateTime? CalismaTarihi1 { get; set; }
            public DateTime? CalismaTarihi2 { get; set; }
            public DateTime? KayitTarihi1 { get; set; }
            public DateTime? KayitTarihi2 { get; set; }
        }

        protected void btnDurbunCalismaGetir_Click(object sender, EventArgs e)
        {
            try
            {
                GetData(FirmaSorumluGetir: false);
            }
            catch (Exception ex)
            {
                MesajVer(hata: ex);
            }
        }

        public override void VerifyRenderingInServerForm(Control control)
        {
            /* Verifies that the control is rendered */
        }

        protected void btnExportExcel_Click(object sender, EventArgs e)
        {
            this.EnableViewState = false;

            Response.Clear();
            Response.Buffer = true;
            Response.AddHeader("content-disposition", "attachment;filename=ÇalışmaDetay.xls");
            Response.ContentEncoding = System.Text.Encoding.GetEncoding("windows-1254");
            Response.Charset = "windows-1254";
            Response.ContentType = "application/vnd.ms-excel";
            using (StringWriter sw = new StringWriter())
            {
                HtmlTextWriter hw = new HtmlTextWriter(sw);

                GetData(FirmaSorumluGetir: false, ExportExcel: true);
                gridExport.HeaderRow.BackColor = Color.White;
                foreach (TableCell cell in gridExport.HeaderRow.Cells)
                {
                    cell.BackColor = gridExport.HeaderStyle.BackColor;
                }

                foreach (GridViewRow row in gridExport.Rows)
                {
                    row.BackColor = Color.White;
                    foreach (TableCell cell in row.Cells)
                    {
                        if (row.RowIndex % 2 == 0)
                        {
                            cell.BackColor = gridExport.AlternatingRowStyle.BackColor;
                        }
                        else
                        {
                            cell.BackColor = gridExport.RowStyle.BackColor;
                        }
                        cell.CssClass = "textmode";
                    }
                }

                gridExport.RenderControl(hw);

                //style to format numbers to string
                string style = @"<style> .textmode { mso-number-format:\@; } </style>";
                Response.Write(style);
                Response.Output.Write(sw.ToString());
                Response.Flush();
                Response.End();
            }
        }
        #endregion DÜRBÜN İÇİNDEKİ METODLAR


        #region FİLTER ROW METODLARI
        protected void ddlfilterSorumlu_SelectedIndexChanged(object sender, EventArgs e)
        {
            try
            {
                GetData(FirmaSorumluGetir: false, FilterRowIcin: true);
            }
            catch (Exception ex)
            {
                MesajVer(hata: ex);
            }
        }

        protected void ddlfilterFirma_SelectedIndexChanged(object sender, EventArgs e)
        {
            try
            {
                using (GorevDataDataContext Context = new GorevDataDataContext(Global.ConStr))
                {
                    IQueryable<ProjeForm> ProjeBaslik = (from pro in Context.ProjeForms
                                                         where pro.Firma == ddlfilterFirma.SelectedValue && pro.PID == 0
                                                         orderby pro.Proje ascending
                                                         select pro);
                    ddlfilterProje.DataSource = ProjeBaslik;
                    ddlfilterProje.DataTextField = "Proje";
                    ddlfilterProje.DataValueField = "Proje";
                    ddlfilterProje.DataBind();
                    ddlfilterProje.Items.Insert(0, new ListItem("Tümü", "*"));
                }
 
                GetData(FirmaSorumluGetir: false, FilterRowIcin: true);
               
            }
            catch (Exception ex)
            {
                MesajVer(hata: ex);
            }
        }

        protected void ddlfilterProje_SelectedIndexChanged(object sender, EventArgs e)
        {
            try
            {
                using (GorevDataDataContext Context = new GorevDataDataContext(Global.ConStr))
                {
                    IQueryable<ProjeForm> FormList = (from pro in Context.ProjeForms
                                                      where pro.Firma == ddlfilterFirma.SelectedValue &&
                                                            pro.Proje == ddlfilterProje.SelectedValue && pro.PID != 0
                                                      orderby pro.Form ascending
                                                      select pro);
                    ddlfilterForm.DataSource = FormList;
                    ddlfilterForm.DataTextField = "Form";
                    ddlfilterForm.DataValueField = "Form";
                    ddlfilterForm.DataBind();
                    ddlfilterForm.Items.Insert(0, new ListItem("Tümü", "*"));
                }

                GetData(FirmaSorumluGetir: false, FilterRowIcin: true);
               
            }
            catch (Exception ex)
            {
                MesajVer(hata: ex);
            }
        }

        protected void ddlfilterForm_SelectedIndexChanged(object sender, EventArgs e)
        {
            try
            {
                GetData(FirmaSorumluGetir: false, FilterRowIcin: true);
            }
            catch (Exception ex)
            {
                MesajVer(hata: ex);
            }
        }

        protected void txtfilterGorev_TextChanged(object sender, EventArgs e)
        {
            try
            {
                GetData(FirmaSorumluGetir: false, FilterRowIcin: true);
            }
            catch (Exception ex)
            {
                MesajVer(hata: ex);
            }
        }

        protected void txtfilterTarih1_TextChanged(object sender, EventArgs e)
        {
            try
            {
                GetData(FirmaSorumluGetir: false, FilterRowIcin: true);
            }
            catch (Exception ex)
            {
                MesajVer(hata: ex);
            }
        }

        protected void txtCalismaSure_TextChanged(object sender, EventArgs e)
        {
            try
            {
                GetData(FirmaSorumluGetir: false, FilterRowIcin: true);
            }
            catch (Exception ex)
            {
                MesajVer(hata: ex);
            }
        }
        #endregion FİLTER ROW METODLARI

      


    }
}