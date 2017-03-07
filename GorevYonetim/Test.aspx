<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Test.aspx.cs" Inherits="GorevYonetim.Test" %>
<%@ Register  Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="ajaxToolkit" %>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <script>
        function onContentsChange() {
            //alert('contents changed');
        }
    </script>
</head>
<body>
    <form id="form1" runat="server">

     <ajaxToolkit:ToolkitScriptManager runat="Server" EnablePartialRendering="true" EnableViewState="true" EnablePageMethods="true" ID="ScriptManager1" />

      
     <asp:UpdatePanel ID="upPanelProje" runat="server">
        <ContentTemplate>
            <asp:GridView ID="gridProje" CssClass="Grid" Width="720px" runat="server" ShowHeaderWhenEmpty="True"
                AlternatingRowStyle-CssClass="alt" PagerStyle-CssClass="pgr" 
                OnRowEditing="gridProje_RowEditing" GridLines="Horizontal" 
                ondatabinding="gridProje_DataBinding"  ShowFooter="true"
                onpageindexchanging="gridProje_PageIndexChanging" 
                onrowcancelingedit="gridProje_RowCancelingEdit" 
                onrowdatabound="gridProje_RowDataBound" 
                onrowupdating="gridProje_RowUpdating"
                BackColor="White" BorderColor="#E7E7FF" BorderStyle="None" BorderWidth="1px" 
                CellPadding="3" AutoGenerateColumns="False" DataKeyNames="ID" 
                AllowPaging="True"  >
                <AlternatingRowStyle CssClass="alt" BackColor="#F7F7F7" />
                <Columns>
                       <asp:CommandField ControlStyle-Height="28px" ShowEditButton="True" ButtonType="Image" 
                            CancelImageUrl="~/Images/gridTool/cancel.png" EditImageUrl="~/Images/gridTool/edit.png" 
                            HeaderText=" &nbsp Düzenle &nbsp;  " UpdateImageUrl="~/Images/gridTool/accept.png" HeaderStyle-HorizontalAlign="Center" >
                            <HeaderStyle HorizontalAlign="Center" Width="90px" Wrap="false"/>
                            <ItemStyle HorizontalAlign="Center"   Wrap="False" /> 
                            <FooterStyle Height="28px" VerticalAlign="Top"  />                       
                       </asp:CommandField>
                    
                        <asp:TemplateField ControlStyle-Width="100px" HeaderText="Firma" >
                            <ItemTemplate>
                                <asp:Label ID="labFirma" runat="server" Text='<%# Eval("Firma") %>' />                             
                            </ItemTemplate>
                            <EditItemTemplate>
                                <asp:Label ID="labFirma" runat="server" Text='<%# Eval("Firma") %>'  />
                                                                           
                            </EditItemTemplate>
                            <FooterTemplate>
                                <asp:DropDownList ID="ddlProjeFirma" Width="100px" AutoPostBack="true" OnSelectedIndexChanged="ddlProjeFirma_SelectedIndexChanged" runat="server"></asp:DropDownList>
                            </FooterTemplate>
                        </asp:TemplateField>

                        <asp:TemplateField ControlStyle-Width="150px" HeaderText="Proje">
                            <ItemTemplate>
                                <asp:Label ID="labProje" runat="server" Text='<%# Eval("Proje")%>'></asp:Label>
                            </ItemTemplate>
                            <EditItemTemplate>
                                <asp:TextBox ID="txtProje" Width="150px" runat="server" MaxLength="20" Text='<%# Eval("Proje")%>'></asp:TextBox>
                            </EditItemTemplate>
                            <FooterTemplate>       
                                <asp:TextBox ID="txtProje" Width="150px"  MaxLength="20" runat="server"></asp:TextBox>
                            </FooterTemplate> 
                        </asp:TemplateField>
                        <asp:TemplateField ControlStyle-Width="120px" HeaderText="Karşı Sorumlu">
                            <ItemTemplate>
                                <asp:Label ID="labKarsiSorumlu" runat="server" Text='<%# Eval("KarsiSorumlu")%>'></asp:Label>
                            </ItemTemplate>
                           <EditItemTemplate>
                                <asp:Label ID="labKarsiSorumlu" runat="server" Text='<%# Eval("KarsiSorumlu") %>' Visible="false" />
                                <asp:DropDownList ID="ddlKarsiSorumlu" Width="120px" runat="server"></asp:DropDownList>                                              
                            </EditItemTemplate>
                            <FooterTemplate>
                                <asp:DropDownList ID="ddlKarsiSorumlu" Width="120px"  runat="server"> </asp:DropDownList>
                            </FooterTemplate> 
                        </asp:TemplateField>
                        <asp:TemplateField ControlStyle-Width="120px" HeaderText="Sorumlu">
                            <ItemTemplate>
                                <asp:Label ID="labSorumlu" runat="server" Text='<%# Eval("Sorumlu")%>'></asp:Label>
                            </ItemTemplate>
                           <EditItemTemplate>
                                <asp:Label ID="labSorumlu" runat="server" Text='<%# Eval("Sorumlu") %>' Visible="false" />
                                <asp:DropDownList ID="ddlSorumlu" Width="120px" runat="server"></asp:DropDownList>                                              
                            </EditItemTemplate>
                            <FooterTemplate>
                                <asp:DropDownList ID="ddlSorumlu" Width="120px"  runat="server"> </asp:DropDownList>
                            </FooterTemplate> 
                        </asp:TemplateField>
                        <asp:TemplateField ControlStyle-Width="150px" HeaderText="Açıklama">
                            <ItemTemplate>
                                <asp:Label ID="labAciklama" runat="server" Text='<%# Eval("Aciklama")%>'></asp:Label>
                            </ItemTemplate>
                            <EditItemTemplate>
                                <asp:TextBox ID="txtAciklama" Width="150px" runat="server" MaxLength="300" Text='<%# Eval("Aciklama")%>'></asp:TextBox>
                            </EditItemTemplate>
                            <FooterTemplate>       
                                <asp:TextBox ID="txtAciklama" Width="150px"  MaxLength="300" runat="server"></asp:TextBox>
                            </FooterTemplate> 
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
             <asp:AsyncPostBackTrigger ControlID="gridProje" />
          
        </Triggers>
     </asp:UpdatePanel>



    </form>
</body>
</html>
