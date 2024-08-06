namespace InvoiceMgmt.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class AddCustomerTable : DbMigration
    {
        public override void Up()
        {
            CreateTable(
                "dbo.Customers",
                c => new
                    {
                        CustomerId = c.Int(nullable: false, identity: true),
                        CompanyId = c.Guid(),
                        FirstName = c.String(),
                        LastName = c.String(),
                        AddressLine = c.String(),
                        City = c.String(),
                        States = c.String(),
                        Pincode = c.String(),
                        Phone = c.String(),
                        EmailId = c.String(),
                        CreatedOn = c.DateTime(),
                    })
                .PrimaryKey(t => t.CustomerId)
                .ForeignKey("dbo.UserAccounts", t => t.CompanyId)
                .Index(t => t.CompanyId);
            
            CreateIndex("dbo.Invoices", "CustomerId");
            AddForeignKey("dbo.Invoices", "CustomerId", "dbo.Customers", "CustomerId");
        }
        
        public override void Down()
        {
            DropForeignKey("dbo.Invoices", "CustomerId", "dbo.Customers");
            DropForeignKey("dbo.Customers", "CompanyId", "dbo.UserAccounts");
            DropIndex("dbo.Invoices", new[] { "CustomerId" });
            DropIndex("dbo.Customers", new[] { "CompanyId" });
            DropTable("dbo.Customers");
        }
    }
}
