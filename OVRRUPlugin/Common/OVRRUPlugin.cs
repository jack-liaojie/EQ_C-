using System.Windows.Forms;
using System;
using AutoSports.OVRCommon;
using OVRRUPlugin;
using System.Data.SqlClient;

namespace OVRRUPlugin.Common
{
    public class OVRRUPlugin:OVRPluginBase
    {
        private frmOVRRUDataEntry m_frmRUPlugin = null;

        public OVRRUPlugin()
        {
            base.m_strName = GVAR.g_strDisplnName;
            base.m_strDiscCode = GVAR.g_strDisplnCode;

            m_frmRUPlugin = new frmOVRRUDataEntry();
            m_frmRUPlugin.TopLevel = false;
            m_frmRUPlugin.Dock = DockStyle.Fill;
            m_frmRUPlugin.FormBorderStyle = FormBorderStyle.None;
        
        }

        public void FillDataGridView(DataGridView dgv, SqlDataReader dt)
        {
            if (dgv == null || dt == null) return;
            if (dt.FieldCount < 1) return;

            bool bResetColumns = false;
            if (dt.FieldCount != dgv.Columns.Count)
            {
                bResetColumns = true;
            }
            else
            {
                for (int i = 0; i < dt.FieldCount; i++)
                {
                    if (dgv.Columns[i].HeaderText != dt.GetName(i))
                    {
                        bResetColumns = true;
                        break;
                    }
                }
            }

            try
            {
                // Reset Columns
                if (bResetColumns)
                {
                    dgv.Columns.Clear();
                    for (int i = 0; i < dt.FieldCount; i++)
                    {
                        DataGridViewColumn col = null;
                        bool bTextBoxCol = true;

                        if (bTextBoxCol)
                        {
                            col = new DataGridViewTextBoxColumn();
                            col.ReadOnly = true;
                        }

                        if (col != null)
                        {
                            col.HeaderText = dt.GetName(i);
                            col.Name = dt.GetName(i);


                            col.Frozen = false;
                            col.AutoSizeMode = DataGridViewAutoSizeColumnMode.None;
                            col.SortMode = DataGridViewColumnSortMode.NotSortable;
                            col.Resizable = DataGridViewTriState.False;
                            dgv.Columns.Add(col);
                        }
                    }
                }

                for (int i = 0; i < dgv.Columns.Count; i++)
                {
                    System.Drawing.SizeF sf = dgv.CreateGraphics().MeasureString(dgv.Columns[i].HeaderText, dgv.Font);
                    if (dgv.Columns[i].HeaderText == "Bib")
                    {
                        dgv.Columns[i].Width = System.Convert.ToInt32(sf.Width + 5f);
                    }
                    if (dgv.Columns[i].HeaderText == "Name")
                    {
                        dgv.Columns[i].Width = System.Convert.ToInt32(sf.Width + 108f);
                    }
                    if (dgv.Columns[i].HeaderText == "Position")
                    {
                        dgv.Columns[i].Width = System.Convert.ToInt32(sf.Width + 5f);
                    }
                }
                // Fill DataGridView
                dgv.Rows.Clear();
                int iRowNum = 0;
                while (dt.Read())
                {
                    DataGridViewRow dr = new DataGridViewRow();
                    dr.CreateCells(dgv);
                    dr.Selected = false;

                    for (int i = 0; i < dt.FieldCount; i++)
                    {
                        dr.Cells[i].Value = dt[i].ToString();
                        //if (dt.GetName(i)=="Time")
                        //{
                        //    string strTime = dt[i].ToString();
                        //    if (strTime.Length == 0)
                        //    {
                        //        dr.Cells[i].Value = GVAR.Str2Int(GVAR.g_FBPlugin.m_frmFBPlugin.m_CCurMatch.MatchTime);
                        //    }
                        //}
                    }
                    iRowNum++;
                    dr.HeaderCell.Value = iRowNum.ToString();

                    dgv.Rows.Add(dr);
                }

            }
            catch (System.Exception ex)
            {
                MessageBox.Show(ex.Message);
                return;
            }
        }

        public override bool Initialize(System.Data.SqlClient.SqlConnection con)
        {
            GVAR.g_RUPlugin= this;
            GVAR.g_ManageDB = new OVRRUManageDB();
            GVAR.g_adoDataBase = new OVRRUDataBase();
            GVAR.g_adoDataBase.DBConnect = con;

            if (GVAR.g_adoDataBase.DBConnect.State == System.Data.ConnectionState.Closed)
            {
                GVAR.g_adoDataBase.DBConnect.Open();
            }

            return true;
        }

        public override System.Windows.Forms.Control GetModuleUI
        {
            get { return m_frmRUPlugin as System.Windows.Forms.Control; }
        }

        protected override void OnMgrEvent(object sender, OVRMgr2PluginEventArgs e)
        {
            switch (e.Type)
            {
                case OVRMgr2PluginEventType.emMatchSelected:
                    {
                        if (m_frmRUPlugin != null)
                        {
                            m_frmRUPlugin.OnMsgFlushSelMatch(0, GVAR.Str2Int(e.Args.ToString()));
                            SetReportContext("MatchID", e.Args.ToString());
                        }
                        break;
                    }
                case OVRMgr2PluginEventType.emRptContextQuery:
                    {
                        QueryReportContext(e.Args as OVRReportContextQueryArgs);
                        break;
                    }
            }
        }

        private void QueryReportContext(OVRReportContextQueryArgs args)
        {
            if (args == null) return;
            switch (args.Name)
            {
                case "MatchID":
                    {
                        if (GVAR.g_matchID > 0)
                        {
                            args.Value = GVAR.g_matchID.ToString();
                            args.Handled = true;
                        }
                        break;
                    }
                default:
                    break;
            }
        }
    }
}
