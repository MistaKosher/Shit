using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Xml.Serialization;

namespace WPF_RSSListener
{

    [XmlRoot(ElementName = "rss")]
    public class RssClass
    {
        [XmlElement(ElementName ="channel")]
        public ChannelClass Channel { get; set; }

    }

    public class ChannelClass
    {
        [XmlElement(ElementName ="item")]
        public List<ItemClass> Items { get; set; }
    }

    public class ItemClass
    {
        [XmlElement(ElementName ="title")]
        public string Title { get; set; }

        [XmlElement(ElementName = "description")]
        public string Description { get; set; }

        [XmlElement(ElementName = "pubDate")]
        public string Date { get; set; }
    }

    public class RssSource
    {
        public List<RssChannel> Channels { get; set; }
    }
    public class RssChannel
    {
        public string Name { get; set; }

        public string URL { get; set; }

        public RssChannel(string name, string url)
        {
            this.Name = name;
            this.URL = url;
        }
    }
}
