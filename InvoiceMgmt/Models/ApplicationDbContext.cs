using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data.Entity;

namespace InvoiceMgmt.Models
{
    public class ApplicationDbContext:DbContext
    {
        public  DbSet<UserAccount> UserAccount { get; set; }
        public  DbSet<ErrorLog> ErroLog { get; set; }

        public DbSet<Invoice> Invoice { get; set; }

        public DbSet<ItemDetails> ItemDetails { get; set; }
        public DbSet<Customer> Customers { get; set; }

        public ApplicationDbContext()
            : base("name=conn") // Ensure the connection string name matches
        {
        }
    }
}