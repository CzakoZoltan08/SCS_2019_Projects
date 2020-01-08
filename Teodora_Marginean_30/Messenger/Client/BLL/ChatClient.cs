using System;
using System.ComponentModel;
using System.Net;
using System.Net.Sockets;
using System.Runtime.CompilerServices;
using System.Text;
using System.Threading;
using System.Windows.Threading;
using Client.Annotations;
using Server.Models;

namespace Client.BLL
{
    public sealed class ChatClient : INotifyPropertyChanged
    {
        public Dispatcher Dispatcher { get; set; }
        public Thread Thread { get; set; }
        public Socket Socket { get; set; }
        private IPAddress IpAddr { get; set; }
        public string IpAddress { get; set; }
        private IPEndPoint IpEndPoint { get; set; }
        public int Port { get; set; }
        public User User { get; set; }
        public BindingList<string> Messages { get; set; }
        public bool IsActive { get; set; } = false;
        public bool IsNotActive => !IsActive;

        public ChatClient()
        {
            Dispatcher = Dispatcher.CurrentDispatcher;
            Messages = new BindingList<string>();

            IpAddress = "127.0.0.1";
            IpAddr = IPAddress.Parse(IpAddress);
            Port = 5960;
            IpEndPoint = new IPEndPoint(IpAddr, Port);
            User = new User("");
        }

        public void SwitchState()
        {
            if (!IsActive)
            {
                Connect();
            }
            else
            {
                Disconnect();
            }
        }

        private void Connect()
        {
            if (IsActive)
            {
                return;
            }

            Socket = new Socket(AddressFamily.InterNetwork, SocketType.Stream, ProtocolType.Tcp);
            Socket.Connect(IpEndPoint);

            SetUsername(User.Username);

            Thread = new Thread(ReceiveMessages);
            Thread.Start();

            IsActive = true;
            OnPropertyChanged(nameof(IsActive));
            OnPropertyChanged(nameof(IsNotActive));
        }

        private void Disconnect()
        {
            if (!IsActive)
            {
                return;
            }

            Socket?.Shutdown(SocketShutdown.Both);
            Socket?.Dispose();
            Socket = null;
            Thread = null;

            Messages?.Clear();

            IsActive = false;
            OnPropertyChanged(nameof(IsActive));
            OnPropertyChanged(nameof(IsNotActive));
        }

        private void ReceiveMessages()
        {
            while (true)
            {
                byte[] informationBytes = new byte[1024];

                try
                {
                    if (!IsActive)
                    {
                        Dispatcher.Invoke(Disconnect);
                        return;
                    }

                    int receivedBytes = Socket.Receive(informationBytes);

                    if (receivedBytes > 0)
                    {
                        string message = Encoding.Unicode.GetString(informationBytes).Trim('\0');
                        Dispatcher.Invoke(() => Messages.Add(message));
                    }

                }
                catch (Exception)
                {
                    Dispatcher.Invoke(Disconnect);
                    return;
                }
            }
        }

        public void SetUsername(string username)
        {
            string command = $"/setname {username}";

           SendCommand(command);
        }

        public void SendMessage(string targetUsername, string message)
        {
            string command = $"/msgto {targetUsername}:{message}";
            
            SendCommand(command);
        }

        public void Register(string username, string password, string nickname)
        {
            string command = $"/register {username} {password} {nickname}";

            SendCommand(command);
        }

        public void Login(string username, string password)
        {
            string command = $"/login {username} {password}";

            SendCommand(command);
        }

        private void SendCommand(string command)
        {
            Socket.Send(Encoding.Unicode.GetBytes(command));
        }

        public event PropertyChangedEventHandler PropertyChanged;

        [NotifyPropertyChangedInvocator]
        private void OnPropertyChanged([CallerMemberName] string propertyName = null)
        {
            PropertyChanged?.Invoke(this, new PropertyChangedEventArgs(propertyName));
        }
    }
}
