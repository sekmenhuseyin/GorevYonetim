<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="IzinTakvimi.aspx.cs" 
                  Inherits="GorevYonetim.IzinTakvimi" EnableEventValidation="false" %>
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
            width:100px;
            line-height:26px;
            font-family:Arial,Tahoma;
            font-size:10pt;
            font-weight:bold;
            border-radius:4px;
            color:black;
            height:28px;
            padding-left:4px;
            border:1px solid #333;
        }
    </style>
    <script type="text/javascript" src="Scripts/jquery-1.8.3.google.js"></script>
   
    <script type="text/javascript">

        $(function () {
           
            /// Tarih tipli textboxlara Takvim Popupı ekliyorum
            $("#<%=txtTarih1.ClientID%>,#<%=txtTarih2.ClientID%>").live("focus", function () {
                $(this).datepicker({
                    weekStart: 1,
                    showOn: 'button',
                    dateFormat: "dd.mm.yyyy",
                });
            });

            $("#divGenelSecim input[type='checkbox']").live('click', function () {

                if ($(this).attr("id") == "chkHerkes" && $(this).prop("checked")) {
                    $("#divGenelSecim #chkFS").prop("checked", false);
                    $("#divGenelSecim #chkFB").prop("checked", false);
                    $("#divGenelSecim #chkCA").prop("checked", false);
                    $("#divGenelSecim #chkGA").prop("checked", false);
                    $("#divGenelSecim #chkSY").prop("checked", false);
                    $("#divGenelSecim #chkEU").prop("checked", false);
                }
                else if ($(this).attr("id") != "chkHerkes" && $(this).prop("checked"))
                {
                    $("#divGenelSecim #chkHerkes").prop("checked", false);
                }

                var deger="";
                $("#divGenelSecim input[type='checkbox']").each(function () {
                    if (this.checked)
                        deger = deger + $("label[for='" + $(this).attr("name") + "']").text() + ",";

                });
               
                $("#<%=hfSecilenIzinliler.ClientID%>").val(deger);
             
            });
          

        });
   
        
        function panelBilgiKapan() {
            $("#panelbilgi").css("display", "none");
        }

        function panelBilgiAc() {
            $("#panelbilgi").css("display", "block");
        }

        function Temizle() {
            $("#divGenelSecim #chkHerkes").prop("checked", false);
            $("#divGenelSecim #chkFS").prop("checked", false);
            $("#divGenelSecim #chkFB").prop("checked", false);
            $("#divGenelSecim #chkCA").prop("checked", false);
            $("#divGenelSecim #chkGA").prop("checked", false);
            $("#divGenelSecim #chkSY").prop("checked", false);
            $("#divGenelSecim #chkEU").prop("checked", false);

            $("#<%=hfSecilenIzinliler.ClientID%>").val("");
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

      <!-- İZİN TAKVİMİ GRIDVIEW  ------------------------- BEGIN -->
     <asp:UpdatePanel ID="upIzinTakvimi" runat="server">
        <ContentTemplate>
            <div id="divProjeHeader" style="width: 760px; position:fixed; top:40px; padding-top:6px; background-color: #363670; color: white;">

                <div id="divGenelSecim">
                     <asp:Label ID="lab" Text="İzinliler " CssClass="FilterDropDownCss" style="margin-left:6px; width:70px; color:white;" runat="server" />
                    <input type="checkbox" name="chkHerkes" id="chkHerkes" class="css-checkbox" />
                    <label for="chkHerkes" class="css-label" style="font-size: 11pt; margin-left: 10px; font-weight: bold">Herkes</label>
                    
                    <input type="checkbox" name="chkFS"  id="chkFS" class="css-checkbox" />
                    <label for="chkFS" class="css-label" style="font-size: 11pt; margin-left: 25px; font-weight: bold">FS</label>
                    <input type="checkbox" name="chkFB"  id="chkFB" class="css-checkbox" />
                    <label for="chkFB" class="css-label" style="font-size: 11pt; margin-left: 25px; font-weight: bold">FB</label>
                    <input type="checkbox" name="chkCA"  id="chkCA" class="css-checkbox" />
                    <label for="chkCA" class="css-label" style="font-size: 11pt; margin-left: 25px; font-weight: bold">CA</label>
                    <input type="checkbox" name="chkSY"  id="chkSY" class="css-checkbox" />
                    <label for="chkSY" class="css-label" style="font-size: 11pt; margin-left: 25px; font-weight: bold">MZ</label>
                    <input type="checkbox" name="chkEU"  id="chkEU" class="css-checkbox" />
                    <label for="chkEU" class="css-label" style="font-size: 11pt; margin-left: 25px; font-weight: bold">EU</label>
                    <input type="checkbox" name="chkGA"  id="chkGA" class="css-checkbox" />
                    <label for="chkGA" class="css-label" style="font-size: 11pt; margin-left: 25px; font-weight: bold">GA</label>

                </div>

                <div style="margin-bottom:10px">
                    <asp:Label ID="Label1" Text="İlk Tarih " CssClass="FilterDropDownCss" style="margin-left:6px; width:70px; color:white;" runat="server" />
                    <asp:TextBox ID="txtTarih1"  CssClass="FilterDropDownCss" style="width:90px" runat="server" />
                    <asp:Label ID="Label2"  Text="Son Tarih"  CssClass="FilterDropDownCss" style="margin-left:-2px; width:70px; color:white;" runat="server" />
                    <asp:TextBox ID="txtTarih2"  CssClass="FilterDropDownCss" style="width:90px" runat="server" />
                     <asp:Label ID="Label3"  Text="Açıklama"  CssClass="FilterDropDownCss" style="margin-left:-2px; width:70px; color:white;" runat="server" />
                    <asp:TextBox ID="txtAciklama"  CssClass="FilterDropDownCss" style="width:280px" runat="server" />
                    <asp:Button ID="btnEkle" OnClick="btnEkle_Click" CssClass="FilterDropDownCss"  Style="width:80px" runat="server" class="btn btn-primary m-b-10" Text="İzin Ekle" />
                </div>  

                 <div style="height:24px; font-size:14px; font-weight:bold"  >
                    <asp:Label  Text="Tarih" Style="margin-left: 12px" Width="90px" runat="server" />
                    <asp:Label  Text="İzinliler" Width="154px" runat="server" />
                    <asp:Label  Text="Açıklama" Width="420px" runat="server" />
                  
                </div>
            </div>

            <asp:GridView ID="gridIzinTakvimi" CssClass="Grid" runat="server" 
                AlternatingRowStyle-CssClass="alt" PagerStyle-CssClass="pgr" 
                GridLines="Horizontal" ondatabinding="gridIzinTakvimi_DataBinding" ShowHeader="true"  ShowFooter="true"
                onpageindexchanging="gridIzinTakvimi_PageIndexChanging" OnRowDataBound="gridIzinTakvimi_RowDataBound"             
                BackColor="White" BorderColor="#E7E7FF" BorderStyle="None" BorderWidth="1px" 
                CellPadding="3" AutoGenerateColumns="False" DataKeyNames="ID" 
                AllowPaging="false" PageSize="20"   >
                <AlternatingRowStyle CssClass="alt" BackColor="#F7F7F7"/>
                <Columns>
                        
                        <asp:TemplateField ControlStyle-CssClass="hideKolon" ItemStyle-CssClass="hideKolon" HeaderStyle-CssClass="hideKolon" FooterStyle-CssClass="hideKolon">
                            <ItemTemplate>
                                <asp:Label ID="labID" runat="server" Text='<%# Eval("ID") %>' ></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                                  
                        <asp:TemplateField ControlStyle-Width="100px" ItemStyle-HorizontalAlign="Center" HeaderText="Tarih" >
                            <ItemTemplate>
                                <asp:Label ID="labGun" runat="server" Text='<%# Eval("Gun","{0:dd.MM.yyyy}") %>' />                             
                            </ItemTemplate>                 
                         </asp:TemplateField>
                        
                        <asp:TemplateField ControlStyle-Width="155px" HeaderText="İzinliler">
                            <ItemTemplate>
                                 <asp:Label ID="labIzinliler" runat="server" Text='<%# Eval("Izinliler")%>'></asp:Label>
                            </ItemTemplate>
                         </asp:TemplateField> 
                         
                         <asp:TemplateField ControlStyle-Width="420px" HeaderText="Açıklama">
                            <ItemTemplate>
                                 <asp:Label ID="labAciklama"  runat="server" Text='<%# Eval("Aciklama")%>'></asp:Label>
                            </ItemTemplate>
                         </asp:TemplateField>

                       <asp:TemplateField ControlStyle-Height="22px" HeaderText="Sil">
                            <ItemTemplate>
                                <asp:ImageButton ID="btnDelete" ImageUrl="~/Images/gridTool/delete.png" runat="server" CommandArgument='<%# Eval("ID")%>'
                                     OnClientClick="ShowMesajPopup(this); return false;" Text="Delete" OnClick="btnDelete_Click"></asp:ImageButton>
                            </ItemTemplate>
                       
                            <HeaderStyle Width="70px" Wrap="false" />
                            <ItemStyle HorizontalAlign="Center" Width="70px" Wrap="False" />
                            <FooterStyle Height="28px" HorizontalAlign="Center" />
                           
                     </asp:TemplateField>
                                                                                     
                </Columns>                       
                           
                <EditRowStyle BorderStyle="Solid" BorderWidth="1px" />
                
                <FooterStyle BackColor="Gray" ForeColor="#4A3C8C" />
                <HeaderStyle Height="94px" BackColor="#4A3C8C" Font-Bold="True" ForeColor="#F7F7F7" />
                
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
             <asp:AsyncPostBackTrigger ControlID="gridIzinTakvimi" EventName="" />
        </Triggers>
    </asp:UpdatePanel>
     <!-- ÇALIŞMA GRIDVIEW  ------------------------- END  ---->
    
 
    <asp:HiddenField ID="hfYetkiKodu" runat="server" />
    <asp:HiddenField ID="hfSecilenIzinliler" runat="server" />

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
            <asp:AsyncPostBackTrigger ControlID="gridIzinTakvimi" EventName="DataBinding" />
        </Triggers>
    </asp:UpdatePanel>
    <!-- LITERAL MESAJ ------------------------  END    ---->


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
 

    <asp:UpdatePanel ID="upPanel3" runat="server">
        <ContentTemplate>
           <asp:Timer ID="timer1" runat="server" Interval="100" ontick="timer1_Tick"></asp:Timer>
        </ContentTemplate>
        <Triggers>
            <asp:AsyncPostBackTrigger ControlID="timer1" EventName="Tick" />
            <asp:AsyncPostBackTrigger ControlID="btnEkle" EventName="Click" />
        </Triggers>
    </asp:UpdatePanel>
     
</asp:Content>
