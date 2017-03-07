using GorevYonetim.App_Data;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace GorevYonetim
{
    public partial class AjaxIslemler : System.Web.UI.Page
    {
        // Önyüzü olmayan webform u servis gibi kullanıp ajax ile verileri çekiyorum.
        // Yapacağım işlemi queryString ile kontrol edip karar veriyorum.
        protected void Page_Load(object sender, EventArgs e)
        {
            #region Değişkenker
            // Json obejsini Response.Write ile geri veri döndürmede kullanıyorum
            string json = "";

            // Ajax post ile geldiğimde linkte gönderdiğim işlem tipini alıyorum.
            string islem = "";

            // Ajax post ile data gönderdiğim zaman dolduracağım değişkenker
            string Firma = "";
            string Proje = "";
            string Form = "";
            string TahBitisTarihi = "";
            string Oncelik = "";
            string Durum = "";
            string Gorev = "";
            string Aciklama = "";
            string Sorumlu = "";

            // Session' da login yapmış kullanıcı bilgilerini alıyorum
            Kullanici kln = new App_Data.Kullanici();
            kln = (Kullanici)Session["User"];

            // Sorgularda bugüne ait kayıtları döndürmek için bugünün tarihini ve bir sonraki günün
            // tarihini alıyorum aralık verebilmek için.
            string date = DateTime.Today.Date.ToString("yyyy/MM/dd");

            string date2 = DateTime.Today.AddDays(1).Date.ToString("yyyy/MM/dd");
            #endregion

            #region QueryString İşlemleri
            // Ajax post ile gönderdiğim istek mi yoksa data mı ayırt etmek için
            if (Request.QueryString["islem"] != null)
            {
                // Ajaxta url kısmına yazdığım key ve değerini alıyorum
                islem = Request.QueryString["islem"].ToString();

                // Ajax ile 'GetCompanies' adında url yardımıyla isteki gönderiyorum
                #region Firmalar
                if (islem == "GetCompanies")
                {
                    string JsonString = string.Empty;
                    string Query = @"Select Distinct Firma
                             From ong.Musteri";
                    DataTable DT = new DataTable();

                    SqlConnection Con = new SqlConnection(ConfigurationManager.ConnectionStrings["OnikimGorevConnectionString"].ToString());
                    Con.Open();

                    SqlCommand Cmd = new SqlCommand(Query, Con);
                    SqlDataAdapter sDa = new SqlDataAdapter(Cmd);

                    sDa.Fill(DT);

                    Con.Close();
                    // Newtonstf JSON Serialize ile elde ettiğim veriyi JSON a çeviriyorum
                    json = Newtonsoft.Json.JsonConvert.SerializeObject(DT);

                    // Elde ettiğim json objesini sayfaya geri döndürüyorum
                    Response.Write(json);
                }
                #endregion

                // Ajax ile 'GetProject' adında istek gönderiyorum ve hangi firmanın projelerini istediğimi url de belirtiyorum
                #region Firmaların Projeleri
                if (islem == "GetProject")
                {
                    string JsonString = string.Empty;
                    string Query = @"Select Distinct Proje from ong.ProjeForm where Firma ='" + Request.QueryString["Value"].ToString() + "'";
                    DataTable DT = new DataTable();

                    SqlConnection Con = new SqlConnection(ConfigurationManager.ConnectionStrings["OnikimGorevConnectionString"].ToString());

                    Con.Open();

                    SqlCommand Cmd = new SqlCommand(Query, Con);
                    SqlDataAdapter sDa = new SqlDataAdapter(Cmd);

                    sDa.Fill(DT);

                    Con.Close();

                    json = Newtonsoft.Json.JsonConvert.SerializeObject(DT);

                    Response.Write(json);
                }
                #endregion

                // Ajax ile 'GetForm' adında istek gönderiyorum ve hangi projenin formlarını istediğimi url de belirtiyorum
                #region Projelere ait formlar
                if (islem == "GetForm")
                {
                    /*
                     Ado.NET kullanıyorum, projelere ait formları sorgu ile çekiyorum. Herhangi bir veri çoklama işlemine takılmamak için distinct kullanıyorum.
                     */
                    string JsonString = string.Empty;
                    string Query = @"Select distinct Form from ong.ProjeForm where Proje ='" + Request.QueryString["Value"].ToString() + "'";
                    DataTable DT = new DataTable();

                    SqlConnection Con = new SqlConnection(ConfigurationManager.ConnectionStrings["OnikimGorevConnectionString"].ToString());

                    Con.Open();
                    SqlCommand Cmd = new SqlCommand(Query, Con);
                    SqlDataAdapter sDa = new SqlDataAdapter(Cmd);

                    sDa.Fill(DT);

                    Con.Close();

                    //Newtonsoft' u sayfaya veri döndürürken JSON a çevirmek için kullanıyorum. Böylelikle javascript ile sayfada rahatça işleyebiliyorum.

                    json = Newtonsoft.Json.JsonConvert.SerializeObject(DT);

                    Response.Write(json);
                }
                #endregion

                // Ajax ile oncelik ve durumları döndürecek istekleri yapıyorum
                #region Öncelik ve Durum 
                if (islem == "GetPriority")
                {
                    /*
                     Ado.NET kullanıyorum, öncelik durumlarını sorgu ile çekiyorum. Herhangi bir veri çoklama işlemine takılmamak için distinct kullanıyorum.
                     */
                    string JsonString = string.Empty;
                    string Query = @"Select distinct Kod,KodInt from ong.Tanim where Tip = '0'";
                    DataTable DT = new DataTable();

                    SqlConnection Con = new SqlConnection(ConfigurationManager.ConnectionStrings["OnikimGorevConnectionString"].ToString());

                    Con.Open();

                    SqlCommand Cmd = new SqlCommand(Query, Con);
                    SqlDataAdapter sDa = new SqlDataAdapter(Cmd);

                    sDa.Fill(DT);

                    Con.Close();

                    //Newtonsoft' u sayfaya veri döndürürken JSON a çevirmek için kullanıyorum. Böylelikle javascript ile sayfada rahatça işleyebiliyorum.

                    json = Newtonsoft.Json.JsonConvert.SerializeObject(DT);

                    Response.Write(json);
                }

                if (islem == "GetStatus")
                {
                    /*
                     Ado.NET kullanıyorum, öncelik durumlarını sorgu ile çekiyorum. Herhangi bir veri çoklama işlemine takılmamak için distinct kullanıyorum.
                     */
                    string JsonString = string.Empty;
                    string Query = @"Select distinct Kod,KodInt from ong.Tanim where Tip = '1'";
                    DataTable DT = new DataTable();

                    SqlConnection Con = new SqlConnection(ConfigurationManager.ConnectionStrings["OnikimGorevConnectionString"].ToString());

                    Con.Open();

                    SqlCommand Cmd = new SqlCommand(Query, Con);
                    SqlDataAdapter sDa = new SqlDataAdapter(Cmd);

                    sDa.Fill(DT);

                    Con.Close();

                    //Newtonsoft' u sayfaya veri döndürürken JSON a çevirmek için kullanıyorum. Böylelikle javascript ile sayfada rahatça işleyebiliyorum.

                    json = Newtonsoft.Json.JsonConvert.SerializeObject(DT);

                    Response.Write(json);
                }
                #endregion

                // Sayfada atama göreve sorumlu ataması yapılmak istediğinde açılan DDL yi doldurmak için istek yapıyorum
                #region Yazılım Sorumluları
                if (islem == "GetDevelopers")
                {
                    string JsonString = string.Empty;
                    string Query = @"Select
                                	KulKodu
                                From
                                	ong.Kullanici
                                Where
                                	YetkiKod = 2";
                    DataTable DT = new DataTable();

                    SqlConnection Con = new SqlConnection(ConfigurationManager.ConnectionStrings["OnikimGorevConnectionString"].ToString());

                    Con.Open();

                    SqlCommand Cmd = new SqlCommand(Query, Con);
                    SqlDataAdapter sDa = new SqlDataAdapter(Cmd);

                    sDa.Fill(DT);

                    Con.Close();

                    json = Newtonsoft.Json.JsonConvert.SerializeObject(DT);

                    Response.Write(json);
                }
                #endregion

                // Giriş yapan kullanıcının o günkü görevlerini alabilmek için istek yapıyorum
                #region Görevler
                if (islem == "GetJobs")
                {
                    string JsonString = string.Empty;
                    string Query = @"select 
                                 	ID,Firma,Proje,Form,Gorev,Aciklama,TahminiBitisTarih,Sorumlu,
                                 	(select Kod from ong.Tanim where Tip = '0' and KodInt = G.Oncelik) as 'Oncelik',
                                 	(select Kod from ong.Tanim where Tip = '1' and KodInt = G.Durum) as 'Durum'
                                 from 
                                 	ong.Gorevler AS G
                                 where 
                                 	sorumlu = '" + kln.KulKodu
                                       + "'and KayitTarih between '" + date + "' and '" + date2 + "' Order By Firma";
                    //
                    //+"'and KayitTarih between '" + date + "' and '" + date2 + "' Order By Oncelik ASC"

                    DataTable DT = new DataTable();

                    SqlConnection Con = new SqlConnection(ConfigurationManager.ConnectionStrings["OnikimGorevConnectionString"].ToString());

                    Con.Open();

                    SqlCommand Cmd = new SqlCommand(Query, Con);
                    SqlDataAdapter sDa = new SqlDataAdapter(Cmd);

                    sDa.Fill(DT);

                    Con.Close();

                    json = Newtonsoft.Json.JsonConvert.SerializeObject(DT);

                    Response.Write(json);
                }
                #endregion

                // Giriş yapan kullanıcı listeden bir görevi seçip açmak isterse o görevi döndürecek isteği işliyorum
                #region Seçilen görevi al
                if (islem == "GetSelectedJob")
                {
                    string JsonString = string.Empty;
                    string Query = @"select 
                                 	ID,Firma,Proje,Form,Gorev,Aciklama,TahminiBitisTarih,Sorumlu,Oncelik,Durum
                                 from 
                                 	ong.Gorevler AS G
                                 where 
                                 	G.ID =" + Request.QueryString["ID"] +
                                        "Order By Firma";
                    DataTable DT = new DataTable();

                    SqlConnection Con = new SqlConnection(ConfigurationManager.ConnectionStrings["OnikimGorevConnectionString"].ToString());

                    Con.Open();

                    SqlCommand Cmd = new SqlCommand(Query, Con);
                    SqlDataAdapter sDa = new SqlDataAdapter(Cmd);

                    sDa.Fill(DT);

                    Con.Close();

                    json = Newtonsoft.Json.JsonConvert.SerializeObject(DT);

                    Response.Write(json);
                }
                #endregion

            }
            #endregion

            #region Request.Form işlemleri

            // Ajax post ile gönderdiğim istek mi yoksa data mı ayırt etmek için
            if (Request.Form["islem"] != null)
            {
                if (Request.Form["islem"].ToString() == "AddJob")
                {
                    // Ajax post tarafında gönderdiğim  key value ilişkisi ile verileri alıyorum.
                    #region Değişkenler
                    Firma = Request.Form["Firma"].ToString();

                    Proje = Request.Form["Proje"].ToString();

                    Form = Request.Form["Form"].ToString();

                    TahBitisTarihi = Request.Form["TahminiBitisTarih"].ToString();

                    Oncelik = Request.Form["Oncelik"].ToString();

                    Durum = Request.Form["Durum"].ToString();

                    Gorev = Request.Form["Gorev"].ToString();

                    Aciklama = Request.Form["Aciklama"].ToString();

                    Sorumlu = Request.Form["Sorumlu"].ToString();
                    #endregion

                    string Query = @"
                                        INSERT INTO ong.Gorevler 
                                        				(
                                        					Firma,Proje,Form,Sorumlu
                                        					,Gorev,Aciklama,Oncelik,Durum
                                        					,TahminiBitisTarih,BitisTarih,Kaydeden,KayitTarih
                                        					,Degistiren,DegisTarih
                                        				)
                                        VALUES (
                                        				@Firma, @Proje, @Form
                                        				, @Sorumlu, @Gorev, @Aciklama
                                        				, @Oncelik, @Durum, @TahminiBitisTarih, @BitisTarih
                                        				, @Kaydeden ,@KayitTarih, @Degistiren
                                        				, @DegisTarih
                                        	   )";



                    SqlConnection Con = new SqlConnection(ConfigurationManager.ConnectionStrings["OnikimGorevConnectionString"].ToString());

                    SqlCommand Cmd = new SqlCommand(Query, Con);

                    Cmd.Parameters.AddWithValue("@Firma", Firma);
                    Cmd.Parameters.AddWithValue("@Proje", Proje);
                    Cmd.Parameters.AddWithValue("@Form", Form);
                    Cmd.Parameters.AddWithValue("@Sorumlu", Sorumlu);
                    Cmd.Parameters.AddWithValue("@Gorev", Gorev);
                    Cmd.Parameters.AddWithValue("@Aciklama", Aciklama);
                    Cmd.Parameters.AddWithValue("@Oncelik", Convert.ToInt32(Oncelik));
                    Cmd.Parameters.AddWithValue("@Durum", Convert.ToInt32(Durum));
                    Cmd.Parameters.AddWithValue("@TahminiBitisTarih", TahBitisTarihi);
                    Cmd.Parameters.AddWithValue("@BitisTarih", TahBitisTarihi);
                    Cmd.Parameters.AddWithValue("@Kaydeden", kln.KulKodu);
                    Cmd.Parameters.AddWithValue("@KayitTarih", date);
                    Cmd.Parameters.AddWithValue("@Degistiren", kln.KulKodu);
                    Cmd.Parameters.AddWithValue("@DegisTarih", date);

                    Con.Open();
                    Cmd.ExecuteNonQuery();
                    Con.Close();
                }
                else if (Request.Form["islem"].ToString() == "EditJob")
                {
                    #region Değişkenler

                    string ID = Request.Form["ID"].ToString();

                    Firma = Request.Form["Firma"].ToString();

                    Proje = Request.Form["Proje"].ToString();

                    Form = Request.Form["Form"].ToString();

                    TahBitisTarihi = Request.Form["TahminiBitisTarih"].ToString();

                    Oncelik = Request.Form["Oncelik"].ToString();

                    Durum = Request.Form["Durum"].ToString();

                    Gorev = Request.Form["Gorev"].ToString();

                    Aciklama = Request.Form["Aciklama"].ToString();

                    Sorumlu = Request.Form["Sorumlu"].ToString();
                    #endregion

                    string Query = @" Update ong.Gorevler 
                                      Set 
                                    	Firma = @Firma
                                    	,Proje =@Proje
                                    	,Form = @Form
                                    	,Sorumlu = @Sorumlu
                                    	,Gorev = @Gorev
                                    	,Aciklama = @Aciklama
                                    	,Oncelik = @Oncelik
                                    	,Durum = @Durum
                                    	,TahminiBitisTarih = @TahminiBitisTarih
                                    	,BitisTarih = @BitisTarih
                                    	,Degistiren = @Degistiren
                                    	,DegisTarih = @DegisTarih
                                    Where
                                    	ID = "+ID+"";



                    SqlConnection Con = new SqlConnection(ConfigurationManager.ConnectionStrings["OnikimGorevConnectionString"].ToString());

                    SqlCommand Cmd = new SqlCommand(Query, Con);

                    Cmd.Parameters.AddWithValue("@Firma", Firma);
                    Cmd.Parameters.AddWithValue("@Proje", Proje);
                    Cmd.Parameters.AddWithValue("@Form", Form);
                    Cmd.Parameters.AddWithValue("@Sorumlu", Sorumlu);
                    Cmd.Parameters.AddWithValue("@Gorev", Gorev);
                    Cmd.Parameters.AddWithValue("@Aciklama", Aciklama);
                    Cmd.Parameters.AddWithValue("@Oncelik", Convert.ToInt32(Oncelik));
                    Cmd.Parameters.AddWithValue("@Durum", Convert.ToInt32(Durum));
                    Cmd.Parameters.AddWithValue("@TahminiBitisTarih", TahBitisTarihi);
                    Cmd.Parameters.AddWithValue("@BitisTarih", TahBitisTarihi);
                    Cmd.Parameters.AddWithValue("@Degistiren", kln.KulKodu);
                    Cmd.Parameters.AddWithValue("@DegisTarih", date);

                    Con.Open();
                    Cmd.ExecuteNonQuery();
                    Con.Close();
                }


            }

            #endregion

        }
    }
}