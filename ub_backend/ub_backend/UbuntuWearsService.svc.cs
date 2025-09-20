using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using System.Security.Cryptography;
using System.ServiceModel;
using System.Text;
using System.Web;
using System.Transactions;

namespace ub_backend
{
    // NOTE: You can use the "Rename" command on the "Refactor" menu to change the class name "UbuntuWearsService" in code, svc and config file together.
    // NOTE: In order to launch WCF Test Client for testing this service, please select UbuntuWearsService.svc or UbuntuWearsService.svc.cs at the Solution Explorer and start debugging.
    public class UbuntuWearsService : IUbuntuWearsService
    {
        private UbuntuWearsDataContext db = new UbuntuWearsDataContext();

        public object DbFunctions { get; private set; }

        #region Authentication Methods
        public ServiceResponse<User> Login(string email, string password)
        {
            try
            {
                var hashedPassword = HashPassword(password);
                var user = db.Users.FirstOrDefault(u => u.Email == email && u.Password == hashedPassword);

                if (user != null)
                {
                    return new ServiceResponse<User>
                    {
                        Success = true,
                        Data = new User
                        {
                            UserID = user.UserID,
                            FirstName = user.FirstName,
                            LastName = user.LastName,
                            Username = user.Username,
                            Email = user.Email,
                            PhoneNumber = user.PhoneNumber,
                            UserType = user.UserType,
                            DateCreated = user.DateCreated
                        }
                    };
                }

                return new ServiceResponse<User>
                {
                    Success = false,
                    ErrorMessage = "Invalid email or password"
                };
            }
            catch (Exception ex)
            {
                return new ServiceResponse<User>
                {
                    Success = false,
                    ErrorMessage = $"Login failed: {ex.Message}"
                };
            }
        }
        public ServiceResponse<User> GetUser(int userId)
        {
            try
            {
                using (var db = new UbuntuWearsDataContext())
                {
                    var user = db.Users.FirstOrDefault(u => u.UserID == userId);

                    if (user == null)
                    {
                        return new ServiceResponse<User>
                        {
                            Success = false,
                            ErrorMessage = "User not found"
                        };
                    }

                    return new ServiceResponse<User>
                    {
                        Success = true,
                        Data = new User
                        {
                            UserID = user.UserID,
                            FirstName = user.FirstName,
                            LastName = user.LastName,
                            Username = user.Username,
                            Email = user.Email,
                            PhoneNumber = user.PhoneNumber,
                            UserType = user.UserType,
                            DateCreated = user.DateCreated
                        }
                    };
                }
            }
            catch (Exception ex)
            {
                return new ServiceResponse<User>
                {
                    Success = false,
                    ErrorMessage = $"Could not get user: {ex.Message}"
                };
            }
        }
        public ServiceResponse<User> Register(User user, string password)
        {
            try
            {
                // Check if email already exists
                if (db.Users.Any(u => u.Email == user.Email))
                {
                    return new ServiceResponse<User>
                    {
                        Success = false,
                        ErrorMessage = "Email already exists"
                    };
                }

                var newUser = new User
                {
                    FirstName = user.FirstName,
                    LastName = user.LastName,
                    Username = user.Username,
                    Email = user.Email,
                    Password = HashPassword(password),
                    PhoneNumber = user.PhoneNumber,
                    UserType = user.UserType,
                    DateCreated = DateTime.Now
                };

                db.Users.InsertOnSubmit(newUser);
                db.SubmitChanges();

                // If user is Manager, add to admin management
                if (user.UserType == "Admin")
                {
                    var admin = new AdminManagement
                    {
                        UserID = newUser.UserID,
                        CreatedAt = DateTime.Now
                    };
                    db.AdminManagements.InsertOnSubmit(admin);
                    db.SubmitChanges();
                }

                return new ServiceResponse<User>
                {
                    Success = true,
                    Data = new User
                    {
                        UserID = newUser.UserID,
                        FirstName = newUser.FirstName,
                        LastName = newUser.LastName,
                        Username = newUser.Username,
                        Email = newUser.Email,
                        PhoneNumber = newUser.PhoneNumber,
                        UserType = newUser.UserType,
                        DateCreated = newUser.DateCreated
                    }
                };
            }
            catch (Exception ex)
            {
                return new ServiceResponse<User>
                {
                    Success = false,
                    ErrorMessage = $"Registration failed: {ex.Message}"
                };
            }
        }

        public ServiceResponse UpdateUser(User UserE)
        {
            try
            {
                using (var db = new UbuntuWearsDataContext())
                {
                    var user = db.Users.FirstOrDefault(u => u.UserID == UserE.UserID);

                    if (user == null)
                    {
                        return new ServiceResponse
                        {
                            Success = false
                        };
                    }

                    // Check if email is already taken by another user
                    if (db.Users.Any(u => u.Email == UserE.Email && u.UserID != UserE.UserID))
                    {
                        return new ServiceResponse
                        {
                            Success = false,

                        };
                    }

                    // Update user details
                    user.Username = UserE.Username;
                    user.Email = UserE.Email;

                    db.Users.InsertOnSubmit(user);

                    return new ServiceResponse
                    {
                        Success = true

                    };
                }
            }
            catch (Exception ex)
            {
                return new ServiceResponse
                {
                    Success = false,

                };
            }
        }
        public ServiceResponse Logout(string token)
        {
            return new ServiceResponse { Success = true };
        }

        public bool IsAdmin(int userId)
        {
            return db.AdminManagements.Any(a => a.UserID == userId);
        }
        #endregion

        #region Product Methods
        public ServiceResponse<List<ProductEntity>> GetProducts()
        {
            try
            {
                var products = db.Products
                    .Where(p => p.isActive == true)
                    .OrderByDescending(p => p.DateAdded)
                    .Select(p => new ProductEntity
                    {
                        ProductID = p.ProductID,
                        Name = p.Name,
                        Description = p.Description,
                        Price = p.Price,
                        Stock = p.Stock,
                        Category = p.Category,
                        ImageURL = p.ImageURL,
                        isActive = p.isActive,
                        DateAdded = p.DateAdded
                    })
                    .ToList();

                return new ServiceResponse<List<ProductEntity>>
                {
                    Success = true,
                    Data = products
                };
            }
            catch (Exception ex)
            {
                return new ServiceResponse<List<ProductEntity>>
                {
                    Success = false,
                    ErrorMessage = $"Error getting products: {ex.Message}"
                };
            }
        }

        public ServiceResponse<List<ProductEntity>> GetProductsByCategory(string category)
        {
            try
            {
                var products = db.Products
                    .Where(p => p.isActive == true && p.Category == category)
                    .Take(10)
                    .OrderByDescending(p => p.DateAdded)
                    .Select(p => new ProductEntity
                    {
                        ProductID = p.ProductID,
                        Name = p.Name,
                        Description = p.Description,
                        Price = p.Price,
                        Stock = p.Stock,
                        Category = p.Category,
                        ImageURL = p.ImageURL,
                        isActive = p.isActive,
                        DateAdded = p.DateAdded
                    })
                    .ToList();

                return new ServiceResponse<List<ProductEntity>>
                {
                    Success = true,
                    Data = products
                };
            }
            catch (Exception ex)
            {
                return new ServiceResponse<List<ProductEntity>>
                {
                    Success = false,
                    ErrorMessage = $"Error getting products by category: {ex.Message}"
                };
            }
        }

        public ServiceResponse<List<ProductEntity>> GetFeaturedProducts(int count = 6)
        {
            try
            {
                var products = db.Products
                    .Where(p => p.isActive == true)
                    .OrderByDescending(p => p.DateAdded)
                    .Take(count)
                    .Select(p => new ProductEntity
                    {
                        ProductID = p.ProductID,
                        Name = p.Name,
                        Description = p.Description,
                        Price = p.Price,
                        Stock = p.Stock,
                        Category = p.Category,
                        ImageURL = p.ImageURL,
                        isActive = p.isActive,
                        DateAdded = p.DateAdded
                    })
                    .ToList();

                return new ServiceResponse<List<ProductEntity>>
                {
                    Success = true,
                    Data = products
                };
            }
            catch (Exception ex)
            {
                return new ServiceResponse<List<ProductEntity>>
                {
                    Success = false,
                    ErrorMessage = $"Error getting featured products: {ex.Message}"
                };
            }
        }

        public ServiceResponse<ProductEntity> GetProduct(int productId)
        {
            try
            {
                var product = db.Products.FirstOrDefault(p => p.ProductID == productId && p.isActive == true);

                if (product != null)
                {
                    return new ServiceResponse<ProductEntity>
                    {
                        Success = true,
                        Data = new ProductEntity
                        {
                            ProductID = product.ProductID,
                            Name = product.Name,
                            Description = product.Description,
                            Price = product.Price,
                            Stock = product.Stock,
                            Category = product.Category,
                            ImageURL = product.ImageURL,
                            isActive = product.isActive,
                            DateAdded = product.DateAdded
                        }
                    };
                }

                return new ServiceResponse<ProductEntity>
                {
                    Success = false,
                    ErrorMessage = "Product not found"
                };
            }
            catch (Exception ex)
            {
                return new ServiceResponse<ProductEntity>
                {
                    Success = false,
                    ErrorMessage = $"Error getting product: {ex.Message}"
                };
            }
        }

        public ServiceResponse<List<ProductEntity>> SearchProducts(string searchTerm)
        {
            try
            {
                var products = db.Products
                    .Where(p => p.isActive == true &&
                               (p.Name.Contains(searchTerm) ||
                                p.Description.Contains(searchTerm) ||
                                p.Category.Contains(searchTerm)))
                    .Select(p => new ProductEntity
                    {
                        ProductID = p.ProductID,
                        Name = p.Name,
                        Description = p.Description,
                        Price = p.Price,
                        Stock = p.Stock,
                        Category = p.Category,
                        ImageURL = p.ImageURL,
                        isActive = p.isActive,
                        DateAdded = p.DateAdded
                    })
                    .OrderByDescending(p => p.DateAdded)
                    .ToList();

                return new ServiceResponse<List<ProductEntity>>
                {
                    Success = true,
                    Data = products
                };
            }
            catch (Exception ex)
            {
                return new ServiceResponse<List<ProductEntity>>
                {
                    Success = false,
                    ErrorMessage = $"Error searching products: {ex.Message}"
                };
            }
        }

        public ServiceResponse<Product> AddProduct(int userId, Product product)
        {
            try
            {
                if (!IsAdmin(userId))
                {
                    return new ServiceResponse<Product>
                    {
                        Success = false,
                        ErrorMessage = "Admin privileges required"
                    };
                }

                var newProduct = new Product
                {
                    Name = product.Name,
                    Description = product.Description,
                    Price = product.Price,
                    Stock = product.Stock,
                    Category = product.Category,
                    ImageURL = product.ImageURL,
                    isActive = true,
                    DateAdded = DateTime.Now
                };

                db.Products.InsertOnSubmit(newProduct);
                db.SubmitChanges();

                return new ServiceResponse<Product>
                {
                    Success = true,
                    Data = new Product
                    {
                        ProductID = newProduct.ProductID,
                        Name = newProduct.Name,
                        Description = newProduct.Description,
                        Price = newProduct.Price,
                        Stock = newProduct.Stock,
                        Category = newProduct.Category,
                        ImageURL = newProduct.ImageURL,
                        isActive = newProduct.isActive,
                        DateAdded = newProduct.DateAdded
                    }
                };
            }
            catch (Exception ex)
            {
                return new ServiceResponse<Product>
                {
                    Success = false,
                    ErrorMessage = $"Error adding product: {ex.Message}"
                };
            }
        }

        public ServiceResponse<Product> UpdateProduct(int userId, Product product)
        {
            try
            {
                if (!IsAdmin(userId))
                {
                    return new ServiceResponse<Product>
                    {
                        Success = false,
                        ErrorMessage = "Admin privileges required"
                    };
                }

                var existingProduct = db.Products.FirstOrDefault(p => p.ProductID == product.ProductID);
                if (existingProduct == null)
                {
                    return new ServiceResponse<Product>
                    {
                        Success = false,
                        ErrorMessage = "Product not found"
                    };
                }

                existingProduct.Name = product.Name;
                existingProduct.Description = product.Description;
                existingProduct.Price = product.Price;
                existingProduct.Stock = product.Stock;
                existingProduct.Category = product.Category;
                existingProduct.ImageURL = product.ImageURL;
                existingProduct.isActive = product.isActive;

                db.SubmitChanges();

                return new ServiceResponse<Product>
                {
                    Success = true,
                    Data = new Product
                    {
                        ProductID = existingProduct.ProductID,
                        Name = existingProduct.Name,
                        Description = existingProduct.Description,
                        Price = existingProduct.Price,
                        Stock = existingProduct.Stock,
                        Category = existingProduct.Category,
                        ImageURL = existingProduct.ImageURL,
                        isActive = existingProduct.isActive,
                        DateAdded = existingProduct.DateAdded
                    }
                };
            }
            catch (Exception ex)
            {
                return new ServiceResponse<Product>
                {
                    Success = false,
                    ErrorMessage = $"Error updating product: {ex.Message}"
                };
            }
        }

        public ServiceResponse DeleteProduct(int userId, int productId)
        {
            try
            {
                if (!IsAdmin(userId))
                {
                    return new ServiceResponse
                    {
                        Success = false,
                        ErrorMessage = "Admin privileges required"
                    };
                }

                var product = db.Products.FirstOrDefault(p => p.ProductID == productId);
                if (product == null)
                {
                    return new ServiceResponse
                    {
                        Success = false,
                        ErrorMessage = "Product not found"
                    };
                }

                // Soft delete by setting isActive to false
                product.isActive = false;
                db.SubmitChanges();

                return new ServiceResponse
                {
                    Success = true
                };
            }
            catch (Exception ex)
            {
                return new ServiceResponse
                {
                    Success = false,
                    ErrorMessage = $"Error deleting product: {ex.Message}"
                };
            }
        }
        #endregion

        #region Cart Methods
        public ServiceResponse<List<CartItem>> GetCartItems(int userId)
        {
            try
            {
                var cartItems = db.Carts
                    .Where(c => c.UserID == userId)
                    .Select(c => new CartItem
                    {
                        CartID = c.CartID,
                        UserID = c.UserID,
                        ProductID = c.ProductID,
                        Quantity = c.Quantity,
                        AddedAt = c.AddedAt,
                        Product = new ProductEntity
                        {
                            ProductID = c.Product.ProductID,
                            Name = c.Product.Name,
                            Description = c.Product.Description,
                            Price = c.Product.Price,
                            Stock = c.Product.Stock,
                            Category = c.Product.Category,
                            ImageURL = c.Product.ImageURL,
                            isActive = c.Product.isActive,
                            DateAdded = c.Product.DateAdded
                        }
                    }).ToList();

                return new ServiceResponse<List<CartItem>>
                {
                    Success = true,
                    Data = cartItems
                };
            }
            catch (Exception ex)
            {
                return new ServiceResponse<List<CartItem>>
                {
                    Success = false,
                    ErrorMessage = $"Error getting cart items: {ex.Message}"
                };
            }
        }

        public ServiceResponse AddToCart(int userId, int productId, int quantity = 1)
        {
            try
            {
                var existingItem = db.Carts.FirstOrDefault(c => c.UserID == userId && c.ProductID == productId);

                if (existingItem != null)
                {
                    existingItem.Quantity += quantity;
                }
                else
                {
                    var newCartItem = new Cart
                    {
                        UserID = userId,
                        ProductID = productId,
                        Quantity = quantity,
                        AddedAt = DateTime.Now
                    };
                    db.Carts.InsertOnSubmit(newCartItem);
                }

                db.SubmitChanges();

                return new ServiceResponse
                {
                    Success = true
                };
            }
            catch (Exception ex)
            {
                return new ServiceResponse
                {
                    Success = false,
                    ErrorMessage = $"Error adding to cart: {ex.Message}"
                };
            }
        }

        public ServiceResponse UpdateCartItem(int userId, int cartItemId, int quantity)
        {
            try
            {
                var cartItem = db.Carts.FirstOrDefault(c => c.CartID == cartItemId && c.UserID == userId);
                if (cartItem == null)
                {
                    return new ServiceResponse
                    {
                        Success = false,
                        ErrorMessage = "Cart item not found"
                    };
                }

                if (quantity <= 0)
                {
                    db.Carts.DeleteOnSubmit(cartItem);
                }
                else
                {
                    cartItem.Quantity = quantity;
                }

                db.SubmitChanges();

                return new ServiceResponse
                {
                    Success = true
                };
            }
            catch (Exception ex)
            {
                return new ServiceResponse
                {
                    Success = false,
                    ErrorMessage = $"Error updating cart item: {ex.Message}"
                };
            }
        }

        public ServiceResponse RemoveFromCart(int userId, int cartItemId)
        {
            try
            {
                var cartItem = db.Carts.FirstOrDefault(c => c.CartID == cartItemId && c.UserID == userId);
                if (cartItem == null)
                {
                    return new ServiceResponse
                    {
                        Success = false,
                        ErrorMessage = "Cart item not found"
                    };
                }

                db.Carts.DeleteOnSubmit(cartItem);
                db.SubmitChanges();

                return new ServiceResponse
                {
                    Success = true
                };
            }
            catch (Exception ex)
            {
                return new ServiceResponse
                {
                    Success = false,
                    ErrorMessage = $"Error removing from cart: {ex.Message}"
                };
            }
        }

        public ServiceResponse ClearCart(int userId)
        {
            try
            {
                var cartItems = db.Carts.Where(c => c.UserID == userId);
                db.Carts.DeleteAllOnSubmit(cartItems);
                db.SubmitChanges();

                return new ServiceResponse
                {
                    Success = true
                };
            }
            catch (Exception ex)
            {
                return new ServiceResponse
                {
                    Success = false,
                    ErrorMessage = $"Error clearing cart: {ex.Message}"
                };
            }
        }
        #endregion

        #region Order Methods
        public ServiceResponse<List<OrderEntity>> GetUserOrders(int userId)
        {
            try
            {
                var orders = db.Orders
                    .Where(o => o.UserID == userId)
                    .OrderByDescending(o => o.CreatedAt)
                    .Select(o => new OrderEntity
                    {
                        OrderID = o.OrderID,
                        UserID = o.UserID,
                        TotalAmount = o.TotalAmount,
                        Status = o.Status,
                        PaymentStatus = o.PaymentStatus,
                        DeliveryAddress = o.DeliveryAddress,
                        PhoneNumber = o.PhoneNumber,
                        CreatedAt = o.CreatedAt,
                        OrderItems = db.OrderItems
                            .Where(oi => oi.OrderID == o.OrderID)
                            .Select(oi => new OrderItemEntity
                            {
                                OrderItemID = oi.OrderItemID,
                                OrderID = oi.OrderID,
                                ProductID = oi.ProductID,
                                Quantity = oi.Quantity,
                                Price = oi.Price,
                                Product = db.Products
                                    .Where(p => p.ProductID == oi.ProductID)
                                    .Select(p => new Product
                                    {
                                        ProductID = p.ProductID,
                                        Name = p.Name,
                                        Description = p.Description,
                                        Price = p.Price,
                                        Stock = p.Stock,
                                        Category = p.Category,
                                        ImageURL = p.ImageURL,
                                        isActive = p.isActive,
                                        DateAdded = p.DateAdded
                                    }).FirstOrDefault()
                            }).ToList()
                    }).ToList();

                return new ServiceResponse<List<OrderEntity>>
                {
                    Success = true,
                    Data = orders
                };
            }
            catch (Exception ex)
            {
                return new ServiceResponse<List<OrderEntity>>
                {
                    Success = false,
                    ErrorMessage = $"Error getting user orders: {ex.Message}"
                };
            }
        }

        public ServiceResponse<List<OrderEntity>> GetOrdersByCategory(string category)
        {
            try
            {
                var orders = db.Orders
                    .Where(o => o.Status == category)
                    .OrderByDescending(o => o.CreatedAt)
                    .Select(o => new OrderEntity
                    {
                        OrderID = o.OrderID,
                        UserID = o.UserID,
                        TotalAmount = o.TotalAmount,
                        Status = o.Status,
                        PaymentStatus = o.PaymentStatus,
                        DeliveryAddress = o.DeliveryAddress,
                        PhoneNumber = o.PhoneNumber,
                        CreatedAt = o.CreatedAt,
                        OrderItems = db.OrderItems
                            .Where(oi => oi.OrderID == o.OrderID)
                            .Select(oi => new OrderItemEntity
                            {
                                OrderItemID = oi.OrderItemID,
                                OrderID = oi.OrderID,
                                ProductID = oi.ProductID,
                                Quantity = oi.Quantity,
                                Price = oi.Price,
                                Product = db.Products
                                    .Where(p => p.ProductID == oi.ProductID)
                                    .Select(p => new Product
                                    {
                                        ProductID = p.ProductID,
                                        Name = p.Name,
                                        Description = p.Description,
                                        Price = p.Price,
                                        Stock = p.Stock,
                                        Category = p.Category,
                                        ImageURL = p.ImageURL,
                                        isActive = p.isActive,
                                        DateAdded = p.DateAdded
                                    }).FirstOrDefault()
                            }).ToList()
                    }).ToList();

                return new ServiceResponse<List<OrderEntity>>
                {
                    Success = true,
                    Data = orders
                };
            }
            catch (Exception ex)
            {
                return new ServiceResponse<List<OrderEntity>>
                {
                    Success = false,
                    ErrorMessage = $"Error getting orders by category: {ex.Message}"
                };
            }
        }

        public ServiceResponse<List<Order>> GetRecentOrders(int count = 10)
        {
            try
            {
                var orders = db.Orders
                    .OrderByDescending(o => o.CreatedAt)
                    .Take(count)
                    .Select(o => new Order
                    {
                        OrderID = o.OrderID,
                        UserID = o.UserID,
                        TotalAmount = o.TotalAmount,
                        Status = o.Status,
                        PaymentStatus = o.PaymentStatus,
                        DeliveryAddress = o.DeliveryAddress,
                        PhoneNumber = o.PhoneNumber,
                        CreatedAt = o.CreatedAt,
                        User = db.Users
                            .Where(u => u.UserID == o.UserID)
                            .Select(u => new User
                            {
                                UserID = u.UserID,
                                FirstName = u.FirstName,
                                LastName = u.LastName,
                                Username = u.Username,
                                Email = u.Email
                            }).FirstOrDefault()
                    }).ToList();

                return new ServiceResponse<List<Order>>
                {
                    Success = true,
                    Data = orders
                };
            }
            catch (Exception ex)
            {
                return new ServiceResponse<List<Order>>
                {
                    Success = false,
                    ErrorMessage = $"Error getting recent orders: {ex.Message}"
                };
            }
        }

        public ServiceResponse<OrderEntity> GetOrder(int orderId)
        {
            try
            {
                var order = db.Orders.FirstOrDefault(o => o.OrderID == orderId);
                if (order == null)
                {
                    return new ServiceResponse<OrderEntity>
                    {
                        Success = false,
                        ErrorMessage = "Order not found"
                    };
                }

                var orderDetails = new OrderEntity
                {
                    OrderID = order.OrderID,
                    UserID = order.UserID,
                    TotalAmount = order.TotalAmount,
                    Status = order.Status,
                    PaymentStatus = order.PaymentStatus,
                    DeliveryAddress = order.DeliveryAddress,
                    PhoneNumber = order.PhoneNumber,
                    CreatedAt = order.CreatedAt,
                    OrderItems = db.OrderItems
                        .Where(oi => oi.OrderID == order.OrderID)
                        .Select(oi => new OrderItemEntity
                        {
                            OrderItemID = oi.OrderItemID,
                            OrderID = oi.OrderID,
                            ProductID = oi.ProductID,
                            Quantity = oi.Quantity,
                            Price = oi.Price,
                            Product = db.Products
                                .Where(p => p.ProductID == oi.ProductID)
                                .Select(p => new Product
                                {
                                    ProductID = p.ProductID,
                                    Name = p.Name,
                                    Description = p.Description,
                                    Price = p.Price,
                                    Stock = p.Stock,
                                    Category = p.Category,
                                    ImageURL = p.ImageURL,
                                    isActive = p.isActive,
                                    DateAdded = p.DateAdded
                                }).FirstOrDefault()
                        }).ToList(),
                    User = db.Users
                        .Where(u => u.UserID == order.UserID)
                        .Select(u => new UserEntity
                        {
                            UserID = u.UserID,
                            FirstName = u.FirstName,
                            LastName = u.LastName,
                            Username = u.Username,
                            Email = u.Email,
                            PhoneNumber = u.PhoneNumber
                        }).FirstOrDefault()
                };

                return new ServiceResponse<OrderEntity>
                {
                    Success = true,
                    Data = orderDetails
                };
            }
            catch (Exception ex)
            {
                return new ServiceResponse<OrderEntity>
                {
                    Success = false,
                    ErrorMessage = $"Error getting order: {ex.Message}"
                };
            }
        }

        public ServiceResponse<Order> CreateOrder(Order order, List<OrderItem> items)
        {
            try
            {
                using (var transaction = new TransactionScope())
                {
                    var newOrder = new Order
                    {
                        UserID = order.UserID,
                        TotalAmount = order.TotalAmount,
                        Status = "Processing",
                        PaymentStatus = "Pending",
                        DeliveryAddress = order.DeliveryAddress,
                        PhoneNumber = order.PhoneNumber,
                        CreatedAt = DateTime.Now
                    };

                    db.Orders.InsertOnSubmit(newOrder);
                    db.SubmitChanges();

                    foreach (var item in items)
                    {
                        var orderItem = new OrderItem
                        {
                            OrderID = newOrder.OrderID,
                            ProductID = item.ProductID,
                            Quantity = item.Quantity,
                            Price = item.Price
                        };
                        db.OrderItems.InsertOnSubmit(orderItem);

                        // Update product stock
                        var product = db.Products.FirstOrDefault(p => p.ProductID == item.ProductID);
                        if (product != null)
                        {
                            product.Stock -= item.Quantity;
                            if (product.Stock < 0) product.Stock = 0;
                        }
                    }

                    // Clear user's cart
                    var cartItems = db.Carts.Where(c => c.UserID == order.UserID);
                    db.Carts.DeleteAllOnSubmit(cartItems);

                    db.SubmitChanges();
                    transaction.Complete();

                    return new ServiceResponse<Order>
                    {
                        Success = true,
                        Data = new Order
                        {
                            OrderID = newOrder.OrderID,
                            UserID = newOrder.UserID,
                            TotalAmount = newOrder.TotalAmount,
                            Status = newOrder.Status,
                            PaymentStatus = newOrder.PaymentStatus,
                            DeliveryAddress = newOrder.DeliveryAddress,
                            PhoneNumber = newOrder.PhoneNumber,
                            CreatedAt = newOrder.CreatedAt
                        }
                    };
                }
            }
            catch (Exception ex)
            {
                return new ServiceResponse<Order>
                {
                    Success = false,
                    ErrorMessage = $"Error creating order: {ex.Message}"
                };
            }
        }

        public ServiceResponse UpdateOrderStatus(int orderId, string status)
        {
            try
            {
                var order = db.Orders.FirstOrDefault(o => o.OrderID == orderId);
                if (order == null)
                {
                    return new ServiceResponse
                    {
                        Success = false,
                        ErrorMessage = "Order not found"
                    };
                }

                order.Status = status;
                db.SubmitChanges();

                return new ServiceResponse
                {
                    Success = true
                };
            }
            catch (Exception ex)
            {
                return new ServiceResponse
                {
                    Success = false,
                    ErrorMessage = $"Error updating order status: {ex.Message}"
                };
            }
        }
        #endregion

        #region Wishlist Methods
        public ServiceResponse<List<WishlistItem>> GetWishlist(int userId)
        {
            try
            {
                var wishlistItems = db.Wishlists
                    .Where(w => w.UserID == userId)
                    .Select(w => new WishlistItem
                    {
                        WishlistID = w.WishlistID,
                        UserID = w.UserID,
                        ProductID = w.ProductID,
                        AddedAt = w.AddedAt,
                        Product = new ProductEntity
                        {
                            ProductID = w.Product.ProductID,
                            Name = w.Product.Name,
                            Description = w.Product.Description,
                            Price = w.Product.Price,
                            Stock = w.Product.Stock,
                            Category = w.Product.Category,
                            ImageURL = w.Product.ImageURL,
                            isActive = w.Product.isActive,
                            DateAdded = w.Product.DateAdded
                        }
                    }).ToList();

                return new ServiceResponse<List<WishlistItem>>
                {
                    Success = true,
                    Data = wishlistItems
                };
            }
            catch (Exception ex)
            {
                return new ServiceResponse<List<WishlistItem>>
                {
                    Success = false,
                    ErrorMessage = $"Error getting wishlist: {ex.Message}"
                };
            }
        }

        public ServiceResponse AddToWishlist(int userId, int productId)
        {
            try
            {
                // Check if already in wishlist
                if (db.Wishlists.Any(w => w.UserID == userId && w.ProductID == productId))
                {
                    return new ServiceResponse
                    {
                        Success = false,
                        ErrorMessage = "Product already in wishlist"
                    };
                }

                var wishlistItem = new Wishlist
                {
                    UserID = userId,
                    ProductID = productId,
                    AddedAt = DateTime.Now
                };

                db.Wishlists.InsertOnSubmit(wishlistItem);
                db.SubmitChanges();

                return new ServiceResponse
                {
                    Success = true
                };
            }
            catch (Exception ex)
            {
                return new ServiceResponse
                {
                    Success = false,
                    ErrorMessage = $"Error adding to wishlist: {ex.Message}"
                };
            }
        }

        public ServiceResponse RemoveFromWishlist(int userId, int wishlistItemId)
        {
            try
            {
                var wishlistItem = db.Wishlists.FirstOrDefault(w => w.WishlistID == wishlistItemId && w.UserID == userId);
                if (wishlistItem == null)
                {
                    return new ServiceResponse
                    {
                        Success = false,
                        ErrorMessage = "Wishlist item not found"
                    };
                }

                db.Wishlists.DeleteOnSubmit(wishlistItem);
                db.SubmitChanges();

                return new ServiceResponse
                {
                    Success = true
                };
            }
            catch (Exception ex)
            {
                return new ServiceResponse
                {
                    Success = false,
                    ErrorMessage = $"Error removing from wishlist: {ex.Message}"
                };
            }
        }
        #endregion

        #region Admin Methods
        public ServiceResponse<DashboardStats> GetDashboardStats()
        {
            try
            {
                var stats = new DashboardStats
                {
                    TotalSales = db.Orders.Where(o => o.PaymentStatus == "Paid").Sum(o => (decimal?)o.TotalAmount) ?? 0,
                    TotalOrders = db.Orders.Count(),
                    TotalProducts = db.Products.Count(p => p.isActive == true),
                    TotalUsers = db.Users.Count(),
                    PendingOrders = db.Orders.Count(o => o.Status == "Processing")
                };

                return new ServiceResponse<DashboardStats>
                {
                    Success = true,
                    Data = stats
                };
            }
            catch (Exception ex)
            {
                return new ServiceResponse<DashboardStats>
                {
                    Success = false,
                    ErrorMessage = $"Error getting dashboard stats: {ex.Message}"
                };
            }
        }

        public ServiceResponse<List<User>> GetUsers()
        {
            try
            {
                if (!IsAdmin(GetCurrentUserId())) 
                {
                    return new ServiceResponse<List<User>>
                    {
                        Success = false,
                        ErrorMessage = "Admin privileges required"
                    };
                }

                var users = db.Users
                    .Select(u => new User
                    {
                        UserID = u.UserID,
                        FirstName = u.FirstName,
                        LastName = u.LastName,
                        Username = u.Username,
                        Email = u.Email,
                        PhoneNumber = u.PhoneNumber,
                        UserType = u.UserType,
                        DateCreated = u.DateCreated
                    }).ToList();

                return new ServiceResponse<List<User>>
                {
                    Success = true,
                    Data = users
                };
            }
            catch (Exception ex)
            {
                return new ServiceResponse<List<User>>
                {
                    Success = false,
                    ErrorMessage = $"Error getting users: {ex.Message}"
                };
            }
        }

        public ServiceResponse<List<Order>> GetAllOrders()
        {
            try
            {
                if (!IsAdmin(GetCurrentUserId())) 
                {
                    return new ServiceResponse<List<Order>>
                    {
                        Success = false,
                        ErrorMessage = "Admin privileges required"
                    };
                }
                

                var orders = db.Orders
                    .OrderByDescending(o => o.CreatedAt)
                    .Select(o => new Order
                    {
                        OrderID = o.OrderID,
                        UserID = o.UserID,
                        TotalAmount = o.TotalAmount,
                        Status = o.Status,
                        PaymentStatus = o.PaymentStatus,
                        DeliveryAddress = o.DeliveryAddress,
                        PhoneNumber = o.PhoneNumber,
                        CreatedAt = o.CreatedAt
                    }).ToList();

                return new ServiceResponse<List<Order>>
                {
                    Success = true,
                    Data = orders
                };
            }
            catch (Exception ex)
            {
                return new ServiceResponse<List<Order>>
                {
                    Success = false,
                    ErrorMessage = $"Error getting all orders: {ex.Message}"
                };
            }
        }
        #endregion

        #region Utility Methods
        private string HashPassword(string password)
        {
            using (var sha256 = SHA256.Create())
            {
                var hashedBytes = sha256.ComputeHash(Encoding.UTF8.GetBytes(password));
                return BitConverter.ToString(hashedBytes).Replace("-", "").ToLower();
            }
        }

        private int GetCurrentUserId()
        {
            // This should be implemented based on your authentication system
            // For example, if using Forms Authentication with user data in session:
            if (HttpContext.Current.Session["UserID"] != null)
            {
                return Convert.ToInt32(HttpContext.Current.Session["UserID"]);
            }

            // Or if using authentication tokens, parse from token
            throw new Exception("User not authenticated");
        }

        public ServiceResponse ProcessPayment(int orderId, Payment payment)
        {
            try
            {
                using (var transaction = new TransactionScope())
                {
                    // Get the order
                    var order = db.Orders.FirstOrDefault(o => o.OrderID == orderId);
                    if (order == null)
                    {
                        return new ServiceResponse
                        {
                            Success = false,
                            ErrorMessage = "Order not found"
                        };
                    }

                    // Validate payment amount matches order total
                    if (payment.Amount != order.TotalAmount)
                    {
                        return new ServiceResponse
                        {
                            Success = false,
                            ErrorMessage = "Payment amount does not match order total"
                        };
                    }

                    // Process payment based on payment method
                    string transactionId;
                    bool paymentSuccess = false;

                    switch (payment.PaymentMethod.ToLower())
                    {
                        case "payfast":
                            paymentSuccess = ProcessPayFastPayment(payment, out transactionId);
                            break;

                        case "eft":
                            paymentSuccess = ProcessEFTPayment(payment, out transactionId);
                            break;

                        case "cashondelivery":
                            paymentSuccess = ProcessCashOnDelivery(payment, out transactionId);
                            break;

                        default:
                            return new ServiceResponse
                            {
                                Success = false,
                                ErrorMessage = "Invalid payment method"
                            };
                    }

                    if (paymentSuccess)
                    {
                        // Create payment record
                        var paymentRecord = new Payment
                        {
                            OrderID = orderId,
                            Amount = payment.Amount,
                            PaymentMethod = payment.PaymentMethod,
                            PaymentStatus = "Completed",
                            TransactionID = transactionId,
                            PaymentDate = DateTime.Now
                        };

                        db.Payments.InsertOnSubmit(paymentRecord);

                        // Update order status
                        order.PaymentStatus = "Paid";
                        order.Status = "Processing";

                        db.SubmitChanges();
                        transaction.Complete();

                        // Send confirmation email
                        SendPaymentConfirmationEmail(orderId, paymentRecord);

                        return new ServiceResponse
                        {
                            Success = true
                        };
                    }
                    else
                    {
                        return new ServiceResponse
                        {
                            Success = false,
                            ErrorMessage = "Payment processing failed"
                        };
                    }
                }
            }
            catch (Exception ex)
            {
                return new ServiceResponse
                {
                    Success = false,
                    ErrorMessage = $"Payment processing error: {ex.Message}"
                };
            }
        }

        private bool ProcessPayFastPayment(Payment payment, out string transactionId)
        {
            try
            {
                // PayFast integration logic
                // This would be the actual PayFast API integration
                transactionId = $"PF_{DateTime.Now:yyyyMMddHHmmss}_{Guid.NewGuid().ToString("N").Substring(0, 8)}";

                // Simulate successful payment for demo purposes
                // In production, you would:
                // 1. Create payment request to PayFast
                // 2. Handle the response
                // 3. Verify the payment status

                // Example PayFast integration (pseudo-code):
                /*
                var payFastRequest = new PayFastRequest
                {
                    merchant_id = ConfigurationManager.AppSettings["PayFastMerchantId"],
                    merchant_key = ConfigurationManager.AppSettings["PayFastMerchantKey"],
                    amount = payment.Amount,
                    item_name = "Ubuntu Wears Order",
                    return_url = "https://yourdomain.com/PaymentSuccess.aspx",
                    cancel_url = "https://yourdomain.com/PaymentCancel.aspx",
                    notify_url = "https://yourdomain.com/PaymentNotify.aspx"
                };

                var response = PayFastClient.ProcessPayment(payFastRequest);
                transactionId = response.TransactionId;
                return response.Success;
                */

                return true; // Simulate success
            }
            catch (Exception)
            {
                transactionId = null;
                return false;
            }
        }

        private bool ProcessEFTPayment(Payment payment, out string transactionId)
        {
            try
            {
                // EFT payment processing logic
                // Generate reference number and provide banking details
                transactionId = $"EFT_{DateTime.Now:yyyyMMddHHmmss}";

                // In a real implementation, you would:
                // 1. Generate a unique payment reference
                // 2. Store the EFT details
                // 3. Set up payment verification process

                return true; // EFT payments are typically marked as pending until verified
            }
            catch (Exception)
            {
                transactionId = null;
                return false;
            }
        }

        private bool ProcessCashOnDelivery(Payment payment, out string transactionId)
        {
            try
            {
                // Cash on delivery processing
                transactionId = $"COD_{DateTime.Now:yyyyMMddHHmmss}";

                // For COD, payment is collected upon delivery
                // Mark as pending until delivered and paid
                return true;
            }
            catch (Exception)
            {
                transactionId = null;
                return false;
            }
        }

        private void SendPaymentConfirmationEmail(int orderId, Payment payment)
        {
            try
            {
                var order = db.Orders.FirstOrDefault(o => o.OrderID == orderId);
                if (order != null)
                {
                    var user = db.Users.FirstOrDefault(u => u.UserID == order.UserID);

                    // Email content
                    string subject = $"Payment Confirmation - Order #{orderId}";
                    string body = $@"
                <h2>Payment Confirmation</h2>
                <p>Dear {user.FirstName} {user.LastName},</p>
                <p>Your payment for Order #{orderId} has been successfully processed.</p>
                
                <h3>Payment Details:</h3>
                <ul>
                    <li><strong>Amount:</strong> R{payment.Amount:F2}</li>
                    <li><strong>Payment Method:</strong> {payment.PaymentMethod}</li>
                    <li><strong>Transaction ID:</strong> {payment.TransactionID}</li>
                    <li><strong>Payment Date:</strong> {payment.PaymentDate:yyyy-MM-dd HH:mm}</li>
                </ul>
                
                <h3>Order Summary:</h3>
                <p>Total Amount: R{order.TotalAmount:F2}</p>
                
                <p>Thank you for shopping with Ubuntu Wears!</p>
                <p><a href='https://ubuntuwears.com/OrderDetails.aspx?id={orderId}'>View Order Details</a></p>
            ";

                    // Send email (implementation depends on your email service)
                    // EmailService.SendEmail(user.Email, subject, body);
                }
            }
            catch (Exception ex)
            {
                // Log email sending error
                System.Diagnostics.Debug.WriteLine($"Email sending failed: {ex.Message}");
            }
        }

        ServiceResponse<List<UserEntity>> IUbuntuWearsService.GetUsers()
        {
            var response = new ServiceResponse<List<UserEntity>>();

            try
            {
                using (var context = new UbuntuWearsDataContext()) // Replace with your actual DbContext
                {
                    // LINQ query to fetch all users and map to UserEntity
                    var users = context.Users
                        .Select(u => new UserEntity
                        {
                            UserID = u.UserID,
                            FirstName = u.FirstName,
                            LastName = u.LastName,
                            Username = u.Username,
                            Email = u.Email,
                            PhoneNumber = u.PhoneNumber,
                            UserType = u.UserType,
                            DataCreated = u.DateCreated
                        })
                        .ToList();

                    response.Data = users;
                    response.Success = true; 
                }
            }
            catch (Exception ex)
            {
                response.Success = false;
                response.Data = new List<UserEntity>();
            }

            return response;
        }
        #endregion

        #region Invoicing & Reports Methods

        public ServiceResponse<List<UserEntity>> GetAdminUsers()
        {
            try
            {
                var adminUsers = db.Users
                    .Where(u => u.UserType == "Manager" || db.AdminManagements.Any(a => a.UserID == u.UserID))
                    .Select(u => new UserEntity
                    {
                        UserID = u.UserID,
                        FirstName = u.FirstName,
                        LastName = u.LastName,
                        Username = u.Username,
                        Email = u.Email,
                        PhoneNumber = u.PhoneNumber,
                        UserType = u.UserType,
                        DataCreated = u.DateCreated
                    }).ToList();

                return new ServiceResponse<List<UserEntity>>
                {
                    Success = true,
                    Data = adminUsers
                };
            }
            catch (Exception ex)
            {
                return new ServiceResponse<List<UserEntity>>
                {
                    Success = false,
                    ErrorMessage = $"Error getting admin users: {ex.Message}"
                };
            }
        }

        public ServiceResponse<InvoiceEntity> GenerateInvoice(int orderId)
        {
            try
            {
                var order = db.Orders.FirstOrDefault(o => o.OrderID == orderId);
                if (order == null)
                {
                    return new ServiceResponse<InvoiceEntity>
                    {
                        Success = false,
                        ErrorMessage = "Order not found"
                    };
                }

                // Check if invoice already exists
                var existingInvoice = db.Invoices.FirstOrDefault(i => i.OrderID == orderId);
                if (existingInvoice != null)
                {
                    return GetInvoice(existingInvoice.InvoiceID);
                }

                using (var transaction = new TransactionScope())
                {
                    // Generate invoice number
                    string invoiceNumber = $"INV-{DateTime.Now:yyyyMMdd}-{orderId:0000}";

                    // Calculate totals (assuming 15% VAT for South Africa)
                    decimal taxRate = 0.15m;
                    decimal taxAmount = order.TotalAmount * taxRate;
                    decimal grandTotal = order.TotalAmount + taxAmount;

                    var invoice = new Invoice
                    {
                        OrderID = orderId,
                        InvoiceNumber = invoiceNumber,
                        InvoiceDate = DateTime.Now,
                        DueDate = DateTime.Now.AddDays(30),
                        TotalAmount = order.TotalAmount,
                        TaxAmount = taxAmount,
                        DiscountAmount = 0,
                        GrandTotal = grandTotal,
                        Status = order.PaymentStatus == "Paid" ? "Paid" : "Pending",
                        CreatedAt = DateTime.Now
                    };

                    db.Invoices.InsertOnSubmit(invoice);
                    db.SubmitChanges();

                    // Add invoice items
                    foreach (var orderItem in order.OrderItems)
                    {
                        var invoiceItem = new InvoiceItem
                        {
                            InvoiceID = invoice.InvoiceID,
                            ProductID = orderItem.ProductID,
                            Quantity = orderItem.Quantity,
                            UnitPrice = orderItem.Price,
                            TotalPrice = orderItem.Quantity * orderItem.Price
                        };
                        db.InvoiceItems.InsertOnSubmit(invoiceItem);
                    }

                    db.SubmitChanges();
                    transaction.Complete();

                    return GetInvoice(invoice.InvoiceID);
                }
            }
            catch (Exception ex)
            {
                return new ServiceResponse<InvoiceEntity>
                {
                    Success = false,
                    ErrorMessage = $"Error generating invoice: {ex.Message}"
                };
            }
        }

        public ServiceResponse<List<InvoiceEntity>> GetInvoices(DateTime? startDate = null, DateTime? endDate = null)
        {
            try
            {
                var query = db.Invoices.AsQueryable();

                if (startDate.HasValue)
                {
                    query = query.Where(i => i.InvoiceDate >= startDate.Value);
                }

                if (endDate.HasValue)
                {
                    query = query.Where(i => i.InvoiceDate <= endDate.Value);
                }

                var invoices = query
                    .OrderByDescending(i => i.InvoiceDate)
                    .Select(i => new InvoiceEntity
                    {
                        InvoiceID = i.InvoiceID,
                        OrderID = i.OrderID,
                        InvoiceNumber = i.InvoiceNumber,
                        InvoiceDate = i.InvoiceDate,
                        DueDate = i.DueDate,
                        TotalAmount = i.TotalAmount,
                        TaxAmount = (decimal)i.TaxAmount,
                        DiscountAmount = (decimal)i.DiscountAmount,
                        GrandTotal = i.GrandTotal,
                        Status = i.Status,
                        CreatedAt = (DateTime)i.CreatedAt,
                        Order = new OrderEntity
                        {
                            OrderID = i.Order.OrderID,
                            TotalAmount = i.Order.TotalAmount,
                            Status = i.Order.Status
                        },
                        Customer = new UserEntity
                        {
                            UserID = i.Order.User.UserID,
                            FirstName = i.Order.User.FirstName,
                            LastName = i.Order.User.LastName,
                            Email = i.Order.User.Email
                        }
                    }).ToList();

                return new ServiceResponse<List<InvoiceEntity>>
                {
                    Success = true,
                    Data = invoices
                };
            }
            catch (Exception ex)
            {
                return new ServiceResponse<List<InvoiceEntity>>
                {
                    Success = false,
                    ErrorMessage = $"Error getting invoices: {ex.Message}"
                };
            }
        }

        public ServiceResponse<InvoiceEntity> GetInvoice(int invoiceId)
        {
            try
            {
                var invoice = db.Invoices.FirstOrDefault(i => i.InvoiceID == invoiceId);
                if (invoice == null)
                {
                    return new ServiceResponse<InvoiceEntity>
                    {
                        Success = false,
                        ErrorMessage = "Invoice not found"
                    };
                }

                var invoiceDetails = new InvoiceEntity
                {
                    InvoiceID = invoice.InvoiceID,
                    OrderID = invoice.OrderID,
                    InvoiceNumber = invoice.InvoiceNumber,
                    InvoiceDate = invoice.InvoiceDate,
                    DueDate = invoice.DueDate,
                    TotalAmount = invoice.TotalAmount,
                    TaxAmount = (decimal)invoice.TaxAmount,
                    DiscountAmount = (decimal)invoice.DiscountAmount,
                    GrandTotal = invoice.GrandTotal,
                    Status = invoice.Status,
                    CreatedAt = (DateTime)invoice.CreatedAt,
                    InvoiceItems = invoice.InvoiceItems.Select(ii => new InvoiceItemEntity
                    {
                        InvoiceItemID = ii.InvoiceItemID,
                        InvoiceID = ii.InvoiceID,
                        ProductID = ii.ProductID,
                        Quantity = ii.Quantity,
                        UnitPrice = ii.UnitPrice,
                        TotalPrice = ii.TotalPrice,
                        Product = new ProductEntity
                        {
                            ProductID = ii.Product.ProductID,
                            Name = ii.Product.Name,
                            Price = ii.Product.Price
                        }
                    }).ToList(),
                    Order = new OrderEntity
                    {
                        OrderID = invoice.Order.OrderID,
                        TotalAmount = invoice.Order.TotalAmount,
                        Status = invoice.Order.Status
                    },
                    Customer = new UserEntity
                    {
                        UserID = invoice.Order.User.UserID,
                        FirstName = invoice.Order.User.FirstName,
                        LastName = invoice.Order.User.LastName,
                        Email = invoice.Order.User.Email,
                        PhoneNumber = invoice.Order.User.PhoneNumber
                    }
                };

                return new ServiceResponse<InvoiceEntity>
                {
                    Success = true,
                    Data = invoiceDetails
                };
            }
            catch (Exception ex)
            {
                return new ServiceResponse<InvoiceEntity>
                {
                    Success = false,
                    ErrorMessage = $"Error getting invoice: {ex.Message}"
                };
            }
        }

        public ServiceResponse<SalesReport> GenerateSalesReport(DateTime startDate, DateTime endDate)
        {
            try
            {
                // normalize endDate to include the entire last day
                var endExclusive = endDate.AddDays(1);

                var salesReport = new SalesReport
                {
                    StartDate = startDate,
                    EndDate = endDate,

                    TotalSales = db.Orders
                        .Where(o => o.CreatedAt >= startDate && o.CreatedAt < endExclusive && o.PaymentStatus == "Paid")
                        .Sum(o => (decimal?)o.TotalAmount) ?? 0,

                    TotalOrders = db.Orders
                        .Count(o => o.CreatedAt >= startDate && o.CreatedAt < endExclusive),

                    TotalCustomers = db.Orders
                        .Where(o => o.CreatedAt >= startDate && o.CreatedAt < endExclusive)
                        .Select(o => o.UserID)
                        .Distinct()
                        .Count()
                };

                salesReport.AverageOrderValue = salesReport.TotalOrders > 0
                    ? salesReport.TotalSales / salesReport.TotalOrders
                    : 0;

                // Sales by category
                salesReport.SalesByCategories = db.OrderItems
                    .Where(oi => oi.Order.CreatedAt >= startDate && oi.Order.CreatedAt < endExclusive && oi.Order.PaymentStatus == "Paid")
                    .GroupBy(oi => oi.Product.Category)
                    .Select(g => new SalesByCategory
                    {
                        Category = g.Key,
                        TotalSales = g.Sum(oi => oi.Quantity * oi.Price),
                        TotalItems = g.Sum(oi => oi.Quantity)
                    })
                    .ToList();

                // Sales by date
                salesReport.SalesByDates = Enumerable.Range(0, (endDate - startDate).Days + 1)
                    .Select(offset => startDate.AddDays(offset).Date)
                    .Select(date => new SalesByDate
                    {
                        Date = date,
                        DailySales = db.Orders
                            .Where(o => o.CreatedAt >= date && o.CreatedAt < date.AddDays(1) && o.PaymentStatus == "Paid")
                            .Sum(o => (decimal?)o.TotalAmount) ?? 0,
                        DailyOrders = db.Orders
                            .Count(o => o.CreatedAt >= date && o.CreatedAt < date.AddDays(1) && o.PaymentStatus == "Paid")
                    })
                    .ToList();

                // Top selling products
                salesReport.TopSellingProducts = db.OrderItems
                    .Where(oi => oi.Order.CreatedAt >= startDate && oi.Order.CreatedAt < endExclusive && oi.Order.PaymentStatus == "Paid")
                    .GroupBy(oi => new { oi.ProductID, oi.Product.Name })
                    .Select(g => new TopSellingProduct
                    {
                        ProductID = g.Key.ProductID,
                        ProductName = g.Key.Name,
                        QuantitySold = g.Sum(oi => oi.Quantity),
                        TotalRevenue = g.Sum(oi => oi.Quantity * oi.Price)
                    })
                    .OrderByDescending(p => p.TotalRevenue)
                    .Take(10)
                    .ToList();

                // Save report metadata
                SaveReportMetadata("Sales", $"Sales Report {startDate:yyyy-MM-dd} to {endDate:yyyy-MM-dd}",
                    GetCurrentUserId(), startDate, endDate);

                return new ServiceResponse<SalesReport>
                {
                    Success = true,
                    Data = salesReport
                };
            }
            catch (Exception ex)
            {
                return new ServiceResponse<SalesReport>
                {
                    Success = false,
                    ErrorMessage = $"Error generating sales report: {ex.Message}"
                };
            }
        }


        public ServiceResponse<InventoryReport> GenerateInventoryReport()
        {
            try
            {
                var inventoryReport = new InventoryReport
                {
                    TotalProducts = db.Products.Count(p => p.isActive),
                    OutOfStockProducts = db.Products.Count(p => p.isActive && p.Stock == 0),
                    LowStockProducts = db.Products.Count(p => p.isActive && p.Stock > 0 && p.Stock <= 10),
                    TotalInventoryValue = db.Products.Where(p => p.isActive).Sum(p => (decimal?)(p.Stock * p.Price)) ?? 0
                };

                inventoryReport.InventoryItems = db.Products
                    .Where(p => p.isActive)
                    .Select(p => new InventoryItem
                    {
                        ProductID = p.ProductID,
                        ProductName = p.Name,
                        CurrentStock = p.Stock,
                        UnitPrice = p.Price,
                        TotalValue = p.Stock * p.Price,
                        StockStatus = p.Stock == 0 ? "Out of Stock" : p.Stock <= 10 ? "Low Stock" : "In Stock"
                    })
                    .OrderByDescending(i => i.TotalValue)
                    .ToList();

                // Save report metadata
                SaveReportMetadata("Inventory", "Inventory Report", GetCurrentUserId());

                return new ServiceResponse<InventoryReport>
                {
                    Success = true,
                    Data = inventoryReport
                };
            }
            catch (Exception ex)
            {
                return new ServiceResponse<InventoryReport>
                {
                    Success = false,
                    ErrorMessage = $"Error generating inventory report: {ex.Message}"
                };
            }
        }

        public ServiceResponse<CustomerReport> GenerateCustomerReport(DateTime? startDate = null, DateTime? endDate = null)
        {
            try
            {
                var customerReport = new CustomerReport
                {
                    TotalCustomers = db.Users.Count(),
                    NewCustomers = startDate.HasValue && endDate.HasValue
                        ? db.Users.Count(u => u.DateCreated >= startDate.Value
                                           && u.DateCreated < endDate.Value.AddDays(1))
                        : db.Users.Count()
                };

                // Top customers by spending
                customerReport.TopCustomers = db.Orders
                    .Where(o => o.PaymentStatus == "Paid")
                    .GroupBy(o => new { o.User.UserID, o.User.FirstName, o.User.LastName })
                    .Select(g => new TopCustomer
                    {
                        CustomerID = g.Key.UserID,
                        CustomerName = $"{g.Key.FirstName} {g.Key.LastName}",
                        TotalSpent = g.Sum(o => o.TotalAmount),
                        TotalOrders = g.Count()
                    })
                    .OrderByDescending(c => c.TotalSpent)
                    .Take(10)
                    .ToList();

                // Customer activity timeline
                if (startDate.HasValue && endDate.HasValue)
                {
                    customerReport.CustomerActivities = Enumerable.Range(0, (endDate.Value - startDate.Value).Days + 1)
                        .Select(offset => startDate.Value.AddDays(offset).Date)
                        .Select(date => new CustomerActivity
                        {
                            Date = date,
                            NewRegistrations = db.Users.Count(u => u.DateCreated >= date
                                                               && u.DateCreated < date.AddDays(1)),
                            OrdersPlaced = db.Orders.Count(o => o.PaymentStatus == "Paid"
                                                             && o.CreatedAt >= date
                                                             && o.CreatedAt < date.AddDays(1))
                        })
                        .ToList();
                }

                // Save report metadata
                SaveReportMetadata("Customer", "Customer Report", GetCurrentUserId(), startDate, endDate);

                return new ServiceResponse<CustomerReport>
                {
                    Success = true,
                    Data = customerReport
                };
            }
            catch (Exception ex)
            {
                return new ServiceResponse<CustomerReport>
                {
                    Success = false,
                    ErrorMessage = $"Error generating customer report: {ex.Message}"
                };
            }
        }


        public ServiceResponse<List<ReportEntity>> GetGeneratedReports(string reportType = null)
        {
            try
            {
                var query = db.Reports.AsQueryable();

                if (!string.IsNullOrEmpty(reportType))
                {
                    query = query.Where(r => r.ReportType == reportType);
                }

                var reports = query
                    .OrderByDescending(r => r.GeneratedDate)
                    .Select(r => new ReportEntity
                    {
                        ReportID = r.ReportID,
                        ReportType = r.ReportType,
                        ReportName = r.ReportName,
                        GeneratedBy = r.GeneratedBy,
                        GeneratedDate = r.GeneratedDate,
                        StartDate = r.StartDate,
                        EndDate = r.EndDate,
                        FilePath = r.FilePath,
                        FileFormat = r.FileFormat,
                        GeneratedByUser = new UserEntity
                        {
                            UserID = r.User.UserID,
                            FirstName = r.User.FirstName,
                            LastName = r.User.LastName,
                            Username = r.User.Username
                        }
                    })
                    .ToList();

                return new ServiceResponse<List<ReportEntity>>
                {
                    Success = true,
                    Data = reports
                };
            }
            catch (Exception ex)
            {
                return new ServiceResponse<List<ReportEntity>>
                {
                    Success = false,
                    ErrorMessage = $"Error getting reports: {ex.Message}"
                };
            }
        }

        private void SaveReportMetadata(string reportType, string reportName, int generatedBy,
            DateTime? startDate = null, DateTime? endDate = null)
        {
            try
            {
                var report = new Report
                {
                    ReportType = reportType,
                    ReportName = reportName,
                    GeneratedBy = generatedBy,
                    GeneratedDate = DateTime.Now,
                    StartDate = startDate,
                    EndDate = endDate,
                    FileFormat = "PDF", // Default format
                    IsArchived = false
                };

                db.Reports.InsertOnSubmit(report);
                db.SubmitChanges();
            }
            catch (Exception ex)
            {
                // Log error but don't break the report generation
                System.Diagnostics.Debug.WriteLine($"Error saving report metadata: {ex.Message}");
            }
        }

        #endregion

        #region Discount Methods
        public ServiceResponse<List<DiscountA>> GetAllDiscounts()
        {
            try
            {
                var discounts = db.Discounts
                    .OrderByDescending(d => d.CreatedAt)
                    .Select(d => new DiscountA
                    {
                        DiscountID = d.DiscountID,
                        Code = d.Code,
                        Description = d.Description,
                        DiscountType = d.DiscountType,
                        DiscountValue = d.DiscountValue,
                        MinOrderAmount = (decimal)d.MinOrderAmount,
                        MaxUses = (int)d.MaxUses,
                        UsedCount = d.UsedCount,
                        StartDate = d.StartDate,
                        EndDate = d.EndDate,
                        IsActive = d.IsActive,
                        CreatedAt = d.CreatedAt
                    }).ToList();

                return new ServiceResponse<List<DiscountA>>
                {
                    Success = true,
                    Data = discounts
                };
            }
            catch (Exception ex)
            {
                return new ServiceResponse<List<DiscountA>>
                {
                    Success = false,
                    ErrorMessage = $"Error getting discounts: {ex.Message}"
                };
            }
        }

        public ServiceResponse<DiscountA> GetDiscount(int discountId)
        {
            try
            {
                var discount = db.Discounts.FirstOrDefault(d => d.DiscountID == discountId);
                if (discount == null)
                {
                    return new ServiceResponse<DiscountA>
                    {
                        Success = false,
                        ErrorMessage = "Discount not found"
                    };
                }

                return new ServiceResponse<DiscountA>
                {
                    Success = true,
                    Data = new DiscountA
                    {
                        DiscountID = discount.DiscountID,
                        Code = discount.Code,
                        Description = discount.Description,
                        DiscountType = discount.DiscountType,
                        DiscountValue = discount.DiscountValue,
                        MinOrderAmount = (decimal)discount.MinOrderAmount,
                        MaxUses = (int)discount.MaxUses,
                        UsedCount = discount.UsedCount,
                        StartDate = discount.StartDate,
                        EndDate = discount.EndDate,
                        IsActive = discount.IsActive,
                        CreatedAt = discount.CreatedAt
                    }
                };
            }
            catch (Exception ex)
            {
                return new ServiceResponse<DiscountA>
                {
                    Success = false,
                    ErrorMessage = $"Error getting discount: {ex.Message}"
                };
            }
        }

        public ServiceResponse<DiscountA> CreateDiscount(DiscountA discount)
        {
            try
            {
                // Check if discount code already exists
                if (db.Discounts.Any(d => d.Code == discount.Code))
                {
                    return new ServiceResponse<DiscountA>
                    {
                        Success = false,
                        ErrorMessage = "Discount code already exists"
                    };
                }

                var newDiscount = new Discount
                {
                    Code = discount.Code,
                    Description = discount.Description,
                    DiscountType = discount.DiscountType,
                    DiscountValue = discount.DiscountValue,
                    MinOrderAmount = discount.MinOrderAmount,
                    MaxUses = discount.MaxUses,
                    UsedCount = 0,
                    StartDate = discount.StartDate,
                    EndDate = discount.EndDate,
                    IsActive = discount.IsActive,
                    CreatedAt = DateTime.Now
                };

                db.Discounts.InsertOnSubmit(newDiscount);
                db.SubmitChanges();

                return new ServiceResponse<DiscountA>
                {
                    Success = true,
                    Data = new DiscountA
                    {
                        DiscountID = newDiscount.DiscountID,
                        Code = newDiscount.Code,
                        Description = newDiscount.Description,
                        DiscountType = newDiscount.DiscountType,
                        DiscountValue = newDiscount.DiscountValue,
                        MinOrderAmount = (decimal)newDiscount.MinOrderAmount,
                        MaxUses = (int)newDiscount.MaxUses,
                        UsedCount = newDiscount.UsedCount,
                        StartDate = newDiscount.StartDate,
                        EndDate = newDiscount.EndDate,
                        IsActive = newDiscount.IsActive,
                        CreatedAt = newDiscount.CreatedAt
                    }
                };
            }
            catch (Exception ex)
            {
                return new ServiceResponse<DiscountA>
                {
                    Success = false,
                    ErrorMessage = $"Error creating discount: {ex.Message}"
                };
            }
        }

        public ServiceResponse<DiscountA> UpdateDiscount(DiscountA discount)
        {
            try
            {
                var existingDiscount = db.Discounts.FirstOrDefault(d => d.DiscountID == discount.DiscountID);
                if (existingDiscount == null)
                {
                    return new ServiceResponse<DiscountA>
                    {
                        Success = false,
                        ErrorMessage = "Discount not found"
                    };
                }

                // Check if discount code already exists (excluding current discount)
                if (db.Discounts.Any(d => d.Code == discount.Code && d.DiscountID != discount.DiscountID))
                {
                    return new ServiceResponse<DiscountA>
                    {
                        Success = false,
                        ErrorMessage = "Discount code already exists"
                    };
                }

                existingDiscount.Code = discount.Code;
                existingDiscount.Description = discount.Description;
                existingDiscount.DiscountType = discount.DiscountType;
                existingDiscount.DiscountValue = discount.DiscountValue;
                existingDiscount.MinOrderAmount = discount.MinOrderAmount;
                existingDiscount.MaxUses = discount.MaxUses;
                existingDiscount.StartDate = discount.StartDate;
                existingDiscount.EndDate = discount.EndDate;
                existingDiscount.IsActive = discount.IsActive;

                db.SubmitChanges();

                return new ServiceResponse<DiscountA>
                {
                    Success = true,
                    Data = new DiscountA
                    {
                        DiscountID = existingDiscount.DiscountID,
                        Code = existingDiscount.Code,
                        Description = existingDiscount.Description,
                        DiscountType = existingDiscount.DiscountType,
                        DiscountValue = existingDiscount.DiscountValue,
                        MinOrderAmount = (decimal)existingDiscount.MinOrderAmount,
                        MaxUses = (int)existingDiscount.MaxUses,
                        UsedCount = existingDiscount.UsedCount,
                        StartDate = existingDiscount.StartDate,
                        EndDate = existingDiscount.EndDate,
                        IsActive = existingDiscount.IsActive,
                        CreatedAt = existingDiscount.CreatedAt
                    }
                };
            }
            catch (Exception ex)
            {
                return new ServiceResponse<DiscountA>
                {
                    Success = false,
                    ErrorMessage = $"Error updating discount: {ex.Message}"
                };
            }
        }

        public ServiceResponse ToggleDiscountStatus(int discountId)
        {
            try
            {
                var discount = db.Discounts.FirstOrDefault(d => d.DiscountID == discountId);
                if (discount == null)
                {
                    return new ServiceResponse
                    {
                        Success = false,
                        ErrorMessage = "Discount not found"
                    };
                }

                discount.IsActive = !discount.IsActive;
                db.SubmitChanges();

                return new ServiceResponse
                {
                    Success = true
                };
            }
            catch (Exception ex)
            {
                return new ServiceResponse
                {
                    Success = false,
                    ErrorMessage = $"Error toggling discount status: {ex.Message}"
                };
            }
        }

        public ServiceResponse DeleteDiscount(int discountId)
        {
            try
            {
                var discount = db.Discounts.FirstOrDefault(d => d.DiscountID == discountId);
                if (discount == null)
                {
                    return new ServiceResponse
                    {
                        Success = false,
                        ErrorMessage = "Discount not found"
                    };
                }

                db.Discounts.DeleteOnSubmit(discount);
                db.SubmitChanges();

                return new ServiceResponse
                {
                    Success = true
                };
            }
            catch (Exception ex)
            {
                return new ServiceResponse
                {
                    Success = false,
                    ErrorMessage = $"Error deleting discount: {ex.Message}"
                };
            }
        }

        public ServiceResponse<decimal> ApplyDiscount(string discountCode, decimal orderAmount)
        {
            try
            {
                var discount = db.Discounts.FirstOrDefault(d => d.Code == discountCode && d.IsActive);
                if (discount == null)
                {
                    return new ServiceResponse<decimal>
                    {
                        Success = false,
                        ErrorMessage = "Invalid or inactive discount code"
                    };
                }

                // Check if discount has expired
                if (DateTime.Now < discount.StartDate || DateTime.Now > discount.EndDate)
                {
                    return new ServiceResponse<decimal>
                    {
                        Success = false,
                        ErrorMessage = "Discount code has expired"
                    };
                }

                // Check if discount has reached maximum uses
                if (discount.MaxUses > 0 && discount.UsedCount >= discount.MaxUses)
                {
                    return new ServiceResponse<decimal>
                    {
                        Success = false,
                        ErrorMessage = "Discount code has reached maximum uses"
                    };
                }

                // Check if order meets minimum amount requirement
                if (orderAmount < discount.MinOrderAmount)
                {
                    return new ServiceResponse<decimal>
                    {
                        Success = false,
                        ErrorMessage = $"Order must be at least R{discount.MinOrderAmount:F2} to use this discount"
                    };
                }

                decimal discountAmount = 0;

                if (discount.DiscountType == "Percentage")
                {
                    discountAmount = orderAmount * (discount.DiscountValue / 100);
                }
                else // FixedAmount
                {
                    discountAmount = discount.DiscountValue;
                }

                // Ensure discount doesn't make order negative
                if (discountAmount > orderAmount)
                {
                    discountAmount = orderAmount;
                }

                return new ServiceResponse<decimal>
                {
                    Success = true,
                    Data = discountAmount
                };
            }
            catch (Exception ex)
            {
                return new ServiceResponse<decimal>
                {
                    Success = false,
                    ErrorMessage = $"Error applying discount: {ex.Message}"
                };
            }
        }
        #endregion

        #region Address Methods
        public ServiceResponse<List<Address>> GetUserAddresses(int userId)
        {
            try
            {
                var addresses = db.Addresses
                    .Where(a => a.UserID == userId)
                    .OrderByDescending(a => a.IsDefault)
                    .ThenByDescending(a => a.CreatedAt)
                    .Select(a => new Address
                    {
                        AddressID = a.AddressID,
                        UserID = a.UserID,
                        AddressName = a.AddressName,
                        StreetAddress = a.StreetAddress,
                        City = a.City,
                        PostalCode = a.PostalCode,
                        Province = a.Province,
                        IsDefault = a.IsDefault,
                        CreatedAt = a.CreatedAt
                    }).ToList();

                return new ServiceResponse<List<Address>>
                {
                    Success = true,
                    Data = addresses
                };
            }
            catch (Exception ex)
            {
                return new ServiceResponse<List<Address>>
                {
                    Success = false,
                    ErrorMessage = $"Error getting addresses: {ex.Message}"
                };
            }
        }

        public ServiceResponse<Address> GetAddress(int addressId)
        {
            try
            {
                var address = db.Addresses.FirstOrDefault(a => a.AddressID == addressId);
                if (address == null)
                {
                    return new ServiceResponse<Address>
                    {
                        Success = false,
                        ErrorMessage = "Address not found"
                    };
                }

                return new ServiceResponse<Address>
                {
                    Success = true,
                    Data = new Address
                    {
                        AddressID = address.AddressID,
                        UserID = address.UserID,
                        AddressName = address.AddressName,
                        StreetAddress = address.StreetAddress,
                        City = address.City,
                        PostalCode = address.PostalCode,
                        Province = address.Province,
                        IsDefault = address.IsDefault,
                        CreatedAt = address.CreatedAt
                    }
                };
            }
            catch (Exception ex)
            {
                return new ServiceResponse<Address>
                {
                    Success = false,
                    ErrorMessage = $"Error getting address: {ex.Message}"
                };
            }
        }

        public ServiceResponse<Address> SaveAddress(Address address)
        {
            try
            {
                // If this is set as default, remove default from other addresses
                if (address.IsDefault)
                {
                    var currentDefault = db.Addresses.FirstOrDefault(a => a.UserID == address.UserID && a.IsDefault);
                    if (currentDefault != null)
                    {
                        currentDefault.IsDefault = false;
                    }
                }

                Address addressEntity;

                if (address.AddressID > 0)
                {
                    // Update existing address
                    addressEntity = db.Addresses.FirstOrDefault(a => a.AddressID == address.AddressID);
                    if (addressEntity == null)
                    {
                        return new ServiceResponse<Address>
                        {
                            Success = false,
                            ErrorMessage = "Address not found"
                        };
                    }
                }
                else
                {
                    // Create new address
                    addressEntity = new Address
                    {
                        UserID = address.UserID,
                        CreatedAt = DateTime.Now
                    };
                    db.Addresses.InsertOnSubmit(addressEntity);
                }

                addressEntity.AddressName = address.AddressName;
                addressEntity.StreetAddress = address.StreetAddress;
                addressEntity.City = address.City;
                addressEntity.PostalCode = address.PostalCode;
                addressEntity.Province = address.Province;
                addressEntity.IsDefault = address.IsDefault;

                db.SubmitChanges();

                return new ServiceResponse<Address>
                {
                    Success = true,
                    Data = new Address
                    {
                        AddressID = addressEntity.AddressID,
                        UserID = addressEntity.UserID,
                        AddressName = addressEntity.AddressName,
                        StreetAddress = addressEntity.StreetAddress,
                        City = addressEntity.City,
                        PostalCode = addressEntity.PostalCode,
                        Province = addressEntity.Province,
                        IsDefault = addressEntity.IsDefault,
                        CreatedAt = addressEntity.CreatedAt
                    }
                };
            }
            catch (Exception ex)
            {
                return new ServiceResponse<Address>
                {
                    Success = false,
                    ErrorMessage = $"Error saving address: {ex.Message}"
                };
            }
        }

        public ServiceResponse DeleteAddress(int addressId)
        {
            try
            {
                var address = db.Addresses.FirstOrDefault(a => a.AddressID == addressId);
                if (address == null)
                {
                    return new ServiceResponse
                    {
                        Success = false,
                        ErrorMessage = "Address not found"
                    };
                }

                db.Addresses.DeleteOnSubmit(address);
                db.SubmitChanges();

                return new ServiceResponse
                {
                    Success = true
                };
            }
            catch (Exception ex)
            {
                return new ServiceResponse
                {
                    Success = false,
                    ErrorMessage = $"Error deleting address: {ex.Message}"
                };
            }
        }

        public ServiceResponse SetDefaultAddress(int userId, int addressId)
        {
            try
            {
                // Remove default from all addresses
                var addresses = db.Addresses.Where(a => a.UserID == userId);
                foreach (var address in addresses)
                {
                    address.IsDefault = false;
                }

                // Set the specified address as default
                var defaultAddress = db.Addresses.FirstOrDefault(a => a.AddressID == addressId && a.UserID == userId);
                if (defaultAddress != null)
                {
                    defaultAddress.IsDefault = true;
                }

                db.SubmitChanges();

                return new ServiceResponse
                {
                    Success = true
                };
            }
            catch (Exception ex)
            {
                return new ServiceResponse
                {
                    Success = false,
                    ErrorMessage = $"Error setting default address: {ex.Message}"
                };
            }
        }
        #endregion
    }
}
