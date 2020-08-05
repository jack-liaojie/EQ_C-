using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Navigation;
using System.Windows.Shapes;

namespace OVRRUPlugin.View
{
    /// <summary>
    /// Interaction logic for MatchPlayers.xaml
    /// </summary>
    public partial class MatchPlayers : UserControl
    {
        /// <summary>
        /// 定义一个路由事件，用来和其他对象交互.
        /// </summary>
        public static readonly RoutedEvent SelectedChangedEvent = EventManager.RegisterRoutedEvent("SelectedChanged",
                RoutingStrategy.Bubble, typeof(RoutedEventHandler), typeof(MatchPlayers));

        public event RoutedEventHandler SelectedChanged
        {
            add { AddHandler(MatchPlayers.SelectedChangedEvent, value); }
            remove { RemoveHandler(MatchPlayers.SelectedChangedEvent, value); }
        }

        public MatchPlayers()
        {
            InitializeComponent();
        }

        private void grdCourtPlayers_SelectionChanged(object sender, SelectionChangedEventArgs e)
        {
            this.RaiseEvent(new RoutedEventArgs(MatchPlayers.SelectedChangedEvent, this));
        }
    }
}
