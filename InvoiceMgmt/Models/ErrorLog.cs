using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.ComponentModel.DataAnnotations;
namespace InvoiceMgmt.Models
{
    public class ErrorLog
    {
        public int id { get; set; }
        public string methodName { get; set; }
        public string errorMsg { get; set; }
        public DateTime? loggedDate { get; set; } = DateTime.Now;

    }
}