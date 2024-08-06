namespace InvoiceMgmt.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class MigrationName : DbMigration
    {
        public override void Up()
        {
            RenameTable(name: "dbo.CustomerAccounts", newName: "UserAccounts");
        }
        
        public override void Down()
        {
            RenameTable(name: "dbo.UserAccounts", newName: "CustomerAccounts");
        }
    }
}
