using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using System.Net;
using System.IO;
using System.Collections;

namespace BitX_ticket
{
    public partial class Form1 : Form
    {
        public Form1()
        {
            InitializeComponent();
        }

        private void btnGenerate_Click(object sender, EventArgs e)
        {
            string url = "https://bitx.co.za/api/1/BTCZAR/ticker";
            WebRequest webGETURL;
            webGETURL = WebRequest.Create(url);

            try
            {
                Stream objStream = webGETURL.GetResponse().GetResponseStream();

                StreamReader reader = new StreamReader(objStream);

                string sLine = "";
                int i = 0;

                //while (sLine != null)
                //{
                i++;
                sLine = reader.ReadLine();
                sLine = sLine.Replace("\"", string.Empty);
                string[] info = new string[6];
                info = sLine.Split(',');

                //timestamp
                info[0] = info[0].Trim();
                info[0] = info[0].Substring((info[0].IndexOf(":")) + 1);
                info[0] = FromUnixTime(long.Parse(info[0]));

                for (int element = 1; element < 6; element++)
                {
                    info[element] = info[element].Trim();
                    int index = (info[element].IndexOf(":")) + 1;
                    info[element] = info[element].Substring(index);
                }

                if (sLine != null)
                {
                    textBox1.Text = (info[0]);
                    textBox2.Text = (info[1]);
                    textBox3.Text = (info[2]);
                    textBox4.Text = (info[3]);
                    textBox5.Text = (info[4]);
                    textBox6.Text = (info[5]);
                }
                //Console.WriteLine("{0}:{1} line", i, sLine);
                //}
            }
            catch (WebException ex)
            {
                MessageBox.Show(ex.Message);
            }
        }

        public string FromUnixTime(long unixTime)
        {
            var epoch = new DateTime(1970, 1, 1, 0, 0, 0, DateTimeKind.Utc);
            return epoch.AddMilliseconds(unixTime + 3600000).ToString();
        }
    }
}
