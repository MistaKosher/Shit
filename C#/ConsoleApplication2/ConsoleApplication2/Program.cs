using System;
using System.Collections.Generic;
using System.Text;
using System.Threading;

namespace ConsoleApplication2
{
    class Program
    {
        private static int pnt = 1;
        
        private static void Threading()
        {
            Thread tr1 = new Thread(Proc("A"));
            //Thread tr2 = new Thread(Proc("B"));
            //Thread tr3 = new Thread(Proc("C"));

            tr1.Start();
            //tr2.Start();
            //tr3.Start();
            
            tr1.Join();
            //tr2.Join();
            //tr3.Join();

           
        }

        private static void Proc(string flag)
        {
            for (int i = 1; i < 10; i++)
            {
                Console.Write(" " + flag + i.ToString() + " ");
            }
        }
        static void Main(string[] args)
        {
            Proc("B");
            //Threading();
            Console.ReadLine();
        }
    }
}
