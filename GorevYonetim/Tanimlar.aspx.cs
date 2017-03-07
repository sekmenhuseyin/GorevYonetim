using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.Linq;
using GorevYonetim.App_Data;
using System.Collections.Specialized;
using AjaxControlToolkit;
using System.IO;
using System.Web.Services;
using System.Web.Script.Serialization;

namespace GorevYonetim
{
    public partial class Tanimlar : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Page.IsPostBack)
            {
                PageType = (TanimType)Request.QueryString["tip"].ToInt32();
                // Aşağıdaki textBox(gizlidir) sadece PageType değerini JQuery tarafında alabilmek için kullanıldı.
                txtPageType.Text = Request.QueryString["tip"].ToString2();
                GetData(PageType);               
            }
        }

        public TanimType PageType = TanimType.None;
        public enum TanimType
        {
            None = -1, Kullanici = 0, Musteri = 1, Sorumlu = 2, Proje = 3, ProjeForm = 4
        }

        [WebMethod]
        public static EkDosyaEx[] DokumanGetir(int ProjeID)
        {
            try
            {
                using (GorevDataDataContext Context = new GorevDataDataContext(Global.ConStr))
                {
                    List<EkDosyaEx> EkDosyaList = new List<EkDosyaEx>();

                    EkDosyaList = Context.EkDosyas.Where(x => x.GorevID == ProjeID && x.Tip == 1).Select(x => new EkDosyaEx
                    {
                        ID = x.ID,
                        GorevID = x.GorevID,
                        Aciklama = x.Aciklama,
                        DosyaAdi = x.DosyaAdi,
                        Kaydeden = x.Kaydeden,
                        KayitTarih = x.KayitTarih,
                        KayitTarihStr = KayitTarihFormatla(x.KayitTarih),
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
        public static EkDosyaEx[] BackupGetir(int ProjeID)
        {
            try
            {
                using (GorevDataDataContext Context = new GorevDataDataContext(Global.ConStr))
                {
                    List<EkDosyaEx> EkDosyaList = new List<EkDosyaEx>();

                    EkDosyaList = Context.EkDosyas.Where(x => x.GorevID == ProjeID && x.Tip == 2).Select(x => new EkDosyaEx
                    {
                        ID = x.ID,
                        GorevID = x.GorevID,
                        Aciklama = x.Aciklama,
                        DosyaAdi = x.DosyaAdi,
                        Kaydeden = x.Kaydeden,
                        KayitTarih = x.KayitTarih,
                        KayitTarihStr = KayitTarihFormatla(x.KayitTarih),
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

        static string KayitTarihFormatla(DateTime? date)
        {
            return string.Format("{0:dd.MM.yyyy - hh:mm}", date);
        }


        #region Getting Data
        void GetData(TanimType type, int editIndex = -1)
        {
            try
            {
                
                switch (type)
                {
                    case TanimType.Kullanici:
                        GetKullanici(editIndex);
                        break;
                    case TanimType.Musteri:
                        GetMusteri(editIndex);
                        break;
                    case TanimType.Sorumlu:
                        GetSorumlu(editIndex);
                        break;
                    case TanimType.Proje:
                        GetProje(editIndex);
                        break;
                    case TanimType.ProjeForm:
                        GetProjeForm(editIndex);
                        break;
                    default:
                        break;
                }

                using (GorevDataDataContext Context = new GorevDataDataContext(Global.ConStr))
                {
                    List<FirmaMin> MusteriList = (from musteri in Context.Musteris
                                                  where musteri.FID == 0
                                                  orderby musteri.Firma ascending
                                                  select new FirmaMin { ID = musteri.ID, Firma = musteri.Firma }).ToList();
                    ddlFirma.DataSource = MusteriList;
                    ddlFirma.DataTextField = "Firma";
                    ddlFirma.DataValueField = "Firma";
                    ddlFirma.DataBind();
                    ddlFirma.Items.Insert(0, new ListItem("-"));
                }

                if (type == TanimType.Proje)
                {
                    ScriptManager.RegisterStartupScript(this, typeof(string), "open", "UpPanelProjeAcKapa(1);", true);
                }
                else
                {
                    ScriptManager.RegisterStartupScript(this, typeof(string), "open", "UpPanelProjeAcKapa(0);", true);
                }
               
            }
            catch (Exception hata)
            {
                MesajVer(hata: hata);
            }
        }

        void GetKullanici(int editIndex = -1)
        {
            using (GorevDataDataContext Context = new GorevDataDataContext(Global.ConStr))
            {
                List<KullaniciEx> KullaniciList = (from kullanici in Context.Kullanicis
                                                 orderby kullanici.ID descending
                                                 select new KullaniciEx
                                                 {
                                                     ID = kullanici.ID,
                                                     KulKodu = kullanici.KulKodu,
                                                     AdSoyad = kullanici.AdSoyad,
                                                     Pass = kullanici.Pass,
                                                     YetkiKod = kullanici.YetkiKod,
                                                     Email = kullanici.Email,
                                                     Firma = kullanici.Firma,
                                                     Kod = (short)kullanici.YetkiKod
                                                 }).ToList();

                if (KullaniciList.Count < 1)
                {
                    KullaniciList.Add(new KullaniciEx());
                }

                gridKullanici.DataSource = KullaniciList;
                gridKullanici.EditIndex = editIndex;
                gridKullanici.DataBind();
            }

            ///Bu kodla pager kısmı sürekli gözüküyor...
            if (gridKullanici != null)
            {
                GridViewRow pagerRow = (GridViewRow)gridKullanici.BottomPagerRow;
                if (pagerRow != null)
                {
                    pagerRow.Visible = true;
                }
            }

        }

        void GetMusteri(int editIndex = -1)
        {
            using (GorevDataDataContext Context = new GorevDataDataContext(Global.ConStr))
            {
                List<Musteri> MusteriList = (from musteri in Context.Musteris
                                             where musteri.FID == 0
                                             orderby musteri.Firma ascending
                                             select musteri).ToList();

                if (MusteriList.Count < 1)
                {
                    MusteriList.Add(new Musteri());
                }

                gridMusteri.DataSource = MusteriList;
                gridMusteri.EditIndex = editIndex;
                gridMusteri.DataBind();
            }

            ///Bu kodla pager kısmı sürekli gözüküyor...
            if (gridMusteri != null)
            {
                GridViewRow pagerRow = (GridViewRow)gridMusteri.BottomPagerRow;
                if (pagerRow != null)
                {
                    pagerRow.Visible = true;
                }
            }
        }

        public bool BoolConvert(object deger)
        {
            if (deger == null)
                return false;
            else
                return deger.ToBool();
        }

        void GetSorumlu(int editIndex = -1)
        {
            using (GorevDataDataContext Context = new GorevDataDataContext(Global.ConStr))
            {
                List<Musteri> SorumluList = (from sorumlu in Context.Musteris
                                             where sorumlu.FID != 0
                                             orderby sorumlu.ID descending
                                             select sorumlu).ToList();

                if (SorumluList.Count < 1)
                {
                    SorumluList.Add(new Musteri());
                }

                gridSorumlu.DataSource = SorumluList;
                gridSorumlu.EditIndex = editIndex;
                gridSorumlu.DataBind();
            }

            ///Bu kodla pager kısmı sürekli gözüküyor...
            if (gridSorumlu != null)
            {
                GridViewRow pagerRow = (GridViewRow)gridSorumlu.BottomPagerRow;
                if (pagerRow != null)
                {
                    pagerRow.Visible = true;
                }
            }
        }

        void GetProje(int editIndex = -1, bool FirmaSorumluGetir=true, string Firma="Tumu", string Proje="Tumu", string Sorumlu="Tumu", string KarsiSorumlu="Tumu")
        {
            using (GorevDataDataContext Context = new GorevDataDataContext(Global.ConStr))
            {
                if (Firma.Trim2('-') == "")
                    Firma = "Tumu";
                if (Proje.Trim2('-') == "")
                    Proje = "Tumu";
                if (Sorumlu.Trim2('-') == "")
                    Sorumlu = "Tumu";
                if (KarsiSorumlu.Trim2('-') == "")
                    KarsiSorumlu = "Tumu";

                List<ProjeFormEx> ProjeList = (from proje in Context.ProjeForms
                                               where proje.PID == 0 &&
                                               (Firma == "Tumu" ? true : proje.Firma == Firma) &&
                                               (Proje == "Tumu" ? true : proje.Proje == Proje) &&
                                               (Sorumlu == "Tumu" ? true : proje.Sorumlu == Sorumlu) &&
                                               (KarsiSorumlu == "Tumu" ? true : proje.KarsiSorumlu.Contains(KarsiSorumlu))
                                               select new ProjeFormEx
                                               {
                                                   ID = proje.ID,
                                                   Firma = proje.Firma,
                                                   Proje = proje.Proje,
                                                   Form = proje.Form,
                                                   Aciklama = proje.Aciklama,
                                                   Durum = proje.Durum,
                                                   KarsiSorumlu = proje.KarsiSorumlu,
                                                   Sorumlu = proje.Sorumlu,
                                                   PID = proje.PID,
                                                   MesaiKota = proje.MesaiKota,
                                                   MesaiKontrol = proje.MesaiKontrol

                                               }).ToList();

                if (ProjeList.Count < 1)
                {
                    ProjeList.Add(new ProjeFormEx());
                }

                gridProje.DataSource = ProjeList;
                gridProje.EditIndex = editIndex;
                gridProje.DataBind();


                if (FirmaSorumluGetir)
                {
                    List<FirmaMin> MusteriList = (from musteri in Context.Musteris
                                                  where musteri.FID == 0
                                                  orderby musteri.Firma ascending
                                                  select new FirmaMin { ID = musteri.ID, Firma = musteri.Firma }).ToList();
                    ddlfilterFirma.DataSource = MusteriList;
                    ddlfilterFirma.DataTextField = "Firma";
                    ddlfilterFirma.DataValueField = "Firma";
                    ddlfilterFirma.DataBind();
                    ddlfilterFirma.Items.Insert(0, new ListItem("-", "-"));

                    ///Sorumlular
                    IQueryable<Kullanici> listSorumlu = (from sorumlu in Context.Kullanicis
                                                         select sorumlu);
                    ddlfilterSorumlu.DataSource = listSorumlu;
                    ddlfilterSorumlu.DataTextField = "AdSoyad";
                    ddlfilterSorumlu.DataValueField = "KulKodu";
                    ddlfilterSorumlu.DataBind();
                    ddlfilterSorumlu.Items.Insert(0, new ListItem("-", "-"));
                }
             
            }

            ///Bu kodla pager kısmı sürekli gözüküyor...
            if (gridProje != null)
            {
                GridViewRow pagerRow = (GridViewRow)gridProje.BottomPagerRow;
                if (pagerRow != null)
                {
                    pagerRow.Visible = true;
                }
            }
        }

        void GetProjeForm(int editIndex = -1,bool FirmaGetir=true,bool ProjeGetir=true,bool FormGetir=true,string Firma=null,string Proje=null,int pID=0)
        {
            using (GorevDataDataContext Context=new GorevDataDataContext(Global.ConStr))
            {
                if (Firma == null && Proje == null)
                {
                    IQueryable<ProjeForm> ProjeTable = (from pro in Context.ProjeForms
                                                        orderby pro.ID descending
                                                        select pro).Take(50);
                    gridProjeForm.DataSource = ProjeTable;
                    gridProjeForm.EditIndex = editIndex;
                    gridProjeForm.DataBind();
                }
                else if (Proje == null)
                {
                    IQueryable<ProjeForm> ProjeTable = (from pro in Context.ProjeForms
                                                        where pro.Firma == Firma && pro.PID==0
                                                        orderby pro.ID descending
                                                        select pro).Take(50);
                    gridProjeForm.DataSource = ProjeTable;
                    gridProjeForm.EditIndex = editIndex;
                    gridProjeForm.DataBind();
                }
                else
                {
                    IQueryable<ProjeForm> ProjeTable = (from pro in Context.ProjeForms
                                                        where pro.Firma == Firma && pro.Proje==Proje
                                                        orderby pro.PID ascending, pro.ID descending                                                        
                                                        select pro).Take(50);

                    gridProjeForm.DataSource = ProjeTable;
                    gridProjeForm.EditIndex = editIndex;
                    gridProjeForm.DataBind();
                }


                if (FirmaGetir)
                {
                    List<FirmaMin> MusteriList = (from musteri in Context.Musteris
                                                  where musteri.FID == 0
                                                  orderby musteri.Firma ascending
                                                  select new FirmaMin { ID = musteri.ID, Firma = musteri.Firma }).ToList();
                    ddlFirma.DataSource = MusteriList;
                    ddlFirma.DataTextField = "Firma";
                    ddlFirma.DataValueField = "Firma";
                    ddlFirma.DataBind();
                    ddlFirma.Items.Insert(0, new ListItem("-"));
                }
                if (ProjeGetir)
                {
                    IQueryable<ProjeForm> ProjeBaslik = (from pro in Context.ProjeForms
                                                         where pro.Firma==Firma && pro.PID == 0
                                                         orderby pro.Proje ascending
                                                         select pro);
                    ddlProje.DataSource = ProjeBaslik;
                    ddlProje.DataTextField = "Proje";
                    ddlProje.DataValueField = "ID";
                    ddlProje.DataBind();
                    ddlProje.Items.Insert(0, new ListItem("-"));
                }
                if (FormGetir)
                {
                    IQueryable<ProjeForm> FormList = (from pro in Context.ProjeForms
                                                         where pro.Firma == Firma && pro.PID == pID
                                                         orderby pro.ID descending
                                                         select pro);
                    ddlForm.DataSource = FormList;
                    ddlForm.DataTextField = "Form";
                    ddlForm.DataValueField = "ID";
                    ddlForm.DataBind();
                    ddlForm.Items.Insert(0, new ListItem("-"));
                }
                                                    
            }

            ///Bu kodla pager kısmı sürekli gözüküyor...
            //if (gridProje != null)
            //{
            //    GridViewRow pagerRow = (GridViewRow)gridProje.BottomPagerRow;
            //    if (pagerRow != null)
            //    {
            //        pagerRow.Visible = true;
            //    }
            //}
        }
        #endregion /// Getting Data 

        #region Kullanıcı Grid Events
        protected void gridKullanici_RowEditing(object sender, GridViewEditEventArgs e)
        {
            pnlHata.Visible = false;
            pnlBasarili.Visible = false;
            GetData(TanimType.Kullanici, e.NewEditIndex);     
        }

        protected void gridKullanici_RowUpdating(object sender, GridViewUpdateEventArgs e)
        {
            try
            {
                using (DataContext Context = Global.DBContext)
                {
                    int kulID = gridKullanici.DataKeys[e.RowIndex].Value.ToInt32();
                    Kullanici updateKul = Context.GetTable<Kullanici>().Where(x => x.ID == kulID).SingleOrDefault();
                    updateKul.AdSoyad = ((TextBox)gridKullanici.Rows[e.RowIndex].FindControl("txtAdSoyad")).Text;
                    updateKul.KulKodu = ((TextBox)gridKullanici.Rows[e.RowIndex].FindControl("txtKulKodu")).Text;
                    updateKul.Email = ((TextBox)gridKullanici.Rows[e.RowIndex].FindControl("txtEmail")).Text;
                    updateKul.Pass = ((TextBox)gridKullanici.Rows[e.RowIndex].FindControl("txtParola")).Text;
                    updateKul.YetkiKod = ((DropDownList)gridKullanici.Rows[e.RowIndex].FindControl("ddlYetkiKod")).SelectedValue.ToShort();
                    updateKul.Firma = ((DropDownList)gridKullanici.Rows[e.RowIndex].FindControl("ddlFirma")).SelectedValue.ToString2();
                    updateKul.Degistiren = Global.Kullanici.KulKodu;
                    updateKul.DegisTarih = DateTime.Now;

                    if (Methods.NullEmptyKontrol(updateKul.AdSoyad, updateKul.KulKodu, updateKul.Pass, updateKul.YetkiKod, updateKul.Firma))
                    {
                        Context.SubmitChanges();
                        GetData(TanimType.Kullanici);
                        MesajVer(Global.MesajTip.Bilgi);
                    }
                    else
                    {
                        MesajVer(Global.MesajTip.Uyari, Mesaj: "Adı Soyadı, Kullanıcı Kodu, Parola, Yetki ve Firma alanları zorunludur ! Lütfen giriniz..");
                    }

                }              
            }
            catch (Exception hata)
            {
                MesajVer(hata: hata);
            }     
        }

        protected void gridKullanici_RowCancelingEdit(object sender, GridViewCancelEditEventArgs e)
        {
            GetData(TanimType.Kullanici, -1);
        }
        
        protected void gridKullanici_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if ((e.Row.RowType == DataControlRowType.DataRow && gridKullanici.EditIndex == e.Row.RowIndex) || e.Row.RowType == DataControlRowType.Footer)
            {
               
                try
                {                    
                    ///Popuptaki dropdownlistleri burda dolduruyoruz. 
                    DropDownList ddlSorumlu = (e.Row.FindControl("ddlYetkiKod") as DropDownList);
                    ddlSorumlu.DataSource = Yetki.YetkileriGetir();
                    ddlSorumlu.DataTextField = "Aciklama";
                    ddlSorumlu.DataValueField = "Kod";
                    ddlSorumlu.DataBind();
                    ddlSorumlu.Items.Insert(0, new ListItem("-"));
                    string sorumlu = (e.Row.FindControl("labYetkiKod") as Label).Text;
                    if (sorumlu.IsNotNullEmpty())
                        ddlSorumlu.Items.FindByValue(sorumlu).Selected = true;

                    DropDownList ddlFirma = (e.Row.FindControl("ddlFirma") as DropDownList);
                    using (GorevDataDataContext Context = new GorevDataDataContext(Global.ConStr))
                    {

                        List<FirmaMin> MusteriList = (from musteri in Context.Musteris
                                                      where musteri.FID == 0
                                                      orderby musteri.Firma ascending
                                                      select new FirmaMin { ID = musteri.ID, Firma = musteri.Firma }).ToList();

                        ddlFirma.DataSource = MusteriList;
                        ddlFirma.DataTextField = "Firma";
                        ddlFirma.DataValueField = "Firma";
                        ddlFirma.DataBind();
                        ddlFirma.Items.Insert(0, new ListItem("-", "-"));

                        string firma = (e.Row.FindControl("labFirma") as Label).Text;
                        if (firma.IsNotNullEmpty())
                            ddlFirma.Items.FindByValue(firma).Selected = true;
                    }

                }
                catch (Exception ex)
                {
                }

            }
        }

        protected void gridKullanici_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            pnlHata.Visible = false;
            pnlBasarili.Visible = false;
            gridKullanici.PageIndex = e.NewPageIndex;
            GetData(TanimType.Kullanici);
        }

        protected void gridKullanici_DataBinding(object sender, EventArgs e)
        {

        }

        protected void GridKullaniciInsert(object sender, EventArgs e)
        {
            try
            {
                using (DataContext Context = Global.DBContext)
                {
                    Kullanici addKullanici = new Kullanici();
                    addKullanici.AdSoyad = ((TextBox)gridKullanici.FooterRow.FindControl("txtAdSoyad")).Text;
                    addKullanici.KulKodu = ((TextBox)gridKullanici.FooterRow.FindControl("txtKulKodu")).Text;
                    addKullanici.Email = ((TextBox)gridKullanici.FooterRow.FindControl("txtEmail")).Text;
                    addKullanici.Pass = ((TextBox)gridKullanici.FooterRow.FindControl("txtParola")).Text;
                    addKullanici.YetkiKod = ((DropDownList)gridKullanici.FooterRow.FindControl("ddlYetkiKod")).SelectedValue.ToShort();
                    addKullanici.Firma = ((DropDownList)gridKullanici.FooterRow.FindControl("ddlFirma")).SelectedValue.ToString2();
                    addKullanici.Kaydeden = Global.Kullanici.KulKodu;
                    addKullanici.KayitTarih = DateTime.Now;
                    addKullanici.Degistiren = Global.Kullanici.KulKodu;
                    addKullanici.DegisTarih = DateTime.Now;

                    if (Methods.NullEmptyKontrol(addKullanici.AdSoyad, addKullanici.KulKodu, addKullanici.YetkiKod, addKullanici.Pass, addKullanici.Firma))
                    {
                        Context.GetTable<Kullanici>().InsertOnSubmit(addKullanici);
                        Context.SubmitChanges();
                        GetData(TanimType.Kullanici);
                        MesajVer(Global.MesajTip.Bilgi);
                    }
                    else
                    {
                        MesajVer(Global.MesajTip.Uyari, Mesaj: "Adı Soyadı, Kullanıcı Kodu, Parola, Yetki ve Firma alanları zorunludur ! Lütfen giriniz..");
                    }

                }
            }
            catch (Exception ex)
            {
                MesajVer(hata: ex);
            }
         
        }

        protected void GridKullaniciDelete(object sender, EventArgs e)
        {
            try
            {
                using (DataContext Context = Global.DBContext)
                {
                    if (Global.Kullanici.YetkiKod > 1)
                    {
                        ImageButton lnkRemove = (ImageButton)sender;
                        int kulID = lnkRemove.CommandArgument.ToInt32();
                        Kullanici silKul = Context.GetTable<Kullanici>().Where(x => x.ID == kulID).SingleOrDefault();

                        if (silKul.IsNotNull())
                        {
                            Context.GetTable<Kullanici>().DeleteOnSubmit(silKul);
                            Context.SubmitChanges();
                            GetData(TanimType.Kullanici);
                            MesajVer(Global.MesajTip.Bilgi);
                        }
                        else
                        {
                            MesajVer(Global.MesajTip.Uyari, Mesaj: "Kayıt bulunamadı !");
                        }
                    }
                    else
                    {
                        MesajVer(Global.MesajTip.Uyari, Mesaj: "Bu işlemi yapmaya yetkiniz yok !");
                    }

                }
            }
            catch (Exception hata)
            {
                MesajVer(hata: hata);
            }
        }
        #endregion /// Kullanıcı Grid Events

        #region Musteri Grid Events
        protected void gridMusteri_RowEditing(object sender, GridViewEditEventArgs e)
        {
            pnlHata.Visible = false;
            pnlBasarili.Visible = false;
            GetData(TanimType.Musteri, e.NewEditIndex);
        }

        protected void gridMusteri_RowCancelingEdit(object sender, GridViewCancelEditEventArgs e)
        {
            GetData(TanimType.Musteri, -1);
        }

        protected void gridMusteri_RowDataBound(object sender, GridViewRowEventArgs e)
        {

        }

        protected void gridMusteri_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            pnlHata.Visible = false;
            pnlBasarili.Visible = false;
            gridMusteri.PageIndex = e.NewPageIndex;
            GetData(TanimType.Musteri);
        }

        protected void gridMusteri_DataBinding(object sender, EventArgs e)
        {

        }

        protected void gridMusteri_RowUpdating(object sender, GridViewUpdateEventArgs e)
        {
            try
            {
                using (GorevDataDataContext Context=new GorevDataDataContext(Global.ConStr))
                {

                    int firmaID = gridMusteri.DataKeys[e.RowIndex].Value.ToInt32();
                    Musteri updateFirma = Context.Musteris.Where(x => x.ID == firmaID).SingleOrDefault();
                    string onceFirma = updateFirma.Firma;
                    updateFirma.Firma = ((TextBox)gridMusteri.Rows[e.RowIndex].FindControl("txtFirmaKodu")).Text;
                    updateFirma.Unvan = ((TextBox)gridMusteri.Rows[e.RowIndex].FindControl("txtFirmaAdi")).Text;
                    updateFirma.Aciklama = ((TextBox)gridMusteri.Rows[e.RowIndex].FindControl("txtAciklama")).Text;
                    updateFirma.Tarih = ((TextBox)gridMusteri.Rows[e.RowIndex].FindControl("txtTarih")).Text.ToDatetimeNull();
                    updateFirma.MesaiKontrol = ((CheckBox)gridMusteri.Rows[e.RowIndex].FindControl("chkMesaiKontrol")).Checked;
                    updateFirma.MesaiKota = ((TextBox)gridMusteri.Rows[e.RowIndex].FindControl("txtMesaiKota")).Text.ToInt32Null();

                    if(updateFirma.MesaiKontrol.ToBool() && (updateFirma.MesaiKota.IsNull() || updateFirma.MesaiKota.ToInt32()==0))
                    {
                        throw new Exception("Mesai Kontrolü seçili olduğu halde girilen kota değeri uygun değil !");
                    }

                    updateFirma.Degistiren = Global.Kullanici.KulKodu;
                    updateFirma.DegisTarih = DateTime.Now;
                    string sonraFirma = updateFirma.Firma;
                    ///ProjeForm tablosunda bu firma kayıtlarını güncelle
                    var projeFormlari = Context.ProjeForms.Where(x => x.Firma == onceFirma);
                    foreach (var item in projeFormlari)
                    {
                        item.Firma = sonraFirma;
                    }

                    ///Bu firmayla ilgili hareket tablosunda kayıt varsa onları da değiştir.
                    var gorevHareketler = Context.GorevHarekets.Where(x => x.Firma == onceFirma);
                    foreach (var item in gorevHareketler)
                    {
                        item.Firma = sonraFirma;
                    }

                    ///Bu projeyle ilgili oluşturulmuş görevler varsa onlara da uygulansın
                    var gorevler = Context.Gorevlers.Where(x => x.Firma == onceFirma);
                    foreach (var item in gorevler)
                    {
                        item.Firma = sonraFirma;
                        ///Trigger da işlem yapmasın ve gereksiz hareket 
                        ///oluşturmasın diye IslemTipine 1 atıyorum..
                        item.IslemTip = 1;
                    }

                    if (Methods.NullEmptyKontrol(updateFirma.Firma, updateFirma.Unvan))
                    {
                        Context.SubmitChanges();
                        GetData(TanimType.Musteri);
                        MesajVer(Global.MesajTip.Bilgi);
                    }
                    else
                    {
                        MesajVer(Global.MesajTip.Uyari, Mesaj: "Firma Kodu ve Firma Ünvan alanları zorunlu alanlardır. Boş geçilemez !");
                    }
                }
            }
            catch (Exception hata)
            {
                MesajVer(hata: hata);
            }
        }

        protected void GridMusteriInsert(object sender, EventArgs e)
        {
            try
            {
                using (DataContext Context = Global.DBContext)
                {
                    Musteri addFirma = new Musteri();
                    addFirma.Firma = ((TextBox)gridMusteri.FooterRow.FindControl("txtFirmaKodu")).Text;
                    addFirma.Unvan = ((TextBox)gridMusteri.FooterRow.FindControl("txtFirmaAdi")).Text;
                    addFirma.Tarih = ((TextBox)gridMusteri.FooterRow.FindControl("txtTarih")).Text.ToDatetimeNull();
                    addFirma.Aciklama = ((TextBox)gridMusteri.FooterRow.FindControl("txtAciklama")).Text;
                    addFirma.MesaiKontrol = ((CheckBox)gridMusteri.FooterRow.FindControl("chkMesaiKontrol")).Checked;
                    addFirma.MesaiKota = ((TextBox)gridMusteri.FooterRow.FindControl("txtMesaiKota")).Text.ToInt32Null();

                    if (addFirma.MesaiKontrol.ToBool() && (addFirma.MesaiKota.IsNull() || addFirma.MesaiKota.ToInt32() == 0))
                    {
                        throw new Exception("Mesai Kontrolü seçili olduğu halde girilen kota değeri uygun değil !");
                    }
                    
                    addFirma.FID = 0; //FID 0 ise Firma başlık bilgisi demektir.
                    addFirma.Kaydeden = Global.Kullanici.KulKodu;
                    addFirma.KayitTarih = DateTime.Now;
                    addFirma.Degistiren = Global.Kullanici.KulKodu;
                    addFirma.DegisTarih = DateTime.Now;

                    if (Methods.NullEmptyKontrol(addFirma.Firma, addFirma.Unvan))
                    {
                        Context.GetTable<Musteri>().InsertOnSubmit(addFirma);
                        Context.SubmitChanges();
                        GetData(TanimType.Musteri);
                        MesajVer(Global.MesajTip.Bilgi); 
                    }
                    else
                    {
                        MesajVer(Global.MesajTip.Uyari, Mesaj: "Firma Kodu ve Firma Ünvan alanları zorunlu alanlardır. Boş geçilemez !");  
                    }
                }
            }
            catch (Exception ex)
            {
                MesajVer(hata: ex);
            }
        }

        protected void GridMusteriDelete(object sender, EventArgs e)
        {
            try
            {
                using (DataContext Context = Global.DBContext)
                {
                    if (Global.Kullanici.YetkiKod > 1)
                    {
                        ImageButton lnkRemove = (ImageButton)sender;
                        int firmaID = lnkRemove.CommandArgument.ToInt32();
                        Musteri silFirma = Context.GetTable<Musteri>().Where(x => x.ID == firmaID).SingleOrDefault();
                        if (silFirma.IsNotNull())
                        {
                            bool varmi = Context.GetTable<Gorevler>().Where(x => x.Firma == silFirma.Firma).Any();

                            if (varmi == false)
                            {
                                Context.GetTable<Musteri>().DeleteOnSubmit(silFirma);
                                Context.SubmitChanges();
                                GetData(TanimType.Musteri);
                                MesajVer(Global.MesajTip.Bilgi);
                            }
                            else
                            {
                                MesajVer(Global.MesajTip.Uyari, Mesaj: "Bu Firmaya ait görevler olduğu için silinemez !");
                                return;
                            }

                        }
                        else
                        {
                            MesajVer(Global.MesajTip.Uyari, Mesaj: "Kayıt bulunamadı !");
                        }
                    }
                    else
                    {
                        MesajVer(Global.MesajTip.Uyari, Mesaj: "Bu işlemi yapmaya yetkiniz yok !");
                    }
                }
            }
            catch (Exception hata)
            {
                MesajVer(hata: hata);
            }
        }
        #endregion /// Musteri Grid Events

        #region ProjeForm ALL METHODS
        protected void gridProjeForm_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            Firma = ddlFirma.SelectedValue;
            pnlHata.Visible = false;
            pnlBasarili.Visible = false;
            gridProjeForm.PageIndex = e.NewPageIndex;

            if (!Firma.IsNotNullEmptyTrim('-'))
            {
                GetData(TanimType.ProjeForm);
            }
            else
            {
                Proje = ddlProje.SelectedItem.ToString2().Trim2('-');
                PID = ddlProje.SelectedValue.ToInt32();
                GetProjeForm(FirmaGetir: false, ProjeGetir: false, Firma: Firma, Proje: Proje, pID: PID);
                ScriptManager.RegisterStartupScript(this, typeof(string), "open", "chkFormCheck();", true);
            }
        }

        protected void gridProjeForm_DataBinding(object sender, EventArgs e)
        {

        }

        protected void gridProjeForm_RowEditing(object sender, GridViewEditEventArgs e)
        {
            pnlHata.Visible = false;
            pnlBasarili.Visible = false;

            ProjeForm_Getir(e.NewEditIndex);
            
        }

        protected void gridProjeForm_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                ProjeForm pform = (ProjeForm)e.Row.DataItem;

                if (pform.PID == 0)
                {
                    e.Row.BackColor = System.Drawing.Color.FromArgb(255, 160, 192, 202);
                    e.Row.ForeColor = System.Drawing.Color.Black;
                    e.Row.Font.Bold = true;
                    //e.Row.BorderWidth = 2;
                    //e.Row.BorderColor = System.Drawing.Color.FromArgb(255,40,40,40);
                }
            }
        }

        protected void gridProjeForm_RowCancelingEdit(object sender, GridViewCancelEditEventArgs e)
        {
            ProjeForm_Getir();
        }

        void ProjeForm_Getir(int editIndex=-1)
        {
            if (Firma.IsNotNullEmpty() && Proje.IsNotNullEmpty())
            {
                GetProjeForm(editIndex, Firma: Firma, Proje: Proje);
            }
            else if (Firma.IsNotNullEmpty())
            {
                GetProjeForm(editIndex, Firma: Firma);
            }
            else
            {
                GetProjeForm(editIndex);
            }
        }

        protected void gridProjeForm_RowUpdating(object sender, GridViewUpdateEventArgs e)
        {
            try
            {
                using (GorevDataDataContext Context = new GorevDataDataContext(Global.ConStr))
                {

                    int PID = ((Label)gridProjeForm.Rows[e.RowIndex].FindControl("labPID")).Text.ToInt32();

                    if (PID == 0) ///Proje güncellenecekse
                    {
                        int projeID = gridProjeForm.DataKeys[e.RowIndex].Value.ToInt32();
                        ProjeForm updateProje = Context.ProjeForms.Where(x => x.ID == projeID).SingleOrDefault();
                        if (updateProje.IsNull())
                        {
                            MesajVer(Global.MesajTip.Uyari, Mesaj: "Proje kaydı bulunamadı ! Lütfen tekrar deneyin..");
                            return;
                        }
                        string firma = updateProje.Firma;
                        string onceProje = updateProje.Proje;
                        updateProje.Proje = ((TextBox)gridProjeForm.Rows[e.RowIndex].FindControl("txtProje")).Text;

                        string sonraProje = updateProje.Proje;

                        ///Bu projenin altında formlar varsa onların da proje adı değişecek
                        var projeFormlari = Context.ProjeForms.Where(x => x.Firma == firma && x.Proje == onceProje);
                        foreach (var item in projeFormlari)
                        {
                            item.Proje = sonraProje;
                        }

                        ///Bu projeyle ilgili hareket tablosunda kayıt varsa onları da değiştir.
                        var gorevHareketler = Context.GorevHarekets.Where(x => x.Firma == firma && x.Proje == onceProje);
                        foreach (var item in gorevHareketler)
                        {
                            item.Proje = sonraProje;
                        }

                        ///Bu projeyle ilgili oluşturulmuş görevler varsa onlara da uygulansın
                        var gorevler = Context.Gorevlers.Where(x => x.Firma == firma && x.Proje == onceProje);
                        foreach (var item in gorevler)
                        {
                            item.Proje = sonraProje;
                            ///Trigger da işlem yapmasın ve gereksiz hareket 
                            ///oluşturmasın diye IslemTipine 1 atıyorum..
                            item.IslemTip = 1;
                        }

                        if (Methods.NullEmptyKontrol(updateProje.Firma, updateProje.Proje))
                        {
                            Context.SubmitChanges();
                            ProjeForm_Getir();
                            MesajVer(Global.MesajTip.Bilgi);
                        }
                        else
                        {
                            MesajVer(Global.MesajTip.Uyari, Mesaj: "Firma ve Proje alanları zorunludur ! Lütfen giriniz..");
                        }
                    }
                    else  ///Form güncellenecekse
                    {
                        int formID = gridProjeForm.DataKeys[e.RowIndex].Value.ToInt32();
                        ProjeForm updateForm = Context.ProjeForms.Where(x => x.ID == formID).SingleOrDefault();
                        if (updateForm.IsNull())
                        {
                            MesajVer(Global.MesajTip.Uyari, Mesaj: "Form kaydı bulunamadı ! Lütfen tekrar deneyin..");
                            return;
                        }
                        string firma = updateForm.Firma;
                        string onceProje = updateForm.Proje;
                        string onceForm = updateForm.Form;
                        updateForm.Form = ((TextBox)gridProjeForm.Rows[e.RowIndex].FindControl("txtForm")).Text;

                        string sonraForm = updateForm.Form;

                        ///Bu projenin altında formlar varsa onların da proje adı değişecek
                        var projeFormlari = Context.ProjeForms.Where(x => x.Firma == firma && x.Proje == onceProje && x.Form == onceForm);
                        foreach (var item in projeFormlari)
                        {
                            item.Form = sonraForm;
                        }

                        ///Bu projeyle ilgili hareket tablosunda kayıt varsa onları da değiştir.
                        var gorevHareketler = Context.GorevHarekets.Where(x => x.Firma == firma && x.Proje == onceProje && x.Form == onceForm);
                        foreach (var item in gorevHareketler)
                        {
                            item.Form = sonraForm;
                        }

                        ///Bu projeyle ilgili oluşturulmuş görevler varsa onlara da uygulansın
                        var gorevler = Context.Gorevlers.Where(x => x.Firma == firma && x.Proje == onceProje && x.Form == onceForm);
                        foreach (var item in gorevler)
                        {
                            item.Form = sonraForm;
                            ///Trigger da işlem yapmasın ve gereksiz hareket 
                            ///oluşturmasın diye IslemTipine 1 atıyorum..
                            item.IslemTip = 1;

                        }

                        if (Methods.NullEmptyKontrol(updateForm.Firma, updateForm.Proje, updateForm.Form))
                        {
                            Context.SubmitChanges();
                            ProjeForm_Getir();
                            MesajVer(Global.MesajTip.Bilgi);
                        }
                        else
                        {
                            MesajVer(Global.MesajTip.Uyari, Mesaj: "Firma, Proje ve Form alanları zorunludur ! Lütfen giriniz..");
                        }
                    }

                   
                }
            }
            catch (Exception ex)
            {
                MesajVer(hata: ex);
            }
        }

        protected void btnProjeFormKaydet_Click(object sender, EventArgs e)
        {
            try
            {
                using (GorevDataDataContext Context = new GorevDataDataContext(Global.ConStr))
                {

                    ProjeForm addProje = new ProjeForm();

                    if (chkProjectNew.Checked) ///Yeni Proje Başlığı tanımlanacaksa
                    {
                        addProje.Firma = ddlFirma.SelectedValue.Trim2('-');
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

                        ScriptManager.RegisterStartupScript(this, typeof(string), "open", "SetCssProject();", true);
                    }
                    else  ///Yeni Form Tanımlanacaksa
                    {
                        addProje.Firma = ddlFirma.SelectedValue.Trim2('-');
                        addProje.Proje = ddlProje.SelectedItem.ToString2().Trim2('-');
                        addProje.Form = txtForm.Text.Trim2();
                        addProje.PID = ddlProje.SelectedValue.ToInt32Null();
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

                    MesajVer(Global.MesajTip.Bilgi);

                }
            }
            catch (Exception ex)
            {
                MesajVer(hata: ex);
            }

        }

        protected void btnProjeFormSil_Click(object sender, EventArgs e)
        {
            try
            {
                using (GorevDataDataContext Context = new GorevDataDataContext(Global.ConStr))
                {

                    if (chkFormNew.Checked) //Proje silinecekse
                    {
                        string firma = ddlFirma.SelectedValue.Trim2('-');
                        int? projeId = ddlProje.SelectedValue.ToInt32Null();
                        string proje = ddlProje.SelectedItem.ToString2().Trim2('-');

                        if (proje.IsNullEmpty())
                        {
                            MesajVer(Global.MesajTip.Uyari, Mesaj: "Geçersiz işlem ! Silinecek projeyi seçmediniz..");
                            return;
                        }

                        ProjeForm project = Context.ProjeForms.Where(x => x.Firma == firma && x.Proje == proje && x.PID == 0).FirstOrDefault();
                        if (project.IsNotNullEmpty())
                        {
                            bool varmi = Context.Gorevlers.Where(x => x.Firma == firma && x.Proje == proje).Any();

                            if (varmi == false)
                            {
                                List<ProjeForm> projeList = Context.ProjeForms.Where(x => x.Firma == firma && x.PID == projeId).ToList();
                                projeList.Add(project);
                                Context.ProjeForms.DeleteAllOnSubmit(projeList);
                            }
                            else
                            {
                                MesajVer(Global.MesajTip.Uyari, Mesaj: "Bu Projeye ait görevler olduğu için silinemez !");
                                return;
                            }
                        }

                        Context.SubmitChanges();
                        GetProjeForm(FirmaGetir: false, Firma: firma, FormGetir: false);
                        txtProje.Text = "";
                    }
                    else
                    {
                        int id = ddlForm.SelectedValue.ToInt32();
                        string firma = "", proje = "";
                        int? pID = null;

                        if (id == 0)
                        {
                            MesajVer(Global.MesajTip.Uyari, Mesaj: "Geçersiz işlem ! Silinecek formu seçmediniz..");
                            return;
                        }

                        ProjeForm form = Context.ProjeForms.Where(x => x.ID == id).FirstOrDefault();
                        if (form.IsNotNullEmpty())
                        {
                            bool varmi = Context.Gorevlers.Where(x => x.Firma == form.Firma && x.Proje == form.Proje && x.Form == form.Form).Any();
                            if (varmi==false)
                            {
                                pID = form.PID;
                                firma = form.Firma;
                                proje = form.Proje;
                                Context.ProjeForms.DeleteOnSubmit(form);
                            }
                            else
                            {
                                MesajVer(Global.MesajTip.Uyari, Mesaj: "Bu Forma ait görevler olduğu için silinemez !");
                                return;
                            }
                        }

                        Context.SubmitChanges();
                        GetProjeForm(FirmaGetir: false, ProjeGetir: false, Firma: firma, Proje: proje, pID: pID.ToInt32());
                        txtForm.Text = "";
                    }

                }

                MesajVer(Global.MesajTip.Bilgi);

            }
            catch (Exception ex)
            {
                MesajVer(hata: ex);
            }
        }

        public static string Firma = null;
        public static string Proje = null;
        public static int PID = -1;
        protected void ddlFirma_SelectedIndexChanged(object sender, EventArgs e)
        {
            Firma = ddlFirma.SelectedValue;
            GetProjeForm(FirmaGetir: false, Firma: Firma, FormGetir: false);
            ScriptManager.RegisterStartupScript(this, typeof(string), "open", "SetCssProject();", true);
        }

        protected void ddlProje_SelectedIndexChanged(object sender, EventArgs e)
        {
            Firma = ddlFirma.SelectedValue;
            Proje = ddlProje.SelectedItem.ToString2().Trim2('-');
            PID = ddlProje.SelectedValue.ToInt32();
            GetProjeForm(FirmaGetir: false, ProjeGetir: false, Firma: Firma, Proje: Proje, pID: PID);
            ScriptManager.RegisterStartupScript(this, typeof(string), "open", "chkFormCheck();", true);
        }

        protected void btnPopupKapat_Click(object sender, EventArgs e)
        {
            mPopup.Hide();
        }
        #endregion /// ProjeForm ALL METHODS

        #region Proje Grid Events
        protected void gridProje_RowEditing(object sender, GridViewEditEventArgs e)
        {
            pnlHata.Visible = false;
            pnlBasarili.Visible = false;
            GetData(TanimType.Proje, e.NewEditIndex);    
        }

        protected void gridProje_RowCancelingEdit(object sender, GridViewCancelEditEventArgs e)
        {
            GetData(TanimType.Proje, -1);
        }

        protected void gridProje_DataBinding(object sender, EventArgs e)
        {

        }

        protected void gridProje_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            pnlHata.Visible = false;
            pnlBasarili.Visible = false;
            gridProje.PageIndex = e.NewPageIndex;
            GetData(TanimType.Proje);
        }
      
        protected void gridProje_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if ((e.Row.RowType == DataControlRowType.DataRow && gridProje.EditIndex == e.Row.RowIndex) || e.Row.RowType == DataControlRowType.Footer)
            {
                try
                {
                    using (GorevDataDataContext Context = new GorevDataDataContext(Global.ConStr))
                    {

                       
                        if (e.Row.RowType == DataControlRowType.Footer)
                        {
                            DropDownList ddlFirma = (e.Row.FindControl("ddlProjeFirma") as DropDownList);
                            List<FirmaMin> MusteriList = (from musteri in Context.Musteris
                                                          where musteri.FID == 0
                                                          orderby musteri.Firma ascending
                                                          select new FirmaMin { ID = musteri.ID, Firma = musteri.Firma }).ToList();
                            ddlFirma.DataSource = MusteriList;
                            ddlFirma.DataTextField = "Firma";
                            ddlFirma.DataValueField = "ID";
                            ddlFirma.DataBind();
                            ddlFirma.Items.Insert(0, new ListItem("-"));
    
                        }
                        else if (e.Row.RowType != DataControlRowType.Footer)
                        {
                            string firma = (e.Row.FindControl("labFirma") as Label).Text;
                            DropDownList ddlKarsiSorumlu = (e.Row.FindControl("ddlKarsiSorumlu") as DropDownList);
                            List<FirmaMin> karsiSorumluList = (from musteri in Context.Musteris
                                                               where musteri.FID != 0 && musteri.Firma == firma
                                                               orderby musteri.Unvan ascending
                                                               select new FirmaMin { ID = musteri.ID, Firma = musteri.Unvan }).ToList();
                            ddlKarsiSorumlu.DataSource = karsiSorumluList;
                            ddlKarsiSorumlu.DataTextField = "Firma"; //Aslında buraya Unvan->Sorumlu AdSoyad geliyor..
                            ddlKarsiSorumlu.DataValueField = "Firma";
                            ddlKarsiSorumlu.DataBind();
                            ddlKarsiSorumlu.Items.Insert(0, new ListItem("-"));
                            string karsisorumlu = (e.Row.FindControl("labKarsiSorumlu") as Label).Text;
                            if (karsisorumlu.IsNotNullEmpty())
                                ddlKarsiSorumlu.Items.FindByValue(karsisorumlu).Selected = true;
                        }
                    

                        DropDownList ddlSorumlu = (e.Row.FindControl("ddlSorumlu") as DropDownList);
                        List<Kullanici> SorumluList = (from kul in Context.Kullanicis
                                                       where kul.Type == 0
                                                       orderby kul.KulKodu ascending
                                                       select kul).ToList();
                        ddlSorumlu.DataSource = SorumluList;
                        ddlSorumlu.DataTextField = "KulKodu";
                        ddlSorumlu.DataValueField = "KulKodu";
                        ddlSorumlu.DataBind();
                        ddlSorumlu.Items.Insert(0, new ListItem("-"));
                        if (e.Row.RowType != DataControlRowType.Footer)
                        {
                            string sorumlu = (e.Row.FindControl("labSorumlu") as Label).Text;
                            if (sorumlu.IsNotNullEmpty())
                                ddlSorumlu.Items.FindByValue(sorumlu).Selected = true;
                        }                     

                    }
                }
                catch (Exception ex)
                {
                }

            }
        }

        protected void gridProje_RowUpdating(object sender, GridViewUpdateEventArgs e)
        {          
            try
            {
                using (GorevDataDataContext Context = new GorevDataDataContext(Global.ConStr))
                {
                    int projeID = gridProje.DataKeys[e.RowIndex].Value.ToInt32();
                    ProjeForm updateProje = Context.ProjeForms.Where(x => x.ID == projeID).SingleOrDefault();
                    if (updateProje.IsNull())
                    {
                        MesajVer(Global.MesajTip.Uyari, Mesaj: "Proje kaydı bulunamadı ! Lütfen tekrar deneyin..");
                        return;
                    }
                    string firma = updateProje.Firma;
                    string onceProje = updateProje.Proje;
                    //updateProje.Firma = ((DropDownList)gridProje.Rows[e.RowIndex].FindControl("ddlProjeFirma")).SelectedItem.ToString2();
                    updateProje.Proje = ((TextBox)gridProje.Rows[e.RowIndex].FindControl("txtProje")).Text;
                    updateProje.KarsiSorumlu = ((DropDownList)gridProje.Rows[e.RowIndex].FindControl("ddlKarsiSorumlu")).SelectedValue;
                    updateProje.Sorumlu = ((DropDownList)gridProje.Rows[e.RowIndex].FindControl("ddlSorumlu")).SelectedValue;
                    //updateProje.Aciklama = ((TextBox)gridProje.Rows[e.RowIndex].FindControl("txtAciklama")).Text;

                    updateProje.MesaiKontrol = ((CheckBox)gridProje.Rows[e.RowIndex].FindControl("chkMesaiKontrol")).Checked;
                    updateProje.MesaiKota = ((TextBox)gridProje.Rows[e.RowIndex].FindControl("txtMesaiKota")).Text.ToInt32Null();

                    if (updateProje.MesaiKontrol.ToBool() && (updateProje.MesaiKota.IsNull() || updateProje.MesaiKota.ToInt32() == 0))
                    {
                        throw new Exception("Mesai Kontrolü seçili olduğu halde girilen kota değeri uygun değil !");
                    }
                      

                    string sonraProje = updateProje.Proje;

                    ///Bu projenin altında formlar varsa onların da proje adı değişecek
                    var projeFormlari = Context.ProjeForms.Where(x => x.Firma == firma && x.Proje == onceProje);
                    foreach (var item in projeFormlari)
                    {
                        item.Proje = sonraProje;
                    }

                    ///Bu projeyle ilgili hareket tablosunda kayıt varsa onları da değiştir.
                    var gorevHareketler = Context.GorevHarekets.Where(x => x.Firma == firma && x.Proje == onceProje);
                    foreach (var item in gorevHareketler)
                    {
                        item.Proje = sonraProje;
                    }

                    ///Bu projeyle ilgili oluşturulmuş görevler varsa onlara da uygulansın
                    var gorevler = Context.Gorevlers.Where(x => x.Firma == firma && x.Proje == onceProje);
                    foreach (var item in gorevler)
                    {
                        item.Proje = sonraProje;
                        ///Trigger da işlem yapmasın ve gereksiz hareket 
                        ///oluşturmasın diye IslemTipine 1 atıyorum..
                        item.IslemTip = 1;
                       
                    }

                    if (Methods.NullEmptyKontrol(updateProje.Firma, updateProje.Proje))
                    {
                        Context.SubmitChanges();
                        GetData(TanimType.Proje);
                        MesajVer(Global.MesajTip.Bilgi);
                    }
                    else
                    {
                        MesajVer(Global.MesajTip.Uyari, Mesaj: "Firma ve Proje alanları zorunludur ! Lütfen giriniz..");
                    }
                }
            }
            catch (Exception ex)
            {
                MesajVer(hata: ex);
            }
        }

        protected void btnProjeInsert_Click(object sender, ImageClickEventArgs e)
        {
            try
            {
                using (DataContext Context = Global.DBContext)
                {
                    ProjeForm addProje = new ProjeForm();
                    addProje.Firma = ((DropDownList)gridProje.FooterRow.FindControl("ddlProjeFirma")).SelectedItem.ToString2();
                    addProje.Proje = ((TextBox)gridProje.FooterRow.FindControl("txtProje")).Text;
                    addProje.KarsiSorumlu = ((DropDownList)gridProje.FooterRow.FindControl("ddlKarsiSorumlu")).SelectedValue;
                    addProje.Sorumlu = ((DropDownList)gridProje.FooterRow.FindControl("ddlSorumlu")).SelectedValue;
                    addProje.Aciklama = ((TextBox)gridProje.FooterRow.FindControl("txtAciklama")).Text;
                    addProje.PID = 0; //PID = 0 ise projedir.
                    addProje.Form = ""; //Form null değer almadığından boşluk attık.
                    addProje.MesaiKontrol = ((CheckBox)gridProje.FooterRow.FindControl("chkMesaiKontrol")).Checked;
                    addProje.MesaiKota = ((TextBox)gridProje.FooterRow.FindControl("txtMesaiKota")).Text.ToInt32Null();

                    if (addProje.MesaiKontrol.ToBool() && (addProje.MesaiKota.IsNull() || addProje.MesaiKota.ToInt32() == 0))
                    {
                        throw new Exception("Mesai Kontrolü seçili olduğu halde girilen kota değeri uygun değil !");
                    }

                    if (Methods.NullEmptyKontrol(addProje.Firma, addProje.Proje))
                    {
                        Context.GetTable<ProjeForm>().InsertOnSubmit(addProje);
                        Context.SubmitChanges();
                        GetData(TanimType.Proje);
                        MesajVer(Global.MesajTip.Bilgi);
                    }
                    else
                    {
                        MesajVer(Global.MesajTip.Uyari, Mesaj: "Firma ve Proje alanları zorunludur ! Lütfen giriniz..");
                    }
                }
            }
            catch (Exception ex)
            {
                MesajVer(hata: ex);
            }
        }

        protected void btnProjeDelete_Click(object sender, ImageClickEventArgs e)
        {
            try
            {
                using (DataContext Context = Global.DBContext)
                {
                    ImageButton lnkRemove = (ImageButton)sender;
                    int projeID = lnkRemove.CommandArgument.ToInt32();
                    ProjeForm silProje = Context.GetTable<ProjeForm>().Where(x => x.ID == projeID).SingleOrDefault();
                    if (silProje.IsNotNull())
                    {
                        bool varmi = Context.GetTable<Gorevler>().Where(x => x.Firma == silProje.Firma && x.Proje == silProje.Proje).Any();

                        if (varmi == false)
                        {
                            Context.GetTable<ProjeForm>().DeleteOnSubmit(silProje);
                            Context.SubmitChanges();
                            GetData(TanimType.Proje);
                            MesajVer(Global.MesajTip.Bilgi);
                        }
                        else
                        {
                            MesajVer(Global.MesajTip.Uyari, Mesaj: "Bu Projeye ait görevler olduğu için silinemez !");
                            return;
                        }
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

        protected void ddlProjeFirma_SelectedIndexChanged(object sender, EventArgs e)
        {
            try
            {
                pnlBasarili.Visible = false;
                pnlHata.Visible = false;

                using (GorevDataDataContext Context = new GorevDataDataContext(Global.ConStr))
                {
                    if (gridProje.EditIndex > -1)
                    {
                        string firma = ((DropDownList)sender).SelectedItem.ToString2();
                        DropDownList ddlKarsiSorumlu = (gridProje.Rows[gridProje.EditIndex].FindControl("ddlKarsiSorumlu") as DropDownList);
                        List<FirmaMin> SorumluList = (from musteri in Context.Musteris
                                                      where musteri.FID != 0 && musteri.Firma == firma
                                                      orderby musteri.Unvan ascending
                                                      select new FirmaMin { ID = musteri.ID, Firma = musteri.Unvan }).ToList();
                        ddlKarsiSorumlu.DataSource = SorumluList;
                        ddlKarsiSorumlu.DataTextField = "Firma"; //Aslında buraya Unvan->Sorumlu AdSoyad geliyor..
                        ddlKarsiSorumlu.DataValueField = "Firma";
                        ddlKarsiSorumlu.DataBind();
                        ddlKarsiSorumlu.Items.Insert(0, new ListItem("-"));
                        string sorumlu = (gridProje.Rows[gridProje.EditIndex].FindControl("labKarsiSorumlu") as Label).Text;
                        if (sorumlu.IsNotNullEmpty())
                            ddlKarsiSorumlu.Items.FindByValue(sorumlu).Selected = true;
                    }
                    else  /// Footer Row 
                    {
                        string firma = ((DropDownList)sender).SelectedItem.ToString2();
                        DropDownList ddlKarsiSorumlu = (gridProje.FooterRow.FindControl("ddlKarsiSorumlu") as DropDownList);
                        List<FirmaMin> SorumluList = (from musteri in Context.Musteris
                                                      where musteri.FID != 0 && musteri.Firma == firma
                                                      orderby musteri.Unvan ascending
                                                      select new FirmaMin { ID = musteri.ID, Firma = musteri.Unvan }).ToList();
                        ddlKarsiSorumlu.DataSource = SorumluList;
                        ddlKarsiSorumlu.DataTextField = "Firma"; //Aslında buraya Unvan->Sorumlu AdSoyad geliyor..
                        ddlKarsiSorumlu.DataValueField = "Firma";
                        ddlKarsiSorumlu.DataBind();
                        ddlKarsiSorumlu.Items.Insert(0, new ListItem("-"));
                        string sorumlu = (gridProje.FooterRow.FindControl("labKarsiSorumlu") as Label).Text;
                        if (sorumlu.IsNotNullEmpty())
                            ddlKarsiSorumlu.Items.FindByValue(sorumlu).Selected = true;
                    }
                }
            }
            catch (Exception ex)
            {
            }
        }

        protected void gridProje_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "Yukle")
            {

            }
        }
       
        #endregion //Proje Grid Events

        #region Sorumlu Grid Events
        protected void gridSorumlu_RowEditing(object sender, GridViewEditEventArgs e)
        {
            pnlHata.Visible = false;
            pnlBasarili.Visible = false;
            GetData(TanimType.Sorumlu, e.NewEditIndex);    
        }

        protected void gridSorumlu_RowCancelingEdit(object sender, GridViewCancelEditEventArgs e)
        {
            GetData(TanimType.Sorumlu, -1);
        }

        protected void gridSorumlu_DataBinding(object sender, EventArgs e)
        {

        }

        protected void gridSorumlu_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            pnlHata.Visible = false;
            pnlBasarili.Visible = false;
            gridSorumlu.PageIndex = e.NewPageIndex;
            GetData(TanimType.Sorumlu);
        }    

        protected void gridSorumlu_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if ((e.Row.RowType == DataControlRowType.DataRow && gridSorumlu.EditIndex == e.Row.RowIndex) || e.Row.RowType == DataControlRowType.Footer)
            {

                try
                {
                    using (GorevDataDataContext Context = new GorevDataDataContext(Global.ConStr))
                    {
                        DropDownList ddlFirma = (e.Row.FindControl("ddlFirma") as DropDownList);
                        List<FirmaMin> MusteriList = (from musteri in Context.Musteris
                                                      where musteri.FID == 0
                                                      orderby musteri.Firma ascending
                                                      select new FirmaMin { ID = musteri.ID, Firma = musteri.Firma }).ToList();
                        ddlFirma.DataSource = MusteriList;
                        ddlFirma.DataTextField = "Firma";
                        ddlFirma.DataValueField = "ID";
                        ddlFirma.DataBind();
                        ddlFirma.Items.Insert(0, new ListItem("-", "0"));
                        string firma = (e.Row.FindControl("labFirma") as Label).Text;
                        if (firma.IsNotNullEmpty())
                            ddlFirma.Items.FindByText(firma).Selected = true;
                    }
                }
                catch (Exception ex)
                {
                }

            }
        }

        protected void gridSorumlu_RowUpdating(object sender, GridViewUpdateEventArgs e)
        {
            try
            {
                using (DataContext Context = Global.DBContext)
                {
                    int sorumluID = gridSorumlu.DataKeys[e.RowIndex].Value.ToInt32();
                    Musteri updateSorumlu = Context.GetTable<Musteri>().Where(x => x.ID == sorumluID).SingleOrDefault();
                    updateSorumlu.Firma = ((DropDownList)gridSorumlu.Rows[e.RowIndex].FindControl("ddlFirma")).SelectedItem.ToString2();
                    updateSorumlu.FID = ((DropDownList)gridSorumlu.Rows[e.RowIndex].FindControl("ddlFirma")).SelectedValue.ToInt32();
                    updateSorumlu.Unvan = ((TextBox)gridSorumlu.Rows[e.RowIndex].FindControl("txtSorumlu")).Text;
                    updateSorumlu.Email = ((TextBox)gridSorumlu.Rows[e.RowIndex].FindControl("txtEmail")).Text;
                    updateSorumlu.Tel1 = ((TextBox)gridSorumlu.Rows[e.RowIndex].FindControl("txtTel1")).Text;
                    updateSorumlu.Tel2 = ((TextBox)gridSorumlu.Rows[e.RowIndex].FindControl("txtTel2")).Text;
                    updateSorumlu.Degistiren = Global.Kullanici.KulKodu;
                    updateSorumlu.DegisTarih = DateTime.Now;


                    if (Methods.NullEmptyKontrol(updateSorumlu.Firma, updateSorumlu.Unvan))
                    {
                        Context.SubmitChanges();
                        GetData(TanimType.Sorumlu);
                        MesajVer(Global.MesajTip.Bilgi);
                    }
                    else
                    {
                        MesajVer(Global.MesajTip.Uyari, Mesaj: "Firma ve Sorumlu alanları zorunludur ! Lütfen giriniz..");
                    }

                }
            }
            catch (Exception hata)
            {
                MesajVer(hata: hata);
            } 
        }

        protected void btnSorumluInsert_Click(object sender, ImageClickEventArgs e)
        {
            try
            {
                using (DataContext Context = Global.DBContext)
                {
                    Musteri addSorumlu = new Musteri();
                    addSorumlu.Firma = ((DropDownList)gridSorumlu.FooterRow.FindControl("ddlFirma")).SelectedItem.ToString2();
                    addSorumlu.FID = ((DropDownList)gridSorumlu.FooterRow.FindControl("ddlFirma")).SelectedValue.ToInt32();
                    addSorumlu.Unvan = ((TextBox)gridSorumlu.FooterRow.FindControl("txtSorumlu")).Text;
                    addSorumlu.Email = ((TextBox)gridSorumlu.FooterRow.FindControl("txtEmail")).Text;
                    addSorumlu.Tel1 = ((TextBox)gridSorumlu.FooterRow.FindControl("txtTel1")).Text;
                    addSorumlu.Tel2 = ((TextBox)gridSorumlu.FooterRow.FindControl("txtTel2")).Text;
                    addSorumlu.Kaydeden = Global.Kullanici.KulKodu;
                    addSorumlu.KayitTarih = DateTime.Now;
                    addSorumlu.Degistiren = Global.Kullanici.KulKodu;
                    addSorumlu.DegisTarih = DateTime.Now;

                    if (Methods.NullEmptyKontrol(addSorumlu.Firma, addSorumlu.Unvan))
                    {
                        Context.GetTable<Musteri>().InsertOnSubmit(addSorumlu);
                        Context.SubmitChanges();
                        GetData(TanimType.Sorumlu);
                        MesajVer(Global.MesajTip.Bilgi);
                    }
                    else
                    {
                        MesajVer(Global.MesajTip.Uyari, Mesaj: "Firma ve Sorumlu alanları zorunludur ! Lütfen giriniz..");
                    }

                }
            }
            catch (Exception ex)
            {
                MesajVer(hata: ex);
            }
        }

        protected void btnSorumluDelete_Click(object sender, ImageClickEventArgs e)
        {
            try
            {
                using (DataContext Context = Global.DBContext)
                {
                    ImageButton lnkRemove = (ImageButton)sender;
                    int sorumluID = lnkRemove.CommandArgument.ToInt32();
                    Musteri silSorumlu = Context.GetTable<Musteri>().Where(x => x.ID == sorumluID).SingleOrDefault();
                    if (silSorumlu.IsNotNull())
                    {
                        Context.GetTable<Musteri>().DeleteOnSubmit(silSorumlu);
                        Context.SubmitChanges();
                        GetData(TanimType.Sorumlu);
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
        #endregion //Sorumlu Grid Events

        protected void timerHelper_Tick(object sender, EventArgs e)
        {
            ///Bu timer bir kereliğine çalışacak sadece Gridin Width özelliğini düzeltebilmek için kullandım.
            timerHelper.Enabled = false;
            gridKullanici.Width = 940;
            gridMusteri.Width = 860;
            gridSorumlu.Width = 790;
            gridProjeForm.Width = 800;
            gridProje.Width = 950;
        }

        void MesajVer(Global.MesajTip mtip = Global.MesajTip.None, Exception hata = null, string Mesaj = null)
        {
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


        /// Ek Dosyaların upload edildiği metod
        protected void fileupKlavuz_UploadedComplete(object sender, AsyncFileUploadEventArgs e)
        {
            try
            {
                AsyncFileUpload fileupload = sender as AsyncFileUpload;

                if (!Directory.Exists(Server.MapPath("UploadFiles/ProjeFiles/P" + fileupload.ThrobberID + "/")))
                {
                    Directory.CreateDirectory(Server.MapPath("UploadFiles/ProjeFiles/P" + fileupload.ThrobberID + "/"));
                }

                string filename = System.IO.Path.GetFileName(fileupload.FileName);

                fileupload.SaveAs(Server.MapPath("UploadFiles/ProjeFiles/P" + fileupload.ThrobberID + "/") + filename);

                using (GorevDataDataContext Context = new GorevDataDataContext(Global.ConStr))
                {
                    EkDosya ekdosya = new EkDosya();
                    ekdosya.Tip = 1;
                    ekdosya.DosyaAdi = filename;
                    ekdosya.GorevID = fileupload.ThrobberID.ToInt32();
                    ekdosya.Kaydeden = Global.Kullanici.KulKodu;
                    ekdosya.KayitTarih = DateTime.Now;
                    Context.EkDosyas.InsertOnSubmit(ekdosya);
                    Context.SubmitChanges();
                }
            }
            catch (Exception ex)
            {
                MesajVer(hata: ex);
            }
          
        }

        #region FİLTER ROW METODLARI
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
                    ddlfilterProje.Items.Insert(0, new ListItem("-"));

                    GetProje(FirmaSorumluGetir: false, Firma: ddlfilterFirma.SelectedValue,
                            Proje: ddlfilterProje.SelectedValue, Sorumlu: ddlfilterSorumlu.SelectedValue,
                            KarsiSorumlu: txtfilterKarsiSorumlu.Text.Trim());  
                }
            }
            catch (Exception ex)
            {
                MesajVer(hata: ex);
            }
        }

        protected void ddlfilterProje_SelectedIndexChanged(object sender, EventArgs e)
        {
            GetProje(FirmaSorumluGetir: false, Firma: ddlfilterFirma.SelectedValue, 
                Proje: ddlfilterProje.SelectedValue, Sorumlu: ddlfilterSorumlu.SelectedValue, 
                KarsiSorumlu: txtfilterKarsiSorumlu.Text.Trim());           
        }

        protected void ddlfilterSorumlu_SelectedIndexChanged(object sender, EventArgs e)
        {
            GetProje(FirmaSorumluGetir: false, Firma: ddlfilterFirma.SelectedValue,
               Proje: ddlfilterProje.SelectedValue, Sorumlu: ddlfilterSorumlu.SelectedValue,
               KarsiSorumlu: txtfilterKarsiSorumlu.Text.Trim());   
        }

        protected void txtfilterKarsiSorumlu_TextChanged(object sender, EventArgs e)
        {
            GetProje(FirmaSorumluGetir: false, Firma: ddlfilterFirma.SelectedValue,
               Proje: ddlfilterProje.SelectedValue, Sorumlu: ddlfilterSorumlu.SelectedValue,
               KarsiSorumlu: txtfilterKarsiSorumlu.Text.Trim());  
        }

        protected void AsyncFileUpload_KlavuzYedekleme_UploadedComplete(object sender, AsyncFileUploadEventArgs e)
        {
            try
            {
                int tip = hKlavuzYedek01.Value.ToInt32();
                int projeID = hProID.Value.ToInt32();

                if (projeID > 0)
                {
                    if (tip == 0)
                    {
                        if (!Directory.Exists(Server.MapPath("UploadFiles/ProjeFiles/P" + projeID.ToString() + "/")))
                        {
                            Directory.CreateDirectory(Server.MapPath("UploadFiles/ProjeFiles/P" + projeID.ToString() + "/"));
                        }

                        string filename = System.IO.Path.GetFileName(AsyncFileUpload_KlavuzYedekleme.FileName);
                        filename = string.Format("{0:yyMMddHHmmss}", DateTime.Now) + " - " + filename;

                        AsyncFileUpload_KlavuzYedekleme.SaveAs(Server.MapPath("UploadFiles/ProjeFiles/P" + projeID.ToString() + "/") + filename);

                        using (GorevDataDataContext Context = new GorevDataDataContext(Global.ConStr))
                        {
                            EkDosya ekdosya = new EkDosya();
                            ekdosya.Tip = 1;
                            ekdosya.DosyaAdi = filename;
                            ekdosya.GorevID = projeID;
                            ekdosya.Kaydeden = Global.Kullanici.KulKodu;
                            ekdosya.KayitTarih = DateTime.Now;
                            Context.EkDosyas.InsertOnSubmit(ekdosya);
                            Context.SubmitChanges();
                        }
                    }
                    else if (tip == 1)
                    {
                        if (!Directory.Exists(Server.MapPath("UploadFiles/ProjeBackup/PB" + projeID.ToString() + "/")))
                        {
                            Directory.CreateDirectory(Server.MapPath("UploadFiles/ProjeBackup/PB" + projeID.ToString() + "/"));
                        }

                        string filename = System.IO.Path.GetFileName(AsyncFileUpload_KlavuzYedekleme.FileName);
                        filename = string.Format("{0:yyMMddHHmmss}", DateTime.Now) + " - " + filename;

                     

                        AsyncFileUpload_KlavuzYedekleme.SaveAs(Server.MapPath("UploadFiles/ProjeBackup/PB" + projeID.ToString() + "/") + filename);

                        using (GorevDataDataContext Context = new GorevDataDataContext(Global.ConStr))
                        {
                            EkDosya ekdosya = new EkDosya();
                            ekdosya.Tip = 2;
                            ekdosya.DosyaAdi = filename;
                            ekdosya.GorevID = projeID;
                            ekdosya.Kaydeden = Global.Kullanici.KulKodu;
                            ekdosya.KayitTarih = DateTime.Now;
                            Context.EkDosyas.InsertOnSubmit(ekdosya);
                            Context.SubmitChanges();
                        }
                    }
                }
               
            }
            catch (Exception ex)
            {
                MesajVer(hata: ex);
            }

        }
        #endregion FİLTER ROW METODLARI
    }
}