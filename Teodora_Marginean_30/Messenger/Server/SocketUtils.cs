using System.Net.Sockets;

namespace Server
{
    public static class SocketUtils
    {
        public static bool IsConnected(Socket socket)
        {
            if (socket == null)
            {
                return false;
            }

            if (!socket.Connected)
            {
                return false;
            }

            if (socket.Available == 0)
            {
                if (socket.Poll(1000, SelectMode.SelectRead))
                {
                    return false;
                }
            }

            return true;
        }
    }
}
