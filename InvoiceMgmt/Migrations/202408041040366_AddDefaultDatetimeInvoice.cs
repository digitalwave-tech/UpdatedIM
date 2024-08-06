namespace InvoiceMgmt.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class AddDefaultDatetimeInvoice : DbMigration
    {
        public override void Up()
        {
            AlterColumn("dbo.Invoices", "InvoiceDate", c => c.DateTime(nullable: false, defaultValueSql: "GETDATE()"));
        }

        public override void Down()
        {
            AlterColumn("dbo.Invoices", "InvoiceDate", c => c.DateTime(nullable: false));

        }
    }
}
