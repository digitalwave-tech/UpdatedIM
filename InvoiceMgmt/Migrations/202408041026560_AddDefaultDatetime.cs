namespace InvoiceMgmt.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class AddDefaultDatetime : DbMigration
    {
        public override void Up()
        {
            AlterColumn("dbo.UserAccounts", "CreatedOn", c => c.DateTime(nullable: false, defaultValueSql: "GETDATE()"));
            AlterColumn("dbo.Customers", "CreatedOn", c => c.DateTime(nullable: false, defaultValueSql: "GETDATE()"));
            AlterColumn("dbo.ErroLog", "loggedDate", c => c.DateTime(nullable: false, defaultValueSql: "GETDATE()"));

        }

        public override void Down()
        {
            AlterColumn("dbo.UserAccounts", "CreatedOn", c => c.DateTime(nullable: false));
            AlterColumn("dbo.Customers", "CreatedOn", c => c.DateTime(nullable: false));
            AlterColumn("dbo.ErroLog", "CreatedOn", c => c.DateTime(nullable: false));
        }
    }
}
