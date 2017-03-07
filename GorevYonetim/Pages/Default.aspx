<%@ Page Title="Log In" Language="C#"  AutoEventWireup="true"
    CodeBehind="Default.aspx.cs" Inherits="GorevYonetim.Default" %>

<!DOCTYPE html>
<!--[if lt IE 7]>      <html class="no-js sidebar-large lt-ie9 lt-ie8 lt-ie7"> <![endif]-->
<!--[if IE 7]>         <html class="no-js sidebar-large lt-ie9 lt-ie8"> <![endif]-->
<!--[if IE 8]>         <html class="no-js sidebar-large lt-ie9"> <![endif]-->
<!--[if gt IE 8]><!-->
<!-- Added by HTTrack -->
<meta http-equiv="content-type" content="text/html" />
<!-- /Added by HTTrack -->
<html xmlns="http://www.w3.org/1999/xhtml" class="no-js sidebar-large">
<!--<![endif]-->
<head id="Head1" runat="server">
    <!-- BEGIN META SECTION -->
    <title>12M Yazılım | ERP Sistemleri V1.0</title>
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <meta content="" name="description" />
    <meta content="themes-lab" name="author" />
    <!-- END META SECTION -->
    <!-- BEGIN MANDATORY STYLE -->
    <link href="../assets/css/icons/icons.min.css" rel="stylesheet" />
    <link href="../assets/css/bootstrap.min.css" rel="stylesheet" />
    <link href="../assets/css/plugins.min.css" rel="stylesheet" />
    <link href="../assets/css/style.min.css" rel="stylesheet" />
    <!-- END  MANDATORY STYLE -->
   
    <!-- BEGIN PAGE LEVEL STYLE -->
    <link href="../assets/css/animate-custom.css" rel="stylesheet" />
    <!-- END PAGE LEVEL STYLE -->
    <script src="../assets/plugins/modernizr/modernizr-2.6.2-respond-1.1.0.min.js"></script>
</head>
<body class="login fade-in" data-page="login">
    <form id="form1" runat="server">
    <asp:ScriptManager ID="ScriptManager1" runat="server">
    </asp:ScriptManager>
    <!-- BEGIN LOGIN BOX -->
    <div class="container" id="login-block">
        <div class="row">
            <div class="col-sm-6 col-md-4 col-sm-offset-3 col-md-offset-4">
                <div class="login-box clearfix animated flipInY">
                    <div class="page-icon animated bounceInDown">
                        <img src="../assets/img/account/user-icon.png" alt="Key icon" />
                    </div>
                    <div class="login-logo">
                        <a href="#">
                            <img title="v25.07.2016" height="150" width="200" src="../Images/logo/12M.png" />
                           
                        </a>
                    </div>
                    <hr />
                  
                    <div class="login-form">
                        <asp:UpdatePanel ID="UpdatePanel1" runat="server">
                            <ContentTemplate>
                                <asp:Panel ID="pnlGiris" runat="server">
                                    <asp:TextBox ID="txtKullaniciAdi" runat="server" placeholder="Kullanıcı Adı" CssClass="input-field form-control user"></asp:TextBox>
                                    <asp:TextBox ID="txtSifre" runat="server" TextMode="Password" placeholder="Şifre"
                                        CssClass="input-field form-control password"></asp:TextBox>
                                    <asp:Button ID="btnGiris" Visible="true" runat="server" CssClass="btn btn-login"
                                        Text="Giriş" onclick="btnGiris_Click"  />
                                </asp:Panel>
                              
                            </ContentTemplate>
                        </asp:UpdatePanel>
                        <asp:UpdateProgress ID="UpdateProgress1" runat="server" AssociatedUpdatePanelID="UpdatePanel1">
                            <ProgressTemplate>
                                <div class="progress progress-striped active">
                                    <div class="progress-bar progress-bar-success" role="progressbar" aria-valuenow="40"
                                        aria-valuemin="0" aria-valuemax="100" style="width: 100%">
                                        <span class="sr-only">Sayfa Yükleniyor</span>Yükleniyor...
                                    </div>
                                </div>
                            </ProgressTemplate>
                        </asp:UpdateProgress>
                      
                        <div class="login-links">
                            <!--Şifremi unuttum burda a href altındaydı.-->
                            <br />
                            <asp:UpdatePanel ID="UpdatePanel2" runat="server">
                                <ContentTemplate>
                                    <asp:Literal ID="lblHata" runat="server"></asp:Literal>
                                </ContentTemplate>
                            </asp:UpdatePanel>
                        </div>
                    </div>
                </div>
            </div>
        </div>
         
    </div>
    <!-- END LOCKSCREEN BOX -->
    </form>
    <!-- BEGIN MANDATORY SCRIPTS -->
    <script src="../assets/plugins/jquery-1.11.js"></script>
    <script src="../assets/plugins/jquery-migrate-1.2.1.js"></script>
    <script src="../assets/plugins/jquery-ui/jquery-ui-1.10.4.min.js"></script>
    <script src="../assets/plugins/bootstrap/bootstrap.min.js"></script>
    <!-- END MANDATORY SCRIPTS -->
    <!-- BEGIN PAGE LEVEL SCRIPTS -->
    <script src="../assets/plugins/backstretch/backstretch.min.js"></script>
    <script src="../assets/js/account.js"></script>
    <!-- END PAGE LEVEL SCRIPTS -->
    <!-- BEGIN MANDATORY SCRIPTS -->
    <script src="../assets/plugins/bootstrap-dropdown/bootstrap-hover-dropdown.min.js"></script>
    <script src="../assets/plugins/bootstrap-select/bootstrap-select.js"></script>
    <!-- END MANDATORY SCRIPTS -->
    <!-- BEGIN PAGE LEVEL SCRIPTS -->
    <script src="../assets/plugins/icheck/custom.js"></script>
    <script src="../assets/js/form.js"></script>
    <!-- END  PAGE LEVEL SCRIPTS -->
    <script src="../assets/js/application.js"></script>
</body>
</html>
