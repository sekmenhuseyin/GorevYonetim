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
    public partial class GorevTakvimi : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Page.IsPostBack)  /// Sayfa ilk kez yükleniyorsa
            {
                //txtTarih1.Text = new DateTime(2015, 3, 1).ToShortDateString();
                //txtTarih2.Text = new DateTime(2015, 3, 4).ToShortDateString();
                txtTarih1.Text = DateTime.Today.ToShortDateString();
                txtTarih2.Text = DateTime.Today.ToShortDateString();
            }
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
                //gridCalisma.Width = 1055;          
            }
            ScriptManager.RegisterStartupScript(this, typeof(string), "open", "GetTakvim();", true);          
        }


        class FirmaProjeRenk
        {
            public string Firma { get; set; }
            public string Proje { get; set; }
            public int? Sure { get; set; }
            public Color Renk { get; set; }
        }

        class FirmaProjeSorumluRenk
        {
            public string Firma { get; set; }
            public string Proje { get; set; }
            public string Sorumlu { get; set; }
            public Color Renk { get; set; }
        }

        protected void btnTamam_Click(object sender, EventArgs e)
        {
            try
            {
                List<GorevCalisma_TakvimiResult> GorevTakvimListe = new List<GorevCalisma_TakvimiResult>();
                using (GorevDataDataContext Context = new GorevDataDataContext())
                {
                    GorevTakvimListe = Context.GorevCalisma_Takvimi(txtTarih1.Text.ToDatetimeNull(), txtTarih2.Text.ToDatetimeNull()).ToList();
                }

                ///SORUMLUYA GÖRE ÇALIŞMALARIN GÖSTERİMİ
                List<string> SorumluList = GorevTakvimListe.GroupBy(x => x.Kaydeden).Select(x => x.Key).ToList();
                List<string> TarihList = GorevTakvimListe.GroupBy(x => new { x.TarihStr, x.Tarih }).OrderBy(x => x.Key.Tarih).Select(x => x.Key.TarihStr).ToList();

                var Liste = GorevTakvimListe.GroupBy(x => new { x.Firma, x.Proje }).Select(x => new { x.Key.Firma, x.Key.Proje }).ToList();
                List<FirmaProjeRenk> FPRenkList = new List<FirmaProjeRenk>();

                int sayac = 0;
                foreach (var item in Liste)
                {
                    FirmaProjeRenk FPRenk = new FirmaProjeRenk();
                    FPRenk.Firma = item.Firma;
                    FPRenk.Proje = item.Proje;
                    FPRenk.Sure = GorevTakvimListe.Where(x => x.Firma == item.Firma && x.Proje == item.Proje).Sum(x => x.CalismaSure);

                    if (FPRenk.Firma.IsNullEmpty() && FPRenk.Proje.IsNullEmpty())
                        FPRenk.Renk = Color.Silver;
                    else if (sayac % 30 == 0)
                        FPRenk.Renk = System.Drawing.ColorTranslator.FromHtml("#428BCA");
                    else if (sayac % 30 == 1)
                        FPRenk.Renk = System.Drawing.ColorTranslator.FromHtml("#8A6D3B");
                    else if (sayac % 30 == 2)
                        FPRenk.Renk = System.Drawing.ColorTranslator.FromHtml("#FABF8F");
                    else if (sayac % 30 == 3)
                        FPRenk.Renk = System.Drawing.ColorTranslator.FromHtml("#5D91A2");
                    else if (sayac % 30 == 4)
                        FPRenk.Renk = System.Drawing.ColorTranslator.FromHtml("#95B3D7");
                    else if (sayac % 30 == 5)
                        FPRenk.Renk = System.Drawing.ColorTranslator.FromHtml("#21A748");
                    else if (sayac % 30 == 6)
                        FPRenk.Renk = System.Drawing.ColorTranslator.FromHtml("#C4D79B");
                    else if (sayac % 30 == 7)
                        FPRenk.Renk = System.Drawing.ColorTranslator.FromHtml("#00A2D9");
                    else if (sayac % 30 == 8)
                        FPRenk.Renk = System.Drawing.ColorTranslator.FromHtml("#80B32D");
                    else if (sayac % 30 == 9)

                        FPRenk.Renk = System.Drawing.ColorTranslator.FromHtml("#D03957");
                    else if (sayac % 30 == 10)
                        FPRenk.Renk = System.Drawing.ColorTranslator.FromHtml("#054570");
                    else if (sayac % 30 == 11)
                        FPRenk.Renk = System.Drawing.ColorTranslator.FromHtml("#B4D462");
                    else if (sayac % 30 == 12)
                        FPRenk.Renk = System.Drawing.ColorTranslator.FromHtml("#157130");
                    else if (sayac % 30 == 13)
                        FPRenk.Renk = System.Drawing.ColorTranslator.FromHtml("#CE6CAC");
                    else if (sayac % 30 == 14)
                        FPRenk.Renk = System.Drawing.ColorTranslator.FromHtml("#3674AB");
                    else if (sayac % 30 == 15)
                        FPRenk.Renk = System.Drawing.ColorTranslator.FromHtml("#96CE09");
                    else if (sayac % 30 == 16)
                        FPRenk.Renk = System.Drawing.ColorTranslator.FromHtml("#563698");
                    else if (sayac % 30 == 17)
                        FPRenk.Renk = System.Drawing.ColorTranslator.FromHtml("#56636F");
                    else if (sayac % 30 == 18)
                        FPRenk.Renk = System.Drawing.ColorTranslator.FromHtml("#738EA7");
                    else if (sayac % 30 == 19)
                        FPRenk.Renk = System.Drawing.ColorTranslator.FromHtml("#5C84AF");

                    else if (sayac % 30 == 20)
                        FPRenk.Renk = System.Drawing.ColorTranslator.FromHtml("#4021A7");
                    else if (sayac % 30 == 21)
                        FPRenk.Renk = System.Drawing.ColorTranslator.FromHtml("#04501B");
                    else if (sayac % 30 == 22)
                        FPRenk.Renk = System.Drawing.ColorTranslator.FromHtml("#1B3E5D");
                    else if (sayac % 30 == 23)
                        FPRenk.Renk = System.Drawing.ColorTranslator.FromHtml("#8C396F");
                    else if (sayac % 30 == 24)
                        FPRenk.Renk = System.Drawing.ColorTranslator.FromHtml("#D9534F");
                    else if (sayac % 30 == 25)
                        FPRenk.Renk = System.Drawing.ColorTranslator.FromHtml("#C75757");
                    else if (sayac % 30 == 26)
                        FPRenk.Renk = System.Drawing.ColorTranslator.FromHtml("#999999");
                    else if (sayac % 30 == 27)
                        FPRenk.Renk = System.Drawing.ColorTranslator.FromHtml("#64A5A4");
                    else if (sayac % 30 == 28)
                        FPRenk.Renk = System.Drawing.ColorTranslator.FromHtml("#7D9E81");
                    else if (sayac % 30 == 29)
                        FPRenk.Renk = System.Drawing.ColorTranslator.FromHtml("#329493");

                    FPRenkList.Add(FPRenk);
                    sayac++;
                }

                TableRow TRow = new TableRow();
                TableRow TRowSor = new TableRow();
                TableCell TCell = new TableCell();
                TCell.Width = 120;
                TCell.CssClass = "TabloYan";
                TCell.BackColor = Color.AliceBlue;
                TCell.Height = 24;
                TRowSor.Cells.Add(TCell);
                TabloSorumlular.Rows.Add(TRowSor);

                foreach (string tarih in TarihList)
                {
                    TCell = new TableCell();
                    TCell.Width = 810;
                    TCell.Text = tarih;
                    TCell.CssClass = "TabloBaslik";
                    TRow.Cells.Add(TCell);
                }
                TabloTakvim.Rows.Add(TRow);

                int toplamSure = 0, toplamSaat = 0, toplamDakika = 0;
                Panel panel = new Panel();
                foreach (string sorumlu in SorumluList)
                {
                    TRow = new TableRow();
                    TRowSor = new TableRow();
                    TCell = new TableCell();
                    TCell.Width = 120;
                    TCell.BackColor = Color.AliceBlue;
                    TCell.CssClass = "TabloYan";
                    TCell.Text = sorumlu;
                    TRowSor.Cells.Add(TCell);
                    TabloSorumlular.Rows.Add(TRowSor);

                    foreach (var tarih in TarihList)
                    {
                        TCell = new TableCell();
                        TCell.CssClass = "TabloHucre";
                        TRow.Cells.Add(TCell);
                        panel = new Panel();
                        panel.CssClass = "PanelCss";
                        TCell.Controls.Add(panel);

                        if (GorevTakvimListe.Any(x => x.Kaydeden == sorumlu && x.TarihStr == tarih))
                        {
                            foreach (var item in GorevTakvimListe.Where(x => x.Kaydeden == sorumlu && x.TarihStr == tarih))
                            {
                                if (tarih == item.TarihStr)
                                {
                                    Label lab = new Label();
                                    toplamSure = FPRenkList.Where(x => x.Firma == item.Firma && x.Proje == item.Proje).FirstOrDefault().Sure.ToInt32();
                                    toplamSaat = toplamSure / 60;
                                    toplamDakika = toplamSure % 60;
                                    if (item.Firma.IsNotNullEmpty())
                                    {
                                        lab.Text = string.Format("{0}-{1} ({2}:{3})", item.Firma, item.Proje, item.Saat, item.Dakika);
                                        lab.ToolTip = string.Format("{0}-{1} ({2}:{3}) / ({4}:{5})", item.Firma, item.Proje, item.Saat, item.Dakika, toplamSaat, toplamDakika);
                                    }
                                    else
                                    {
                                        lab.Text = string.Format("BOŞ ({0}:{1})", item.Saat, item.Dakika);
                                        lab.ToolTip = string.Format("BOŞ ({0}:{1})", item.Saat, item.Dakika);
                                    }
                                    lab.Width = new Unit(item.CalismaSure.ToDouble() * 1.5);
                                    lab.CssClass = "LabelCss";
                                    lab.BackColor = FPRenkList.Where(x => x.Firma == item.Firma && x.Proje == item.Proje).FirstOrDefault().Renk;

                                    panel.Controls.Add(lab);
                                }
                                else
                                {
                                    Label lab = new Label();
                                    lab.Text = string.Format("BOŞ (9:0)");
                                    lab.ToolTip = string.Format("BOŞ (9:0)");
                                    lab.BackColor = FPRenkList.Where(x => x.Firma == "" && x.Proje == "").FirstOrDefault().Renk;
                                    lab.Width = new Unit(810);
                                    lab.CssClass = "LabelCss";
                                    panel.Controls.Add(lab);
                                }

                            }
                        }
                        else
                        {
                            Label lab = new Label();
                            lab.Text = string.Format("BOŞ (9:0)");
                            lab.ToolTip = string.Format("BOŞ (9:0)");
                            if (FPRenkList.Any(x => x.Firma == "" && x.Proje == ""))
                                lab.BackColor = FPRenkList.Where(x => x.Firma == "" && x.Proje == "").FirstOrDefault().Renk;
                            else
                                lab.BackColor = System.Drawing.ColorTranslator.FromHtml("#D03957");

                            lab.Width = new Unit(810);
                            lab.CssClass = "LabelCss";
                            panel.Controls.Add(lab);
                        }

                    }

                    TabloTakvim.Rows.Add(TRow);
                }

                TabloTakvim.Width = (810 * TarihList.Count);


                ///FİRMAYA GÖRE ÇALIŞMALARIN GÖSTERİMİ
                GorevTakvimListe = GorevTakvimListe.Where(x => x.Firma != "").OrderBy(x => x.Firma).ToList();
                List<string> MusteriList = GorevTakvimListe.GroupBy(x => x.Firma).Select(x => x.Key).ToList();


                var Liste2 = GorevTakvimListe.GroupBy(x => new { x.Firma, x.Proje, x.Kaydeden }).Select(x => new { x.Key.Firma, x.Key.Proje, x.Key.Kaydeden }).ToList();
                List<FirmaProjeSorumluRenk> FPSRenkList = new List<FirmaProjeSorumluRenk>();

                sayac = 0;
                foreach (var item in Liste2)
                {
                    FirmaProjeSorumluRenk FPSRenk = new FirmaProjeSorumluRenk();
                    FPSRenk.Firma = item.Firma;
                    FPSRenk.Proje = item.Proje;
                    FPSRenk.Sorumlu = item.Kaydeden;

                    if (FPSRenk.Firma.IsNullEmpty() && FPSRenk.Proje.IsNullEmpty())
                        FPSRenk.Renk = Color.Silver;
                    else if (sayac % 30 == 0)
                        FPSRenk.Renk = System.Drawing.ColorTranslator.FromHtml("#428BCA");
                    else if (sayac % 30 == 1)
                        FPSRenk.Renk = System.Drawing.ColorTranslator.FromHtml("#8A6D3B");
                    else if (sayac % 30 == 2)
                        FPSRenk.Renk = System.Drawing.ColorTranslator.FromHtml("#FABF8F");
                    else if (sayac % 30 == 3)
                        FPSRenk.Renk = System.Drawing.ColorTranslator.FromHtml("#5D91A2");
                    else if (sayac % 30 == 4)
                        FPSRenk.Renk = System.Drawing.ColorTranslator.FromHtml("#95B3D7");
                    else if (sayac % 30 == 5)
                        FPSRenk.Renk = System.Drawing.ColorTranslator.FromHtml("#21A748");
                    else if (sayac % 30 == 6)
                        FPSRenk.Renk = System.Drawing.ColorTranslator.FromHtml("#C4D79B");
                    else if (sayac % 30 == 7)
                        FPSRenk.Renk = System.Drawing.ColorTranslator.FromHtml("#00A2D9");
                    else if (sayac % 30 == 8)
                        FPSRenk.Renk = System.Drawing.ColorTranslator.FromHtml("#80B32D");
                    else if (sayac % 30 == 9)

                        FPSRenk.Renk = System.Drawing.ColorTranslator.FromHtml("#D03957");
                    else if (sayac % 30 == 10)
                        FPSRenk.Renk = System.Drawing.ColorTranslator.FromHtml("#054570");
                    else if (sayac % 30 == 11)
                        FPSRenk.Renk = System.Drawing.ColorTranslator.FromHtml("#B4D462");
                    else if (sayac % 30 == 12)
                        FPSRenk.Renk = System.Drawing.ColorTranslator.FromHtml("#157130");
                    else if (sayac % 30 == 13)
                        FPSRenk.Renk = System.Drawing.ColorTranslator.FromHtml("#CE6CAC");
                    else if (sayac % 30 == 14)
                        FPSRenk.Renk = System.Drawing.ColorTranslator.FromHtml("#3674AB");
                    else if (sayac % 30 == 15)
                        FPSRenk.Renk = System.Drawing.ColorTranslator.FromHtml("#96CE09");
                    else if (sayac % 30 == 16)
                        FPSRenk.Renk = System.Drawing.ColorTranslator.FromHtml("#563698");
                    else if (sayac % 30 == 17)
                        FPSRenk.Renk = System.Drawing.ColorTranslator.FromHtml("#56636F");
                    else if (sayac % 30 == 18)
                        FPSRenk.Renk = System.Drawing.ColorTranslator.FromHtml("#738EA7");
                    else if (sayac % 30 == 19)
                        FPSRenk.Renk = System.Drawing.ColorTranslator.FromHtml("#5C84AF");

                    else if (sayac % 30 == 20)
                        FPSRenk.Renk = System.Drawing.ColorTranslator.FromHtml("#4021A7");
                    else if (sayac % 30 == 21)
                        FPSRenk.Renk = System.Drawing.ColorTranslator.FromHtml("#04501B");
                    else if (sayac % 30 == 22)
                        FPSRenk.Renk = System.Drawing.ColorTranslator.FromHtml("#1B3E5D");
                    else if (sayac % 30 == 23)
                        FPSRenk.Renk = System.Drawing.ColorTranslator.FromHtml("#8C396F");
                    else if (sayac % 30 == 24)
                        FPSRenk.Renk = System.Drawing.ColorTranslator.FromHtml("#D9534F");
                    else if (sayac % 30 == 25)
                        FPSRenk.Renk = System.Drawing.ColorTranslator.FromHtml("#C75757");
                    else if (sayac % 30 == 26)
                        FPSRenk.Renk = System.Drawing.ColorTranslator.FromHtml("#999999");
                    else if (sayac % 30 == 27)
                        FPSRenk.Renk = System.Drawing.ColorTranslator.FromHtml("#64A5A4");
                    else if (sayac % 30 == 28)
                        FPSRenk.Renk = System.Drawing.ColorTranslator.FromHtml("#7D9E81");
                    else if (sayac % 30 == 29)
                        FPSRenk.Renk = System.Drawing.ColorTranslator.FromHtml("#329493");

                    FPSRenkList.Add(FPSRenk);
                    sayac++;
                }

                FPSRenkList.Add(new FirmaProjeSorumluRenk { Firma = "", Proje = "", Sorumlu = "", Renk = Color.Silver });


                TRow = new TableRow();
                TRowSor = new TableRow();
                TCell = new TableCell();
                TCell.Width = 120;
                TCell.CssClass = "TabloYan";
                TCell.BackColor = Color.AliceBlue;
                TCell.Height = 24;
                TRowSor.Cells.Add(TCell);
                TabloMusteriler.Rows.Add(TRowSor);

                foreach (string tarih in TarihList)
                {
                    TCell = new TableCell();
                    TCell.Width = 810;
                    TCell.Text = tarih;
                    TCell.CssClass = "TabloBaslik";
                    TRow.Cells.Add(TCell);
                }
                TabloTakvim2.Rows.Add(TRow);

                toplamSure = 0;
                panel = new Panel();
                foreach (string musteri in MusteriList)
                {
                    TRow = new TableRow();
                    TRowSor = new TableRow();
                    TCell = new TableCell();
                    TCell.Width = 120;
                    TCell.BackColor = Color.AliceBlue;
                    TCell.CssClass = "TabloYan";
                    TCell.Text = musteri;
                    TRowSor.Cells.Add(TCell);
                    TabloMusteriler.Rows.Add(TRowSor);

                    foreach (var tarih in TarihList)
                    {
                        TCell = new TableCell();
                        TCell.CssClass = "TabloHucre";
                        TRow.Cells.Add(TCell);
                        panel = new Panel();
                        panel.CssClass = "PanelCss";
                        TCell.Controls.Add(panel);

                        if (GorevTakvimListe.Any(x => x.Firma == musteri && x.TarihStr == tarih))
                        {
                            toplamSure = GorevTakvimListe.Where(x => x.Firma == musteri && x.TarihStr == tarih).Sum(x => x.CalismaSure).ToInt32();

                            foreach (var item in GorevTakvimListe.Where(x => x.Firma == musteri && x.TarihStr == tarih))
                            {
                                if (tarih == item.TarihStr)
                                {
                                    Label lab = new Label();
                                    if (item.Firma.IsNotNullEmpty())
                                    {
                                        lab.Text = string.Format("{0}-{1} ({2}:{3})", item.Kaydeden, item.Proje, item.Saat, item.Dakika);
                                        lab.ToolTip = string.Format("{0}-{1} ({2}:{3})", item.Kaydeden, item.Proje, item.Saat, item.Dakika);
                                    }
                                    else
                                    {
                                        lab.Text = string.Format("BOŞ ({0}:{1})", item.Saat, item.Dakika);
                                        lab.ToolTip = string.Format("BOŞ ({0}:{1})", item.Saat, item.Dakika);
                                    }
                                    lab.Width = new Unit(item.CalismaSure.ToDouble() * 1.5 * ((double)540/toplamSure));
                                    lab.CssClass = "LabelCss";
                                    lab.BackColor = FPSRenkList.Where(x => x.Firma == item.Firma && x.Proje == item.Proje && x.Sorumlu == item.Kaydeden).FirstOrDefault().Renk;

                                    panel.Controls.Add(lab);
                                }
                                else
                                {
                                    Label lab = new Label();
                                    lab.Text = string.Format("BOŞ (9:0)");
                                    lab.ToolTip = string.Format("BOŞ (9:0)");
                                    lab.BackColor = FPSRenkList.Where(x => x.Firma == "" && x.Proje == "").FirstOrDefault().Renk;
                                    lab.Width = new Unit(810);
                                    lab.CssClass = "LabelCss";
                                    panel.Controls.Add(lab);
                                }

                            }
                        }
                        else
                        {
                            Label lab = new Label();
                            lab.Text = string.Format("BOŞ (9:0)");
                            lab.ToolTip = string.Format("BOŞ (9:0)");
                            lab.BackColor = FPSRenkList.Where(x => x.Firma == "" && x.Proje == "").FirstOrDefault().Renk;
                            lab.Width = new Unit(810);
                            lab.CssClass = "LabelCss";
                            panel.Controls.Add(lab);
                        }

                    }

                    TabloTakvim2.Rows.Add(TRow);
                }

                TabloTakvim2.Width = (810 * TarihList.Count);

            }
            catch (Exception hata)
            {
                MesajVer(hata: hata);
            }
            
        }

        


    }
}