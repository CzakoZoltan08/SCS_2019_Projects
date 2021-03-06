﻿using System;
using System.Globalization;
using System.Windows.Data;

namespace Server.Converters
{
    public class BoolToServerStatusConverter : IValueConverter
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
