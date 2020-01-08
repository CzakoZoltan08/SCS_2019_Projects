using System.Data.Entity;
using Server.Models;

namespace Server
{
    public class DataContext : DbContext
    {
        public virtual DbSet<User> Users { get; set; }
        public virtual DbSet<Message> Messages { get; set; }

        public DataContext() : base("DataContext")
        {
            Configuration.AutoDetectChangesEnabled = true;
        }
    }
}
