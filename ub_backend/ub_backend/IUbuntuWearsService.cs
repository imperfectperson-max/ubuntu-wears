using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using System.ServiceModel;
using System.Text;

namespace ub_backend
{
    // NOTE: You can use the "Rename" command on the "Refactor" menu to change the interface name "IUbuntuWearsService" in both code and config file together.
    [ServiceContract]
    public interface IUbuntuWearsService
    {
        #region Authentication
        [OperationContract]
        ServiceResponse<User> Login(string email, string password);

        [OperationContract]
        ServiceResponse<User> Register(User user, string password);

        [OperationContract]
        ServiceResponse Logout(string token);

        [OperationContract]
        bool IsAdmin(int userId);

        [OperationContract]
        ServiceResponse UpdateUser(User UserE);

        [OperationContract]
        ServiceResponse<User> GetUser(int userId);
        #endregion

        #region Products
        [OperationContract]
        ServiceResponse<List<ProductEntity>> GetProducts();

        [OperationContract]
        ServiceResponse<List<ProductEntity>> GetProductsByCategory(string category);

        [OperationContract]
        ServiceResponse<List<ProductEntity>> GetFeaturedProducts(int count = 6);

        [OperationContract]
        ServiceResponse<ProductEntity> GetProduct(int productId);

        [OperationContract]
        ServiceResponse<List<ProductEntity>> SearchProducts(string searchTerm);

        [OperationContract]
        ServiceResponse<Product> AddProduct(int userId, Product product);

        [OperationContract]
        ServiceResponse<Product> UpdateProduct(int userId, Product product);

        [OperationContract]
        ServiceResponse DeleteProduct(int userId, int productId);
        #endregion

        #region Cart
        [OperationContract]
        ServiceResponse<List<CartItem>> GetCartItems(int userId);

        [OperationContract]
        ServiceResponse AddToCart(int userId, int productId, int quantity = 1);

        [OperationContract]
        ServiceResponse UpdateCartItem(int userId, int cartItemId, int quantity);

        [OperationContract]
        ServiceResponse RemoveFromCart(int userId, int cartItemId);

        [OperationContract]
        ServiceResponse ClearCart(int userId);
        #endregion

        #region Orders
        [OperationContract]
        ServiceResponse<List<OrderEntity>> GetUserOrders(int userId);

        [OperationContract]
        ServiceResponse<List<Order>> GetRecentOrders(int count = 10);

        [OperationContract]
        ServiceResponse<List<OrderEntity>> GetOrdersByCategory(string category);

        [OperationContract]
        ServiceResponse<OrderEntity> GetOrder(int orderId);

        [OperationContract]
        ServiceResponse<Order> CreateOrder(Order order, List<OrderItem> items);

        [OperationContract]
        ServiceResponse UpdateOrderStatus(int orderId, string status);

        [OperationContract]
        ServiceResponse ProcessPayment(int orderId, Payment payment);
        #endregion

        #region Wishlist
        [OperationContract]
        ServiceResponse<List<WishlistItem>> GetWishlist(int userId);

        [OperationContract]
        ServiceResponse AddToWishlist(int userId, int productId);

        [OperationContract]
        ServiceResponse RemoveFromWishlist(int userId, int wishlistItemId);
        #endregion

        #region Admin
        [OperationContract]
        ServiceResponse<DashboardStats> GetDashboardStats();

        [OperationContract]
        ServiceResponse<List<UserEntity>> GetUsers();

        [OperationContract]
        ServiceResponse<List<Order>> GetAllOrders();
        #endregion

        #region Invoicing & Reports
        [OperationContract]
        ServiceResponse<InvoiceEntity> GenerateInvoice(int orderId);

        [OperationContract]
        ServiceResponse<List<InvoiceEntity>> GetInvoices(DateTime? startDate = null, DateTime? endDate = null);

        [OperationContract]
        ServiceResponse<InvoiceEntity> GetInvoice(int invoiceId);

        [OperationContract]
        ServiceResponse<SalesReport> GenerateSalesReport(DateTime startDate, DateTime endDate);

        [OperationContract]
        ServiceResponse<InventoryReport> GenerateInventoryReport();

        [OperationContract]
        ServiceResponse<CustomerReport> GenerateCustomerReport(DateTime? startDate = null, DateTime? endDate = null);

        [OperationContract]
        ServiceResponse<List<ReportEntity>> GetGeneratedReports(string reportType = null);

        [OperationContract]
        ServiceResponse<List<UserEntity>> GetAdminUsers();
        #endregion

        #region Discount Methods
        [OperationContract]
        ServiceResponse<List<DiscountA>> GetAllDiscounts();

        [OperationContract]
        ServiceResponse<DiscountA> GetDiscount(int discountId);

        [OperationContract]
        ServiceResponse<DiscountA> CreateDiscount(DiscountA discount);

        [OperationContract]
        ServiceResponse<DiscountA> UpdateDiscount(DiscountA discount);

        [OperationContract]
        ServiceResponse ToggleDiscountStatus(int discountId);

        [OperationContract]
        ServiceResponse DeleteDiscount(int discountId);

        [OperationContract]
        ServiceResponse<decimal> ApplyDiscount(string discountCode, decimal orderAmount);
        #endregion

        #region Address Methods
        [OperationContract]
        ServiceResponse<List<Address>> GetUserAddresses(int userId);

        [OperationContract]
        ServiceResponse<Address> GetAddress(int addressId);

        [OperationContract]
        ServiceResponse<Address> SaveAddress(Address address);

        [OperationContract]
        ServiceResponse DeleteAddress(int addressId);

        [OperationContract]
        ServiceResponse SetDefaultAddress(int userId, int addressId);
        #endregion

    }

    [DataContract]
    public class ServiceResponse
    {
        [DataMember]
        public bool Success { get; set; }

        [DataMember]
        public string ErrorMessage { get; set; }
    }

    [DataContract]
    public class ServiceResponse<T> : ServiceResponse
    {
        [DataMember]
        public T Data { get; set; }
    }

    [DataContract]
    public class DashboardStats
    {
        [DataMember]
        public decimal TotalSales { get; set; }

        [DataMember]
        public int TotalOrders { get; set; }

        [DataMember]
        public int TotalProducts { get; set; }

        [DataMember]
        public int TotalUsers { get; set; }

        [DataMember]
        public int PendingOrders { get; set; }
    }
    [DataContract]
    public class UserEntity
    {
        [DataMember]
        public int UserID { get; set; }

        [DataMember]
        public string FirstName { get; set; }

        [DataMember]
        public string LastName { get; set; }

        [DataMember]
        public string Username { get; set; }

        [DataMember]
        public string Email { get; set; }

        [DataMember]
        public string PhoneNumber { get; set; }

        [DataMember]
        public string UserType { get; set; }

        [DataMember]
        public DateTime DataCreated { get; set; }
    }

    [DataContract]
    public class ProductEntity
    {
        [DataMember]
        public int ProductID { get; set; }

        [DataMember]
        public string Name { get; set; }

        [DataMember]
        public string Description { get; set; }

        [DataMember]
        public decimal Price { get; set; }

        [DataMember]
        public int Stock { get; set; }

        [DataMember]
        public string Category { get; set; }

        [DataMember]
        public string ImageURL { get; set; }

        [DataMember]
        public bool isActive { get; set; }

        [DataMember]
        public DateTime DateAdded { get; set; }
    }

    [DataContract]
    public class CartItem
    {
        [DataMember]
        public int CartID { get; set; }

        [DataMember]
        public int UserID { get; set; }

        [DataMember]
        public int ProductID { get; set; }

        [DataMember]
        public int Quantity { get; set; }

        [DataMember]
        public DateTime AddedAt { get; set; }

        [DataMember]
        public ProductEntity Product { get; set; }
    }

    [DataContract]
    public class OrderEntity
    {
        [DataMember]
        public int OrderID { get; set; }

        [DataMember]
        public int UserID { get; set; }

        [DataMember]
        public decimal TotalAmount { get; set; }

        [DataMember]
        public string Status { get; set; }

        [DataMember]
        public string PaymentStatus { get; set; }

        [DataMember]
        public string DeliveryAddress { get; set; }

        [DataMember]
        public string PhoneNumber { get; set; }

        [DataMember]
        public DateTime CreatedAt { get; set; }

        [DataMember]
        public List<OrderItemEntity> OrderItems { get; set; }

        [DataMember]
        public UserEntity User { get; set; }
    }

    [DataContract]
    public class OrderItemEntity
    {
        [DataMember]
        public int OrderItemID { get; set; }

        [DataMember]
        public int OrderID { get; set; }

        [DataMember]
        public int ProductID { get; set; }

        [DataMember]
        public int Quantity { get; set; }

        [DataMember]
        public decimal Price { get; set; }

        [DataMember]
        public Product Product { get; set; }
    }

    [DataContract]
    public class WishlistItem
    {
        [DataMember]
        public int WishlistID { get; set; }

        [DataMember]
        public int UserID { get; set; }

        [DataMember]
        public int ProductID { get; set; }

        [DataMember]
        public DateTime AddedAt { get; set; }

        [DataMember]
        public ProductEntity Product { get; set; }
    }

    [DataContract]
    public class PaymentEntity
    {
        [DataMember]
        public int PaymentID { get; set; }

        [DataMember]
        public int OrderID { get; set; }

        [DataMember]
        public decimal Amount { get; set; }

        [DataMember]
        public string PaymentMethod { get; set; }

        [DataMember]
        public string PaymentStatus { get; set; }

        [DataMember]
        public string TransactionID { get; set; }

        [DataMember]
        public DateTime PaymentDate { get; set; }
    }

    [DataContract]
    public class InvoiceEntity
    {
        [DataMember] public int InvoiceID { get; set; }
        [DataMember] public int OrderID { get; set; }
        [DataMember] public string InvoiceNumber { get; set; }
        [DataMember] public DateTime InvoiceDate { get; set; }
        [DataMember] public DateTime DueDate { get; set; }
        [DataMember] public decimal TotalAmount { get; set; }
        [DataMember] public decimal TaxAmount { get; set; }
        [DataMember] public decimal DiscountAmount { get; set; }
        [DataMember] public decimal GrandTotal { get; set; }
        [DataMember] public string Status { get; set; }
        [DataMember] public DateTime CreatedAt { get; set; }
        [DataMember] public List<InvoiceItemEntity> InvoiceItems { get; set; }
        [DataMember] public OrderEntity Order { get; set; }
        [DataMember] public UserEntity Customer { get; set; }
    }

    [DataContract]
    public class InvoiceItemEntity
    {
        [DataMember] public int InvoiceItemID { get; set; }
        [DataMember] public int InvoiceID { get; set; }
        [DataMember] public int ProductID { get; set; }
        [DataMember] public int Quantity { get; set; }
        [DataMember] public decimal UnitPrice { get; set; }
        [DataMember] public decimal TotalPrice { get; set; }
        [DataMember] public ProductEntity Product { get; set; }
    }

    [DataContract]
    public class SalesReport
    {
        [DataMember] public DateTime StartDate { get; set; }
        [DataMember] public DateTime EndDate { get; set; }
        [DataMember] public decimal TotalSales { get; set; }
        [DataMember] public int TotalOrders { get; set; }
        [DataMember] public int TotalCustomers { get; set; }
        [DataMember] public decimal AverageOrderValue { get; set; }
        [DataMember] public List<SalesByCategory> SalesByCategories { get; set; }
        [DataMember] public List<SalesByDate> SalesByDates { get; set; }
        [DataMember] public List<TopSellingProduct> TopSellingProducts { get; set; }
    }

    [DataContract]
    public class SalesByCategory
    {
        [DataMember] public string Category { get; set; }
        [DataMember] public decimal TotalSales { get; set; }
        [DataMember] public int TotalItems { get; set; }
    }

    [DataContract]
    public class SalesByDate
    {
        [DataMember] public DateTime Date { get; set; }
        [DataMember] public decimal DailySales { get; set; }
        [DataMember] public int DailyOrders { get; set; }
    }

    [DataContract]
    public class TopSellingProduct
    {
        [DataMember] public int ProductID { get; set; }
        [DataMember] public string ProductName { get; set; }
        [DataMember] public int QuantitySold { get; set; }
        [DataMember] public decimal TotalRevenue { get; set; }
    }

    [DataContract]
    public class InventoryReport
    {
        [DataMember] public int TotalProducts { get; set; }
        [DataMember] public int OutOfStockProducts { get; set; }
        [DataMember] public int LowStockProducts { get; set; }
        [DataMember] public decimal TotalInventoryValue { get; set; }
        [DataMember] public List<InventoryItem> InventoryItems { get; set; }
    }

    [DataContract]
    public class InventoryItem
    {
        [DataMember] public int ProductID { get; set; }
        [DataMember] public string ProductName { get; set; }
        [DataMember] public int CurrentStock { get; set; }
        [DataMember] public decimal UnitPrice { get; set; }
        [DataMember] public decimal TotalValue { get; set; }
        [DataMember] public string StockStatus { get; set; } // In Stock, Low Stock, Out of Stock
    }

    [DataContract]
    public class CustomerReport
    {
        [DataMember] public int TotalCustomers { get; set; }
        [DataMember] public int NewCustomers { get; set; }
        [DataMember] public List<TopCustomer> TopCustomers { get; set; }
        [DataMember] public List<CustomerActivity> CustomerActivities { get; set; }
    }

    [DataContract]
    public class TopCustomer
    {
        [DataMember] public int CustomerID { get; set; }
        [DataMember] public string CustomerName { get; set; }
        [DataMember] public decimal TotalSpent { get; set; }
        [DataMember] public int TotalOrders { get; set; }
    }

    [DataContract]
    public class CustomerActivity
    {
        [DataMember] public DateTime Date { get; set; }
        [DataMember] public int NewRegistrations { get; set; }
        [DataMember] public int OrdersPlaced { get; set; }
    }

    [DataContract]
    public class ReportEntity
    {
        [DataMember] public int ReportID { get; set; }
        [DataMember] public string ReportType { get; set; }
        [DataMember] public string ReportName { get; set; }
        [DataMember] public int GeneratedBy { get; set; }
        [DataMember] public DateTime GeneratedDate { get; set; }
        [DataMember] public DateTime? StartDate { get; set; }
        [DataMember] public DateTime? EndDate { get; set; }
        [DataMember] public string FilePath { get; set; }
        [DataMember] public string FileFormat { get; set; }
        [DataMember] public UserEntity GeneratedByUser { get; set; }
    }
    [DataContract]
    public class AddressA
    {
        [DataMember] public int AddressID { get; set; }
        [DataMember] public int UserID { get; set; }
        [DataMember] public string AddressName { get; set; }
        [DataMember] public string StreetAddress { get; set; }
        [DataMember] public string City { get; set; }
        [DataMember] public string PostalCode { get; set; }
        [DataMember] public string Province { get; set; }
        [DataMember] public bool IsDefault { get; set; }
        [DataMember] public DateTime CreatedAt { get; set; }
    }
    [DataContract]
    public class DiscountA
    {
        [DataMember] public int DiscountID { get; set; }
        [DataMember] public string Code { get; set; }
        [DataMember] public string Description { get; set; }
        [DataMember] public string DiscountType { get; set; }
        [DataMember] public decimal DiscountValue { get; set; }
        [DataMember] public decimal MinOrderAmount { get; set; }
        [DataMember] public int MaxUses { get; set; }
        [DataMember] public int UsedCount { get; set; }
        [DataMember] public DateTime StartDate { get; set; }
        [DataMember] public DateTime EndDate { get; set; }
        [DataMember] public bool IsActive { get; set; }
        [DataMember] public DateTime CreatedAt { get; set; }
    }
}
