USE [master]
GO
/****** Object:  Database [OnikimGorev]    Script Date: 26.01.2018 18:37:35 ******/
CREATE DATABASE [OnikimGorev]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'OnikimGorev', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL11.MSSQLSERVER\MSSQL\DATA\OnikimGorev_2.mdf' , SIZE = 14336KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'OnikimGorev_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL11.MSSQLSERVER\MSSQL\DATA\OnikimGorev_2_log.ldf' , SIZE = 26112KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO
ALTER DATABASE [OnikimGorev] SET COMPATIBILITY_LEVEL = 100
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [OnikimGorev].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [OnikimGorev] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [OnikimGorev] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [OnikimGorev] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [OnikimGorev] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [OnikimGorev] SET ARITHABORT OFF 
GO
ALTER DATABASE [OnikimGorev] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [OnikimGorev] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [OnikimGorev] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [OnikimGorev] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [OnikimGorev] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [OnikimGorev] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [OnikimGorev] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [OnikimGorev] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [OnikimGorev] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [OnikimGorev] SET  DISABLE_BROKER 
GO
ALTER DATABASE [OnikimGorev] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [OnikimGorev] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [OnikimGorev] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [OnikimGorev] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [OnikimGorev] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [OnikimGorev] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [OnikimGorev] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [OnikimGorev] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [OnikimGorev] SET  MULTI_USER 
GO
ALTER DATABASE [OnikimGorev] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [OnikimGorev] SET DB_CHAINING OFF 
GO
ALTER DATABASE [OnikimGorev] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [OnikimGorev] SET TARGET_RECOVERY_TIME = 0 SECONDS 
GO
EXEC sys.sp_db_vardecimal_storage_format N'OnikimGorev', N'ON'
GO
USE [OnikimGorev]
GO
/****** Object:  User [USR110912115303]    Script Date: 26.01.2018 18:37:36 ******/
CREATE USER [USR110912115303] WITHOUT LOGIN WITH DEFAULT_SCHEMA=[dbo]
GO
/****** Object:  DatabaseRole [USR090826114250]    Script Date: 26.01.2018 18:37:36 ******/
CREATE ROLE [USR090826114250]
GO
/****** Object:  Schema [ong]    Script Date: 26.01.2018 18:37:36 ******/
CREATE SCHEMA [ong]
GO
/****** Object:  UserDefinedFunction [dbo].[fnSplit]    Script Date: 26.01.2018 18:37:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[fnSplit](
    @sInputList VARCHAR(8000) -- List of delimited items
  , @sDelimiter VARCHAR(8000) = ',' -- delimiter that separates items
) RETURNS @List TABLE (item VARCHAR(8000))

BEGIN
DECLARE @sItem VARCHAR(8000)
WHILE CHARINDEX(@sDelimiter,@sInputList,0) <> 0
 BEGIN
 SELECT
  @sItem=RTRIM(LTRIM(SUBSTRING(@sInputList,1,CHARINDEX(@sDelimiter,@sInputList,0)-1))),
  @sInputList=RTRIM(LTRIM(SUBSTRING(@sInputList,CHARINDEX(@sDelimiter,@sInputList,0)+LEN(@sDelimiter),LEN(@sInputList))))

 IF LEN(@sItem) > 0
  INSERT INTO @List SELECT @sItem
 END

IF LEN(@sInputList) > 0
 INSERT INTO @List SELECT @sInputList -- Put the last item in
RETURN
END


GO
/****** Object:  Table [ong].[Ayar]    Script Date: 26.01.2018 18:37:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [ong].[Ayar](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[MailTo] [varchar](300) NULL,
	[MailCc] [varchar](300) NULL,
	[MailCcTumunde] [bit] NULL,
	[KontrolBaslangicTarihi] [date] NULL,
 CONSTRAINT [PK_Ayar] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [ong].[EkDosya]    Script Date: 26.01.2018 18:37:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [ong].[EkDosya](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[GorevID] [int] NOT NULL,
	[DosyaAdi] [varchar](150) NOT NULL,
	[Boyut] [varchar](20) NULL,
	[Aciklama] [varchar](300) NULL,
	[Kaydeden] [varchar](5) NULL,
	[KayitTarih] [smalldatetime] NULL,
	[Tip] [smallint] NOT NULL,
 CONSTRAINT [PK_EkDosya] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [Unique_EkDosya] UNIQUE NONCLUSTERED 
(
	[GorevID] ASC,
	[DosyaAdi] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [ong].[EMail]    Script Date: 26.01.2018 18:37:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [ong].[EMail](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[MailTo] [varchar](300) NULL,
	[MailCc] [varchar](300) NULL,
	[Baslik] [varchar](300) NULL,
	[Icerik] [varchar](4000) NULL,
	[Kaydeden] [varchar](5) NULL,
	[KayitTarih] [smalldatetime] NULL,
 CONSTRAINT [PK_EMail] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [ong].[GorevCalisma]    Script Date: 26.01.2018 18:37:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [ong].[GorevCalisma](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Sorumlular] [varchar](20) NOT NULL,
	[GorevID] [int] NOT NULL,
	[Tarih1] [smalldatetime] NOT NULL,
	[Tarih2] [smalldatetime] NULL,
	[CalismaSure] [int] NOT NULL,
	[Calisma] [varchar](4000) NOT NULL,
	[Durum] [smallint] NULL,
	[Kaydeden] [varchar](5) NULL,
	[KayitTarih] [smalldatetime] NULL,
	[Degistiren] [varchar](5) NULL,
	[DegisTarih] [smalldatetime] NULL,
 CONSTRAINT [PK_GorevCalisma] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [ong].[GorevDetay]    Script Date: 26.01.2018 18:37:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [ong].[GorevDetay](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[GorevID] [int] NOT NULL,
	[GorevDetay] [nvarchar](200) NOT NULL,
	[Durum] [bit] NOT NULL,
	[Kaydeden] [varchar](5) NOT NULL,
	[KayitTarih] [smalldatetime] NOT NULL,
	[Degistiren] [varchar](5) NOT NULL,
	[DegisTarih] [smalldatetime] NOT NULL,
 CONSTRAINT [PK_GorevDetay] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [ong].[GorevHareket]    Script Date: 26.01.2018 18:37:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [ong].[GorevHareket](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[GorevID] [int] NOT NULL,
	[Firma] [varchar](20) NULL,
	[Proje] [varchar](20) NULL,
	[Form] [varchar](50) NULL,
	[Sorumlu] [varchar](5) NULL,
	[Sorumlu2] [varchar](5) NULL,
	[Sorumlu3] [varchar](5) NULL,
	[Gorev] [varchar](100) NULL,
	[Aciklama] [varchar](2000) NULL,
	[DurumAciklama] [varchar](2000) NULL,
	[Oncelik] [varchar](20) NULL,
	[Durum] [smallint] NULL,
	[DurumStr] [varchar](20) NULL,
	[TahminiBitisTarih] [smalldatetime] NULL,
	[Kaydeden] [varchar](5) NOT NULL,
	[KayitTarih] [smalldatetime] NOT NULL,
	[SqlType] [varchar](10) NULL,
 CONSTRAINT [PK_GorevHareket] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [ong].[Gorevler]    Script Date: 26.01.2018 18:37:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [ong].[Gorevler](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Firma] [varchar](20) NOT NULL,
	[Proje] [varchar](20) NOT NULL,
	[Form] [varchar](50) NOT NULL,
	[Sorumlu] [varchar](5) NULL,
	[Sorumlu2] [varchar](5) NULL,
	[Sorumlu3] [varchar](5) NULL,
	[Gorev] [varchar](100) NOT NULL,
	[Aciklama] [varchar](2000) NOT NULL,
	[DurumAciklama] [varchar](2000) NULL,
	[Oncelik] [smallint] NOT NULL,
	[Durum] [smallint] NOT NULL,
	[GorevTipi] [smallint] NULL,
	[CalisilanDepartman] [smallint] NULL,
	[TahminiBitisTarih] [smalldatetime] NULL,
	[BitisTarih] [smalldatetime] NULL,
	[Kaydeden] [varchar](5) NOT NULL,
	[KayitTarih] [smalldatetime] NOT NULL,
	[Degistiren] [varchar](5) NOT NULL,
	[DegisTarih] [smalldatetime] NOT NULL,
	[IslemTip] [smallint] NULL,
	[IslemSira] [int] NULL,
 CONSTRAINT [PK_Gorevler] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [ong].[Kullanici]    Script Date: 26.01.2018 18:37:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [ong].[Kullanici](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[KulKodu] [varchar](5) NOT NULL,
	[Pass] [varchar](100) NOT NULL,
	[AdSoyad] [varchar](50) NOT NULL,
	[YetkiKod] [smallint] NOT NULL,
	[Email] [varchar](80) NULL,
	[Tel] [varchar](15) NULL,
	[Firma] [varchar](20) NULL,
	[Type] [smallint] NOT NULL,
	[Kaydeden] [varchar](5) NULL,
	[KayitTarih] [smalldatetime] NULL,
	[Degistiren] [varchar](5) NULL,
	[DegisTarih] [smalldatetime] NULL,
 CONSTRAINT [PK_Kullanici] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [Unique_Kullanici] UNIQUE NONCLUSTERED 
(
	[KulKodu] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [ong].[Musteri]    Script Date: 26.01.2018 18:37:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [ong].[Musteri](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Firma] [varchar](20) NOT NULL,
	[Unvan] [varchar](80) NOT NULL,
	[Aciklama] [varchar](300) NULL,
	[Tarih] [smalldatetime] NULL,
	[Email] [varchar](80) NULL,
	[Tel1] [varchar](15) NULL,
	[Tel2] [varchar](15) NULL,
	[MesaiKontrol] [bit] NULL,
	[MesaiKota] [int] NULL,
	[FID] [int] NOT NULL,
	[Kaydeden] [varchar](5) NULL,
	[KayitTarih] [smalldatetime] NULL,
	[Degistiren] [varchar](5) NULL,
	[DegisTarih] [smalldatetime] NULL,
 CONSTRAINT [PK_Musteri] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [Unique_Firma] UNIQUE NONCLUSTERED 
(
	[Firma] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [ong].[ProjeForm]    Script Date: 26.01.2018 18:37:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [ong].[ProjeForm](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Firma] [varchar](20) NOT NULL,
	[Proje] [varchar](20) NOT NULL,
	[Form] [varchar](50) NOT NULL,
	[Sorumlu] [varchar](5) NULL,
	[KarsiSorumlu] [varchar](50) NULL,
	[Aciklama] [varchar](300) NULL,
	[MesaiKontrol] [bit] NULL,
	[MesaiKota] [int] NULL,
	[PID] [int] NULL,
	[Durum] [smallint] NULL,
	[Kaydeden] [varchar](5) NULL,
	[KayitTarih] [smalldatetime] NULL,
 CONSTRAINT [PK_Proje] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [Unique_Proje_Form] UNIQUE NONCLUSTERED 
(
	[Firma] ASC,
	[Proje] ASC,
	[Form] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [ong].[Tanim]    Script Date: 26.01.2018 18:37:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [ong].[Tanim](
	[Tip] [smallint] NOT NULL,
	[KodInt] [smallint] NOT NULL,
	[Kod] [varchar](20) NOT NULL,
	[Aciklama] [varchar](100) NULL,
 CONSTRAINT [PK_Tanim] PRIMARY KEY CLUSTERED 
(
	[Tip] ASC,
	[KodInt] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [ong].[TatilGunleri]    Script Date: 26.01.2018 18:37:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [ong].[TatilGunleri](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Izinliler] [varchar](30) NOT NULL,
	[Gun] [date] NOT NULL,
	[Aciklama] [varchar](50) NULL,
 CONSTRAINT [PK_TatilGunleri] PRIMARY KEY CLUSTERED 
(
	[Izinliler] ASC,
	[Gun] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [ong].[EkDosya] ADD  CONSTRAINT [DF_EkDosya_KayitTarih]  DEFAULT (getdate()) FOR [KayitTarih]
GO
ALTER TABLE [ong].[GorevCalisma] ADD  CONSTRAINT [DF_GorevCalisma_KayitTarih]  DEFAULT (getdate()) FOR [KayitTarih]
GO
ALTER TABLE [ong].[GorevCalisma] ADD  CONSTRAINT [DF_GorevCalisma_DegisTarih]  DEFAULT (getdate()) FOR [DegisTarih]
GO
ALTER TABLE [ong].[GorevDetay] ADD  CONSTRAINT [DF_GorevDetay_Durum]  DEFAULT ((0)) FOR [Durum]
GO
ALTER TABLE [ong].[Gorevler] ADD  CONSTRAINT [DF_Gorev_Oncelik]  DEFAULT ((0)) FOR [Oncelik]
GO
ALTER TABLE [ong].[Gorevler] ADD  CONSTRAINT [DF_Gorevler_Durum]  DEFAULT ((0)) FOR [Durum]
GO
ALTER TABLE [ong].[Gorevler] ADD  CONSTRAINT [DF_Gorevler_KayitTarih]  DEFAULT (getdate()) FOR [KayitTarih]
GO
ALTER TABLE [ong].[Gorevler] ADD  CONSTRAINT [DF_Gorevler_DegisTarih]  DEFAULT (getdate()) FOR [DegisTarih]
GO
ALTER TABLE [ong].[Kullanici] ADD  CONSTRAINT [DF_Kullanici_KayitTarih]  DEFAULT (getdate()) FOR [KayitTarih]
GO
ALTER TABLE [ong].[Kullanici] ADD  CONSTRAINT [DF_Kullanici_DegisTarih]  DEFAULT (getdate()) FOR [DegisTarih]
GO
ALTER TABLE [ong].[Musteri] ADD  CONSTRAINT [DF_Musteri_KayitTarih]  DEFAULT (getdate()) FOR [KayitTarih]
GO
ALTER TABLE [ong].[Musteri] ADD  CONSTRAINT [DF_Musteri_DegisTarih]  DEFAULT (getdate()) FOR [DegisTarih]
GO
ALTER TABLE [ong].[ProjeForm] ADD  CONSTRAINT [DF_Proje_Durum]  DEFAULT ((0)) FOR [Durum]
GO
ALTER TABLE [ong].[ProjeForm] ADD  CONSTRAINT [DF_ProjeForm_KayitTarih]  DEFAULT (getdate()) FOR [KayitTarih]
GO
ALTER TABLE [ong].[Gorevler]  WITH NOCHECK ADD  CONSTRAINT [FK_Gorevler_Kullanici] FOREIGN KEY([Sorumlu])
REFERENCES [ong].[Kullanici] ([KulKodu])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [ong].[Gorevler] NOCHECK CONSTRAINT [FK_Gorevler_Kullanici]
GO
/****** Object:  StoredProcedure [ong].[Calisma_Girmeyenler_Raporu]    Script Date: 26.01.2018 18:37:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [ong].[Calisma_Girmeyenler_Raporu]
AS
BEGIN

     DECLARE @KulKodu VARCHAR(5), @AdSoyad VARCHAR(50), @KontrolBaslangicTarihi DATE,
			@MailTo VARCHAR(300), @MailCc VARCHAR(300), @Subject VARCHAR(300), 
			@Body VARCHAR(MAX), @Sayac INT, @KontrolTarih DATE, @TempTarih VARCHAR(10),
			@TempSorumlu VARCHAR(30), @TempSorumlular VARCHAR(40)

	SET @KontrolBaslangicTarihi=CONVERT(DATE, GETDATE()-30, 104)--(SELECT TOP 1 KontrolBaslangicTarihi FROM ong.Ayar)

	SET @MailTo = (SELECT TOP 1 MailTo FROM ong.Ayar)
	IF (SELECT TOP 1 MailCcTumunde FROM ong.Ayar) = 1
	Begin
	   SET @MailCc = (SELECT TOP 1 MailCc FROM ong.Ayar)
	End

	SET Language Turkish --
	SET @KontrolTarih=@KontrolBaslangicTarihi
	
	 SET @Body='<style type="text/css">
		table
		{
		    font-family:Arial,Tahoma,sans-serif;
            font-size:10pt;
		}
        table tr th
        {
           text-align:left;
		   padding:4px;
        }
		table td
		{
		   border:1px solid #ddd;
		   padding:4px 4px 4px 6px;
		} 
        </style>
		<table cellspacing="0" cellpadding="3" style="background-color: White; 
		border-color: #E7E7FF; border-width: 1px; border-style: solid; 
		width: 390px; border-collapse: collapse;">
        <tr style="color: #F7F7F7; background-color: #4A3C8C; font-weight: bold;">
            <th style="width:90px">Tarih</th>
            <th style="width:100px">Sorumlu</th>
            <th style="width:200px">Açıklama</th>
        </tr>'

		SET @Sayac=0; 


	WHILE @KontrolTarih <= CONVERT(DATE, GETDATE(), 104)
	
	BEGIN
	    
	    --Cumartesi ve Pazar Kontrolü
		IF (Datepart(dw,@KontrolTarih) = 6) OR (Datepart(dw,@KontrolTarih) = 7) 
		Begin
		    SET @KontrolTarih = DATEADD(DAY,1,@KontrolTarih)
			Continue;
		End 

		
		IF(SELECT COUNT(ID) FROM ong.TatilGunleri(NOLOCK)
		WHERE Gun=@KontrolTarih AND Izinliler='Herkes')>0 
		Begin
		    SET @KontrolTarih = DATEADD(DAY,1,@KontrolTarih) --Tarihi 1 gün arttır 
	    	Continue;
		End

		SET @TempSorumlu=''
		SET @TempSorumlular=''

		DECLARE CUR1 CURSOR FOR
	    (SELECT Izinliler FROM ong.TatilGunleri(NOLOCK)
		WHERE Gun=@KontrolTarih AND Izinliler<>'Herkes')

		OPEN CUR1
		FETCH NEXT FROM CUR1 INTO @TempSorumlu

	    WHILE @@FETCH_STATUS = 0
	    BEGIN
		    
			SET @TempSorumlular=@TempSorumlular+','+@TempSorumlu
			FETCH NEXT FROM CUR1 INTO @TempSorumlu
		END
		CLOSE CUR1
	    DEALLOCATE CUR1	

		SET @TempTarih='E';

	    DECLARE CUR CURSOR FOR
		(SELECT KulKodu, AdSoyad FROM ong.Kullanici(NOLOCK) 
	            WHERE [Type]=0 AND YetkiKod=2 AND 
			    CONVERT(DATE,KayitTarih,104) <= CONVERT(DATE,@KontrolTarih,104) AND
				KulKodu NOT IN(SELECT item FROM  [dbo].[fnSplit](@TempSorumlular,','))
				
				)
        
		OPEN CUR
	    FETCH NEXT FROM CUR INTO @KulKodu, @AdSoyad

	    WHILE @@FETCH_STATUS = 0
	    BEGIN
		   
			IF (SELECT COUNT(ID) FROM ong.GorevCalisma(NOLOCK)
			WHERE CONVERT(DATE,Tarih1,104) = CONVERT(DATE,@KontrolTarih,104)
			AND Kaydeden=@KulKodu) = 0
			BEGIN
			    
				IF(@TempTarih='E')
				SET @TempTarih = CONVERT(VARCHAR(10),@KontrolTarih,104);

				IF @Sayac%2 = 0 
				Begin
					SET @Body = @Body + '<tr style="color: #4A3C8C; background-color: #E7E7FF;">
					<td> <span style="font-weight:bold">'+@TempTarih+'</span> </td>
					<td> <span style="display: inline-block;">'+@KulKodu+'</span> </td>
					<td> <span style="display: inline-block;">Çalışma girilmemiştir.</span> </td></tr>';			
				End
				ELSE
				Begin
					SET @Body = @Body + '<tr style="color: #4A3C8C; background-color: #F7F7F7;">
					<td> <span style="font-weight:bold">'+@TempTarih+'</span> </td>
					<td> <span style="display: inline-block;">'+@KulKodu+'</span> </td>
					<td> <span style="display: inline-block;">Çalışma girilmemiştir.</span> </td></tr>';			
				End	
				
				SET @TempTarih='';
				SET @Sayac=@Sayac+1;	 								
			END

					    
			FETCH NEXT FROM CUR INTO @KulKodu, @AdSoyad

		END -- CURSOR
		
		CLOSE CUR
	    DEALLOCATE CUR	

        SET @KontrolTarih = DATEADD(DAY,1,@KontrolTarih) --Tarihi 1 gün arttır
		

	END -- WHILE

	SET @Subject = CONVERT(VARCHAR(10),GETDATE(),104) + ' Girilmemiş Çalışmalar';
	
	SELECT @Sayac   

	IF @Sayac > 0
	BEGIN
		    EXEC msdb.dbo.sp_send_dbmail
				@profile_name = 'GorevMail',
				@recipients = @MailTo,
				@copy_recipients = @MailCc,
				@subject = @Subject,
				@body=@Body,
				@body_format ='HTML',
				@importance ='HIGH'
    END	

END
GO
/****** Object:  StoredProcedure [ong].[GorevCalisma_Takvimi]    Script Date: 26.01.2018 18:37:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [ong].[GorevCalisma_Takvimi]
@BaslangicTarih DATE,
@BitisTarih DATE
AS
BEGIN

    SET Language Turkish

	SELECT GC.Kaydeden,  SUM(GC.CalismaSure) AS CalismaSure, 
	       (SUM(GC.CalismaSure)/60) AS Saat, (SUM(GC.CalismaSure)%60) AS Dakika, 
	        G.Firma, G.Proje, GC.Tarih1 AS Tarih,
			CAST(DAY(GC.Tarih1) AS varchar)+' '+DATENAME(MONTH,GC.Tarih1)+
			           ' '+DATENAME(WEEKDAY, GC.Tarih1) AS TarihStr 
	FROM ong.GorevCalisma(NOLOCK) GC
	INNER JOIN ong.Gorevler(NOLOCK) G ON GC.GorevID=G.ID
	WHERE GC.Tarih1>=@BaslangicTarih AND  GC.Tarih1<=@BitisTarih
	      --AND GC.Kaydeden='CA'
    GROUP BY GC.Kaydeden, GC.Tarih1, G.Firma, G.Proje 

	UNION ALL

	SELECT GC.Kaydeden,  (540-SUM(GC.CalismaSure)) AS CalismaSure,
	    ((540-SUM(GC.CalismaSure))/60) AS Saat, ((540-SUM(GC.CalismaSure))%60) AS Dakika,   
	    '' AS Firma, '' AS Proje, GC.Tarih1 AS Tarih,
		CAST(DAY(GC.Tarih1) AS varchar)+' '+DATENAME(MONTH,GC.Tarih1)+
			        ' '+DATENAME(WEEKDAY, GC.Tarih1) AS TarihStr 
	FROM ong.GorevCalisma(NOLOCK) GC
	INNER JOIN ong.Gorevler(NOLOCK) G ON GC.GorevID=G.ID
	WHERE GC.Tarih1>=@BaslangicTarih AND  GC.Tarih1<=@BitisTarih
	      --AND GC.Kaydeden='CA'
    GROUP BY GC.Kaydeden, GC.Tarih1 
	HAVING SUM(GC.CalismaSure)<540
	ORDER BY GC.Kaydeden, GC.Tarih1, G.Firma DESC

 

	

  
END
GO
/****** Object:  StoredProcedure [ong].[Gorevi_YenidenSirala]    Script Date: 26.01.2018 18:37:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [ong].[Gorevi_YenidenSirala]
@Sorumlu VARCHAR(5),
@GorevID INT,
@MevcutSira INT,
@YeniSira INT,
@SadeceSirala BIT
AS
BEGIN

  DECLARE @GID INT, @GIslemSira INT 

IF(@SadeceSirala=0)  --SadeceSirala True ise bu if bloğuna girmeyecek
BEGIN
   
	IF(@MevcutSira IS NULL)
	   SET @MevcutSira=1000

	IF((SELECT COUNT(ID) FROM ong.Gorevler 
	   WHERE Sorumlu=@Sorumlu AND Durum IN(1,2,3,4,5,6) 
	   AND IslemSira=@YeniSira AND ID<>@GorevID)>0 AND @YeniSira<@MevcutSira)
	BEGIN
   
		UPDATE ong.Gorevler SET IslemSira=@YeniSira WHERE ID=@GorevID
   
		DECLARE CUR CURSOR FOR(
			SELECT ID, IslemSira FROM ong.Gorevler 
			WHERE Sorumlu=@Sorumlu AND Durum IN(1,2,3,4,5,6) AND 
			IslemSira>=@YeniSira AND IslemSira<=@MevcutSira AND ID<>@GorevID)

		OPEN CUR
		FETCH NEXT FROM CUR INTO @GID, @GIslemSira
		WHILE @@FETCH_STATUS=0
		BEGIN
  
		   UPDATE ong.Gorevler SET IslemSira=@GIslemSira+1 WHERE ID=@GID 

		   FETCH NEXT FROM CUR INTO @GID, @GIslemSira
		END
		CLOSE CUR
		DEALLOCATE CUR
	END
	ELSE IF((SELECT COUNT(ID) FROM ong.Gorevler 
	   WHERE Sorumlu=@Sorumlu AND Durum IN(1,2,3,4,5,6) 
	   AND IslemSira=@YeniSira AND ID<>@GorevID)>0 AND @YeniSira>@MevcutSira)
	BEGIN
   
		UPDATE ong.Gorevler SET IslemSira=@YeniSira WHERE ID=@GorevID
   
		DECLARE CUR CURSOR FOR(
			SELECT ID, IslemSira FROM ong.Gorevler 
			WHERE Sorumlu=@Sorumlu AND Durum IN(1,2,3,4,5,6) AND 
			IslemSira<=@YeniSira AND IslemSira>=@MevcutSira AND ID<>@GorevID)

		OPEN CUR
		FETCH NEXT FROM CUR INTO @GID, @GIslemSira
		WHILE @@FETCH_STATUS=0
		BEGIN
  
		   UPDATE ong.Gorevler SET IslemSira=@GIslemSira-1 WHERE ID=@GID 

		   FETCH NEXT FROM CUR INTO @GID, @GIslemSira
		END
		CLOSE CUR
		DEALLOCATE CUR
	END

	ELSE
	BEGIN
	   UPDATE ong.Gorevler SET IslemSira=@YeniSira WHERE ID=@GorevID
	END

END


-----Sadece Sıralama Kısmı Örneğin (2,4,6) yı (1,2,3) yapar

DECLARE @SaySira INT
SET @SaySira=1
    
DECLARE CUR CURSOR FOR
(
	---CURSOR da Order By Kullanabilmek için Dış Select ve Top kullanılmalı
	SELECT A.ID FROM(
	SELECT TOP 200 ID FROM ong.Gorevler 
	WHERE Sorumlu=@Sorumlu AND Durum IN(1,2,3,4,5,6) AND 
	      IslemSira IS NOT NULL AND IslemSira>0
	ORDER BY IslemSira ASC
	) A
)

OPEN CUR
FETCH NEXT FROM CUR INTO @GID
WHILE @@FETCH_STATUS=0
BEGIN
  
	UPDATE ong.Gorevler SET IslemSira=@SaySira WHERE ID=@GID 	   
	SET @SaySira=@SaySira+1

	FETCH NEXT FROM CUR INTO @GID
END
CLOSE CUR
DEALLOCATE CUR



END

GO
/****** Object:  StoredProcedure [ong].[GorevMailGonderimi]    Script Date: 26.01.2018 18:37:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [ong].[GorevMailGonderimi]
AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @ID INT, @MailTo VARCHAR(300), @MailCc VARCHAR(300), @Subject VARCHAR(300), @Body VARCHAR(4000)

	DECLARE CUR CURSOR FOR   (SELECT TOP (6) ID, MailTo, MailCc, Baslik, Icerik FROM ong.EMail(NOLOCK))

	OPEN CUR

	FETCH NEXT FROM CUR INTO @ID, @MailTo, @MailCc, @Subject, @Body

	WHILE @@FETCH_STATUS = 0
	BEGIN
		EXEC msdb.dbo.sp_send_dbmail
					@profile_name = 'GorevMail',
					@recipients = @MailTo,
					@copy_recipients= @MailCc,
					@subject = @Subject,
					@body=@Body,
					@body_format ='HTML',
					@importance ='HIGH'
        
		DELETE FROM ong.EMail WHERE ID=@ID

		FETCH NEXT FROM CUR INTO @ID, @MailTo, @MailCc, @Subject, @Body
	END

	CLOSE CUR
	DEALLOCATE CUR

END
GO
/****** Object:  StoredProcedure [ong].[KisiBazli_GunlukCalisma_Raporu]    Script Date: 26.01.2018 18:37:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [ong].[KisiBazli_GunlukCalisma_Raporu]
AS
BEGIN

    DECLARE @KulKodu VARCHAR(5), @AdSoyad VARCHAR(50),
	@Sorumlular VARCHAR(20), @Firma VARCHAR(20), @Proje VARCHAR(20), @Form VARCHAR(50),
	@Gorev VARCHAR(100), @Kaydeden VARCHAR(5), @KayitTarih SMALLDATETIME,
	@CalismaSure INT, @Calisma VARCHAR(4000), @YedekAlindi VARCHAR(5),
	@DosyaAdi VARCHAR(200), @Boyut VARCHAR(20),

	@MailTo VARCHAR(300), @MailCc VARCHAR(300), @Subject VARCHAR(300), 
	@Body VARCHAR(MAX), @Sayac INT,
	@ToplamSure INT 


	SET @MailTo = (SELECT TOP 1 MailTo FROM ong.Ayar)
	IF (SELECT TOP 1 MailCcTumunde FROM ong.Ayar) = 1
	Begin
	   SET @MailCc = (SELECT TOP 1 MailCc FROM ong.Ayar)
	End

	DECLARE CUR1 CURSOR FOR  (SELECT KulKodu, AdSoyad FROM ong.Kullanici(NOLOCK) 
	                          WHERE [Type]=0 AND YetkiKod<3)
	OPEN CUR1

	FETCH NEXT FROM CUR1 INTO @KulKodu, @AdSoyad

	WHILE @@FETCH_STATUS = 0
	BEGIN
	    
		SET @Sayac=0; 

		SET @ToplamSure=0;

	    SET @Body='<style type="text/css">
		table
		{
		    font-family:Arial,Tahoma,sans-serif;
            font-size:10pt;
		}
        table tr th
        {
           text-align:left;
        }
		table td
		{
		   border:1px solid #ddd;
		   padding:3px;
		} 
        </style>
		<table cellspacing="0" cellpadding="3" style="background-color: White; 
		border-color: #E7E7FF; border-width: 1px; border-style: solid; 
		width: 1085px; border-collapse: collapse;">
        <tr style="color: #F7F7F7; background-color: #4A3C8C; font-weight: bold;">
            <th style="width:70px">Firma</th>
            <th style="width:80px">Proje</th>
            <th style="width:100px">Form</th>
            <th style="width:180px">Görev</th>
            <th style="width:70px">Tarih</th>
            <th style="width:60px">Süre(dk)</th>
            <th style="width:440px">Çalışmalar </th>
			<th style="width:440px">Dosya Adı </th>
			<th style="width:440px">Boyut </th>
            <th style="width:80px">Yedek Alındımı</th>
        </tr>'

	    DECLARE CUR2 CURSOR FOR
		SELECT  GC.Sorumlular,G.Firma,G.Proje,G.Form,
				G.Gorev,GC.KayitTarih,GC.CalismaSure,GC.Calisma,
				A.DosyaAdi, A.Boyut, GC.Kaydeden,
				Case When A.ProjeID IS NULL Then 'Hayır' Else 'Evet' END AS YedekAlindi
		FROM ong.GorevCalisma(NOLOCK) GC
		INNER JOIN ong.Gorevler(NOLOCK) G ON GC.GorevID=G.ID AND  
		CONVERT(Date, GC.Tarih1, 104) = CONVERT(Date, GETDATE(), 104)
		LEFT JOIN (

			SELECT B.Firma,B.Proje, B.Kaydeden, MAX(B.DosyaAdi) DosyaAdi, 
			       MAX(B.Boyut) Boyut, MAX(B.ProjeID) ProjeID FROM 
			(SELECT DISTINCT ED.GorevID AS ProjeID, PF.Firma, PF.Proje, 
				ED.Kaydeden, CONVERT(Date, ED.KayitTarih, 104) AS KayitTarih,
				ED.DosyaAdi, ED.Boyut 
			FROM ong.EkDosya(NOLOCK) ED
			INNER JOIN ong.ProjeForm(NOLOCK) PF ON ED.GorevID=PF.ID AND ED.Tip=2 AND 
			CONVERT(Date, ED.KayitTarih, 104) = CONVERT(Date, GETDATE(), 104)
			WHERE ED.Kaydeden=@KulKodu) B
			GROUP BY B.Firma, B.Proje, B.Kaydeden
			
			) A
		ON A.Firma=G.Firma AND A.Proje=G.Proje AND A.Kaydeden=GC.Kaydeden
		WHERE GC.Kaydeden = @KulKodu 


		OPEN CUR2
	    FETCH NEXT FROM CUR2 INTO @Sorumlular, @Firma, @Proje, @Form, 
		                          @Gorev, @KayitTarih, @CalismaSure,
								  @Calisma, @DosyaAdi, @Boyut, @Kaydeden, @YedekAlindi
	    WHILE @@FETCH_STATUS = 0
	    BEGIN
		   
		   IF @Sayac%2 = 0 
		   BEGIN
			    SET @Body = @Body + '<tr style="color: #4A3C8C; background-color: #E7E7FF;">
				<td> <span style="display: inline-block;">'+@Firma+'</span> </td>
				<td> <span style="display: inline-block;">'+@Proje+'</span> </td>
				<td> <span style="display: inline-block;">'+@Form+'</span> </td>
				<td> <span style="display: inline-block;">'+@Gorev+'</span> </td>
				<td> <span style="display: inline-block;">'+CONVERT(VARCHAR(10),@KayitTarih,104)+'</span> </td>
				<td style="text-align:right"> <span style="display: inline-block;">'+
				                      CONVERT(VARCHAR(6),@CalismaSure)+'</span> </td>
				<td> <span style="display: inline-block;">'+@Calisma+'</span> </td>
				<td> <span style="display: inline-block;">'+@DosyaAdi+'</span> </td>
				<td> <span style="display: inline-block;">'+@Boyut+'</span> </td>'
				IF @YedekAlindi='Hayır'
				Begin
					SET @Body=@Body+'<td><span style="display: inline-block;
					color:red; font-weight:bold">'+@YedekAlindi+'</span> </td>
		    		</tr>';
				End
				Else
				Begin
				    SET @Body=@Body+'<td> <span style="display: inline-block;
					font-weight:bold">'+@YedekAlindi+'</span> </td>
		    		</tr>';
				End
		   END
		   ElSE
		   BEGIN
				 SET @Body = @Body + '<tr style="color: #4A3C8C; background-color: #F7F7F7;">
				<td> <span style="display: inline-block;">'+@Firma+'</span> </td>
				<td> <span style="display: inline-block;">'+@Proje+'</span> </td>
				<td> <span style="display: inline-block;">'+@Form+'</span> </td>
				<td> <span style="display: inline-block;">'+@Gorev+'</span> </td>
				<td> <span style="display: inline-block;">'+CONVERT(VARCHAR(10),@KayitTarih,104)+'</span> </td>
				<td style="text-align:right"> <span style="display: inline-block;">'+
				                      CONVERT(VARCHAR(6),@CalismaSure)+'</span> </td>
				<td> <span style="display: inline-block;">'+@Calisma+'</span> </td>
				<td> <span style="display: inline-block;">'+@DosyaAdi+'</span> </td>
				<td> <span style="display: inline-block;">'+@Boyut+'</span> </td>'
				IF @YedekAlindi='Hayır'
				Begin
					SET @Body=@Body+'<td><span style="display: inline-block;
					color:red; font-weight:bold">'+@YedekAlindi+'</span> </td>
		    		</tr>';
				End
				Else
				Begin
				    SET @Body=@Body+'<td> <span style="display: inline-block;
					font-weight:bold">'+@YedekAlindi+'</span> </td>
		    		</tr>';
				End
		   END

		    SET @Sayac=@Sayac+1;

			SET @ToplamSure = @ToplamSure + @CalismaSure;
		    
			FETCH NEXT FROM CUR2 INTO @Sorumlular, @Firma, @Proje, @Form, 
		                          @Gorev, @KayitTarih, @CalismaSure,
								  @Calisma, @DosyaAdi, @Boyut, @Kaydeden, @YedekAlindi
	    END

		CLOSE CUR2
	    DEALLOCATE CUR2

		--DELETE TOP (1) FROM ong.GorevCalisma
		SET @Body=@Body+'<tr style="color: #4A3C8C; background-color: #E7E7DD; font-weight: bold;">
            <th style="width:70px"></th>
            <th style="width:80px"></th>
            <th style="width:100px"></th>
            <th style="width:180px"></th>
            <th style="width:70px"></th>
            <th style="width:60px; text-align:right">'+CONVERT(VARCHAR(10),@ToplamSure/60)+
			                     ':'+CONVERT(VARCHAR(10),@ToplamSure%60) +'</th>
            <th style="width:440px"></th>
            <th style="width:80px"></th>
        </tr>';

		SET @Subject = CONVERT(VARCHAR(10),GETDATE(),104)+' '+@KulKodu+' Kullanıcısına ait çalışmalar';
	   
	    IF @Sayac > 0
		BEGIN
		      EXEC msdb.dbo.sp_send_dbmail
					@profile_name = 'GorevMail',
					@recipients = @MailTo,
					@copy_recipients = @MailCc,
					@subject = @Subject,
					@body=@Body,
					@body_format ='HTML',
					@importance ='HIGH'
        END
		

		FETCH NEXT FROM CUR1 INTO @KulKodu, @AdSoyad

	END

	CLOSE CUR1
	DEALLOCATE CUR1

  
END
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Tip 0 ise göreve aittir. Tip 1 ise projeye aittir. Tip 2 ise projenin backup dosyasıdır.' , @level0type=N'SCHEMA',@level0name=N'ong', @level1type=N'TABLE',@level1name=N'EkDosya', @level2type=N'COLUMN',@level2name=N'Tip'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Yetki Kodları kod tarafında Yetki classında tutulmaktadır. 0=>Staff  1=>Admin 2=>SysAdmin' , @level0type=N'SCHEMA',@level0name=N'ong', @level1type=N'TABLE',@level1name=N'Kullanici', @level2type=N'COLUMN',@level2name=N'YetkiKod'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Type 0 ise Bizim kullanıcımız demektir. Type 1 Müsteri Sorumlusu demektir.' , @level0type=N'SCHEMA',@level0name=N'ong', @level1type=N'TABLE',@level1name=N'Kullanici', @level2type=N'COLUMN',@level2name=N'Type'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Buraya firmanın kısa kodu gelecek.' , @level0type=N'SCHEMA',@level0name=N'ong', @level1type=N'TABLE',@level1name=N'Musteri', @level2type=N'COLUMN',@level2name=N'Firma'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Unvan alanında Sorumlu adı soyadı da tutuluyor.' , @level0type=N'SCHEMA',@level0name=N'ong', @level1type=N'TABLE',@level1name=N'Musteri', @level2type=N'COLUMN',@level2name=N'Unvan'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Araya ; koyarak birden fazla mailde tanımlanabilir.' , @level0type=N'SCHEMA',@level0name=N'ong', @level1type=N'TABLE',@level1name=N'Musteri', @level2type=N'COLUMN',@level2name=N'Email'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'FID = 0 ise Firma satırıdır. Değilse sorumlusu satırıdır ve FID bağlı olduğu firmanın ID sini verir(Aynı tabloda)' , @level0type=N'SCHEMA',@level0name=N'ong', @level1type=N'TABLE',@level1name=N'Musteri', @level2type=N'COLUMN',@level2name=N'FID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Bu alan Kullanici tablosundaki KulKodu alanından gelecek.' , @level0type=N'SCHEMA',@level0name=N'ong', @level1type=N'TABLE',@level1name=N'ProjeForm', @level2type=N'COLUMN',@level2name=N'Sorumlu'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Bu alan Firma tablosundaki Sorumlu alanından gelecek.' , @level0type=N'SCHEMA',@level0name=N'ong', @level1type=N'TABLE',@level1name=N'ProjeForm', @level2type=N'COLUMN',@level2name=N'KarsiSorumlu'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'PID=0 olanlar projedir.  Formlarda PID bağlı olduğu Projenin ID sini verir.(Aynı tabloda)' , @level0type=N'SCHEMA',@level0name=N'ong', @level1type=N'TABLE',@level1name=N'ProjeForm', @level2type=N'COLUMN',@level2name=N'PID'
GO
USE [master]
GO
ALTER DATABASE [OnikimGorev] SET  READ_WRITE 
GO
