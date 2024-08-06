using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Web;

namespace InvoiceMgmt.Models
{
    public class Customer
    {
        public Customer()
        {
            Invoices = new List<Invoice>();
        }
        [Key]
        public int? CustomerId { get; set; }
        [ForeignKey("Company")]
        public Guid? CompanyId { get; set; }
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public string AddressLine { get; set; }
        public string City { get; set; }
        public string States { get; set; }
        public string Pincode { get; set; }
        public string Phone { get; set; }
        public string EmailId { get; set; }
        public DateTime? CreatedOn { get; set; } = DateTime.Now;
        public virtual UserAccount Company { get; set; }
        public virtual List<Invoice> Invoices { get; set; }
    }
}