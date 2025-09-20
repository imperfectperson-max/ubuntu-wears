using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using ub_frontend.UbuntuWearsReference;
using Newtonsoft.Json;

namespace ub_frontend
{
    public partial class Products : System.Web.UI.Page
    {
        private string CurrentCategory => Request.QueryString["category"] ?? "";
        private string SearchTerm => Request.QueryString["search"] ?? "";
        private string SortBy => ViewState["SortBy"] as string ?? "newest";
        private int CurrentPage
        {
            get => ViewState["CurrentPage"] as int? ?? 1;
            set => ViewState["CurrentPage"] = value;
        }
        private const int PageSize = 12;

        // Session-based cart property
        private List<CartItem> Cart
        {
            get
            {
                if (Session["Cart"] == null)
                    Session["Cart"] = new List<CartItem>();
                return (List<CartItem>)Session["Cart"];
            }
            set => Session["Cart"] = value;
        }

        // Session-based wishlist property
        private List<WishlistItem> Wishlist
        {
            get
            {
                if (Session["Wishlist"] == null)
                    Session["Wishlist"] = new List<WishlistItem>();
                return (List<WishlistItem>)Session["Wishlist"];
            }
            set => Session["Wishlist"] = value;
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                InitializePage();
                LoadProducts();
            }

            // Handle postback events
            string eventTarget = Request["__EVENTTARGET"];
            string eventArgument = Request["__EVENTARGUMENT"];

            if (!string.IsNullOrEmpty(eventTarget))
            {
                if (eventTarget == "AddToCart" && !string.IsNullOrEmpty(eventArgument))
                {
                    AddToCart(Convert.ToInt32(eventArgument));
                }
                else if (eventTarget == "AddToWishlist" && !string.IsNullOrEmpty(eventArgument))
                {
                    AddToWishlist(Convert.ToInt32(eventArgument));
                }
            }
        }

        private void InitializePage()
        {
            if (!string.IsNullOrEmpty(CurrentCategory))
            {
                litCategoryTitle.Text = $"{CurrentCategory} Products";
                ddlCategory.SelectedValue = CurrentCategory;
            }
            else if (!string.IsNullOrEmpty(SearchTerm))
            {
                litSearchTitle.Text = $"Search Results for \"{SearchTerm}\"";
            }
            else
            {
                litCategoryTitle.Text = "All Products";
            }

            ddlSortBy.SelectedValue = SortBy;
        }

        private void LoadProducts()
        {
            using (var client = new UbuntuWearsServiceClient())
            {
                List<ProductEntity> products;

                if (!string.IsNullOrEmpty(SearchTerm))
                {
                    var response = client.SearchProducts(SearchTerm);
                    products = response.Success ? response.Data.ToList() : new List<ProductEntity>();
                }
                else if (!string.IsNullOrEmpty(CurrentCategory))
                {
                    var response = client.GetProductsByCategory(CurrentCategory);
                    products = response.Success ? response.Data.ToList() : new List<ProductEntity>();
                }
                else
                {
                    var response = client.GetProducts();
                    products = response.Success ? response.Data.ToList() : new List<ProductEntity>();
                }

                // Apply sorting
                products = ApplySorting(products, SortBy);

                // Apply pagination
                var totalProducts = products.Count;
                var pagedProducts = products.Skip((CurrentPage - 1) * PageSize).Take(PageSize).ToList();

                RenderProducts(pagedProducts);
                litProductCount.Text = $"{totalProducts} products found";

                SetupPagination(totalProducts);
            }
        }

        private void RenderProducts(List<ProductEntity> products)
        {
            StringBuilder sb = new StringBuilder();

            if (products.Count == 0)
            {
                sb.Append(@"
                    <div class='no-products'>
                        <i class='fas fa-search'></i>
                        <h2>No products found</h2>
                        <p>Try adjusting your search or filter criteria</p>
                        <button type='button' class='btn-primary' onclick='location.href=""Products.aspx""'>Clear Filters</button>
                    </div>");
            }
            else
            {
                sb.Append("<div class='product-grid'>");

                foreach (var product in products)
                {
                    string imageUrl = !string.IsNullOrEmpty(product.ImageURL)
                        ? product.ImageURL
                        : "https://via.placeholder.com/300x400?text=No+Image";

                    string outOfStockClass = product.Stock == 0 ? "out-of-stock" : "";
                    string outOfStockDisabled = product.Stock == 0 ? "disabled" : "";

                    // Check if product is in wishlist
                    bool isInWishlist = Wishlist.Any(w => w.ProductID == product.ProductID);
                    string wishlistIcon = isInWishlist ? "fas fa-heart" : "far fa-heart";
                    string wishlistStyle = isInWishlist ? "style='color: #e74c3c;'" : "";

                    sb.Append($@"
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
                        data-id='{product.ProductID}' data-name='{HttpUtility.HtmlEncode(product.Name)}' 
                        data-price='{product.Price}' data-image='{imageUrl}'>
                    <i class='fas fa-shopping-cart'></i> 
                    {(product.Stock == 0 ? "Out of Stock" : "Add to Cart")}
                </button>
                <button type='button' class='wishlist-btn' data-id='{product.ProductID}' 
                        data-name='{HttpUtility.HtmlEncode(product.Name)}' data-price='{product.Price}' 
                        data-image='{imageUrl}'>
                    <i class='{wishlistIcon}' {wishlistStyle}></i>
                </button>
            </div>
        </div>
    </div>");
                }

                sb.Append("</div>");
            }

            productsGrid.InnerHtml = sb.ToString();
        }

        private List<ProductEntity> ApplySorting(List<ProductEntity> products, string sortBy)
        {
            switch (sortBy)
            {
                case "price_asc": return products.OrderBy(p => p.Price).ToList();
                case "price_desc": return products.OrderByDescending(p => p.Price).ToList();
                case "name_asc": return products.OrderBy(p => p.Name).ToList();
                case "name_desc": return products.OrderByDescending(p => p.Name).ToList();
                case "newest":
                default: return products.OrderByDescending(p => p.DateAdded).ToList();
            }
        }

        private void SetupPagination(int totalProducts)
        {
            int totalPages = (int)Math.Ceiling((double)totalProducts / PageSize);

            divPagination.Visible = totalPages > 1;
            litCurrentPage.Text = CurrentPage.ToString();
            litTotalPages.Text = totalPages.ToString();

            btnPrev.Enabled = CurrentPage > 1;
            btnNext.Enabled = CurrentPage < totalPages;
        }

        protected void ddlSortBy_SelectedIndexChanged(object sender, EventArgs e)
        {
            ViewState["SortBy"] = ddlSortBy.SelectedValue;
            CurrentPage = 1;
            LoadProducts();
        }

        protected void ddlCategory_SelectedIndexChanged(object sender, EventArgs e)
        {
            Response.Redirect($"~/Products.aspx?category={Server.UrlEncode(ddlCategory.SelectedValue)}");
        }

        protected void btnPrev_Click(object sender, EventArgs e)
        {
            if (CurrentPage > 1)
            {
                CurrentPage--;
                LoadProducts();
            }
        }

        protected void btnNext_Click(object sender, EventArgs e)
        {
            CurrentPage++;
            LoadProducts();
        }

        private void AddToCart(int productId)
        {
            using (var client = new UbuntuWearsServiceClient())
            {
                var productResponse = client.GetProduct(productId);
                if (!productResponse.Success)
                {
                    ScriptManager.RegisterStartupScript(this, GetType(), "AddToCartError",
                        $"showNotification('Error: Product not found', 'error');", true);
                    return;
                }

                var product = productResponse.Data;

                // Check if product is already in cart
                var existingItem = Cart.FirstOrDefault(item => item.ProductID == productId);

                if (existingItem != null)
                {
                    existingItem.Quantity += 1;
                }
                else
                {
                    Cart.Add(new CartItem
                    {
                        ProductID = product.ProductID,
                        Name = product.Name,
                        Price = product.Price,
                        ImageURL = product.ImageURL,
                        Quantity = 1
                    });
                }

                // Update session
                Cart = Cart;

                // Update cart count in master page
                SiteMaster master = (SiteMaster)Master;
                if (master != null)
                {
                    master.UpdateCartCount();
                }

                ScriptManager.RegisterStartupScript(this, GetType(), "AddToCartSuccess",
                    "showNotification('Product added to cart successfully!', 'success');", true);
            }
        }

        private void AddToWishlist(int productId)
        {
            using (var client = new UbuntuWearsServiceClient())
            {
                var productResponse = client.GetProduct(productId);
                if (!productResponse.Success)
                {
                    ScriptManager.RegisterStartupScript(this, GetType(), "AddToWishlistError",
                        $"showNotification('Error: Product not found', 'error');", true);
                    return;
                }

                var product = productResponse.Data;

                // Check if product is already in wishlist
                var existingItem = Wishlist.FirstOrDefault(item => item.ProductID == productId);

                if (existingItem != null)
                {
                    // Remove from wishlist
                    Wishlist.Remove(existingItem);
                    ScriptManager.RegisterStartupScript(this, GetType(), "RemoveFromWishlistSuccess",
                        "showNotification('Removed from wishlist', 'success');", true);
                }
                else
                {
                    // Add to wishlist
                    Wishlist.Add(new WishlistItem
                    {
                        ProductID = product.ProductID,
                        Name = product.Name,
                        Price = product.Price,
                        ImageURL = product.ImageURL
                    });
                    ScriptManager.RegisterStartupScript(this, GetType(), "AddToWishlistSuccess",
                        "showNotification('Added to wishlist!', 'success');", true);
                }

                // Update session
                Wishlist = Wishlist;

                // Reload products to update wishlist icons
                LoadProducts();
            }
        }

        protected string GetCartJson()
        {
            return JsonConvert.SerializeObject(Cart);
        }

        protected string GetWishlistJson()
        {
            return JsonConvert.SerializeObject(Wishlist);
        }

        protected string GetProductsJson()
        {
            using (var client = new UbuntuWearsServiceClient())
            {
                var response = client.GetProducts();
                if (response.Success)
                {
                    return JsonConvert.SerializeObject(response.Data);
                }
            }
            return "[]";
        }
    }

    // Cart item class
    [Serializable]
    public class CartItem
    {
        public int ProductID { get; set; }
        public string Name { get; set; }
        public decimal Price { get; set; }
        public string ImageURL { get; set; }
        public int Quantity { get; set; }
    }

    // Wishlist item class
    [Serializable]
    public class WishlistItem
    {
        public int ProductID { get; set; }
        public string Name { get; set; }
        public decimal Price { get; set; }
        public string ImageURL { get; set; }
    }
}