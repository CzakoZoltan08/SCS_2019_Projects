using System;
using System.Globalization;
using System.Windows.Data;
using System.Windows.Media;

namespace Client.Converters
{
    public class StatusToColorConverter : IValueConverter
    {
        private readonly Brush connectedColorBrush = new SolidColorBrush(Color.FromRgb(0, 255, 0));
        private readonly Brush disconnectedColorBrush = new SolidColorBrush(Color.FromRgb(255, 0, 0));

        public object Convert(object value, Type targetType, object parameter, CultureInfo culture)
        {
            if (value is bool)
            {
                if ((bool) value)
                {
                    return connectedColorBrush;
                }
            }

            return disconnectedColorBrush;
        }

        public object ConvertBack(object value, Type targetType, object parameter, CultureInfo culture)
        {
            return (Brush) value == connectedColorBrush;
        }
    }
}
