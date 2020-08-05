using System;
using System.Collections.Generic;
using System.Reflection;
using Stimulsoft.Report.Components;

namespace OVRReportsScriptHelper
{
    public class ReportScript
    {
        public static Object ReflectVar(object obj, String strVarName)
        {
            Type ParentType = obj.GetType();
            FieldInfo fi_Var = ParentType.GetField(strVarName);
            if (fi_Var != null)
            {
                return fi_Var.GetValue(obj);
            }
            return null;
        }
    }

    public class TextBoxCol : List<StiText> {}
    //调整TextBox的宽度，边距
    public class AdjustTextBoxPosition
    {
        private double m_totalWidth;
        private double m_totalLeft;
        private int m_showNum;
        private int m_txtCount;
        private List<TextBoxCol> m_txtCtrls;

        /// <summary>
        /// 
        /// </summary>
        /// <param name="tolWidth">总长度</param>
        /// <param name="tolLeft">左边距</param>
        /// <param name="tolColNum">最大列数量</param>
        /// <param name="showNum">显示的数量</param>
        public AdjustTextBoxPosition( double tolWidth, double tolLeft, int tolColNum, int showNum)
        {
            m_totalWidth = tolWidth;
            m_totalLeft = tolLeft;
            m_txtCount = tolColNum;
            m_showNum = showNum;
            m_txtCtrls = new List<TextBoxCol>();
            for (int i = 0; i < tolColNum; i++ )
            {
                TextBoxCol col = new TextBoxCol();
                m_txtCtrls.Add(col);
            }
        }

        public bool AddTextToCol(int col, StiText stiTxt)
        {
            if (col > m_txtCount - 1 || col < 0)
            {
                return false;
            }
            (m_txtCtrls[(int)col]).Add(stiTxt);
            return true;
        }
        public void AutoAdjustTextBox()
        {
            double eleWidth = m_totalWidth / (double)m_showNum;
            for (int i = 0; i < m_txtCtrls.Count; i++ )
            {
                if ( i < m_showNum )
                {
                    foreach ( StiText stiTxt in m_txtCtrls[i])
                    {
                        stiTxt.Width = eleWidth;
                        stiTxt.Left = i * eleWidth + m_totalLeft;
                    }
                }
                else
                {
                    foreach (StiText stiTxt in m_txtCtrls[i])
                    {
                        stiTxt.Width = 0.0;
                        stiTxt.Left = m_totalLeft + m_totalWidth;
                    }
                }
            }
        }
    }
    

}
