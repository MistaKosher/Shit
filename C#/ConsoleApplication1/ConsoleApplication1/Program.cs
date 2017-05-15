using System;
using System.Collections.Generic;
using System.Text;
using System.Collections;
using System.Data;
using System.Data.OleDb;

namespace ConsoleApplication1
{
    class Program
    {
        static void Main(string[] args)
        {
            OleDbConnection dbconn = new OleDbConnection("provider=oraoledb.oracle;data source=10.48.115.212/j48cdb;user id=j48_data_centr;password=CegthGjkmpjdfntkm");
            dbconn.Open();
            OleDbCommand cmd = new OleDbCommand("select t.* from srv_usr_list t where t.last_name = 'Петров'");
            cmd.Connection = dbconn;

            OleDbDataReader reader = cmd.ExecuteReader();
           // DataTable d = new DataTable(cmd.);
            //d.Clear();
            while (reader.Read())
                Console.WriteLine(reader[1]);
            dbconn.Close();
        }
    }
}
