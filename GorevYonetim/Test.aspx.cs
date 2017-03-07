using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

using AjaxControlToolkit.Sanitizer;


namespace GorevYonetim
{
    public partial class Test : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            //if (Request.QueryString["preview"] == "1" && !string.IsNullOrEmpty(Request.QueryString["fileId"]))
            //{
            //    var fileId = Request.QueryString["fileId"];
            //    var fileContents = (byte[])Session["fileContents_" + fileId];
            //    var fileContentType = (string)Session["fileContentType_" + fileId];

            //    if (fileContents != null)
            //    {
            //        Response.Clear();
            //        Response.ContentType = fileContentType;
            //        Response.BinaryWrite(fileContents);
            //        Response.End();
            //    }
            //}
            //htmlEditorExtender1.AjaxFileUpload.AllowedFileTypes = "jpg,jpeg,JPG";
        }

        protected void htmlEditorExtender1_ImageUploadComplete(object sender, AjaxControlToolkit.AjaxFileUploadEventArgs e)
        {
           // if (e.ContentType.Contains("jpg") || e.ContentType.Contains("gif")
           //|| e.ContentType.Contains("png") || e.ContentType.Contains("jpeg"))
           // {
           //     Session["fileContentType_" + e.FileId] = e.ContentType;
           //     Session["fileContents_" + e.FileId] = e.GetContents();
           // }

           // // Set PostedUrl to preview the uploaded file.         
           // e.PostedUrl = string.Format("?preview=1&fileId={0}", e.FileId);
        }
    }
}