using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;
using DevComponents.DotNetBar;
using AutoSports.OVRCommon;
using Sunny.UI;

//KnockOut设置,决赛阶段的,支持多个

namespace AutoSports.OVRDrawModel
{
    public partial class AxModelWizardKnockFinalForm : UIForm
    {
        public AxModelWizardKnockFinalForm()
        {
            InitializeComponent();
        }

        public Int32 m_nGroupFromCnt = 0;			//共有多少组到此阶段



        public Int32 m_nQualFromCntPerGroup = 0;		//每组会能有几人到此阶段




        static String m_strSectionName = "OVRDrawModel";

        private void Localization()
        {
            this.lbStageTitle.Text = LocalizationRecourceManager.GetString(m_strSectionName, "lbStageTitle");
            this.gpRankFirst.Text = LocalizationRecourceManager.GetString(m_strSectionName, "gpRankFirst");
            this.gpRankSecond.Text = LocalizationRecourceManager.GetString(m_strSectionName, "gpRankSecond");
            this.gpRankThird.Text = LocalizationRecourceManager.GetString(m_strSectionName, "gpRankThird");
            this.chbRank1.Text = LocalizationRecourceManager.GetString(m_strSectionName, "chbRank");
            this.chbRank2.Text = LocalizationRecourceManager.GetString(m_strSectionName, "chbRank");
            this.chbRank3.Text = LocalizationRecourceManager.GetString(m_strSectionName, "chbRank");
        }

        private void InitCtrlStyleContent()
        {
            this.tbStageTitle.Text = LocalizationRecourceManager.GetString(m_strSectionName, "tbTypeFinal");
            this.chbRank2.Checked = true;
            this.chbRank3.Checked = true;

            this.tbRank1Title.Text = LocalizationRecourceManager.GetString(m_strSectionName, "tbRank1Title");
            this.tbRank2Title.Text = LocalizationRecourceManager.GetString(m_strSectionName, "tbRank2Title");
            this.tbRank3Title.Text = LocalizationRecourceManager.GetString(m_strSectionName, "tbRank3Title");
            this.lbRank1.Text = LocalizationRecourceManager.GetString(m_strSectionName, "lbRankFirst");
        }

        public Int32 GetModelSize(int nModelIndex) 	//创建的几个模型都需要多少人 1-3
        {
            if (nModelIndex < 1 || nModelIndex > 3)
            {
                return 0;
            }

            Int32 nPlayerCntPerGroupRank1 = this.cbRank1End.SelectedIndex + 1;
            Int32 nPlayerCntPerGroupRank2 = this.cbRank2End.SelectedIndex + 1;

            if (nModelIndex == 1)
            {
                return GetRankIndexEnd(1);
            }
            else
            {
                if (nModelIndex == 2)
                {
                    return GetRankIndexEnd(2) - GetRankIndexEnd(1);
                }
                else //nModelIndex == 3
                {
                    return GetRankIndexEnd(3) - GetRankIndexEnd(2);
                }
            }
        }

        public Int32 GetModelLayer(int nModelIndex)  //创建的几个模型需要几层



        {
            Int32 nPlayerCnt = GetModelSize(nModelIndex);
	        return AxModelKnockOut.GetLayer(nPlayerCnt);
        }

        //public Int32 GetModelRank(int nModelIndex);	//创建的几个模型输出几人排名 目前认为 模型中有几人就输出几人排名



        public String GetModelTitle(int nModelIndex)  //此模型标题



        {
            if (nModelIndex < 1 || nModelIndex > 3)
            {
                return "";
            }

            String strTemp;
            if (nModelIndex == 1)
            {
                strTemp = this.tbRank1Title.Text;
            }
            else
            {
                if (nModelIndex == 2)
                {
                    strTemp = this.tbRank2Title.Text;
                }
                else
                {
                    strTemp = this.tbRank3Title.Text;
                }
            }

            return strTemp;
        }

        public Int32 GetModelPlayerIndexStart(int nModelIndex)  //此模型是从上一阶段每组第几名开始进入



        {
            if (nModelIndex < 1 || nModelIndex > 3)
            {
                return 0;
            }

            if (nModelIndex == 1)
            {
                return 1;
            }
            else if (nModelIndex == 2)
            {
                if (IsModelCanUse(2))
                    return GetModelPlayerIndexEnd(1) + 1;
                else
                    return 0;
            }
            else // nModelIndex == 3 
            {
                if (IsModelCanUse(3))
                    return GetModelPlayerIndexEnd(2) + 1;
                else
                    return 0;
            }
        }

        public Int32 GetModelPlayerIndexEnd(int nModelIndex)  //此模型是从上一阶段每组取到第几名为止



        {
            if (nModelIndex < 1 || nModelIndex > 3)
            {
                return 0;
            }

            if (nModelIndex == 1)
            {
                return this.cbRank1End.SelectedIndex + 1;
            }
            else if (nModelIndex == 2)
            {
                if (IsModelCanUse(2))
                    return GetModelPlayerIndexEnd(1) + this.cbRank2End.SelectedIndex + 1;
                else
                    return 0;
            }
            else // nModelIndex == 3
            {
                if (IsModelCanUse(3))
                    return GetModelPlayerIndexEnd(2) + this.cbRank3End.SelectedIndex + 1;
                else
                    return 0;
            }
        }

        public Int32 GetRankIndexStart(int nModelIndex)
        {
            if (nModelIndex < 1 || nModelIndex > 3)
            {
                return 0;
            }

            if (nModelIndex == 1)
            {
                return 1;
            }
            else if (nModelIndex == 2)
            {
                return GetRankIndexEnd(1) + 1;
            }
            else
            {
                return GetRankIndexEnd(2) + 1;
            }
        }

        public Int32 GetRankIndexEnd(int nModelIndex)  //此模型是控制所有进入决赛的第几名到第几名



        {
            if (nModelIndex < 1 || nModelIndex > 3)
            {
                return 0;
            }

            if (nModelIndex == 1)
            {
                return GetModelPlayerIndexEnd(1) * GetGroupFromCnt();
            }
            else if (nModelIndex == 2)
            {
                return GetModelPlayerIndexEnd(2) * GetGroupFromCnt();
            }
            else
            {
                return GetModelPlayerIndexEnd(3) * GetGroupFromCnt();
            }
        }

        public Boolean IsModelCanUse(Int32 nModelIndex)  //此模型是否可以被使用,主要依靠上一个模型是否还留下人可以用
        {
            if (nModelIndex < 1 || nModelIndex > 3)
            {
                return false;
            }

            if (nModelIndex == 1)
            {
                return true;
            }
            else if (nModelIndex == 2)
            {
                Int32 nPlayerIdxRank1End = this.cbRank1End.SelectedIndex + 1;
                if (nPlayerIdxRank1End == GetQualFromCntPerGroup())
                    return false;
                else
                    return true;
            }
            else // nModelIndex == 3
            {
                if (!IsModelCanUse(2))	//2不能用,3肯定不能用



                    return false;

                Int32 nPlayerIdxRank2End = this.cbRank1End.SelectedIndex + 1 + this.cbRank2End.SelectedIndex + 1;
                if (nPlayerIdxRank2End == GetQualFromCntPerGroup())
                    return false;
                else
                    return true;
            }
        }

        public Boolean IsModelUse(Int32 nModelIndex)  //是否使用此模型,依靠两点
        {
            if (nModelIndex < 1 || nModelIndex > 3)
            {
                return false;
            }

            if (nModelIndex == 1)
            {
                if (IsModelCanUse(1))
                    return true;
                else
                    return false;
            }
            else if (nModelIndex == 2)
            {
                if (IsModelCanUse(2) && this.chbRank2.Checked)
                    return true;
                else
                    return false;
            }
            else // nModelIndex == 3
            {
                if (IsModelCanUse(3) && this.chbRank3.Checked)
                    return true;
                else
                    return false;
            }
        }

        public Boolean isValued()  //所有设置是否合法,会弹出对话框提示
        {
            String strMsg;

            if (GetModelSize(1) > 8)
            {
                strMsg = LocalizationRecourceManager.GetString(m_strSectionName, "KnockOut1Error");
                DevComponents.DotNetBar.MessageBoxEx.Show(strMsg);
                return false;
            }

            if (GetModelSize(2) > 8)
            {
                strMsg = LocalizationRecourceManager.GetString(m_strSectionName, "KnockOut2Error");
                DevComponents.DotNetBar.MessageBoxEx.Show(strMsg);
                return false;
            }

            if (GetModelSize(3) > 8)
            {
                strMsg = LocalizationRecourceManager.GetString(m_strSectionName, "KnockOut3Error");
                DevComponents.DotNetBar.MessageBoxEx.Show(strMsg);
                return false;
            }

            return true;
        }

        public String GetStageTitle()
        {
            String strTemp;
            strTemp = this.tbStageTitle.Text;
            return strTemp;
        }

        public Int32 GetGroupFromCnt()
        {
            return m_nGroupFromCnt;
        }

        public Int32 GetQualFromCntPerGroup()
        {
            return m_nQualFromCntPerGroup;
        }

        public void SetParam(Int32 nGroupCnt, Int32 nQualCntPerGroup)
        {
            //bool bNeedInit = false;

            if ((nGroupCnt != m_nGroupFromCnt) || (nQualCntPerGroup != m_nQualFromCntPerGroup))
            {
                //bNeedInit = true;
                m_nGroupFromCnt = nGroupCnt;
                m_nQualFromCntPerGroup = nQualCntPerGroup;

                Init();
            }
            else
            {
                //和上次参数一样的话，就不用更新了
                return;
            }
        }

        protected void Init()  //根据人数范围设置复选框范围和默认设置


        {
            if (m_nGroupFromCnt < 1 || m_nQualFromCntPerGroup < 1)
                return;

            Int32 nPlayerCnt = m_nGroupFromCnt * m_nQualFromCntPerGroup;

            this.cbRank1End.Items.Clear();

            for (Int32 nCyc = GetModelPlayerIndexStart(1); nCyc <= GetQualFromCntPerGroup(); nCyc++)
            {
                this.cbRank1End.Items.Add(nCyc);
            }

            this.cbRank1End.SelectedIndex = 0;
            cbRank1End_SelectedIndexChanged(null, null);
        }

        protected void SetRank2Enable(Boolean bEnable)
        {
            this.cbRank2End.Enabled = bEnable;
            this.tbRank2Title.Enabled = bEnable;
            this.chbRank2.Enabled = bEnable;

            if(!bEnable)
            {
                this.cbRank2End.Items.Clear();
                this.lbRank2.Text = "";
                this.lbRank2Desc.Text = "";
            }

            this.tbStageTitle.Enabled = IsModelUse(2);
        }

        protected void SetRank3Enable(Boolean bEnable)
        {
            this.cbRank3End.Enabled = bEnable;
            this.tbRank3Title.Enabled = bEnable;
            this.chbRank3.Enabled = bEnable;

            if (!bEnable)
            {
                this.cbRank3End.Items.Clear();
                this.lbRank3.Text = "";
                this.lbRank3Desc.Text = "";
            }
        }

        private void chbRank2_CheckedChanged(object sender, EventArgs e)
        {
            if (!this.chbRank2.Checked)
            {
                this.chbRank3.Checked = false;
                this.tbStageTitle.Enabled = false;
            }
            else
            {
                this.tbStageTitle.Enabled = true;
            }
        }

        private void chbRank3_CheckedChanged(object sender, EventArgs e)
        {
            if (this.chbRank3.Checked)
            {
                this.chbRank2.Checked = true;
                this.tbStageTitle.Enabled = true;
            }
        }

        private void cbRank1End_SelectedIndexChanged(object sender, EventArgs e)
        {
            //刷新显示Rank1的信息



            String strInfo;
            String strMsg;
            strMsg = LocalizationRecourceManager.GetString(m_strSectionName, "lbRankInfo");
            strInfo = String.Format(strMsg, GetRankIndexStart(1), GetRankIndexEnd(1));
            this.lbRank1Desc.Text = strInfo;

            //判断是否显示Rank2
            if (IsModelCanUse(2))
            {
                SetRank2Enable(true);

                //刷新Rank2开始信息




                String strStartInfo;
                strMsg = LocalizationRecourceManager.GetString(m_strSectionName, "lbRankStart");
                strStartInfo = String.Format(strMsg, GetModelPlayerIndexStart(2));
                this.lbRank2.Text = strStartInfo;

                this.cbRank2End.Items.Clear();
                for (Int32 nCyc = GetModelPlayerIndexStart(2); nCyc <= m_nQualFromCntPerGroup; nCyc++)
                {
                    this.cbRank2End.Items.Add(nCyc);
                }
                this.cbRank2End.SelectedIndex = 0;
                cbRank2End_SelectedIndexChanged(null, null); //刷新Rank2显示
            }
            else
            {
                SetRank2Enable(false);
                SetRank3Enable(false);
            }
        }

        private void cbRank2End_SelectedIndexChanged(object sender, EventArgs e)
        {
            //刷新显示Rank2的信息



            String strInfo;
            String strMsg;
            strMsg = LocalizationRecourceManager.GetString(m_strSectionName, "lbRankInfo");
            strInfo = String.Format(strMsg, GetRankIndexStart(2), GetRankIndexEnd(2));
            this.lbRank2Desc.Text = strInfo;

            //判断是否显示Rank3
            if (IsModelCanUse(3))
            {
                SetRank3Enable(true);

                //刷新Rank3开始信息



                String strStartInfo;
                strMsg = LocalizationRecourceManager.GetString(m_strSectionName, "lbRankStart");
                strStartInfo = String.Format(strMsg, GetModelPlayerIndexStart(3));
                this.lbRank3.Text = strStartInfo;

                this.cbRank3End.Items.Clear();
                for (Int32 nCyc = GetModelPlayerIndexStart(3); nCyc <= m_nQualFromCntPerGroup; nCyc++)
                {
                    this.cbRank3End.Items.Add(nCyc);
                }
                this.cbRank3End.SelectedIndex = 0;
                cbRank3End_SelectedIndexChanged(null, null); //刷新Rank3显示
            }
            else
            {
                SetRank3Enable(false);
            }
        }

        private void cbRank3End_SelectedIndexChanged(object sender, EventArgs e)
        {
            //刷新显示Rank3的信息



            String strInfo;
            String strMsg;
            strMsg = LocalizationRecourceManager.GetString(m_strSectionName, "lbRankInfo");
            strInfo = String.Format(strMsg, GetRankIndexStart(3), GetRankIndexEnd(3));
            this.lbRank3Desc.Text = strInfo;
        }

        private void AxModelWizardKnockFinalForm_Load(object sender, EventArgs e)
        {
            Localization();
            InitCtrlStyleContent();
        }
    }
}
