using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.Script.Services;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using AjaxControlToolkit;

namespace GorevYonetim
{
    public partial class DestekGorevler : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            

        }

        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static string GetFirma()
        {
            string JsonString = string.Empty;
            string Query = @"Select Distinct Firma
                             From ong.Musteri";
            DataTable DT = new DataTable();

            SqlConnection Con = new SqlConnection(ConfigurationManager.ConnectionStrings["OnikimGorevConnectionString"].ToString());

            SqlCommand Cmd = new SqlCommand(Query, Con);
            SqlDataAdapter sDa = new SqlDataAdapter(Cmd);

            sDa.Fill(DT);

            JsonString = Newtonsoft.Json.JsonConvert.SerializeObject(DT);
            return JsonString;
        }
    }
}