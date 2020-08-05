using System;
using System.Collections.Generic;
using System.Text;
using System.Windows.Forms;
using System.Diagnostics;

namespace AutoSports.OVRDrawModel
{
    public class AxModelMgr
    {
        public AxModelMgr()
        {

        }

        public static AxDrawModelMatchList CreateModelSingle(ref AxDrawModelInfo retDrawInfo)
        {
            retDrawInfo.RemoveAll();

            // 1.弹出对话框设置参数
            DialogResult drResult;
            AxDrawModelEditForm fmModelEditForm = new AxDrawModelEditForm();
            fmModelEditForm.ShowDialog();
            drResult = fmModelEditForm.DialogResult;

            if (drResult != DialogResult.OK)
            {
                retDrawInfo.RemoveAll();
                retDrawInfo.m_eType = EDrawModelType.emTypeNone;
                AxDrawModelMatchList modelModel = new AxDrawModelMatchList();
                return modelModel;
            }

            // 2.根据设置的参数,开始创建

            retDrawInfo = fmModelEditForm.GetDrawInfo();
            AxDrawModelMatchList drawModel = _CreateModelSingle(retDrawInfo);
            drawModel.CreateMatchNum();

            return drawModel;
        }

	    //由外部调用,创建整个赛事模型,利用向导对话框

	    //如果返回的无数据,标识创建失败
	    public static AxDrawModelEvent CreateModelEvent()
        {       
            AxDrawModelEvent modelEvent = new AxDrawModelEvent();
            DialogResult drResult;

            AxModelWizardFrameForm fmModelEditForm = new AxModelWizardFrameForm();
            fmModelEditForm.ShowDialog();
            drResult = fmModelEditForm.DialogResult;

            if (drResult != DialogResult.OK)
            {
                return modelEvent;
            }

            modelEvent = fmModelEditForm.m_ModelEvent;

            //把所有比赛实际创建出来

            for (Int32 nStage = 0; nStage < modelEvent.GetStageCnt(); nStage++)
            {
                AxDrawModelStage pModelStage = modelEvent.GetStageObj(nStage);
                for (Int32 nModel = 0; nModel < pModelStage.GetModelCnt(); nModel++)
                {
                    AxDrawModelModelExport pModelExport = pModelStage.GetModelExpObj(nModel);
                    pModelExport.m_matchList = _CreateModelSingle(pModelExport.m_drawInfo);
                }
            }

            modelEvent.CreateMatchNum();

            return modelEvent;
        }

	    //利用DrawInfo信息,创建一个结构
	    protected static AxDrawModelMatchList _CreateModelSingle(AxDrawModelInfo DrawInfo)
        {
            AxDrawModelMatchList retModel = new AxDrawModelMatchList();

            if (DrawInfo.m_eType == EDrawModelType.emTypeManual)
            {
                return retModel;
            }
            else if (DrawInfo.m_eType == EDrawModelType.emTypeRoundRobin)
            {
                AxModelRoundRobin roundRobin = new AxModelRoundRobin();
                if (!roundRobin.Create(DrawInfo.m_nSize, DrawInfo.m_bBogol))
                {
                    retModel.RemoveAll();
                    return retModel;
                }

                if ( !roundRobin.GetModelExport(retModel) )
                {
                    retModel.RemoveAll();
                    return retModel;
                }

                return retModel;
            }
            else if (DrawInfo.m_eType == EDrawModelType.emTypeKonckOut)
            {
                AxModelKnockOut knockOut = new AxModelKnockOut();
                if (!knockOut.Create(DrawInfo.m_nSize, DrawInfo.m_nRank, false))
                {
                    retModel.RemoveAll();
                    return retModel;
                }

                if (!knockOut.GetModelExport(retModel))
                {
                    retModel.RemoveAll();
                    return retModel;
                }

                return retModel;
            }
            else
            {
                return retModel;
            }
        }
    }
}
