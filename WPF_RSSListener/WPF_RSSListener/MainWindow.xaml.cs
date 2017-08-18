using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Net;
using System.Text;
using System.Threading;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Navigation;
using System.Windows.Shapes;
using System.Xml.Serialization;

namespace WPF_RSSListener
{
    /// <summary>
    /// Логика взаимодействия для MainWindow.xaml
    /// </summary>
    public partial class MainWindow : Window
    {
        public MainWindow()
        {
            InitializeComponent();
            AddChannels();
        }

        private void Button_Click(object sender, RoutedEventArgs e)
        {
            ReadData();
            Thread.Sleep(1000);
        }
        
        RssSource source = new RssSource();

        public void AddChannels()
        {
            source.Channels = new List<RssChannel>();

            source.Channels.Add(new RssChannel("Российская газета", "https://rg.ru/xml/index.xml"));
            source.Channels.Add(new RssChannel("Известия", "https://iz.ru/xml/rss/all.xml"));
            source.Channels.Add(new RssChannel("Life", "https://life.ru/xml/feed.xml?hashtag=%D0%BD%D0%BE%D0%B2%D0%BE%D1%81%D1%82%D0%B8"));

            foreach (RssChannel ch in source.Channels)
                listbox1.Items.Add(ch.Name.ToString());
        }

        private async void ReadData()
        {

            Encoding enc = Encoding.GetEncoding(1251);
            WebClient web = new WebClient();
            string s = await web.DownloadStringTaskAsync(new Uri(source.Channels[listbox1.SelectedIndex].URL));

            XmlSerializer xml = new XmlSerializer(typeof(RssClass));
            RssClass res = xml.Deserialize(new MemoryStream(Encoding.GetEncoding(1251).GetBytes(s))) as RssClass;

            TextBlock textblock1 = new TextBlock();
            data_grid.ItemsSource = res.Channel.Items;

        }
    }
}
