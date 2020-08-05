using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using OVRBDWPF;
namespace AutoSports.OVRBDPlugin
{
    public partial class InputResults : Form
    {
        ResultsInput m_input;
        public InputResults()
        {
            InitializeComponent();
            m_input = new ResultsInput();
        }

        

        private void frmInputResultsLoaded(object sender, EventArgs e)
        {
            eleWPFInputResults.Child = m_input;
        }
    }
}
