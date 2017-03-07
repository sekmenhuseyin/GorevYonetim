using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.Linq;
using GorevYonetim.App_Data;
using System.Data;
using System.Web.Services;
using System.IO;
using System.Transactions;
using AjaxControlToolkit;
using System.Web.Script.Serialization;

namespace GorevYonetim
{
    public partial class Gorev : System.Web.UI.Page
    {
    
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Page.IsPostBack) /// Sayfa ilk kez yükleniyorsa
            {
                Session["SonKayitID"] = 0;
                GetData();
                BindEkDosya();
            }
        }

        #region Data İşlemleri
        private void BindEkDosya()
        {
            ///GridView sırf gözükebilsin diye DataBind() yapıyorum..
            //DataTable dt = new DataTable();
            //gridEkDosya.DataSource = dt;
            //gridEkDosya.DataBind();
            Session["EkDosyalar"] = new List<EkDosya>();
        }

        [WebMethod]
        public static EkDosyaEx[] DokumanGetir(string Firma, string Proje)
        {
            try
            {
                using (GorevDataDataContext Context = new GorevDataDataContext(Global.ConStr))
                {
                    int ProjeID = Context.ProjeForms.Where(x => x.Firma == Firma.Trim() && x.Proje == Proje.Trim() && x.PID == 0).FirstOrDefault().ID;

                    List<EkDosyaEx> EkDosyaList = new List<EkDosyaEx>();

                    EkDosyaList = Context.EkDosyas.Where(x => x.GorevID == ProjeID && x.Tip == 1).Select(x => new EkDosyaEx
                    {
                        ID = x.ID,
                        GorevID = x.GorevID,
                        Aciklama = x.Aciklama,
                        DosyaAdi = x.DosyaAdi,
                        Kaydeden = x.Kaydeden,
                        KayitTarih = x.KayitTarih,
                        KayitTarihStr = string.Format("{0:dd.MM.yyyy - hh:mm}", x.KayitTarih),
                        Tip = x.Tip
                    }).OrderByDescending(x => x.ID).ToList();

                    return EkDosyaList.ToArray();
                }
            }
            catch
            {
                return new EkDosyaEx[0].ToArray();
            }
        }

        [WebMethod]
        public static EkDosyaEx[] EkDosyaGetir(int ID)
        {
            try
            {
                using (GorevDataDataContext Context = new GorevDataDataContext(Global.ConStr))
                {
                   
                    List<EkDosyaEx> EkDosyaList = new List<EkDosyaEx>();

                    EkDosyaList = Context.EkDosyas.Where(x => x.GorevID == ID).Select(x => new EkDosyaEx
                    {
                        ID = x.ID,
                        GorevID = x.GorevID,
                        Aciklama = x.Aciklama,
                        DosyaAdi = x.DosyaAdi,
                        Kaydeden = x.Kaydeden,
                        KayitTarih = x.KayitTarih,
                        KayitTarihStr = string.Format("{0:dd.MM.yyyy - hh:mm}", x.KayitTarih)
                    }).ToList();


                    return EkDosyaList.ToArray();
                }
            }
            catch
            {
                return new EkDosyaEx[0].ToArray();
            }
        }

        [WebMethod]
        public static List<string> GorevGetir(string projeAdi)
        {
            using (GorevDataDataContext Context = new GorevDataDataContext(Global.ConStr))
            {
                IQueryable<string> GorevList = Context.Gorevlers.Where(x => x.Proje == projeAdi).Select(x => x.Gorev);
                return GorevList.ToList();
            }
        }

        [WebMethod]
        public static List<GorevHareketEx> HareketGetir(int GorevID)
        {
            using (GorevDataDataContext Context = new GorevDataDataContext(Global.ConStr))
            {
                List<GorevHareketEx> GorevHareketList = (from x in Context.GorevHarekets
                                                         join y in Context.Gorevlers
                                                         on x.GorevID equals y.ID
                                                         where x.GorevID==GorevID
                                                         select new GorevHareketEx
                                                         {
                                                             ID = x.ID,
                                                             GorevID = x.GorevID,
                                                             GorevKayitTarih = y.KayitTarih,                           
                                                             DurumStr = x.DurumStr,
                                                             Sorumlu = x.Sorumlu,                                    
                                                             Kaydeden = x.Kaydeden,
                                                             KayitTarih = x.KayitTarih
                                                             
                                                         }).ToList();

                int sira = 1;
                foreach (var item in GorevHareketList)
                {
                    item.ListeID = sira;
                    item.KayitTarihStr = item.KayitTarih.ToShortDateString() + " - " + item.KayitTarih.ToShortTimeString();
                    item.GorevKayitTarihStr = item.GorevKayitTarih.ToShortDateString() + " - " + item.GorevKayitTarih.ToShortTimeString();
                    //if (item.TahminiBitisTarih.IsNotNullEmpty())
                    //    item.TahBitisTarihStr = item.TahminiBitisTarih.Value.ToShortDateString();
                    sira++;
                }
                            
                return GorevHareketList;
            }
        }

        [WebMethod]
        public static GorevHareketDetay HareketDetayGetir(int GHareketID)
        {
            using (GorevDataDataContext Context = new GorevDataDataContext(Global.ConStr))
            {
                GorevHareketDetay GHareketDetay = (from x in Context.GorevHarekets
                                                   where x.ID == GHareketID
                                                   select new GorevHareketDetay
                                                   {
                                                       ID = x.ID,
                                                       Gorev = x.Gorev,
                                                       Aciklama = x.Aciklama,
                                                       DAciklama = x.DurumAciklama
                                                   }).FirstOrDefault();

                return GHareketDetay;
            }
        }

        [WebMethod]
        public static List<GorevCalismaEx> CalismalariGetir(int GorevID)
        {
            using (GorevDataDataContext Context = new GorevDataDataContext(Global.ConStr))
            {
                List<GorevCalismaEx> CalismaList = (from gc in Context.GorevCalismas
                                                    join g in Context.Gorevlers
                                                    on gc.GorevID equals g.ID
                                                    where gc.GorevID == GorevID
                                                    orderby gc.Tarih1 ascending
                                                    select new GorevCalismaEx
                                                    {
                                                        ID = gc.ID,
                                                        GorevID = gc.GorevID,
                                                        Kaydeden = gc.Kaydeden,
                                                        Sorumlular = gc.Sorumlular,
                                                        Firma = g.Firma,
                                                        Proje = g.Proje,
                                                        Form = g.Form,
                                                        Gorev = g.Gorev,
                                                        CalismaSure = gc.CalismaSure,
                                                        Tarih1 = gc.Tarih1,
                                                        KayitTarih = gc.KayitTarih

                                                    }).ToList();

                int sira = 1;
                foreach (var item in CalismaList)
                {
                    item.ListeID = sira;
                    item.CalismaTarihStr = item.Tarih1.ToShortDateString();
                    sira++;
                }

                if (CalismaList.Count > 0)
                {
                    int calismaSure = 0;
                    GorevCalismaEx altSatir = new GorevCalismaEx();
                    calismaSure = CalismaList.Sum(x => x.CalismaSure);
                    int saat = calismaSure / 60;
                    int dakika = calismaSure % 60;
                    altSatir.Aciklama = string.Format("{0} sa - {1} dk", saat, dakika);
                    CalismaList.Add(altSatir);
                }

                return CalismaList;
            }
        }

        [WebMethod]
        public static CalismaDetay CalismaDetayGetir(int CalismaID)
        {
            using (GorevDataDataContext Context = new GorevDataDataContext(Global.ConStr))
            {
                CalismaDetay calismaDetay = (from gc in Context.GorevCalismas
                                             join g in Context.Gorevlers
                                             on gc.GorevID equals g.ID
                                             where gc.ID == CalismaID
                                             select new CalismaDetay
                                             {
                                                 ID = gc.ID,
                                                 Gorev = g.Gorev,
                                                 Aciklama = g.Aciklama,
                                                 Calisma = gc.Calisma
                                             }).FirstOrDefault();

                return calismaDetay;
            }
        }

        [WebMethod]
        public static string EkDosyaSil(string Param)
        {
            try
            {
                string[] degerler = Param.Split(',');
                int id = degerler[0].ToInt32();
                int gorevID = degerler[1].ToInt32();
                string dosyaAdi = degerler[2].ToString2();

                using (GorevDataDataContext Context = new GorevDataDataContext(Global.ConStr))
                {
                    EkDosya ekdosya = Context.EkDosyas.Where(x => x.ID == id).FirstOrDefault();
                    if (ekdosya.IsNotNull())
                        Context.EkDosyas.DeleteOnSubmit(ekdosya);
                    Context.SubmitChanges();
                }

                FileInfo file = new FileInfo(System.Web.HttpContext.Current.Server.MapPath("UploadFiles/GorevFiles/" + gorevID + "/") + dosyaAdi);
                if (file.Exists)
                    file.Delete();

                return dosyaAdi;
            }
            catch
            {
                return "Error";
            }
        }
      
        void GetData(int editIndex = -1, bool FirmaGetir = true, bool SorumluGetir = true, bool DurumGetir = true, bool Sorting = false, string SortField=null)
        {
            try
            {
                int kayitAdet = 0;
                using (GorevDataDataContext Context = new GorevDataDataContext(Global.ConStr))
                {
                    GorevFiltre Filtre = new GorevFiltre();
                    Kullanici Kul = Global.Kullanici;
                    hfYetkiKodu.Value = Kul.YetkiKod.ToString2();

                    if (Kul.YetkiKod == 1) //1->Customer
                    {
                        txtFirmaCus.Text = Kul.Firma;

                        IQueryable<ProjeForm> ProjeBaslik = (from pro in Context.ProjeForms
                                                             where pro.Firma == Kul.Firma && pro.PID == 0
                                                             orderby pro.Proje ascending
                                                             select pro);
                        ddlistProjeCus.DataSource = ProjeBaslik;
                        ddlistProjeCus.DataTextField = "Proje";
                        ddlistProjeCus.DataValueField = "Proje";
                        ddlistProjeCus.DataBind();
                        ddlistProjeCus.Items.Insert(0, new ListItem("-"));

                    }

                    #region Sorumlu Firma Durum DropDownList Set Blok 
                    if (SorumluGetir) ///Aynı zamanda genel durumları da burda oluşturuyorum.
                    {
                        ///Genel Durumlar Oluşturuluyor
                        ddlDGenelDurumlar.DataSource = Durum.GenelDurumlariGetir();
                        ddlDGenelDurumlar.DataTextField = "Aciklama";
                        ddlDGenelDurumlar.DataValueField = "Kod";
                        ddlDGenelDurumlar.DataBind();

                        ///Popup Görev Ekle İçin
                        IQueryable<Kullanici> listSorumlu = (from sorumlu in Context.Kullanicis
                                                             where sorumlu.YetkiKod!=1
                                                             select sorumlu);
                        ddlistSorumlu.DataSource = listSorumlu;
                        ddlistSorumlu.DataTextField = "AdSoyad";
                        ddlistSorumlu.DataValueField = "KulKodu";
                        ddlistSorumlu.DataBind();
                        ddlistSorumlu.Items.Insert(0, new ListItem("-", "-"));

                        ddlistSorumlu2.DataSource = listSorumlu;
                        ddlistSorumlu2.DataTextField = "AdSoyad";
                        ddlistSorumlu2.DataValueField = "KulKodu";
                        ddlistSorumlu2.DataBind();
                        ddlistSorumlu2.Items.Insert(0, new ListItem("-", "-"));

                        ddlistSorumlu3.DataSource = listSorumlu;
                        ddlistSorumlu3.DataTextField = "AdSoyad";
                        ddlistSorumlu3.DataValueField = "KulKodu";
                        ddlistSorumlu3.DataBind();
                        ddlistSorumlu3.Items.Insert(0, new ListItem("-", "-"));


                        ///Popup Dürbün İçin
                        ddlDSorumlu.DataSource = listSorumlu;
                        ddlDSorumlu.DataTextField = "AdSoyad";
                        ddlDSorumlu.DataValueField = "KulKodu";
                        ddlDSorumlu.DataBind();
                        ddlDSorumlu.Items.Insert(0, new ListItem("Tümü (*)", "*"));
                        ddlDSorumlu.ClearSelection();
                        if (Kul.YetkiKod == 3 || Kul.YetkiKod == 1)  /// 3->Admin veya 1->Customersa 
                            ddlDSorumlu.Items.FindByValue("*").Selected = true;
                        else
                            ddlDSorumlu.Items.FindByValue(Kul.KulKodu).Selected = true;
                    }

                    if (FirmaGetir)
                    {
                        List<FirmaMin> MusteriList = (from musteri in Context.Musteris
                                                      where musteri.FID == 0
                                                      orderby musteri.Firma ascending
                                                      select new FirmaMin { ID = musteri.ID, Firma = musteri.Firma }).ToList();

                        ddlistFirma.DataSource = MusteriList;
                        ddlistFirma.DataTextField = "Firma";
                        ddlistFirma.DataValueField = "Firma";
                        ddlistFirma.DataBind();
                        ddlistFirma.Items.Insert(0, new ListItem("-", "-"));

                        ddlistFirma2.DataSource = MusteriList;
                        ddlistFirma2.DataTextField = "Firma";
                        ddlistFirma2.DataValueField = "Firma";
                        ddlistFirma2.DataBind();
                        ddlistFirma2.Items.Insert(0, new ListItem("-", "-"));

                        ///Popup Dürbün İçin
                        ddlDFirma.DataSource = MusteriList;
                        ddlDFirma.DataTextField = "Firma";
                        ddlDFirma.DataValueField = "Firma";
                        ddlDFirma.DataBind();
                        ddlDFirma.Items.Insert(0, new ListItem("Tümü (*)", "*"));

                    }


                    if (DurumGetir)  ///Burda aynı zamanda Öncelik tipleri de çağrılıyor
                    {
                        ///Popup Görev Ekledeki Durumlar
                        ///Yetkisi Admin olmayanlar tüm durumları göremeyecek
                        ///Kodu 6 dan büyük olan durumları sadece Admin görebilecek
                        IQueryable<Tanim> listTanim = from ver in Context.Tanims
                                                      where ver.Tip == 1
                                                      && (Kul.YetkiKod < 3 ? ver.KodInt < 7 : true)
                                                      select ver;
                        ddlistDurum.DataSource = listTanim;
                        ddlistDurum.DataTextField = "Kod";
                        ddlistDurum.DataValueField = "KodInt";
                        ddlistDurum.DataBind();

                        ddlistDurum2.DataSource = listTanim;
                        ddlistDurum2.DataTextField = "Kod";
                        ddlistDurum2.DataValueField = "KodInt";
                        ddlistDurum2.DataBind();

                        ///Popup Dürbündeki Durumlar
                        ddlDDurum.DataSource = listTanim;
                        ddlDDurum.DataTextField = "Kod";
                        ddlDDurum.DataValueField = "KodInt";
                        ddlDDurum.DataBind();
                        ddlDDurum.Items.Insert(0, new ListItem("Tümü (*)", "*"));

                        ///Popup Görev Ekledeki Öncelikler
                        IQueryable<Tanim> listOncelik = Context.Tanims.Where(x => x.Tip == 0);
                        ddlistOncelik.DataSource = listOncelik;
                        ddlistOncelik.DataTextField = "Kod";
                        ddlistOncelik.DataValueField = "KodInt";
                        ddlistOncelik.DataBind();
                        ddlistOncelik.ClearSelection();
                        ddlistOncelik.Items.FindByValue("1").Selected = true; ///1 Normal default değeri set eder
                                                                              
                        ddlistOncelik2.DataSource = listOncelik;
                        ddlistOncelik2.DataTextField = "Kod";
                        ddlistOncelik2.DataValueField = "KodInt";
                        ddlistOncelik2.DataBind();
                        ddlistOncelik2.ClearSelection();
                        ddlistOncelik2.Items.FindByValue("1").Selected = true; ///1 Normal default değeri set eder
                                                                               
                        ddlistOncelikCus.DataSource = listOncelik;
                        ddlistOncelikCus.DataTextField = "Kod";
                        ddlistOncelikCus.DataValueField = "KodInt";
                        ddlistOncelikCus.DataBind();
                        ddlistOncelikCus.ClearSelection();
                        ddlistOncelikCus.Items.FindByValue("1").Selected = true; ///1 Normal default değeri set eder

                    }
                    #endregion Sorumlu Firma Durum DropDownList Set Blok SON



                    List<int> GorevDurumlari = new List<int>();

                    if (Page.IsPostBack || Session["GorevFiltre"].IsNull())
                    {
                        Filtre.GenelDurumlar = ddlDGenelDurumlar.SelectedValue.ToShort(0);
                        GorevDurumlari = Durum.GorevDurumlariGetir(Filtre.GenelDurumlar);

                        Filtre.Sorumlu = ddlDSorumlu.SelectedValue.Trim2('*');
                        Filtre.Firma = ddlDFirma.SelectedValue.Trim2('*');

                        if (Kul.YetkiKod == 1) //1-> Customer
                        {
                            Filtre.Firma = Kul.Firma;

                            if (ddlDFirma.Visible)
                            {
                                chkYedek.Checked = true;
                                txtDurbunFirma.Visible = true;
                                ddlDFirma.Visible = false;
                                txtDurbunFirma.Text = Kul.Firma;

                                IQueryable<ProjeForm> ProjeBaslik = (from pro in Context.ProjeForms
                                                                     where pro.Firma == Kul.Firma && pro.PID == 0
                                                                     orderby pro.Proje ascending
                                                                     select pro);
                                ddlDProje.DataSource = ProjeBaslik;
                                ddlDProje.DataTextField = "Proje";
                                ddlDProje.DataValueField = "Proje";
                                ddlDProje.DataBind();
                                ddlDProje.Items.Insert(0, new ListItem("Tümü (*)", "*"));
                            }
                        }
                        
                        Filtre.Proje = ddlDProje.SelectedValue.Trim2('*');
                        Filtre.Form = ddlDForm.SelectedValue.Trim2('*');
                        Filtre.Gorev = txtDGorev.Text.Trim2();
                        Filtre.Aciklama = txtDAciklama.Text.Trim2();
                        Filtre.Durum = ddlDDurum.SelectedValue.ToShort(-5);

                        Filtre.KayitTarihi1 = txtDKayitTarih1.Text.ToDatetimeNull();
                        Filtre.KayitTarihi2 = txtDKayitTarih2.Text.ToDatetimeNull();
                        Filtre.TahBitisTarihi1 = txtDTahBitisTarihi1.Text.ToDatetimeNull();
                        Filtre.TahBitisTarihi2 = txtDTahBitisTarihi2.Text.ToDatetimeNull();

                        Filtre.AsliSorumlu = chkAsli.Checked;
                        Filtre.YedekSorumlu = chkYedek.Checked;

                        Session["GorevFiltre"] = Filtre;
                    }
                    else if (Session["GorevFiltre"].IsNotNull()) ///Sayfa ilk kez yüklenmişse
                    {
                        ddlDFirma.ClearSelection();
                        ddlDGenelDurumlar.ClearSelection();
                        ddlDDurum.ClearSelection();
                        ddlDSorumlu.ClearSelection();

                        Filtre = (GorevFiltre)Session["GorevFiltre"];
                        GorevDurumlari = Durum.GorevDurumlariGetir(Filtre.GenelDurumlar);                       
                        ddlDSorumlu.Items.FindByValue(Filtre.Sorumlu.IsNullEmptySetValue("*")).Selected = true;
                       
                        ddlDFirma.Items.FindByValue(Filtre.Firma.IsNullEmptySetValue("*")).Selected = true;
                        ddlDGenelDurumlar.Items.FindByValue(Filtre.GenelDurumlar.ToString2()).Selected = true;

                        if (Filtre.Durum == -5)
                            ddlDDurum.Items.FindByValue("*").Selected = true;
                        else
                            ddlDDurum.Items.FindByValue(Filtre.Durum.IsNullEmptySetValue("*")).Selected = true;

                        if (Filtre.TahBitisTarihi1 != null)
                            txtDTahBitisTarihi1.Text = Filtre.TahBitisTarihi1.Value.ToShortDateString();
                        if (Filtre.TahBitisTarihi2 != null)
                            txtDTahBitisTarihi2.Text = Filtre.TahBitisTarihi2.Value.ToShortDateString();
                        if (Filtre.KayitTarihi1 != null)
                            txtDKayitTarih1.Text = Filtre.KayitTarihi1.Value.ToShortDateString();
                        if (Filtre.KayitTarihi2 != null)
                            txtDKayitTarih2.Text = Filtre.KayitTarihi2.Value.ToShortDateString();

                        txtDGorev.Text = Filtre.Gorev.ToString2();
                        txtDAciklama.Text = Filtre.Aciklama.ToString2();

                        chkAsli.Checked = Filtre.AsliSorumlu;
                        chkYedek.Checked = Filtre.YedekSorumlu;
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

                    DateTime? sonTahBitisTarihi1 = null;
                    DateTime? sonTahBitisTarihi2 = null;

                    if (Filtre.TahBitisTarihi1.IsNotNullEmpty() && Filtre.TahBitisTarihi2.IsNotNullEmpty())
                    {
                        sonTahBitisTarihi1 = new DateTime(Filtre.TahBitisTarihi1.Value.Year, Filtre.TahBitisTarihi1.Value.Month, Filtre.TahBitisTarihi1.Value.Day, 0, 0, 0);
                        sonTahBitisTarihi2 = new DateTime(Filtre.TahBitisTarihi2.Value.Year, Filtre.TahBitisTarihi2.Value.Month, Filtre.TahBitisTarihi2.Value.Day, 23, 59, 59);
                    }
                    else if (Filtre.TahBitisTarihi1.IsNotNullEmpty())
                    {
                        sonTahBitisTarihi1 = new DateTime(Filtre.TahBitisTarihi1.Value.Year, Filtre.TahBitisTarihi1.Value.Month, Filtre.TahBitisTarihi1.Value.Day, 0, 0, 0);
                        sonTahBitisTarihi2 = new DateTime(Filtre.TahBitisTarihi1.Value.Year, Filtre.TahBitisTarihi1.Value.Month, Filtre.TahBitisTarihi1.Value.Day, 23, 59, 59);
                    }
                    else if (Filtre.TahBitisTarihi2.IsNotNullEmpty())
                    {
                        sonTahBitisTarihi1 = new DateTime(Filtre.TahBitisTarihi2.Value.Year, Filtre.TahBitisTarihi2.Value.Month, Filtre.TahBitisTarihi2.Value.Day, 0, 0, 0);
                        sonTahBitisTarihi2 = new DateTime(Filtre.TahBitisTarihi2.Value.Year, Filtre.TahBitisTarihi2.Value.Month, Filtre.TahBitisTarihi2.Value.Day, 23, 59, 59);
                    }

                    var Liste = (from gorevs in Context.Gorevlers
                                 join tOncelik in Context.Tanims on gorevs.Oncelik equals tOncelik.KodInt
                                 where tOncelik.Tip == 0
                                 join tDurum in Context.Tanims on gorevs.Durum equals tDurum.KodInt
                                 where tDurum.Tip == 1 && tDurum.KodInt > -1
                                 && (GorevDurumlari.Contains(tDurum.KodInt)) &&

                                 (Filtre.Sorumlu.IsNullEmpty() ? true :
                                  (Filtre.Sorumlu.IsNullEmpty() && chkAsli.Checked ? gorevs.Sorumlu != null && gorevs.Sorumlu.Trim() != "" :
                                   (Filtre.Sorumlu.IsNullEmpty() && chkYedek.Checked ? ((gorevs.Sorumlu2 != null && gorevs.Sorumlu2.Trim() != "") || (gorevs.Sorumlu3 != null && gorevs.Sorumlu3.Trim() != "")) :
                                    (Filtre.Sorumlu.IsNotNullEmpty() && chkAsli.Checked && chkYedek.Checked ? (gorevs.Sorumlu == Filtre.Sorumlu || gorevs.Sorumlu2 == Filtre.Sorumlu || gorevs.Sorumlu3 == Filtre.Sorumlu) :
                                     (Filtre.Sorumlu.IsNotNullEmpty() && chkAsli.Checked ? gorevs.Sorumlu == Filtre.Sorumlu :
                                      (Filtre.Sorumlu.IsNotNullEmpty() && chkYedek.Checked ? (gorevs.Sorumlu2 == Filtre.Sorumlu || gorevs.Sorumlu3 == Filtre.Sorumlu) : false)
                                 )))))

                                 && (Filtre.Firma.IsNullEmpty() ? true : gorevs.Firma == Filtre.Firma)
                                 && (Filtre.Proje.IsNullEmpty() ? true : gorevs.Proje == Filtre.Proje)
                                 && (Filtre.Form.IsNullEmpty() ? true : gorevs.Form == Filtre.Form)
                                 && (Filtre.Durum == -5 ? true : gorevs.Durum == Filtre.Durum)
                                 && (Filtre.Gorev.IsNullEmpty() ? true : gorevs.Gorev.Contains(Filtre.Gorev))
                                 && (Filtre.Aciklama.IsNullEmpty() ? true : gorevs.Aciklama.Contains(Filtre.Aciklama))
                                 && (sonKayitTarih1.IsNullEmpty() ? true : gorevs.KayitTarih >= sonKayitTarih1)
                                 && (sonKayitTarih2.IsNullEmpty() ? true : gorevs.KayitTarih <= sonKayitTarih2)
                                 && (sonTahBitisTarihi1.IsNullEmpty() ? true : gorevs.TahminiBitisTarih >= sonTahBitisTarihi1)
                                 && (sonTahBitisTarihi2.IsNullEmpty() ? true : gorevs.TahminiBitisTarih <= sonTahBitisTarihi2)
                                 orderby
                                 gorevs.Durum == 3 ? 0 : 1 ascending,
                                 gorevs.IslemSira == null ? 100000 : gorevs.IslemSira ascending,
                                 gorevs.Oncelik descending, 
                                 gorevs.TahminiBitisTarih ascending, 
                                 gorevs.ID descending
                                 select new GorevlerEx
                                 {
                                     ID = gorevs.ID,
                                     IslemSira = gorevs.IslemSira,
                                     Firma = gorevs.Firma,
                                     Proje = gorevs.Proje,
                                     Form = gorevs.Form,
                                     Gorev = gorevs.Gorev,
                                     Aciklama = gorevs.Aciklama,
                                     Sorumlu = SorumluFormatla(gorevs.Sorumlu, gorevs.Sorumlu2, gorevs.Sorumlu3),
                                     Durum = gorevs.Durum,
                                     DurumAcikla = tDurum.Kod,
                                     Oncelik = gorevs.Oncelik,
                                     OncelikAcikla = tOncelik.Kod,
                                     KayitTarih = gorevs.KayitTarih,
                                     TahminiBitisTarih = gorevs.TahminiBitisTarih
                                 }).Take(200);

                    #region SORTING İŞLEMİ *
                    if (Sorting && SortField.IsNotNullEmpty())  ///Sıralama varsa onu da uygula
                    {                  
                        if (SortType == SortDirection.Ascending)
                        {
                            if (SortField == "ID")
                            {
                                ///ID olduğunda her iki durumda da Desc yapıyorum.
                                Liste = Liste.OrderByDescending(x => x.Firma);
                            }
                            else if (SortField == "Firma")
                            {
                                Liste = Liste.OrderBy(x => x.Firma);
                            }
                            else if (SortField == "Proje")
                            {
                                Liste = Liste.OrderBy(x => x.Proje);
                            }
                            else if (SortField == "Form")
                            {
                                Liste = Liste.OrderBy(x => x.Form);
                            }
                            else if (SortField == "Gorev")
                            {
                                Liste = Liste.OrderBy(x => x.Gorev);
                            }
                            else if (SortField == "Sorumlu")
                            {
                                Liste = Liste.OrderBy(x => x.Sorumlu);
                            }
                            else if (SortField == "Durum")
                            {
                                Liste = Liste.OrderBy(x => x.Durum);
                            }
                            else if (SortField == "Oncelik")
                            {
                                Liste = Liste.OrderBy(x => x.Oncelik);
                            }
                            else if (SortField == "TahminiBitisTarih")
                            {
                                Liste = Liste.OrderBy(x => x.TahminiBitisTarih);
                            }
                            SortType = SortDirection.Descending;
                        }
                        else
                        {
                            if (SortField == "ID")
                            {
                                Liste = Liste.OrderByDescending(x => x.Firma);
                            }
                            else if (SortField == "Firma")
                            {
                                Liste = Liste.OrderByDescending(x => x.Firma);
                            }
                            else if (SortField == "Proje")
                            {
                                Liste = Liste.OrderByDescending(x => x.Proje);
                            }
                            else if (SortField == "Form")
                            {
                                Liste = Liste.OrderByDescending(x => x.Form);
                            }
                            else if (SortField == "Gorev")
                            {
                                Liste = Liste.OrderByDescending(x => x.Gorev);
                            }
                            else if (SortField == "Sorumlu")
                            {
                                Liste = Liste.OrderByDescending(x => x.Sorumlu);
                            }
                            else if (SortField == "Durum")
                            {
                                Liste = Liste.OrderByDescending(x => x.Durum);
                            }
                            else if (SortField == "Oncelik")
                            {
                                Liste = Liste.OrderByDescending(x => x.Oncelik);
                            }
                            else if (SortField == "TahminiBitisTarih")
                            {
                                Liste = Liste.OrderByDescending(x => x.TahminiBitisTarih);
                            }
                            SortType = SortDirection.Ascending;
                        }
                    }
                    #endregion SORTING İŞLEMİ * SON

                    gridGorev.DataSource = Liste;
                    gridGorev.EditIndex = editIndex;
                    gridGorev.DataBind();

                    kayitAdet += Liste.Count();

                    if (kayitAdet > 0)
                       Session["SonKayitID"] = Liste.Max(x => x.ID);
                      
                }

                ///Bu kodla pager kısmı sürekli gözüküyor...
                if (gridGorev != null)
                {
                    GridViewRow pagerRow = (GridViewRow)gridGorev.BottomPagerRow;
                    if (pagerRow != null)
                    {
                        pagerRow.Visible = true;
                    }
                }

                ScriptManager.RegisterStartupScript(this, typeof(string), "open", "ToplamKayit(" + kayitAdet + ");", true); 
            }
            catch (Exception hata)
            {
                MesajVer(hata: hata);
            }
        }

        int InsertGorev(Gorevler gorev)
        {
            int insertID = 0;
            using (GorevDataDataContext Context = new GorevDataDataContext(Global.ConStr))
            {
               
                Context.GetTable<Gorevler>().InsertOnSubmit(gorev);
                Context.SubmitChanges();

                insertID = gorev.ID;

                try
                {
                    if (Session["EkDosyalar"].IsNotNullEmpty())
                    {
                        List<EkDosya> EkDosyaList = Session["EkDosyalar"] as List<EkDosya>;
                        EkDosya ekdos;
                        foreach (var item in EkDosyaList)
                        {
                            ekdos = new EkDosya();
                            ekdos.DosyaAdi = item.DosyaAdi;
                            ekdos.GorevID = gorev.ID;
                            ekdos.Kaydeden = Global.Kullanici.KulKodu;
                            ekdos.KayitTarih = DateTime.Now;
                            Context.GetTable<EkDosya>().InsertOnSubmit(ekdos);

                        }
                        Context.SubmitChanges();
                        Session["EkDosyalar"] = null;

                        ///Temp klasörü varsa yeni kaydın görevID sini klasör olarak belirtiyorum.
                        if (Directory.Exists(Server.MapPath("UploadFiles/GorevFiles/Temp/")))
                        {
                            Directory.Move(Server.MapPath("UploadFiles/GorevFiles/Temp/"), Server.MapPath("UploadFiles/GorevFiles/" + insertID + "/"));
                        }
                    }
                }
                catch (Exception ex)
                {
                    Session["EkDosyalar"] = null;
                    throw ex;
                }

                #region Mail Gönderimi
                if (gorev.Sorumlu.IsNotNullEmptyTrim('-') && txtTahBitTarih.Text.IsNullEmpty())
                {
                    EMail eMail = new EMail();

                    string mail = (from ver in Context.Kullanicis
                                    where ver.KulKodu == gorev.Sorumlu
                                    select ver).FirstOrDefault().Email.ToString2();

                    if (gorev.Sorumlu2.IsNotNullEmptyTrim('-'))
                    {
                        string mail2 = (from ver in Context.Kullanicis
                                        where ver.KulKodu == gorev.Sorumlu2
                                        select ver).FirstOrDefault().Email.ToString2();

                        mail += ";" + mail2;

                        if (gorev.Sorumlu3.IsNotNullEmptyTrim('-'))
                        {
                            string mail3 = (from ver in Context.Kullanicis
                                            where ver.KulKodu == gorev.Sorumlu3
                                            select ver).FirstOrDefault().Email.ToString2();

                            mail += ";" + mail3;
                        }
                    }


                    StreamReader SR = new StreamReader(Server.MapPath("~/Classes/MailSablon/GorevAtandi.html"));
                    string mesajIcerik = SR.ReadToEnd();
                    mesajIcerik = string.Format(mesajIcerik, gorev.Sorumlu, gorev.Firma, gorev.Proje, gorev.Form, gorev.Gorev, gorev.Aciklama);

                    Ayar ayar = (from ver in Context.Ayars
                                    select ver).FirstOrDefault();

                    if (ayar.IsNotNull())
                    {
                        if (ayar.MailCcTumunde.ToBool())
                        {
                            eMail.MailCc = ayar.MailCc;
                        }
                    }

                    eMail.MailTo = mail;
                    eMail.Baslik = "Yeni Görev Atandı";
                    eMail.Icerik = mesajIcerik;
                    eMail.Kaydeden = Global.Kullanici.KulKodu;
                    eMail.KayitTarih = DateTime.Now;

                    Context.EMails.InsertOnSubmit(eMail);
                    Context.SubmitChanges();
                    
                }
                #endregion 

            }
            return insertID;
        }

        void UpdateGorev(Gorevler upGorev, int grvID,short yetki=-1)
        {
            using (GorevDataDataContext Context = new GorevDataDataContext(Global.ConStr))
            {
                short ilkDurum = -5;
                string ilkSorumlu = "";
                Gorevler gorev = Context.GetTable<Gorevler>().Where(x => x.ID == grvID).SingleOrDefault();

                gorev.Firma = upGorev.Firma;
                gorev.Proje = upGorev.Proje;
                gorev.Form = upGorev.Form;
                gorev.Gorev = upGorev.Gorev;
                gorev.Aciklama = upGorev.Aciklama;

                if (yetki == 3)  ///3->Admin
                {
                    ilkSorumlu = gorev.Sorumlu;
                    gorev.Sorumlu = upGorev.Sorumlu;
                    gorev.Sorumlu2 = upGorev.Sorumlu2;
                    gorev.Sorumlu3 = upGorev.Sorumlu3;

                    if (upGorev.Durum == 7) //7->Onaylandı ise
                        gorev.BitisTarih = DateTime.Now;
                }
 
                ilkDurum = gorev.Durum;
                gorev.Durum = upGorev.Durum;
                gorev.TahminiBitisTarih = upGorev.TahminiBitisTarih;
                gorev.Degistiren = Global.Kullanici.KulKodu;
                gorev.DegisTarih = DateTime.Now;
                gorev.DurumAciklama = upGorev.DurumAciklama;
                gorev.Oncelik = upGorev.Oncelik;

                Context.SubmitChanges();

                try
                {
                    if (Session["EkDosyalar"].IsNotNullEmpty())
                    {
                        List<EkDosya> EkDosyaList = Session["EkDosyalar"] as List<EkDosya>;
                        EkDosya ekdos;
                        foreach (var item in EkDosyaList)
                        {
                            ekdos = new EkDosya();
                            ekdos.DosyaAdi = item.DosyaAdi;
                            ekdos.GorevID = item.GorevID;
                            ekdos.Kaydeden = Global.Kullanici.KulKodu;
                            ekdos.KayitTarih = DateTime.Now;
                            Context.GetTable<EkDosya>().InsertOnSubmit(ekdos);
                        }
                        Context.SubmitChanges();
                        Session["EkDosyalar"] = null;
                    }
                }
                catch (Exception ex)
                {
                    Session["EkDosyalar"] = null;
                    throw ex;
                }
              
                #region Mail Gönderimi
                if (gorev.Sorumlu.IsNotNullEmptyTrim('-'))
                {
                    EMail eMail = new EMail();

                    Ayar ayar = (from ver in Context.Ayars
                                 select ver).FirstOrDefault();

                    if (ayar.IsNotNull())
                    {
                        eMail.MailTo = ayar.MailTo;

                        if (ayar.MailCcTumunde.ToBool())
                        {     
                            eMail.MailCc = ayar.MailCc;
                        }
                    }
        
                    if (gorev.Durum == 6 && ilkDurum != gorev.Durum)
                    {
                        StreamReader SR = new StreamReader(Server.MapPath("~/Classes/MailSablon/GorevBitti.html"));
                        string mesajIcerik = SR.ReadToEnd();
                        mesajIcerik = string.Format(mesajIcerik, gorev.Sorumlu, gorev.Firma, gorev.Proje, gorev.Form, gorev.Gorev, gorev.Aciklama,gorev.DurumAciklama);
                        //Mail.Gonder(new MailType("Görev Tamamlandı", mesajIcerik, "o.berkli@12mconsulting.com.tr"));

                        string sorumlular = gorev.Sorumlu;

                        if (gorev.Sorumlu2.IsNotNullEmpty())
                            sorumlular += "," + gorev.Sorumlu2;

                        if (gorev.Sorumlu3.IsNotNullEmpty())
                            sorumlular += "," + gorev.Sorumlu3;

                        eMail.Baslik = string.Format("{0} {1} {2} Görev Tamamlandı", sorumlular, gorev.Proje, gorev.Form);
                        eMail.Icerik = mesajIcerik;
                        eMail.Kaydeden = Global.Kullanici.KulKodu;
                        eMail.KayitTarih = DateTime.Now;

                        Context.EMails.InsertOnSubmit(eMail);
                        Context.SubmitChanges();
                    }
                    else if (gorev.Durum == 8 && ilkDurum != gorev.Durum)
                    {
                        string mail = (from ver in Context.Kullanicis
                                       where ver.KulKodu == gorev.Sorumlu
                                       select ver).FirstOrDefault().Email.ToString2();

                        if (gorev.Sorumlu2.IsNotNullEmptyTrim('-'))
                        {
                            string mail2 = (from ver in Context.Kullanicis
                                            where ver.KulKodu == gorev.Sorumlu2
                                            select ver).FirstOrDefault().Email.ToString2();

                            mail += ";" + mail2;

                            if (gorev.Sorumlu3.IsNotNullEmptyTrim('-'))
                            {
                                string mail3 = (from ver in Context.Kullanicis
                                                where ver.KulKodu == gorev.Sorumlu3
                                                select ver).FirstOrDefault().Email.ToString2();

                                mail += ";" + mail3;
                            }
                        }

         
                        StreamReader SR = new StreamReader(Server.MapPath("~/Classes/MailSablon/GorevReddedildi.html"));
                        string mesajIcerik = SR.ReadToEnd();
                        mesajIcerik = string.Format(mesajIcerik, gorev.Sorumlu, gorev.Firma, gorev.Proje, gorev.Form, 
                                                    gorev.Gorev, gorev.Aciklama, gorev.DurumAciklama);

                        eMail.MailTo = mail;
                        eMail.Baslik = "Görev Reddedildi !";
                        eMail.Icerik = mesajIcerik;
                        eMail.Kaydeden = Global.Kullanici.KulKodu;
                        eMail.KayitTarih = DateTime.Now;

                        Context.EMails.InsertOnSubmit(eMail);
                        Context.SubmitChanges();                    
                    }

                    if (ilkSorumlu!=gorev.Sorumlu && gorev.Sorumlu.Trim() == "OB")
                    {
                        string durum = ddlistDurum.SelectedItem.ToString2();
                        StreamReader SR = new StreamReader(Server.MapPath("~/Classes/MailSablon/GorevAdminBilgi.html"));
                        string mesajIcerik = SR.ReadToEnd();
                        mesajIcerik = string.Format(mesajIcerik, Global.Kullanici.KulKodu, gorev.Sorumlu, gorev.Firma, gorev.Proje, 
                                                    gorev.Form, gorev.Gorev, gorev.Aciklama, durum, gorev.DurumAciklama);

                        eMail.Baslik = "Görev Admin Bilgi";
                        eMail.Icerik = mesajIcerik;
                        eMail.Kaydeden = Global.Kullanici.KulKodu;
                        eMail.KayitTarih = DateTime.Now;

                        Context.EMails.InsertOnSubmit(eMail);
                        Context.SubmitChanges();

                    }
                }
                #endregion 
                
            }
        }

        void DeleteGorev(int grvID)
        {
            using (DataContext Context = Global.DBContext)
            {
                Gorevler gorev = Context.GetTable<Gorevler>().Where(x => x.ID == grvID).SingleOrDefault();
                Context.GetTable<Gorevler>().DeleteOnSubmit(gorev);
                Context.SubmitChanges();
            }
        }
        #endregion  Data İşlemleri SON

        #region Grid Metotlar
        protected void GridPaging(object sender, GridViewPageEventArgs e)
        {
            pnlHata.Visible = false;
            pnlBasarili.Visible = false;
            gridGorev.PageIndex = e.NewPageIndex;
            GetData();
        }

        protected void gridGorev_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                GorevlerEx gorev = (GorevlerEx)e.Row.DataItem;

                #region Durumlara Göre Renklendirme
                if (gorev.Durum == 1) ///Atandı
                {
                    e.Row.BackColor = System.Drawing.Color.FromArgb(255, 190, 190, 255);
                }
                else if (gorev.Durum == 2) ///Başlandı
                {
                    //e.Row.CssClass = "ClsMavi";
                    e.Row.BackColor = System.Drawing.Color.FromArgb(255, 190, 190, 255);
                    e.Row.Cells[11].BackColor = System.Drawing.Color.FromArgb(255, 0, 170, 0);
                    e.Row.Cells[11].ForeColor = System.Drawing.Color.White;
                }
                else if (gorev.Durum == 4) ///Kalite Kontrol
                {
                    e.Row.BackColor = System.Drawing.Color.FromArgb(255, 190, 190, 255);
                    e.Row.Cells[11].BackColor = System.Drawing.Color.FromArgb(255, 43, 24, 200);
                    e.Row.Cells[11].ForeColor = System.Drawing.Color.White;
                }
                else if (gorev.Durum == 8) ///Reddedildi.
                {
                    e.Row.BackColor = System.Drawing.Color.FromArgb(255, 190, 190, 255);
                    e.Row.Cells[11].BackColor = System.Drawing.Color.Red;
                    e.Row.Cells[11].ForeColor = System.Drawing.Color.White;
                }
                else if (gorev.Durum == 3)  ///Onay Ver
                {
                    e.Row.BackColor = System.Drawing.Color.FromArgb(255, 240, 235, 145);
                    e.Row.Cells[11].BackColor = System.Drawing.Color.IndianRed;
                    e.Row.Cells[11].ForeColor = System.Drawing.Color.White;
                }
                else if (gorev.Durum == 5) ///Beklemede
                {
                    e.Row.BackColor = System.Drawing.Color.FromArgb(255, 240, 235, 145);
                }
                else if (gorev.Durum == 6) ///Bitti
                {
                    e.Row.BackColor = System.Drawing.Color.FromArgb(255, 160, 220, 170);
                }
                else if (gorev.Durum == 7) ///Onaylandı
                {
                    e.Row.BackColor = System.Drawing.Color.FromArgb(255, 0, 220, 170);
                }
                else if (gorev.Durum == 9) ///Durduruldu
                {
                    e.Row.BackColor = System.Drawing.Color.Gray;
                }
                #endregion Durumlara Göre Renklendirme Son

                ///Son girilen satırı kalın kırmızıyla çiziyoruz.. 
                if (gorev.ID == Session["SonKayitID"].ToInt32() + 1)
                {
                    e.Row.BorderWidth = 4;
                    e.Row.BorderColor = System.Drawing.Color.Red;
                }

                ///Tahmini Bitiş Tarihi Girilmeyenleri griye boyuyoruz..
                //if (gorev.TahminiBitisTarih.IsNullEmpty())
                //{
                //    e.Row.Cells[8].BackColor = System.Drawing.Color.Gray;
                //}

                ///Sorumlusu Girilmeyenleri griye boyuyoruz..
                if (gorev.Sorumlu.IsNullEmpty())
                {
                    e.Row.Cells[9].BackColor = System.Drawing.Color.Gray;
                }

                ///Onceliği acil olanları açık kırmızıya boyuyoruz..
                if (gorev.Oncelik == 2)
                {
                    e.Row.Cells[10].BackColor = System.Drawing.Color.IndianRed;
                    e.Row.Cells[10].ForeColor = System.Drawing.Color.White;
                }
      
                
            }   
        }     

        protected void gridGorev_DataBinding(object sender, EventArgs e)
        {
            /*Bu Metod içeriği boş olmasına rağmen literal mesajları tetiklemek için kullanılıyor*/
        }
        #endregion Grid Metotlar SON

        #region Görev Genel İşlemler
        protected void YeniKayit(object sender, EventArgs e)
        {
            pnlBasarili.Visible = false;
            pnlHata.Visible = false;

            ///--  Firefox İçin Ekstradan Yazılan Kodlar  ----------------------------------------------------//
            //mPopup.Show();
            //ScriptManager.RegisterStartupScript(this, typeof(string), "open", "ShowPopup_YeniKayit();", true);
            ///-----------------------------------------------------------------------------------------------//
        }
        
        protected void Duzenle(object sender, EventArgs e)
        { 
            pnlBasarili.Visible = false;
            pnlHata.Visible = false;
            //ddlistFirma2.Visible = true;
            //txtMusteriFirma.Visible = false;

        }

        protected void SiraVer(object sender, EventArgs e)
        {
            pnlBasarili.Visible = false;
            pnlHata.Visible = false;

            int yetki = hfYetkiKodu.Value.ToInt32();
            if (yetki != 3)  ///Admin-> 3 sadece işlem sırasını değiştirebilir..
                return;
            
            if (gridGorev.EditIndex > -1)
            {
                ///Kayıt işlemi
                GridViewRow Row = gridGorev.Rows[gridGorev.EditIndex];
                int ID = ((Label)Row.FindControl("labID")).Text.ToInt32();
                int? IslemSira = ((TextBox)Row.FindControl("txtIslemSira")).Text.ToInt32Null();

                if (IslemSira.IsNotNull() && IslemSira < 1)
                    IslemSira = null;


                using (GorevDataDataContext Context = new GorevDataDataContext(Global.ConStr))
                {
                    Gorevler grv = Context.Gorevlers.Where(x => x.ID == ID).FirstOrDefault();
                    if (grv.IsNotNull())
                    {
                        Context.Gorevi_YenidenSirala(grv.Sorumlu, grv.ID, grv.IslemSira, IslemSira, false);
                    }
                }

                GetData(FirmaGetir: false, SorumluGetir: false, DurumGetir: false);          
            }
            else
            {
                int rowIndex = ((ImageButton)sender).CommandArgument.ToInt32(-1);
                GetData(editIndex: rowIndex, FirmaGetir: false, SorumluGetir: false, DurumGetir: false);  
            }
            
        }

        public string SorumluFormatla(string Sorumlu, string Sorumlu2, string Sorumlu3)
        {
            string Sorumlular = "";
            if (Sorumlu.IsNotNullEmptyTrim('-'))
            {
                Sorumlular = Sorumlu.ToString2();

                if (Sorumlu2.IsNotNullEmptyTrim('-'))
                {
                    Sorumlular += "," + Sorumlu2.ToString2();

                    if (Sorumlu3.IsNotNullEmptyTrim('-'))
                    {
                        Sorumlular += "," + Sorumlu3.ToString2();                        
                    }               
                }                
            }
            return Sorumlular;
        }

        protected void btnKaydet_Click(object sender, EventArgs e)
        {
            try
            {
                short Yetki = Global.Kullanici.YetkiKod.ToShort(-1);
                int KeyID = hfkeyID.Value.ToInt32();
         
                Gorevler gorev = new Gorevler();

                if (Yetki == 3) ///3->Admin
                {
                    gorev.Firma = ddlistFirma.SelectedValue.Trim2('-');
                    gorev.Proje = ddlistProje.SelectedItem.ToString2().Trim2('-');
                    gorev.Form = ddlistForm.SelectedItem.ToString2().Trim2('-');
                    gorev.Gorev = txtGorev.Text.Trim2();
                    gorev.Aciklama = txtAciklama.Text.Trim2();
                    gorev.Sorumlu = ddlistSorumlu.SelectedValue;
                    gorev.Sorumlu2 = ddlistSorumlu2.SelectedValue;
                    gorev.Sorumlu3 = ddlistSorumlu3.SelectedValue;

                    gorev.Durum = ddlistDurum.SelectedValue.ToShort();
                    gorev.TahminiBitisTarih = txtTahBitTarih.Text.ToDatetimeNull();
                    gorev.DurumAciklama = txtDurumAciklama.Text.Trim2();
                    gorev.Oncelik = ddlistOncelik.SelectedValue.ToShort();

                    gorev.Kaydeden = Global.Kullanici.KulKodu;
                    gorev.KayitTarih = DateTime.Now;
                    gorev.Degistiren = Global.Kullanici.KulKodu;
                    gorev.DegisTarih = DateTime.Now;

                    if (gorev.Durum == 7) //7->Onaylandı ise
                        gorev.BitisTarih = DateTime.Now;

                    if (gorev.Sorumlu2.Trim2('-').IsNotNullEmpty() && gorev.Sorumlu.Trim2('-').IsNullEmpty())
                    {
                        MesajVer(Global.MesajTip.Uyari, Mesaj: "Sorumlu-1 girilmeden Sorumlu-2 girilemez !");
                        return;
                    }
                    else if (gorev.Sorumlu3.Trim2('-').IsNotNullEmpty() && gorev.Sorumlu.Trim2('-').IsNullEmpty())
                    {
                        MesajVer(Global.MesajTip.Uyari, Mesaj: "Sorumlu-1 girilmeden Sorumlu-3 girilemez !");
                        return;
                    }
                    else if (gorev.Sorumlu3.Trim2('-').IsNotNullEmpty() && gorev.Sorumlu2.Trim2('-').IsNullEmpty())
                    {
                        MesajVer(Global.MesajTip.Uyari, Mesaj: "Sorumlu-2 girilmeden Sorumlu-3 girilemez !");
                        return;
                    }
                }
                else if (Yetki == 1) ///1->Customer
                {
                    gorev.Firma = txtFirmaCus.Text.Trim();
                    gorev.Proje = ddlistProjeCus.SelectedItem.ToString2().Trim2('-');
                    gorev.Form = ddlistFormCus.SelectedItem.ToString2().Trim2('-');
                    gorev.Gorev = txtGorevCus.Text.Trim2();
                    gorev.Aciklama = txtAciklamaCus.Text.Trim2();

                    gorev.Durum = 3;  //3->Onay Ver
                    gorev.TahminiBitisTarih = txtTahBitTarihCus.Text.ToDatetimeNull();
                    gorev.DurumAciklama = txtDurumAciklamaCus.Text.Trim2();
                    gorev.Oncelik = ddlistOncelikCus.SelectedValue.ToShort();


                    gorev.Kaydeden = Global.Kullanici.KulKodu;
                    gorev.KayitTarih = DateTime.Now;
                    gorev.Degistiren = Global.Kullanici.KulKodu;
                    gorev.DegisTarih = DateTime.Now;
                }
                else
                {
                    gorev.Firma = ddlistFirma2.SelectedValue.Trim2('-');
                    gorev.Proje = ddlistProje2.SelectedItem.ToString2().Trim2('-');
                    gorev.Form = ddlistForm2.SelectedItem.ToString2().Trim2('-');
                    gorev.Gorev = txtGorev2.Text.Trim2();
                    gorev.Aciklama = txtAciklama2.Text.Trim2();

                    gorev.Durum = ddlistDurum2.SelectedValue.ToShort();
                    gorev.TahminiBitisTarih = txtTahBitTarih2.Text.ToDatetimeNull();
                    gorev.DurumAciklama = txtDurumAciklama2.Text.Trim2();
                    gorev.Oncelik = ddlistOncelik2.SelectedValue.ToShort();


                    gorev.Kaydeden = Global.Kullanici.KulKodu;
                    gorev.KayitTarih = DateTime.Now;
                    gorev.Degistiren = Global.Kullanici.KulKodu;
                    gorev.DegisTarih = DateTime.Now;
                }

                
                /// Yeni Kayıt  
                if (KeyID == 0)
                {
                    if (Methods.NullEmptyKontrol(gorev.Firma,gorev.Proje,gorev.Form,gorev.Gorev,gorev.Aciklama))
                    {
                        InsertGorev(gorev); /// Burda mail tablosuna da yazıyor..                                 
                        MesajVer(Global.MesajTip.Bilgi);
                        ScriptManager.RegisterStartupScript(this, typeof(string), "open", "PopupTemizle(0);", true);
                        GetData(FirmaGetir: false, SorumluGetir: false, DurumGetir:false);
                    }
                    else
                    {
                        MesajVer(Global.MesajTip.Uyari, Mesaj: "Firma,Proje,Form, Görev ve Açıklama alanları zorunludur boş geçilemez !");
                    }
                }
                ///  Mevcut Kaydın Güncellenmesi
                else if (KeyID > 0)
                {
                    UpdateGorev(gorev, KeyID, Yetki);
                    ScriptManager.RegisterStartupScript(this, typeof(string), "open", "DurumTemizle();", true);
                    MesajVer(Global.MesajTip.Bilgi);                   
                    GetData(FirmaGetir: false, SorumluGetir: false, DurumGetir: false);
                }

            }
            catch (Exception ex)
            {                
                MesajVer(hata: ex);
            }
            
        }

        protected void btnSil_Click(object sender, EventArgs e)
        {
            try
            {
                short Yetki = Global.Kullanici.YetkiKod.ToShort(-1);

                int KeyID = hfkeyID.Value.ToInt32();

                if (Yetki >= 3) ///Admin -> 3
                {
                    if (KeyID > 0)
                    {
                        DeleteGorev(KeyID);
                        GetData(FirmaGetir: false, SorumluGetir: false);
                        MesajVer(Global.MesajTip.Bilgi);
                        mPopup.Hide();
                    }
                    else
                    {
                        MesajVer(Global.MesajTip.Uyari, Mesaj: "Silinecek görevi seçmediniz ! Lütfen tekrar deneyin..");
                    }
                }
                else
                {
                    MesajVer(Global.MesajTip.Uyari, Mesaj: "Görev silme yetkiniz yok !!");
                }
               
            }
            catch (Exception ex)
            {
                MesajVer(hata: ex);
            }

        }

        /// Ek Dosyaların upload edildiği metod
        protected void AsyncFileUpload_UploadedComplete(object sender, AjaxControlToolkit.AsyncFileUploadEventArgs e)
        {
            string klasor = "Temp";
            if (hfkeyID.Value.ToInt32() != 0)
                klasor = hfkeyID.Value;

            if (!Directory.Exists(Server.MapPath("UploadFiles/GorevFiles/" + klasor + "/")))
            {
                Directory.CreateDirectory(Server.MapPath("UploadFiles/GorevFiles/" + klasor + "/"));
            }

            string filename = System.IO.Path.GetFileName(AsyncFileUpload1.FileName);

            AsyncFileUpload1.SaveAs(Server.MapPath("UploadFiles/GorevFiles/" + klasor + "/") + filename);

            EkDosya dosya = new EkDosya();
            dosya.GorevID = hfkeyID.Value.ToInt32();
            dosya.DosyaAdi = filename;

            if (Session["EkDosyalar"].IsNull())
            {
                Session["EkDosyalar"] = new List<EkDosya>();
            }
            (Session["EkDosyalar"] as List<EkDosya>).Add(dosya); 
        }

        /// Ek Dosyaların upload edildiği metod
        protected void AsyncFileUpload2_UploadedComplete(object sender, AjaxControlToolkit.AsyncFileUploadEventArgs e)
        {
            string klasor = "Temp";
            if (hfkeyID.Value.ToInt32() != 0)
                klasor = hfkeyID.Value;

            if (!Directory.Exists(Server.MapPath("UploadFiles/GorevFiles/" + klasor + "/")))
            {
                Directory.CreateDirectory(Server.MapPath("UploadFiles/GorevFiles/" + klasor + "/"));
            }

            string filename = System.IO.Path.GetFileName(AsyncFileUpload2.FileName);

            AsyncFileUpload2.SaveAs(Server.MapPath("UploadFiles/GorevFiles/" + klasor + "/") + filename);

            EkDosya dosya = new EkDosya();
            dosya.GorevID = hfkeyID.Value.ToInt32();
            dosya.DosyaAdi = filename;

            if (Session["EkDosyalar"].IsNull())
            {
                Session["EkDosyalar"] = new List<EkDosya>();
            }
            (Session["EkDosyalar"] as List<EkDosya>).Add(dosya);
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

        /// Bu Timer Gridin Width özelliğini düzeltebilmek için kullanıldı.
        protected void timerGenel_Tick(object sender, EventArgs e)
        {
            timerGenel.Enabled = false;
            ///Bu timer bir kereliğine çalışacak sadece Gridin Width özelliğini düzeltebilmek için kullandım.
       
            if (!Page.IsPostBack)
            {
                gridGorev.Width = 1025;          
            }
            else
            {
                //mPopup.Dispose();
            }
        }
   
        protected void ddlistFirma_SelectedIndexChanged(object sender, EventArgs e)
        {
            try
            {
                if (ddlistFirma.SelectedValue.Trim2('-').IsNullEmpty())
                    return;
              
                using (GorevDataDataContext Context = new GorevDataDataContext(Global.ConStr))
                {
                    IQueryable<ProjeForm> ProjeBaslik = (from pro in Context.ProjeForms
                                                         where pro.Firma == ddlistFirma.SelectedValue && pro.PID == 0
                                                         orderby pro.Proje ascending
                                                         select pro);
                    ddlistProje.DataSource = ProjeBaslik;
                    ddlistProje.DataTextField = "Proje";
                    ddlistProje.DataValueField = "Proje";
                    ddlistProje.DataBind();
                    ddlistProje.Items.Insert(0, new ListItem("-"));
                    if (hProje.Value == "")
                        hProje.Value = "-";
                    ddlistProje.Items.FindByText(hProje.Value).Selected = true;


                    IQueryable<ProjeForm> FormList = (from pro in Context.ProjeForms
                                                      where pro.Firma == ddlistFirma.SelectedValue &&
                                                            pro.Proje == hProje.Value && pro.PID != 0
                                                      orderby pro.Form ascending
                                                      select pro);
                    ddlistForm.DataSource = FormList;
                    ddlistForm.DataTextField = "Form";
                    ddlistForm.DataValueField = "Form";
                    ddlistForm.DataBind();
                    ddlistForm.Items.Insert(0, new ListItem("-"));
                    if (hForm.Value == "")
                        hForm.Value = "-";
                    ddlistForm.Items.FindByText(hForm.Value).Selected = true;
                   
                }
                ScriptManager.RegisterStartupScript(this, typeof(string), "open", "SetSelectedProject()", true);
                pnlBasarili.Visible = false;
                pnlHata.Visible = false;
              
            }
            catch (Exception ex)
            {
                MesajVer(hata: ex);
            }
        }

        protected void ddlistProje_SelectedIndexChanged(object sender, EventArgs e)
        {
            try
            {
                if (ddlistFirma.SelectedValue.Trim2('-').IsNullEmpty())
                    return;

                using (GorevDataDataContext Context = new GorevDataDataContext(Global.ConStr))
                {
                    IQueryable<ProjeForm> FormList = (from pro in Context.ProjeForms
                                                      where pro.Firma == ddlistFirma.SelectedValue &&
                                                            pro.Proje == ddlistProje.SelectedValue && pro.PID != 0
                                                      orderby pro.Form ascending
                                                      select pro);
                    ddlistForm.DataSource = FormList;
                    ddlistForm.DataTextField = "Form";
                    ddlistForm.DataValueField = "Form";
                    ddlistForm.DataBind();
                    ddlistForm.Items.Insert(0, new ListItem("-"));
                    if (hForm.Value == "")
                        hForm.Value = "-";
                    ddlistForm.Items.FindByText(hForm.Value).Selected = true;
                }
                ScriptManager.RegisterStartupScript(this, typeof(string), "open", "SetSelectedForm()", true);
                pnlBasarili.Visible = false;
                pnlHata.Visible = false;
               
            }
            catch (Exception ex)
            {
                MesajVer(hata: ex);
            }
        }

        protected void ddlistFirma2_SelectedIndexChanged(object sender, EventArgs e)
        {
            try
            {
                if (ddlistFirma2.SelectedValue.Trim2('-').IsNullEmpty())
                    return;

                int Yetki = hfYetkiKodu.Value.ToInt32();

                if (Yetki == 1)
                {
                    ddlistFirma2.Visible = false;
                    //txtMusteriFirma.Visible = true;
                    //txtMusteriFirma.Text = ddlistFirma2.SelectedValue;
                }

                using (GorevDataDataContext Context = new GorevDataDataContext(Global.ConStr))
                {
                    IQueryable<ProjeForm> ProjeBaslik = (from pro in Context.ProjeForms
                                                         where pro.Firma == ddlistFirma2.SelectedValue && pro.PID == 0
                                                         orderby pro.Proje ascending
                                                         select pro);
                    ddlistProje2.DataSource = ProjeBaslik;
                    ddlistProje2.DataTextField = "Proje";
                    ddlistProje2.DataValueField = "Proje";
                    ddlistProje2.DataBind();
                    ddlistProje2.Items.Insert(0, new ListItem("-"));
                    if (hProje2.Value == "")
                        hProje2.Value = "-";
                    ddlistProje2.Items.FindByText(hProje.Value).Selected = true;


                    IQueryable<ProjeForm> FormList = (from pro in Context.ProjeForms
                                                      where pro.Firma == ddlistFirma2.SelectedValue &&
                                                            pro.Proje == hProje2.Value && pro.PID != 0
                                                      orderby pro.Form ascending
                                                      select pro);
                    ddlistForm2.DataSource = FormList;
                    ddlistForm2.DataTextField = "Form";
                    ddlistForm2.DataValueField = "Form";
                    ddlistForm2.DataBind();
                    ddlistForm2.Items.Insert(0, new ListItem("-"));
                    try
                    {
                        if (hForm2.Value == "")
                            hForm2.Value = "-";
                        ddlistForm2.Items.FindByText(hForm2.Value).Selected = true;
                    }
                    catch { /*Bişey yapma*/ }

                }
                ScriptManager.RegisterStartupScript(this, typeof(string), "open", "SetSelectedProject2()", true);
                pnlBasarili.Visible = false;
                pnlHata.Visible = false;

            }
            catch (Exception ex)
            {
                MesajVer(hata: ex);
            }
        }

        protected void ddlistProje2_SelectedIndexChanged(object sender, EventArgs e)
        {
            try
            {
                if (ddlistFirma2.SelectedValue.Trim2('-').IsNullEmpty())
                    return;

                using (GorevDataDataContext Context = new GorevDataDataContext(Global.ConStr))
                {
                    IQueryable<ProjeForm> FormList = (from pro in Context.ProjeForms
                                                      where pro.Firma == ddlistFirma2.SelectedValue &&
                                                            pro.Proje == ddlistProje2.SelectedValue && pro.PID != 0
                                                      orderby pro.Form ascending
                                                      select pro);
                    ddlistForm2.DataSource = FormList;
                    ddlistForm2.DataTextField = "Form";
                    ddlistForm2.DataValueField = "Form";
                    ddlistForm2.DataBind();
                    ddlistForm2.Items.Insert(0, new ListItem("-"));

                    if (hForm2.Value == "")
                        hForm2.Value = "-";
                    ddlistForm2.Items.FindByText(hForm2.Value).Selected = true;
                }
                ScriptManager.RegisterStartupScript(this, typeof(string), "open", "SetSelectedForm2()", true);
                pnlBasarili.Visible = false;
                pnlHata.Visible = false;

            }
            catch (Exception ex)
            {
                MesajVer(hata: ex);
            }
        }

        protected void ddlistSorumlu_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (ddlistSorumlu.SelectedValue.Trim2('-').IsNullEmpty())
            {
                ScriptManager.RegisterStartupScript(this, typeof(string), "open", "SetSelectedDurum('0')", true);
            }
            else
            {
                ScriptManager.RegisterStartupScript(this, typeof(string), "open", "SetSelectedDurum('1')", true);
            }
        }
        #endregion Görev Genel İşlemler SON

        #region Çalışma Ekle Metodları
        protected void CalismaEkleyiAc(object sender, EventArgs e)
        {

            Session["CalismaID"] = 0;
            Session["BackupYuklendi"] = false;
            pnlBasarili.Visible = false;
            pnlHata.Visible = false;

        }

        protected void btnCalismaKaydet_Click(object sender, EventArgs e)
        {
            int gorevID = hfcGorevID.Value.ToInt32();
            try
            {
                if (gorevID > 0)
                {
                    GorevCalisma gorevCalis = new GorevCalisma();
                    gorevCalis.GorevID = gorevID;
                    gorevCalis.Sorumlular = txtcSorumlu.Text.Trim2('-');
                    gorevCalis.Calisma = txtcCalisma.Text.Trim2();
                    gorevCalis.Tarih1 = txtcTarih.Text.ToDatetime();
                    gorevCalis.CalismaSure = txtcSure.Text.ToInt32();

                    if (Methods.NullEmptyKontrol(gorevCalis.Sorumlular, gorevCalis.Calisma, gorevCalis.Tarih1, gorevCalis.CalismaSure))
                    {
                        if (Session["BackupYuklendi"].IsNullEmpty())
                            Session["BackupYuklendi"] = false;

                        if (Session["BackupYuklendi"].ToBool())
                        {
                            using (GorevDataDataContext Context = new GorevDataDataContext(Global.ConStr))
                            {
                                if (Session["CalismaID"].ToInt32() == 0) /// Insert
                                {
                                    gorevCalis.Kaydeden = Global.Kullanici.KulKodu;
                                    gorevCalis.KayitTarih = DateTime.Now;
                                    gorevCalis.Degistiren = Global.Kullanici.KulKodu;
                                    gorevCalis.DegisTarih = DateTime.Now;

                                    Context.GorevCalismas.InsertOnSubmit(gorevCalis);
                                    Context.SubmitChanges();
                                    Session["CalismaID"] = gorevCalis.ID;
                                }
                                else  /// Update
                                {
                                    GorevCalisma gorCalis = Context.GorevCalismas.Where(x => x.ID == Session["CalismaID"].ToInt32()).FirstOrDefault();
                                    if (gorCalis.IsNotNull())
                                    {
                                        gorCalis.Calisma = gorevCalis.Calisma;
                                        gorCalis.CalismaSure = gorevCalis.CalismaSure;
                                        gorCalis.Tarih1 = gorevCalis.Tarih1;
                                        gorCalis.Tarih2 = gorevCalis.Tarih2;
                                        gorCalis.Degistiren = Global.Kullanici.KulKodu;
                                        gorCalis.DegisTarih = DateTime.Now;
                                        Context.SubmitChanges();
                                    }
                                }
                            }
                            MesajVer(Global.MesajTip.Bilgi);
                        }
                        else
                        {
                            MesajVer(Global.MesajTip.Uyari, Mesaj: "Proje yedeklemesi zorunludur !");
                        }
                    }
                    else
                    {
                        MesajVer(Global.MesajTip.Uyari, Mesaj: "Sorumlu, Çalışma, İlk Tarih ve Süre alanları zorunludur boş geçilemez !");
                    }
                }
            }
            catch (Exception ex)
            {
                MesajVer(hata: ex);
            }
        }
        #endregion Çalışma Ekle Metodları SON

        #region Dürbün Metodları
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
                    ddlDProje.Items.Insert(0, new ListItem("Tümü (*)","*"));
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
                Kullanici Kul = Global.Kullanici;
                using (GorevDataDataContext Context = new GorevDataDataContext(Global.ConStr))
                {
                    if (Kul.YetkiKod != 1) //1->Customer
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
                    else
                    {
                        IQueryable<ProjeForm> FormList = (from pro in Context.ProjeForms
                                                          where pro.Firma == Kul.Firma &&
                                                                pro.Proje == ddlDProje.SelectedValue && pro.PID != 0
                                                          orderby pro.Form ascending
                                                          select pro);
                        ddlDForm.DataSource = FormList;
                        ddlDForm.DataTextField = "Form";
                        ddlDForm.DataValueField = "Form";
                        ddlDForm.DataBind();
                        ddlDForm.Items.Insert(0, new ListItem("Tümü (*)", "*"));
                    }
                }
                pnlBasarili.Visible = false;
                pnlHata.Visible = false;
            }
            catch (Exception ex)
            {
                MesajVer(hata: ex);
            }
        }

        public class GorevFiltre
        {
            public string Sorumlu { get; set; }
            public bool AsliSorumlu { get; set; }
            public bool YedekSorumlu { get; set; }
            public string Firma { get; set; }
            public string Proje { get; set; }
            public string Form { get; set; }
            public string Gorev { get; set; }
            public string Aciklama { get; set; }
            public short Durum { get; set; }
            public DateTime? KayitTarihi1 { get; set; }
            public DateTime? KayitTarihi2 { get; set; }
            public DateTime? TahBitisTarihi1 { get; set; }
            public DateTime? TahBitisTarihi2 { get; set; }
            public short GenelDurumlar { get; set; }
        }

        protected void btnDurbunGorevGetir_Click(object sender, EventArgs e)
        {
            try
            {
                GetData(FirmaGetir: false, SorumluGetir: false, DurumGetir: false);
            }
            catch(Exception ex)
            {
                MesajVer(hata: ex);
            }
        }
        #endregion Dürbün Metodları SON

        #region Grid Sorting
        protected void gridGorev_Sorting(object sender, GridViewSortEventArgs e)
        {
            try
            {
                GetData(FirmaGetir: false, SorumluGetir: false, DurumGetir: false, Sorting: true, SortField: e.SortExpression);
            }
            catch (Exception hata)
            {
                MesajVer(hata: hata);
            }
        }

        public SortDirection SortType
        {
            get
            {
                if (ViewState["Sort"] == null)
                {
                    ViewState["Sort"] = SortDirection.Ascending;
                }
                return (SortDirection)ViewState["Sort"];
            }
            set
            {
                ViewState["Sort"] = value;
            }
        }
        #endregion Grid Sorting SON

        #region ProjeForm Eklenmesi
        void GetProjeForm(int editIndex = -1, bool FirmaGetir = true, bool ProjeGetir = true, bool FormGetir = true, string Firma = null, string Proje = null, int pID = 0)
        {
            using (GorevDataDataContext Context = new GorevDataDataContext(Global.ConStr))
            {

                if (FirmaGetir)
                {
                    List<FirmaMin> MusteriList = (from musteri in Context.Musteris
                                                  where musteri.FID == 0
                                                  orderby musteri.Firma ascending
                                                  select new FirmaMin { ID = musteri.ID, Firma = musteri.Firma }).ToList();
                    //ddlFirma.DataSource = MusteriList;
                    //ddlFirma.DataTextField = "Firma";
                    //ddlFirma.DataValueField = "Firma";
                    //ddlFirma.DataBind();
                    //ddlFirma.Items.Insert(0, new ListItem("-"));
                }
                if (ProjeGetir)
                {
                    IQueryable<ProjeForm> ProjeBaslik = (from pro in Context.ProjeForms
                                                         where pro.Firma == Firma && pro.PID == 0
                                                         orderby pro.Proje ascending
                                                         select pro);
                    //ddlProje.DataSource = ProjeBaslik;
                    //ddlProje.DataTextField = "Proje";
                    //ddlProje.DataValueField = "ID";
                    //ddlProje.DataBind();
                    //ddlProje.Items.Insert(0, new ListItem("-"));
                }
                if (FormGetir)
                {
                    IQueryable<ProjeForm> FormList = (from pro in Context.ProjeForms
                                                      where pro.Firma == Firma && pro.PID == pID
                                                      orderby pro.ID descending
                                                      select pro);
                    //ddlForm.DataSource = FormList;
                    //ddlForm.DataTextField = "Form";
                    //ddlForm.DataValueField = "ID";
                    //ddlForm.DataBind();
                    //ddlForm.Items.Insert(0, new ListItem("-"));
                }

            }

        }

        protected void btnProjeEkleyiAc_Click(object sender, ImageClickEventArgs e)
        {         
            //string firma = ddlistFirma.SelectedValue;
            //ddlFirma.Items.FindByValue(firma).Selected = true;
            //mPopupProjeForm.Show();
        }

        protected void btnFormEkleyiAc_Click(object sender, ImageClickEventArgs e)
        {
            //string proje= ddlistProje.SelectedItem.ToString2();
            //ddlProje.Items.FindByText(proje).Selected = true;
            //mPopupProjeForm.Show();
            //ScriptManager.RegisterStartupScript(this, typeof(string), "open", "SelectedProje()", true);
        }

        protected void btnProjeFormKaydet_Click(object sender, EventArgs e)
        {
            try
            {
                using (GorevDataDataContext Context = new GorevDataDataContext(Global.ConStr))
                {

                    ProjeForm addProje = new ProjeForm();

                    if (!txtFormPanel.Visible) ///Yeni Proje tanımlanacaksa
                    {
                        addProje.Firma = txtFirma.Text.Trim2();
                        addProje.Proje = txtProje.Text.Trim2();
                        addProje.Form = "";
                        addProje.PID = 0;  //PID 0 ise proje başlığı demektir.
                        addProje.Kaydeden = Global.Kullanici.KulKodu;
                        addProje.KayitTarih = DateTime.Now;

                        if (addProje.Firma.IsNullEmpty() || addProje.Proje.IsNullEmpty())
                        {
                            MesajVer(Global.MesajTip.Uyari, Mesaj: "Firma ve Proje Adı zorunlu alandır. Boş geçilemez !");
                            return;
                        }

                        Context.GetTable<ProjeForm>().InsertOnSubmit(addProje);
                        Context.SubmitChanges();
                        GetProjeForm(FirmaGetir: false, Firma: addProje.Firma, FormGetir: false);
                        txtProje.Text = "";

                    }
                    else  ///Yeni Form Tanımlanacaksa
                    {
                        addProje.Firma = txtFirma.Text.Trim2();
                        addProje.Proje = txtProje.Text.Trim2();

                        ProjeForm pForm = Context.ProjeForms.Where(x => x.Firma == addProje.Firma && x.Proje == addProje.Proje && x.PID == 0).FirstOrDefault();

                        if (pForm.IsNotNullEmpty())
                        {
                            addProje.Form = txtForm.Text.Trim2();
                            addProje.PID = pForm.ID;
                            addProje.Kaydeden = Global.Kullanici.KulKodu;
                            addProje.KayitTarih = DateTime.Now;

                            if (addProje.Firma.IsNullEmpty() || addProje.Proje.IsNullEmpty() || addProje.Form.IsNullEmpty())
                            {
                                MesajVer(Global.MesajTip.Uyari, Mesaj: "Firma,Proje ve Form Adı zorunlu alandır. Boş geçilemez !");
                                return;
                            }

                            Context.GetTable<ProjeForm>().InsertOnSubmit(addProje);
                            Context.SubmitChanges();
                            GetProjeForm(FirmaGetir: false, ProjeGetir: false, Firma: addProje.Firma, Proje: addProje.Proje, pID: addProje.PID.ToInt32());
                            txtForm.Text = "";
                        }
                    }

                    MesajVer(Global.MesajTip.Bilgi);

                }
            }
            catch (Exception ex)
            {
                MesajVer(hata: ex);
            }
        }

        protected void btnPopupKapat_Click(object sender, EventArgs e)
        {
            mPopupProjeForm.Hide();
        }

        protected void ddlProje_SelectedIndexChanged(object sender, EventArgs e)
        {
            //GetProjeForm(FirmaGetir: false, ProjeGetir: false, Firma: ddlFirma.SelectedValue, Proje: ddlProje.SelectedItem.ToString2().Trim2('-'), pID: ddlProje.SelectedValue.ToInt32());
            //ScriptManager.RegisterStartupScript(this, typeof(string), "open", "chkFormCheck();", true);
        }
        #endregion ProjeForm Eklenmesi SON

        #region Klavuz ve Ekdosya
        protected void gridEkDosya_DataBinding(object sender, EventArgs e)
        {

        }
  
        protected void btnDokumanSil_Click(object sender, ImageClickEventArgs e)
        {

        }
        #endregion Klavuz ve Ekdosya SON

        protected void btnProjeEklemeyiAc_Click(object sender, EventArgs e)
        { 
            txtFormPanel.Visible = false;
            txtProje.ReadOnly = false;
            txtProje.Text = "";
            txtFirma.Text = ddlistFirma.SelectedValue;
            mPopupProjeForm.Show();
        }

        protected void btnFormEklemeyiAc_Click(object sender, EventArgs e)
        {
            txtFormPanel.Visible = true;
            txtProje.ReadOnly = true;
            txtFirma.Text = ddlistFirma.SelectedValue;
            txtProje.Text = ddlistProje.SelectedValue;  
            mPopupProjeForm.Show();
        }

        protected void AsyncFileUploadProjeBackup_UploadedComplete(object sender, AsyncFileUploadEventArgs e)
        {
            try
            {
                using (GorevDataDataContext Context = new GorevDataDataContext(Global.ConStr))
                {
                    string firma = hfcFirma.Value.Trim2();
                    string proje = hfcProje.Value.Trim2();

                    ProjeForm Proje = Context.ProjeForms.Where(x => x.Firma == firma && x.Proje == proje && x.PID == 0).FirstOrDefault();

                    if (Proje.IsNotNullEmpty())
                    {
                        if (!Directory.Exists(Server.MapPath("UploadFiles/ProjeBackup/PB" + Proje.ID.ToString() + "/")))
                        {
                            Directory.CreateDirectory(Server.MapPath("UploadFiles/ProjeBackup/PB" + Proje.ID.ToString() + "/"));
                        }

                        string filename = System.IO.Path.GetFileName(AsyncFileUploadProjeBackup.FileName);
                        filename = string.Format("{0:yyMMddHHmmss}", DateTime.Now) + " - " + filename;

                        AsyncFileUploadProjeBackup.SaveAs(Server.MapPath("UploadFiles/ProjeBackup/PB" + Proje.ID.ToString() + "/") + filename);

                        EkDosya ekdosya = new EkDosya();
                        ekdosya.Tip = 2;
                        ekdosya.DosyaAdi = filename;
                        ekdosya.Boyut = BoyutHesapla(e.FileSize.ToDouble());
                        ekdosya.GorevID = Proje.ID;
                        ekdosya.Kaydeden = Global.Kullanici.KulKodu;
                        ekdosya.KayitTarih = DateTime.Now;
                        Context.EkDosyas.InsertOnSubmit(ekdosya);
                        Context.SubmitChanges();
                        Session["BackupYuklendi"] = true;
                    }
                    else
                    {
                        MesajVer(mtip: Global.MesajTip.Uyari, Mesaj: "Yüklenecek proje belirtilmemiş !");
                    }
                }
            }
            catch (Exception ex)
            {
                MesajVer(hata: ex);
            }
        }

        public string BoyutHesapla(double deger)
        {
            string birim = "KB";
            deger = deger / 1024;
            if (deger > 1024)
            {
                deger = deger / 1024;
                birim = "MB";
            }
            if (deger > 1024)
            {
                deger = deger / 1024;
                birim = "GB";
            }
            deger = Math.Round(deger, 2);
            return deger.ToString() + " " + birim;
        }


        protected void AsyncFileUploadCus_UploadedComplete(object sender, AsyncFileUploadEventArgs e)
        {
            string klasor = "Temp";
            if (hfkeyID.Value.ToInt32() != 0)
                klasor = hfkeyID.Value;

            if (!Directory.Exists(Server.MapPath("UploadFiles/GorevFiles/" + klasor + "/")))
            {
                Directory.CreateDirectory(Server.MapPath("UploadFiles/GorevFiles/" + klasor + "/"));
            }

            string filename = System.IO.Path.GetFileName(AsyncFileUploadCus.FileName);

            AsyncFileUploadCus.SaveAs(Server.MapPath("UploadFiles/GorevFiles/" + klasor + "/") + filename);

            EkDosya dosya = new EkDosya();
            dosya.GorevID = hfkeyID.Value.ToInt32();
            dosya.DosyaAdi = filename;

            if (Session["EkDosyalar"].IsNull())
            {
                Session["EkDosyalar"] = new List<EkDosya>();
            }
            (Session["EkDosyalar"] as List<EkDosya>).Add(dosya);
        }

        protected void ddlistProjeCus_SelectedIndexChanged(object sender, EventArgs e)
        {
            try
            {
                if (txtFirmaCus.Text.IsNullEmpty())
                    return;

                using (GorevDataDataContext Context = new GorevDataDataContext(Global.ConStr))
                {
                    IQueryable<ProjeForm> FormList = (from pro in Context.ProjeForms
                                                      where pro.Firma == txtFirmaCus.Text.Trim() &&
                                                            pro.Proje == ddlistProjeCus.SelectedValue && pro.PID != 0
                                                      orderby pro.Form ascending
                                                      select pro);
                    ddlistFormCus.DataSource = FormList;
                    ddlistFormCus.DataTextField = "Form";
                    ddlistFormCus.DataValueField = "Form";
                    ddlistFormCus.DataBind();
                    ddlistFormCus.Items.Insert(0, new ListItem("-"));
                    if (hFormCus.Value == "")
                        hFormCus.Value = "-";
                    ddlistFormCus.Items.FindByText(hFormCus.Value).Selected = true;
                }
                ScriptManager.RegisterStartupScript(this, typeof(string), "open", "SetSelectedFormCus()", true);
                pnlBasarili.Visible = false;
                pnlHata.Visible = false;

            }
            catch (Exception ex)
            {
                MesajVer(hata: ex);
            }
        }


    }
}