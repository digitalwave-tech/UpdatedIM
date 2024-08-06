using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.ComponentModel.DataAnnotations;
namespace InvoiceMgmt.Models
{
    public class Invoice
    {
        [Key]
        public int? InvoiceNo { get; set; }
        public Guid? CompanyId { get; set; }
        public int? CustomerId { get; set; }
        public DateTime InvoiceDate { get; set; } = DateTime.Now;
        public decimal? SubTotal { get; set; }
        public decimal? SgstRate { get; set; }
        public decimal? CgstRate { get; set; }

        public decimal? TotalAmt { get; set; }
        public virtual List<ItemDetails> Details { get; set; }
        public virtual Customer Customers { get; set; }
    }
}