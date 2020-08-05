using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Drawing;
using System.Data;
using System.Text;
using System.Windows.Forms;
using System.Data.SqlClient;
using System.Collections;

using AutoSports.OVRCommon;

namespace AutoSports.OVRMatchSchedule
{
    public partial class OVRMatchScheduleForm
    {
        struct SAxTreeNodeInfo  // 树控件节点定义
        {
            public String strNodeKey;
            public int iNodeType;
            public int iSportID;
            public int iDisciplineID;
            public int iEventID;
            public int iPhaseID;
            public int iFatherPhaseID;
            public int iMatchID;
            public int iPhaseType;
            public int iPhaseSize;
        }

        private void RefreshPhaseTree()
        {
            advTree.BeginUpdate();
            advTree.Nodes.Clear();
            DevComponents.AdvTree.Node oLastSelNode = null;
            try
            {
                SqlCommand oneSqlCommand = new SqlCommand();
                oneSqlCommand.Connection = m_matchScheduleModule.DatabaseConnection;
                oneSqlCommand.CommandText = "Proc_GetScheduleTree";
                oneSqlCommand.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter(
                            "@ID", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "@ID",
                            DataRowVersion.Current, m_strDisciplineID);
                oneSqlCommand.Parameters.Add(cmdParameter1);

                SqlParameter cmdParameter2 = new SqlParameter(
                            "@Type", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "@Type",
                            DataRowVersion.Current, -5);
                oneSqlCommand.Parameters.Add(cmdParameter2);

                SqlParameter cmdParameter3 = new SqlParameter(
                            "@LanguageCode", SqlDbType.Char, 3,
                            ParameterDirection.Input, true, 0, 0, "@LanguageCode",
                            DataRowVersion.Current, m_strActiveLanguageCode);

                oneSqlCommand.Parameters.Add(cmdParameter3);

                if (m_matchScheduleModule.DatabaseConnection.State == System.Data.ConnectionState.Closed)
                {
                    m_matchScheduleModule.DatabaseConnection.Open();
                }

                SqlDataReader sdr = oneSqlCommand.ExecuteReader();

                int cols = sdr.FieldCount;                                          //获取结果行中的列数
                object[] values = new object[cols];
                if (sdr.HasRows)
                {
                    while (sdr.Read())
                    {
                        String strNodeName = "";
                        String strNodeKey = "";
                        String strFatherNodeKey = "";
                        int iNodeType = -5;//-4表示所有Sport, -3表示Sport，-2表示Discipline，-1表示Event，0表示Phase
                        int iSportID = 0;
                        int iDisciplineID = 0;
                        int iEventID = 0;
                        int iPhaseID = 0;
                        int iPhaseType = 0;
                        int iPhaseSize = 0;
                        int iFatherPhaseID = 0;
                        int iMatchID = 0;
                        int nImage = 0;
                        int nSelectedImage = 0;

                        strNodeName = OVRDataBaseUtils.GetFieldValue2String(ref sdr, "F_NodeName");
                        strNodeKey = OVRDataBaseUtils.GetFieldValue2String(ref sdr, "F_NodeKey");
                        strFatherNodeKey = OVRDataBaseUtils.GetFieldValue2String(ref sdr, "F_FatherNodeKey");
                        iNodeType = OVRDataBaseUtils.GetFieldValue2Int32(ref sdr, "F_NodeType");
                        iSportID = OVRDataBaseUtils.GetFieldValue2Int32(ref sdr, "F_SportID");
                        iDisciplineID = OVRDataBaseUtils.GetFieldValue2Int32(ref sdr, "F_DisciplineID");
                        iEventID = OVRDataBaseUtils.GetFieldValue2Int32(ref sdr, "F_EventID");
                        iPhaseID = OVRDataBaseUtils.GetFieldValue2Int32(ref sdr, "F_PhaseID");
                        iPhaseType = OVRDataBaseUtils.GetFieldValue2Int32(ref sdr, "F_PhaseType");
                        iPhaseSize = OVRDataBaseUtils.GetFieldValue2Int32(ref sdr, "F_PhaseSize");
                        iFatherPhaseID = OVRDataBaseUtils.GetFieldValue2Int32(ref sdr, "F_FatherPhaseID");
                        iMatchID = OVRDataBaseUtils.GetFieldValue2Int32(ref sdr, "F_MatchID");
                        nImage = iNodeType + 3;
                        nSelectedImage = iNodeType + 3;

                        SAxTreeNodeInfo oneSNodeInfo = new SAxTreeNodeInfo();
                        oneSNodeInfo.strNodeKey = strNodeKey;
                        oneSNodeInfo.iNodeType = iNodeType;
                        oneSNodeInfo.iSportID = iSportID;
                        oneSNodeInfo.iDisciplineID = iDisciplineID;
                        oneSNodeInfo.iEventID = iEventID;
                        oneSNodeInfo.iPhaseID = iPhaseID;
                        oneSNodeInfo.iPhaseType = iPhaseType;
                        oneSNodeInfo.iPhaseSize = iPhaseSize;
                        oneSNodeInfo.iFatherPhaseID = iFatherPhaseID;
                        oneSNodeInfo.iMatchID = iMatchID;

                        DevComponents.AdvTree.Node oneNode = new DevComponents.AdvTree.Node();
                        oneNode.Text = strNodeName;
                        oneNode.ImageIndex = nImage;
                        oneNode.ImageExpandedIndex = nSelectedImage;
                        oneNode.Tag = oneSNodeInfo;
                        oneNode.DataKey = strNodeKey;

                        if (oneSNodeInfo.iNodeType == -3)
                        {
                            oneNode.Expanded = true;
                        }
                        if (oneSNodeInfo.iNodeType == -2 && oneSNodeInfo.iDisciplineID == m_iActiveDisciplineID)
                        {
                            oneNode.Expanded = true;
                        }

                        DevComponents.AdvTree.Node FatherNode = advTree.FindNodeByDataKey(strFatherNodeKey);
                        if (FatherNode == null)
                        {
                            advTree.Nodes.Add(oneNode);
                        }
                        else
                        {
                            FatherNode.Nodes.Add(oneNode);
                        }

                        if (m_strLastSelPhaseTreeNodeKey == strNodeKey)
                        {
                            oLastSelNode = oneNode;
                            oneNode.Expanded = true;

                            // Expand All Parent Node
                            DevComponents.AdvTree.Node node = oLastSelNode;
                            while (node.Parent != null)
                            {
                                node.Parent.Expanded = true;
                                node = node.Parent;
                            }
                        }
                    }
                }

                sdr.Close();
            }
            catch (Exception ex)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
            }

            advTree.EndUpdate();
            advTree.SelectedNode = oLastSelNode;
        }
    }
}