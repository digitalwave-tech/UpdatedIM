using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace InvoiceMgmt.Models
{
    public class CustomerInvoice
    {
        public int? InvoiceNo { get; set; }
        public string InvoiceDate { get; set; }
        public string CustomerName { get; set; }

        public decimal? TotalAmt { get; set; }
    }
}