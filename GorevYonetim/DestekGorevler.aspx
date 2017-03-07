<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="DestekGorevler.aspx.cs" Inherits="GorevYonetim.DestekGorevler" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="ajaxToolkit" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">

    <% string KulKod = ((GorevYonetim.App_Data.Kullanici)Session["User"]).KulKodu.ToString();  %>
    <%string today = DateTime.Today.Date.ToString("yyyy'-'MM'-'dd");%>

    <title>Destek Görevleri</title>
    <link href="assets/css/bootstrap.min.css" rel="stylesheet" />
    <script type="text/javascript" src="Scripts/jquery-3.1.1.js"></script>
    <script type="text/javascript" src="assets/js/bootstrap.js"></script>
    <script type="text/javascript">

        var ID = "";

        $(function () {

            $(document).keydown(function (e) {
                if (e.which == 113) {  // F2 YENİ KAYIT
                    $("#pnlDestekGorev")
                        .slideDown();

                    $("#btnEditJob")
                        .attr("style", "display:none");

                    $("#btnAddJob")
                        .attr("style", "display:block");

                    $("#slcProject")
                        .find("option")
                        .remove()
                        .end()
                        .append("<option value=' - '>-</option>");

                    $("#slcForm")
                        .find("option")
                        .remove()
                        .end()
                        .append("<option value=' - '>-</option>");

                    $("#slcStatus").val("0"); // Yeni kayıt için panel açıldığında combobox ın seçili gelmesi için

                    $("#slcPriority").val("1"); // Yeni kayıt için panel açıldığında combobox ın seçili gelmesi için

                    $("#dtpFinalDate").val("<%=today%>"); // Yeni kayıt için panel açıldığında tarihin bugünü göstermesi için

                    $("#txtJobTitle").val(""); // Yeni kayıt için panel açıldığında Textbox ın boş gelmesi için

                    $("#slcCompany").val(" - ");

                    // TinyMCE nin kendi metodlarından, editörün içerisine veri aktarmak için setContent() metodu kullanılıyor.
                    // Buradaki amaç yeni kayıt ekranında belirli alanların sıfırlanması.
                    // getContent() metodu ile editör içerisinde bulunan kodları alabiliyoruz.
                    tinyMCE.activeEditor.setContent("");

                    return false;
                }
                else if (e.which == 27) { // ESC POPUPLARI KAPAT
                    $("#pnlDestekGorev").slideUp();
                    return false;
                }
            });
        }); //F2 ve Esc tuşlarına komut atama

        // Firmaları, projelerini ve onlara ait formları getirmek için kullanıldı. AjaxIslemleri sayfası servis gibi çalışmaktadır.
        function GetCompanies() {

            // Firmaların doldurulduğu select ögesini bulup, içerisini siliyorum. Append ile içerisine standart bir terim ekliyorum. Böylelikle hem verilerin yığılmasını önlemiş oluyorum hem de manasız bir satır ekleterek kullanıcıyı seçim yapmaya mecbur bırakıyorum.
            $("#slcCompany")
                .find("option")
                .remove()
                .end()
                .append("<option value=' - '>-</option>");

            $("#slcProject")
                .find("option")
                .remove()
                .end()
                .append("<option value=' - '>-</option>");

            $("#slcForm")
                .find("option")
                .remove()
                .end()
                .append("<option value=' - '>-</option>");

            var WebRetCode = new Object();

            var list = null;

            // Ajax kullanarak, servis gibi kullandığım webform u çağırıyorum. Data yı boş gönderiyorum. Ajax eksik yazıldığında hata verebiliyor.
            // Success olduğunda servisten response ile gönderdiğimi JSON objesine çeviriyorum. Bu obje içerisinde for ile döniüp gönderdiğim verileri select nesnesine ekliyorum.
            try {
                $.ajax({

                    method: "POST",
                    async: false,
                    url: "/AjaxIslemler.aspx?islem=GetCompanies",
                    data: "{}",
                    success: function (data) {

                        WebRetCode = JSON.parse(data);
                        for (var i = 0; i < WebRetCode.length; i++) {
                            $("#slcCompany").append("<option value='" + WebRetCode[i].Firma + "'>" + WebRetCode[i].Firma + "</option>");
                        }
                    },
                    error: function (data) { },
                    complete: function (data) { }
                });

            }
            catch (e) {

            }
            return WebRetCode;
        }

        function GetProjects() {

            $("#slcProject")
                .find("option")
                .remove()
                .end()
                .append("<option value=' - '>-</option>");

            $("#slcForm")
                .find("option")
                .remove()
                .end()
                .append("<option value=' - '>-</option>");

            var WebRetCode = new Object();

            var list = null;

            var company = $("#slcCompany :selected").text();

            try {
                $.ajax({

                    method: "POST",
                    async: false,
                    url: "/AjaxIslemler.aspx?islem=GetProject&Value=" + company,
                    data: "{}",
                    success: function (data) {

                        WebRetCode = JSON.parse(data);
                        for (var i = 0; i < WebRetCode.length; i++) {

                            $("#slcProject").append("<option value='" + WebRetCode[i].Proje + "'>" + WebRetCode[i].Proje + "</option>");


                        }
                    },
                    error: function (data) { },
                    complete: function (data) { }
                });

            }
            catch (e) {

            }
            return WebRetCode;
        }

        function GetForms() {
            $("#slcForm")
                .find("option")
                .remove()
                .end()
                .append("<option value=' - '>-</option>");

            var WebRetCode = new Object();

            var list = null;

            var project = $("#slcProject :selected").text();

            try {
                $.ajax({

                    method: "POST",
                    async: false,
                    url: "/AjaxIslemler.aspx?islem=GetForm&Value=" + project,
                    data: "{}",
                    success: function (data) {

                        WebRetCode = JSON.parse(data);
                        for (var i = 0; i < WebRetCode.length; i++) {
                            if (WebRetCode[i].Form != "") {
                                $("#slcForm").append("<option value='" + WebRetCode[i].Form + "'>" + WebRetCode[i].Form + "</option>");
                            }
                        }
                    },
                    error: function (data) { },
                    complete: function (data) { }
                });

            }
            catch (e) {

            }
            return WebRetCode;
        }

        function GetJobs() {
            $("#tblJobs").find("tr").remove().end();

            var WebRetCode = new Object();

            var list = null;

            var project = $("#slcProject :selected").text();

            try {
                $.ajax({

                    method: "POST",
                    async: false,
                    url: "/AjaxIslemler.aspx?islem=GetJobs",
                    data: "{}",
                    success: function (data) {

                        WebRetCode = JSON.parse(data);
                        for (var i = 0; i < WebRetCode.length; i++) {

                            var date = "--";
                            var color = "";

                            // Görevin durumuna bakarak renk atamasını gerçekleştiriyorum
                            if (WebRetCode[i].Durum == "Onaylandı") {
                                color = "#27ae60";
                            }
                            else if (WebRetCode[i].Durum == "Beklemede") {
                                color = "#f1c40f";
                            }
                            else if (WebRetCode[i].Durum == "Kalite Kontrol") {
                                color = "#3498db";
                            }
                            else if (WebRetCode[i].Durum == "Durduruldu") {
                                color = "#e74c3c";
                            }
                            else if (WebRetCode[i].Durum == "Atandı") {
                                color = "#9b59b6";
                            }
                            else if (WebRetCode[i].Durum == "Oluşturuldu") {
                                color = "#95a5a6";
                            }
                            else if (WebRetCode[i].Durum == "Onaylandı") {
                                color = "#2ecc71";
                            }
                            else if (WebRetCode[i].Durum == "Reddedildi") {
                                color = "#c0392b";
                            }
                            else if (WebRetCode[i].Durum == "Onay Ver") {
                                color = "#bdc3c7";
                            }
                            else if (WebRetCode[i].Durum == "Başlandı") {
                                color = "#27ae60";
                            }
                            else if (WebRetCode[i].Durum == "Bitti") {
                                color = "#2ecc71";
                            }
                            
                            //Gelen tarih alanında istenmeyen kısımları ayırıyorum
                            if (WebRetCode[i].TahminiBitisTarih != null) {
                                var DateTime = WebRetCode[i].TahminiBitisTarih.split("T");
                                date = DateTime[0];
                            }
                            $("#tblJobs")
                                .append("<tr><td>" +
                                WebRetCode[i].Firma + "</td><td>" +
                                WebRetCode[i].Proje + "</td><td>" +
                                WebRetCode[i].Form + "</td><td>" +
                                WebRetCode[i].Gorev + "</td><td>" +
                                date + "</td><td>" +
                                WebRetCode[i].Sorumlu + "</td><td>" +
                                WebRetCode[i].Oncelik + "</td><td style='background-color:"+color+";'>" +
                                WebRetCode[i].Durum + "</td>" + "<td>" +
                                "<a id=" + WebRetCode[i].ID +
                                " class='btn btn-md btn-block btn-primary glyphicon glyphicon-pencil' onclick='GetSelectedJob(this)'/>"
                                + "</td></tr>");


                        }
                    },
                    error: function (data) { },
                    complete: function (data) { }
                });

            }
            catch (e) {

            }
            return WebRetCode;
        }

        // Göreve atanacak öncelik sırasını ve durumunu döndüren Ajax Metodları
        function GetPriorities() {
            $("#slcPriority")
                .find("option")
                .remove()
                .end()
                .append("<option value=' - '>-</option>");

            var WebRetCode = new Object();

            try {
                $.ajax({

                    method: "POST",
                    async: false,
                    url: "/AjaxIslemler.aspx?islem=GetPriority",
                    data: "{}",
                    success: function (data) {
                        WebRetCode = JSON.parse(data);
                        for (var i = 0; i < WebRetCode.length; i++) {

                            $("#slcPriority").append("<option value='" + WebRetCode[i].KodInt + "'>" + WebRetCode[i].Kod + "</option>");

                        }
                    },
                    error: function (data) { },
                    complete: function (data) { }
                });

            }
            catch (e) {

            }
            return WebRetCode;
        }

        function GetStatus() {
            $("#slcStatus")
                .find("option")
                .remove()
                .end()
                .append("<option value=' - '>-</option>");

            var WebRetCode = new Object();

            try {
                $.ajax({

                    method: "POST",
                    async: false,
                    url: "/AjaxIslemler.aspx?islem=GetStatus",
                    data: "{}",
                    success: function (data) {
                        WebRetCode = JSON.parse(data);
                        for (var i = 0; i < WebRetCode.length; i++) {

                            $("#slcStatus").append("<option value='" + WebRetCode[i].KodInt + "'>" + WebRetCode[i].Kod + "</option>");

                        }
                    },
                    error: function (data) { },
                    complete: function (data) { }
                });

            }
            catch (e) {

            }
            return WebRetCode;
        }

        // Görev atanacak yazılım departmanı çalışanları
        function GetDevelopers() {
            $("#slcDevelopers")
                .find("option")
                .remove()
                .end()
                .append("<option value=' - '>-</option>");

            var WebRetCode = new Object();

            try {
                $.ajax({

                    method: "POST",
                    async: false,
                    url: "/AjaxIslemler.aspx?islem=GetDevelopers",
                    data: "{}",
                    success: function (data) {
                        WebRetCode = JSON.parse(data);
                        for (var i = 0; i < WebRetCode.length; i++) {
                            if (WebRetCode[i].KulKodu != "") {
                                $("#slcDevelopers").append("<option value='" + WebRetCode[i].KulKodu + "'>" + WebRetCode[i].KulKodu + "</option>");
                            }
                        }
                    },
                    error: function (data) { },
                    complete: function (data) { }
                });

            }
            catch (e) {

            }
            return WebRetCode;

        }

        // Görev ata checkbox işaretlendiğinde 
        function JobTransfer(e) {

            $("#divDevelopers").slideToggle();

        }

        // Satırlarda bulunan Button için
        function GetSelectedJob(e) {

            var WebRetCode = new Object();

            try {
                $.ajax({

                    method: "POST",
                    async: false,
                    url: "/AjaxIslemler.aspx?islem=GetSelectedJob&ID=" + e.id,
                    data: "{}",
                    success: function (data) {

                        // Seçtiğim satırda daha önceden atadığım ID yi global bir değişken ID ye atayıp güncelleme işlemlerinde kullanıyorum.
                        ID = e.id;

                        WebRetCode = JSON.parse(data);

                        $("#txtJobTitle").val(WebRetCode[0].Gorev);

                        tinyMCE.activeEditor.setContent(WebRetCode[0].Aciklama);

                        $("#slcCompany").val(WebRetCode[0].Firma);

                        GetProjects();

                        $("#slcProject").val(WebRetCode[0].Proje);

                        GetForms();

                        $("#slcForm").val(WebRetCode[0].Form);
                        $("#slcPriority").val(WebRetCode[0].Oncelik);
                        $("#slcStatus").val(WebRetCode[0].Durum);

                        if (WebRetCode[0].TahminiBitisTarih != null) {
                            var DateTime = WebRetCode[0].TahminiBitisTarih.split("T");
                            var date = "";
                            date = DateTime[0].toString();
                            $("#dtpFinalDate").val(date);
                        }

                        $("#pnlDestekGorev").slideDown();

                        $("#btnAddJob")
                        .attr("style", "display:none");

                        $("#btnEditJob")
                            .attr("style", "display:block");
                    },
                    error: function (data) { },
                    complete: function (data) { }
                });

            }
            catch (e) {

            }
            return WebRetCode;

        }

        // Yeni görev eklemek için
        function AddJob() {

            var Company = $("#slcCompany").val();
            var Project = $("#slcProject").val();
            var Form = $("#slcForm").val();
            var FinalDate = $("#dtpFinalDate").val();
            var Priority = $("#slcPriority").val();
            var Status = $("#slcStatus").val();
            var JobTitle = $("#txtJobTitle").val();
            var JobDescription = tinyMCE.activeEditor.getContent();
            var Person = "<% =KulKod%>";

            if ($("#chkJobTransfer").checked) {

                Person = $("#slcDevelopers").val();
            }

            try {

                if (JobTitle == "" | JobTitle == null) {

                    throw "Görev için başlık giriniz !";

                } else if (Company == " - ") {

                    throw "Görev için 'Firma' seçiniz !";

                } else if (Person == "" | Person == null | Person == " - ") {

                    throw "Kullanıcı bulunamadı !";
                }


                $.ajax({

                    method: "POST",
                    async: false,
                    url: "/AjaxIslemler.aspx",
                    data: {
                        "islem": "AddJob",
                        "Firma": Company,
                        "Proje": Project,
                        "Form": Form,
                        "TahminiBitisTarih": FinalDate,
                        "Oncelik": Priority,
                        "Durum": Status,
                        "Gorev": JobTitle,
                        "Aciklama": JobDescription,
                        "Sorumlu": Person
                    },
                    success: function () {
                        GetJobs();
                    },
                    error: function (data) { },
                    complete: function (data) { }
                });

            }
            catch (e) {

                alert(e);
                console.log(e.name);

            }
        }

        // Görev güncellemek için
        function EditJob() {

            var Company = $("#slcCompany").val();
            var Project = $("#slcProject").val();
            var Form = $("#slcForm").val();
            var FinalDate = $("#dtpFinalDate").val();
            var Priority = $("#slcPriority").val();
            var Status = $("#slcStatus").val();
            var JobTitle = $("#txtJobTitle").val();
            var JobDescription = tinyMCE.activeEditor.getContent();
            var Person = "<% =KulKod%>";

            if ($("#chkJobTransfer").checked) {

                Person = $("#slcDevelopers").val();
            }

            try {

                if (JobTitle == "" | JobTitle == null) {

                    throw "Görev için başlık giriniz !";

                } else if (Company == " - ") {

                    throw "Görev için 'Firma' seçiniz !";

                } else if (Person == "" | Person == null | Person == " - ") {

                    throw "Kullanıcı bulunamadı !";
                }


                $.ajax({

                    method: "POST",
                    async: false,
                    url: "/AjaxIslemler.aspx",
                    data: {
                        "islem": "EditJob",
                        "ID":ID,
                        "Firma": Company,
                        "Proje": Project,
                        "Form": Form,
                        "TahminiBitisTarih": FinalDate,
                        "Oncelik": Priority,
                        "Durum": Status,
                        "Gorev": JobTitle,
                        "Aciklama": JobDescription,
                        "Sorumlu": Person
                    },
                    success: function () {
                        GetJobs();
                    },
                    error: function (data) { },
                    complete: function (data) { }
                });

            }
            catch (e) {

                alert(e);
                console.log(e.name);

            }
        }

        // Sayfa açıldığında çalışacak olan metodlar ve atamalar
        $(document).ready(function () {

            GetDevelopers();
            GetPriorities();
            GetCompanies();
            GetStatus();
            GetJobs();

        });

    </script>
    <%-- TinyMCE HTML editör için gerekli olan Script, editörün gerektiği şekilde çalışması için internet bağlantısı gereklidir --%>
    <script src="//cdn.tinymce.com/4/tinymce.min.js"></script>
    <%-- TinyMCE editör üzerinde bulunan menüler ve özellikler tinymce.init içerisinde tanımlanır.--%>
    <script type="text/javascript">
        tinymce.init({
            selector: '#txtGorevAciklama',
            height: 150,
            theme: 'modern',
            plugins: [
              'advlist autolink lists link image charmap print preview hr anchor pagebreak',
              'searchreplace wordcount visualblocks visualchars code fullscreen',
              'insertdatetime media nonbreaking save table contextmenu directionality',
              'emoticons template paste textcolor colorpicker textpattern imagetools codesample'
            ],
            toolbar1: 'insertfile undo redo | styleselect | bold italic | alignleft aligncenter alignright alignjustify | bullist numlist outdent indent | link image print preview media | forecolor backcolor emoticons | codesample',
            image_advtab: true,
            templates: [
              { title: 'Test template 1', content: 'Test 1' },
              { title: 'Test template 2', content: 'Test 2' }
            ],
            content_css: [
              '//fonts.googleapis.com/css?family=Lato:300,300i,400,400i',
              '//www.tinymce.com/css/codepen.min.css'
            ]
        });
    </script>
</head>
<body>
    <form id="form1" runat="server">
        <asp:Panel ID="AnaPanel" runat="server">
            <br />
            <div class="container">
                <a href="/Gorev.aspx" class="glyphicon glyphicon-chevron-left"></a>
                <div class="panel panel-default" id="pnlDestekGorev" style="display: none;">
                    <div class="panel-body">
                        <div class="col-md-12">
                            <div class="row">
                                <div class="col-md-2">
                                    <div class="form-group">
                                        <label for="slcCompany">Firma</label>
                                        <select class="form-control" onchange="GetProjects()" id="slcCompany">
                                            <option value="-">-</option>
                                        </select>
                                    </div>
                                </div>
                                <div class="col-md-2">
                                    <div class="form-group">
                                        <label for="slcProject">Proje</label>
                                        <select class="form-control" onchange="GetForms()" id="slcProject">
                                            <option value="-">-</option>
                                        </select>
                                    </div>
                                </div>
                                <div class="col-md-2">
                                    <div class="form-group">
                                        <label for="slcForm">Form</label>
                                        <select class="form-control" id="slcForm">
                                            <option value="-">-</option>
                                        </select>
                                    </div>
                                </div>
                                <div class="col-md-2">
                                    <div class="form-group">
                                        <label for="dtpFinalDate">Tah.Bitiş Tarihi</label>
                                        <input type="date" class="form-control" style="height: 30px;" id="dtpFinalDate" />
                                    </div>
                                </div>
                                <div class="col-md-2">
                                    <div class="form-group">
                                        <label for="slcPriority">Öncelik</label>
                                        <select class="form-control" id="slcPriority">
                                            <option value="-">-</option>
                                        </select>
                                    </div>
                                </div>
                                <div class="col-md-2">
                                    <div class="form-group">
                                        <label for="slcStatus">Durum</label>
                                        <select class="form-control" id="slcStatus">
                                            <option value="-">-</option>
                                        </select>
                                    </div>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-md-7">
                                    <div class="form-group">
                                        <label for="txtJobTitle">Görev</label>
                                        <input type="text" id="txtJobTitle" class="form-control" required="required" />
                                    </div>
                                </div>
                                <div class="col-md-2">
                                    <div style="margin-top: 30px;" class="checkbox">
                                        <label>
                                            <input id="chkJobTransfer" type="checkbox" onclick="JobTransfer(this)" value="" />Görevi ata</label>
                                    </div>
                                </div>
                                <div class="col-md-3" id="divDevelopers" style="display: none">
                                    <div class="form-group">
                                        <label for="slcDeveloper">Sorumlu</label>
                                        <select class="form-control" id="slcDevelopers">
                                            <option value="-">-</option>
                                        </select>
                                    </div>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-md-12">
                                    <textarea id="txtGorevAciklama"></textarea>
                                </div>
                            </div>
                            <br />
                            <div class="row">
                                <div class="col-sm-12">
                                    <input type="button" style="display: none;" value="Görev Ekle" id="btnAddJob" class="btn btn-md btn-block btn-primary" onclick="AddJob()" />
                                    <input type="button" style="display: none;" value="Görev Güncelle" id="btnEditJob" class="btn btn-md btn-block btn-success" onclick="EditJob()" />
                                </div>
                            </div>
                        </div>

                    </div>
                </div>
                <div style="height: 400px; overflow-y: scroll;">
                    <table class="table table-hover">
                        <thead>
                            <tr>
                                <td>Firma</td>
                                <td>Proje</td>
                                <td>Form</td>
                                <td>Görev</td>
                                <td>Bitiş Tarihi</td>
                                <td>Sorumlu</td>
                                <td>Öncelik</td>
                                <td>Durum</td>
                                <td>İşlemler</td>
                            </tr>
                        </thead>
                        <tfoot>
                            <tr>
                                <td>Firma</td>
                                <td>Proje</td>
                                <td>Form</td>
                                <td>Görev</td>
                                <td>Bitiş Tarihi</td>
                                <td>Sorumlu</td>
                                <td>Öncelik</td>
                                <td>Durum</td>
                                <td>İşlemler</td>
                            </tr>
                        </tfoot>
                        <tbody id="tblJobs">
                        </tbody>
                    </table>
                </div>
            </div>
        </asp:Panel>
    </form>
</body>
</html>
