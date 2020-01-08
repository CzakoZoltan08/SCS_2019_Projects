using Server.Models;

namespace Server.DAL
{

    public static class RepositoryLocator
    {
        private static readonly DataContext Context = new DataContext(); 
        private static IRepository<User> users;
        private static IRepository<Message> messages;

        public static IRepository<User> UserRepository =>
            users ??
            (users = new BaseRepository<User>(Context));

        public static IRepository<Message> MessageRepository =>
            messages ??
            (messages = new BaseRepository<Message>(Context));
    }
}
