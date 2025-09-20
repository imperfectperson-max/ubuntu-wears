using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using ub_frontend.UbuntuWearsReference;

namespace ub_frontend
{
    public partial class _Default : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadFeaturedProducts();
            }
        }

        protected override void RaisePostBackEvent(IPostBackEventHandler source, string eventArgument)
        {
            if (!string.IsNullOrEmpty(eventArgument))
            {
                if (eventArgument.StartsWith("AddToCart|"))
                {
                    int productId = Convert.ToInt32(eventArgument.Split('|')[1]);
                    AddToCart(productId);
                }
                else if (eventArgument.StartsWith("AddToWishlist|"))
                {
                    int productId = Convert.ToInt32(eventArgument.Split('|')[1]);
                    AddToWishlist(productId);
                }
                else
                {
                    base.RaisePostBackEvent(source, eventArgument);
                }
            }
            else
            {
                base.RaisePostBackEvent(source, eventArgument);
            }
        }

        private void LoadFeaturedProducts()
        {
            using (var client = new UbuntuWearsServiceClient())
            {
                var response = client.GetFeaturedProducts(8);
                if (response.Success && response.Data != null)
                {
                    StringBuilder sb = new StringBuilder();

                    foreach (var product in response.Data)
                    {
                        // Use placeholder image if ImageURL is null or empty
                        string imageUrl = !string.IsNullOrEmpty(product.ImageURL)
                            ? product.ImageURL
                            : "https://via.placeholder.com/300x400?text=No+Image";

                        string outOfStockClass = product.Stock == 0 ? "out-of-stock" : "";
                        string outOfStockDisabled = product.Stock == 0 ? "disabled" : "";

                        string productHtml = $@"
    <div class='product-tile'>
        <div class='product-image'>
            <a href='ProductDetail.aspx?id={product.ProductID}'>
                <img src='{imageUrl}' alt='{HttpUtility.HtmlEncode(product.Name)}' />
            </a>
        </div>
        <div class='product-info'>
            <a href='ProductDetail.aspx?id={product.ProductID}' style='text-decoration: none; color: inherit;'>
                <h3>{HttpUtility.HtmlEncode(product.Name)}</h3>
            </a>
            <p class='product-category'>{HttpUtility.HtmlEncode(product.Category)}</p>
            <p class='product-price'>R{product.Price:F2}</p>
            <div class='product-actions'>
                <button type='button' class='add-to-cart-btn {outOfStockClass}' {outOfStockDisabled} 
                        data-id='{product.ProductID}'>
                    <i class='fas fa-shopping-cart'></i> 
                    {(product.Stock == 0 ? "Out of Stock" : "Add to Cart")}
                </button>
                <button type='button' class='wishlist-btn' data-id='{product.ProductID}'>
                    <i class='fas fa-heart'></i>
                </button>
            </div>
        </div>
    </div>";

                        sb.Append(productHtml);
                    }

                    productsGrid.InnerHtml = sb.ToString();
                }
                else
                {
                    productsGrid.InnerHtml = @"
                        <div class='no-products'>
                            <i class='fas fa-box-open'></i>
                            <h3>No featured products available</h3>
                            <p>Check back later for new arrivals</p>
                        </div>";
                }
            }
        }

        private void AddToCart(int productId)
        {
            if (Session["UserID"] == null)
            {
                Response.Redirect("~/Login.aspx?returnUrl=" + Server.UrlEncode(Request.Url.ToString()));
                return;
            }

            int userId = Convert.ToInt32(Session["UserID"]);

            using (var client = new UbuntuWearsServiceClient())
            {
                var response = client.AddToCart(userId, productId, 1);
                if (response.Success)
                {
                    SiteMaster master = (SiteMaster)Master;
                    master.UpdateCartCount();

                    ScriptManager.RegisterStartupScript(this, GetType(), "AddToCartSuccess",
                        "showNotification('Product added to cart successfully!', 'success');", true);
                }
                else
                {
                    ScriptManager.RegisterStartupScript(this, GetType(), "AddToCartError",
                        $"showNotification('Error: {response.ErrorMessage}', 'error');", true);
                }
            }
        }

        private void AddToWishlist(int productId)
        {
            if (Session["UserID"] == null)
            {
                Response.Redirect("~/Login.aspx?returnUrl=" + Server.UrlEncode(Request.Url.ToString()));
                return;
            }

            int userId = Convert.ToInt32(Session["UserID"]);

            using (var client = new UbuntuWearsServiceClient())
            {
                var response = client.AddToWishlist(userId, productId);
                if (response.Success)
                {
                    ScriptManager.RegisterStartupScript(this, GetType(), "AddToWishlistSuccess",
                        "showNotification('Product added to wishlist!', 'success');", true);
                }
                else
                {
                    ScriptManager.RegisterStartupScript(this, GetType(), "AddToWishlistError",
                        $"showNotification('Error: {response.ErrorMessage}', 'error');", true);
                }
            }
        }
    }
}