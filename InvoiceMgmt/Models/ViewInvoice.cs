using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace InvoiceMgmt.Models
{
    public class ViewInvoice
    {
        public string InvoiceDate { get; set; }
        public string CustomerName { get; set; }
        public int? InvoiceNo { get; set; }
        public decimal? NetAmt { get; set; }
    }
    public class ViewInvoiceList
    {
        public List<ViewInvoice> viewInvoices { get; set; }

    }
}