# Ubuntu Wears

An Amazon-style e-commerce platform specializing in authentic, stylish traditional attire, built with ASP.NET Web Forms and a WCF Service.

## 🚀 Features

*   **Product Catalog:** Dynamic product loading from DB, sorting, and filtering.
*   **User Management:** User registration, login, and role-based access (Customer/Admin).
*   **Shopping Cart:** Add, remove, and update items with a full checkout process.
*   **Transaction Processing:** Implements business rules like VAT, discounts, and free shipping.
*   **Product Management (Admin):** Full CRUD (Create, Read, Update, Delete) operations for products.
*   **Reporting & Invoices:** Admin dashboard with sales reports, inventory levels, and user registration stats. Customers can view their order history.
*   **Service Layer:** A dedicated WCF service handles all business logic and database operations.

## 🛠️ Built With

*   **Frontend:** ASP.NET Web Forms (C#), Javascript
*   **Backend Service:** WCF (Windows Communication Foundation)
*   **Database:** MS SQL Server
*   **Styling:** HTML, CSS, Bootstrap


## 📦 Database Setup

1.  Attach the provided `.mdf` file (located in `App_Data/`) to your LocalDB instance.
2.  Update the connection string in the `web.config` file if necessary.

## 🔧 Getting Started

1.  Clone the repository: `git clone https://github.com/imperfectperson-max/ubuntu-wears.git`
2.  Open the `ub_frontend.sln` solution file in Visual Studio.
3.  Restore NuGet packages.
4.  Build the solution.
5.  Run the project (IIS Express).

## 👥 Academic Note

This project was developed as the final group project for the module **IFM2B10** in 2025.
