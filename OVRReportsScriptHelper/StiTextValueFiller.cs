using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Stimulsoft.Report.Components;
using Stimulsoft.Report.Dictionary;
using OVRReportsScriptHelper;

namespace OVRReportScriptHelper
{
    public class StiTextValueFiller
    {
        private object m_container;
        //m_dataTable第一列必须为数字，指明要填充的序号，后面列依次对应fieldPrefix
        private StiDataTableSource m_dataTable;
        private string[] m_fieldPrefix;
        public StiTextValueFiller(object textContainer, StiDataTableSource dataTable, string[] fieldPrefix)
        {
            m_container = textContainer;
            m_dataTable = dataTable;
            m_fieldPrefix = fieldPrefix;
        }

        public void DoFill()
        {
            if (m_dataTable == null || m_fieldPrefix == null || m_fieldPrefix.Length <= 0)
            {
                return;
            }
            if (m_dataTable.Columns.Count < m_fieldPrefix.Length + 1)
            {
                return;
            }
            string strColName;
            for (int j = 0; j < m_dataTable.Rows.Count; j++)
            {
                //先取索引
                StiRow sr = m_dataTable.Rows[j];
                strColName = m_dataTable.Columns[0].Name;
                string strIndex = sr[strColName].ToString();

                //赋值
                for (int i = 1; i <= m_fieldPrefix.Length; i++)
                {
                    strColName = m_dataTable.Columns[i].Name;
                    string strValue = sr[strColName] == null ? "" : sr[strColName].ToString();//数据集中取出值
                    StiText st = (StiText)ReportScript.ReflectVar(m_container, m_fieldPrefix[i - 1] + strIndex);//用反射取得StiText控件
                    if (st != null)
                    {
                        st.TextValue = strValue;
                    }
                }
            }
        }
    }
}
