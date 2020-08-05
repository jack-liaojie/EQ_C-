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

//向导框架

namespace AutoSports.OVRDrawModel
{
    public partial class AxModelWizardFrameForm : UIForm
    {
        public AxModelWizardFrameForm()
        {
            InitializeComponent();
        }

        static string m_strSectionName = "OVRDrawModel";

        public EShowType m_eShowType = EShowType.emShowMain;
        public EUseEventModel m_eModelUse = EUseEventModel.emModelmGtoK;

        //用于输出的临时结果
        public AxDrawModelEvent m_ModelEvent = new AxDrawModelEvent();

        public AxModelWizardFirstForm m_StepFirst = new AxModelWizardFirstForm();
        public AxModelWizardGroupForm m_StepGroup = new AxModelWizardGroupForm();
        public AxModelWizardKnockOutForm m_StepKnockOut = new AxModelWizardKnockOutForm();
        public AxModelWizardKnockFinalForm m_StepKnockFinal = new AxModelWizardKnockFinalForm();
        public AxModelWizardKnockSingleForm m_StepKnockSingle = new AxModelWizardKnockSingleForm();

        private void Localization()
        {
            this.Text = LocalizationRecourceManager.GetString(m_strSectionName, "frmDrawModel");
            this.btnPrevious.Text = LocalizationRecourceManager.GetString(m_strSectionName, "btnPrevious");
            this.btnNext.Text = LocalizationRecourceManager.GetString(m_strSectionName, "btnNext");
            this.btnCancel.Text = LocalizationRecourceManager.GetString(m_strSectionName, "btnCancel");
        }

        private void InitCtrlStyleContent()
        {
            //创建子窗体
            m_StepFirst.Visible = true;
            m_StepGroup.Visible = false;
            m_StepKnockOut.Visible = false;
            m_StepKnockFinal.Visible = false;
            m_StepKnockSingle.Visible = false;
            m_StepFirst.TopLevel = false;
            m_StepGroup.TopLevel = false;
            m_StepKnockOut.TopLevel = false;
            m_StepKnockFinal.TopLevel = false;
            m_StepKnockSingle.TopLevel = false;
            m_StepFirst.Dock = DockStyle.Fill;
            m_StepGroup.Dock = DockStyle.Fill;
            m_StepKnockOut.Dock = DockStyle.Fill;
            m_StepKnockFinal.Dock = DockStyle.Fill;
            m_StepKnockSingle.Dock = DockStyle.Fill;

            this.lbDlg.Controls.Add(m_StepFirst);
            this.lbDlg.Controls.Add(m_StepGroup);
            this.lbDlg.Controls.Add(m_StepKnockOut);
            this.lbDlg.Controls.Add(m_StepKnockFinal);
            this.lbDlg.Controls.Add(m_StepKnockSingle);

            UpdateUI();
        }

	    public void UpdateUI()
        {
            if (m_eShowType == EShowType.emShowMain)
            {
                this.btnPrevious.Enabled = false;
                this.btnNext.Enabled = true;

                this.btnNext.Text = LocalizationRecourceManager.GetString(m_strSectionName, "btnNext");
                this.lbHelp1.Text = LocalizationRecourceManager.GetString(m_strSectionName, "lbHelp1Welcome");
                this.lbHelp2.Text = LocalizationRecourceManager.GetString(m_strSectionName, "lbHelp2Choose");
            }
            else if (m_eShowType == EShowType.emShowKnockSingle)
            {
                if (m_eModelUse == EUseEventModel.emModelKnockOut)
                {
                    this.btnPrevious.Enabled = true;
                    this.btnNext.Enabled = true;

                    this.btnNext.Text = LocalizationRecourceManager.GetString(m_strSectionName, "btnFinish");
                    this.lbHelp1.Text = LocalizationRecourceManager.GetString(m_strSectionName, "SingleKnockOut");
                    this.lbHelp2.Text = LocalizationRecourceManager.GetString(m_strSectionName, "lbSetKOParam");
                }
                else
                    if (m_eModelUse == EUseEventModel.emModelmKtoK)
                    {
                        this.btnPrevious.Enabled = true;
                        this.btnNext.Enabled = true;

                        this.btnNext.Text = LocalizationRecourceManager.GetString(m_strSectionName, "btnFinish");
                        this.lbHelp1.Text = LocalizationRecourceManager.GetString(m_strSectionName, "lbMKoToSKo");
                        this.lbHelp2.Text = LocalizationRecourceManager.GetString(m_strSectionName, "lbSetSecondPhaseParam");
                    }
                    else
                        if (m_eModelUse == EUseEventModel.emModelmGtoK)
                        {
                            this.btnPrevious.Enabled = true;
                            this.btnNext.Enabled = true;

                            this.btnNext.Text = LocalizationRecourceManager.GetString(m_strSectionName, "btnFinish");
                            this.lbHelp1.Text = LocalizationRecourceManager.GetString(m_strSectionName, "lbRRToSKo");
                            this.lbHelp2.Text = LocalizationRecourceManager.GetString(m_strSectionName, "lbSetKOParam");
                        }
            }
            else if (m_eShowType == EShowType.emShowKnockM)
            {
                if (m_eModelUse == EUseEventModel.emModelmKtoK)
                {
                    this.btnPrevious.Enabled = true;
                    this.btnNext.Enabled = true;

                    this.btnNext.Text = LocalizationRecourceManager.GetString(m_strSectionName, "btnNext");
                    this.lbHelp1.Text = LocalizationRecourceManager.GetString(m_strSectionName, "lbMKoToSKo");
                    this.lbHelp2.Text = LocalizationRecourceManager.GetString(m_strSectionName, "lbSetFirstPhaseParam");
                }
            }
            else if (m_eShowType == EShowType.emShowKnockMFinal)
            {
                this.btnPrevious.Enabled = true;
                this.btnNext.Enabled = true;

                this.btnNext.Text = LocalizationRecourceManager.GetString(m_strSectionName, "btnFinish");
                this.lbHelp1.Text = LocalizationRecourceManager.GetString(m_strSectionName, "lbRRToMKo");
                this.lbHelp2.Text = LocalizationRecourceManager.GetString(m_strSectionName, "lbSetKOParam");
            }
            else if (m_eShowType == EShowType.emShowGroupM)
            {
                if (m_eModelUse == EUseEventModel.emModelGroup)
                {
                    this.btnPrevious.Enabled = true;
                    this.btnNext.Enabled = true;

                    this.btnNext.Text = LocalizationRecourceManager.GetString(m_strSectionName, "btnFinish");
                    this.lbHelp1.Text = LocalizationRecourceManager.GetString(m_strSectionName, "cbTypeRoundRobin");
                    this.lbHelp2.Text = LocalizationRecourceManager.GetString(m_strSectionName, "lbSetRRParam");
                }
                else
                    if (m_eModelUse == EUseEventModel.emModelmGtoK)
                    {
                        this.btnPrevious.Enabled = true;
                        this.btnNext.Enabled = true;

                        this.btnNext.Text = LocalizationRecourceManager.GetString(m_strSectionName, "btnNext");
                        this.lbHelp1.Text = LocalizationRecourceManager.GetString(m_strSectionName, "lbRRToSKo");
                        this.lbHelp2.Text = LocalizationRecourceManager.GetString(m_strSectionName, "lbSetRRParam");
                    }
                    else
                        if (m_eModelUse == EUseEventModel.emModelmGtomK)
                        {
                            this.btnPrevious.Enabled = true;
                            this.btnNext.Enabled = true;

                            this.btnNext.Text = LocalizationRecourceManager.GetString(m_strSectionName, "btnNext");
                            this.lbHelp1.Text = LocalizationRecourceManager.GetString(m_strSectionName, "lbRRToMKo");
                            this.lbHelp2.Text = LocalizationRecourceManager.GetString(m_strSectionName, "lbSetRRParam");
                        }
            }
        }

	    //创建出只有DrawInfo,没有比赛列表的结构
	    public Boolean CreateEventModel()
        {
            m_ModelEvent.RemoveAll();

            //预赛,小组赛
            if (m_eModelUse == EUseEventModel.emModelGroup || m_eModelUse == EUseEventModel.emModelmGtomK || m_eModelUse == EUseEventModel.emModelmGtoK)
            {
                AxDrawModelStage modelStage = new AxDrawModelStage();
                modelStage.m_strStageName = m_StepGroup.GetStageTitle();

                for (Int32 nCyc = 0; nCyc < m_StepGroup.GetGroupCnt(); nCyc++)
                {
                    //每个组除了名字,都一样,所以统一建了一个,每次换名字
                    AxDrawModelModelExport modelExport = new AxDrawModelModelExport();
                    modelExport.m_drawInfo.m_bBogol = m_StepGroup.IsUseBogol();
                    modelExport.m_drawInfo.m_bQual = true;
                    modelExport.m_drawInfo.m_eType = EDrawModelType.emTypeRoundRobin;
                    modelExport.m_drawInfo.m_nSize = m_StepGroup.GetPlayerCntPerGroup();
                    modelExport.m_drawInfo.m_nRank = m_StepGroup.GetQualCntPerGroup();

                    modelExport.m_drawInfo.m_strTitle = m_StepGroup.GetGroupName(nCyc);
                    modelStage.m_aryModelList.Add(modelExport);
                }

                m_ModelEvent.m_aryStageList.Add(modelStage);

                //如果是单循环赛,在这直接加上名次信息,就完事了
                if (m_eModelUse == EUseEventModel.emModelGroup)
                {
                    for (Int32 nCyc = 0; nCyc < modelStage.m_aryModelList[0].m_drawInfo.m_nRank; nCyc++)
                    {
                        for (Int32 nGroup = 0; nGroup < m_StepGroup.GetGroupCnt(); nGroup++)
                        {
                            AxDrawModelPlayerFrom playerFrom = new AxDrawModelPlayerFrom();
                            playerFrom.m_byStageOrder = 0;
                            playerFrom.m_byModelOrder = (Byte)nGroup;
                            playerFrom.m_byResultRank = (Byte)(nCyc + 1);
                            m_ModelEvent.m_aryEventRank.Add(playerFrom);
                        }
                    }
                }
            }
            else
            if (m_eModelUse == EUseEventModel.emModelmKtoK) //预赛,淘汰赛
            {
                AxDrawModelStage modelStage = new AxDrawModelStage();
                modelStage.m_strStageName = m_StepKnockOut.GetStageTitle();

                for (int nCyc = 0; nCyc < m_StepKnockOut.GetGroupCnt(); nCyc++)
                {
                    //每个组除了名字,都一样,所以统一建了一个,每次换名字
                    AxDrawModelModelExport modelExport = new AxDrawModelModelExport();
                    modelExport.m_drawInfo.m_bBogol = false;
                    modelExport.m_drawInfo.m_bQual = true;
                    modelExport.m_drawInfo.m_eType = EDrawModelType.emTypeKonckOut;
                    modelExport.m_drawInfo.m_nSize = m_StepKnockOut.GetLayerCntPerGroup();
                    modelExport.m_drawInfo.m_nRank = m_StepKnockOut.GetQualCntPerGroup();
                    modelExport.m_drawInfo.m_strTitle = m_StepKnockOut.GetGroupName(nCyc);
                    modelStage.m_aryModelList.Add(modelExport);
                }

                m_ModelEvent.m_aryStageList.Add(modelStage);
            }
            else
            if (m_eModelUse == EUseEventModel.emModelKnockOut) //预赛,单淘汰赛
            {
                AxDrawModelStage modelStage = new AxDrawModelStage();
                modelStage.m_strStageName = m_StepKnockSingle.GetStageTitle();

                AxDrawModelModelExport modelExport = new AxDrawModelModelExport();
                modelExport.m_drawInfo.m_bBogol = false;
                modelExport.m_drawInfo.m_bQual = false;
                modelExport.m_drawInfo.m_eType = EDrawModelType.emTypeKonckOut;
                modelExport.m_drawInfo.m_nSize = m_StepKnockSingle.GetLayerCntPerGroup();
                modelExport.m_drawInfo.m_nRank = m_StepKnockSingle.GetQualCntPerGroup();
                modelExport.m_drawInfo.m_strTitle = m_StepKnockSingle.GetStageTitle();

                modelStage.m_aryModelList.Add(modelExport);
                m_ModelEvent.m_aryStageList.Add(modelStage);

                //处理最终排名
                for (int nCyc = 0; nCyc < modelExport.m_drawInfo.m_nRank; nCyc++)
                {
                    AxDrawModelPlayerFrom playerFrom = new AxDrawModelPlayerFrom();
                    playerFrom.m_byStageOrder = 0;
                    playerFrom.m_byModelOrder = 0;
                    playerFrom.m_byResultRank = (Byte)(nCyc + 1);
                    m_ModelEvent.m_aryEventRank.Add(playerFrom);
                }
            }

            //决赛, 多组To多淘
            if (m_eModelUse == EUseEventModel.emModelmGtomK)
            {
                AxDrawModelStage modelStageKnock = new AxDrawModelStage();
                modelStageKnock.m_strStageName = m_StepKnockFinal.GetStageTitle();

                //创建所有淘汰赛模型
                Int32 nModelCanUseCnt = m_StepKnockFinal.IsModelUse(3) ? 3 : (m_StepKnockFinal.IsModelUse(2) ? 2 : 1);
                for (Int32 nModel = 1; nModel <= nModelCanUseCnt; nModel++)
                {
                    AxDrawModelModelExport modelExport = new AxDrawModelModelExport();
                    modelExport.m_drawInfo.m_eType = EDrawModelType.emTypeKonckOut;
                    modelExport.m_drawInfo.m_nSize = m_StepKnockFinal.GetModelLayer(nModel);
                    modelExport.m_drawInfo.m_nRank = m_StepKnockFinal.GetModelSize(nModel);
                    modelExport.m_drawInfo.m_bBogol = false;
                    modelExport.m_drawInfo.m_strTitle = m_StepKnockFinal.GetModelTitle(nModel);

                    Int32 nRankOrder = 1;

                    //循环把晋级的人填入这个结构, 每组里的第几个人
                    for (Int32 nPlayerIndex = m_StepKnockFinal.GetModelPlayerIndexStart(nModel) - 1;
                              nPlayerIndex < m_StepKnockFinal.GetModelPlayerIndexEnd(nModel);
                              nPlayerIndex++)
                    {
                        //从预赛晋级过来了几个组
                        for (Int32 nGroup = 0; nGroup < m_StepKnockFinal.GetGroupFromCnt(); nGroup++)
                        {
                            //处理所有来源
                            AxDrawModelPlayerFrom playerFrom = new AxDrawModelPlayerFrom();
                            playerFrom.m_byStageOrder = 0;				//第1层的
                            playerFrom.m_byModelOrder = (Byte)nGroup;			//循环这一层的每个模型
                            playerFrom.m_byResultRank = (Byte)(nPlayerIndex + 1);	//在这一组的排序
                            modelExport.m_aryPlayerFrom.Add(playerFrom);

                            //处理整个赛事最后排名
                            AxDrawModelPlayerFrom rankPlayerFrom = new AxDrawModelPlayerFrom();
                            rankPlayerFrom.m_byStageOrder = 1;	//固定在第二阶段
                            rankPlayerFrom.m_byModelOrder = (Byte)(nModel - 1); //循环每个淘汰赛
                            rankPlayerFrom.m_byResultRank = (Byte)(nRankOrder++);
                            m_ModelEvent.m_aryEventRank.Add(rankPlayerFrom);
                        }
                    }

                    modelStageKnock.m_aryModelList.Add(modelExport);
                }//for nModel

                m_ModelEvent.m_aryStageList.Add(modelStageKnock);
            }
            //多组To单淘
            else if (m_eModelUse == EUseEventModel.emModelmGtoK)
            {
                AxDrawModelStage modelStageKnock = new AxDrawModelStage();
                modelStageKnock.m_strStageName = m_StepKnockSingle.GetStageTitle();

                AxDrawModelModelExport modelExport = new AxDrawModelModelExport();
                modelExport.m_drawInfo.m_eType = EDrawModelType.emTypeKonckOut;
                modelExport.m_drawInfo.m_nSize = m_StepKnockSingle.GetLayerCntPerGroup();
                modelExport.m_drawInfo.m_nRank = m_StepKnockSingle.GetQualCntPerGroup();
                modelExport.m_drawInfo.m_bBogol = false;
                modelExport.m_drawInfo.m_strTitle = m_StepKnockSingle.GetStageTitle();

                //处理所有人来源,以组为轮换顺序加入晋级名单
                for (Int32 nPlayerIdx = 0; nPlayerIdx < m_StepGroup.GetQualCntPerGroup(); nPlayerIdx++)
                {
                    for (Int32 nGroup = 0; nGroup < m_StepGroup.GetGroupCnt(); nGroup++)
                    {
                        AxDrawModelPlayerFrom playerFrom = new AxDrawModelPlayerFrom();
                        playerFrom.m_byStageOrder = 0;				        //第1层的
                        playerFrom.m_byModelOrder = (Byte)nGroup;			//循环这一层的每个模型
                        playerFrom.m_byResultRank = (Byte)(nPlayerIdx + 1);	//在这一组的排序		
                        modelExport.m_aryPlayerFrom.Add(playerFrom);
                    }
                }

                //处理最后排名输出
                for (Int32 nResultIdx = 0; nResultIdx < m_StepKnockSingle.GetQualCntPerGroup(); nResultIdx++)
                {
                    AxDrawModelPlayerFrom playerFrom = new AxDrawModelPlayerFrom();
                    playerFrom.m_byStageOrder = 1;			//第2层的
                    playerFrom.m_byModelOrder = 0;			//循环这一层的每个模型
                    playerFrom.m_byResultRank = (Byte)(nResultIdx + 1);	//在这一组的排序		
                    m_ModelEvent.m_aryEventRank.Add(playerFrom);
                }

                modelStageKnock.m_aryModelList.Add(modelExport);
                m_ModelEvent.m_aryStageList.Add(modelStageKnock);
            }
            //多淘To淘
            else if (m_eModelUse == EUseEventModel.emModelmKtoK)
            {
                AxDrawModelStage modelStageKnock = new AxDrawModelStage();
                modelStageKnock.m_strStageName = m_StepKnockSingle.GetStageTitle();

                AxDrawModelModelExport modelExport = new AxDrawModelModelExport();
                modelExport.m_drawInfo.m_eType = EDrawModelType.emTypeKonckOut;
                modelExport.m_drawInfo.m_nSize = m_StepKnockSingle.GetLayerCntPerGroup();
                modelExport.m_drawInfo.m_nRank = m_StepKnockSingle.GetQualCntPerGroup();
                modelExport.m_drawInfo.m_bBogol = false;
                modelExport.m_drawInfo.m_strTitle = m_StepKnockSingle.GetStageTitle();

                //处理所有人来源,以组为轮换顺序加入晋级名单
                for (Int32 nPlayerIdx = 0; nPlayerIdx < m_StepKnockOut.GetQualCntPerGroup(); nPlayerIdx++)
                {
                    for (Int32 nGroup = 0; nGroup < m_StepKnockOut.GetGroupCnt(); nGroup++)
                    {
                        AxDrawModelPlayerFrom playerFrom = new AxDrawModelPlayerFrom();
                        playerFrom.m_byStageOrder = 0;				        //第1层的
                        playerFrom.m_byModelOrder = (Byte)nGroup;			//循环这一层的每个模型
                        playerFrom.m_byResultRank = (Byte)(nPlayerIdx + 1);	//在这一组的排序		
                        modelExport.m_aryPlayerFrom.Add(playerFrom);
                    }
                }

                //处理最后排名输出
                for (Int32 nResultIdx = 0; nResultIdx < m_StepKnockSingle.GetQualCntPerGroup(); nResultIdx++)
                {
                    AxDrawModelPlayerFrom playerFrom = new AxDrawModelPlayerFrom();
                    playerFrom.m_byStageOrder = 1;			//第2层的
                    playerFrom.m_byModelOrder = 0;			//只有一个淘汰赛模型
                    playerFrom.m_byResultRank = (Byte)(nResultIdx + 1);	//在这一组的排序		
                    m_ModelEvent.m_aryEventRank.Add(playerFrom);
                }

                modelStageKnock.m_aryModelList.Add(modelExport);
                m_ModelEvent.m_aryStageList.Add(modelStageKnock);
            }

            return true;
        }

        private void btnPrevious_Click(object sender, EventArgs e)
        {
            if (m_eShowType == EShowType.emShowGroupM)
            {
                if (m_eModelUse == EUseEventModel.emModelGroup || m_eModelUse == EUseEventModel.emModelmGtomK || m_eModelUse == EUseEventModel.emModelmGtoK)
                {
                    m_StepGroup.Visible = false;
                    m_StepFirst.Visible = true;
                    m_eShowType = EShowType.emShowMain;
                }
            }
            else if (m_eShowType == EShowType.emShowKnockSingle)
            {
                if (m_eModelUse == EUseEventModel.emModelKnockOut)
                {
                    m_StepKnockSingle.Visible = false;
                    m_StepFirst.Visible = true;
                    m_eShowType = EShowType.emShowMain;
                }
                else if (m_eModelUse == EUseEventModel.emModelmKtoK)
                {
                    m_StepKnockSingle.Visible = false;
                    m_StepKnockOut.Visible = true;
                    m_eShowType = EShowType.emShowKnockM;
                }
                else if (m_eModelUse == EUseEventModel.emModelmGtoK)
                {
                    m_StepKnockSingle.Visible = false;
                    m_StepGroup.Visible = true;
                    m_eShowType = EShowType.emShowGroupM;
                }
            }
            else if (m_eShowType == EShowType.emShowKnockM)
            {
                if (m_eModelUse == EUseEventModel.emModelmKtoK)
                {
                    m_StepKnockOut.Visible = false;
                    m_StepFirst.Visible = true;
                    m_eShowType = EShowType.emShowMain;
                }
            }
            else if (m_eShowType == EShowType.emShowKnockMFinal)
            {
                if (m_eModelUse == EUseEventModel.emModelmGtomK)
                {
                    m_StepKnockFinal.Visible = false;
                    m_StepGroup.Visible = true;
                    m_eShowType = EShowType.emShowGroupM;
                }
            }

            UpdateUI();
        }

        private void btnNext_Click(object sender, EventArgs e)
        {
            String strMsg;

            if (m_eShowType == EShowType.emShowMain) //欢迎
            {
                m_eModelUse = (EUseEventModel)m_StepFirst.GetEventModelType();

                if (m_eModelUse == EUseEventModel.emModelKnockOut)
                {
                    strMsg = LocalizationRecourceManager.GetString(m_strSectionName, "cbTypeKnockOut");
                    m_StepKnockSingle.SetStageName(strMsg);
                    m_StepFirst.Visible = false;
                    m_StepKnockSingle.Visible = true;
                    m_eShowType = EShowType.emShowKnockSingle;
                }
                else
                    if (m_eModelUse == EUseEventModel.emModelGroup)
                    {
                        strMsg = LocalizationRecourceManager.GetString(m_strSectionName, "cbTypeRoundRobin");
                        m_StepGroup.SetStageTitle(strMsg);
                        m_StepFirst.Visible = false;
                        m_StepGroup.Visible = true;
                        m_eShowType = EShowType.emShowGroupM;
                    }
                    else
                        if (m_eModelUse == EUseEventModel.emModelmKtoK)
                        {
                            m_StepFirst.Visible = false;
                            m_StepKnockOut.Visible = true;
                            m_eShowType = EShowType.emShowKnockM;
                        }
                        else
                            if (m_eModelUse == EUseEventModel.emModelmGtoK)
                            {
                                strMsg = LocalizationRecourceManager.GetString(m_strSectionName, "KOStageQual");
                                m_StepGroup.SetStageTitle(strMsg);
                                m_StepFirst.Visible = false;
                                m_StepGroup.Visible = true;
                                m_eShowType = EShowType.emShowGroupM;
                            }
                            else
                                if (m_eModelUse == EUseEventModel.emModelmGtomK)
                                {
                                    m_StepFirst.Visible = false;
                                    m_StepGroup.Visible = true;
                                    m_eShowType = EShowType.emShowGroupM;
                                }
            }
            else if (m_eShowType == EShowType.emShowGroupM) //多组
            {
                if (m_eModelUse == EUseEventModel.emModelGroup) //小组赛
                {
                    CreateEventModel();
                    this.DialogResult = DialogResult.OK;
                    Close();
                }
                else
                    if (m_eModelUse == EUseEventModel.emModelmGtomK) //多组To多淘
                    {
                        //需要把预赛的信息传递到决赛
                        m_StepKnockFinal.SetParam(m_StepGroup.GetGroupCnt(), m_StepGroup.GetQualCntPerGroup());
                        m_StepGroup.Visible = false;
                        m_StepKnockFinal.Visible = true;
                        m_eShowType = EShowType.emShowKnockMFinal;
                    }
                    else
                        if (m_eModelUse == EUseEventModel.emModelmGtoK) //多组To单淘
                        {
                            strMsg = LocalizationRecourceManager.GetString(m_strSectionName, "tbTypeFinal");
                            m_StepKnockSingle.SetStageName(strMsg);
                            m_StepGroup.Visible = false;
                            m_StepKnockSingle.Visible = true;
                            m_StepKnockSingle.SetParam(m_StepGroup.GetQualCntPerGroup() * m_StepGroup.GetGroupCnt());
                            m_eShowType = EShowType.emShowKnockSingle;
                        }
            }
            else if (m_eShowType == EShowType.emShowKnockM) //多淘
            {
                if (m_eModelUse == EUseEventModel.emModelmKtoK) //多淘To淘
                {
                    m_StepKnockOut.Visible = false;
                    m_StepKnockSingle.Visible = true;
                    m_StepKnockSingle.SetParam(m_StepKnockOut.GetQualCntPerGroup() * m_StepKnockOut.GetGroupCnt());
                    m_eShowType = EShowType.emShowKnockSingle;
                }
            }
            else if (m_eShowType == EShowType.emShowKnockMFinal) //多淘F
            {
                if (m_eModelUse == EUseEventModel.emModelmGtomK) //多组To多淘F
                {
                    if (m_StepKnockFinal.isValued())
                    {
                        CreateEventModel();
                        this.DialogResult = DialogResult.OK;
                        Close();
                    }
                }
            }
            else if (m_eShowType == EShowType.emShowKnockSingle) //单淘
            {
                if (m_eModelUse == EUseEventModel.emModelKnockOut) //单淘
                {
                    if (m_StepKnockSingle.isValued())
                    {
                        CreateEventModel();
                        this.DialogResult = DialogResult.OK;
                        Close();
                    }
                }
                else
                    if (m_eModelUse == EUseEventModel.emModelmGtoK) //多组To单淘
                    {
                        if (m_StepKnockSingle.isValued())
                        {
                            CreateEventModel();
                            this.DialogResult = DialogResult.OK;
                            Close();
                        }
                    }
                    else if (m_eModelUse == EUseEventModel.emModelmKtoK) //多淘To单淘
                    {
                        if (m_StepKnockSingle.isValued())
                        {
                            CreateEventModel();
                            this.DialogResult = DialogResult.OK;
                            Close();
                        }
                    }
            }

            UpdateUI();
        }

        private void btnCancel_Click(object sender, EventArgs e)
        {
            this.DialogResult = DialogResult.Cancel;
            Close();
        }

        private void AxModelWizardFrameForm_Load(object sender, EventArgs e)
        {
            InitCtrlStyleContent();
            Localization();
        }
    }
}