using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace InvoiceMgmt.Models
{
    public class InvoiceRequest
    {
        public Guid? companyId { get; set; }

        public string customerName { get; set; }
        public decimal? subtotal { get; set; }
        public decimal? SgstRate { get; set; }
        public decimal? CgstRate { get; set; }

        public decimal? totalAmt { get; set; }

        public virtual List<ItemDetails> Details { get; set; }
    }
}