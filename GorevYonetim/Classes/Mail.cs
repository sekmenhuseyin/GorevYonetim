using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Mail;
using System.Text;
using System.Text.RegularExpressions;
using System.Web;

namespace GorevYonetim
{
    public static class Mail
    {
        /// <summary>
        /// Mail Adresi geçerli mi değilmi bunu regexle kontrol eder. Geçerli ise true döner.
        /// </summary>
        public static bool MailGecerlimi(string emailaddress)
        {
            return Regex.IsMatch(emailaddress, @"^([\w-\.]+)@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.)|(([\w-]+\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})(\]?)$");
        }
        
        public static bool Gonder(MailType mail)
        {
            try
            {
                MailMessage Message = new MailMessage();
                MailAddress fromAddress = new MailAddress("gorev@12mconsulting.com.tr", "12M Bilgisayar");

                Message.From = fromAddress;
                foreach (string str in mail.Adresler)
                    Message.To.Add(str);
                Message.SubjectEncoding = Encoding.UTF8;
                Message.Subject = mail.Baslik;
                Message.BodyEncoding = Encoding.UTF8;
                Message.Body = mail.Icerik;
                Message.IsBodyHtml = true;

                SmtpClient smtp = new SmtpClient();
                smtp.Port = 587;
                smtp.Host = "mail.12mconsulting.com.tr";
                smtp.EnableSsl = false;
                smtp.Credentials = new System.Net.NetworkCredential("gorev@12mconsulting.com.tr", "Birikim12");
                smtp.Send(Message);
                Message.Dispose();
                return true;
            }
            catch(Exception ex)
            {
                string mesaj = "Mail Gönderim hatası ! " + ex.Message;
                Exception hata = new Exception(mesaj);
                throw hata;    
            }
        }
    }

    public class MailType
    {
        public string Baslik { get; set; }
        public string Icerik { get; set; }
        public List<string> Adresler { get; set; }

        public MailType(string baslik, string icerik, params string[] adresler)
        {
            Baslik = baslik;
            Icerik = icerik;
            Adresler = adresler.ToList();
        }
    }

}