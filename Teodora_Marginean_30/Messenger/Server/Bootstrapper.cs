using System.Windows;
using Caliburn.Micro;
using Server.ViewModels;

namespace Server
{
    public class Bootstrapper : BootstrapperBase
    {
        public Bootstrapper()
        {
            Initialize();
        }

        protected override void OnStartup(object sender, StartupEventArgs e)
        {
            DisplayRootViewFor<ServerViewModel>();
        }
    }
}
