namespace InvoiceMgmt.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class InitialCreate : DbMigration
    {
        public override void Up()
        {
            CreateTable(
                "dbo.CustomerAccounts",
                c => new
                    {
                        CompanyId = c.Guid(nullable: false),
                        CompanyName = c.String(),
                        AddressLine = c.String(),
                        City = c.String(),
                        States = c.String(),
                        Pincode = c.String(),
                        Phone = c.String(),
                        EmailId = c.String(),
                        CreatedOn = c.DateTime(),
                        GstNo = c.String(),
                        username = c.String(),
                        password = c.String(),
                    })
                .PrimaryKey(t => t.CompanyId);
            
        }
        
        public override void Down()
        {
            DropTable("dbo.CustomerAccounts");
        }
    }
}
