namespace InvoiceMgmt.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class AddErrorLogTable : DbMigration
    {
        public override void Up()
        {
            CreateTable(
                "dbo.ErrorLogs",
                c => new
                    {
                        id = c.Int(nullable: false, identity: true),
                        methodName = c.String(),
                        errorMsg = c.String(),
                        loggedDate = c.DateTime(),
                    })
                .PrimaryKey(t => t.id);
            
        }
        
        public override void Down()
        {
            DropTable("dbo.ErrorLogs");
        }
    }
}
