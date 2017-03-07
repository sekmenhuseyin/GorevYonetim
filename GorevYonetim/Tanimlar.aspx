<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Tanimlar.aspx.cs" Inherits="GorevYonetim.Tanimlar" %>
<%@ Register  Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="ajaxToolkit" %>


<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
     
    <link rel="Stylesheet" href="Styles/GridStyle.css" />
    <link rel="Stylesheet" href="Styles/Gorev.css" />
    <style type="text/css">
        .FilterDropDownCss
        {
            width:180px;
            line-height:26px;
            font-family:Arial,Tahoma;
            font-size:10pt;
            border-radius:4px;
            color:black;
            height:28px;
            padding-left:4px;
            border:1px solid #333;
        }
        .btnGozatCss
        {
            background-image:url('Images/gridTool/zoom.png');
            background-repeat:no-repeat;
            color:black;
            width:76px;
            height:34px;
            padding-left:30px;
            border:1px solid gray;
        }
            .btnGozatCss:hover
            {
                background-color:gray;
                color:white;
            }
        .btnGeriDonCss
        {
            background-image:url('Images/gridTool/back.png');
            background-repeat:no-repeat;
            color:black;
            width:110px;
            height:36px;
            padding-left:32px;
            border:1px solid gray;
        }
            .btnGeriDonCss:hover
            {
                background-color:gray;
                color:white;
            }

        .btnKlavuzYedeklemeCss
        {          
            background-repeat:no-repeat;
            color:black;
            width:200px;
            line-height:28px;
            height:32px;
            padding-left:30px;
            border:2px solid gray;
            margin:0px;
        }
            .btnKlavuzYedeklemeCss:hover
            {
                background-color:gray;
                color:white;
            }

        .tableKlavuzYedekleme
        {
            border:2px solid gray;
        }
        .tableKlavuzYedekleme tr th
        {
            padding:6px 4px 6px 10px;
            color:white;
            background-color:#606080;   
        }
        .tableKlavuzYedekleme tr td 
        {
            padding:3px 4px 3px 10px; 
        }
        .tableKlavuzYedekleme tr:nth-child(even) td
        {
            background-color:silver;
            color: black;
        }
            .tableKlavuzYedekleme tr:nth-child(even) td a
            {
                color: black;
            }
                .tableKlavuzYedekleme tr:nth-child(even) td a:hover
                {
                    font-weight: bold;
                }
        .tableKlavuzYedekleme tr:nth-child(odd) td
        {    
            background-color:aliceblue;
            color: black;
        }
            .tableKlavuzYedekleme tr:nth-child(odd) td a
            {
                color:black;
            }
                .tableKlavuzYedekleme tr:nth-child(odd) td a:hover
                {
                    font-weight: bold;
                }
    </style>

    <script type="text/javascript" src="assets/plugins/jquery-1.11.js"></script>
    <script type="text/javascript">
        
        $(function () 
        {           
            $(document).keydown(function (e) {
                if (e.which == 113) {  // F2 YENİ KAYIT
                    var deger = $(".PageTypeCls").val();
                    if (deger == "4") {
                        var kontrol = $("#<%=popupPanel.ClientID%>").css("display");
                        if (kontrol == "none") {
                            $(".chkProjectCls").prop("checked", false);
                            $(".divtxtProje").hide();
                            $(".divddlProje").show();

                            $(".chkFormCls").prop("checked", true);
                            $(".divddlForm").hide();
                            $(".divtxtForm").show();
                            ShowPopup_YeniKayit();
                        }
                    }
                    return false;
                }
                if (e.which == 112) {  // F1 BİŞEY YAPMA
                    return false;
                }
                else if (e.which == 27) { // ESC POPUPLARI KAPAT
                    PopupPanelGizle();
                    return false;
                }
            });

            $("input[name$='Tarih']").live("focus", function () {
                $(this).datepicker({
                    showOn: 'button',
                    dateFormat: "dd.mm.yyyy",
                });
            });

            /// Bootstrapla Ajax Toolkit çakışmasından kaynaklanan sorun düzelsin diye..
            $("#<%=ddlFirma.ClientID%>").val("-").change();  
                   
       }); /// Ready Function Sonu

        function PopupPanelGizle() {
            $find("MPE").hide();
            $("#<%=popupPanel.ClientID%>").css("display", "none");
        }

        function ShowPopup_YeniKayit() {
            // Popup Paneli görünür yapıyorum 
            $("#popupPanel").css("display", "block");            
            $("#<%=txtForm.ClientID%>").val("");
            $("#<%=txtProje.ClientID%>").val("");
            $("#<%=ddlFirma.ClientID%>").val("-").change();  
            $("#<%=ddlProje.ClientID%>").val("-").change();

            $(".divtxtProje").hide();
            $(".divddlProje").show();
          
            $find("MPE").show();                  
            return false;
        }

        function panelBilgiKapan() {
            $("#panelbilgi").css("display", "none");
        }

        function panelBilgiAc() {
            $("#panelbilgi").css("display", "block");
        }

        function chkProjectCheck() {
            $("#<%=txtForm.ClientID%>").val("");
            var deger = $('.chkProjectCls').is(':checked').valueOf();
            if (deger) {
                $("#<%=txtForm.ClientID%>").prop("disabled", true);
                $(".divddlProje").hide();
                $(".divtxtProje").show();
            }
            else {             
                $("#<%=txtForm.ClientID%>").prop("disabled", false);
                $(".divtxtProje").hide();
                $(".divddlProje").show();
            }
        }

        function SetCssProject()
        {
            chkProjectCheck();
        }

        function chkFormCheck() {
               var deger = $('.chkFormCls').is(':checked').valueOf();
               if (deger) {              
                $(".divddlForm").hide();
                $(".divtxtForm").show();
            }
            else {
                $(".divtxtForm").hide();
                $(".divddlForm").show();
            }
        }

        //// Popup MesajBoxın Evetemi Hayıra mı tıklandığını almak için
        var _source;
        var _popup;
        function ShowMesajPopup(source) {           
            var mesaj = 'Bu kaydı silmek istediğinize emin misiniz ?';
            var deger = $('.chkFormCls').is(':checked').valueOf();
            if (deger)
                mesaj ='Bu proje ve altındaki tüm formlar silinecek. Emin misiniz ?'
            $(".body").text(mesaj);

            this._source = source;
            this._popup = $find('mpeMesaj');
            this._popup.show();
        }
        function OkClick() {
            this._popup.hide();
            __doPostBack(this._source.name, '');
        }
        function CancelClick() {
            this._popup.hide();
            this._source = null;
            this._popup = null;
        }
        ///-----------------------------------------------------------

        /// AsynFileUploadla ilgili kodlar  --------------------------
        function uploadStarted(sender, args) {
            ///100 MB sınırı kontrol ediliyor..
            if (sender._inputFile.files[0].size >= 104857600) {
                //sender._stopLoad();
                var err = new Error();
                err.name = 'Dosya boyutu hatası';
                err.message = 'Dosya boyutu 100 MB üzerinde olduğu için upload edilemiyor !';
                throw (err);
                return false;
            }
        }

        function uploadComplete(sender,args) {
            var fileName = args.get_fileName();

            var tip = $("#<%=hKlavuzYedek01.ClientID%>").val();
            if (tip == "0")
                $("#tableKlavuz tr:first").after("<tr><td><span style='font-weight:bold'> **</span></td><td><span style='font-weight:bold'>" + fileName + "</span></td><td></td><td></td></tr>");
            else if (tip == "1")
                $("#tableYedekleme tr:first").after("<tr><td><span style='font-weight:bold'> **</span></td><td><span style='font-weight:bold'>" + fileName + "</span></td><td></td><td></td></tr>");

            $get("<%=labMesaj.ClientID%>").innerHTML = "<span style='color:green'><b>Upload işlemi başarıyla gerçekleşti.</b></span>";
        }

        function uploadError(sender, args) {
            $get("<%=labMesaj.ClientID%>").innerHTML = "<span style='color:red'><b> Hata Oluştu : </b>" + args.get_errorMessage() +"</span>";
        }
        ///-----------------------------------------------------------

        function UpPanelProjeAcKapa(tip) {
            if (tip == 1) {
                $("#<%=upPanelProje.ClientID%>").show();
            }
            else {
                $("#<%=upPanelProje.ClientID%>").hide();
            }
        }


        function ProjeGozat(selRowInfo) {
            var row = selRowInfo.parentNode.parentNode;
            var $idText = row.cells[2].innerHTML;            
            var hidden = $("input[type$=hidden]",$idText);
            var ProjeID = hidden.prevObject[2].defaultValue;

            var firma = row.cells[1].innerText;
            var proje = row.cells[2].innerText;                
            $("#<%=upPanelProje.ClientID%>").hide();
            $("#divFiltreGenel").show();
            $("#<%=labProID.ClientID%>").text(ProjeID);
            $("#<%=hProID.ClientID%>").val(ProjeID);
            $("#<%=labFirma.ClientID%>").text(firma);
            $("#<%=labProje.ClientID%>").text(proje);

            BtnKlavuzClick();

            $("#tableKlavuz td").remove();
            $("#tableYedekleme td").remove();

            $.ajax({
                type: "POST",
                url: "Tanimlar.aspx/DokumanGetir",
                data: "{ ProjeID: '" + ProjeID + "' }",
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

            $.ajax({
                type: "POST",
                url: "Tanimlar.aspx/BackupGetir",
                data: "{ ProjeID: '" + ProjeID + "' }",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (response) {
                    if (response.d.length > 0) {
                        for (var i = 0; i < response.d.length; i++) {
                            $("#tableYedekleme").append(
                                "<tr><td>" + response.d[i].ID + "</td><td><a target='_blank' href='UploadFiles/ProjeBackup/PB" +
                                response.d[i].GorevID + "/" + response.d[i].DosyaAdi + "' >" +
                                response.d[i].DosyaAdi + "</a></td><td>" + response.d[i].Kaydeden + "</td><td>" + response.d[i].KayitTarihStr + "</td></tr>");
                        }
                    }
                },
                failure: function (response) {
                    alert(response.d);
                }
            });
        }
        

        function GridProjeyeDon() {
            $("#divFiltreGenel").hide();
            $("#<%=upPanelProje.ClientID%>").show();        
        }

        function BtnKlavuzClick() {
            $("#divYedekleme").hide();
            $("#divKlavuz").show();
            $("#<%=hKlavuzYedek01.ClientID%>").val("0");

            $("#<%=btnKlavuz.ClientID%>").css({
                "background-color": "gray",
                "color": "white",
                "font-weight": "bold"
            });
            $("#<%=btnYedekleme.ClientID%>").css({
                "background-color": "silver",
                "color": "black",
                "font-weight": "normal"
            });
          
        }

        function BtnYedeklemeClick() {
            $("#divKlavuz").hide();
            $("#divYedekleme").show();
            $("#<%=hKlavuzYedek01.ClientID%>").val("1");

            $("#<%=btnYedekleme.ClientID%>").css({
                "background-color": "gray",
                "color": "white",
                "font-weight": "bold"
            });
            $("#<%=btnKlavuz.ClientID%>").css({
                "background-color": "silver",
                "color": "black",
                "font-weight": "normal"
            });
        }

    </script>

</asp:Content>


<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <asp:Panel ID="AnaPanel" runat="server">

    <ajaxToolkit:ToolkitScriptManager runat="Server" EnablePartialRendering="true" EnableViewState="true" EnablePageMethods="true" ID="ScriptManager1" />

     <!-- KULLANICI GRIDVIEW  ------------------------- BEGIN -->
     <asp:UpdatePanel ID="upPanelKullanici" runat="server">
        <ContentTemplate>
            <asp:GridView ID="gridKullanici" CssClass="Grid" Width="940"  runat="server" 
                ShowHeaderWhenEmpty="True"
                AlternatingRowStyle-CssClass="alt" PagerStyle-CssClass="pgr" 
                OnRowEditing="gridKullanici_RowEditing" GridLines="Horizontal" 
                ondatabinding="gridKullanici_DataBinding"  ShowFooter="true"
                onpageindexchanging="gridKullanici_PageIndexChanging" 
                onrowcancelingedit="gridKullanici_RowCancelingEdit" 
                onrowdatabound="gridKullanici_RowDataBound" 
                onrowupdating="gridKullanici_RowUpdating"
                BackColor="White" BorderColor="#E7E7FF" BorderStyle="None" BorderWidth="1px" 
                CellPadding="3" AutoGenerateColumns="False" DataKeyNames="ID" 
                AllowPaging="True"  >
                <AlternatingRowStyle CssClass="alt" BackColor="#F7F7F7" />
                <Columns>
                       <asp:CommandField ControlStyle-Height="28px" ShowEditButton="True" ButtonType="Image" 
                            CancelImageUrl="~/Images/gridTool/cancel.png" EditImageUrl="~/Images/gridTool/edit.png" 
                            HeaderText=" &nbsp Düzenle &nbsp;  " UpdateImageUrl="~/Images/gridTool/accept.png" HeaderStyle-HorizontalAlign="Center" >
                            <HeaderStyle HorizontalAlign="Center" Width="70px" Wrap="false"/>
                            <ItemStyle HorizontalAlign="Center"   Wrap="False" /> 
                            <FooterStyle Height="28px" VerticalAlign="Top"  />
                            
                        </asp:CommandField>
                    
                        <asp:TemplateField ControlStyle-Width="160px" HeaderText="Adı Soyadı">
                            <ItemTemplate>
                                <asp:Label ID="labAdSoyad" runat="server" Text='<%# Eval("AdSoyad")%>'></asp:Label>
                            </ItemTemplate>
                            <EditItemTemplate>
                                <asp:TextBox ID="txtAdSoyad" Width="160px" CssClass="FilterDropDownCss" runat="server" MaxLength="50" Text='<%# Eval("AdSoyad")%>'></asp:TextBox>
                            </EditItemTemplate>
                            <FooterTemplate>       
                                <asp:TextBox ID="txtAdSoyad" Width="160px" CssClass="FilterDropDownCss"  MaxLength="50" runat="server"></asp:TextBox>
                            </FooterTemplate> 
                        </asp:TemplateField>

                        <asp:TemplateField ControlStyle-Width="100px" HeaderText="Kullanıcı Kodu">
                            <ItemTemplate>
                                <asp:Label ID="labKulKodu" runat="server" Text='<%# Eval("KulKodu")%>'></asp:Label>
                            </ItemTemplate>
                            <EditItemTemplate>
                                <asp:TextBox ID="txtKulKodu" Width="100px" CssClass="FilterDropDownCss" runat="server" MaxLength="5" Text='<%# Eval("KulKodu")%>'></asp:TextBox>
                            </EditItemTemplate>
                            <FooterTemplate>
                                <asp:TextBox ID="txtKulKodu" Width="100px" CssClass="FilterDropDownCss"  MaxLength="5" runat="server"></asp:TextBox>
                            </FooterTemplate> 
                        </asp:TemplateField>
                        
                        <asp:TemplateField ControlStyle-Width="100px" HeaderText="Parola">
                            <ItemTemplate>
                                <asp:Label ID="labParola" runat="server" Text='<%# Eval("Pass")%>'></asp:Label>
                            </ItemTemplate>
                            <EditItemTemplate>
                                <asp:TextBox ID="txtParola" Width="100px" CssClass="FilterDropDownCss"  runat="server" MaxLength="50" Text='<%# Eval("Pass")%>'></asp:TextBox>
                            </EditItemTemplate>
                            <FooterTemplate>
                                <asp:TextBox ID="txtParola" Width="100px" CssClass="FilterDropDownCss"  MaxLength="50" runat="server"></asp:TextBox>
                            </FooterTemplate> 
                        </asp:TemplateField>
                        <asp:TemplateField ControlStyle-Width="220px" HeaderText="E-Mail">
                            <ItemTemplate>
                                <asp:Label ID="labEmail" runat="server" Text='<%# Eval("Email")%>'></asp:Label>
                            </ItemTemplate>
                            <EditItemTemplate>
                                <asp:TextBox ID="txtEmail" Width="220px" CssClass="FilterDropDownCss" runat="server" MaxLength="80" Text='<%# Eval("Email")%>'></asp:TextBox>
                            </EditItemTemplate>
                            <FooterTemplate>
                                <asp:TextBox ID="txtEmail"  Width="220px" CssClass="FilterDropDownCss" MaxLength="80" runat="server"></asp:TextBox>
                            </FooterTemplate> 
                        </asp:TemplateField>
                    
                      <asp:TemplateField ControlStyle-Width="90px" HeaderText="Yetki" >
                            <ItemTemplate>
                                <asp:Label ID="labYetkiKod" runat="server" Text='<%# Eval("Aciklama") %>' />                             
                            </ItemTemplate>
                            <EditItemTemplate>
                                <asp:Label ID="labYetkiKod" runat="server" Text='<%# Eval("YetkiKod") %>' Visible="false" />
                                <asp:DropDownList ID="ddlYetkiKod" CssClass="FilterDropDownCss" Width="90px" runat="server"></asp:DropDownList>                                              
                            </EditItemTemplate>
                            <FooterTemplate>
                                <asp:Label ID="labYetkiKod" runat="server" Visible="false" />
                                <asp:DropDownList ID="ddlYetkiKod" CssClass="FilterDropDownCss" Width="90px"  runat="server"> </asp:DropDownList>
                            </FooterTemplate>
                        </asp:TemplateField>   

                       <asp:TemplateField ControlStyle-Width="130px" HeaderText="Firma" >
                            <ItemTemplate>
                                <asp:Label ID="labFirma" runat="server" Text='<%# Eval("Firma") %>' />                             
                            </ItemTemplate>
                            <EditItemTemplate>
                                <asp:Label ID="labFirma" runat="server" Text='<%# Eval("Firma") %>' Visible="false" />
                                <asp:DropDownList ID="ddlFirma" CssClass="FilterDropDownCss" Width="130px" runat="server"></asp:DropDownList>                                              
                            </EditItemTemplate>
                            <FooterTemplate>
                                <asp:Label ID="labFirma" runat="server" Visible="false" />
                                <asp:DropDownList ID="ddlFirma" CssClass="FilterDropDownCss" Width="130px"  runat="server"> </asp:DropDownList>
                            </FooterTemplate>
                         </asp:TemplateField>

                       


                     <asp:TemplateField ControlStyle-Height="28px" HeaderText="Sil / Ekle">
                            <ItemTemplate>
                                <asp:ImageButton ID="btnDelete" ImageUrl="~/Images/gridTool/delete.png" runat="server" CommandArgument='<%# Eval("ID")%>'
                                     OnClientClick="ShowMesajPopup(this); return false;" Text="Delete" OnClick="GridKullaniciDelete"></asp:ImageButton>
                            </ItemTemplate>
                            <FooterTemplate>
                                <asp:ImageButton ID="btnInsert" ImageUrl="~/Images/gridTool/add.png" runat="server" Text="Ekle" OnClick="GridKullaniciInsert" />
                            </FooterTemplate>
                            <HeaderStyle Width="70px" Wrap="false" />
                            <ItemStyle HorizontalAlign="Center" Width="70px" Wrap="False" />
                            <FooterStyle Height="28px" HorizontalAlign="Center" />
                           
                     </asp:TemplateField>
                
                </Columns>                       
                
                
                <EditRowStyle BorderStyle="Solid" BorderWidth="1px" />
                
                <FooterStyle BackColor="#B5C7DE" ForeColor="#4A3C8C" />
                <HeaderStyle BackColor="#4A3C8C" Font-Bold="True" ForeColor="#F7F7F7" />
                
                <PagerStyle CssClass="pgr" />
                <RowStyle BackColor="#E7E7FF" ForeColor="#4A3C8C" />
                <SelectedRowStyle BackColor="#738A9C" Font-Bold="True" ForeColor="#F7F7F7" />
                <SortedAscendingCellStyle BackColor="#F4F4FD" />
                <SortedAscendingHeaderStyle BackColor="#5A4C9D" />
                <SortedDescendingCellStyle BackColor="#D8D8F0" />
                <SortedDescendingHeaderStyle BackColor="#3E3277" />
            </asp:GridView>
                  
        </ContentTemplate>
        <Triggers>
             <asp:AsyncPostBackTrigger ControlID="gridKullanici" />
        </Triggers>
     </asp:UpdatePanel>
     <!-- KULLANICI GRIDVIEW  ------------------------- END  --->


     <!-- MÜŞTERİ GRIDVIEW  ------------------------- BEGIN -->
     <asp:UpdatePanel ID="upPanelMusteri" runat="server">
        <ContentTemplate>
            <asp:GridView ID="gridMusteri" CssClass="Grid" Width="860px" runat="server" ShowHeaderWhenEmpty="True"
                AlternatingRowStyle-CssClass="alt" PagerStyle-CssClass="pgr" 
                OnRowEditing="gridMusteri_RowEditing" GridLines="Horizontal" 
                ondatabinding="gridMusteri_DataBinding"  ShowFooter="true"
                onpageindexchanging="gridMusteri_PageIndexChanging" 
                onrowcancelingedit="gridMusteri_RowCancelingEdit" 
                onrowdatabound="gridMusteri_RowDataBound" 
                onrowupdating="gridMusteri_RowUpdating"
                BackColor="White" BorderColor="#E7E7FF" BorderStyle="None" BorderWidth="1px" 
                CellPadding="3" AutoGenerateColumns="False" DataKeyNames="ID" 
                AllowPaging="True" >
                <AlternatingRowStyle CssClass="alt" BackColor="#F7F7F7" />
                <Columns>
                       <asp:CommandField ControlStyle-Height="28px" ShowEditButton="True" ButtonType="Image" 
                            CancelImageUrl="~/Images/gridTool/cancel.png" EditImageUrl="~/Images/gridTool/edit.png" 
                            HeaderText=" &nbsp Düzenle &nbsp;  " UpdateImageUrl="~/Images/gridTool/accept.png" HeaderStyle-HorizontalAlign="Center" >
                            <HeaderStyle HorizontalAlign="Center" Width="70px" Wrap="false"/>
                            <ItemStyle HorizontalAlign="Center"   Wrap="False" /> 
                            <FooterStyle Height="28px" VerticalAlign="Top"  />                            
                        </asp:CommandField>                  
                        
                        <asp:TemplateField ControlStyle-Width="120px" HeaderText="Firma Kodu">
                            <ItemTemplate>
                                <asp:Label ID="labFirmaKodu" runat="server" Text='<%# Eval("Firma")%>'></asp:Label>
                            </ItemTemplate>
                            <EditItemTemplate>
                                <asp:TextBox ID="txtFirmaKodu" CssClass="FilterDropDownCss" runat="server" MaxLength="20" Text='<%# Eval("Firma")%>'></asp:TextBox>
                            </EditItemTemplate>
                            <FooterTemplate>
                                <asp:TextBox ID="txtFirmaKodu" CssClass="FilterDropDownCss" Width="120px"  MaxLength="20" runat="server"></asp:TextBox>
                            </FooterTemplate>                         
                            <ControlStyle Width="120px" /> 
                        </asp:TemplateField>
                        <asp:TemplateField ControlStyle-Width="180px" HeaderText="Firma Ünvan">
                            <ItemTemplate>
                                <asp:Label ID="labFirmaAdi" runat="server" Text='<%# Eval("Unvan")%>'></asp:Label>
                            </ItemTemplate>
                            <EditItemTemplate>
                                <asp:TextBox ID="txtFirmaAdi" CssClass="FilterDropDownCss" runat="server" MaxLength="80" Text='<%# Eval("Unvan")%>'></asp:TextBox>
                            </EditItemTemplate>
                            <FooterTemplate>
                                <asp:TextBox ID="txtFirmaAdi" CssClass="FilterDropDownCss" Width="180px"  MaxLength="80" runat="server"></asp:TextBox>
                            </FooterTemplate> 
                            <ControlStyle Width="180px" />
                        </asp:TemplateField>
                        <asp:TemplateField ControlStyle-Width="195px" HeaderText="Açıklama">
                            <ItemTemplate>
                                <asp:Label ID="labAciklama" runat="server" Text='<%# Eval("Aciklama")%>'></asp:Label>
                            </ItemTemplate>
                            <EditItemTemplate>
                                <asp:TextBox ID="txtAciklama" CssClass="FilterDropDownCss" Width="195px" runat="server" MaxLength="300" Text='<%# Eval("Aciklama")%>'></asp:TextBox>
                            </EditItemTemplate>
                            <FooterTemplate>
                                <asp:TextBox ID="txtAciklama" CssClass="FilterDropDownCss" Width="195px"  MaxLength="300" runat="server"></asp:TextBox>
                            </FooterTemplate> 
                            <ControlStyle Width="195px" />
                        </asp:TemplateField>
                         <asp:TemplateField ControlStyle-Width="75px" HeaderText="Tarih" >
                            <ItemTemplate>
                                <asp:Label ID="labTarih" runat="server" Text='<%# Eval("Tarih","{0:dd.MM.yyyy}") %>' />                             
                            </ItemTemplate>
                            <EditItemTemplate>
                                <asp:TextBox ID="txtTarih" CssClass="FilterDropDownCss"  runat="server" Text='<%# Eval("Tarih","{0:dd.MM.yyyy}") %>' />                                
                            </EditItemTemplate>
                            <FooterTemplate>
                                <asp:TextBox ID="txtTarih" CssClass="FilterDropDownCss"  runat="server" Width="75px"  />                       
                            </FooterTemplate>
                             <ControlStyle Width="75px" />
                        </asp:TemplateField>
                        
                       <asp:TemplateField ControlStyle-Width="75px" HeaderText="M.Kontrol" ItemStyle-HorizontalAlign="Center" FooterStyle-HorizontalAlign="Center"  >
                            <ItemTemplate>
                                <asp:CheckBox ID="chkMesaiKontrol" runat="server" Enabled="false"  Checked='<%# BoolConvert(Eval("MesaiKontrol")) %>'  />                             
                            </ItemTemplate>
                            <EditItemTemplate>
                               <asp:CheckBox ID="chkMesaiKontrol" runat="server"  Checked='<%# BoolConvert(Eval("MesaiKontrol")) %>'  />                                
                            </EditItemTemplate>
                            <FooterTemplate>
                               <asp:CheckBox ID="chkMesaiKontrol" runat="server"  Checked='<%# BoolConvert(Eval("MesaiKontrol")) %>'  />                       
                            </FooterTemplate>
                            
                        </asp:TemplateField>

                         <asp:TemplateField ControlStyle-Width="75px" HeaderText="Mesai Kota" >
                            <ItemTemplate>
                                <asp:Label ID="labMesaiKota" runat="server" Text='<%# Eval("MesaiKota") %>' />                             
                            </ItemTemplate>
                            <EditItemTemplate>
                                <asp:TextBox ID="txtMesaiKota" CssClass="FilterDropDownCss"  runat="server" Text='<%# Eval("MesaiKota") %>' />                                
                            </EditItemTemplate>
                            <FooterTemplate>
                                <asp:TextBox ID="txtMesaiKota" CssClass="FilterDropDownCss"  runat="server" Width="75px"  />                       
                            </FooterTemplate>
                        </asp:TemplateField>
                        

                        <asp:TemplateField ControlStyle-Height="28px" HeaderText="Sil / Ekle">
                            <ItemTemplate>
                                <asp:ImageButton ID="btnDelete" ImageUrl="~/Images/gridTool/delete.png" runat="server" CommandArgument='<%# Eval("ID")%>'
                                     OnClientClick="ShowMesajPopup(this); return false;" Text="Delete" OnClick="GridMusteriDelete"></asp:ImageButton>
                            </ItemTemplate>
                            <FooterTemplate>
                                <asp:ImageButton ID="btnInsert" ImageUrl="~/Images/gridTool/add.png" runat="server" Text="Ekle" OnClick="GridMusteriInsert" />
                            </FooterTemplate>
                            <HeaderStyle Width="70px" Wrap="false" />
                            <ItemStyle HorizontalAlign="Center" Width="70px" Wrap="False" />
                            <FooterStyle Height="28px" HorizontalAlign="Center" />                          
                        </asp:TemplateField>
                
                </Columns>                       
                
                
                <EditRowStyle BorderStyle="Solid" BorderWidth="1px" />
                
                <FooterStyle BackColor="#B5C7DE" ForeColor="#4A3C8C" />
                <HeaderStyle BackColor="#4A3C8C" Font-Bold="True" ForeColor="#F7F7F7" />
                
                <PagerStyle CssClass="pgr" />
                <RowStyle BackColor="#E7E7FF" ForeColor="#4A3C8C" />
                <SelectedRowStyle BackColor="#738A9C" Font-Bold="True" ForeColor="#F7F7F7" />
                <SortedAscendingCellStyle BackColor="#F4F4FD" />
                <SortedAscendingHeaderStyle BackColor="#5A4C9D" />
                <SortedDescendingCellStyle BackColor="#D8D8F0" />
                <SortedDescendingHeaderStyle BackColor="#3E3277" />
            </asp:GridView>
                  
        </ContentTemplate>
        <Triggers>
             <asp:AsyncPostBackTrigger ControlID="gridMusteri" />
        </Triggers>
    </asp:UpdatePanel>
     <!-- MÜŞTERİ GRIDVIEW  ------------------------- END  --->
   

     <!-- SORUMLU GRIDVIEW  ------------------------- BEGIN -->
     <asp:UpdatePanel ID="upPanelSorumlu" runat="server">
        <ContentTemplate>
            <asp:GridView ID="gridSorumlu" CssClass="Grid" Width="790px" runat="server" ShowHeaderWhenEmpty="True"
                AlternatingRowStyle-CssClass="alt" PagerStyle-CssClass="pgr" 
                OnRowEditing="gridSorumlu_RowEditing" GridLines="Horizontal" 
                ondatabinding="gridSorumlu_DataBinding"  ShowFooter="true"
                onpageindexchanging="gridSorumlu_PageIndexChanging" 
                onrowcancelingedit="gridSorumlu_RowCancelingEdit" 
                onrowdatabound="gridSorumlu_RowDataBound" 
                onrowupdating="gridSorumlu_RowUpdating"
                BackColor="White" BorderColor="#E7E7FF" BorderStyle="None" BorderWidth="1px" 
                CellPadding="3" AutoGenerateColumns="False" DataKeyNames="ID" 
                AllowPaging="True" >
                <AlternatingRowStyle CssClass="alt" BackColor="#F7F7F7" />
                <Columns>
                      <asp:CommandField ControlStyle-Height="28px" ShowEditButton="True" ButtonType="Image" 
                            CancelImageUrl="~/Images/gridTool/cancel.png" EditImageUrl="~/Images/gridTool/edit.png" 
                            HeaderText=" &nbsp Düzenle &nbsp;  " UpdateImageUrl="~/Images/gridTool/accept.png" HeaderStyle-HorizontalAlign="Center" >
                            <HeaderStyle HorizontalAlign="Center" Width="70px" Wrap="false"/>
                            <ItemStyle HorizontalAlign="Center"   Wrap="False" /> 
                            <FooterStyle Height="28px" VerticalAlign="Top"  />                            
                      </asp:CommandField>
                    
                       <asp:TemplateField ControlStyle-Width="120px" HeaderText="Firma" >
                            <ItemTemplate>
                                <asp:Label ID="labFirma" runat="server" Text='<%# Eval("Firma") %>' />                             
                            </ItemTemplate>
                            <EditItemTemplate>
                                 <asp:Label ID="labFirma" runat="server" Text='<%# Eval("Firma") %>' Visible="false" />
                                 <asp:DropDownList CssClass="FilterDropDownCss" ID="ddlFirma" Width="80px"  runat="server" ></asp:DropDownList>                                             
                            </EditItemTemplate>
                            <FooterTemplate>
                                 <asp:DropDownList CssClass="FilterDropDownCss" ID="ddlFirma" Width="120px"  runat="server"> </asp:DropDownList>
                            </FooterTemplate>
                        </asp:TemplateField>

                        <asp:TemplateField ControlStyle-Width="150px" HeaderText="Sorumlu">
                            <ItemTemplate>
                                <asp:Label ID="labSorumlu" runat="server" Text='<%# Eval("Unvan")%>'></asp:Label>
                            </ItemTemplate>
                            <EditItemTemplate>
                                <asp:TextBox ID="txtSorumlu" CssClass="FilterDropDownCss"  Width="150px" runat="server" MaxLength="50" Text='<%# Eval("Unvan")%>'></asp:TextBox>
                            </EditItemTemplate>
                            <FooterTemplate>       
                                <asp:TextBox ID="txtSorumlu" CssClass="FilterDropDownCss" Width="150px"  MaxLength="50" runat="server"></asp:TextBox>
                            </FooterTemplate> 
                        </asp:TemplateField>
                        <asp:TemplateField ControlStyle-Width="180px" HeaderText="E-Mail">
                            <ItemTemplate>
                                <asp:Label ID="labEmail" runat="server" Text='<%# Eval("Email")%>'></asp:Label>
                            </ItemTemplate>
                            <EditItemTemplate>
                                <asp:TextBox ID="txtEmail" CssClass="FilterDropDownCss" Width="180px" runat="server" MaxLength="80" Text='<%# Eval("Email")%>'></asp:TextBox>
                            </EditItemTemplate>
                            <FooterTemplate>       
                                <asp:TextBox ID="txtEmail" CssClass="FilterDropDownCss" Width="180px"  MaxLength="80" runat="server"></asp:TextBox>
                            </FooterTemplate> 
                        </asp:TemplateField>
                        <asp:TemplateField ControlStyle-Width="100px" HeaderText="Tel-1">
                            <ItemTemplate>
                                <asp:Label ID="labTel1" runat="server" Text='<%# Eval("Tel1")%>'></asp:Label>
                            </ItemTemplate>
                            <EditItemTemplate>
                                <asp:TextBox ID="txtTel1" CssClass="FilterDropDownCss" Width="100px" runat="server" MaxLength="15" Text='<%# Eval("Tel1")%>'></asp:TextBox>
                            </EditItemTemplate>
                            <FooterTemplate>       
                                <asp:TextBox ID="txtTel1" CssClass="FilterDropDownCss" Width="100px"  MaxLength="15" runat="server"></asp:TextBox>
                            </FooterTemplate> 
                        </asp:TemplateField>
                        <asp:TemplateField ControlStyle-Width="100px" HeaderText="Tel-2">
                            <ItemTemplate>
                                <asp:Label ID="labTel2"  runat="server" Text='<%# Eval("Tel2")%>'></asp:Label>
                            </ItemTemplate>
                            <EditItemTemplate>
                                <asp:TextBox ID="txtTel2" CssClass="FilterDropDownCss" Width="100px" runat="server" MaxLength="15" Text='<%# Eval("Tel2")%>'></asp:TextBox>
                            </EditItemTemplate>
                            <FooterTemplate>       
                                <asp:TextBox ID="txtTel2" CssClass="FilterDropDownCss" Width="100px"  MaxLength="15" runat="server"></asp:TextBox>
                            </FooterTemplate> 
                        </asp:TemplateField>

                      <asp:TemplateField ControlStyle-Height="28px" HeaderText="Sil / Ekle">
                            <ItemTemplate>
                                <asp:ImageButton ID="btnSorumluDelete" ImageUrl="~/Images/gridTool/delete.png" runat="server" CommandArgument='<%# Eval("ID")%>'
                                     OnClientClick="ShowMesajPopup(this); return false;" Text="Delete" OnClick="btnSorumluDelete_Click"></asp:ImageButton>
                            </ItemTemplate>
                            <FooterTemplate>
                                <asp:ImageButton ID="btnSorumluInsert" ImageUrl="~/Images/gridTool/add.png" runat="server" Text="Ekle" OnClick="btnSorumluInsert_Click" />
                            </FooterTemplate>
                            <HeaderStyle Width="60px" Wrap="false" />
                            <ItemStyle HorizontalAlign="Center" Width="70px" Wrap="False" />
                            <FooterStyle Height="28px" HorizontalAlign="Center" />                        
                      </asp:TemplateField>
                
                </Columns>                       
                
                
                <EditRowStyle BorderStyle="Solid" BorderWidth="1px" />
                
                <FooterStyle BackColor="#B5C7DE" ForeColor="#4A3C8C" />
                <HeaderStyle BackColor="#4A3C8C" Font-Bold="True" ForeColor="#F7F7F7" />
                
                <PagerStyle CssClass="pgr" />
                <RowStyle BackColor="#E7E7FF" ForeColor="#4A3C8C" />
                <SelectedRowStyle BackColor="#738A9C" Font-Bold="True" ForeColor="#F7F7F7" />
                <SortedAscendingCellStyle BackColor="#F4F4FD" />
                <SortedAscendingHeaderStyle BackColor="#5A4C9D" />
                <SortedDescendingCellStyle BackColor="#D8D8F0" />
                <SortedDescendingHeaderStyle BackColor="#3E3277" />
            </asp:GridView>
                  
        </ContentTemplate>
        <Triggers>
             <asp:AsyncPostBackTrigger ControlID="gridMusteri" />
        </Triggers>
     </asp:UpdatePanel>
     <!-- SORUMLU GRIDVIEW  ------------------------- END  --->
    

     <!-- PROJE GRIDVIEW  ------------------------- BEGIN -->
     <asp:UpdatePanel ID="upPanelProje" runat="server" style="display:block" >
        <ContentTemplate>
            <div id="divProjeHeader" style="width: 950px; padding-left: 5px; padding-top: 10px; height: 62px; background-color: #363670; color: white;">
                <asp:Label ID="Label1" Text="" Width="50px" runat="server" />
                <asp:Label ID="Label2" Text="Firma" Width="164px" runat="server" />
                <asp:Label ID="Label3" Text="Proje" Width="168px" runat="server" />
                <asp:Label ID="Label4" Text="Sorumlu" Width="100px" runat="server" />
                <asp:Label ID="Label5" Text="Karşı Sorumlu" Width="144px" runat="server" />             
            
                <div id="divFilterRow">
                    <asp:DropDownList ID="ddlfilterFirma" Style="margin-left: 50px; width:164px" CssClass="FilterDropDownCss" 
                        AutoPostBack="true" runat="server" OnSelectedIndexChanged="ddlfilterFirma_SelectedIndexChanged" />
                    <asp:DropDownList ID="ddlfilterProje" Style="margin-left: 2px; width:168px" CssClass="FilterDropDownCss" 
                        AutoPostBack="true" runat="server" OnSelectedIndexChanged="ddlfilterProje_SelectedIndexChanged" />
                    <asp:DropDownList ID="ddlfilterSorumlu" Style="margin-left: 2px; width:100px" CssClass="FilterDropDownCss" 
                        AutoPostBack="true" runat="server" OnSelectedIndexChanged="ddlfilterSorumlu_SelectedIndexChanged" />
                    <asp:TextBox ID="txtfilterKarsiSorumlu" runat="server" style="width:144px" AutoPostBack="true"
                        OnTextChanged="txtfilterKarsiSorumlu_TextChanged" CssClass="FilterDropDownCss" />

                    <asp:Label ID="Label6" Style="vertical-align:bottom" Text="M.Kontrol" Width="76px" runat="server" />   

                    <asp:Label ID="Label7" Style="vertical-align:bottom" Text="Mesai Kota" Width="84px" runat="server" />   

                </div>
            </div>
            <asp:GridView ID="gridProje" CssClass="Grid" Width="950px" runat="server"
                AlternatingRowStyle-CssClass="alt" PagerStyle-CssClass="pgr" 
                OnRowEditing="gridProje_RowEditing" GridLines="Horizontal" 
                ondatabinding="gridProje_DataBinding"  ShowFooter="true" ShowHeader="false"
                onpageindexchanging="gridProje_PageIndexChanging" 
                onrowcancelingedit="gridProje_RowCancelingEdit" 
                onrowdatabound="gridProje_RowDataBound" 
                onrowupdating="gridProje_RowUpdating"
                BackColor="White" BorderColor="#E7E7FF" BorderStyle="None" BorderWidth="1px" 
                CellPadding="3" AutoGenerateColumns="False" DataKeyNames="ID" 
                AllowPaging="True" OnRowCommand="gridProje_RowCommand"  >
                <AlternatingRowStyle CssClass="alt" BackColor="#F7F7F7" />
                <Columns>
                       <asp:CommandField ControlStyle-Height="28px" ShowEditButton="True" ButtonType="Image" 
                            CancelImageUrl="~/Images/gridTool/cancel.png" EditImageUrl="~/Images/gridTool/edit.png" 
                            HeaderText=" &nbsp Düzenle &nbsp;  " UpdateImageUrl="~/Images/gridTool/accept.png" HeaderStyle-HorizontalAlign="Center" >
                            <HeaderStyle HorizontalAlign="Center" Width="80px" Wrap="false"/>
                            <ItemStyle HorizontalAlign="Center"   Wrap="False" /> 
                            <FooterStyle Height="28px" Width="80px" VerticalAlign="Top"  />                       
                       </asp:CommandField>
                    
                        <asp:TemplateField ControlStyle-Width="160px" HeaderText="Firma" >
                            <ItemTemplate>
                                <asp:Label ID="labFirma" runat="server" Text='<%# Eval("Firma") %>' />                             
                            </ItemTemplate>
                            <EditItemTemplate>
                                <asp:Label ID="labFirma" runat="server" Text='<%# Eval("Firma") %>'  />                                                         
                            </EditItemTemplate>
                            <FooterTemplate>
                                <asp:DropDownList ID="ddlProjeFirma" CssClass="FilterDropDownCss" Width="160px" AutoPostBack="true" OnSelectedIndexChanged="ddlProjeFirma_SelectedIndexChanged" runat="server"></asp:DropDownList>
                            </FooterTemplate>
                        </asp:TemplateField>

                        <asp:TemplateField ControlStyle-Width="170px" HeaderText="Proje">
                            <ItemTemplate>
                                <asp:Label ID="labProje" runat="server" Text='<%# Eval("Proje")%>'></asp:Label>
                                <asp:HiddenField ID="hProjeID" runat="server" Value='<%#Eval("ID")%>' />
                            </ItemTemplate>
                            <EditItemTemplate>
                                <asp:TextBox ID="txtProje" Width="170px" CssClass="FilterDropDownCss" runat="server" MaxLength="20" Text='<%# Eval("Proje")%>'></asp:TextBox>
                            </EditItemTemplate>
                            <FooterTemplate>       
                                <asp:TextBox ID="txtProje" Width="170px"  CssClass="FilterDropDownCss" MaxLength="20" runat="server"></asp:TextBox>
                            </FooterTemplate> 
                        </asp:TemplateField>
                        
                        <asp:TemplateField ControlStyle-Width="100px" HeaderText="Sorumlu">
                            <ItemTemplate>
                                <asp:Label ID="labSorumlu" runat="server" Text='<%# Eval("Sorumlu")%>'></asp:Label>
                            </ItemTemplate>
                           <EditItemTemplate>
                                <asp:Label ID="labSorumlu" runat="server" Text='<%# Eval("Sorumlu") %>' Visible="false" />
                                <asp:DropDownList ID="ddlSorumlu" CssClass="FilterDropDownCss" Width="100px" runat="server"></asp:DropDownList>                                              
                            </EditItemTemplate>
                            <FooterTemplate>
                                <asp:DropDownList ID="ddlSorumlu" Width="100px" CssClass="FilterDropDownCss"  runat="server"> </asp:DropDownList>
                            </FooterTemplate> 
                        </asp:TemplateField>

                        <asp:TemplateField ControlStyle-Width="140px" HeaderText="Karşı Sorumlu">
                            <ItemTemplate>
                                <asp:Label ID="labKarsiSorumlu" runat="server" Text='<%# Eval("KarsiSorumlu")%>'></asp:Label>
                            </ItemTemplate>
                           <EditItemTemplate>
                                <asp:Label ID="labKarsiSorumlu" runat="server" Text='<%# Eval("KarsiSorumlu") %>' Visible="false" />
                                <asp:DropDownList ID="ddlKarsiSorumlu" CssClass="FilterDropDownCss" Width="140px" runat="server"></asp:DropDownList>                                              
                            </EditItemTemplate>
                            <FooterTemplate>
                                <asp:DropDownList ID="ddlKarsiSorumlu" CssClass="FilterDropDownCss" Width="140px"  runat="server"> </asp:DropDownList>
                            </FooterTemplate> 
                        </asp:TemplateField>

                        <asp:TemplateField ControlStyle-Width="75px" HeaderText="M.Kontrol" ItemStyle-HorizontalAlign="Center" FooterStyle-HorizontalAlign="Center"  >
                            <ItemTemplate>
                                <asp:CheckBox ID="chkMesaiKontrol" runat="server" Enabled="false"  Checked='<%# BoolConvert(Eval("MesaiKontrol")) %>'  />                             
                            </ItemTemplate>
                            <EditItemTemplate>
                               <asp:CheckBox ID="chkMesaiKontrol" runat="server"  Checked='<%# BoolConvert(Eval("MesaiKontrol")) %>'  />                                
                            </EditItemTemplate>
                            <FooterTemplate>
                               <asp:CheckBox ID="chkMesaiKontrol" runat="server"  Checked='<%# BoolConvert(Eval("MesaiKontrol")) %>'  />                       
                            </FooterTemplate>
                            
                        </asp:TemplateField>

                         <asp:TemplateField ControlStyle-Width="75px" HeaderText="Mesai Kota" >
                            <ItemTemplate>
                                <asp:Label ID="labMesaiKota" runat="server" Text='<%# Eval("MesaiKota") %>' />                             
                            </ItemTemplate>
                            <EditItemTemplate>
                                <asp:TextBox ID="txtMesaiKota" CssClass="FilterDropDownCss"  runat="server" Text='<%# Eval("MesaiKota") %>' />                                
                            </EditItemTemplate>
                            <FooterTemplate>
                                <asp:TextBox ID="txtMesaiKota" CssClass="FilterDropDownCss"  runat="server" Width="75px"  />                       
                            </FooterTemplate>
                        </asp:TemplateField>
                       
                        
                        <asp:TemplateField ControlStyle-Width="80px" HeaderText="Gözat">
                            <ItemTemplate>
                                <asp:Button ToolTip="Klavuz Dosyaları ve Yedekleme" Text="Gözat" ID="btnGozat" CssClass="btnGozatCss" 
                                              runat="server" CommandName="Select" OnClientClick="ProjeGozat(this)" />
                            </ItemTemplate> 
                          
                        </asp:TemplateField>
                        
                     <asp:TemplateField ControlStyle-Height="28px" HeaderText="Sil / Ekle">
                            <ItemTemplate>
                                <asp:ImageButton ID="btnProjeDelete" ImageUrl="~/Images/gridTool/delete.png" runat="server" CommandArgument='<%# Eval("ID")%>'
                                     OnClientClick="ShowMesajPopup(this); return false;" Text="Delete" OnClick="btnProjeDelete_Click"></asp:ImageButton>
                            </ItemTemplate>
                            <FooterTemplate>
                                <asp:ImageButton ID="btnProjeInsert" ImageUrl="~/Images/gridTool/add.png" runat="server" Text="Ekle" OnClick="btnProjeInsert_Click" />
                            </FooterTemplate>
                            <HeaderStyle Width="70px" Wrap="false" />
                            <ItemStyle HorizontalAlign="Center" Width="70px" Wrap="False" />
                            <FooterStyle Height="28px" Width="70px" HorizontalAlign="Center" />                      
                     </asp:TemplateField>
                
                </Columns>                       
                
                
                <EditRowStyle BorderStyle="Solid" BorderWidth="1px" />
                
                <FooterStyle BackColor="#B5C7DE" ForeColor="#4A3C8C" />
                <HeaderStyle BackColor="#4A3C8C" CssClass="ProjeHeaderCss" Font-Bold="True" ForeColor="#F7F7F7" />
                
                <PagerStyle CssClass="pgr" />
                <RowStyle BackColor="#E7E7FF" ForeColor="#4A3C8C" />
                <SelectedRowStyle BackColor="#738A9C" Font-Bold="True" ForeColor="#F7F7F7" />
                <SortedAscendingCellStyle BackColor="#F4F4FD" />
                <SortedAscendingHeaderStyle BackColor="#5A4C9D" />
                <SortedDescendingCellStyle BackColor="#D8D8F0" />
                <SortedDescendingHeaderStyle BackColor="#3E3277" />
            </asp:GridView>
                  
        </ContentTemplate>
        <Triggers>
             <asp:AsyncPostBackTrigger ControlID="gridProje" />
          
        </Triggers>
     </asp:UpdatePanel>
     <!-- PROJE GRIDVIEW  ------------------------- END  --->
     

     <!-- PROJE FORM GRIDVIEW  ------------------------- BEGIN -->
     <asp:UpdatePanel ID="upPanelProjeForm" runat="server">
        <ContentTemplate>
            <asp:GridView ID="gridProjeForm" CssClass="Grid"  Width="800px" runat="server" ShowHeaderWhenEmpty="True"
                AlternatingRowStyle-CssClass="alt" PagerStyle-CssClass="pgr" 
                GridLines="Horizontal" 
                ondatabinding="gridProjeForm_DataBinding"  ShowFooter="false"
                onpageindexchanging="gridProjeForm_PageIndexChanging"                
                OnRowEditing="gridProjeForm_RowEditing"               
                onrowcancelingedit="gridProjeForm_RowCancelingEdit" 
                onrowupdating="gridProjeForm_RowUpdating"
                OnRowDataBound="gridProjeForm_RowDataBound"
                BackColor="White" BorderColor="#E7E7FF" BorderStyle="None" BorderWidth="1px" 
                CellPadding="3" AutoGenerateColumns="False" DataKeyNames="ID" 
                AllowPaging="True" >
                <AlternatingRowStyle CssClass="alt" BackColor="#F7F7F7" />
                <Columns>
                      <asp:CommandField ControlStyle-Height="28px" ShowEditButton="True" ButtonType="Image" 
                            CancelImageUrl="~/Images/gridTool/cancel.png" EditImageUrl="~/Images/gridTool/edit.png" 
                            HeaderText=" &nbsp Düzenle &nbsp;  " UpdateImageUrl="~/Images/gridTool/accept.png" HeaderStyle-HorizontalAlign="Center" >
                            <HeaderStyle HorizontalAlign="Center" Width="90px" Wrap="false"/>
                            <ItemStyle HorizontalAlign="Center"   Wrap="False" /> 
                            <FooterStyle Height="28px" VerticalAlign="Top"  />
                            
                        </asp:CommandField>

                        <asp:TemplateField  HeaderText="PID (Hide)" FooterStyle-CssClass="hideKolon" ItemStyle-CssClass="hideKolon" HeaderStyle-CssClass="hideKolon" ControlStyle-CssClass="hideKolon" >
                            <ItemTemplate>
                                <asp:Label ID="labPID" runat="server" Text='<%# Eval("PID") %>' />                           
                            </ItemTemplate>
                        </asp:TemplateField>
                   
                        <asp:TemplateField ControlStyle-Width="210px" HeaderText="Firma" >
                            <ItemTemplate>
                                <asp:Label ID="lblFirma" runat="server" Text='<%# Eval("Firma") %>' />                             
                            </ItemTemplate>
                            <EditItemTemplate>
                                <asp:Label ID="lblFirma" runat="server" Text='<%# Eval("Firma") %>' />                                                 
                            </EditItemTemplate>
                            <FooterTemplate>
                                <asp:Label ID="lblFirma" runat="server" Text='<%# Eval("Firma") %>' Visible="false" />
                                <asp:DropDownList ID="ddlFirma" CssClass="FilterDropDownCss" Width="210px" runat="server">
                                </asp:DropDownList>
                            </FooterTemplate>
                            
                        </asp:TemplateField>

                        <asp:TemplateField ControlStyle-Width="220px" HeaderText="Proje Adı">
                            <ItemTemplate>
                                <asp:Label ID="labProje" runat="server" Text='<%# Eval("Proje")%>'></asp:Label>
                            </ItemTemplate>
                            <EditItemTemplate>
                                <asp:Label ID="labProje" runat="server" Text='<%# Eval("Proje")%>' Visible='<%# Eval("PID").ToString() != "0" %>'></asp:Label>
                                <asp:TextBox ID="txtProje" CssClass="FilterDropDownCss" runat="server" Width="220px" MaxLength="20" Text='<%# Eval("Proje")%>' Visible='<%# Eval("PID").ToString() == "0" %>'></asp:TextBox>
                            </EditItemTemplate>
                            <FooterTemplate>
                                <asp:TextBox ID="txtProje" CssClass="FilterDropDownCss" Width="220px"  MaxLength="20" runat="server"></asp:TextBox>
                            </FooterTemplate>                       
                         
                        </asp:TemplateField>

                         <asp:TemplateField ControlStyle-Width="280px" HeaderText="Form">
                            <ItemTemplate>
                                <asp:Label ID="labForm" runat="server" Text='<%# Eval("Form")%>'></asp:Label>
                            </ItemTemplate>
                            <EditItemTemplate>
                                <asp:TextBox ID="txtForm" CssClass="FilterDropDownCss" runat="server" Width="280px" MaxLength="300" Text='<%# Eval("Form")%>' Visible='<%# Eval("PID").ToString() != "0" %>' ></asp:TextBox>                           
                            </EditItemTemplate>
                            <FooterTemplate>
                                <asp:TextBox ID="txtForm" CssClass="FilterDropDownCss" Width="280px"  MaxLength="300" runat="server"></asp:TextBox>
                            </FooterTemplate> 
                        
                        </asp:TemplateField>                   
                
                </Columns>                       
                         
                <EditRowStyle BorderStyle="Solid" BorderWidth="1px" />
                
                <FooterStyle BackColor="#B5C7DE" ForeColor="#4A3C8C" />
                <HeaderStyle BackColor="#4A3C8C" Font-Bold="True" ForeColor="#F7F7F7" />
                
                <PagerStyle CssClass="pgr" />
                <RowStyle BackColor="#E7E7FF" ForeColor="#4A3C8C" />
                <SelectedRowStyle BackColor="#738A9C" Font-Bold="True" ForeColor="#F7F7F7" />
                <SortedAscendingCellStyle BackColor="#F4F4FD" />
                <SortedAscendingHeaderStyle BackColor="#5A4C9D" />
                <SortedDescendingCellStyle BackColor="#D8D8F0" />
                <SortedDescendingHeaderStyle BackColor="#3E3277" />
            </asp:GridView>
                  
        </ContentTemplate>
        <Triggers>
             <asp:AsyncPostBackTrigger ControlID="gridProje" />
        </Triggers>
    </asp:UpdatePanel>
     <!-- PROJE FORM GRIDVIEW  ------------------------- END  ---->


     <!-- PROJEFORM POPUP EDİT FORM   ----------------------------- BEGIN  -->
     <ajaxToolkit:ModalPopupExtender ID="mPopup" runat="server" BehaviorID="MPE" 
                TargetControlID="btnPopupAc" PopupControlID="popupPanel" BackgroundCssClass="modalBackground"
                DropShadow="True" />
     <asp:Button ID="btnPopupAc" runat="server" Style="display: none" Text="Popup Açmak İçin Şart" />
     <asp:Panel ID="popupPanel" runat="server" CssClass="editPopupProjeTanim" Style="display: none">
            <asp:UpdatePanel ID="upPanelProjeFormEdit" runat="server">
                <ContentTemplate>
                    <div>
                        <table border="0" cellpadding="4px" class="tableCls" cellspacing="0" style="margin-top: 8px">
                            <tr>
                                <td class="tdbaslik">Firma
                                </td>
                                <td>
                                    <asp:DropDownList ID="ddlFirma" Width="260px" CssClass="form-control" data-live-search="true" data-width="260px" runat="server"
                                        AutoPostBack="true" OnSelectedIndexChanged="ddlFirma_SelectedIndexChanged">
                                    </asp:DropDownList>
                                </td>
                                <td style="width: 50px"></td>
                            </tr>
                            <tr>
                                <td class="tdbaslik">Proje
                                </td>
                                <td>
                                    <div class="divtxtProje" style="display: none">
                                        <asp:TextBox ID="txtProje" Width="260px" CssClass="form-control" runat="server"></asp:TextBox>
                                    </div>
                                    <div class="divddlProje">
                                        <asp:DropDownList ID="ddlProje" runat="server" CssClass="form-control" data-live-search="true" data-width="260px" Width="260px"
                                            AutoPostBack="true" OnSelectedIndexChanged="ddlProje_SelectedIndexChanged">
                                        </asp:DropDownList>
                                    </div>
                                </td>
                                <td style="width: 60px; float: right; padding-top: 5px">
                                    <input type="checkbox" class="chkProjectCls" id="chkProjectNew" onchange="chkProjectCheck()" runat="server" />
                                    <span>Yeni</span>
                                </td>
                            </tr>
                            <tr>
                                <td class="tdbaslik">Form
                                </td>
                                <td>
                                    <div class="divtxtForm">
                                        <asp:TextBox ID="txtForm" Width="260px" CssClass="form-control" runat="server"></asp:TextBox>
                                    </div>
                                    <div class="divddlForm" style="display: none">
                                        <asp:DropDownList ID="ddlForm" runat="server" CssClass="form-control" data-live-search="true" data-width="260px" Width="260px">
                                        </asp:DropDownList>
                                    </div>

                                </td>
                                <td>
                                    <input type="checkbox" class="chkFormCls" id="chkFormNew" onchange="chkFormCheck()" runat="server" />
                                    <span>Yeni</span>
                                </td>
                            </tr>
                            <tr>
                                <td>&nbsp;</td>
                                <td>

                                    <asp:Button ID="btnProjeFormKaydet" runat="server" Text="Kaydet"
                                        data-original-title="Proje-Form Kaydet" rel="tooltip" type="button"
                                        class="btn btn-primary m-b-10" data-toggle="tooltip" data-placement="bottom" Width="100px"
                                        OnClick="btnProjeFormKaydet_Click" Style="margin-left: 20px; float: right" />

                                    <asp:Button ID="btnProjeFormSil" runat="server" Text="Sil"
                                        data-original-title="Proje-Form Kaydet" rel="tooltip" type="button"
                                        class="btn btn-danger" data-toggle="tooltip" data-placement="bottom" Width="100px"
                                        OnClick="btnProjeFormSil_Click" OnClientClick="ShowMesajPopup(this); return false;" Style="float: right" />

                                </td>
                                <td></td>
                            </tr>

                        </table>

                        <asp:Button ID="btnPopupKapat" runat="server" Text=" x " Font-Size="22px" data-original-title="Kapat" rel="tooltip"
                            type="button" class="btn btn-primary m-b-10" data-toggle="tooltip" data-placement="bottom" title=""
                            CssClass="btn btn-primary m-b-10" Width="30px" Height="30px" Style="position: absolute; padding: 0px; top:0px; right:0px"
                            OnClick="btnPopupKapat_Click" OnClientClick="PopupPanelGizle()" />

                    </div>
                </ContentTemplate>
                <Triggers>
                    <asp:AsyncPostBackTrigger ControlID="ddlFirma" EventName="SelectedIndexChanged" />
                    <asp:AsyncPostBackTrigger ControlID="ddlProje" EventName="SelectedIndexChanged" />
                    <asp:AsyncPostBackTrigger ControlID="btnPopupKapat" EventName="Click" />
                </Triggers>
            </asp:UpdatePanel>


            <!-- POPUP MESAJ FORM KISMI  INCEPTION:) ----------------------- BEGIN -->
            <asp:Button ID="btnMesajShow" runat="server" Text="SMP" Style="display: none" />
            <ajaxToolkit:ModalPopupExtender ID="mesajPopup2" runat="server" BehaviorID="mpeMesaj2"
                PopupControlID="panelConfirmPopup" TargetControlID="btnMesajShow" OkControlID="btnYes2" OnOkScript="OkClick();" CancelControlID="btnNo2" OnCancelScript="CancelClick();"
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
                    <asp:Button ID="btnYes2" runat="server" Text="Evet" CssClass="yes" />
                    <asp:Button ID="btnNo2" runat="server" Text="Hayır" CssClass="no" />
                </div>
            </asp:Panel>
            <!-- POPUP MESAJ FORM KISMI   ----------------------- END -->
               
     </asp:Panel>        
     <!-- PROJEFORM POPUP EDİT FORM   ------------------------------ END -->


  

    <!-- POPUP MESAJ FORM KISMI  ----------------------- BEGIN -->
    <asp:Button ID="btnShow" runat="server" Text="SMP" Style="display: none" />
    <ajaxToolkit:ModalPopupExtender ID="mesajPopup" runat="server" BehaviorID="mpeMesaj"
        PopupControlID="pnlPopup" TargetControlID="btnShow" OkControlID="btnYes" OnOkScript="OkClick();"
        CancelControlID="btnNo" OnCancelScript="CancelClick();" BackgroundCssClass="modalBackground2">
    </ajaxToolkit:ModalPopupExtender>
    <asp:Panel ID="pnlPopup" runat="server" CssClass="modalMesajPopup" Style="display: none">
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

    <asp:TextBox ID="txtPageType" runat="server" Style="display:none" CssClass="PageTypeCls"></asp:TextBox>


    <asp:UpdatePanel ID="upPanelTimer" runat="server">
        <ContentTemplate>
           <asp:Timer ID="timerHelper" runat="server" Interval="100" ontick="timerHelper_Tick"></asp:Timer>
                       
        </ContentTemplate>
        <Triggers>
            <asp:AsyncPostBackTrigger ControlID="timerHelper" EventName="Tick" />
            <asp:AsyncPostBackTrigger ControlID="btnProjeFormKaydet" EventName="Click" />
            <asp:AsyncPostBackTrigger ControlID="btnGeriDon"  />
            <asp:AsyncPostBackTrigger ControlID="btnKlavuz"  />
            <asp:AsyncPostBackTrigger ControlID="btnYedekleme"  />
        </Triggers>
    </asp:UpdatePanel>


   
    <div id="divFiltreGenel" style="width:920px; height:590px; background-color:silver; padding:10px; margin-top:-6px; display:none">
        <asp:Button ID="btnGeriDon" OnClientClick="GridProjeyeDon()" Text="Geri Dön" CssClass="btnGeriDonCss" runat="server" />
        <div id="divProjeDetay">
            <div style="background-color:#606080; color:white; height:30px;">
                <asp:Label  Style="line-height: 32px; margin-left: 10px;  font-weight: bold" Text="ID :" runat="server" />
                <asp:Label ID="labProID"  Style="line-height: 32px; margin-left: 4px; margin-right: 40px; font-weight: bold"  runat="server" />
                <asp:Label  Style="line-height: 32px; margin-left: 10px;  font-weight: bold" Text="Firma :" runat="server" />
                <asp:Label ID="labFirma"  Style="line-height: 32px; margin-left: 4px; margin-right: 50px; font-weight: bold"  runat="server" />
                <asp:Label  Style="line-height: 32px; margin-left: 10px;  font-weight: bold" Text="Proje :" runat="server" />
                <asp:Label ID="labProje"  Style="line-height: 32px; margin-left: 4px; margin-right: 50px; font-weight: bold"  runat="server" />
                <asp:HiddenField ID="hProID" runat="server" />
            </div>
            <asp:Button ID="btnKlavuz" OnClientClick="BtnKlavuzClick()"  style="background-image:url('Images/docedit.png');" 
                        CssClass="btnKlavuzYedeklemeCss" runat="server" Text="Klavuz ve Dökümanlar" />
            <asp:Button ID="btnYedekleme" OnClientClick="BtnYedeklemeClick()"  style="background-image:url('Images/backupfile.png'); margin-left:-4px;"
                        CssClass="btnKlavuzYedeklemeCss" runat="server" Text="Yedekleme İşlemleri" />
            
            <div id="divKlavuz" style="width:890px; margin-top:2px; height:420px; background-color:#A9A9A9; border-right:1px solid gray; overflow-y:scroll">
                <table id="tableKlavuz" class="tableKlavuzYedekleme">
                    <tr>
                        <th style="width:60px">ID</th>
                        <th style="width:560px">Dosya Adı</th>
                        <th style="width:100px">Kaydeden</th>
                        <th style="width:160px">Kayıt Tarih</th>                 
                    </tr>
                                        
                </table>

                
            </div>
            
            <div id="divYedekleme" style="width:890px;  margin-top:2px; height:420px; background-color:#A9A9A9; border-right:1px solid gray; overflow-y:scroll; display:none">
                <table id="tableYedekleme" class="tableKlavuzYedekleme">
                    <tr>
                        <th style="width:60px">ID</th>
                        <th style="width:560px">Backup Dosyası</th>
                        <th style="width:100px">Kaydeden</th>
                        <th style="width:160px">Kayıt Tarih</th>                 
                    </tr>
                                        
                </table>
            </div>


            <div style="height: 40px;">
                <ajaxToolkit:AsyncFileUpload UploaderStyle="Traditional" ThrobberID="loadImage"
                    ID="AsyncFileUpload_KlavuzYedekleme" OnClientUploadError="uploadError"
                    OnClientUploadComplete="uploadComplete" OnClientUploadStarted="uploadStarted" 
                    Font-Size="14px" Font-Bold="true" Height="26px"
                    runat="server" Width="400px"
                    OnUploadedComplete="AsyncFileUpload_KlavuzYedekleme_UploadedComplete"
                    Style="margin-top: 10px; margin-left: 10px; float: left" />
                <asp:Image ImageUrl="~/Images/loader.gif" Height="22px" Width="22px" Style="vertical-align: -20px; margin-left: 10px" ID="loadImage" runat="server" />
                <asp:Label ID="labMesaj" Style="margin-left: 5px; vertical-align: -14px" runat="server"></asp:Label>
            </div>
            

            <asp:HiddenField ID="hKlavuzYedek01" Value="0" runat="server" />
                  
        </div>
    </div>

     <!-- LITERAL MESAJ ------------------------  BEGIN  ---->
     <asp:UpdatePanel ID="upPanelMesaj" runat="server">
        <ContentTemplate>
            <div class="row" id="panelbilgi" style="width:700px; padding:0px; margin-left:30px" >
                <div>
                    <div class="panel panel-default" style="background-color:#A9A9A9; margin:2px auto; overflow:hidden" >
                        <asp:Panel ID="pnlHata" runat="server" Visible="false" CssClass="panelInfo" >
                            <div class="alert alert-danger fade in" style="margin: 5px auto; width:690px; overflow:hidden" >
                                <button type="button" id="btnHataClose" onclick="panelBilgiKapan()" class="close" data-dismiss="alert" aria-hidden="true">
                                    &times;</button>
                                <asp:Literal ID="lblHata" runat="server"></asp:Literal>
                            </div>
                        </asp:Panel>
                        <asp:Panel ID="pnlBasarili" runat="server" Visible="false" CssClass="panelInfo">
                            <div class="alert alert-success fade in" style="margin: 5px auto; width:690px; overflow:hidden ">
                                <button type="button" class="close" id="btnBasariClose" onclick="panelBilgiKapan()" data-dismiss="alert" aria-hidden="true">
                                    &times;</button> 
                                <asp:Literal ID="lblBasarili" runat="server"></asp:Literal>
                            </div>
                        </asp:Panel>
                    </div>
                </div>
            </div>
        </ContentTemplate>
        <Triggers>
            <asp:AsyncPostBackTrigger ControlID="gridKullanici" EventName="DataBinding" />
        </Triggers>
    </asp:UpdatePanel>
     <!-- LITERAL MESAJ ------------------------  END    ---->
    
   

   
   </asp:Panel>

</asp:Content>
