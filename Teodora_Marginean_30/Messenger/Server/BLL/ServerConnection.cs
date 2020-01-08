using System.Net;
using System.Net.Sockets;

namespace Server.BLL
{
    public class ServerConnection
    {
        private IPAddress IpAddr { get; set; }
        public string IpAddress { get; set; }
        public int Port { get; set; }
        private IPEndPoint IpEndPoint => new IPEndPoint(IpAddr, Port);
        public Socket Socket { get; private set; }
        public bool IsActive { get;  private set; }

        public ServerConnection()
        {
            IpAddress = "127.0.0.1";
            IpAddr = IPAddress.Parse(IpAddress);
            Port = 5960;

            IsActive = false;
        }

        public void Start()
        {
            if (IsActive)
                return;

            Socket = new Socket(AddressFamily.InterNetwork, SocketType.Stream, ProtocolType.Tcp);
            Socket.Bind(IpEndPoint);
            Socket.Listen(5);

            IsActive = true;
        }

        public void Stop()
        {
            if (!IsActive)
                return;

            Socket.Dispose();
            Socket = null;

            IsActive = false;
        }
    }
}
