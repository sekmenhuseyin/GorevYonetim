<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="GorevTakvimi.aspx.cs" 
                  Inherits="GorevYonetim.GorevTakvimi" EnableEventValidation="false" %>
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
        .LabelCss {
            white-space: nowrap; 
            display:inline-block; 
            overflow-x: hidden;
            font-size:9pt;
            text-align:center;
            height:20px;
            cursor:pointer;
        }
        .PanelCss {
            display:inline-flex;
            white-space: nowrap; 
            overflow-x: hidden;
            font-size:9pt;
        }
        .TabloBaslik {
            text-align:center;
            font-size:12pt;
            font-weight:bold;
            border:1px solid black;
        }
        .TabloYan {
            text-align:center;
            font-size:9pt;
            font-weight:bold;
            border:1px solid black;
            height:22px;
        }
        .TabloHucre {
            border:1px solid black;    
        }
        .tableTakvim {
            border: 2px solid gray;
        }
            .tableTakvim tr td {
                padding: 0px;
            }
            .tableTakvim tr:nth-child(even) td {
                background-color: silver;
                color: black;
            }
                .tableTakvim tr:nth-child(even) td a {
                    color: black;
                }
                    .tableTakvim tr:nth-child(even) td a:hover {
                        font-weight: bold;
                    }
            .tableTakvim tr:nth-child(odd) td {
                background-color: aliceblue;
                color: black;
            }
                .tableTakvim tr:nth-child(odd) td a {
                    color: black;
                }
                    .tableTakvim tr:nth-child(odd) td a:hover {
                        font-weight: bold;
                    }

    </style>
     <script type="text/javascript" src="assets/plugins/jquery-1.11.js"></script>
   
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

           
        });
        
        function panelBilgiKapan() {
            $("#panelbilgi").css("display", "none");
        }

        function panelBilgiAc() {
            $("#panelbilgi").css("display", "block");
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


    <ajaxToolkit:ToolkitScriptManager runat="Server" ID="ScriptManager1" />

    <!-- GÖREV TAKVİMİ GRIDVIEW  ------------------------- BEGIN -->

    <div id="divProjeHeader" style="top: 40px; padding-top: 6px; background-color: #363670; color: white;">

        <div>
            <asp:Label Text="İlk Tarih " CssClass="FilterDropDownCss" Style="margin-left: 6px; width: 70px; color: white;" runat="server" />
            <asp:TextBox ID="txtTarih1" CssClass="FilterDropDownCss" Style="width: 90px" runat="server" />
            <asp:Label Text="Son Tarih " CssClass="FilterDropDownCss" Style="margin-left: 4px; width: 70px; color: white;" runat="server" />
            <asp:TextBox ID="txtTarih2" CssClass="FilterDropDownCss" Style="width: 90px" runat="server" />
            <asp:Button ID="btnTamam" style="margin-left: 4px; vertical-align:baseline" class="btn btn-primary m-b-10" Text="Listele" OnClick="btnTamam_Click" runat="server" />
        </div>
    </div>

    <div style="position:relative; background-color:gray">
        <div style="float: left">
            <asp:Table ID="TabloSorumlular"  runat="server" CssClass="tableTakvim">
            </asp:Table>
            <br />
            <br />
            <asp:Table ID="TabloMusteriler" runat="server" CssClass="tableTakvim">
            </asp:Table>
        </div>
        <div style="overflow-x: scroll; height: 480px; width: 960px; overflow-y: hidden; 
              background-color: gray; -webkit-scrollbar-thumb-background: #393812;
              -webkit-border-radius: 1ex; -webkit-box-shadow: 0px 1px 2px rgba(0, 0, 0, 0.75);">
            <asp:Table ID="TabloTakvim" runat="server" CssClass="tableTakvim">
            </asp:Table>
            <br />
            <br />
            <asp:Table ID="TabloTakvim2" runat="server" CssClass="tableTakvim">
            </asp:Table>
        </div>
    </div>

    <!-- GÖREV TAKVİMİ GRIDVIEW  ------------------------- END -->
  

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
          
        </Triggers>
    </asp:UpdatePanel>
    <!-- LITERAL MESAJ ------------------------  END    ---->


    <asp:UpdatePanel ID="upPanel3" runat="server">
        <ContentTemplate>
           <asp:Timer ID="timer1" runat="server" Interval="100" ontick="timer1_Tick"></asp:Timer>
        </ContentTemplate>
        <Triggers>
            <asp:AsyncPostBackTrigger ControlID="timer1" EventName="Tick" />
           <%-- <asp:AsyncPostBackTrigger ControlID="btnTamam" EventName="Click" />--%>
        </Triggers>
    </asp:UpdatePanel>
     
</asp:Content>
