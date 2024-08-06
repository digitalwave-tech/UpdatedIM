using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace InvoiceMgmt.Models
{
    public class ItemDetails
    {
        [Key]  
        public int? ItemID { get; set; }
        [ForeignKey("InvoiceNoNavigation")]
        public int? invoiceNo { get; set; }
        public string itemName { get; set; }
        public int? quantity { get; set; }
        public decimal? price { get; set; }
        public decimal? Amount { get; set; }
        [ForeignKey("invoiceNo")]
        
        public virtual Invoice InvoiceNoNavigation { get; set; }
    }
}