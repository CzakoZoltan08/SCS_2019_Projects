using System;
using System.Globalization;
using System.Windows.Data;

namespace Server.Converters
{
    public class BoolToConnectionStatusConverter : IValueConverter
    {
        private const string connected = "Connect";
        private const string disconnected = "Disconnect";

        public object Convert(object value, Type targetType, object parameter, CultureInfo culture)
        {
            if (value is bool)
            {
                if ((bool) value)
                {
                    return connected;
                }
            }

            return disconnected;
        }

        public object ConvertBack(object value, Type targetType, object parameter, CultureInfo culture)
        {
            return value?.Equals(connected);
        }
    }
}