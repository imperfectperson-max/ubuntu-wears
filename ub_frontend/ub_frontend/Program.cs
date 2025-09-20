using System;
using System.Windows.Forms;

namespace ub_frontend
{
    static class Program
    {
        [STAThread]
        static void Main()
        {
            Application.EnableVisualStyles();
            Application.SetCompatibleTextRenderingDefault(false);
            Application.Run(new MainForm()); // replace with your form
        }
    }
}
