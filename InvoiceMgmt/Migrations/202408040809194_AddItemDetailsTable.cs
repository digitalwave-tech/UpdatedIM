namespace InvoiceMgmt.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class AddItemDetailsTable : DbMigration
    {
        public override void Up()
        {
            CreateTable(
                "dbo.ItemDetails",
                c => new
                    {
                        ItemID = c.Int(nullable: false, identity: true),
                        invoiceNo = c.Int(),
                        itemName = c.String(),
                        quantity = c.Int(),
                        price = c.Decimal(precision: 18, scale: 2),
                        Amount = c.Decimal(precision: 18, scale: 2),
                    })
                .PrimaryKey(t => t.ItemID)
                .ForeignKey("dbo.Invoices", t => t.invoiceNo)
                .Index(t => t.invoiceNo);
            
        }
        
        public override void Down()
        {
            DropForeignKey("dbo.ItemDetails", "invoiceNo", "dbo.Invoices");
            DropIndex("dbo.ItemDetails", new[] { "invoiceNo" });
            DropTable("dbo.ItemDetails");
        }
    }
}
