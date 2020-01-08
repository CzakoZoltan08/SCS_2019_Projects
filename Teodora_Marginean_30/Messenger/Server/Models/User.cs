using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Server.Models
{
    public class User
    {
        [Key, Required]
        [Index(IsUnique = true)]
        public string Username { get; set; }
        [Required]
        public string Password { get; set; }
        public string Nickname { get; set; }

        public User() { }

        public User(string username)
        {
            Username = username;
        }
    }
}
