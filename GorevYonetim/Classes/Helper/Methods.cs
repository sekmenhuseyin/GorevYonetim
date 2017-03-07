using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace GorevYonetim
{
    public static class Methods
    {
        /// <summary>
        /// Kendisine gönderilen değerler içinde bir tane bile null değer 
        /// <para>varsa false yoksa true döner.</para>
        /// </summary>
        public static bool NullKontrol(params object[] Degerler)
        {
            foreach (var value in Degerler)
            {
                if (value == null || value == DBNull.Value)
                    return false;

            }
            return true;
        }

        /// <summary>
        /// Gönderilen değerler içinde bir tane bile null veya boş değer varsa false yoksa true döner.
        /// <para>Tipi Int olanlar varsa 0 değeri gönderilirse bunu da boş sayacak. Örnek: Deger.ToInt32() </para>
        /// <para>Ayrıca [-] tire karakterini atarak bakar.</para>
        /// </summary>
        public static bool NullEmptyKontrol(params object[] Degerler)
        {
            foreach (var value in Degerler)
            {
                if (value == null || value == DBNull.Value
                    || value.ToString2().Trim2('-') == string.Empty)
                    return false;

                ///Tipi int olanlarda değeri -1 ise bunu boş sayacak
                if (value.GetType() == typeof(int) && value.ToInt32() == 0)
                    return false;
            }
            return true;
        }
    }
}