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
    public partial class ProductDetail : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (!string.IsNullOrEmpty(Request.QueryString["id"]))
                {
                    int productId;
                    if (int.TryParse(Request.QueryString["id"], out productId))
                    {
                        LoadProductDetail(productId);
                        LoadRelatedProducts(productId);
                    }
                    else
                    {
                        ShowNotFound();
                    }
                }
                else
                {
                    ShowNotFound();
                }
            }

            // Handle postback events
            string eventTarget = Request["__EVENTTARGET"];
            string eventArgument = Request["__EVENTARGUMENT"];

            if (!string.IsNullOrEmpty(eventTarget))
            {
                if (eventTarget == "AddToCart" && !string.IsNullOrEmpty(eventArgument))
                {
                    var args = eventArgument.Split('|');
                    if (args.Length == 2)
                    {
                        AddToCart(Convert.ToInt32(args[0]), Convert.ToInt32(args[1]));
                    }
                }
                else if (eventTarget == "AddToWishlist" && !string.IsNullOrEmpty(eventArgument))
                {
                    AddToWishlist(Convert.ToInt32(eventArgument));
                }
            }
        }

        private void LoadProductDetail(int productId)
        {
            using (var client = new UbuntuWearsServiceClient())
            {
                var response = client.GetProduct(productId);
                if (response.Success && response.Data != null)
                {
                    var product = response.Data;
                    RenderProductDetail(product);
                    Page.Title = $"Ubuntu Wears - {product.Name}";
                }
                else
                {
                    ShowNotFound();
                }
            }
        }

        private void RenderProductDetail(ProductEntity product)
        {
            StringBuilder sb = new StringBuilder();

            string imageUrl = !string.IsNullOrEmpty(product.ImageURL)
                ? product.ImageURL
                : "https://via.placeholder.com/500x600?text=No+Image";

            string outOfStockHtml = product.Stock == 0
                ? @"<div class='out-of-stock'>
                    <i class='fas fa-exclamation-circle'></i> This product is currently out of stock
                   </div>"
                : "";

            string addToCartDisabled = product.Stock == 0 ? "disabled" : "";

            string productHtml = $@"
                <div class='product-detail'>
                    <div class='product-image-container'>
                        <img src='{imageUrl}' alt='{HttpUtility.HtmlEncode(product.Name)}' class='product-main-image' />
                    </div>
                    
                    <div class='product-info'>
                        <h1 class='product-title'>{HttpUtility.HtmlEncode(product.Name)}</h1>
                        <p class='product-category'>{HttpUtility.HtmlEncode(product.Category)}</p>
                        <p class='product-price'>R{product.Price:F2}</p>
                        
                        {outOfStockHtml}
                        
                        <p class='product-description'>{HttpUtility.HtmlEncode(product.Description)}</p>
                        
                        <div class='product-meta'>
                            <div class='meta-item'>
                                <i class='fas fa-box'></i>
                                <span>Stock: {product.Stock}</span>
                            </div>
                            <div class='meta-item'>
                                <i class='fas fa-calendar'></i>
                                <span>Added: {product.DateAdded.ToString("dd MMMM yyyy")}</span>
                            </div>
                            <div class='meta-item'>
                                <i class='fas fa-tag'></i>
                                <span>SKU: UW{product.ProductID:0000}</span>
                            </div>
                        </div>
                        
                        <div class='product-actions'>
                            <div class='quantity-selector'>
                                <button type='button' class='quantity-btn' onclick='updateQuantity(-1)'>-</button>
                                <input type='text' id='txtQuantity' class='quantity-input' value='1' min='1' max='10' />
                                <button type='button' class='quantity-btn' onclick='updateQuantity(1)'>+</button>
                            </div>
                            
                            <button type='button' class='add-to-cart-btn' {addToCartDisabled} 
                                    onclick='addToCart({product.ProductID})'>
                                {(product.Stock == 0 ? "Out of Stock" : "Add to Cart")}
                            </button>
                            
                            <button type='button' class='wishlist-btn' onclick='addToWishlist({product.ProductID})'>
                                <i class='fas fa-heart'></i>
                            </button>
                        </div>
                    </div>
                </div>";

            sb.Append(productHtml);
            productDetailContent.InnerHtml = sb.ToString();
        }

        private void LoadRelatedProducts(int currentProductId)
        {
            using (var client = new UbuntuWearsServiceClient())
            {
                var response = client.GetFeaturedProducts(4);
                if (response.Success && response.Data != null)
                {
                    var relatedProducts = response.Data.Where(p => p.ProductID != currentProductId).Take(3).ToList();
                    RenderRelatedProducts(relatedProducts);
                }
            }
        }

        private void RenderRelatedProducts(List<ProductEntity> relatedProducts)
        {
            if (relatedProducts.Any())
            {
                StringBuilder sb = new StringBuilder();

                sb.Append(@"<h3 class='related-title'>You Might Also Like</h3>
                            <div class='related-grid'>");

                foreach (var product in relatedProducts)
                {
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
                                            onclick='addToCart({product.ProductID})'>
                                        <i class='fas fa-shopping-cart'></i> 
                                        {(product.Stock == 0 ? "Out of Stock" : "Add to Cart")}
                                    </button>
                                    <button type='button' class='wishlist-btn' onclick='addToWishlist({product.ProductID})'>
                                        <i class='fas fa-heart'></i>
                                    </button>
                                </div>
                            </div>
                        </div>";

                    sb.Append(productHtml);
                }

                sb.Append("</div>");
                relatedProductsContent.InnerHtml = sb.ToString();
            }
        }

        private void ShowNotFound()
        {
            StringBuilder sb = new StringBuilder();

            string notFoundHtml = @"
                <div class='not-found'>
                    <i class='fas fa-exclamation-triangle'></i>
                    <h2>Product Not Found</h2>
                    <p>The requested product could not be found.</p>
                    <a href='Products.aspx' class='btn-primary'>Continue Shopping</a>
                </div>";

            sb.Append(notFoundHtml);
            productDetailContent.InnerHtml = sb.ToString();
            relatedProductsContent.Visible = false;
        }

        private void AddToCart(int productId, int quantity)
        {
            if (Session["UserID"] == null)
            {
                Response.Redirect("~/Login.aspx?returnUrl=" + Server.UrlEncode(Request.Url.ToString()));
                return;
            }

            int userId = Convert.ToInt32(Session["UserID"]);

            using (var client = new UbuntuWearsServiceClient())
            {
                var response = client.AddToCart(userId, productId, quantity);
                if (response.Success)
                {
                    SiteMaster master = (SiteMaster)Master;
                    master.UpdateCartCount();

                    ShowNotification("Product added to cart successfully!", "success");
                }
                else
                {
                    ShowNotification("Error: " + response.ErrorMessage, "error");
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
                    ShowNotification("Product added to wishlist!", "success");
                }
                else
                {
                    ShowNotification("Error: " + response.ErrorMessage, "error");
                }
            }
        }

        private void ShowNotification(string message, string type)
        {
            ScriptManager.RegisterStartupScript(this, GetType(), "ShowNotification",
                $"showNotification('{HttpUtility.JavaScriptStringEncode(message)}', '{type}');", true);
        }
    }
}