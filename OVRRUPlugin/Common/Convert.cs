using System;
using System.Windows;
using System.Windows.Data;
using System.Globalization;
using System.Windows.Controls;
using System.Windows.Media.Imaging;
using System.Windows.Media;


namespace OVRRUPlugin.Common
{
    public class NOCImageSourceConnvert : IValueConverter
    {
        public object Convert(object value, Type targetType, object parameter, CultureInfo culture)
        {
            if (value == null)
            {
                return null;
            }
            string strNOC = (string)value;
            if (strNOC == "")
            {
                return null;
            }
            string flagPath = System.IO.Path.Combine(GVAR.GetAppRootDir(), string.Format("Flag\\{0}.png", strNOC));
            //string flagPath = System.IO.Path.Combine(GVAR.GetAppRootDir(), string.Format("Flag\\CHN.png"));
            if (!System.IO.File.Exists(flagPath))
            {
                flagPath = System.IO.Path.Combine(GVAR.GetAppRootDir(), string.Format("Flag\\{0}.jpg", strNOC));
                if (!System.IO.File.Exists(flagPath))
                {
                    return null;
                }
            }
            BitmapImage bi3 = null;
            try
            {
                bi3 = new BitmapImage();
                bi3.BeginInit();
                bi3.UriSource = new Uri(flagPath, UriKind.Absolute);
                bi3.EndInit();
            }
            catch
            {
                return null;
            }

            return bi3;

        }
        public object ConvertBack(object value, Type targetType, object parameter, CultureInfo culture)
        {
            return null;
        }
    }

    public class EraseButtonConvert : IValueConverter
    {
        public object Convert(object value, Type targetType, object parameter, CultureInfo culture)
        {
            if (value == null)
            {
                return false;
            }
            ComboBoxItem item = value as ComboBoxItem;
            int matchStatus = System.Convert.ToInt32(item.Tag);
            if (matchStatus == 50 || matchStatus == 120)
            {
                return true;
            }
            else
            {
                return false;
            }
        }
        public object ConvertBack(object value, Type targetType, object parameter, CultureInfo culture)
        {
            return null;
        }
    }

    public class PageButtonConvert : IValueConverter
    {
        public object Convert(object value, Type targetType, object parameter, CultureInfo culture)
        {
            if (value == null)
            {
                return false;
            }
            if ((int)value == -1)
            {
                return false;
            }
            return true;
        }
        public object ConvertBack(object value, Type targetType, object parameter, CultureInfo culture)
        {
            return null;
        }
    }
    public class HalfConvert : IValueConverter
    {
        public object Convert(object value, Type targetType, object parameter, CultureInfo culture)
        {
            double len = (double)value;
            return len / 2;
        }
        public object ConvertBack(object value, Type targetType, object parameter, CultureInfo culture)
        {
            return null;
        }
    }

    public class StatusBtnContentConvert : IValueConverter
    {
        public object Convert(object value, Type targetType, object parameter, CultureInfo culture)
        {
            int matchStaus = (int)value;
            string res = "";
            switch (matchStaus)
            {
                case 10:
                    res = "AVAILABLE";
                    break;
                case 20:
                    res = "CONFIGURED";
                    break;
                case 30:
                    res = "SCHEDULE";
                    break;
                case 40:
                    res = "STARTLIST";
                    break;
                case 50:
                    res = "RUNNING";
                    break;
                case 60:
                    res = "SUSPEND";
                    break;
                case 100:
                    res = "UNOFFICIAL";
                    break;
                case 110:
                    res = "OFFICIAL";
                    break;
                case 120:
                    res = "REVISION";
                    break;
                case 130:
                    res = "CANCELED";
                    break;
            }
            return res;

        }
        public object ConvertBack(object value, Type targetType, object parameter, CultureInfo culture)
        {
            return null;
        }
    }


    public class StatusBtnColorConvert : IValueConverter
    {
        public object Convert(object value, Type targetType, object parameter, CultureInfo culture)
        {
            int matchStaus = (int)value;
            Brush brush = Brushes.White;
            switch (matchStaus)
            {
                case 10:
                case 20:
                    break;
                case 30:
                case 40:
                    brush = new SolidColorBrush(Color.FromRgb(218, 136, 22));
                    break;
                case 50:
                    brush = new SolidColorBrush(Color.FromRgb(70, 182, 8));
                    break;
                case 60:
                    break;
                case 100:
                    brush = new SolidColorBrush(Color.FromRgb(55, 67, 178));
                    break;
                case 110:
                    brush = new SolidColorBrush(Color.FromRgb(190, 16, 39));
                    break;
                case 120:
                    brush = new SolidColorBrush(Color.FromRgb(199, 20, 164));
                    break;
                case 130:
                    break;
            }
            return brush;

        }
        public object ConvertBack(object value, Type targetType, object parameter, CultureInfo culture)
        {
            return null;
        }
    }

    public class StatusBtnEnableConvert : IValueConverter
    {
        public object Convert(object value, Type targetType, object parameter, CultureInfo culture)
        {
            int curStatusID = (int)value;
            int btnStatusID = System.Convert.ToInt32(parameter);
            if (curStatusID == 30)
            {
                if (btnStatusID == 40)
                {
                    return true;
                }
            }
            else if (curStatusID == 40)
            {
                if (btnStatusID == 50)
                {
                    return true;
                }
            }
            else if (curStatusID == 50)
            {
                if (btnStatusID == 40 || btnStatusID == 100)
                {
                    return true;
                }
            }
            else if (curStatusID == 100)
            {
                if (btnStatusID == 50 || btnStatusID == 40 || btnStatusID == 110 || btnStatusID == 120)
                {
                    return true;
                }
            }
            else if (curStatusID == 110)
            {
                if (btnStatusID == 50 || btnStatusID == 40 || btnStatusID == 120)
                {
                    return true;
                }
            }
            else if (curStatusID == 120)
            {
                if (btnStatusID == 110)
                {
                    return true;
                }
            }
            return false;

        }
        public object ConvertBack(object value, Type targetType, object parameter, CultureInfo culture)
        {
            return null;
        }
    }
    public class CurrentWeatherConvert : IMultiValueConverter
    {
        public object Convert(object[] values, Type targetType, object parameter, CultureInfo culture)
        {
            int weatherID = (int)values[0];
            int curWeatherID = (int)values[1];
            if (weatherID == curWeatherID)
            {
                LinearGradientBrush brush = new LinearGradientBrush();
                brush.StartPoint = new Point(0, 0);
                brush.EndPoint = new Point(0, 1);
                GradientStop stop1 = new GradientStop(Color.FromRgb(255, 249, 192), 0);
                GradientStop stop2 = new GradientStop(Color.FromRgb(255, 112, 0), 1);
                brush.GradientStops.Add(stop1);
                brush.GradientStops.Add(stop2);
                return brush;
            }
            return Brushes.White;
        }
        public object[] ConvertBack(object value, Type[] targetTypes, object parameter, CultureInfo culture)
        {
            return null;
        }
    }

    public class BoolReverseConvert : IValueConverter
    {
        public object Convert(object value, Type targetType, object parameter, CultureInfo culture)
        {
            bool bOrg = (bool)value;
            if (bOrg)
            {
                return false;
            }
            return true;
        }
        public object ConvertBack(object value, Type targetType, object parameter, CultureInfo culture)
        {
            return null;
        }
    }


    public class FontWeightConvert : IValueConverter
    {
        public object Convert(object value, Type targetType, object parameter, CultureInfo culture)
        {
            if (value == null || (string)value != "")
            {
                return FontWeights.Normal;
            }
            return FontWeights.Bold;
        }
        public object ConvertBack(object value, Type targetType, object parameter, CultureInfo culture)
        {
            return null;
        }
    }

    public class RqPenReadOnlyConvert : IValueConverter
    {
        public object Convert(object value, Type targetType, object parameter, CultureInfo culture)
        {
            if (value == null || (string)value == "")
            {
                return Visibility.Collapsed;
            }
            return Visibility.Visible;
        }
        public object ConvertBack(object value, Type targetType, object parameter, CultureInfo culture)
        {
            return null;
        }
    }
}
