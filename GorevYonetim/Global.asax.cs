using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.SessionState;
using System.Data;
using System.Data.Linq;
using System.Web.Configuration;
using GorevYonetim.App_Data;

namespace GorevYonetim
{
    public class Global : System.Web.HttpApplication
    {
        #region Application Methods
        void Application_Start(object sender, EventArgs e)
        {
            Application["UsersOnline"] = 0;
            //System.Web.HttpContext.Current.Session["Server"] = WebConfigurationManager.AppSettings["Server"];
        }

        void Application_End(object sender, EventArgs e)
        {
            //  Code that runs on application shutdown

        }

        void Application_Error(object sender, EventArgs e)
        {
            // Code that runs when an unhandled error occurs            
        }

        void Session_Start(object sender, EventArgs e)
        {
            Global.Kullanici.IsNull(); 
            Application.Lock();
            Application["UsersOnline"] = (int)Application["UsersOnline"] + 1;
            Application.UnLock();
        }

        void Session_End(object sender, EventArgs e)
        {
            Application.Lock();
            Application["UsersOnline"] = (int)Application["UsersOnline"] - 1;
            Application.UnLock();
            //System.Web.HttpContext.Current.Response.Redirect("~/Pages/Default.aspx");
            //Global.Kullanici.IsNull();
            // Code that runs when a session ends. 
            // Note: The Session_End event is raised only when the sessionstate mode
            // is set to InProc in the Web.config file. If session mode is set to StateServer 
            // or SQLServer, the event is not raised.
        }
        #endregion ///Application Methods

        #region Connection Properties
        public static string Server
        {
            get
            {
                return WebConfigurationManager.AppSettings["Server"];
            }
        }

        public static string Database
        {
            get
            {
                return WebConfigurationManager.AppSettings["Database"];
            }
        }

        public static string UserID
        {
            get
            {
                return WebConfigurationManager.AppSettings["UserID"];
            }
        }

        public static string Parola
        {
            get
            {
                return WebConfigurationManager.AppSettings["Parola"];
            }
        }

        public static string ConStr
        {
            get
            {
                return string.Format("Server={0}; Database={1}; Uid={2}; Pwd={3}", Server, Database, UserID, Parola);
            }
        }
        #endregion  ///Connection Properties


        public static Kullanici Kullanici
        {
            get
            {
                if (System.Web.HttpContext.Current.Session["User"] == null)
                {
                    //System.Web.HttpContext.Current.Session.Abandon(); /// Tüm diğer sessionları siler
                    System.Web.HttpContext.Current.Response.Redirect("~/Pages/Default.aspx");
                }
                return ((Kullanici)System.Web.HttpContext.Current.Session["User"]);
            }
            set
            {
                System.Web.HttpContext.Current.Session["User"] = value;
                if (value == null)
                {
                    //System.Web.HttpContext.Current.Session.Abandon(); /// Tüm diğer sessionları siler
                    System.Web.HttpContext.Current.Response.Redirect("~/Pages/Default.aspx");
                }
            }
        }


        public enum MesajTip
        {
            None, Bilgi, Hata, Uyari
        }

 
        private static string shema = string.Empty;
        /// <summary>
        /// <para>1.Kullanım şekli Ayarlar.Shema="FINSAT601,FINSAT684" </para>
        /// <para>Bu kullanımla FINSAT601 olanlar FINSAT684 oluyor. Diğer şemalar değişmiyor. </para>
        /// <para>2.Kullanım şekli Ayarlar.Shema="*,FINSAT684" </para>
        /// <para>Bu kullanımla tüm şemalar FINSAT684 olur. Bu kullanım tavsiye edilmez.</para>
        /// <para>Not:Şemalar arasına virgül konur. İfade içindeki boşluklar trimle atıldığı için sorun oluşturmaz.</para>
        /// </summary>
        public static string Shema
        {
            get
            {
                return shema;
            }
            set
            {
                if (value.Split(',').Length == 2)
                    shema = value;
                else
                    throw new Exception("Şemaya aktarılan değer uygun formatta değil !\nÖrnek Kullanım: Ayarlar.Shema=\"FINSAT601,FINSAT684\" şeklinde olmalıdır.");
            }
        }

        public static IDbConnection Con = new System.Data.SqlClient.SqlConnection(ConStr);

        public static DataContext DBContext
        {
            get
            {
                return new DataContext(Con, new CustomMappingSource(Shema));
            }
        }



    }
}
