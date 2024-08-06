namespace InvoiceMgmt.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class AddInoviceTable : DbMigration
    {
        public override void Up()
        {
            CreateTable(
                "dbo.Invoices",
                c => new
                    {
                        InvoiceNo = c.Int(nullable: false, identity: true),
                        CompanyId = c.Guid(),
                        CustomerId = c.Int(),
                        InvoiceDate = c.DateTime(nullable: false),
                        SubTotal = c.Decimal(precision: 18, scale: 2),
                        SgstRate = c.Decimal(precision: 18, scale: 2),
                        CgstRate = c.Decimal(precision: 18, scale: 2),
                        TotalAmt = c.Decimal(precision: 18, scale: 2),
                    })
                .PrimaryKey(t => t.InvoiceNo);
            
        }
        
        public override void Down()
        {
            DropTable("dbo.Invoices");
        }
    }
}
