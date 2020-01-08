using System;
using System.Windows;
using Client.BLL;

namespace Client
{
    /// <summary>
    /// Interaction logic for MainWindow.xaml
    /// </summary>
    public partial class MainWindow : Window
    {
        private ChatClient client;

        public MainWindow()
        {
            InitializeComponent();
            client = new ChatClient();
            DataContext = client;
        }

        private void ConnectButton_OnClick(object sender, RoutedEventArgs e)
        {
            try
            {
                client.SwitchState();
                if (client.IsActive)
                {
                    client.SetUsername(Username.Text);
                }
            }
            catch (Exception exception)
            {
                MessageBox.Show(exception.Message, "ERROR", MessageBoxButton.OK, MessageBoxImage.Error);
            }
}

        private void SendMessageButton_OnClick(object sender, RoutedEventArgs e)
        {
            client.SendMessage(TargetUsername.Text, MessageToSend.Text);
        }
    }
}
