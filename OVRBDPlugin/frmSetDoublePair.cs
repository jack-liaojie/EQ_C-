using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using DevComponents.DotNetBar;
using AutoSports.OVRCommon;

namespace AutoSports.OVRBDPlugin
{
    public partial class frmSetDoublePair : Office2007Form
    {
        Int32 m_iMatchID;
        Int32 m_iSplitRegisterID;
        Int32 m_iPosition;
        SexType m_sexType;

        public Int32 m_iPairRegID { get;private set;}
        public bool BClearDouble {private set;get;}

        public frmSetDoublePair(Int32 iMatchID, Int32 iSplitRegisterID, Int32 iPosition, SexType sexType)
        {
            m_iMatchID = iMatchID;
            m_iSplitRegisterID = iSplitRegisterID;
            m_iPosition = iPosition;
            m_sexType = sexType;
            BClearDouble = false;
            m_iPairRegID = -1;
            //OVRDataBaseUtils.SetDataGridViewStyle(this.lstbx_TeamMembers);
            InitializeComponent();
        }

        public void InitTeamMembersListBox()
        {
            BDCommon.g_ManageDB.InitTeamMembersListBox(ref lstbx_TeamMembers, m_iMatchID, m_iPosition, m_sexType);

            foreach ( DataGridViewRow row in   lstbx_TeamMembers.SelectedRows)
            {
                row.Selected = false;
            }
          

            if (m_iSplitRegisterID > 0)
            {
                Int32 iPairMember1RegID, iPairMember2RegID;
                BDCommon.g_ManageDB.GetDoublePairMember(m_iSplitRegisterID, out iPairMember1RegID, out iPairMember2RegID);

                if (iPairMember1RegID <= 0 && iPairMember2RegID <= 0)
                    iPairMember1RegID = m_iSplitRegisterID;

                SelectMemeberInListBox(iPairMember1RegID, iPairMember2RegID);
            }
        }

        private void SelectMemeberInListBox(Int32 iPairMember1RegID, Int32 iPairMember2RegID)
        {
            if (iPairMember1RegID > 0 )
            {
                foreach ( DataGridViewRow row in lstbx_TeamMembers.Rows )
                {
                    int registerID = Convert.ToInt32(row.Cells[0].Value);
                    if (registerID == iPairMember1RegID )
                    {
                        row.Selected = true;
                    }
                }
                //int iMember1Pos = lstbx_TeamMembers.FindStringExact(BDCommon.g_ManageDB.GetRegisterName(iPairMember1RegID));
                //lstbx_TeamMembers.SelectedIndices.Add(iMember1Pos);
            }
            if (iPairMember2RegID > 0)
            {
                //int iMember2Pos = lstbx_TeamMembers.FindStringExact(BDCommon.g_ManageDB.GetRegisterName(iPairMember2RegID));
                //lstbx_TeamMembers.SelectedIndices.Add(iMember2Pos);

                foreach (DataGridViewRow row in lstbx_TeamMembers.Rows)
                {
                    int registerID = Convert.ToInt32(row.Cells[0].Value);
                    if (registerID == iPairMember2RegID)
                    {
                        row.Selected = true;
                    }
                }
            }
        }

        private void lstbx_TeamMembers_SelectedValueChanged(object sender, EventArgs e)
        {
            if(lstbx_TeamMembers.SelectedRows.Count > 2)
            {
                for (int i = 0; i < lstbx_TeamMembers.SelectedRows.Count;i++ )
                {
                    if ( i <= 1 )
                    {
                        lstbx_TeamMembers.SelectedRows[i].Selected = true;
                    }
                    else
                    {
                        lstbx_TeamMembers.SelectedRows[i].Selected = false;
                    }
                }
                return;
            }

            UpdatePairNamePreview();
        }

        private void UpdatePairNamePreview()
        {
            lbPreviewPairName.Text = "";

            Int32 iSelCount = lstbx_TeamMembers.SelectedRows.Count;
            for (int i= iSelCount-1; i >= 0; i--)
            {
                DataGridViewRow rowView = lstbx_TeamMembers.SelectedRows[i] as DataGridViewRow;
                if (rowView != null)
                {
                    string name = rowView.Cells[1].Value.ToString();
                    if (lbPreviewPairName.Text.Length > 0)
                        lbPreviewPairName.Text += "/";
                    lbPreviewPairName.Text += name;
                }
            }
        }

        private void BtnOk_Click(object sender, EventArgs e)
        {
            int nSelCount = lstbx_TeamMembers.SelectedRows.Count;
            if (nSelCount == 2)
            {
                int nRegBID = Convert.ToInt32((lstbx_TeamMembers.SelectedRows[0] as DataGridViewRow).Cells[0].Value);
                int nRegAID = Convert.ToInt32((lstbx_TeamMembers.SelectedRows[1] as DataGridViewRow).Cells[0].Value);

                m_iPairRegID = BDCommon.g_ManageDB.CreateDoublePair(nRegAID, nRegBID);
            }
            else
            {
                DevComponents.DotNetBar.MessageBoxEx.Show("Make sure two players are selected!");
                return;
            }
            //else if (nSelCount == 1)
            //{
            //    m_iPairRegID = Convert.ToInt32((lstbx_TeamMembers.SelectedRows[0] as DataGridViewRow).Cells[0].Value);
            //}

            this.DialogResult = DialogResult.OK;
            BClearDouble = false;
            this.Close();
        }

        private void dgGridSelectChanged(object sender, EventArgs e)
        {
            if (lstbx_TeamMembers.SelectedRows.Count > 2)
            {
                for (int i = 0; i < lstbx_TeamMembers.SelectedRows.Count; i++)
                {
                    if (i <= 1)
                    {
                        lstbx_TeamMembers.SelectedRows[i].Selected = true;
                    }
                    else
                    {
                        lstbx_TeamMembers.SelectedRows[i].Selected = false;
                    }
                }
                return;
            }
            if ( m_sexType == SexType.All )
            {
                if (lstbx_TeamMembers.SelectedRows.Count == 2)
                {
                    int sexA = Convert.ToInt32((lstbx_TeamMembers.SelectedRows[0] as DataGridViewRow).Cells[2].Value);
                    int sexB = Convert.ToInt32((lstbx_TeamMembers.SelectedRows[1] as DataGridViewRow).Cells[2].Value);
                    if ( sexA == sexB )
                    {
                        lstbx_TeamMembers.SelectedRows[1].Selected = false;
                    }
                }
            }

            UpdatePairNamePreview();
        }

        private void btnClearDouble_Click(object sender, EventArgs e)
        {
            this.DialogResult = DialogResult.OK;
            BClearDouble = true;
            this.Close();
        }
    }
}
