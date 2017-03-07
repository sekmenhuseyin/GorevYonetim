<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Gorev.aspx.cs" Inherits="GorevYonetim.Gorev" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="ajaxToolkit" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">

    <link rel="Stylesheet" href="Styles/GridStyle.css" />
    <link rel="Stylesheet" href="Styles/Gorev.css" />
    <style type="text/css">
        .klavuz {
            border: 1px solid #563d7c;
            border-radius: 5px;
            color: white;
            padding: 5px 30px 5px 5px;
            background-image: url('Images/next.png');
            background-position-y: 2px;
            background-position-x: 63px;
            background-color: #563d7c;
            background-repeat: no-repeat;
            position: absolute;
            top: 13px;
            right: 8px;
            width: 90px;
        }

        .tableKlavuzYedekleme {
            border: 2px solid gray;
        }
            .tableKlavuzYedekleme tr {
                height: 28px;
            }
                .tableKlavuzYedekleme tr th {
                    padding: 5px 4px 5px 10px;
                    color: white;
                    background-color: #606080;
                }
                .tableKlavuzYedekleme tr td {
                    padding: 1px 3px 1px 10px;
                }
                .tableKlavuzYedekleme tr:nth-child(even) td {
                    background-color: silver;
                    color: black;
                }
                    .tableKlavuzYedekleme tr:nth-child(even) td a {
                        color: black;
                    }
                        .tableKlavuzYedekleme tr:nth-child(even) td a:hover {
                            font-weight: bold;
                        }

                .tableKlavuzYedekleme tr:nth-child(odd) td {
                    background-color: aliceblue;
                    color: black;
                }
                    .tableKlavuzYedekleme tr:nth-child(odd) td a {
                        color: black;
                    }
                        .tableKlavuzYedekleme tr:nth-child(odd) td a:hover {
                            font-weight: bold;
                        }

        .btnProjeFormAcCss {
            vertical-align: -6px;
            background-size: cover;
            width: 24px;
            height: 24px;
            border: none;
            background-color: transparent;
            margin-left: -4px;
        }

            .btnProjeFormAcCss:hover {
                background-image: url('Images/add.png');
            }

        .KontrolGoster {
            display: block;
        }

        .KontrolGizle {
            display: none;
        }
    </style>

    <script type="text/javascript" src="assets/plugins/jquery-1.11.js"></script>

    <script type="text/javascript">

        $(function () {
            $(document).keydown(function (e) {
                if (e.which == 112) {  // F1 DÜRBÜN 
                    var popup1 = $("#<%=popupPanel.ClientID%>").css("display");
                    var popup2 = $("#<%=popupDurbunPanel.ClientID%>").css("display");
                    var popup3 = $("#<%=popupCalismaPanel.ClientID%>").css("display");
                    if (popup1 == "none" && popup2 == "none" && popup3 == "none") {
                        ShowPopup_Durbun();
                    }
                    return false;
                }
                else if (e.which == 113) {  // F2 YENİ KAYIT
                    var popup1 = $("#<%=popupPanel.ClientID%>").css("display");
                    var popup2 = $("#<%=popupDurbunPanel.ClientID%>").css("display");
                    var popup3 = $("#<%=popupCalismaPanel.ClientID%>").css("display");
                    if (popup1 == "none" && popup2 == "none" && popup3 == "none") {
                        ShowPopup_YeniKayit();
                    }
                    return false;
                }

                else if (e.which == 27) { // ESC POPUPLARI KAPAT
                    PopupPanelleriGizle();
                    return false;
                }

            });


            $("#<%=txtcSure.ClientID%>").keypress(function (e) {
                if (e.which != 8 && e.which != 0 && (e.which < 48 || e.which > 57)) {
                    //hata mesajı
                    $("#hataMessage").html("Sadece rakam").show().fadeOut("slow");
                    return false;
                }
            });


            $("#<%=ddlistProje.ClientID%>").live("change", function () {
                $(this).addClass("form-control");
            });

            // Popuptaki TextBoxların MaxLength özelliği çalışmıyor. Bizde burda sınırlıyoruz.
            $("#<%=txtGorev.ClientID%>").attr("maxlength", 40);
            $("#<%=txtAciklama.ClientID%>").attr("maxlength", 2000);
            $("#<%=txtDurumAciklama.ClientID%>").attr("maxlength", 2000);

            /// Tarih tipli textboxlara Takvim Popupı ekliyorum
            $(".txtTakvim").live("focus", function () {
                $(this).datepicker({
                    weekStart: 1,
                    showOn: 'button',
                    dateFormat: "dd.mm.yyyy",
                });
            });

            $("#<%=txtTahBitTarih.ClientID%>,#<%=txtTahBitTarihCus.ClientID%>,#<%=txtTahBitTarih2.ClientID%>,#<%=txtcTarih.ClientID%>").live("focus", function () {
                $(this).datepicker({
                    weekStart: 1,
                    showOn: 'button',
                    dateFormat: "dd.mm.yyyy",
                });
            });


            $('.chkProjectCls').live("click", function () {
                $("#<%=txtForm.ClientID%>").val("");
                var deger = $('.chkProjectCls').is(':checked').valueOf();
                if (deger) {
                    $("#<%=txtForm.ClientID%>").prop("disabled", true);
                    $(".divddlProje").live(function () {
                        $(this).css("display", "none");
                    });
                    $(".divtxtProje").live(function () {
                        $(this).css("display", "block");
                    });
                }
                else {
                    $("#<%=txtForm.ClientID%>").prop("disabled", false);
                    $(".divtxtProje").live(function () {
                        $(this).css("display", "none");
                    });
                    $(".divddlProje").live(function () {
                        $(this).css("display", "block");
                    });
                }
            });

            /// Bootstrapla Ajax Toolkit çakışmasından kaynaklanan sorun düzelsin diye..
            $("#<%=ddlistFirma.ClientID%>").val("-").change();


        }); /// Ready Function Sonu


        function PopupPanelleriGizle() {

            $find("MPE").hide();
            $find("MPE2").hide();
            $find("MPECus").hide();
            $find("MPEDurbun").hide();
            $find("MPECalisma").hide();
           
            $(".editPopupPanel").css("display", "none");
            $(".editPopupPanelCus").css("display", "none");
            $(".editPopupPanel2").css("display", "none");
            $(".editPopupCalisma").css("display", "none");
            $(".PopupDurbun").css("display", "none");
        }


        function GorevEklePopup() {
            $find("mpeGorevAdd").show();
            return false;
        }

        function panelBilgiKapan() {
            $("#panelbilgi").css("display", "none");
        }

        function panelBilgiAc() {
            $("#panelbilgi").css("display", "block");
        }

        function ShowPopup_YeniKayit() {

            PopupTemizle(1);

            var yetki = $("#<%=hfYetkiKodu.ClientID%>").val();
            ///1->Customer 3->Admin
            if (yetki == "3") {
                $("#<%=popupPanel.ClientID%>").css("display", "block");
                $("#<%=ddlistFirma.ClientID%>").val("-").change();
                $find("MPE").show();
                return false;
            }
            else if (yetki == "1") {
                $("#<%=popupPanelCus.ClientID%>").css("display", "block");
                $find("MPECus").show();
                return false;
            }
            else {
                $("#<%=popupPanel2.ClientID%>").css("display", "block");
                $("#<%=ddlistFirma2.ClientID%>").val("-").change();
                $("#<%=ddlistDurum2.ClientID %> option:contains('Onay Ver') ").attr("selected", "selected").change();
                $find("MPE2").show();
                return false;
            }
    }


    function ShowPopup_Durbun() {
        $("#<%=popupDurbunPanel.ClientID%>").css("display", "block");
            $find("MPEDurbun").show();
        }


        function ShowPopup_YeniCalisma(selRowInfo) {

            var yetki = $("#<%=hfYetkiKodu.ClientID%>").val();
            if (yetki == "1")
                return false;

            $("#<%=popupCalismaPanel.ClientID%>").css("display", "block");
            var row = selRowInfo.parentNode.parentNode;

            var ID = row.cells[1].innerText.trim();
            var firma = row.cells[3].innerText.trim();
            var proje = row.cells[4].innerText.trim();
            var form = row.cells[5].innerText.trim();
            var gorev = row.cells[6].innerText.trim();
            var aciklama = row.cells[7].innerText.trim();
            var tarih = row.cells[8].innerText.trim();
            var sorumlu = row.cells[9].innerText.trim();

            $("#<%=hfcGorevID.ClientID%>").val(ID);
            $("#<%=hfcFirma.ClientID%>").val(firma);
            $("#<%=hfcProje.ClientID%>").val(proje);
            $("#<%=txtcSorumlu.ClientID%>").val(sorumlu);
            $("#<%=txtcFirma.ClientID%>").val(firma);
            $("#<%=txtcProje.ClientID%>").val(proje);
            $("#<%=txtcForm.ClientID%>").val(form);
            $("#<%=txtcGorev.ClientID%>").val(gorev);
            $("#<%=txtcAciklama.ClientID%>").val(aciklama);
            $("#<%=txtcTahBitis.ClientID%>").val(tarih);

            $("#<%=txtcTarih.ClientID%>").val(GetDate());

            $("#<%=txtcSorumlu.ClientID%>").prop("readonly", true);

            ///JQuery çoklu seçerek textboxları boşaltıyorum..       
            $("#<%=txtcSure.ClientID%>,#<%=txtcCalisma.ClientID%>").val("");
            $get("<%=labMesaj2.ClientID%>").innerHTML = "";

            $find("MPECalisma").show();
            return false;
        }


        function GetDate() {
            var g = new Date().getDate();
            var a = new Date().getMonth() + 1;
            var y = new Date().getFullYear();
            var gun, ay, yil;

            if (g.toString().trim().length == 1)
                gun = "0" + g.toString();
            else
                gun = g.toString();

            if (a.toString().trim().length == 1)
                ay = "0" + a.toString();
            else
                ay = a.toString();

            yil = y.toString();

            var date = gun + "." + ay + "." + yil;
            return date;
        }

        function ToplamKayit(adet) {
            var ifade = "Bulunan Kayıt Sayısı : " + adet;
            $("#<%=labToplamKayit.ClientID%>").text(ifade);
        }

        function PopupTemizle(param) {
            // Açılan popuptaki alanlar burda temizleniyor
            $("#<%=txtGorev.ClientID%>").val("");
            $("#<%=txtAciklama.ClientID%>").val("");
            $("#<%=txtTahBitTarih.ClientID%>").val("");
            $("#<%=labKayitTarihi.ClientID%>").text("");
            $("#<%=txtDurumAciklama.ClientID%>").val("");

            $("#<%=txtGorevCus.ClientID%>").val("");
            $("#<%=txtAciklamaCus.ClientID%>").val("");
            $("#<%=txtTahBitTarihCus.ClientID%>").val("");
            $("#<%=txtDurumAciklamaCus.ClientID%>").val("");

            $("#<%=txtGorev2.ClientID%>").val("");
            $("#<%=txtAciklama2.ClientID%>").val("");
            $("#<%=txtTahBitTarih2.ClientID%>").val("");
            $("#<%=labKayitTarihi2.ClientID%>").text("");
            $("#<%=txtDurumAciklama2.ClientID%>").val("");

            if (param == 1) {
                $("#<%=ddlistForm.ClientID%>").val("-").change();
                $("#<%=ddlistProje.ClientID%>").val("-").change();
                $("#<%=ddlistFormCus.ClientID%>").val("-").change();
                $("#<%=ddlistProjeCus.ClientID%>").val("-").change();
                $("#<%=ddlistForm2.ClientID%>").val("-").change();
                $("#<%=ddlistProje2.ClientID%>").val("-").change();

                $("#<%=ddlistSorumlu.ClientID%>").val("-").change();
                $("#<%=ddlistSorumlu2.ClientID%>").val("-").change();
                $("#<%=ddlistSorumlu3.ClientID%>").val("-").change();
                $("#<%=ddlistOncelik.ClientID%>").val("1").change();
                $("#<%=ddlistOncelik2.ClientID%>").val("1").change();
            }

            // UploadFile sonuc mesajı // Asp Labelda html metoduyla temizleniyor diğerlerinden farklı val işe yaramıyor.
            $("#<%=labMesaj.ClientID%>").html("");
            $("#<%=labMesajCus.ClientID%>").html("");
            $("#<%=labMesaj3.ClientID%>").html("");

            ///Gridin satırlarını siliyor. Grid.Rows.Clear() gibi
            $("#tableKlavuz tr:not(:first)").remove();
            $("#tableEkDosya tr:not(:first)").remove();
            $("#tableKlavuzCus tr:not(:first)").remove();
            $("#tableEkDosyaCus tr:not(:first)").remove();
            $("#tableKlavuz2 tr:not(:first)").remove();
            $("#tableEkDosya2 tr:not(:first)").remove();
            ///hkeyID 0 ise ben bunu yeni kayıt olarak kabul ederim.
            $("#<%=hfkeyID.ClientID%>").val("0");

        }

        function DurumTemizle() {
            $("#<%=txtDurumAciklama.ClientID%>").val("");
        }

        var proje = "-", form = "-";
        function ShowPopup_Duzenleme(selRowInfo) {
            //Popup Paneli görünür yapıyorum  aslında bu olmadan da açılıyor ama ben işimi garantiye alıyorum
            $("#<%=popupPanel.ClientID%>").css("display", "block");
            $("#<%=popupPanelCus.ClientID%>").css("display", "block");
            $("#<%=popupPanel2.ClientID%>").css("display", "block");

            PopupTemizle(1);

            var row = selRowInfo.parentNode.parentNode;
            //var rowIndex = row.rowIndex - 1;    
            var ID = row.cells[1].innerText.trim();
            var firma = row.cells[3].innerText.trim();
            proje = row.cells[4].innerText.trim();
            form = row.cells[5].innerText.trim();
            var gorev = row.cells[6].innerText.trim();
            var aciklama = row.cells[7].innerText.trim();
            var tarih = row.cells[8].innerText.trim();
            var sorumlu = row.cells[9].innerText.trim();
            var oncelik = row.cells[10].innerText.trim();
            var durum = row.cells[11].innerText.trim();
            var kayitTarih = row.cells[12].innerText.trim();

            var Sorumlular = sorumlu.split(",");
            var yetki = $("#<%=hfYetkiKodu.ClientID%>").val();

            if (yetki == "3") ///3->Admin
            {
                $("#<%=hProje.ClientID%>").val(proje);
                $("#<%=hForm.ClientID%>").val(form);

                $("#<%=hfkeyID.ClientID%>").val(ID);
                $("#<%=ddlistFirma.ClientID%> option[value='" + firma + "' ] ").attr("selected", "selected").change();
                $("#<%=ddlistProje.ClientID%> option[value='" + proje + "' ] ").attr("selected", "selected").change();
                $("#<%=ddlistForm.ClientID%> option[value='" + form + "' ] ").attr("selected", "selected").change();

                // Proje ve form aşağıdaki metodlarda da set ediliyor..
                $("#<%=txtGorev.ClientID%>").val(gorev);
                $("#<%=txtAciklama.ClientID%>").val(aciklama);
                $("#<%=txtTahBitTarih.ClientID%>").val(tarih);
                $("#<%=labKayitTarihi.ClientID%>").text("K:" + kayitTarih);
                $("#<%=ddlistSorumlu.ClientID %> option[value='" + Sorumlular[0] + "' ] ").attr("selected", "selected").change();
                $("#<%=ddlistSorumlu2.ClientID %> option[value='" + Sorumlular[1] + "' ] ").attr("selected", "selected").change();
                $("#<%=ddlistSorumlu3.ClientID %> option[value='" + Sorumlular[2] + "' ] ").attr("selected", "selected").change();
                $("#<%=ddlistOncelik.ClientID %> option:contains('" + oncelik + "') ").attr("selected", "selected").change();
                $("#<%=ddlistDurum.ClientID %> option:contains('" + durum + "') ").attr("selected", "selected").change();
                $("#<%=txtDurumAciklama.ClientID%>").val("");

                // UploadFile sonuc mesajı  // Asp Labelda html metoduyla temizleniyor diğerlerinden farklı val işe yaramıyor.
                $("#<%=labMesaj.ClientID%>").html("");
                $("#<%=AsyncFileUpload1.ClientID%>").val(" ");
                ///Gridin satırlarını siliyor. Grid.Rows.Clear() gibi
                $("#tableKlavuz tr:not(:first)").remove();
                $("#tableEkDosya tr:not(:first)").remove();

                $.ajax({
                    type: "POST",
                    url: "Gorev.aspx/DokumanGetir",
                    data: "{ Firma: '" + firma + "', Proje:'" + proje + "'}",
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (response) {
                        if (response.d.length > 0) {
                            for (var i = 0; i < response.d.length; i++) {
                                $("#tableKlavuz").append(
                                    "<tr><td>" + response.d[i].ID + "</td><td><a target='_blank' href='UploadFiles/ProjeFiles/P" +
                                    response.d[i].GorevID + "/" + response.d[i].DosyaAdi + "' >" +
                                    response.d[i].DosyaAdi + "</a></td><td>" + response.d[i].Kaydeden + "</td><td>" + response.d[i].KayitTarihStr + "</td></tr>");
                            }
                        }
                    },
                    failure: function (response) {
                        alert(response.d);
                    }
                });


                ///Bu ajax metoduyla EkDosyaGetir WebMethodundan veri alıyorum ve gridEkDosya'yı dolduruyorum..
                $.ajax({
                    type: "POST",
                    url: "Gorev.aspx/EkDosyaGetir",
                    data: "{ID: '" + ID + "'}",
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (response) {
                        if (response.d.length > 0) {
                            for (var i = 0; i < response.d.length; i++) {
                                $("#tableEkDosya").append(
                                    "<tr><td>" + response.d[i].GorevID + "</td><td>" + response.d[i].ID + "</td><td><a target='_blank' href='UploadFiles/GorevFiles/" +
                                    response.d[i].GorevID + "/" + response.d[i].DosyaAdi + "' >" +
                                    response.d[i].DosyaAdi + "</a></td><td>" + response.d[i].Kaydeden + "</td><td>" + response.d[i].KayitTarihStr + "</td><td>" +
                                    "<input type='image' src='Images/delete.png' id='gEkDosya" + response.d[i].ID + "' onclick='ShowMesajPopup(this,0); return false;'" +
                                    "style='height:20px;' value='" + response.d[i].ID + "," + response.d[i].GorevID + "," + response.d[i].DosyaAdi + "' /> </td></tr>");
                            }
                        }
                    },
                    failure: function (response) {
                        alert(response.d);
                    }
                });

                $find("MPE").show();

            }
            else if(yetki == "1") ///1->Customer
            {
                $("#<%=hProjeCus.ClientID%>").val(proje);
                $("#<%=hFormCus.ClientID%>").val(form);

                $("#<%=hfkeyID.ClientID%>").val(ID);
                $("#<%=txtFirmaCus.ClientID%>").val(firma);
                $("#<%=ddlistProjeCus.ClientID%> option[value='" + proje + "' ] ").attr("selected", "selected").change();
                $("#<%=ddlistFormCus.ClientID%> option[value='" + form + "' ] ").attr("selected", "selected").change();

                // Proje ve form aşağıdaki metodlarda da set ediliyor..
                $("#<%=txtGorevCus.ClientID%>").val(gorev);
                $("#<%=txtAciklamaCus.ClientID%>").val(aciklama);
                $("#<%=txtTahBitTarihCus.ClientID%>").val(tarih);

                $("#<%=ddlistOncelikCus.ClientID %> option:contains('" + oncelik + "') ").attr("selected", "selected").change();
                $("#<%=txtDurumAciklamaCus.ClientID%>").val("");

                // UploadFile sonuc mesajı  // Asp Labelda html metoduyla temizleniyor diğerlerinden farklı val işe yaramıyor.
                $("#<%=labMesajCus.ClientID%>").html("");
                $("#<%=AsyncFileUploadCus.ClientID%>").val(" ");
                ///Gridin satırlarını siliyor. Grid.Rows.Clear() gibi
                $("#tableKlavuzCus tr:not(:first)").remove();
                $("#tableEkDosyaCus tr:not(:first)").remove();


                $.ajax({
                    type: "POST",
                    url: "Gorev.aspx/DokumanGetir",
                    data: "{ Firma: '" + firma + "', Proje:'" + proje + "'}",
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (response) {
                        if (response.d.length > 0) {
                            for (var i = 0; i < response.d.length; i++) {
                                $("#tableKlavuzCus").append(
                                    "<tr><td>" + response.d[i].ID + "</td><td><a target='_blank' href='UploadFiles/ProjeFiles/P" +
                                    response.d[i].GorevID + "/" + response.d[i].DosyaAdi + "' >" +
                                    response.d[i].DosyaAdi + "</a></td><td>" + response.d[i].Kaydeden + "</td><td>" + response.d[i].KayitTarihStr + "</td></tr>");
                            }
                        }
                    },
                    failure: function (response) {
                        alert(response.d);
                    }
                });


                ///Bu ajax metoduyla EkDosyaGetir WebMethodundan veri alıyorum ve gridEkDosya'yı dolduruyorum..
                $.ajax({
                    type: "POST",
                    url: "Gorev.aspx/EkDosyaGetir",
                    data: "{ID: '" + ID + "'}",
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (response) {
                        if (response.d.length > 0) {
                            for (var i = 0; i < response.d.length; i++) {
                                $("#tableEkDosyaCus").append(
                                    "<tr><td>" + response.d[i].GorevID + "</td><td>" + response.d[i].ID + "</td><td><a target='_blank' href='UploadFiles/GorevFiles/" +
                                    response.d[i].GorevID + "/" + response.d[i].DosyaAdi + "' >" +
                                    response.d[i].DosyaAdi + "</a></td><td>" + response.d[i].Kaydeden + "</td><td>" + response.d[i].KayitTarihStr + "</td><td>" +
                                    "<input type='image' src='Images/delete.png' id='gEkCusDosya" + response.d[i].ID + "' onclick='ShowMesajPopup(this,1); return false;'" +
                                    "style='height:20px;' value='" + response.d[i].ID + "," + response.d[i].GorevID + "," + response.d[i].DosyaAdi + "' /> </td></tr>");
                            }
                        }
                    },
                    failure: function (response) {
                        alert(response.d);
                    }
                });


                $find("MPECus").show();

            }
            else {
                $("#<%=hProje2.ClientID%>").val(proje);
                $("#<%=hForm2.ClientID%>").val(form);

                $("#<%=hfkeyID.ClientID%>").val(ID);
                $("#<%=ddlistFirma2.ClientID%> option[value='" + firma + "' ] ").attr("selected", "selected").change();
                $("#<%=ddlistProje2.ClientID%> option[value='" + proje + "' ] ").attr("selected", "selected").change();
                $("#<%=ddlistForm2.ClientID%> option[value='" + form + "' ] ").attr("selected", "selected").change();

                // Proje ve form aşağıdaki metodlarda da set ediliyor..
                $("#<%=txtGorev2.ClientID%>").val(gorev);
                $("#<%=txtAciklama2.ClientID%>").val(aciklama);
                $("#<%=txtTahBitTarih2.ClientID%>").val(tarih);
                $("#<%=labKayitTarihi2.ClientID%>").text("K:" + kayitTarih);

                $("#<%=ddlistOncelik2.ClientID %> option:contains('" + oncelik + "') ").attr("selected", "selected").change();
                $("#<%=ddlistDurum2.ClientID %> option:contains('" + durum + "') ").attr("selected", "selected").change();
                $("#<%=txtDurumAciklama2.ClientID%>").val("");

                // UploadFile sonuc mesajı  // Asp Labelda html metoduyla temizleniyor diğerlerinden farklı val işe yaramıyor.
                $("#<%=labMesaj3.ClientID%>").html("");
                $("#<%=AsyncFileUpload2.ClientID%>").val(" ");
                ///Gridin satırlarını siliyor. Grid.Rows.Clear() gibi
                $("#tableKlavuz2 tr:not(:first)").remove();
                $("#tableEkDosya2 tr:not(:first)").remove();


                $.ajax({
                    type: "POST",
                    url: "Gorev.aspx/DokumanGetir",
                    data: "{ Firma: '" + firma + "', Proje:'" + proje + "'}",
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (response) {
                        if (response.d.length > 0) {
                            for (var i = 0; i < response.d.length; i++) {
                                $("#tableKlavuz2").append(
                                    "<tr><td>" + response.d[i].ID + "</td><td><a target='_blank' href='UploadFiles/ProjeFiles/P" +
                                    response.d[i].GorevID + "/" + response.d[i].DosyaAdi + "' >" +
                                    response.d[i].DosyaAdi + "</a></td><td>" + response.d[i].Kaydeden + "</td><td>" + response.d[i].KayitTarihStr + "</td></tr>");
                            }
                        }
                    },
                    failure: function (response) {
                        alert(response.d);
                    }
                });


                ///Bu ajax metoduyla EkDosyaGetir WebMethodundan veri alıyorum ve gridEkDosya'yı dolduruyorum..
                $.ajax({
                    type: "POST",
                    url: "Gorev.aspx/EkDosyaGetir",
                    data: "{ID: '" + ID + "'}",
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (response) {
                        if (response.d.length > 0) {
                            for (var i = 0; i < response.d.length; i++) {
                                $("#tableEkDosya2").append(
                                    "<tr><td>" + response.d[i].GorevID + "</td><td>" + response.d[i].ID + "</td><td><a target='_blank' href='UploadFiles/GorevFiles/" +
                                    response.d[i].GorevID + "/" + response.d[i].DosyaAdi + "' >" +
                                    response.d[i].DosyaAdi + "</a></td><td>" + response.d[i].Kaydeden + "</td><td>" + response.d[i].KayitTarihStr + "</td><td>" +
                                    "<input type='image' src='Images/delete.png' id='gEk2Dosya" + response.d[i].ID + "' onclick='ShowMesajPopup(this,1); return false;'" +
                                    "style='height:20px;' value='" + response.d[i].ID + "," + response.d[i].GorevID + "," + response.d[i].DosyaAdi + "' /> </td></tr>");
                            }
                        }
                    },
                    failure: function (response) {
                        alert(response.d);
                    }
                });

                $find("MPE2").show();

            }
        }

        function SetSelectedProject() {
            $("#<%=ddlistProje.ClientID %> option[value='" + proje + "' ] ").attr("selected", "selected").change();
        }
        function SetSelectedForm() {
            $("#<%=ddlistForm.ClientID %> option[value='" + form + "' ] ").attr("selected", "selected").change();
        }
        function SetSelectedDurum(durum) {
            $("#<%=ddlistDurum.ClientID %> option[value='" + durum + "' ] ").attr("selected", "selected").change();
        }

        function SetSelectedProjectCus() {
            $("#<%=ddlistProjeCus.ClientID %> option[value='" + proje + "' ] ").attr("selected", "selected").change();
        }
        function SetSelectedFormCus() {
            $("#<%=ddlistFormCus.ClientID %> option[value='" + form + "' ] ").attr("selected", "selected").change();
        }

        function SetSelectedProject2() {
            $("#<%=ddlistProje2.ClientID %> option[value='" + proje + "' ] ").attr("selected", "selected").change();
        }
        function SetSelectedForm2() {
            $("#<%=ddlistForm2.ClientID %> option[value='" + form + "' ] ").attr("selected", "selected").change();
        }
        function SetSelectedDurum2(durum) {
             $("#<%=ddlistDurum2.ClientID %> option[value='" + durum + "' ] ").attr("selected", "selected").change();
        }


        function ShowPopup_Hareketler(selRowInfo) {
            $("#tableHareket td").remove();
            var row = selRowInfo.parentNode.parentNode;
            var ID = row.cells[1].innerText.trim();

            $.ajax({
                type: "POST",
                url: "Gorev.aspx/HareketGetir",
                data: '{GorevID: "' + ID + '" }',
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (response) {
                    for (var i = 0; i < response.d.length; i++) {
                        $("#tableHareket").append(
                        "<tr><td>" + response.d[i].ListeID + "</td>" +
                            "<td><a href='#' onclick='ShowPopup_HareketDetay(" + response.d[i].ID + ")'>&nbsp;" + response.d[i].GorevID + "&nbsp;</a></td>" +
                            "<td>" + response.d[i].GorevKayitTarihStr + "</td>" +
                            "<td>" + response.d[i].Sorumlu + "</td>" +
                            "<td>" + response.d[i].DurumStr + "</td>" +
                            "<td>" + response.d[i].Kaydeden + "</td>" +
                            "<td>" + response.d[i].KayitTarihStr + "</td></tr>");
                    }
                },
                failure: function (response) {
                    alert(response.d);
                }
            });

            $find("MPEHareket").show();
        }

        function ShowPopup_HareketDetay(gHareketID) {
            $.ajax({
                type: "POST",
                url: "Gorev.aspx/HareketDetayGetir",
                data: '{GHareketID: "' + gHareketID + '" }',
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (response) {
                    $("#taGorev").val(response.d.Gorev);
                    $("#taAciklama").val(response.d.Aciklama);
                    $("#taDAciklama").val(response.d.DAciklama);
                },
                failure: function (response) {
                    alert(response.d);
                }
            });

            $find("MPEHareketDetay").show();
        }

        function Calismalari_Goster(selRowInfo) {
            $("#tableCalismalar td").remove();
            var row = selRowInfo.parentNode.parentNode;
            var ID = row.cells[1].innerText.trim();

            $.ajax({
                type: "POST",
                url: "Gorev.aspx/CalismalariGetir",
                data: '{GorevID: "' + ID + '" }',
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (response) {
                    for (var i = 0; i < response.d.length-1; i++) {
                        $("#tableCalismalar").append(
                        "<tr><td style='text-align:center'>" + response.d[i].ListeID + "</td>" +
                            "<td><a href='#' onclick='Calisma_Detay(" + response.d[i].ID + ")'>&nbsp;" + response.d[i].ID + "&nbsp;</a></td>" +
                            "<td>" + response.d[i].Kaydeden + "</td>" +
                            "<td>" + response.d[i].Sorumlular + "</td>" +
                            "<td>" + response.d[i].Firma + "</td>" +
                            "<td>" + response.d[i].Proje + "</td>" +
                            "<td>" + response.d[i].Form + "</td>" +
                            "<td>" + response.d[i].CalismaSure + "</td>" +
                            "<td>" + response.d[i].CalismaTarihStr + "</td></tr>");
                    }
                    $("#tableCalismalar").append(
                       "<tr><td colspan='7' style='text-align:right; padding-right:10px'>Toplam Süre :</td>" +
                           "<td colspan='2'>" + response.d[response.d.length - 1].Aciklama + "</td></tr>");
                },
                failure: function (response) {
                    alert(response.d);
                }
            });

            $find("MPECalismalar").show();
        }

        function Calisma_Detay(calismaID) {
            $.ajax({
                type: "POST",
                url: "Gorev.aspx/CalismaDetayGetir",
                data: '{CalismaID: "' + calismaID + '" }',
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (response) {
                    $("#cdGorev").val(response.d.Gorev);
                    $("#cdAciklama").val(response.d.Aciklama);
                    $("#cdCalisma").val(response.d.Calisma);
                },
                failure: function (response) {
                    alert(response.d);
                }
            });

            $find("MPECalismaDetay").show();
        }



        function SelectedFirma() {
            var firma = $("#<%=ddlistFirma.ClientID%>").val();
            $('.chkProjectCls').prop("checked", true).change();
            $find("MPEProjeForm").show();
        }

        function SelectedFirmaProje() {
            var firma = $("#<%=ddlistFirma.ClientID%>").val();
            var proje = $("#<%=ddlistProje.ClientID%>").val();

            $('.chkProjectCls').prop("checked", false1);
            $('.chkProjectCls').trigger("click");

            $find("MPEProjeForm").show();
        }

        function SelectedProje() {
            var proje = $("#<%=ddlistProje.ClientID%>").val();
        }

        //// Popup MesajBoxın Evetemi Hayıra mı tıklandığını almak için
        var _source;
        var _popup;
        function ShowMesajPopup(source, tip) {
            this._source = source;
            if (tip == 0)
                this._popup = $find('mpeMesaj');
            else if (tip == 1)
                this._popup = $find('mpeMesaj2');
            else
                return false;

            this._popup.show();
        }
        function OkClick() {
            this._popup.hide();
            __doPostBack(this._source.name, '');

            PopupPanelleriGizle();

            if (_source.type == "image") {  //type image olanı ben ek dosyalar silmede kullanıyorum. 
                $.ajax({
                    type: "POST",
                    url: "Gorev.aspx/EkDosyaSil",
                    data: '{Param: "' + _source.value + '" }',
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    complete: function (response) {
                        alert('İşlem başarılı..');
                    },
                    failure: function (response) {
                        alert('İşlem başarısız !');
                    }
                });
            }
        }
        function CancelClick() {
            this._popup.hide();
            this._source = null;
            this._popup = null;
        }
        ///-----------------------------------------------------------

        /// AsynFileUploadla ilgili kodlar  --------------------------
        function uploadStarted(sender, args) {
            ///50 MB sınırı kontrol ediliyor..
            if (sender._inputFile.files[0].size >= 52428800) {
                //sender._stopLoad();
                var err = new Error();
                err.name = 'Dosya boyutu hatası';
                err.message = 'Dosya boyutu 50 MB üzerinde!';
                throw (err);
                return false;
            }
        }

        function uploadComplete(sender) {
            $get("<%=labMesaj.ClientID%>").innerHTML = "<span style='color:green'><b>Upload işlemi başarıyla gerçekleşti.</b></span>";
            $("#tableEkDosya").append("<tr><td></td><td></td><td>" + sender._inputFile.files[0].name + "</td>" +
                "<td><a target='_blank' href='UploadFiles'>Kaydedilmedi..</a></td><td></td><td></td></tr>");
        }
        function uploadComplete2(sender) {
            $get("<%=labMesaj3.ClientID%>").innerHTML = "<span style='color:green'><b>Upload işlemi başarıyla gerçekleşti.</b></span>";
            $("#tableEkDosya2").append("<tr><td></td><td></td><td>" + sender._inputFile.files[0].name + "</td>" +
                "<td><a target='_blank' href='UploadFiles'>Kaydedilmedi..</a></td><td></td><td></td></tr>");
        }
        function uploadCompleteCus(sender) {
            $get("<%=labMesajCus.ClientID%>").innerHTML = "<span style='color:green'><b>Upload işlemi başarıyla gerçekleşti.</b></span>";
            $("#tableEkDosyaCus").append("<tr><td></td><td></td><td>" + sender._inputFile.files[0].name + "</td>" +
                "<td><a target='_blank' href='UploadFiles'>Kaydedilmedi..</a></td><td></td><td></td></tr>");
        }

        function uploadError(sender, args) {
            $get("<%=labMesaj.ClientID%>").innerHTML = "<span style='color:red'><b> Hata Oluştu : </b>" + args.get_errorMessage() + "</span>";
        }
        function uploadError2(sender, args) {
            $get("<%=labMesaj3.ClientID%>").innerHTML = "<span style='color:red'><b> Hata Oluştu : </b>" + args.get_errorMessage() + "</span>";
        }
        function uploadErrorCus(sender, args) {
            $get("<%=labMesajCus.ClientID%>").innerHTML = "<span style='color:red'><b> Hata Oluştu : </b>" + args.get_errorMessage() + "</span>";
        }
        ///-----------------------------------------------------------
        /// AsynFileUploadla proje yedeklemeyle ilgili ---------------
        function uploadCompleteProjeBackup(sender) {
            $get("<%=labMesaj2.ClientID%>").innerHTML = "<span style='color:green'><b>Upload işlemi başarıyla gerçekleşti.</b></span>";
        }

        function uploadErrorProjeBackup(sender, args) {
            $get("<%=labMesaj2.ClientID%>").innerHTML = "<span style='color:red'><b> Hata Oluştu : </b>" + args.get_errorMessage() + "</span>";
        }
        ///-----------------------------------------------------------

        function btnKlavuzClientClick() {
            $("#divEditPopup").hide();
            $("#<%=panelEkDosyalar.ClientID%>").hide();
            $("#<%=panelKlavuz.ClientID%>").show();
            $("#<%=panelKlavuzDosya.ClientID%>").show();

        }

        function btnGeriDonClientClick() {
            $("#<%=panelKlavuzDosya.ClientID%>").hide();
            $("#<%=panelEkDosyalar.ClientID%>").hide();
            $("#<%=panelKlavuz.ClientID%>").hide();
            $("#divEditPopup").show();
        }

        function btnKlavuzDosyaAc() {
            $("#<%=panelEkDosyalar.ClientID%>").hide();
            $("#<%=panelKlavuzDosya.ClientID%>").show();

            $("#btnKlavuzDosya").css({ "background-color": "#00a2d9", "color": "white" });
            $("#btnEkDosyalar").css({ "background-color": "silver", "color": "black" });
        }

        function btnEkDosyalarAc() {
            $("#<%=panelKlavuzDosya.ClientID%>").hide();
            $("#<%=panelEkDosyalar.ClientID%>").show();

            $("#btnKlavuzDosya").css({ "background-color": "silver", "color": "black" });
            $("#btnEkDosyalar").css({ "background-color": "#00a2d9", "color": "white" });
        }

        function btnKlavuzClientClick2() {
            $("#divEditPopup2").hide();
            $("#<%=panelEkDosyalar2.ClientID%>").hide();
            $("#<%=panelKlavuz2.ClientID%>").show();
            $("#<%=panelKlavuzDosya2.ClientID%>").show();
        }

        function btnGeriDonClientClick2() {
            $("#<%=panelKlavuzDosya2.ClientID%>").hide();
             $("#<%=panelEkDosyalar2.ClientID%>").hide();
             $("#<%=panelKlavuz2.ClientID%>").hide();
             $("#divEditPopup2").show();
         }

         function btnKlavuzDosyaAc2() {
             $("#<%=panelEkDosyalar2.ClientID%>").hide();
            $("#<%=panelKlavuzDosya2.ClientID%>").show();

            $("#btnKlavuzDosya2").css({ "background-color": "#00a2d9", "color": "white" });
            $("#btnEkDosyalar2").css({ "background-color": "silver", "color": "black" });
        }


        function btnEkDosyalarAc2() {
            $("#<%=panelKlavuzDosya2.ClientID%>").hide();
            $("#<%=panelEkDosyalar2.ClientID%>").show();

            $("#btnKlavuzDosya2").css({ "background-color": "silver", "color": "black" });
            $("#btnEkDosyalar2").css({ "background-color": "#00a2d9", "color": "white" });
        }


        function btnKlavuzClientClickCus() {
            $("#divEditPopupCus").hide();
            $("#<%=panelEkDosyalarCus.ClientID%>").hide();
            $("#<%=panelKlavuzCus.ClientID%>").show();
            $("#<%=panelKlavuzDosyaCus.ClientID%>").show();

        }

        function btnGeriDonClientClickCus() {
            $("#<%=panelKlavuzDosyaCus.ClientID%>").hide();
             $("#<%=panelEkDosyalarCus.ClientID%>").hide();
             $("#<%=panelKlavuzCus.ClientID%>").hide();
             $("#divEditPopupCus").show();
         }

         function btnKlavuzDosyaAcCus() {
             $("#<%=panelEkDosyalarCus.ClientID%>").hide();
            $("#<%=panelKlavuzDosyaCus.ClientID%>").show();

            $("#btnKlavuzDosyaCus").css({ "background-color": "#00a2d9", "color": "white" });
            $("#btnEkDosyalarCus").css({ "background-color": "silver", "color": "black" });
        }

        function btnEkDosyalarAcCus() {
            $("#<%=panelKlavuzDosyaCus.ClientID%>").hide();
            $("#<%=panelEkDosyalarCus.ClientID%>").show();

            $("#btnKlavuzDosyaCus").css({ "background-color": "silver", "color": "black" });
            $("#btnEkDosyalarCus").css({ "background-color": "#00a2d9", "color": "white" });
        }


        function ProjeEklemeyiAc() {
            $(".divtxtForm").hide();
        }

        function FormEklemeyiAc() {
            $(".divtxtForm").show();
        }


    </script>


</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <asp:Panel ID="AnaPanel" runat="server">

        <ajaxToolkit:ToolkitScriptManager runat="Server" EnablePartialRendering="true" EnableViewState="true" EnablePageMethods="true" ID="ScriptManager1" />

        <!-- GÖREV GRIDVIEW  ------------------------- BEGIN -->
        <div id="dvGrid" style="width: 950px">
            <asp:UpdatePanel ID="upPanelGorev" runat="server">
                <ContentTemplate>
                    <asp:GridView ID="gridGorev" runat="server" Width="1025px" CssClass="Grid" AutoGenerateColumns="False"
                        AllowSorting="true" AllowPaging="False" OnPageIndexChanging="GridPaging" OnSorting="gridGorev_Sorting"
                        OnDataBinding="gridGorev_DataBinding" GridLines="None"
                        ShowHeaderWhenEmpty="True" ShowFooter="true" EditRowStyle-VerticalAlign="Middle"
                        AlternatingRowStyle-CssClass="alt" PagerStyle-CssClass="pgr"
                        HeaderStyle-HorizontalAlign="Center"
                        OnRowDataBound="gridGorev_RowDataBound" DataKeyNames="ID"
                        BorderColor="#E7E7FF" BorderStyle="None">
                        <Columns>
                            <asp:TemplateField HeaderText="Düzenle" SortExpression="ID">
                                <ItemTemplate>
                                    <asp:ImageButton ID="btnDuzenle" ToolTip="Kaydı düzenle" Height="26px" Width="28px" ImageUrl="~/Images/gridTool/edit.png" runat="server" CommandArgument='<%# Container.DataItemIndex%>'
                                        Text="Düzenle" OnClick="Duzenle" OnClientClick="ShowPopup_Duzenleme(this)" CommandName="Select"></asp:ImageButton>
                                    <asp:ImageButton CssClass="AcKapa" ID="btnSiraVer" ToolTip="Sırala" Height="18px" ImageAlign="Top" Width="18px" ImageUrl="~/Images/gridTool/chart.png" runat="server" 
                                        CommandArgument='<%# Container.DataItemIndex%>'  Text="Düzenle" OnClick="SiraVer" CommandName="Select"></asp:ImageButton>
                                </ItemTemplate>
                                <FooterTemplate>
                                    <asp:ImageButton ID="btnYeniKayit" ImageUrl="~/Images/gridTool/add.png" runat="server" CommandArgument='<%# Eval("ID")%>'
                                        Text="Yeni Kayıt" OnClick="YeniKayit" OnClientClick="ShowPopup_YeniKayit()"></asp:ImageButton>
                                </FooterTemplate>
                                <HeaderStyle Width="50px" Wrap="false" />
                                <ItemStyle HorizontalAlign="Center" Width="50px" Wrap="False" />
                                <FooterStyle Height="28px" HorizontalAlign="Center" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="ID (Hide)" FooterStyle-CssClass="hideKolon" ItemStyle-CssClass="hideKolon" HeaderStyle-CssClass="hideKolon" ControlStyle-CssClass="hideKolon">
                                <ItemTemplate>
                                    <asp:Label ID="labID" runat="server" Text='<%# Eval("ID") %>' />
                                </ItemTemplate>
                            </asp:TemplateField>


                            <asp:TemplateField ControlStyle-CssClass="AcKapa" FooterStyle-CssClass="AcKapa" HeaderStyle-CssClass="AcKapa" ItemStyle-CssClass="AcKapa" HeaderStyle-Width="40px" HeaderText="Sıra">
                                <ItemTemplate>

                                    <asp:Label ID="labIslemSira" Width="34px" Font-Size="13pt" Style="text-align: center" Font-Bold="true" runat="server" Text='<%# Eval("IslemSira") %>' />

                                </ItemTemplate>
                                <EditItemTemplate>
                                    <asp:TextBox ID="txtIslemSira" Width="30px" Font-Bold="true" Style="text-align: center" Font-Size="12pt" runat="server" MaxLength="3" Text='<%# Eval("IslemSira")%>'></asp:TextBox>
                                </EditItemTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField ControlStyle-Width="80px" HeaderText="Firma" SortExpression="Firma">
                                <ItemTemplate>
                                    <asp:Label ID="labFirma" Font-Bold="true" runat="server" Text='<%# Eval("Firma") %>' />

                                </ItemTemplate>
                            </asp:TemplateField>


                            <asp:TemplateField ControlStyle-Width="115px" HeaderText="Proje" SortExpression="Proje">
                                <ItemTemplate>
                                    <asp:Label ID="labProje" CssClass="KelimeAyrac" runat="server" Text='<%# Eval("Proje") %>' />
                                </ItemTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField ControlStyle-Width="175px" HeaderText="Form" SortExpression="Form">
                                <ItemTemplate>
                                    <asp:Label ID="labForm" runat="server" Text='<%# Eval("Form") %>' />
                                </ItemTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField ControlStyle-Width="270px" HeaderText="Görev" SortExpression="Gorev">
                                <ItemTemplate>
                                    <asp:Label ID="labGorev" runat="server" Text='<%# Eval("Gorev")%>'></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="Aciklama (Hide)" ControlStyle-CssClass="hideKolon" ItemStyle-CssClass="hideKolon" HeaderStyle-CssClass="hideKolon" FooterStyle-CssClass="hideKolon">
                                <ItemTemplate>
                                    <asp:Label ID="labAciklama" runat="server" Text='<%# Eval("Aciklama")%>'></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField ControlStyle-Width="70px" HeaderText="Tah.Bitiş" SortExpression="TahminiBitisTarih">
                                <ItemTemplate>
                                    <asp:Label ID="labTahBitisTarih" runat="server" Text='<%# Eval("TahminiBitisTarih","{0:dd.MM.yyyy}")%>'></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField ControlStyle-Width="70px" ItemStyle-HorizontalAlign="Center" HeaderText="Sorumlu" SortExpression="Sorumlu">
                                <ItemTemplate>
                                    <asp:Label ID="labSorumlu" runat="server" Font-Bold="true" Font-Size="14px" Text='<%# Eval("Sorumlu") %>' />
                                </ItemTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField ControlStyle-Width="55px" HeaderText="Öncelik" SortExpression="Oncelik">
                                <ItemTemplate>
                                    <asp:Label runat="server" ID="labOncelikAciklama" Font-Bold="true" Font-Size="13px" Text='<%# Eval("OncelikAcikla")%>'></asp:Label>
                                    <asp:Label ID="labOncelik" runat="server" Text='<%# Eval("Oncelik")%>' Visible="false" />
                                </ItemTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField ControlStyle-Width="75px" HeaderText="Durum" SortExpression="Durum">
                                <ItemTemplate>
                                    <asp:LinkButton ID="btnDurumAciklama"
                                        ForeColor='<%# (((short)Eval("Durum")) == 2 || ((short)Eval("Durum")) == 3 || ((short)Eval("Durum")) == 4 || ((short)Eval("Durum")) == 8)  ? System.Drawing.Color.White : System.Drawing.Color.Black %>'
                                        Font-Bold="true" Font-Size="13px" runat="server" OnClientClick="ShowPopup_Hareketler(this)" Text='<%# Eval("DurumAcikla")%>'></asp:LinkButton>
                                    <asp:Label ID="labDurum" runat="server" Text='<%# Eval("Durum")%>' Visible="false" />
                                </ItemTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="KayitTarih (Hide)" ControlStyle-CssClass="hideKolon" ItemStyle-CssClass="hideKolon" HeaderStyle-CssClass="hideKolon" FooterStyle-CssClass="hideKolon">
                                <ItemTemplate>
                                    <asp:Label ID="labKayitTarih" runat="server" Text='<%# Eval("KayitTarih","{0:dd.MM.yyyy}")%>'></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField  HeaderText="Çalışma">
                                <ItemTemplate>
                                    <asp:ImageButton CssClass="AcKapa" ID="btnCalismalariGoster" ToolTip="Çalışmaları Göster" Height="20px" ImageAlign="Top" Width="20px" ImageUrl="~/Images/gridTool/info.png" runat="server" 
                                          OnClientClick="Calismalari_Goster(this)"></asp:ImageButton>
                                    <asp:ImageButton ID="btnCalismaEkle" ToolTip="Çalışma ekle" ImageUrl="~/Images/gridTool/save.png" runat="server" Height="28px" CommandArgument='<%# Eval("ID")%>'
                                        Text="Düzenle" OnClick="CalismaEkleyiAc" OnClientClick="ShowPopup_YeniCalisma(this)"></asp:ImageButton>                    
                                </ItemTemplate>

                                <HeaderStyle Width="50px" Wrap="false" />
                                <ItemStyle HorizontalAlign="Center" Width="50px" Wrap="False" />

                            </asp:TemplateField>

                        </Columns>
                        <AlternatingRowStyle BackColor="#F7F7F7" />
                        <EditRowStyle VerticalAlign="Middle" />
                        <FooterStyle BackColor="#B5C7DE" ForeColor="#4A3C8C" />
                        <HeaderStyle BackColor="#4A3C8C" Font-Bold="True" ForeColor="#F7F7F7" />
                        <PagerStyle CssClass="pgr" />
                        <RowStyle Height="15px" VerticalAlign="Middle" Wrap="True" BackColor="#E7E7FF"
                            ForeColor="#4A3C8C" />
                        <SelectedRowStyle BackColor="#738A9C" Font-Bold="True" ForeColor="#F7F7F7" />
                        <SortedAscendingCellStyle BackColor="#F4F4FD" />
                        <SortedAscendingHeaderStyle BackColor="#5A4C9D" />
                        <SortedDescendingCellStyle BackColor="#D8D8F0" />
                        <SortedDescendingHeaderStyle BackColor="#3E3277" />
                    </asp:GridView>

                </ContentTemplate>
                <Triggers>
                    <asp:AsyncPostBackTrigger ControlID="gridGorev" />

                </Triggers>
            </asp:UpdatePanel>

        </div>
        <!-- GÖREV GRIDVIEW  ------------------------- END -->


        <!-- LITERAL MESAJ ------------------------  BEGIN  ---->
        <asp:UpdatePanel ID="upPanelMesaj" runat="server" Style="display: block">
            <ContentTemplate>
                <div class="row" id="panelbilgi" style="width: 900px; position: fixed; bottom: 0; padding: 0px; margin-left: 30px;">
                    <div>
                        <div class="panel panel-default" style="background-color: #A9A9A9; margin: 2px auto">
                            <asp:Panel ID="pnlHata" runat="server" Visible="false" CssClass="panelInfo">
                                <div class="alert alert-danger fade in" style="margin: 5px auto; width: 890px">
                                    <button type="button" id="btnHataClose" onclick="panelBilgiKapan()" class="close" data-dismiss="alert"
                                        aria-hidden="true">
                                        &times;</button>
                                    <asp:Literal ID="lblHata" runat="server"></asp:Literal>
                                </div>
                            </asp:Panel>
                            <asp:Panel ID="pnlBasarili" runat="server" Visible="false" CssClass="panelInfo">
                                <div class="alert alert-success fade in" style="margin: 5px auto; width: 890px">
                                    <button type="button" class="close" id="btnBasariClose" onclick="panelBilgiKapan()" data-dismiss="alert"
                                        aria-hidden="true">
                                        &times
                                    </button>
                                    <asp:Literal ID="lblBasarili" runat="server"></asp:Literal>
                                </div>
                            </asp:Panel>
                        </div>
                    </div>
                </div>
            </ContentTemplate>
            <Triggers>
                <asp:AsyncPostBackTrigger ControlID="gridGorev" EventName="RowDataBound" />
                <asp:AsyncPostBackTrigger ControlID="timerGenel" EventName="Tick" />
            </Triggers>
        </asp:UpdatePanel>
        <!-- LITERAL MESAJ ---------------------------  END  ---->


        <!-- POPUP EDİT FORM ADMIN  ----------------------------- BEGIN  -->
        <ajaxToolkit:ModalPopupExtender ID="mPopup" runat="server" BehaviorID="MPE" CancelControlID="btnIptal"
            TargetControlID="btnPopupAc" PopupControlID="popupPanel" BackgroundCssClass="modalBackground"
            DropShadow="True" />
        <asp:Button ID="btnPopupAc" runat="server" Style="display: none" Text="Popup Açmak İçin Şart" />
        <asp:Panel ID="popupPanel" runat="server" CssClass="editPopupPanel" Style="display: none">

            <div id="divEditPopup" style="display: block">
                <asp:Button runat="server" ID="btnKlavuz" OnClientClick="btnKlavuzClientClick()" Text="Döküman" CssClass="klavuz" />

                <div class="div_pe_baslik" style="margin-top: 10px">
                    <asp:Label ID="Label13" Style="margin-right: 140px; margin-left: 10px" runat="server" Text="Sorumlu-1"></asp:Label>
                    <asp:Label ID="Label15" Style="margin-right: 140px" runat="server" Text="Sorumlu-2"></asp:Label>
                    <asp:Label ID="Label16" Style="margin-right: 148px" runat="server" Text="Sorumlu-3"></asp:Label>
                </div>
                <div>
                    <asp:UpdatePanel ID="UpdatePanel2" runat="server">
                        <ContentTemplate>

                            <asp:DropDownList ID="ddlistSorumlu" Style="margin-left: 10px; border-radius: 4px" CssClass="form-control" data-live-search="false"
                                data-width="190px" Width="190px" AutoPostBack="true" OnSelectedIndexChanged="ddlistSorumlu_SelectedIndexChanged" runat="server" />

                            <asp:DropDownList ID="ddlistSorumlu2" Style="margin-left: 20px; border-radius: 4px;" CssClass="form-control" data-live-search="false"
                                data-width="190px" Width="190px" AutoPostBack="true" runat="server" />

                            <asp:DropDownList ID="ddlistSorumlu3" Style="margin-left: 20px; border-radius: 4px" CssClass="form-control" data-live-search="false"
                                data-width="190px" Width="190px" AutoPostBack="true" runat="server" />

                        </ContentTemplate>
                        <Triggers>
                            <asp:AsyncPostBackTrigger ControlID="ddlistSorumlu" EventName="SelectedIndexChanged" />
                        </Triggers>
                    </asp:UpdatePanel>
                </div>

                <div class="div_pe_baslik">
                    <asp:Label ID="Label17" Style="margin-right: 173px; margin-left: 10px" runat="server" Text="Firma"></asp:Label>
                    <asp:Label ID="Label18" Style="margin-right: 175px" runat="server" Text="Proje"></asp:Label>
                    <asp:Label ID="Label19" Style="margin-right: 175px" runat="server" Text="Form"></asp:Label>
                    <asp:Label ID="Label7" runat="server" Text="T.Bitiş Tarihi"></asp:Label>
                </div>
                <div>
                    <div>
                        <asp:UpdatePanel ID="UpdatePanel1" style="width: 654px; float: left" runat="server">
                            <ContentTemplate>
                                <asp:DropDownList ID="ddlistFirma" CssClass="form-control" Style="margin-left: 10px; border-radius: 4px" data-live-search="true"
                                    data-width="190px" Width="190px" runat="server" OnSelectedIndexChanged="ddlistFirma_SelectedIndexChanged" AutoPostBack="True" />

                                <asp:DropDownList ID="ddlistProje" CssClass="form-control" data-live-search="true" Style="margin-left: 20px; border-radius: 4px"
                                    data-width="190px" Width="190px" runat="server" AutoPostBack="true" OnSelectedIndexChanged="ddlistProje_SelectedIndexChanged" />


                                <asp:Button ID="btnProjeEklemeyiAc" runat="server" OnClick="btnProjeEklemeyiAc_Click" CssClass="btnProjeFormAcCss" />

                                <asp:DropDownList ID="ddlistForm" CssClass="form-control" data-live-search="true" Style="margin-left: -4px; border: 2px solid #140145; border-radius: 4px"
                                    data-width="190px" Width="190px" runat="server" />

                                <asp:Button ID="btnFormEklemeyiAc" runat="server" OnClick="btnFormEklemeyiAc_Click" CssClass="btnProjeFormAcCss" />


                            </ContentTemplate>
                            <Triggers>

                                <asp:AsyncPostBackTrigger ControlID="btnProjeEklemeyiAc" EventName="Click" />
                                <asp:AsyncPostBackTrigger ControlID="btnFormEklemeyiAc" EventName="Click" />
                                <asp:AsyncPostBackTrigger ControlID="ddlistFirma" EventName="SelectedIndexChanged" />

                            </Triggers>
                        </asp:UpdatePanel>


                        <asp:HiddenField ID="hProje" runat="server" Value="-" />
                        <asp:HiddenField ID="hForm" runat="server" Value="-" />

                        <asp:TextBox ID="txtTahBitTarih" Style="padding-left: 10px; border-radius: 4px" runat="server" BorderWidth="1" BorderColor="#666666" Height="31px" Width="100px" />

                        <asp:Label Style="margin-left: 4px; vertical-align: 2px; font-size: 12px; font-weight: bold" ID="labKayitTarihi" Text="K: " runat="server"></asp:Label>
                    </div>

                </div>
                <div class="div_pe_baslik">
                    <asp:Label ID="Label2" Style="margin-right: 600px; margin-left: 10px" runat="server" Text="Görev"></asp:Label>
                    <asp:Label ID="Label4" Style="margin-right: 68px;" runat="server" Text="Öncelik"></asp:Label>
                    <asp:Label ID="Label5" runat="server" Text="Durum"></asp:Label>
                </div>
                <div style="width: 938px">
                    <asp:TextBox runat="server" Style="margin-left: 10px; padding-left: 6px; border-radius: 4px" BorderWidth="1" BorderColor="#666666" ID="txtGorev" Width="618px" Height="32px"
                        MaxLength="40" />
                    <asp:UpdatePanel ID="UpdatePanel7" style="float: right" runat="server">
                        <ContentTemplate>
                            <asp:DropDownList ID="ddlistOncelik" Style="margin-left: 10px; border-radius: 4px" CssClass="form-control" data-live-search="false" data-width="110px" Width="110px" runat="server" />

                            <asp:DropDownList ID="ddlistDurum" Style="margin-left: 10px; border-radius: 4px" CssClass="form-control" data-live-search="false" data-width="160px" Width="160px" runat="server" />
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </div>
                <div class="div_pe_baslik">
                    <asp:Label ID="Label1" Style="margin-right: 173px; margin-left: 10px" runat="server" Text="Açıklama"></asp:Label>
                </div>
                <div>
                    <asp:TextBox runat="server" ID="txtAciklama" Width="930px" Style="margin-left: 10px; padding-left: 6px; border-radius: 4px" Height="120px"
                        TextMode="MultiLine" BorderWidth="1" BorderColor="#666666" MaxLength="2000" />
                </div>
                <div class="div_pe_baslik">
                    <asp:Label ToolTip="Yeni bir hareket olduğunda girilecek açıklamadır." Style="margin-right: 173px; margin-left: 10px; border-radius: 4px" runat="server" Text="Mesaj"></asp:Label>
                </div>
                <div>
                    <asp:TextBox runat="server" ID="txtDurumAciklama" Width="930px"
                        Style="margin-left: 10px; padding-left: 6px; -moz-border-radius: 4px; -webkit-border-radius: 4px; border-radius: 4px"
                        Height="96px"
                        BorderWidth="1" BorderColor="#666666" TextMode="MultiLine" MaxLength="2000" />
                </div>


            </div>

            <asp:Panel ID="panelKlavuz" Style="display: none" runat="server">
                <asp:Button runat="server" ID="btnGeriDon" OnClientClick="btnGeriDonClientClick()" Text="Görev" CssClass="klavuz"
                    Style="background-image: url('Images/back.png');" />

                <input type="button" id="btnKlavuzDosya" class="btnKlavuzEkDosya" value="Klavuz" onclick="btnKlavuzDosyaAc()"
                    style="position: absolute; left: 0px; top: 0px; width: 100px; background-color: #00a2d9; color: white" />
                <input type="button" id="btnEkDosyalar" class="btnKlavuzEkDosya" value="Ek Dosyalar" onclick="btnEkDosyalarAc()"
                    style="position: absolute; left: 100px; top: 0px; width: 100px; background-color: silver; color: black" />


                <asp:Panel ID="panelKlavuzDosya" CssClass="panelKlavuzDosyaCls" Height="380px" Width="850px" runat="server" ScrollBars="Auto">

                    <table id="tableKlavuz" class="tableKlavuzYedekleme">
                        <tr>
                            <th style="width: 60px">ID</th>
                            <th style="width: 510px">Dosya Adı</th>
                            <th style="width: 100px">Kaydeden</th>
                            <th style="width: 160px">Kayıt Tarih</th>
                        </tr>

                    </table>


                </asp:Panel>


                <asp:Panel ID="panelEkDosyalar" runat="server" CssClass="panelEkDosyalarCls" Height="380px" Width="850px" ScrollBars="Auto">

                    <table id="tableEkDosya" class="tableKlavuzYedekleme">
                        <tr>
                            <th style="width: 60px">GörevID</th>
                            <th style="width: 60px">DökID</th>
                            <th style="width: 400px">Dosya</th>
                            <th style="width: 100px">Kaydeden</th>
                            <th style="width: 160px">Kayıt Tarih</th>
                            <th style="width: 50px">Sil</th>
                        </tr>

                    </table>

                </asp:Panel>

            </asp:Panel>


            <div style="position: absolute; right: 8px; bottom: 3px; height: 40px">
                <asp:Button Text="Kaydet" runat="server" class="btn btn-blue" Style="width: 100px" ID="btnKaydet" OnClick="btnKaydet_Click" />
                <asp:Button Text="Sil" runat="server" class="btn btn-danger" Style="width: 100px; margin-left: 20px" ID="btnSil" OnClick="btnSil_Click"
                    OnClientClick="ShowMesajPopup(this,0); return false;" />

                <asp:Button Text="Kapat" runat="server" class="btn btn-dark" Style="width: 100px; margin-left: 20px" ID="btnIptal" OnClientClick="PopupPanelleriGizle()" />
            </div>



            <div style="height: 24px; position: absolute; bottom: 24px; left: 8px">
                <label class="custom-file-input file-blue">
                    <ajaxToolkit:AsyncFileUpload UploaderStyle="Traditional" ThrobberID="loadImage"
                        ID="AsyncFileUpload1" OnClientUploadError="uploadError"
                        OnClientUploadComplete="uploadComplete" OnClientUploadStarted="uploadStarted"
                        Font-Size="14px" Font-Bold="true" Height="26px"
                        runat="server" Width="300px"
                        OnUploadedComplete="AsyncFileUpload_UploadedComplete"
                        Style="margin-top: 10px; margin-left: 10px; float: left" />
                </label>
                <asp:Image ImageUrl="~/Images/loader.gif" Height="22px" Width="22px" Style="vertical-align: 8px; margin-left: 10px" ID="loadImage" runat="server" />
                <asp:Label ID="labMesaj" CssClass="labMesajCls" Style="margin-left: 5px; vertical-align: 14px" runat="server"></asp:Label>
            </div>

            <!-- POPUP MESAJ FORM KISMI  INCEPTION:) ----------------------- BEGIN -->
            <asp:Button ID="btnMesajShow" runat="server" Text="SMP" Style="display: none" />
            <ajaxToolkit:ModalPopupExtender ID="mesajPopup" runat="server" BehaviorID="mpeMesaj"
                PopupControlID="panelConfirmPopup" TargetControlID="btnMesajShow" OkControlID="btnYes" OnOkScript="OkClick();" CancelControlID="btnNo" OnCancelScript="CancelClick();"
                BackgroundCssClass="modalBackground2">
            </ajaxToolkit:ModalPopupExtender>
            <asp:Panel ID="panelConfirmPopup" runat="server" CssClass="modalMesajPopup" Style="display: none">
                <div class="header">
                    Onay Mesajı
                </div>
                <div class="body">
                    Bu kaydı silmek istediğinize emin misiniz ?
                </div>
                <div class="footer" align="right">
                    <asp:Button ID="btnYes" runat="server" Text="Evet" CssClass="yes" />
                    <asp:Button ID="btnNo" runat="server" Text="Hayır" CssClass="no" />
                </div>
            </asp:Panel>
            <!-- POPUP MESAJ FORM KISMI   ----------------------- END -->

        </asp:Panel>
        <!-- POPUP EDİT FORM ADMIN  ------------------------------ END -->

        <asp:HiddenField ID="hfkeyID" runat="server" />

 
        <!-- POPUP EDİT FORM CUSTOMER  ----------------------------- BEGIN  -->
        <ajaxToolkit:ModalPopupExtender ID="mPopupCus" runat="server" BehaviorID="MPECus" CancelControlID="btnIptalCus"
            TargetControlID="btnPopupAcCus" PopupControlID="popupPanelCus" BackgroundCssClass="modalBackground"
            DropShadow="True" />
        <asp:Button ID="btnPopupAcCus" runat="server" Style="display: none" Text="Popup Açmak İçin Şart" />
        <asp:Panel ID="popupPanelCus" runat="server" CssClass="editPopupPanelCus" Style="display: none">

            <div id="divEditPopupCus" style="display: block">
                <asp:Button runat="server" ID="btnKlavuzCus" OnClientClick="btnKlavuzClientClickCus()" Text="Döküman" CssClass="klavuz" />


                <div class="div_pe_baslik">
                    <asp:Label ID="Label3" Style="margin-right: 173px; margin-left: 10px" runat="server" Text="Firma"></asp:Label>
                    <asp:Label ID="Label6" Style="margin-right: 175px" runat="server" Text="Proje"></asp:Label>
                    <asp:Label ID="Label10" Style="margin-right: 175px" runat="server" Text="Form"></asp:Label>
                    <asp:Label ID="Label21" runat="server" Text="T.Bitiş Tarihi"></asp:Label>
                </div>
                <div>
                    <div>
                        <asp:UpdatePanel ID="UpdatePanel3" style="width: 654px; float: left" runat="server">
                            <ContentTemplate>

                                <asp:TextBox ID="txtFirmaCus" Enabled="false" Style="margin-left: 10px; border-radius: 4px; padding-left: 6px; height: 28px"
                                    data-width="190px" Width="190px" runat="server"></asp:TextBox>

                                <asp:DropDownList ID="ddlistProjeCus" CssClass="form-control" data-live-search="true" Style="margin-left: 20px; border-radius: 4px"
                                    data-width="190px" Width="190px" runat="server" AutoPostBack="true" OnSelectedIndexChanged="ddlistProjeCus_SelectedIndexChanged" />

                                <asp:DropDownList ID="ddlistFormCus" CssClass="form-control" data-live-search="true" Style="margin-left: 16px; border: 2px solid #140145; border-radius: 4px"
                                    data-width="190px" Width="190px" runat="server" />


                            </ContentTemplate>
                            <Triggers>
                            </Triggers>
                        </asp:UpdatePanel>


                        <asp:HiddenField ID="hProjeCus" runat="server" Value="-" />
                        <asp:HiddenField ID="hFormCus" runat="server" Value="-" />

                        <asp:TextBox ID="txtTahBitTarihCus" Style="padding-left: 10px; border-radius: 4px" runat="server" BorderWidth="1" BorderColor="#666666" Height="31px" Width="100px" />

                        <asp:Label Style="margin-left: 2px; vertical-align: 2px; font-size: 12px; font-weight: bold" ID="Label27" runat="server"></asp:Label>
                    </div>

                </div>
                <div class="div_pe_baslik">
                    <asp:Label ID="Label28" Style="margin-right: 600px; margin-left: 10px" runat="server" Text="Görev"></asp:Label>
                    <asp:Label ID="Label29" Style="margin-right: 68px;" runat="server" Text="Öncelik"></asp:Label>

                </div>
                <div style="width: 765px">
                    <asp:TextBox runat="server" Style="margin-left: 10px; padding-left: 6px; border-radius: 4px" BorderWidth="1" BorderColor="#666666" ID="txtGorevCus" Width="618px" Height="32px"
                        MaxLength="40" />
                    <asp:UpdatePanel ID="UpdatePanel6" style="float: right" runat="server">
                        <ContentTemplate>
                            <asp:DropDownList ID="ddlistOncelikCus" Style="margin-left: 10px; border-radius: 4px" CssClass="form-control" data-live-search="false" data-width="110px" Width="110px" runat="server" />

                        </ContentTemplate>
                    </asp:UpdatePanel>
                </div>
                <div class="div_pe_baslik">
                    <asp:Label ID="Label31" Style="margin-right: 173px; margin-left: 10px" runat="server" Text="Açıklama"></asp:Label>
                </div>
                <div>
                    <asp:TextBox runat="server" ID="txtAciklamaCus" Width="930px" Style="margin-left: 10px; padding-left: 6px; border-radius: 4px" Height="120px"
                        TextMode="MultiLine" BorderWidth="1" BorderColor="#666666" MaxLength="2000" />
                </div>
                <div class="div_pe_baslik">
                    <asp:Label ID="Label32" ToolTip="Yeni bir hareket olduğunda girilecek açıklamadır." Style="margin-right: 173px; margin-left: 10px; border-radius: 4px" runat="server" Text="Mesaj"></asp:Label>
                </div>
                <div>
                    <asp:TextBox runat="server" ID="txtDurumAciklamaCus" Width="930px"
                        Style="margin-left: 10px; padding-left: 6px; border-radius: 4px" Height="96px"
                        BorderWidth="1" BorderColor="#666666" TextMode="MultiLine" MaxLength="2000" />
                </div>


            </div>



            <asp:Panel ID="panelKlavuzCus" Style="display: none" runat="server">
                <asp:Button runat="server" ID="btnGeriDonCus" OnClientClick="btnGeriDonClientClickCus()" Text="Görev" CssClass="klavuz"
                    Style="background-image: url('Images/back.png');" />

                <input type="button" id="btnKlavuzDosyaCus" class="btnKlavuzEkDosya" value="Klavuz" onclick="btnKlavuzDosyaAcCus()"
                    style="position: absolute; left: 0px; top: 0px; width: 100px; background-color: #00a2d9; color: white" />
                <input type="button" id="btnEkDosyalarCus" class="btnKlavuzEkDosya" value="Ek Dosyalar" onclick="btnEkDosyalarAcCus()"
                    style="position: absolute; left: 100px; top: 0px; width: 100px; background-color: silver; color: black" />


                <asp:Panel ID="panelKlavuzDosyaCus" CssClass="panelKlavuzDosyaCls" Height="380px" Width="850px" runat="server" ScrollBars="Auto">

                    <table id="tableKlavuzCus" class="tableKlavuzYedekleme">
                        <tr>
                            <th style="width: 60px">ID</th>
                            <th style="width: 510px">Dosya Adı</th>
                            <th style="width: 100px">Kaydeden</th>
                            <th style="width: 160px">Kayıt Tarih</th>
                        </tr>

                    </table>


                </asp:Panel>

                <asp:Panel ID="panelEkDosyalarCus" runat="server" CssClass="panelEkDosyalarCls" Height="380px" Width="850px" ScrollBars="Auto">

                    <table id="tableEkDosyaCus" class="tableKlavuzYedekleme">
                        <tr>
                            <th style="width: 60px">GörevID</th>
                            <th style="width: 60px">DökID</th>
                            <th style="width: 400px">Dosya</th>
                            <th style="width: 100px">Kaydeden</th>
                            <th style="width: 160px">Kayıt Tarih</th>
                            <th style="width: 50px">Sil</th>
                        </tr>

                    </table>

                </asp:Panel>

            </asp:Panel>


            <div style="position: absolute; right: 8px; bottom: 3px; height: 40px">
                <asp:Button Text="Kaydet" runat="server" class="btn btn-blue" Style="width: 100px" ID="btnKaydetCus" OnClick="btnKaydet_Click" />
               
                <asp:Button Text="Kapat" runat="server" class="btn btn-dark" Style="width: 100px; margin-left: 20px" ID="btnIptalCus" OnClientClick="PopupPanelleriGizle()" />
            </div>



            <div style="height: 24px; position: absolute; bottom: 24px; left: 8px">
                <label class="custom-file-input file-blue">
                    <ajaxToolkit:AsyncFileUpload UploaderStyle="Traditional" ThrobberID="loadImageCus"
                        ID="AsyncFileUploadCus" OnClientUploadError="uploadErrorCus"
                        OnClientUploadComplete="uploadCompleteCus" OnClientUploadStarted="uploadStarted"
                        Font-Size="14px" Font-Bold="true" Height="26px"
                        runat="server" Width="300px"
                        OnUploadedComplete="AsyncFileUploadCus_UploadedComplete"
                        Style="margin-top: 10px; margin-left: 10px; float: left" />
                </label>
                <asp:Image ImageUrl="~/Images/loader.gif" Height="22px" Width="22px" Style="vertical-align: 8px; margin-left: 10px" ID="loadImageCus" runat="server" />
                <asp:Label ID="labMesajCus" CssClass="labMesajCls" Style="margin-left: 5px; vertical-align: 14px" runat="server"></asp:Label>
            </div>

            <!-- POPUP MESAJ FORM KISMI  INCEPTION:) ----------------------- BEGIN -->
            <asp:Button ID="btnMesajShowCus" runat="server" Text="SMP" Style="display: none" />
            <ajaxToolkit:ModalPopupExtender ID="mesajPopupCus" runat="server" BehaviorID="mpeMesajCus"
                PopupControlID="panelConfirmPopupCus" TargetControlID="btnMesajShowCus" OkControlID="btnYesCus" OnOkScript="OkClick();" CancelControlID="btnNoCus" OnCancelScript="CancelClick();"
                BackgroundCssClass="modalBackground2">
            </ajaxToolkit:ModalPopupExtender>
            <asp:Panel ID="panelConfirmPopupCus" runat="server" CssClass="modalMesajPopup" Style="display: none">
                <div class="header">
                    Onay Mesajı
                </div>
                <div class="body">
                    Bu kaydı silmek istediğinize emin misiniz ?
                </div>
                <div class="footer" align="right">
                    <asp:Button ID="btnYesCus" runat="server" Text="Evet" CssClass="yes" />
                    <asp:Button ID="btnNoCus" runat="server" Text="Hayır" CssClass="no" />
                </div>
            </asp:Panel>
            <!-- POPUP MESAJ FORM KISMI   ----------------------- END -->

          



        </asp:Panel>
        <!-- POPUP EDİT FORM CUSTOMER   ------------------------------ END -->
      

        <!-- POPUP EDİT FORM DİĞER  ----------------------------- BEGIN  -->
        <ajaxToolkit:ModalPopupExtender ID="mPopup2" runat="server" BehaviorID="MPE2" CancelControlID="btnIptal2"
            TargetControlID="btnPopupAc2" PopupControlID="popupPanel2" BackgroundCssClass="modalBackground"
            DropShadow="True" />
        <asp:Button ID="btnPopupAc2" runat="server" Style="display: none" Text="Popup Açmak İçin Şart" />
        <asp:Panel ID="popupPanel2" runat="server" CssClass="editPopupPanel2" Style="display: none">

            <div id="divEditPopup2" style="display: block">
                <asp:Button runat="server" ID="btnKlavuz2" OnClientClick="btnKlavuzClientClick2()" Text="Döküman" CssClass="klavuz" />


                <div class="div_pe_baslik">
                    <asp:Label ID="Label11" Style="margin-right: 173px; margin-left: 10px" runat="server" Text="Firma"></asp:Label>
                    <asp:Label ID="Label12" Style="margin-right: 175px" runat="server" Text="Proje"></asp:Label>
                    <asp:Label ID="Label14" Style="margin-right: 175px" runat="server" Text="Form"></asp:Label>
                    <asp:Label ID="Label20" runat="server" Text="T.Bitiş Tarihi"></asp:Label>
                </div>
                <div>
                    <div>
                        <asp:UpdatePanel ID="UpdatePanel4" style="width: 654px; float: left" runat="server">
                            <ContentTemplate>
                                <asp:DropDownList ID="ddlistFirma2" CssClass="form-control" Style="margin-left: 10px; border-radius: 4px" data-live-search="true"
                                    data-width="190px" Width="190px" runat="server" OnSelectedIndexChanged="ddlistFirma2_SelectedIndexChanged" AutoPostBack="True" />

                                <asp:DropDownList ID="ddlistProje2" CssClass="form-control" data-live-search="true" Style="margin-left: 20px; border-radius: 4px"
                                    data-width="190px" Width="190px" runat="server" AutoPostBack="true" OnSelectedIndexChanged="ddlistProje2_SelectedIndexChanged" />

                                <asp:Button ID="btnProjeEklemeyiAc2" runat="server" OnClick="btnProjeEklemeyiAc_Click" CssClass="btnProjeFormAcCss" />

                                <asp:DropDownList ID="ddlistForm2" CssClass="form-control" data-live-search="true" Style="margin-left: -4px; border: 2px solid #140145; border-radius: 4px"
                                    data-width="190px" Width="190px" runat="server" />

                                <asp:Button ID="btnFormEklemeyiAc2" runat="server" OnClick="btnFormEklemeyiAc_Click" CssClass="btnProjeFormAcCss" />


                            </ContentTemplate>
                            <Triggers>

                                <asp:AsyncPostBackTrigger ControlID="btnProjeEklemeyiAc2" EventName="Click" />
                                <asp:AsyncPostBackTrigger ControlID="btnFormEklemeyiAc2" EventName="Click" />
                                <asp:AsyncPostBackTrigger ControlID="ddlistFirma2" EventName="SelectedIndexChanged" />

                            </Triggers>
                        </asp:UpdatePanel>


                        <asp:HiddenField ID="hProje2" runat="server" Value="-" />
                        <asp:HiddenField ID="hForm2" runat="server" Value="-" />

                        <asp:TextBox ID="txtTahBitTarih2" Style="padding-left: 10px; border-radius: 4px" runat="server" BorderWidth="1" BorderColor="#666666" Height="31px" Width="100px" />

                        <asp:Label Style="margin-left: 2px; vertical-align: 2px; font-size: 12px; font-weight: bold" ID="labKayitTarihi2" runat="server"></asp:Label>
                    </div>

                </div>
                <div class="div_pe_baslik">
                    <asp:Label ID="Label22" Style="margin-right: 600px; margin-left: 10px" runat="server" Text="Görev"></asp:Label>
                    <asp:Label ID="Label23" Style="margin-right: 68px;" runat="server" Text="Öncelik"></asp:Label>
                    <asp:Label ID="Label24" runat="server" Text="Durum"></asp:Label>
                </div>
                <div style="width: 938px">
                    <asp:TextBox runat="server" Style="margin-left: 10px; padding-left: 6px; border-radius: 4px" BorderWidth="1" BorderColor="#666666" ID="txtGorev2" Width="618px" Height="32px"
                        MaxLength="40" />
                    <asp:UpdatePanel ID="UpdatePanel5" style="float: right" runat="server">
                        <ContentTemplate>
                            <asp:DropDownList ID="ddlistOncelik2" Style="margin-left: 10px; border-radius: 4px" CssClass="form-control" data-live-search="false" data-width="110px" Width="110px" runat="server" />

                            <asp:DropDownList ID="ddlistDurum2" Style="margin-left: 10px; border-radius: 4px" CssClass="form-control" data-live-search="false" data-width="160px" Width="160px" runat="server" />
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </div>
                <div class="div_pe_baslik">
                    <asp:Label ID="Label25" Style="margin-right: 173px; margin-left: 10px" runat="server" Text="Açıklama"></asp:Label>
                </div>
                <div>
                    <asp:TextBox runat="server" ID="txtAciklama2" Width="930px" Style="margin-left: 10px; padding-left: 6px; border-radius: 4px" Height="120px"
                        TextMode="MultiLine" BorderWidth="1" BorderColor="#666666" MaxLength="2000" />
                </div>
                <div class="div_pe_baslik">
                    <asp:Label ID="Label26" ToolTip="Yeni bir hareket olduğunda girilecek açıklamadır." Style="margin-right: 173px; margin-left: 10px; border-radius: 4px" runat="server" Text="Mesaj"></asp:Label>
                </div>
                <div>
                    <asp:TextBox runat="server" ID="txtDurumAciklama2" Width="930px"
                        Style="margin-left: 10px; padding-left: 6px; border-radius: 4px" Height="96px"
                        BorderWidth="1" BorderColor="#666666" TextMode="MultiLine" MaxLength="2000" />
                </div>


            </div>



            <asp:Panel ID="panelKlavuz2" Style="display: none" runat="server">
                <asp:Button runat="server" ID="btnGeriDon2" OnClientClick="btnGeriDonClientClick2()" Text="Görev" CssClass="klavuz"
                    Style="background-image: url('Images/back.png');" />

                <input type="button" id="btnKlavuzDosya2" class="btnKlavuzEkDosya" value="Klavuz" onclick="btnKlavuzDosyaAc2()"
                    style="position: absolute; left: 0px; top: 0px; width: 100px; background-color: #00a2d9; color: white" />
                <input type="button" id="btnEkDosyalar2" class="btnKlavuzEkDosya" value="Ek Dosyalar" onclick="btnEkDosyalarAc2()"
                    style="position: absolute; left: 100px; top: 0px; width: 100px; background-color: silver; color: black" />


                <asp:Panel ID="panelKlavuzDosya2" CssClass="panelKlavuzDosyaCls" Height="380px" Width="850px" runat="server" ScrollBars="Auto">

                    <table id="tableKlavuz2" class="tableKlavuzYedekleme">
                        <tr>
                            <th style="width: 60px">ID</th>
                            <th style="width: 510px">Dosya Adı</th>
                            <th style="width: 100px">Kaydeden</th>
                            <th style="width: 160px">Kayıt Tarih</th>
                        </tr>

                    </table>


                </asp:Panel>

                <asp:Panel ID="panelEkDosyalar2" runat="server" CssClass="panelEkDosyalarCls" Height="380px" Width="850px" ScrollBars="Auto">

                    <table id="tableEkDosya2" class="tableKlavuzYedekleme">
                        <tr>
                            <th style="width: 60px">GörevID</th>
                            <th style="width: 60px">DökID</th>
                            <th style="width: 400px">Dosya</th>
                            <th style="width: 100px">Kaydeden</th>
                            <th style="width: 160px">Kayıt Tarih</th>
                            <th style="width: 50px">Sil</th>
                        </tr>

                    </table>

                </asp:Panel>

            </asp:Panel>


            <div style="position: absolute; right: 8px; bottom: 3px; height: 40px">
                <asp:Button Text="Kaydet" runat="server" class="btn btn-blue" Style="width: 100px" ID="btnKaydet2" OnClick="btnKaydet_Click" />
                <asp:Button Text="Sil" runat="server" class="btn btn-danger" Style="width: 100px; margin-left: 20px" ID="btnSil2" OnClick="btnSil_Click"
                    OnClientClick="ShowMesajPopup(this,1); return false;" />

                <asp:Button Text="Kapat" runat="server" class="btn btn-dark" Style="width: 100px; margin-left: 20px" ID="btnIptal2" OnClientClick="PopupPanelleriGizle()" />
            </div>



            <div style="height: 24px; position: absolute; bottom: 24px; left: 8px">
                <label class="custom-file-input file-blue">
                    <ajaxToolkit:AsyncFileUpload UploaderStyle="Traditional" ThrobberID="loadImage3"
                        ID="AsyncFileUpload2" OnClientUploadError="uploadError2"
                        OnClientUploadComplete="uploadComplete2" OnClientUploadStarted="uploadStarted"
                        Font-Size="14px" Font-Bold="true" Height="26px"
                        runat="server" Width="300px"
                        OnUploadedComplete="AsyncFileUpload2_UploadedComplete"
                        Style="margin-top: 10px; margin-left: 10px; float: left" />
                </label>
                <asp:Image ImageUrl="~/Images/loader.gif" Height="22px" Width="22px" Style="vertical-align: 8px; margin-left: 10px" ID="loadImage3" runat="server" />
                <asp:Label ID="labMesaj3" CssClass="labMesajCls" Style="margin-left: 5px; vertical-align: 14px" runat="server"></asp:Label>
            </div>

            <!-- POPUP MESAJ FORM KISMI  INCEPTION:) ----------------------- BEGIN -->
            <asp:Button ID="btnMesajShow2" runat="server" Text="SMP" Style="display: none" />
            <ajaxToolkit:ModalPopupExtender ID="mesajPopup2" runat="server" BehaviorID="mpeMesaj2"
                PopupControlID="panelConfirmPopup2" TargetControlID="btnMesajShow2" OkControlID="btnYes2" OnOkScript="OkClick();" CancelControlID="btnNo2" OnCancelScript="CancelClick();"
                BackgroundCssClass="modalBackground2">
            </ajaxToolkit:ModalPopupExtender>
            <asp:Panel ID="panelConfirmPopup2" runat="server" CssClass="modalMesajPopup" Style="display: none">
                <div class="header">
                    Onay Mesajı
                </div>
                <div class="body">
                    Bu kaydı silmek istediğinize emin misiniz ?
                </div>
                <div class="footer" align="right">
                    <asp:Button ID="btnYes2" runat="server" Text="Evet" CssClass="yes" />
                    <asp:Button ID="btnNo2" runat="server" Text="Hayır" CssClass="no" />
                </div>
            </asp:Panel>
            <!-- POPUP MESAJ FORM KISMI   ----------------------- END -->

        </asp:Panel>
        <!-- POPUP EDİT FORM DİĞER   ------------------------------ END -->


        <!-- POPUP CALİSMA FORM   ----------------------------- BEGIN  -->
        <ajaxToolkit:ModalPopupExtender ID="mPopupCalisma" runat="server" BehaviorID="MPECalisma" CancelControlID="btnCalismaIptal"
            TargetControlID="btnPopupCalismaAc" PopupControlID="popupCalismaPanel" BackgroundCssClass="modalBackground"
            DropShadow="True" />
        <asp:Button ID="btnPopupCalismaAc" runat="server" Style="display: none" Text="Popup Açmak İçin Şart" />
        <asp:Panel ID="popupCalismaPanel" runat="server" CssClass="editPopupCalisma" Style="display: none">
            <div id="anaDiv">
                <div id="div1" class="baslik">
                    <asp:Label ID="lab1" Style="margin-right: 20px;" Width="120px" runat="server" Text="Sorumlu"></asp:Label>
                    <asp:Label ID="lab2" Style="margin-right: 20px" Width="120px" runat="server" Text="Firma"></asp:Label>
                    <asp:Label ID="lab3" Style="margin-right: 20px" Width="150px" runat="server" Text="Proje"></asp:Label>
                    <asp:Label ID="lab4" Style="margin-right: 20px" Width="150px" runat="server" Text="Form"></asp:Label>
                    <asp:Label ID="lab5" runat="server" Text="Tah.Bitiş"></asp:Label>
                </div>
                <div id="div2" class="satir">
                    <asp:TextBox ID="txtcSorumlu" Style="margin-right: 20px; background-color: #ebe8e8;" Width="120px" runat="server"></asp:TextBox>
                    <asp:TextBox ID="txtcFirma" Style="margin-right: 20px; background-color: #ebe8e8" ReadOnly="true" Width="120px" runat="server"></asp:TextBox>
                    <asp:TextBox ID="txtcProje" Style="margin-right: 20px; background-color: #ebe8e8" ReadOnly="true" Width="150px" runat="server"></asp:TextBox>
                    <asp:TextBox ID="txtcForm" Style="margin-right: 20px; background-color: #ebe8e8" ReadOnly="true" Width="150px" runat="server"></asp:TextBox>
                    <asp:TextBox ID="txtcTahBitis" Style="margin-right: 20px; background-color: #ebe8e8" Width="90px" ReadOnly="true" runat="server"></asp:TextBox>
                </div>

                <div class="baslik">
                    <asp:Label runat="server" Text="Görev"></asp:Label>
                </div>
                <div class="satir">
                    <asp:TextBox ID="txtcGorev" Style="margin-right: 20px; background-color: #ebe8e8" ReadOnly="true" Width="727px" Height="25px" runat="server"></asp:TextBox>
                </div>
                <div class="baslik">
                    <asp:Label ID="Label8" Style="margin-right: 30px" runat="server" Text="Açıklama"></asp:Label>
                </div>
                <div class="satir3">
                    <asp:TextBox ID="txtcAciklama" Style="background-color: #ebe8e8" ReadOnly="true" Width="900px" Height="95px" TextMode="MultiLine" runat="server"></asp:TextBox>
                </div>

                <div class="baslik">
                    <asp:Label ID="Label9" Style="margin-right: 315px" runat="server" Text="Çalışma"></asp:Label>
                </div>
                <div class="satir4">
                    <asp:TextBox ID="txtcCalisma" Style="margin-right: 20px" Width="900px" Height="112px" TextMode="MultiLine" runat="server"></asp:TextBox>
                </div>

                <div class="baslik">
                    <asp:Label Style="margin-right: 20px;" Width="90px" runat="server" Text="Tarih"></asp:Label>
                    <asp:Label Style="margin-right: 30px;" Width="90px" runat="server" Text="Süre(dk)"></asp:Label>
                </div>
                <div class="satir">
                    <asp:TextBox ID="txtcTarih" Style="margin-right: 20px" Width="90px" runat="server"></asp:TextBox>
                    <asp:TextBox ID="txtcSure" Style="margin-right: 2px" Width="90px" runat="server"></asp:TextBox>
                    <span id="hataMessage"></span>

                    <label class="custom-file-input file-blue">
                        <ajaxToolkit:AsyncFileUpload UploaderStyle="Traditional" ThrobberID="loadImage2"
                            ID="AsyncFileUploadProjeBackup" OnClientUploadError="uploadErrorProjeBackup"
                            OnClientUploadComplete="uploadCompleteProjeBackup"
                            Font-Size="14px" Font-Bold="true" Height="26px"
                            runat="server" Width="300px"
                            OnUploadedComplete="AsyncFileUploadProjeBackup_UploadedComplete"
                            Style="display: inline-block; margin-left: 20px" />

                    </label>
                    <asp:Image ImageUrl="~/Images/loader.gif" Height="22px" Width="22px" Style="margin-left: 10px" ID="loadImage2" runat="server" />
                    <asp:Label ID="labMesaj2" Style="margin-left: 5px;" runat="server"></asp:Label>

                </div>

                <asp:HiddenField ID="hfcFirma" runat="server" />
                <asp:HiddenField ID="hfcProje" runat="server" />
                <asp:HiddenField ID="hfcGorevID" runat="server" />


                <!--BUTONLAR BEGIN-->
                <div class="satir">
                    <asp:Button ID="btnCalismaKaydet" OnClick="btnCalismaKaydet_Click" Style="position: absolute; right: 160px; bottom: -4px" runat="server"
                        Text="Kaydet" Width="100px" class="btn btn-primary m-b-10" />
                    <asp:Button ID="btnCalismaIptal" OnClientClick="PopupPanelleriGizle()" Style="position: absolute; right: 30px; bottom: 6px" runat="server"
                        Text="Kapat" Width="100px" class="btn btn-dark" />
                </div>
                <!--BUTONLAR END-->
            </div>
        </asp:Panel>
        <!-- POPUP CALİSMA FORM   ------------------------------ END -->

        <!-- POPUP HAREKETLER   ----------------------------- BEGIN  -->
        <ajaxToolkit:ModalPopupExtender ID="mPopupHareket" runat="server" BehaviorID="MPEHareket" CancelControlID="btnHareketKapat"
            TargetControlID="btnPopupHareketAc" PopupControlID="popupHareketlerPanel" BackgroundCssClass="modalBackground"
            DropShadow="True" />
        <asp:Button ID="btnPopupHareketAc" runat="server" Style="display: none" Text="Popup Açmak İçin Şart" />
        <asp:Panel ID="popupHareketlerPanel" runat="server" CssClass="PopupHareketler" Style="display: none">

            <!--BUTONLAR BEGIN-->
            <div style="width: 670px; position: fixed;">
                <asp:Button ID="btnHareketKapat" OnClientClick="PopupPanelleriGizle()" Style="float: right; font-size: 16px; margin-top: -6px; font-weight: bold"
                    runat="server" Text="x" CssClass="btn btn-dark" Height="30px" Width="40px" />
            </div>
            <!--BUTONLAR END-->

            <div id="divHareket">

                <table id="tableHareket" cellpadding="0" cellspacing="0" border="0">
                    <tr>
                        <th style="width: 50px">Sıra</th>
                        <th style="width: 80px">GörevID</th>
                        <th style="width: 130px">Görev Tarihi</th>
                        <th style="width: 90px">Sorumlu</th>
                        <th style="width: 90px">Durum</th>
                        <th style="width: 90px">Kaydeden</th>
                        <th style="width: 130px">Kayıt Tarihi</th>

                    </tr>
                </table>

                <asp:HiddenField ID="hfH_GorevID" runat="server" />

            </div>

        </asp:Panel>
        <!-- POPUP HAREKETLER   --------------------------- END -->

        <!-- POPUP HAREKET DETAY   ----------------------------- BEGIN  -->
        <ajaxToolkit:ModalPopupExtender ID="mPopupHareketDetay" runat="server" BehaviorID="MPEHareketDetay" CancelControlID="btnHareketDetayKapat"
            TargetControlID="btnPopupHareketDetayAc" PopupControlID="popupHareketDetayPanel" BackgroundCssClass="modalBackground"
            DropShadow="True" />
        <asp:Button ID="btnPopupHareketDetayAc" runat="server" Style="display: none" Text="Popup Açmak İçin Şart" />
        <asp:Panel ID="popupHareketDetayPanel" runat="server" CssClass="PopupHareketDetay" Style="display: none">

            <!--BUTONLAR BEGIN-->
            <div style="width: 570px; position: fixed">
                <asp:Button ID="btnHareketDetayKapat" Style="float: right; font-size: 16px; margin-top: -6px; font-weight: bold"
                    runat="server" Text="x" CssClass="btn btn-dark" Height="32px" Width="40px" />
            </div>
            <!--BUTONLAR END-->

            <div id="divHareketDetay" style="padding-top: 2px">
                <div style="height: 25px">
                    <span style="font-size: 14px; vertical-align: -8px; margin-left: 4px; font-weight: bold">Görev : </span>
                </div>
                <div style="height: 50px">
                    <textarea rows="3" style="margin-left: 2px; width: 560px" id="taGorev"></textarea>
                </div>
                <div style="height: 25px">
                    <span style="font-size: 14px; vertical-align: -8px; margin-left: 4px; font-weight: bold">Açıklama :</span>
                </div>
                <div style="height: 100px">

                    <textarea rows="6" style="margin-left: 2px; width: 560px" id="taAciklama"></textarea>
                </div>
                <div style="height: 25px">
                    <span style="font-size: 14px; margin-left: 4px; vertical-align: -8px; font-weight: bold">Mesaj :</span>
                </div>
                <div style="height: 150px">

                    <textarea rows="9" style="margin-left: 2px; width: 560px" id="taDAciklama"></textarea>
                </div>

            </div>

        </asp:Panel>
        <!-- POPUP HAREKET DETAY   --------------------------- END -->

        
        <!-- GÖREVİN ÇALIŞMALARI   --------------------------- BEGIN  -->
        <ajaxToolkit:ModalPopupExtender ID="mPopupCalismalar" runat="server" BehaviorID="MPECalismalar" CancelControlID="btnCalismalariKapat"
            TargetControlID="btnCalismalariAc" PopupControlID="popupCalismalarPanel" BackgroundCssClass="modalBackground"
            DropShadow="True" />
        <asp:Button ID="btnCalismalariAc" runat="server" Style="display: none" Text="Popup Açmak İçin Şart" />
        <asp:Panel ID="popupCalismalarPanel" runat="server" CssClass="PopupHareketler" Style="width:930px; display: none">

            <!--BUTONLAR BEGIN-->
            <div style="position: absolute; right:-6px; top:0">
                <asp:Button ID="btnCalismalariKapat" OnClientClick="PopupPanelleriGizle()" Style="float: right; font-size: 14px; margin-top: -6px; font-weight: bold"
                    runat="server" Text="x" CssClass="btn btn-dark" Height="30px" Width="32px" />
            </div>
            <!--BUTONLAR END-->


            <div id="divCalismalar" style="width:920px">
                <table id="tableCalismalar" cellpadding="0" cellspacing="0" border="0">
                    <tr>
                        <th style="width: 50px; text-align:center">Sıra</th>
                        <th style="width: 82px">Çalışma ID</th>
                        <th style="width: 82px">Kaydeden</th>
                        <th style="width: 95px">Sorumlular</th>
                        <th style="width: 130px">Firma</th>
                        <th style="width: 140px">Proje</th>
                        <th style="width: 160px">Form</th>
                        <th style="width: 80px">Ç.Süresi</th>
                        <th style="width: 90px">Ç.Tarihi</th>
                    </tr>
                </table>
                <asp:HiddenField ID="hf_CalismaID" runat="server" />
            </div>

        </asp:Panel>
        <!-- GÖREVİN ÇALIŞMALARI   ---------------------------- END -->

        <!-- GÖREV ÇALIŞMA DETAY   ----------------------------- BEGIN  -->
        <ajaxToolkit:ModalPopupExtender ID="mPopupCalismaDetay" runat="server" BehaviorID="MPECalismaDetay" CancelControlID="btnCalismaDetayKapat"
            TargetControlID="btnPopupCalismaDetayAc" PopupControlID="popupCalismaDetayPanel" BackgroundCssClass="modalBackground"
            DropShadow="True" />
        <asp:Button ID="btnPopupCalismaDetayAc" runat="server" Style="display: none" Text="Popup Açmak İçin Şart" />
        <asp:Panel ID="popupCalismaDetayPanel" runat="server" CssClass="PopupHareketDetay" Style="display: none; width:684px">

            <!--BUTONLAR BEGIN-->
            <div style="position: absolute; right:-6px; top:0">
                <asp:Button ID="btnCalismaDetayKapat" Style="float: right; font-size: 14px; margin-top: -6px; font-weight: bold"
                    runat="server" Text="x" CssClass="btn btn-dark" Height="30px" Width="32px" />
            </div>
            <!--BUTONLAR END-->

            <div id="divCalismaDetay" style="padding-top: 2px; width:680px">
                <div style="height: 25px">
                    <span style="font-size: 14px; vertical-align: -8px; margin-left: 4px; font-weight: bold">Görev : </span>
                </div>
                <div style="height: 50px">
                    <textarea rows="3" style="margin-left: 2px; width: 670px" id="cdGorev"></textarea>
                </div>
                <div style="height: 25px">
                    <span style="font-size: 14px; vertical-align: -8px; margin-left: 4px; font-weight: bold">Açıklama :</span>
                </div>
                <div style="height: 100px">

                    <textarea rows="6" style="margin-left: 2px; width: 670px" id="cdAciklama"></textarea>
                </div>
                <div style="height: 25px">
                    <span style="font-size: 14px; margin-left: 4px; vertical-align: -8px; font-weight: bold">Çalışma :</span>
                </div>
                <div style="height: 150px">

                    <textarea rows="9" style="margin-left: 2px; width: 670px" id="cdCalisma"></textarea>
                </div>

            </div>

        </asp:Panel>
        <!-- GÖREV ÇALIŞMA DETAY    --------------------------- END -->


        <!-- POPUP DÜRBÜN   ----------------------------- BEGIN  -->
        <ajaxToolkit:ModalPopupExtender ID="mPopupDurbun" runat="server" BehaviorID="MPEDurbun" CancelControlID="btnDurbunKapat"
            TargetControlID="btnPopupDurbunAc" PopupControlID="popupDurbunPanel" BackgroundCssClass="modalBackground"
            DropShadow="True" />
        <asp:Button ID="btnPopupDurbunAc" runat="server" Style="display: none" Text="Popup Açmak İçin Şart" />
        <asp:Panel ID="popupDurbunPanel" runat="server" CssClass="PopupDurbun" Style="display: none">

            <asp:UpdatePanel ID="upPanelDurbun" runat="server">
                <ContentTemplate>
                    <div id="divDurbun">
                        <table id="tableDurbun" cellpadding="0" cellspacing="0" border="0">
                            <tr>
                                <td style="width: 200px">Sorumlu   
                                  &nbsp;&nbsp;&nbsp; &nbsp; &nbsp; &nbsp;
                                  <asp:CheckBox ID="chkAsli" Checked="true" runat="server" Text="Asli" />
                                    &nbsp;&nbsp;
                                  <asp:CheckBox ID="chkYedek" Checked="false" runat="server" Text="Yedek" />
                                </td>
                                <td style="width: 200px">Firma</td>
                                <td style="width: 200px">Proje</td>
                                <td style="width: 200px">Form</td>
                            </tr>
                           
                             <tr>
                                <td>
                                    <asp:DropDownList ID="ddlDSorumlu" CssClass="form-control" data-live-search="true" data-width="200px" Width="200px"
                                        runat="server" AutoPostBack="true" />
                                </td>
                                <td>
                                    <asp:DropDownList ID="ddlDFirma" CssClass="form-control" data-live-search="true" data-width="200px" Width="200px"
                                        runat="server" AutoPostBack="true" OnSelectedIndexChanged="ddlDFirma_SelectedIndexChanged" />


                                    <asp:TextBox ID="txtDurbunFirma" Enabled="false" Style="padding-left: 6px; height: 32px"
                                        Visible="false" data-width="200px" Width="200px" runat="server"></asp:TextBox>

                                </td>
                                <td>
                                    <asp:DropDownList ID="ddlDProje" CssClass="form-control" data-live-search="true" data-width="200px" Width="200px"
                                        runat="server" AutoPostBack="true" OnSelectedIndexChanged="ddlDProje_SelectedIndexChanged" />
                                </td>
                                <td>
                                    <asp:DropDownList ID="ddlDForm" CssClass="form-control" data-live-search="true" data-width="200px" Width="200px"
                                        runat="server" AutoPostBack="true" />
                                </td>
                            </tr>
                            <tr>
                                <td>Durum</td>
                                <td>Kayıt Tarihi</td>
                                <td>Tah. Bitiş Tarihi</td>
                                <td>Genel Seçenekler</td>
                            </tr>
                            <tr>
                                <td>
                                    <asp:DropDownList ID="ddlDDurum" CssClass="form-control" data-live-search="true" data-width="200px" Width="200px"
                                        runat="server" AutoPostBack="true" />
                                </td>
                                <td>
                                    <asp:TextBox ID="txtDKayitTarih1" CssClass="txtTakvim" runat="server" Height="26px" Width="95px" />
                                    <asp:TextBox ID="txtDKayitTarih2" CssClass="txtTakvim" runat="server" Height="26px" Width="95px" />
                                </td>
                                <td>
                                    <asp:TextBox ID="txtDTahBitisTarihi1" CssClass="txtTakvim" runat="server" Height="26px" Width="95px" />
                                    <asp:TextBox ID="txtDTahBitisTarihi2" CssClass="txtTakvim" runat="server" Height="26px" Width="95px" />
                                </td>
                                <td>
                                    <asp:DropDownList ID="ddlDGenelDurumlar" CssClass="form-control" data-live-search="true" data-width="200px" Width="200px"
                                        runat="server">
                                    </asp:DropDownList>
                                </td>
                            </tr>
                            <tr>
                                <td colspan="2">Görev</td>
                                <td colspan="2">Açıklama</td>
                            </tr>
                            <tr>
                                <td colspan="2">
                                    <asp:TextBox runat="server" ID="txtDGorev" Width="400px" Height="40px"
                                        TextMode="MultiLine" />
                                </td>

                                <td colspan="2">
                                    <asp:TextBox runat="server" ID="txtDAciklama" Width="400px" Height="40px"
                                        TextMode="MultiLine" />
                                </td>
                            </tr>
                        </table>
                    </div>
                </ContentTemplate>
                <Triggers>
                </Triggers>
            </asp:UpdatePanel>


            <!--BUTONLAR BEGIN-->
            <div style="width: 800px; position:absolute; bottom:5px; margin-left: 10px">
                <asp:Label ID="labToplamKayit" Style="width: 100px; margin-right: 100px" Font-Bold="true" Text="Bulunan Kayıt Sayısı : " runat="server" />
                <div style="width: 300px; float: right">
                    <asp:Button ID="btnDurbunGorevGetir" Style="float: left"
                        runat="server" Text="Süz Getir" Width="100px" OnClick="btnDurbunGorevGetir_Click" />
                    <asp:Button ID="btnDurbunKapat" OnClientClick="PopupPanelleriGizle()" Style="float: right"
                        runat="server" Text="Kapat" Width="100px" />
                </div>
            </div>
            <!--BUTONLAR END-->
        </asp:Panel>
        <!-- POPUP DÜRBÜN   --------------------------- END -->


        <asp:HiddenField ID="hfYetkiKodu" runat="server" />

        <!-- PROJEFORM POPUP EDİT FORM   ----------------------------- BEGIN  -->
        <ajaxToolkit:ModalPopupExtender ID="mPopupProjeForm" runat="server" BehaviorID="MPEProjeForm"
            TargetControlID="btnPopupProjeForm" PopupControlID="popupProjeFormPanel" BackgroundCssClass="modalBackground"
            DropShadow="True" />
        <asp:Button ID="btnPopupProjeForm" runat="server" Style="display: none" Text="Popup Açmak İçin Şart" />
        <asp:Panel ID="popupProjeFormPanel" runat="server" CssClass="editPopupProjeTanim2" Style="display: none">
            <asp:UpdatePanel ID="upPanelProjeFormEdit" runat="server">
                <ContentTemplate>
                    <div>
                        <table border="0" cellpadding="4px" class="tableCls" cellspacing="0" style="margin-top: 8px">
                            <tr>
                                <td class="tdbaslik">Firma
                                </td>
                                <td>
                                    <asp:TextBox ID="txtFirma" ReadOnly="true" Width="260px" CssClass="form-control" runat="server"></asp:TextBox>
                                </td>
                                <td style="width: 50px"></td>
                            </tr>
                            <tr>
                                <td class="tdbaslik">Proje
                                </td>
                                <td>
                                    <div class="divtxtProje">
                                        <asp:TextBox ID="txtProje" Width="260px" CssClass="form-control" runat="server"></asp:TextBox>
                                    </div>
                                </td>
                                <td style="width: 60px; float: right; padding-top: 5px"></td>
                            </tr>
                            <tr>
                                <td colspan="2">
                                    <asp:Panel ID="txtFormPanel" runat="server" Visible="false">
                                        <span style="font-weight: bold; font-size: 14px; margin-left: 2px">Form</span>
                                        <asp:TextBox ID="txtForm" Width="260px" Style="margin-left: 6px" CssClass="form-control" runat="server"></asp:TextBox>
                                    </asp:Panel>
                                </td>
                                <td></td>
                            </tr>
                            <tr>
                                <td>&nbsp;</td>
                                <td>
                                    <asp:Button ID="btnProjeFormKaydet" runat="server" Text="Kaydet"
                                        data-original-title="Proje-Form Kaydet" rel="tooltip" type="button"
                                        class="btn btn-primary m-b-10" data-toggle="tooltip" data-placement="bottom" Width="120px"
                                        OnClick="btnProjeFormKaydet_Click" Style="position: absolute; bottom: -6px; right: 36px" />

                                </td>
                                <td></td>
                            </tr>

                        </table>

                        <asp:Button ID="btnPopupKapat" runat="server" Text=" x " Font-Size="22px" data-original-title="Kapat" rel="tooltip"
                            type="button" class="btn btn-primary m-b-10" data-toggle="tooltip" data-placement="bottom" title=""
                            CssClass="btn btn-primary m-b-10" Width="30px" Height="30px" Style="position: absolute; right: 0px; top: 0px; padding: 0px"
                            OnClick="btnPopupKapat_Click" />

                    </div>
                </ContentTemplate>
                <Triggers>

                    <asp:AsyncPostBackTrigger ControlID="btnPopupKapat" EventName="Click" />
                </Triggers>
            </asp:UpdatePanel>


            <!-- POPUP MESAJ FORM KISMI  INCEPTION:) ----------------------- BEGIN -->
            <asp:Button ID="Button2" runat="server" Text="SMP" Style="display: none" />
            <ajaxToolkit:ModalPopupExtender ID="mesajPopup3" runat="server" BehaviorID="mpeMesaj3"
                PopupControlID="panelConfirmPopup" TargetControlID="btnMesajShow" OkControlID="btnYes3" OnOkScript="OkClick();" CancelControlID="btnNo3" OnCancelScript="CancelClick();"
                BackgroundCssClass="modalBackground2">
            </ajaxToolkit:ModalPopupExtender>
            <asp:Panel ID="panel2" runat="server" CssClass="modalMesajPopup" Style="display: none">
                <div class="header">
                    Onay Mesajı
                </div>
                <div class="body">
                    Bu kaydı silmek istediğinize emin misiniz ?
                </div>
                <div class="footer" align="right">
                    <asp:Button ID="btnYes3" runat="server" Text="Evet" CssClass="yes" />
                    <asp:Button ID="btnNo3" runat="server" Text="Hayır" CssClass="no" />
                </div>
            </asp:Panel>
            <!-- POPUP MESAJ FORM KISMI   ----------------------- END -->

        </asp:Panel>
        <!-- PROJEFORM POPUP EDİT FORM   ------------------------------ END -->



        <!--Timer Update Panel ------------------------------ BEGIN -->
        <!--Burada Triggers'a Butonların Click Eventleri bağlanarak Asp.Net butonların PostBack olmadan çalışması sağlanıyor-->
        <asp:UpdatePanel ID="upPanel3" runat="server">
            <ContentTemplate>
                <asp:Timer ID="timerGenel" runat="server" Interval="100" OnTick="timerGenel_Tick">
                </asp:Timer>
            </ContentTemplate>
            <Triggers>
                <asp:AsyncPostBackTrigger ControlID="timerGenel" EventName="Tick" />
                <asp:AsyncPostBackTrigger ControlID="btnKaydet" EventName="Click" />
                <asp:AsyncPostBackTrigger ControlID="btnKaydetCus" EventName="Click" />
                <asp:AsyncPostBackTrigger ControlID="btnKaydet2" EventName="Click" />
                <asp:AsyncPostBackTrigger ControlID="btnSil" EventName="Click" />              
                <asp:AsyncPostBackTrigger ControlID="btnSil2" EventName="Click" />
            
                <asp:AsyncPostBackTrigger ControlID="btnCalismaKaydet" EventName="Click" />
                <asp:AsyncPostBackTrigger ControlID="btnDurbunGorevGetir" EventName="Click" />

                <asp:AsyncPostBackTrigger ControlID="btnKlavuz" />
                <asp:AsyncPostBackTrigger ControlID="btnGeriDon" />
                <asp:AsyncPostBackTrigger ControlID="btnKlavuzCus" />
                <asp:AsyncPostBackTrigger ControlID="btnGeriDonCus" />
                <asp:AsyncPostBackTrigger ControlID="btnKlavuz2" />
                <asp:AsyncPostBackTrigger ControlID="btnGeriDon2" />


            </Triggers>
        </asp:UpdatePanel>
        <!--Timer Update Panel  ----------------------------- END -->

    </asp:Panel>

</asp:Content>
