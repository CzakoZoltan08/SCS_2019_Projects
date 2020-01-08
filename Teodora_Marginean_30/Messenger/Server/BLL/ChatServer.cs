using System;
using System.Collections.ObjectModel;
using System.Text;
using System.Threading;
using System.Windows.Threading;
using Server.Models;

namespace Server.BLL
{
    public sealed class ChatServer
    {
        public ServerConnection ServerConnection { get; }
        private Dispatcher Dispatcher { get; }
        private Thread Thread { get; set; }
        public ObservableCollection<Client> Clients { get; private set; }
        public ObservableCollection<string> MessageLogs { get; private set; }
        private int ClientIdCounter { get; set; }
        public bool IsActive => ServerConnection.IsActive;

        public ChatServer()
        {
            ServerConnection = new ServerConnection();

            Dispatcher = Dispatcher.CurrentDispatcher;

            Clients = new ObservableCollection<Client>();
            MessageLogs = new ObservableCollection<string>();

            ClientIdCounter = 0;
        }

        public void SwitchState()
        {
            if (!IsActive)
            {
                Thread = new Thread(WaitForConnections);
                Thread.Start();
                ServerConnection.Start();
            }

            else
            {
                ServerConnection.Stop();
                while (Clients.Count != 0)
                {
                    Client client = Clients[0];
                    Clients.Remove(client);
                }
            }
        }

        private void WaitForConnections()
        {
            while (true)
            {
                if (ServerConnection.Socket == null)
                {
                    return;
                }

                try
                {
                    Client client = new Client
                    {
                        User = new User(""),
                        Socket = ServerConnection.Socket.Accept()
                    };

                    client.Thread = new Thread(() => ProcessMessages(client));
                    client.Thread.Start();

                    Dispatcher.Invoke(new Action(() =>
                        Clients.Add(client)), null);

                    ClientIdCounter++;
                }
                catch (Exception e)
                {
                    Console.WriteLine(@"Connection terminated!");
                }
            }
        }

        private void ProcessMessages(Client client)
        {
            while (true)
            {
                if (client.IsConnected() == false)
                {
                    Dispatcher.Invoke(() =>
                    {
                        Clients.Remove(client);
                        client.Dispose();

                    });
                    return;
                }

                var messageBytes = new byte[1024];
                var receivedBytes = client.Socket.Receive(messageBytes);

                var messageReceived = Encoding.Unicode.GetString(messageBytes);

                if (receivedBytes <= 0) continue;

                if (messageReceived.Substring(0, 8) == "/setname")
                {
                    SetName(client, messageReceived);
                }
                else if (messageReceived.Substring(0, 6) == "/msgto")
                {
                    MessageClient(client, messageReceived);
                }
                else if ((messageReceived.Substring(0, 6) == "/login"))
                {
                    Login(messageReceived);
                }
                else if ((messageReceived.Substring(0, 9) == "/register"))
                {
                    Register(messageReceived);
                }   
            }
        }

        private static void Register(string messageReceived)
        {
            //TODO
            string command = messageReceived.Replace("/register ", "").Trim('\0');
            string[] data = command.Split(' ');

            string username = data[0];
            string password = data[1];
            string nickname = data[2];

            User newUser = new User
            {
                Username = username,
                Password = password,
                Nickname = nickname
            };
        }

        private static void Login(string messageReceived)
        {
            //TODO
            string command = messageReceived.Replace("/login ", "").Trim('\0');
            string[] data = command.Split(' ');

            string username = data[0];
            string password = data[1];
        }

        private void MessageClient(Client client, string messageReceived)
        {
            var data = messageReceived.Replace("/msgto ", "").Trim('\0');
            var targetUsername = data.Substring(0, data.IndexOf(':'));
            var messageToSend = data.Substring(data.IndexOf(':') + 1);

            Message sentMessage = new Message
            {
                MessageContent = messageToSend,
                SenderUsername = client.User.Username,
                ReceiverUsername = targetUsername,
                DateTimeSent = DateTime.Now
            };

            Dispatcher.Invoke(new Action(() =>
                SendMessage(client, targetUsername, sentMessage)
            ), null);

            Dispatcher.Invoke(new Action(() =>
                SendMessage(client, client.User.Username, sentMessage)
            ), null);
        }

        private static void SetName(Client client, string receivedCommand)
        {
            string newUsername = receivedCommand.Replace("/setname ", "").Trim('\0');
            client.User.Username = newUsername;
        }

        private void SendMessage(Client senderClient, string receiverUsername, Message messageContent)
        {
            string message = GenerateMessageLog(senderClient, receiverUsername, messageContent);

            bool isSent = false;

            foreach (var client in Clients)
            {
                if (!client.User.Username.Equals(receiverUsername)) continue;

                client.SendMessage(new Message(message));
                isSent = true;
            }

            if (!isSent)
            {
                senderClient.SendMessage(
                    new Message("**SERVER*** ERROR! Username not found! Your message was not sent!"));
            }
        }

        private string GenerateMessageLog(Client senderClient, string receiverUsername, Message messageContent)
        {
            string message = $"You:{messageContent.MessageContent}";
            
            if (!senderClient.User.Username.Equals(receiverUsername))
            {
                message = $"{senderClient.User.Username}:{messageContent.MessageContent}";
                var messageLog = $"**LOG** From: {senderClient.User.Username} | To: {receiverUsername} | Message: {messageContent.MessageContent}";
                MessageLogs.Add(messageLog);
            }

            return message;
        }
    }
}
