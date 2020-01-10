using System.Data.SQLite.EF6.Migrations;
using Server.Models;

namespace Server.Migrations
{
    using System.Data.Entity.Migrations;

    internal sealed class Configuration : DbMigrationsConfiguration<Server.DataContext>
    {
        public Configuration()
        {
            AutomaticMigrationsEnabled = false;
            SetSqlGenerator("System.Data.SQLite", new SQLiteMigrationSqlGenerator());
        }

        protected override void Seed(DataContext context)
        {
            context.Users.AddOrUpdate(
                new User
                {
                    Username = "admin",
                    Password = "admin",
                    Nickname = "Admin"
                });

            context.SaveChanges();
        }
    }
}
