using InvoiceMgmt.Models;
using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Linq;
using System.Net;
using System.Runtime.InteropServices;
using System.Threading.Tasks;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.Script.Services;
using System.Web.Services;

namespace InvoiceMgmt
{
    /// <summary>
    /// Summary description for WebService
    /// </summary>
    [WebService(Namespace = "http://tempuri.org/")]
    [WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
    [System.ComponentModel.ToolboxItem(false)]
    [ScriptService]
    // To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
    // [System.Web.Script.Services.ScriptService]
    public class WebService : System.Web.Services.WebService
    {
        private readonly ApplicationDbContext dbContext;
        ErrorLog errorLog = new ErrorLog();
        public WebService()
        {
            dbContext = new ApplicationDbContext();
        }
        [WebMethod]
        public string CreateAccount(UserAccount customer)
        {
            try
            {
                //var user = dbContext.UserAccount.Select(x => x.GstNo).Where(customer.GstNo== x);
                var user = dbContext.UserAccount
                            .FirstOrDefault(x => x.GstNo == customer.GstNo);
                if (user == null)
                {
                    customer.CompanyId = Guid.NewGuid();
                    var response = dbContext.UserAccount.Add(customer);
                    var re = dbContext.SaveChanges();
                    return "Created";
                }
                else
                    return "Company Name already registered";



            }
            catch (Exception ex)
            {
                var exc = new ErrorLog
                {
                    errorMsg = "ErrorMsg : " + ex.InnerException + "\r\n" + ex.StackTrace,
                    methodName = nameof(CreateAccount),
                };
                WriteErrorLog(exc);
                int da = (int)HttpStatusCode.InternalServerError;
                return da.ToString();
            }

        }
        
        [WebMethod(EnableSession = true)]
        public bool Login(string username, string password)
        {
            try
            {
                //var user = dbContext.UserAccount.Select(x => x.username == username && x.password==password);
                var user = dbContext.UserAccount
                            .Where(x => x.username == username && x.password == password)
                            .FirstOrDefault();

                if (user != null)
                {
                    Session["gstNo"] = user.GstNo.ToString();
                    Session["companyID"] = (Guid)user.CompanyId;
                    return true;
                }
                else
                {

                    return false;
                }
            }
            catch (Exception ex)
            {
                var exc = new ErrorLog
                {
                    errorMsg = "ErrorMsg : " + ex.InnerException + "\r\n" + ex.StackTrace,
                    methodName = nameof(Login),
                };
                WriteErrorLog(exc);
                return false;
            }

        }

        [WebMethod(EnableSession = true)]
        public string GetInvoices()
        {
            try
            {
                var gstNo = Session["gstNo"].ToString();
                var companyAcct = dbContext.UserAccount.Where(u => u.GstNo == gstNo).FirstOrDefault();

                var invoicelist = dbContext.Invoice.Where(u => u.CompanyId == companyAcct.CompanyId).ToList();
                if (invoicelist.Count() > 0)
                {
                    var invoiceNumbers = invoicelist.Select(x => x.InvoiceNo).ToList();
                    var itemDetails = dbContext.ItemDetails.Where(u => invoiceNumbers.Contains(u.invoiceNo)).ToList();

                    var customerIds = invoicelist.Select(x => x.CustomerId).Distinct().ToList();
                    var customers = dbContext.Customers
                        .Where(c => customerIds.Contains(c.CustomerId))
                        .ToList();

                    // Creating the list of ViewInvoice
                    var viewInvoices = invoicelist.Select(invoice => new ViewInvoice
                    {
                        InvoiceDate = invoice.InvoiceDate.ToString("dd-MMM-yyyy"),
                        CustomerName = customers
                                .Where(c => c.CustomerId == invoice.CustomerId)
                                .Select(c => c.FirstName + " " + c.LastName)
                                .FirstOrDefault() ?? "Unknown",
                        InvoiceNo = invoice.InvoiceNo,
                        NetAmt = invoice.TotalAmt
                    }).ToList();

                    // Serialize the viewInvoices list to JSON
                    JavaScriptSerializer js = new JavaScriptSerializer();
                    return js.Serialize(viewInvoices);

                }
            }
            catch (Exception ex)
            {
                var exc = new ErrorLog
                {
                    errorMsg = "ErrorMsg : " + ex.Message + "\r\n" + ex.StackTrace,
                    methodName = nameof(GetInvoices),
                };
                WriteErrorLog(exc);

            }
            return null;
        }

        [WebMethod(EnableSession = true)]
        public string CreateCustomer(Customer customers)
        {
            try
            {
                customers.CompanyId = (Guid)Session["companyID"];
                var response = dbContext.Customers.Add(customers);
                var result = dbContext.SaveChangesAsync();
                return "Created";
            }
            catch (Exception ex)
            {
                var exc = new ErrorLog
                {
                    errorMsg = "ErrorMsg : " + ex.InnerException + "\r\n" + ex.StackTrace,
                    methodName = nameof(CreateCustomer),
                };
                WriteErrorLog(exc);
                int da = (int)HttpStatusCode.InternalServerError;
                return da.ToString();
            }
        }
        [WebMethod(EnableSession = true)]
        public List<string> GetCustomeNameByGstNo()
        {
            try
            {
                var gstNo = Session["gstNo"].ToString();
                var companyId = dbContext.UserAccount.Where(u => u.GstNo == gstNo).Select(z => z.CompanyId).FirstOrDefault();

                var customers = dbContext.Customers
                                .Where(u => u.CompanyId == companyId)
                                .ToList(); 

                var result = customers.Select(y => $"{y.FirstName} {y.LastName}").ToList();

                if (result.Count() > 0)
                {
                    return result;

                }
            }
            catch (Exception ex)
            {
                var exc = new ErrorLog
                {
                    errorMsg = "ErrorMsg : " + ex.InnerException + "\r\n" + ex.StackTrace,
                    methodName = nameof(GetCustomeNameByGstNo),
                };
                WriteErrorLog(exc);
            }
            return null;
        }

        
        public string CreateInvoice(Invoice invoices)
        {
            try
            {

                dbContext.Invoice.Add(invoices);
                var result =  dbContext.SaveChangesAsync();

                return HttpStatusCode.Created.ToString();

            }
            catch (Exception ex)
            {
                var exc = new ErrorLog
                {
                    errorMsg = "ErrorMsg : " + ex.InnerException + "\r\n" + ex.StackTrace,
                    methodName = nameof(CreateInvoice)
                };

                WriteErrorLog(exc);
                int da = (int)HttpStatusCode.InternalServerError;
                return da.ToString();

            }
        }
        [WebMethod(EnableSession = true)]
        public string BindInvoice(InvoiceRequest invoiceRequest)
        {
            var customer_Id = dbContext.Customers
                   .Where(y => (y.FirstName + " " + y.LastName) == invoiceRequest.customerName)
                   .Select(x => x.CustomerId).FirstOrDefault();

            Invoice invoices = new Invoice()
            {
                CompanyId = (Guid)Session["companyID"],
                CustomerId = customer_Id,
                SubTotal = invoiceRequest.subtotal,
                SgstRate = invoiceRequest.SgstRate,
                CgstRate = invoiceRequest.CgstRate,
                TotalAmt = invoiceRequest.totalAmt,
                //Details = invoiceRequest.Details
                Details = invoiceRequest.Details.Select(d => new ItemDetails
                {
                    itemName = d.itemName,
                    quantity = d.quantity,
                    price = d.price,
                    Amount = d.Amount
                }).ToList()
            };
            var result = CreateInvoice(invoices);
            return  result;
        }

        [WebMethod(EnableSession = true)]
        public List<PDFTemplate> GetInvoiceItemDetails(List<int?> invoicenos)
        {
            try
            {



                var query = (from id in dbContext.ItemDetails
                             where invoicenos.Contains(id.invoiceNo)
                             join i in dbContext.Invoice on id.invoiceNo equals i.InvoiceNo
                             join c in dbContext.Customers on i.CustomerId equals c.CustomerId
                             join ua in dbContext.UserAccount on c.CompanyId equals ua.CompanyId
                             group new { id, i, c, ua } by new { ua.CompanyId, ua.CompanyName, ua.AddressLine, ua.Phone, ua.City, ua.States, ua.Pincode, ua.EmailId } into companyGroup
                             select new
                             {
                                 companyDetails = new
                                 {
                                     companyGroup.Key.CompanyId,
                                     companyGroup.Key.CompanyName,
                                     companyGroup.Key.AddressLine,
                                     companyGroup.Key.Phone,
                                     companyGroup.Key.City,
                                     companyGroup.Key.States,
                                     companyGroup.Key.Pincode,
                                     companyGroup.Key.EmailId,
                                     customerdetails = companyGroup
                                         .GroupBy(g => new { g.c.CustomerId, g.c.FirstName, g.c.LastName, g.c.AddressLine, g.c.Phone, g.c.City, g.c.States, g.c.Pincode, g.c.EmailId })
                                         .Select(customerGroup => new
                                         {
                                             customername = customerGroup.Key.FirstName + " " + customerGroup.Key.LastName,
                                             custoomeraddress = customerGroup.Key.AddressLine,
                                             customerphoneNo = customerGroup.Key.Phone,
                                             customercity = customerGroup.Key.City,
                                             customerstate = customerGroup.Key.States,
                                             customerpincode = customerGroup.Key.Pincode,
                                             customeremail = customerGroup.Key.EmailId,
                                             itemDetails = customerGroup.Select(item => new
                                             {
                                                 invoiceNo = item.id.invoiceNo,
                                                 invoiceDate = item.i.InvoiceDate,
                                                 itemName = item.id.itemName,
                                                 quantity = item.id.quantity,
                                                 price = item.id.price,
                                                 Amount = item.id.Amount,
                                                 SgstRate = item.i.SgstRate,
                                                 CgstRate = item.i.CgstRate,
                                                 subtotalAmt = item.i.SubTotal,
                                                 netAmount = item.i.TotalAmt,
                                             }).ToList()
                                         }).ToList()
                                 }
                             }).ToList(); // Materialize the data here

                // Perform the necessary formatting in memory
                var result = query.Select(q => new PDFTemplate
                {
                    companyDetails = new Companydetails
                    {
                        companyid = q.companyDetails.CompanyId,
                        companyName = q.companyDetails.CompanyName,
                        companyaddress = q.companyDetails.AddressLine,
                        companyphoneNo = q.companyDetails.Phone,
                        companycity = q.companyDetails.City,
                        companystate = q.companyDetails.States,
                        companypincode = q.companyDetails.Pincode,
                        companyemail = q.companyDetails.EmailId,
                        customerdetails = q.companyDetails.customerdetails.Select(cd => new Customerdetail
                        {
                            customername = cd.customername,
                            custoomeraddress = cd.custoomeraddress,
                            customerphoneNo = cd.customerphoneNo,
                            customercity = cd.customercity,
                            customerstate = cd.customerstate,
                            customerpincode = cd.customerpincode,
                            customeremail = cd.customeremail,
                            itemDetails = cd.itemDetails.Select(id => new Itemdetail
                            {
                                invoiceNo = id.invoiceNo,
                                invocieDate = id.invoiceDate.ToString("dd/MM/yyyy"), // Formatting done in memory
                                itemName = id.itemName,
                                quantity = id.quantity,
                                price = id.price,
                                Amount = id.Amount,
                                SgstRate = id.SgstRate,
                                CgstRate = id.CgstRate,
                                subtotalAmt = id.subtotalAmt,
                                netAmount = id.netAmount,
                            }).ToArray() // Convert to array here
                        }).ToArray() // Convert to array here
                    }
                }).ToList();


                return result;
            }
            catch (Exception ex)
            {
                var exc = new ErrorLog
                {
                    errorMsg = "ErrorMsg : " + ex.Message + "\r\n" + ex.StackTrace,
                    methodName = nameof(GetInvoiceItemDetails),
                };
                WriteErrorLog(exc);
            }
            return null;
        }
        [WebMethod(EnableSession = true)]
        public List<CustomerInvoice> GetInvoicesByCustomer(string customerName)
        {
            try
            {
                var gstNo = HttpContext.Current.Session["gstNo"]?.ToString();
                if (string.IsNullOrEmpty(gstNo))
                {
                    throw new Exception("Session does not contain GST number.");
                }

                var companyId = dbContext.UserAccount
                                          .Where(u => u.GstNo == gstNo)
                                          .Select(z => z.CompanyId)
                                          .FirstOrDefault();

                var names = customerName.Split(' ');
                var firstName = names[0];
                var lastName = names.Length > 1 ? names[1] : "";

                var invoices = dbContext.Invoice
                           .Where(i => i.Customers.FirstName == firstName &&
                                       i.Customers.LastName == lastName &&
                                       i.Customers.CompanyId == companyId)
                           .Select(i => new
                           {
                               i.InvoiceNo,
                               i.InvoiceDate,
                               CustomerName = i.Customers.FirstName + " " + i.Customers.LastName,
                               i.TotalAmt
                           })
                           .ToList()
                           .Select(i => new CustomerInvoice
                           {
                               InvoiceNo = i.InvoiceNo,
                               InvoiceDate = i.InvoiceDate.ToString("dd/MM/yyyy"),
                               CustomerName = i.CustomerName,
                               TotalAmt = i.TotalAmt
                           })
                           .ToList();

                return invoices.ToList();
            }
            catch (Exception ex)
            {
                // Handle exception
                throw new Exception("Internal server error");
            }
        }

        public void WriteErrorLog(ErrorLog errorLog)
        {
            var response = dbContext.ErroLog.Add(errorLog);
            dbContext.SaveChangesAsync();

        }
    }
}
