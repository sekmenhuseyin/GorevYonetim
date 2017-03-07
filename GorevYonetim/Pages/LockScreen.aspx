<%@ Page Language="C#" AutoEventWireup="true" Inherits="GorevYonetim.Pages.LockScreen" Codebehind="LockScreen.aspx.cs" %>

<!DOCTYPE html>
<!--[if lt IE 7]>      <html class="no-js sidebar-large lt-ie9 lt-ie8 lt-ie7"> <![endif]-->
<!--[if IE 7]>         <html class="no-js sidebar-large lt-ie9 lt-ie8"> <![endif]-->
<!--[if IE 8]>         <html class="no-js sidebar-large lt-ie9"> <![endif]-->
<!-- Added by HTTrack -->
<meta http-equiv="content-type" content="text/html;charset=UTF-8" />
<!-- /Added by HTTrack -->
<!--[if gt IE 8]><!-->
<html xmlns="http://www.w3.org/1999/xhtml" class="no-js sidebar-large">
<!--<![endif]-->
<head runat="server">
    <!-- BEGIN META SECTION -->
    <meta charset="utf-8" />
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
    <link href="../assets/css/animate-custom.css" rel="stylesheet">
    <!-- END PAGE LEVEL STYLE -->
    <script src="../assets/plugins/modernizr/modernizr-2.6.2-respond-1.1.0.min.js"></script>
    <script src="../Scripts/jquery-1.4.1.min.js"></script>
    <script type="text/javascript">
        function ParolaBosalt() {
            $("#<%=txtSifre.ClientID%>").val("");
        }
    </script>
</head>
<body class="login lockscreen fade-in" data-page="lockscreen">
    <form id="form1" runat="server">
        <!-- BEGIN LOCKSCREEN BOX -->
        <div class="container" id="login-block">
            <div class="row">
                <div class="col-sm-6 col-md-4 col-sm-offset-3 col-md-offset-4">
                    <div class="login-box clearfix animated flipInY">
                        <div class="page-icon animated bounceInDown">
                            <img src="../assets/img/avatars/avatar12_big.png" alt="avatar 12" />
                        </div>
                        <div>
                            <i class="glyph-icon flaticon-padlock23"></i>
                        </div>
                        <h3><asp:Label ID="labKullanici" runat="server"></asp:Label></h3>
                        <hr />
                        <div class="login-form">
                            <!-- BEGIN ERROR BOX -->
                            <div class="alert alert-danger hide">
                                <button type="button" class="close" data-dismiss="alert">&times;</button>
                                <h4>Error!</h4>
                                Wrong password. Please try again.
                            </div>
                            <!-- END ERROR BOX -->

                            <div class="col-md-12 form-input">
                                <asp:TextBox ID="txtSifre" runat="server" TextMode="Password" CssClass="input-field form-control width-100p password"
                                    placeholder="Şifre" required=""></asp:TextBox>
                            </div>

                            <asp:Button ID="btnGiris" OnClick="btnGiris_Click" runat="server" CssClass="btn btn-login btn-reset" Text="Giriş" />
                            <div class="login-links">
                                <a href="Default.aspx">Başka bir kullanıcı ile oturum aç</a>
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
</body>
</html>
