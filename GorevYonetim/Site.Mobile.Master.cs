using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace GorevYonetim
{
	public partial class SiteMobile : System.Web.UI.MasterPage
	{
		protected void Page_Load(object sender, EventArgs e)
		{
            Global.Kullanici.IsNull();  /// Eğer Kullanici Null ise get gloğunda Defaul.aspx sayfasına yönleniyor..
		}
	}
}