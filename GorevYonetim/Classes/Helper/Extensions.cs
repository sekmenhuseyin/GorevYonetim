using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
using System.Reflection;
using System.IO;

namespace GorevYonetim
{

    public static class Extensions
    {

        #region GENEL TİP DÖNÜŞÜMLERİ

        /// <summary>
        /// Convert a string to Integer, or return defaultValue
        /// </summary>
        public static int ToInt32(this object Deger, int defaultValue = 0)
        {
            try { return Convert.ToInt32(Deger); }
            catch { return defaultValue; }
        }

        /// <summary>
        /// Convert a string to Integer, or return defaultValue
        /// </summary>
        public static int ToInt32(this object Deger)
        {
            try { return Convert.ToInt32(Deger); }
            catch{  return 0;   }
        }

        /// <summary>
        /// Object değeri Int32 tipine dönüştürür. 
        /// <para>Dönüştüremezse null değer döndürür.</para>
        /// </summary>
        public static int? ToInt32Null(this object Deger)
        {
            try { return Convert.ToInt32(Deger); }
            catch { return null; }
        }


        /// <summary>
        /// Convert a string to Short, or return defaultValue
        /// </summary>
        public static short ToShort(this object ConverReqString)
        {
            try { return Convert.ToInt16(ConverReqString); }
            catch { return 0; }
        }

        /// <summary>
        /// Convert a string to Short, or return defaultValue
        /// </summary>
        public static short ToShort(this object ConverReqString, short defaultValue = 0)
        {
            try { return Convert.ToInt16(ConverReqString); }
            catch { return defaultValue; }
        }


        /// <summary>
        /// Convert a string to Long, or return defaultValue
        /// </summary>
        public static long ToLong(this object ConverReqString, long defaultValue = 0)
        {
            try { return long.Parse(ConverReqString.ToString()); }
            catch { return defaultValue; }
        }

        /// <summary>
        /// Convert a double to double or return defaltValue
        /// </summary>
        public static double ToDouble(this object ConverReqString, double defaultValue = 0.0)
        {
            try { return Convert.ToDouble(ConverReqString); }
            catch { return defaultValue; }
        }

        /// <summary>
        /// Convert a float to float or return defaltValue
        /// </summary>
        public static float ToFloat(this object ConverReqString, float defaultValue = 0.0f)
        {
            try { return Convert.ToSingle(ConverReqString); }
            catch { return defaultValue; }
        }

        /// <summary>
        /// Convert a decimal to decimal or return defaltValue
        /// </summary>
        public static decimal ToDecimal(this object ConverReqString, decimal defaultValue = 0.0M)
        {
            try { return Convert.ToDecimal(ConverReqString); }
            catch { return defaultValue; }
        }

        /// <summary>
        /// Convert a char to char or return defaltValue
        /// </summary>
        public static char ToChar(this object ConverReqString, char defaultValue = ' ')
        {
            try { return Convert.ToChar(ConverReqString); }
            catch { return defaultValue; }
        }

        /// <summary>
        /// İfadeyi DateTime tipine dönüştürmeye çalışır. Eğer dönüştüremezse 01.01.1970 değerini döndürür.
        /// <para> if(dönenDateTime == new DateTime(1970, 1, 1)) şeklinde </para>
        /// <para> doğru dönüştürüp dönüştüremediğini kontrol edebilirsiniz.</para>
        /// </summary>
        /// <param name="format"> Default format değeri 0 dır. 1 olursa tarihe o anki saat bilgisini ekler.</param>
        public static DateTime ToDatetime(this object ConverReqString, int format = 0)
        {
            DateTime deger;
            try
            {
                if (format == 1)
                {
                    deger = Convert.ToDateTime(ConverReqString);
                    deger = new DateTime(deger.Year, deger.Month, deger.Day, DateTime.Now.Hour, DateTime.Now.Minute, DateTime.Now.Second);
                }
                else
                {
                    deger = Convert.ToDateTime(ConverReqString);
                }

            }
            catch
            {
                deger = new DateTime(1970, 1, 1);
            }
            return deger;
        }

        /// <summary>
        /// İfadeyi DateTime tipine dönüştürmeye çalışır. Eğer dönüştüremezse null değer döndürür.
        /// <para> if(dönenDateTime == null) şeklinde </para>
        /// <para> doğru dönüştürüp dönüştüremediğini kontrol edebilirsiniz.</para>
        /// </summary>
        /// <param name="format"> Default format değeri 0 dır. 1 olursa tarihe o anki saat bilgisini ekler.</param>
        public static DateTime? ToDatetimeNull(this object ConverReqString, int format = 0)
        {
            DateTime? deger;
            try
            {
                if (format == 1)
                {
                    deger = Convert.ToDateTime(ConverReqString);
                    deger = new DateTime(deger.Value.Year, deger.Value.Month, deger.Value.Day, DateTime.Now.Hour, DateTime.Now.Minute, DateTime.Now.Second);
                }
                else
                {
                    deger = Convert.ToDateTime(ConverReqString);
                }

            }
            catch
            {
                deger = null;
            }

            return deger;
        }

        public static bool ToBool(this object ConverReqString)
        {
            bool deger = false;
            try
            {
                deger = Convert.ToBoolean(ConverReqString);
            }
            catch
            {
                deger = false;
            }
            return deger;
        }

        /// <summary>
        /// Convert a string to string or return defaltValue
        /// </summary>
        /// <param name="ConverReqString"></param>
        /// <returns></returns>
        public static string ToString2(this object Deger, string defaultValue = "")
        {
            try { return Convert.ToString(Deger).Trim(); }
            catch { return defaultValue; }
        }

        /// <summary>
        /// Gelen string ifadeyi ters çevirir. Örnek Can -> naC
        /// </summary>
        public static string ToReverse(this string Deger, string defaultValue = "?")
        {
            try
            {
                char[] dizi = Deger.ToCharArray();
                Array.Reverse(dizi);
                return new string(dizi);
            }
            catch { return defaultValue; }
        }


        public static object IfNullGetValue(this object Deger)
        {
            if (Deger == DBNull.Value || Deger == null)
            {
                return "";
            }
            else
                return Deger;
        }


        /// <summary>
        /// ? operatöründe kullanılan karşılaştırmayı yapar. 
        /// İlk parametre hangi değerle karşılaştırıldığını gösterir.
        /// Eğer sonuc true ise ikinci parametre değilse üçüncü parametre döner.
        /// </summary>
        public static string IfElse(this object Deger, object EsitKosulu, string Esitse, string Degilse)
        {
            if (Deger.Equals(EsitKosulu))
                return Esitse;
            else
                return Degilse;
        }

        /// <summary>
        /// Int tipindeki değerleri DateTime tipine dönüştürür.
        /// </summary>
        public static DateTime IntToDateTime(this int Deger)
        {
            DateTime date = new DateTime(1899, 12, 30);
            date = date.AddDays(Deger);
            return date;
        }

        /// <summary>
        /// DateTime tipindeki saat kısmını alıp int olarak saat değeri üretir.
        /// </summary>
        public static int TimeInt(this DateTime DateSaat)
        {
            int saat = 0;
            if (DateSaat.Hour >= 1)
            {
                saat += DateSaat.Hour * 60 * 60;
            }
            if (DateSaat.Minute >= 1)
            {
                saat += DateSaat.Minute * 60;
            }
            if (DateSaat.Second > 0)
            {
                saat += DateSaat.Second;
            }
            return saat;
        }

        /// <summary>
        /// IEnumerable tipleri DataTable'a dönüştürür.  Örnek List<Class> => DataTable
        /// </summary>
        public static DataTable ToDataTable<T>(this IEnumerable<T> collection)
        {
            DataTable newDataTable = new DataTable();
            Type impliedType = typeof(T);
            PropertyInfo[] _propInfo = impliedType.GetProperties();
            foreach (PropertyInfo pi in _propInfo)
            {
                if (!pi.PropertyType.IsGenericType)
                    newDataTable.Columns.Add(pi.Name, pi.PropertyType);
                else
                    newDataTable.Columns.Add(pi.Name, pi.PropertyType.GetGenericArguments()[0]);
            }

            foreach (T item in collection)
            {
                DataRow newDataRow = newDataTable.NewRow();
                newDataRow.BeginEdit();
                foreach (PropertyInfo pi in _propInfo)
                {
                    if (pi.GetValue(item, null).IsNotNull())
                        newDataRow[pi.Name] = pi.GetValue(item, null);
                    else
                        newDataRow[pi.Name] = DBNull.Value;
                }
                newDataRow.EndEdit();
                newDataTable.Rows.Add(newDataRow);
            }

            newDataTable.AcceptChanges();
            return newDataTable;
        }
        #endregion   // GENEL TİP DÖNÜŞÜMLERİ

        #region TİPLERDE BOŞLUK NULL KONTROLLERİ
        /// <summary>
        /// Null ve DBNULL kontrolü yapar 
        /// </summary>
        public static bool IsNull(this object value)
        {
            if (value == DBNull.Value || value == null)
                return true;
            else
                return false;
        }

        /// <summary>
        /// Null ve DBNULL değilse true döner
        /// </summary>
        public static bool IsNotNull(this object value)
        {
            if (value == DBNull.Value || value == null)
                return false;
            else
                return true;
        }

        /// <summary>
        /// Null, DBNULL ve String.Empty ise true döner
        /// </summary>
        public static bool IsNullEmpty(this object value)
        {
            if (value == null) return true;
            if (value == DBNull.Value) return true;
            if (value.ToString().Trim() == string.Empty) return true;
            return false;
        }

        /// <summary>
        /// Null, DBNULL ve String.Empty ise girilen string değeri döner.
        /// <para>Değilse kendi değerinin string karşılığını döner.</para>
        /// </summary>
        public static string IsNullEmptySetValue(this object value,string retDeger)
        {
            if (value == null) return retDeger;
            if (value == DBNull.Value) return retDeger;
            if (value.ToString().Trim() == string.Empty) return retDeger;

            return value.ToString2();
        }

        /// <summary>
        /// Null, DBNULL ve String.Empty değilse true döner
        /// </summary>
        public static bool IsNotNullEmpty(this object value)
        {
            if (value == null) return false;
            if (value == DBNull.Value) return false;
            if (value.ToString().Trim() == string.Empty) return false;
            return true;
        }

        /// <summary>
        /// Null, DBNULL ve String.Empty değilse true döner
        /// <para>Belirtilen char değeri atıldıktan sonra bakar.</para>
        /// </summary>
        public static bool IsNotNullEmptyTrim(this object value, char trimChar)
        {
            if (value == null) return false;
            if (value == DBNull.Value) return false;
            if (value.ToString().Replace(trimChar,' ').Trim() == string.Empty) return false;
            return true;
        }
        #endregion  // TİPLERDE BOŞLUK NULL KONTROLLERİ


        public static object ToType<T>(this object obj, T type)
        {
            //create instance of T type object:
            var tmp = Activator.CreateInstance(Type.GetType(type.ToString()));

            //loop through the properties of the object you want to covert:          
            foreach (PropertyInfo pi in obj.GetType().GetProperties())
            {
                try
                {
                    //get the value of property and try 
                    //to assign it to the property of T type object:
                    tmp.GetType().GetProperty(pi.Name).SetValue(tmp,
                                              pi.GetValue(obj, null), null);
                }
                catch { }
            }

            //return the T type object:         
            return tmp;
        }

        /// <summary>
        /// Aynı tipteki nesnenin değerlerini kendine set eder
        ///<para>Örnek Kullanım : gorev1.Set(gorev2,"ID"); </para> 
        ///<para>Bunun anlamı gorev1=gorev2; gibi olur ID değeri set edilmez </para> 
        /// </summary>
        public static void Set(this object obj, object deger, params string[] istisnalar)
        {

            foreach (PropertyInfo pi in deger.GetType().GetProperties())
            {
                if (istisnalar != null)
                {
                    if (istisnalar.Contains(pi.Name))
                        continue;
                }

                try
                {
                    deger.GetType().GetProperty(pi.Name).SetValue(obj, pi.GetValue(deger, null), null);
                }
                catch { }
            }
        }
    
        /// <summary>
        /// Propertisi olan nesnelerin propertisini default değerler verir.
        /// </summary>
        /// <param name="Istisnalar">Default değeri set edilmeyecek propertyleri belirtmek gerekiyor.</param>
        public static void DefaultValueSet(this object Deger, params string[] Istisnalar)
        {
            foreach (var pi in Deger.GetType().GetProperties())
            {
                if (Istisnalar.Contains(pi.Name))
                    continue;

                if (pi.PropertyType == typeof(string))
                    pi.SetValue(Deger, "", null);
                else if (pi.PropertyType == typeof(decimal))
                    pi.SetValue(Deger, 0.0m, null);
                else if (pi.PropertyType == typeof(int) || pi.PropertyType == typeof(short) ||
                         pi.PropertyType == typeof(Single) || pi.PropertyType == typeof(double))
                    pi.SetValue(Deger, (short)0, null);
            }
        }

        #region Extensions - 2  21 Ekim 2014
        /// <summary>
        /// <para>Bu extension Exception tiplerine gelerek hatayı txt dosyasına yazar. </para>
        /// <para>Hatayı uygulamanın kök dizinindeki Hata.txt dosyasına yazar. Eğer bu dosya yoksa </para>
        /// <para>hatayı yazmaz. Burada otomatik dosya oluşturmayı bilinçli olarak yapmadık.  </para>
        /// </summary>
        public static bool HataYaz(this Exception hata)
        {
            try
            {
                StreamWriter yaz = new StreamWriter(AppDomain.CurrentDomain.BaseDirectory+"\\Hata.txt", true);
                yaz.WriteLine("Hata Oluştu  --> Tarih: {0}", DateTime.Now);
                yaz.WriteLine("Kullanıcı Kodu : {0} ", Global.Kullanici.ToStringProp("KulKodu"));
                yaz.WriteLine("Hata Kaynağı   : {0}", hata.Source);
                yaz.WriteLine("Hata Mesajı    : {0}", hata.Message);
                yaz.WriteLine("Hata Detayı    : {0}", hata.StackTrace);
                yaz.WriteLine("\n-----------------------------------------------------------------------------\n");
                yaz.Close();
                
                return true;
            }
            catch(Exception ex)
            {
                return false;
                /*Bilinçli boş bırakıldı*/
            }
        }

        /// <summary>
        /// <para>Bu extension ilgili class nesnesinin belirttiği property değerini ToString2() metoduyla geri döner.</para>
        /// <para>Hata oluşursa geriye string.Empty döner.</para>
        /// </summary>
        /// <param name="propertName">Görmek istediğiniz property nin Name değerini girin.</param>
        /// <returns></returns>
        public static string ToStringProp(this object obje,string propertName)
        {
            try
            {
                return obje.GetType().GetProperty(propertName).GetValue(obje, null).ToString2();
            }
            catch
            {
                return string.Empty;
            }
        }

        /// <summary>
        /// Bu metod hem trim işlevini yapar hemde kodda oluşan "\n" leri temizler. 
        /// </summary>
        /// <param name="charTrim">
        /// Extradan belirtilen char tipindeki değerlerde ifadeden atılır.
        /// </param>
        public static string Trim2(this string Str, params char[] charTrim)
        {
            Str = Str.Trim();
            Str = Str.Replace("\n", " ");
            if (charTrim.Length > 0)
            {
                Str = Str.Trim(charTrim);
            }
            return Str;
        }

        #endregion 


     


    }
}
