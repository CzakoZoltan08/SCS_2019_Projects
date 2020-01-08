using System;
using System.Net.Sockets;
using System.Text;
using System.Threading;
using Server.Models;

namespace Server.BLL
{
    public class Client : IDisposable
    {
        public User User { get; set; }
        public Socket Socket { get; set; }
        public Thread Thread { get; set; }

        public void SendMessage(Message message)
        {
            if (IsConnected())
            {
                string messageContent = message.MessageContent;

                Socket.Send(Encoding.Unicode.GetBytes(messageContent));
            }
        }

        internal bool IsConnected()
        {
            return SocketUtils.IsConnected(Socket);
        }

        public void Dispose()
        {
            Socket?.Shutdown(SocketShutdown.Both);
            Socket?.Dispose();
            Thread = null;
        }
    }
}
