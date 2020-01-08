namespace Server.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class InitialMigration : DbMigration
    {
        public override void Up()
        {
            CreateTable(
                "dbo.Messages",
                c => new
                    {
                        SenderUsername = c.String(nullable: false, maxLength: 128),
                        MessageContent = c.String(maxLength: 2147483647),
                        ReceiverUsername = c.String(nullable: false, maxLength: 2147483647),
                        DateTimeSent = c.DateTime(nullable: false),
                    })
                .PrimaryKey(t => t.SenderUsername);
            
            CreateTable(
                "dbo.Users",
                c => new
                    {
                        Username = c.String(nullable: false, maxLength: 128),
                        Password = c.String(nullable: false, maxLength: 2147483647),
                        Nickname = c.String(maxLength: 2147483647),
                    })
                .PrimaryKey(t => t.Username)
                .Index(t => t.Username, unique: true);
            
        }
        
        public override void Down()
        {
            DropIndex("dbo.Users", new[] { "Username" });
            DropTable("dbo.Users");
            DropTable("dbo.Messages");
        }
    }
}
