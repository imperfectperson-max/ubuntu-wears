using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace ub_frontend
{
    public partial class Terms : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // Set the last updated date to current date
                litLastUpdated.Text = DateTime.Now.ToString("MMMM d, yyyy");
            }
        }
    }
}