using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Data;

namespace Client.Converters
{
    public class BoolToClientStatusConverter : IValueConverter
    {
        private const string isConnected = "Server is connected";
        private const string isDisconnected = "Server is disconnected";

        public object Convert(object value, Type targetType, object parameter, CultureInfo culture)
        {
            if (value is bool)
            {
                if ((bool) value)
                {
                    return isConnected;
                }
            }

            return isDisconnected;
        }

        public object ConvertBack(object value, Type targetType, object parameter, CultureInfo culture)
        {
            return value?.Equals(isConnected);
        }
    }
}
