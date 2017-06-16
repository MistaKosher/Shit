using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.IO;

namespace Figures
{
    class Program
    {
        static void Main(string[] args)
        {
            List<Figure> fig = new List<Figure>();
            if (!File.Exists("fig.txt"))
            {
                Console.WriteLine("File not exist");
                Console.ReadLine();
                return;
            }

            string str;

            using (StreamReader sr = new StreamReader("fig.txt"))
            {
                str = sr.ReadToEnd();
            }

            string[] pars = str.Split('\n');
            int i = 0;
            var var_tmp = new {name = "pidor", surname = "lisyi", dick  = 45.9};

            Console.WriteLine(var_tmp.name + " " + var_tmp.surname + " " + var_tmp.dick);
            while (i < pars.Length)
            {
                switch (pars[i][0])
                {
                    case 'r':
                        {
                            fig.Add(new Rectangle(pars[i], Convert.ToDouble(pars[++i]), Convert.ToDouble(pars[++i])));
                            i++;
                            break;
                        }
                    case 'c':
                        {
                            fig.Add(new Circle(pars[i], Convert.ToDouble(pars[++i])));
                            i++;
                            break;
                        }
                    default:
                        {
                            Console.WriteLine("default");
                            i++;
                            break;
                        }
                }
            }

            foreach (Figure f in fig)
                f.show();
            Console.ReadLine();
        }
    }

    public abstract class Figure
    {
        private string name;

        public string Name
        {
            get { return name; }
            set { name = value;}
        }

        public abstract double square();
        public abstract double perimetr();
        public abstract void show();

    }

    public class Rectangle : Figure
    {
        private double a, b;

        public Rectangle(string name, double a, double b)
        {
            this.Name = name;
            this.a = a;
            this.b = b;
        }

        private Rectangle() { }            

        public override double square()
        {
            return a * b;
        }

        public override double perimetr()
        {
            return (a + b) * 2;
        }
        public override void show()
        {
            Console.WriteLine(Name);
            Console.WriteLine("Периметр:" + perimetr());
            Console.WriteLine("Площадь:" + square());
        }
    }

    public class Circle : Figure
    {
        private double r;

        public Circle(string name, double r)
        {
            this.Name = name;
            this.r = r;
        }

        private Circle() { }

        public override double square()
        {
            return Math.PI*r*r;
        }

        public override double perimetr()
        {
            return Math.PI*r*2;
        }
        public override void show()
        {
            Console.WriteLine(Name);
            Console.WriteLine("Длина окружности:" + perimetr());
            Console.WriteLine("Площадь:" + square());
        }
    }

    public class Triangle : Figure
    {
        private double r;

        public Triangle(string name, double r)
        {
            this.Name = name;
            this.r = r;
        }

        private Triangle() { }

        public override double square()
        {
            return Math.PI * r * r;
        }

        public override double perimetr()
        {
            return Math.PI * r * 2;
        }
        public override void show()
        {
            Console.WriteLine(Name);
            Console.WriteLine("Периметр:" + perimetr());
            Console.WriteLine("Площадь:" + square());
        }
    }
}
