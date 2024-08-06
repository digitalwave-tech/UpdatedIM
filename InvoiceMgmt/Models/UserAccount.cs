using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.ComponentModel.DataAnnotations;
namespace InvoiceMgmt.Models
{
    public class UserAccount
    {
        [Key]
        public Guid CompanyId { get; set; }
        public string CompanyName { get; set; }
        public string AddressLine { get; set; }
        public string City { get; set; } 
        public string States { get; set; }
        public string Pincode { get; set; }
        public string Phone { get; set; }
        public string EmailId { get; set; }
        public DateTime? CreatedOn { get; set; } = DateTime.Now;
        public string GstNo { get; set; }
        public string username { get; set; }
        public string password { get; set; }

    }
}