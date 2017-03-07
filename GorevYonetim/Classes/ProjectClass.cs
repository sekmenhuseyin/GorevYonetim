using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using GorevYonetim.App_Data;

namespace GorevYonetim
{

    #region LinqSql Extra Classes
    public class ProjeFormSetEx
    {
        public int Tip { get; set; }
        public string ProjeForm { get; set; }
    }

    public class ProjeFormEx : ProjeForm
    {
        public string Klavuz { get; set; }
    }

    public class GorevlerEx : Gorevler
    {
        public string DurumAcikla { get; set; }
        public string OncelikAcikla { get; set; }
    }

    public class GorevlerMin 
    {
        public int ID { get; set; }
        public string Gorev { get; set; }
        public string Proje { get; set; }
    }

    public class GorevCalismaEx : GorevCalisma
    {
        public string Firma { get; set; }
        public string Proje { get; set; }
        public string Form { get; set; }
        public string Gorev { get; set; }
        public string Aciklama { get; set; }
        public string CalismaTarihStr { get; set; }
        public int ListeID { get; set; }
    }

    public class CalismaDetay
    {
        public int ID { get; set; }
        public string Gorev { get; set; }
        public string Aciklama { get; set; }
        public string Calisma { get; set; }
    }

    public class GorevHareketEx : GorevHareket
    {
        public int ListeID { get; set; }
        public string KayitTarihStr { get; set; }
        public string TahBitisTarihStr { get; set; }
        public DateTime GorevKayitTarih { get; set; }
        public string GorevKayitTarihStr { get; set; }
    }

    public class EkDosyaEx : EkDosya
    {
        public string KayitTarihStr { get; set; }
    }

    public class GorevHareketDetay
    {
        public int ID { get; set; }
        public string Gorev { get; set; }
        public string Aciklama { get; set; }
        public string DAciklama { get; set; }
    }

    public class FirmaMin
    {
        public int ID { get; set; }
        public string Firma { get; set; }
    }

    public class KullaniciEx : Kullanici
    {
        public string Aciklama { get; set; }
        private short kod;
        public short Kod
        {
            get
            {
                return kod;
            }
            set
            {
                kod = value;
                Aciklama = Yetki.GetYetkiAciklama(kod);
            }
        }
    }
    #endregion LinqSql Extra Classes SON

    public class Yetki
    {
        private static List<Yetki> YetkiList = new List<Yetki>();
        public short Kod { get; set; }
        public string Aciklama { get; set; }

        public Yetki(short kod,string aciklama)
        {
            Kod = kod;
            Aciklama = aciklama;
        }

        public static List<Yetki> YetkileriGetir()
        {
            YetkiList.Clear();
            YetkiList.Add(new Yetki(0, "Reader"));
            YetkiList.Add(new Yetki(1, "Customer"));
            YetkiList.Add(new Yetki(2, "User"));
            YetkiList.Add(new Yetki(3, "Admin"));
            //YetkiList.Add(new Yetki(3, "SysAdmin")); 
            return YetkiList;
        }

        public static string GetYetkiAciklama(short kod)
        {
            switch (kod)
            {
                case 0:
                    return "Reader";
                case 1:
                    return "Customer";
                case 2:
                    return "User";
                case 3:
                    return "Admin";
                default:
                    return "Reader";
            }
        }
    }

    public class Durum
    {
        private static List<int> GorevDurumlari = new List<int>();
        private static List<Durum> DurumList = new List<Durum>();
        public short Kod { get; set; }
        public string Aciklama { get; set; }

        public Durum(short kod, string aciklama)
        {
            Kod = kod;
            Aciklama = aciklama;
        }

        public static List<Durum> GenelDurumlariGetir()
        {
            DurumList.Clear();
            DurumList.Add(new Durum(0, "Aktif Görevler (*)"));
            DurumList.Add(new Durum(1, "Devam Eden Görevler"));
            DurumList.Add(new Durum(2, "Onaylanmış Görevler"));
            DurumList.Add(new Durum(3, "Biten Görevler"));
            DurumList.Add(new Durum(4, "Tüm Görevler"));
            return DurumList;
        }

        public static List<int> GorevDurumlariGetir(short kod)
        {
            switch (kod)
            {
                case 0:
                    return GorevDurumlari = new List<int>() { 0, 1, 2, 3, 4, 5, 6, 8 }; ///Aktif
                case 1:
                    return GorevDurumlari = new List<int>() { 1, 2, 4, 5 }; ///Devam Edenler
                case 2:
                    return GorevDurumlari = new List<int>() { 7 }; ///Onaylananlar
                case 3:
                    return GorevDurumlari = new List<int>() { 6 }; ///Bitenler
                case 4:
                    return GorevDurumlari = new List<int>() { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9 }; ///Tüm Görevler
                default:
                    return GorevDurumlari = new List<int>();
            }
        }


    }
   
}