using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace ub_frontend.ErrorPages
{
    public partial class _404 : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // Set the status code to 404
            Response.StatusCode = 404;
            Response.StatusDescription = "Not Found";
            Response.TrySkipIisCustomErrors = true;
        }
    }
}