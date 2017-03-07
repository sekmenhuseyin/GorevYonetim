<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Calismalar.aspx.cs" Inherits="GorevYonetim.Calismalar" EnableEventValidation="false" %>
<%@ Register  Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="ajaxToolkit" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
      
    <link rel="Stylesheet" href="Styles/GridStyle.css" />
    <link rel="Stylesheet" href="Styles/Gorev.css" />
    <style type="text/css">
        body
        {
            font-family: Arial;
            font-size: 10pt;
        }
        .FilterDropDownCss
        {
            width:180px;
            line-height:26px;
            font-family:Arial,Tahoma;
            font-size:10pt;
            font-weight:bold;
            border-radius:4px;
            color:black;
            height:28px;
            padding-left:2px;
            border:1px solid #333;
        }
    </style>
    <script  type="text/javascript" src="Scripts/jquery-1.4.1.js"></script>
   
    <script type="text/javascript">

        $(function () {
            $(document).keydown(function (e) {
                if (e.which == 112) {  // F1 
                    var deger = $("#<%=popupDurbunPanel.ClientID%>").css("display");
                    if (deger == "none")
                        ShowPopup_Durbun();
                    return false;
                }
                else if (e.which == 27) { //Esc
                    PopupPanelleriGizle();
                    return false;
                }
            });

            $("#<%=txtcSure.ClientID%>").keypress(function (e) {
                if (e.which != 8 && e.which != 0 && (e.which < 48 || e.which > 57)) {
                    //display error message
                    $("#hataMessage").html("Sadece rakam").show().fadeOut("slow");
                    return false;
                }
            });

            /// Tarih tipli textboxlara Takvim Popupı ekliyorum
            $(".txtTakvim,#<%=txtfilterTarih1.ClientID%>").live("focus", function () {
                $(this).datepicker({
                    weekStart: 1,
                    showOn: 'button',
                    dateFormat: "dd.mm.yyyy",
                });
            });

            /// Bootstrapla Ajax Toolkit çakışmasından kaynaklanan sorun düzelsin diye..
            $("#<%=ddlDFirma.ClientID%>").val("-").change(); 
        });
   
       
         
        function panelBilgiKapan() {
            $("#panelbilgi").css("display", "none");
        }

        function panelBilgiAc() {
            $("#panelbilgi").css("display", "block");
        }

        function ShowPopup_Durbun() {
            $("#<%=popupDurbunPanel.ClientID%>").css("display", "block");
            $find("MPEDurbun").show();
        }

        function ShowPopup_YeniCalisma(selRowInfo) {
            $("#popupCalismaPanel").css("display", "block");
            var row = selRowInfo.parentNode.parentNode;

            var ID = row.cells[1].innerText.trim();
            var kaydeden = row.cells[2].innerText.trim();
            var sorumlu = row.cells[3].innerText.trim();
            var firma = row.cells[4].innerText.trim();
            var proje = row.cells[5].innerText.trim();
            var form = row.cells[6].innerText.trim();
            var gorev = row.cells[7].innerText.trim();
            var tarih1 = row.cells[8].innerText.trim();
            var sure = row.cells[9].innerText.trim();
            var aciklama = row.cells[10].innerText.trim();
            var calisma = row.cells[11].innerText.trim();
          

            $("#<%=hfCalismaID.ClientID%>").val(ID);
            $("#<%=txtcSorumlu.ClientID%>").val(sorumlu);
            $("#<%=txtcFirma.ClientID%>").val(firma);
            $("#<%=txtcProje.ClientID%>").val(proje);
            $("#<%=txtcForm.ClientID%>").val(form);
            $("#<%=txtcGorev.ClientID%>").val(gorev);
            $("#<%=txtcTarih.ClientID%>").val(tarih1);
            $("#<%=txtcSure.ClientID%>").val(sure);
            $("#<%=txtcAciklama.ClientID%>").val(aciklama);
            $("#<%=txtcCalisma.ClientID%>").val(calisma);
            $("#<%=txtcKaydeden.ClientID%>").val(kaydeden);
         
            $("#<%=txtcSorumlu.ClientID%>").prop("readonly", true);

            $find("MPECalisma").show();
        
        }

        function PopupPanelleriGizle() {
            $find("MPEDurbun").hide();
            $(".PopupDurbun").css("display", "none");
        }

        function ToplamKayit(adet) {
            var ifade = "Bulunan Kayıt Sayısı : " + adet;
            $("#<%=labToplamKayit.ClientID%>").text(ifade);
        }
        
             
        //// Popup MesajBoxın Evetemi Hayıra mı tıklandığını almak için
        var _source;
        var _popup;
        function ShowMesajPopup(source) {
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

    </script>
 
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

     <ajaxToolkit:ToolkitScriptManager runat="Server"  ID="ScriptManager1" />

      <!-- ÇALIŞMA GRIDVIEW  ------------------------- BEGIN -->
     <asp:UpdatePanel ID="upPanelCalisma" runat="server">
        <ContentTemplate>
              <div id="divProjeHeader" style="width: 1075px; padding-left: 5px; padding-top:8px; background-color: #363670; color: white;">

                <div style="height:12px">
                    <asp:Label  Text="Kaydeden" Style="margin-left: 54px" Width="66px" runat="server" />
                    <asp:Label Text="Sorumlu" Width="66px" runat="server" />
                    <asp:Label  Text="Firma" Width="118px" runat="server" />
                    <asp:Label  Text="Proje" Width="130px" runat="server" />
                    <asp:Label  Text="Form" Width="152px" runat="server" />
                    <asp:Label  Text="Görev" Width="300px" runat="server" />
                    <asp:Label  Text="Ç.Tarih" Width="80px" runat="server" />
                    <asp:Label  Text="Süre" Width="74px" runat="server" />
                </div>
                           
                <div id="divFilterRow">
                    <asp:CheckBox ID="chkTumKayitlarda" Text="Tümü" runat="server" ToolTip="Tüm Kayıtları Listele"
                                  AutoPostBack="true"    />
                    <asp:DropDownList ID="ddlfilterKaydeden" Style="margin-left: 4px; margin-top:4px; margin-bottom:1px; width:64px" CssClass="FilterDropDownCss" 
                        AutoPostBack="true" runat="server" OnSelectedIndexChanged="ddlfilterSorumlu_SelectedIndexChanged" />
                    <asp:DropDownList ID="ddlfilterSorumlu" Style="width:64px" CssClass="FilterDropDownCss" 
                        AutoPostBack="true" runat="server" OnSelectedIndexChanged="ddlfilterSorumlu_SelectedIndexChanged" />

                    <asp:DropDownList ID="ddlfilterFirma" Style="width:118px" CssClass="FilterDropDownCss" 
                        AutoPostBack="true" runat="server" OnSelectedIndexChanged="ddlfilterFirma_SelectedIndexChanged" />
                    <asp:DropDownList ID="ddlfilterProje" Style="width:130px" CssClass="FilterDropDownCss" 
                        AutoPostBack="true" runat="server" OnSelectedIndexChanged="ddlfilterProje_SelectedIndexChanged" />
                   
                    <asp:DropDownList ID="ddlfilterForm" Style="width:152px" CssClass="FilterDropDownCss"  
                         AutoPostBack="true" runat="server" OnSelectedIndexChanged="ddlfilterForm_SelectedIndexChanged" />
                    
                    <asp:TextBox ID="txtfilterGorev" Style="width:300px" CssClass="FilterDropDownCss" 
                        AutoPostBack="true"  runat="server" OnTextChanged="txtfilterGorev_TextChanged" />

                    <asp:TextBox ID="txtfilterTarih1" Style="width:82px" CssClass="FilterDropDownCss" 
                        AutoPostBack="true"  runat="server" OnTextChanged="txtfilterTarih1_TextChanged" />

                     <asp:TextBox ID="txtCalismaSure" Style="width:74px" CssClass="FilterDropDownCss" 
                        AutoPostBack="true"  runat="server" OnTextChanged="txtCalismaSure_TextChanged" />
                   
                </div>
            </div>
             <asp:GridView ID="gridCalisma" CssClass="Grid"  Width="1075px" runat="server" 
                AlternatingRowStyle-CssClass="alt" PagerStyle-CssClass="pgr" 
                GridLines="Horizontal" ondatabinding="gridCalisma_DataBinding" ShowHeader="false"  ShowFooter="true"
                onpageindexchanging="gridCalisma_PageIndexChanging"             
                BackColor="White" BorderColor="#E7E7FF" BorderStyle="None" BorderWidth="1px" 
                CellPadding="3" AutoGenerateColumns="False" DataKeyNames="ID" 
                AllowPaging="false" PageSize="20"   >
                <AlternatingRowStyle CssClass="alt" BackColor="#F7F7F7"/>
                <Columns>
                        <asp:TemplateField ControlStyle-Height="18px" HeaderText="Düzenle">
                            <ItemTemplate>
                                <asp:ImageButton ID="btnDuzenle" ImageUrl="~/Images/gridTool/edit24.png" runat="server" CommandArgument='<%# Container.DataItemIndex %>'
                                   Text="Düzenle" OnClick="btnDuzenle_Click" CommandName="Select" OnClientClick="ShowPopup_YeniCalisma(this)"></asp:ImageButton>
                            </ItemTemplate>   
                                                                    
                            <HeaderStyle Width="60px" Wrap="false" />
                            <ItemStyle HorizontalAlign="Center" Width="60px" Wrap="False" />           
                        </asp:TemplateField>

                        <asp:TemplateField ControlStyle-CssClass="hideKolon" ItemStyle-CssClass="hideKolon" HeaderStyle-CssClass="hideKolon" FooterStyle-CssClass="hideKolon">
                            <ItemTemplate>
                                <asp:Label ID="labID" runat="server" Text='<%# Eval("ID") %>' ></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>

                        <asp:TemplateField ControlStyle-Width="53px" HeaderText="Kaydeden" >
                            <ItemTemplate>
                                <asp:Label ID="labKaydeden" runat="server" Text='<%# Eval("Kaydeden") %>' />                             
                            </ItemTemplate>                 
                         </asp:TemplateField>
                                  
                        <asp:TemplateField ControlStyle-Width="53px" HeaderText="Sorumlu" >
                            <ItemTemplate>
                                <asp:Label ID="labSorumlu" runat="server" Text='<%# Eval("Sorumlular") %>' />                             
                            </ItemTemplate>                 
                         </asp:TemplateField>
                        
                        <asp:TemplateField ControlStyle-Width="100px" HeaderText="Firma">
                            <ItemTemplate>
                                 <asp:Label ID="labFirma" runat="server" Text='<%# Eval("Firma")%>'></asp:Label>
                            </ItemTemplate>
                         </asp:TemplateField> 
                         
                         <asp:TemplateField ControlStyle-Width="110px" HeaderText="Proje">
                            <ItemTemplate>
                                 <asp:Label ID="labProje" runat="server" Text='<%# Eval("Proje")%>'></asp:Label>
                            </ItemTemplate>
                         </asp:TemplateField>

                        <asp:TemplateField ControlStyle-Width="130px" HeaderText="Form">
                            <ItemTemplate>
                                <asp:Label ID="labForm" runat="server" Text='<%# Eval("Form")%>'></asp:Label>
                            </ItemTemplate>
                         </asp:TemplateField>  

                         <asp:TemplateField ControlStyle-Width="260px" HeaderText="Görev">
                            <ItemTemplate>
                                 <asp:Label ID="labGorev" runat="server" Text='<%# Eval("Gorev")%>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>

                         <asp:TemplateField ControlStyle-Width="70px" HeaderText="Tarih">
                            <ItemTemplate>
                                <asp:Label ID="labTarih1" runat="server" Text='<%# Eval("Tarih1","{0:dd.MM.yyyy}")%>'></asp:Label>
                            </ItemTemplate>
                            <FooterTemplate>
                                <asp:Label ID="labTarihFark" runat="server"></asp:Label>
                            </FooterTemplate>
                        </asp:TemplateField>
     
                        <asp:TemplateField ControlStyle-Width="60px" HeaderText="Süre(dk)">
                            <ItemTemplate>
                                <asp:Label ID="labCalismaSure" runat="server" Text='<%# Eval("CalismaSure")%>'></asp:Label>
                            </ItemTemplate>
                            <FooterTemplate>
                                <asp:Label ID="labToplamSure" runat="server" ></asp:Label>
                            </FooterTemplate>
                        </asp:TemplateField>
                       
                         <asp:TemplateField  ControlStyle-CssClass="hideKolon" ItemStyle-CssClass="hideKolon" HeaderStyle-CssClass="hideKolon" FooterStyle-CssClass="hideKolon" HeaderText="Açıklama ">
                            <ItemTemplate>
                                <asp:Label ID="labAciklama" runat="server" Text='<%# Eval("Aciklama")%>'></asp:Label>
                            </ItemTemplate> 
                        </asp:TemplateField>

                        <asp:TemplateField  ControlStyle-CssClass="hideKolon" ItemStyle-CssClass="hideKolon" HeaderStyle-CssClass="hideKolon" FooterStyle-CssClass="hideKolon" HeaderText="Çalışmalar ">
                            <ItemTemplate>
                                <asp:Label ID="labCalisma" runat="server" Text='<%# Eval("Calisma")%>'></asp:Label>
                            </ItemTemplate> 
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
             <asp:AsyncPostBackTrigger ControlID="gridCalisma" EventName="" />
        </Triggers>
    </asp:UpdatePanel>
     <!-- ÇALIŞMA GRIDVIEW  ------------------------- END  ---->
    
    <asp:GridView ID="gridExport" HeaderStyle-BackColor="#363670" HeaderStyle-ForeColor="White" HeaderStyle-Font-Bold="true"
        RowStyle-BackColor="#A1DCF2" AlternatingRowStyle-BackColor="White" AlternatingRowStyle-ForeColor="#000"
        runat="server" AutoGenerateColumns="false" AllowPaging="false"  >
        <Columns>
            <asp:BoundField DataField="Kaydeden" HeaderText="Kaydeden" HeaderStyle-HorizontalAlign="Left" ItemStyle-Width="80px" />
            <asp:BoundField DataField="Sorumlular" HeaderText="Sorumlu" HeaderStyle-HorizontalAlign="Left" ItemStyle-Width="80px" />
            <asp:BoundField DataField="Firma" HeaderText="Firma" HeaderStyle-HorizontalAlign="Left" ItemStyle-Width="120px" />
            <asp:BoundField DataField="Proje" HeaderText="Proje" HeaderStyle-HorizontalAlign="Left" ItemStyle-Width="150px" />
            <asp:BoundField DataField="Form" HeaderText="Form" HeaderStyle-HorizontalAlign="Left" ItemStyle-Width="150px" />
            <asp:BoundField DataField="Gorev" HeaderText="Görev" HeaderStyle-HorizontalAlign="Left" ItemStyle-Width="300px" /> 
            <asp:BoundField DataField="Aciklama" HeaderText="Açıklama" HeaderStyle-HorizontalAlign="Left" ItemStyle-Width="1000px" />       
            <asp:BoundField DataField="Tarih1" DataFormatString="{0:dd.MM.yyyy}" HeaderText="Tarih" HeaderStyle-HorizontalAlign="Left" ItemStyle-Width="90px" />
            <asp:BoundField DataField="CalismaSure" HeaderText="Süre" HeaderStyle-HorizontalAlign="Left" ItemStyle-Width="80px"  />
            <asp:BoundField DataField="Calisma" HeaderText="Çalışma" HeaderStyle-HorizontalAlign="Left" ItemStyle-Width="2000px" />
        </Columns>
    </asp:GridView>

    <asp:HiddenField ID="hfYetkiKodu" runat="server" />

    <!-- LITERAL MESAJ ------------------------  BEGIN  ---->
    <asp:UpdatePanel ID="upPanelMesaj" runat="server">
        <ContentTemplate>
            <div class="row" id="panelbilgi" style="width: 980px; position: fixed; bottom: 0;
                padding: 0px; margin-left: 30px" >
                <div>
                    <div class="panel panel-default" style="background-color:#A9A9A9; margin:2px auto; overflow:hidden" >
                        <asp:Panel ID="pnlHata" runat="server" Visible="false" CssClass="panelInfo" >
                            <div class="alert alert-danger fade in" style="margin: 5px auto; width:970px; overflow:hidden" >
                                <button type="button" id="btnHataClose" onclick="panelBilgiKapan()" class="close" data-dismiss="alert" aria-hidden="true">
                                    &times;</button>
                                <asp:Literal ID="lblHata" runat="server"></asp:Literal>
                            </div>
                        </asp:Panel>
                        <asp:Panel ID="pnlBasarili" runat="server" Visible="false" CssClass="panelInfo">
                            <div class="alert alert-success fade in" style="margin: 5px auto; width:970px; overflow:hidden ">
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
            <asp:AsyncPostBackTrigger ControlID="gridCalisma" EventName="DataBinding" />
        </Triggers>
    </asp:UpdatePanel>
    <!-- LITERAL MESAJ ------------------------  END    ---->

    <!-- POPUP MESAJ FORM KISMI  ----------------------- BEGIN -->
    <asp:Button ID="btnShow" runat="server" Text="SMP" Style="display: none" />
    <ajaxToolkit:ModalPopupExtender ID="mesajPopup" runat="server" BehaviorID="mpeMesaj"
        PopupControlID="pnlPopup" TargetControlID="btnShow" OkControlID="btnYes" OnOkScript="OkClick();"
        CancelControlID="btnNo" OnCancelScript="CancelClick();" BackgroundCssClass="modalBackground2">
    </ajaxToolkit:ModalPopupExtender>
    <asp:Panel ID="pnlPopup" runat="server" CssClass="modalPopup" Style="display: none">
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

    <!-- POPUP CALİSMA FORM   ----------------------------- BEGIN  -->
    <ajaxToolkit:ModalPopupExtender ID="mPopupCalisma" runat="server" BehaviorID="MPECalisma" CancelControlID="btnCalismaIptal" 
            TargetControlID="btnPopupCalismaAc" PopupControlID="popupCalismaPanel" BackgroundCssClass="modalBackground"
            DropShadow="True"  />
    <asp:Button ID="btnPopupCalismaAc" runat="server" Style="display: none" Text="Popup Açmak İçin Şart" />
    <asp:Panel ID="popupCalismaPanel" runat="server" CssClass="editPopupCalismaC" Style="display:none">

        <div id="anaDivC">
            <div id="div1" class="baslikC">
                <asp:Label ID="lab0" Style="margin-right: 40px" runat="server" Text="Kaydeden"></asp:Label>
                <asp:Label ID="lab1" Style="margin-right: 54px" runat="server" Text="Sorumlu"></asp:Label>
                <asp:Label ID="lab2" Style="margin-right: 110px" runat="server" Text="Firma"></asp:Label>
                <asp:Label ID="lab3" Style="margin-right: 144px" runat="server" Text="Proje"></asp:Label>
                <asp:Label ID="lab4" Style="margin-right: 10px" runat="server" Text="Form"></asp:Label>
          
            </div>
            <div id="div2" class="satirC">
                <asp:TextBox ID="txtcKaydeden" Style="margin-right: 20px; background-color: #ebe8e8;"  Width="90px" runat="server"></asp:TextBox>
                <asp:TextBox ID="txtcSorumlu" Style="margin-right: 20px; background-color: #ebe8e8;"  Width="90px" runat="server"></asp:TextBox>
                <asp:TextBox ID="txtcFirma" Style="margin-right: 20px; background-color: #ebe8e8" ReadOnly="true" Width="130px" runat="server" ></asp:TextBox>
                <asp:TextBox ID="txtcProje" Style="margin-right: 20px; background-color: #ebe8e8" ReadOnly="true" Width="160px" runat="server" ></asp:TextBox>
                <asp:TextBox ID="txtcForm" Style="margin-right: 20px; background-color: #ebe8e8" ReadOnly="true" Width="210px" runat="server" ></asp:TextBox>
                
            </div>

            <div id="div3" class="baslikC">
                <asp:Label ID="Label3" Style="margin-right: 312px" runat="server" Text="Görev"></asp:Label>

            </div>
            <div id="div4" class="satirC2">
                <asp:TextBox ID="txtcGorev" Style="margin-right: 20px; background-color: #ebe8e8" ReadOnly="true" Width="774px" Height="24px" TextMode="SingleLine" runat="server"></asp:TextBox>
            </div>

             <div id="div9" class="baslikC">
                <asp:Label ID="Label1" Style="margin-right: 315px" runat="server" Text="Açıklama"></asp:Label>
            </div>
            <div id="div10" class="satirC3">
                <asp:TextBox ID="txtcAciklama" Enabled="false" Style="margin-right: 20px" Width="850px" Height="134px" TextMode="MultiLine" runat="server" ></asp:TextBox>
            </div>

            <div id="div7" class="baslikC">
                <asp:Label ID="Label9" Style="margin-right: 315px" runat="server" Text="Çalışma"></asp:Label>
            </div>
            <div id="div8" class="satirC4">
                <asp:TextBox ID="txtcCalisma" Style="margin-right: 20px" Width="850px" Height="150px" TextMode="MultiLine" runat="server" ></asp:TextBox>
            </div>

            <div id="div5" class="baslikC">
                <asp:Label ID="Label11" Style="margin-right: 55px" runat="server" Text="Çalışma Tarihi"></asp:Label>
             
                <asp:Label ID="Label12" Style="margin-right: 5px" runat="server" Text="Süre(dk)"></asp:Label>

            </div>
            <div id="div6" class="satirC">
                <asp:TextBox ID="txtcTarih" CssClass="txtTakvim" Style="margin-right: 56px" Width="95px" runat="server" ></asp:TextBox>
                
                <asp:TextBox ID="txtcSure"  Style="margin-right:1px" Width="90px" runat="server" ></asp:TextBox>
                <span id="hataMessage"></span>
            </div>

            <asp:HiddenField ID="hfCalismaID" runat="server" />

            <!--BUTONLAR BEGIN-->

                <asp:Button ID="btnCalismaKaydet" OnClick="btnCalismaKaydet_Click" Style="position:absolute; right:150px; bottom:-4px;" runat="server" class="btn btn-primary m-b-10" Text="Kaydet" Width="100px" />
                <asp:Button ID="btnCalismaIptal" Style="position:absolute; right:24px; bottom:6px;" runat="server" class="btn btn-dark" Text="Kapat" Width="100px" />
          
            <!--BUTONLAR END-->

        </div>

    </asp:Panel>
    <!-- POPUP CALİSMA FORM   ------------------------------ END -->

       <!-- POPUP DÜRBÜN   ----------------------------- BEGIN  -->
    <ajaxToolkit:ModalPopupExtender ID="mPopupDurbun" runat="server" BehaviorID="MPEDurbun" CancelControlID="btnDurbunKapat" 
            TargetControlID="btnPopupDurbunAc" PopupControlID="popupDurbunPanel" BackgroundCssClass="modalBackground"
            DropShadow="True"  />
    <asp:Button ID="btnPopupDurbunAc" runat="server" Style="display: none" Text="Popup Açmak İçin Şart" />
    <asp:Panel ID="popupDurbunPanel" runat="server" CssClass="PopupDurbun" Style="height:200px; width:900px; display:none">

        <asp:UpdatePanel ID="upPanelDurbun" runat="server">
            <ContentTemplate>                     
                <div id="divDurbun" style="height:174px; width:900px">
                    <table id="tableDurbun" cellpadding="0" cellspacing="0" border="0">
                        <tr>
                            <td style="width: 150px">Kaydeden</td>
                            <td style="width: 150px">Sorumlu</td>
                            <td style="width: 170px">Firma</td>
                            <td style="width: 180px">Proje</td>
                            <td style="width: 190px">Form</td>
                        </tr>
                        <tr>
                            <td>
                                <asp:DropDownList ID="ddlDKaydeden" CssClass="form-control" data-live-search="true" data-width="150px" Width="150px"
                                    runat="server" AutoPostBack="true" />
                            </td>
                            <td>
                                <asp:DropDownList ID="ddlDSorumlu" CssClass="form-control" data-live-search="true" data-width="150px" Width="150px"
                                    runat="server" AutoPostBack="true" />
                            </td>
                            <td>
                                <asp:DropDownList ID="ddlDFirma" CssClass="form-control" data-live-search="true" data-width="170px" Width="170px"
                                    runat="server" AutoPostBack="true" OnSelectedIndexChanged="ddlDFirma_SelectedIndexChanged" />
                            </td>
                            <td>
                                <asp:DropDownList ID="ddlDProje" CssClass="form-control" data-live-search="true" data-width="180px" Width="180px"
                                    runat="server" AutoPostBack="true" OnSelectedIndexChanged="ddlDProje_SelectedIndexChanged" />
                            </td>
                            <td>
                                <asp:DropDownList ID="ddlDForm" CssClass="form-control" data-live-search="true" data-width="190px" Width="190px"
                                    runat="server" AutoPostBack="true" />
                            </td>
                        </tr>              
                        <tr>
                            <td colspan="2">Görev</td>
                            <td colspan="3">Çalışma Tarihi <span style="margin-left:140px">Kayıt Tarihi</span></td>
                        </tr>
                        <tr>
                            <td colspan="2">
                                <asp:TextBox runat="server" ID="txtDGorev" Width="310px" Height="40px"
                                    TextMode="MultiLine" />
                            </td>

                            <td colspan="3">
                                <asp:TextBox ID="txtDCalismaTarih1" CssClass="txtTakvim" runat="server" Height="26px" Width="95px" />
                                <asp:TextBox ID="txtDCalismaTarih2" CssClass="txtTakvim" runat="server" Height="26px" Width="95px" />

                                <asp:TextBox ID="txtDKayitTarih1" Style="margin-left:36px" CssClass="txtTakvim" runat="server" Height="26px" Width="95px" />
                                <asp:TextBox ID="txtDKayitTarih2" CssClass="txtTakvim" runat="server" Height="26px" Width="95px" /> 
                            </td>
                        </tr>
                    </table>
                </div>         
            </ContentTemplate>
            <Triggers>

            </Triggers>
        </asp:UpdatePanel>

        <!--BUTONLAR BEGIN-->
        <div style="width: 894px; position:absolute; bottom:5px; margin-left: 10px">
            <asp:Label ID="labToplamKayit" Style="width:100px; margin-right:100px" Text="Bulunan Kayıt Sayısı : " runat="server" />
            
            <div style="width:600px; float:right">
            <asp:Button ID="btnExportExcel" Style="margin-right:200px; margin-left:20px" 
                runat="server" Text="Export Excel" Width="100px" OnClick="btnExportExcel_Click" />
            <asp:Button ID="btnDurbunCalismaGetir" Style="margin-right:50px"  
                runat="server" Text="Süz Getir" Width="100px" OnClick="btnDurbunCalismaGetir_Click" />
            <asp:Button ID="btnDurbunKapat" OnClientClick="PopupPanelleriGizle()" 
                runat="server" Text="Kapat" Width="100px" />
           </div>
        </div>
        <!--BUTONLAR END-->
    </asp:Panel>
    <!-- POPUP DÜRBÜN   --------------------------- END -->  

    <asp:UpdatePanel ID="upPanel3" runat="server">
        <ContentTemplate>
           <asp:Timer ID="timer1" runat="server" Interval="100" ontick="timer1_Tick"></asp:Timer>
        </ContentTemplate>
        <Triggers>
            <asp:AsyncPostBackTrigger ControlID="timer1" EventName="Tick" />
            <asp:AsyncPostBackTrigger ControlID="btnCalismaKaydet" EventName="Click" />
            <asp:AsyncPostBackTrigger ControlID="btnDurbunCalismaGetir" EventName="Click" /> 
        </Triggers>
    </asp:UpdatePanel>
     
</asp:Content>
