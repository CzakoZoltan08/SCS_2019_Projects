using System;
using System.ComponentModel.DataAnnotations;

namespace Server.Models
{
    public class Message
    {
        public string MessageContent { get; set; }
        [Key, Required]
        public string SenderUsername { get; set; }
        [Required]
        public string ReceiverUsername { get; set; }
        public DateTime DateTimeSent { get; set; }

        public Message() { }

        public Message(string messageContent)
        {
            MessageContent = messageContent;
            DateTimeSent = DateTime.Now;
        }
    }
}
