using System.Collections.ObjectModel;
using System.ComponentModel;
using System.Runtime.CompilerServices;
using Caliburn.Micro;
using Server.BLL;
using Server.Properties;

namespace Server.ViewModels
{
    public class ServerViewModel : Screen
    {
        private readonly ChatServer chatServer;

        public bool IsServerActive {
            get => chatServer.IsActive;
        }
        public bool IsNotActive => !IsServerActive;

        public int ClientCount
        {
            get => chatServer.Clients.Count;
            private set
            {
                value = chatServer.Clients.Count;
                OnPropertyChanged(nameof(ActiveClients));
            }
        }

        public string IpAddress
        {
            get => chatServer.ServerConnection.IpAddress;
            set => chatServer.ServerConnection.IpAddress = value;
        }

        public int Port
        {
            get => chatServer.ServerConnection.Port;
            set => chatServer.ServerConnection.Port = value;
        }

        public ObservableCollection<Client> ActiveClients { get; set; }
        public ObservableCollection<string> MessageLogs { get; set; }

        public ServerViewModel()
        {
            chatServer = new ChatServer();

            ActiveClients = chatServer.Clients;
            MessageLogs = chatServer.MessageLogs;

            ActiveClients.CollectionChanged += (sender, args) => OnPropertyChanged(nameof(ClientCount));
        }

        public void ConnectDisconnect()
        {
            chatServer.SwitchState();

            OnPropertyChanged(nameof(IsServerActive));
            OnPropertyChanged(nameof(IsNotActive));
        }

        public override event PropertyChangedEventHandler PropertyChanged;

        [NotifyPropertyChangedInvocator]
        protected virtual void OnPropertyChanged([CallerMemberName] string propertyName = null)
        {
            PropertyChanged?.Invoke(this, new PropertyChangedEventArgs(propertyName));
        }
    }
}
