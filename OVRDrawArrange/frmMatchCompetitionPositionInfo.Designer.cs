using Sunny.UI;

namespace AutoSports.OVRDrawArrange
{
    partial class MatchCompetitionPositionInfo
    {
        /// <summary>
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form Designer generated code

        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            this.TextMatchName = new Sunny.UI.UITextBox();
            this.lbMatchName = new Sunny.UI.UILabel();
            this.lbLanguage = new Sunny.UI.UILabel();
            this.CmbLanguage = new Sunny.UI.UIComboBox();
            this.lbCompetitorName = new Sunny.UI.UILabel();
            this.TextPositionDes1 = new Sunny.UI.UITextBox();
            this.lbPositionDes1 = new Sunny.UI.UILabel();
            this.TextPositionDes2 = new Sunny.UI.UITextBox();
            this.lbPositionDes2 = new Sunny.UI.UILabel();
            this.RadioFromPhaseRank = new Sunny.UI.UIRadioButton();
            this.RadioFromMatchRank = new Sunny.UI.UIRadioButton();
            this.RadioFromMatchHistory = new Sunny.UI.UIRadioButton();
            this.RadioFromPhasePosition = new Sunny.UI.UIRadioButton();
            this.btnCancle = new Sunny.UI.UISymbolButton();
            this.btnOK = new Sunny.UI.UISymbolButton();
            this.lbStartPhase = new Sunny.UI.UILabel();
            this.CmbStartPhase = new Sunny.UI.UIComboBox();
            this.lblSourcePhase = new Sunny.UI.UILabel();
            this.CmbSourcePhase = new Sunny.UI.UIComboBox();
            this.lblSourcePhaseforMatch = new Sunny.UI.UILabel();
            this.CmbSourcePhaseForMatch = new Sunny.UI.UIComboBox();
            this.lbSourcePhaseforHistoryMatch = new Sunny.UI.UILabel();
            this.CmbSourcePhaseforHistoryMatch = new Sunny.UI.UIComboBox();
            this.TextPhasePosition = new Sunny.UI.UITextBox();
            this.lbPhasePosition = new Sunny.UI.UILabel();
            this.TextPhaseRank = new Sunny.UI.UITextBox();
            this.lbPhaseRank = new Sunny.UI.UILabel();
            this.lbSourceMatch = new Sunny.UI.UILabel();
            this.CmbSourceMatch = new Sunny.UI.UIComboBox();
            this.TextMatchRank = new Sunny.UI.UITextBox();
            this.TextProgress = new Sunny.UI.UITextBox();
            this.lbMatchRank = new Sunny.UI.UILabel();
            this.TextHistoryMatchRank = new Sunny.UI.UITextBox();
            this.lbHistoryMatchRank = new Sunny.UI.UILabel();
            this.lbHistoryMatch = new Sunny.UI.UILabel();
            this.CmbHistoryMatch = new Sunny.UI.UIComboBox();
            this.TextHistoryLevel = new Sunny.UI.UITextBox();
            this.lbHistoryLevel = new Sunny.UI.UILabel();
            this.TextPositionSourceDes = new Sunny.UI.UITextBox();
            this.LbPositionSourceDes = new Sunny.UI.UILabel();
            this.CmbCompetitor = new Sunny.UI.UIComboBox();
            this.btnNEXT = new Sunny.UI.UISymbolButton();
            this.btnPRE = new Sunny.UI.UISymbolButton();
            this.lbSourceProgress = new Sunny.UI.UILabel();
            this.TextSourceProgress = new Sunny.UI.UITextBox();
            this.lbProgress = new Sunny.UI.UILabel();
            this.TextMatchRank.SuspendLayout();
            this.SuspendLayout();
            // 
            // TextMatchName
            // 
            this.TextMatchName.Cursor = System.Windows.Forms.Cursors.IBeam;
            this.TextMatchName.FillColor = System.Drawing.Color.White;
            this.TextMatchName.Font = new System.Drawing.Font("Î¢ÈíÑÅºÚ", 12F);
            this.TextMatchName.Location = new System.Drawing.Point(157, 134);
            this.TextMatchName.Margin = new System.Windows.Forms.Padding(4, 5, 4, 5);
            this.TextMatchName.Maximum = 2147483647D;
            this.TextMatchName.Minimum = -2147483648D;
            this.TextMatchName.Name = "TextMatchName";
            this.TextMatchName.Padding = new System.Windows.Forms.Padding(5);
            this.TextMatchName.Size = new System.Drawing.Size(142, 29);
            this.TextMatchName.TabIndex = 45;
            // 
            // lbMatchName
            // 
            this.lbMatchName.AutoSize = true;
            this.lbMatchName.Font = new System.Drawing.Font("Î¢ÈíÑÅºÚ", 12F);
            this.lbMatchName.Location = new System.Drawing.Point(27, 75);
            this.lbMatchName.Name = "lbMatchName";
            this.lbMatchName.Size = new System.Drawing.Size(114, 21);
            this.lbMatchName.TabIndex = 44;
            this.lbMatchName.Text = "Match Name:";
            this.lbMatchName.TextAlign = System.Drawing.ContentAlignment.MiddleLeft;
            // 
            // lbLanguage
            // 
            this.lbLanguage.AutoSize = true;
            this.lbLanguage.Font = new System.Drawing.Font("Î¢ÈíÑÅºÚ", 12F);
            this.lbLanguage.Location = new System.Drawing.Point(52, 46);
            this.lbLanguage.Name = "lbLanguage";
            this.lbLanguage.Size = new System.Drawing.Size(89, 21);
            this.lbLanguage.TabIndex = 43;
            this.lbLanguage.Text = "Language:";
            this.lbLanguage.TextAlign = System.Drawing.ContentAlignment.MiddleLeft;
            // 
            // CmbLanguage
            // 
            this.CmbLanguage.DisplayMember = "Text";
            this.CmbLanguage.FillColor = System.Drawing.Color.White;
            this.CmbLanguage.Font = new System.Drawing.Font("Î¢ÈíÑÅºÚ", 12F);
            this.CmbLanguage.FormattingEnabled = true;
            this.CmbLanguage.ItemHeight = 23;
            this.CmbLanguage.Location = new System.Drawing.Point(157, 46);
            this.CmbLanguage.Margin = new System.Windows.Forms.Padding(4, 5, 4, 5);
            this.CmbLanguage.MinimumSize = new System.Drawing.Size(63, 0);
            this.CmbLanguage.Name = "CmbLanguage";
            this.CmbLanguage.Padding = new System.Windows.Forms.Padding(0, 0, 30, 0);
            this.CmbLanguage.Size = new System.Drawing.Size(142, 29);
            this.CmbLanguage.TabIndex = 42;
            this.CmbLanguage.TextAlignment = System.Drawing.ContentAlignment.MiddleLeft;
            // 
            // lbCompetitorName
            // 
            this.lbCompetitorName.Font = new System.Drawing.Font("Î¢ÈíÑÅºÚ", 12F);
            this.lbCompetitorName.Location = new System.Drawing.Point(306, 46);
            this.lbCompetitorName.Name = "lbCompetitorName";
            this.lbCompetitorName.Size = new System.Drawing.Size(169, 21);
            this.lbCompetitorName.TabIndex = 46;
            this.lbCompetitorName.Text = "Competitor Name:";
            this.lbCompetitorName.TextAlign = System.Drawing.ContentAlignment.MiddleRight;
            // 
            // TextPositionDes1
            // 
            this.TextPositionDes1.Cursor = System.Windows.Forms.Cursors.IBeam;
            this.TextPositionDes1.FillColor = System.Drawing.Color.White;
            this.TextPositionDes1.Font = new System.Drawing.Font("Î¢ÈíÑÅºÚ", 12F);
            this.TextPositionDes1.Location = new System.Drawing.Point(157, 178);
            this.TextPositionDes1.Margin = new System.Windows.Forms.Padding(4, 5, 4, 5);
            this.TextPositionDes1.Maximum = 2147483647D;
            this.TextPositionDes1.Minimum = -2147483648D;
            this.TextPositionDes1.Name = "TextPositionDes1";
            this.TextPositionDes1.Padding = new System.Windows.Forms.Padding(5);
            this.TextPositionDes1.Size = new System.Drawing.Size(142, 29);
            this.TextPositionDes1.TabIndex = 49;
            // 
            // lbPositionDes1
            // 
            this.lbPositionDes1.AutoSize = true;
            this.lbPositionDes1.Font = new System.Drawing.Font("Î¢ÈíÑÅºÚ", 12F);
            this.lbPositionDes1.Location = new System.Drawing.Point(57, 104);
            this.lbPositionDes1.Name = "lbPositionDes1";
            this.lbPositionDes1.Size = new System.Drawing.Size(84, 21);
            this.lbPositionDes1.TabIndex = 48;
            this.lbPositionDes1.Text = "Position1:";
            this.lbPositionDes1.TextAlign = System.Drawing.ContentAlignment.MiddleLeft;
            // 
            // TextPositionDes2
            // 
            this.TextPositionDes2.Cursor = System.Windows.Forms.Cursors.IBeam;
            this.TextPositionDes2.FillColor = System.Drawing.Color.White;
            this.TextPositionDes2.Font = new System.Drawing.Font("Î¢ÈíÑÅºÚ", 12F);
            this.TextPositionDes2.Location = new System.Drawing.Point(157, 222);
            this.TextPositionDes2.Margin = new System.Windows.Forms.Padding(4, 5, 4, 5);
            this.TextPositionDes2.Maximum = 2147483647D;
            this.TextPositionDes2.Minimum = -2147483648D;
            this.TextPositionDes2.Name = "TextPositionDes2";
            this.TextPositionDes2.Padding = new System.Windows.Forms.Padding(5);
            this.TextPositionDes2.Size = new System.Drawing.Size(142, 29);
            this.TextPositionDes2.TabIndex = 51;
            // 
            // lbPositionDes2
            // 
            this.lbPositionDes2.AutoSize = true;
            this.lbPositionDes2.Font = new System.Drawing.Font("Î¢ÈíÑÅºÚ", 12F);
            this.lbPositionDes2.Location = new System.Drawing.Point(57, 133);
            this.lbPositionDes2.Name = "lbPositionDes2";
            this.lbPositionDes2.Size = new System.Drawing.Size(84, 21);
            this.lbPositionDes2.TabIndex = 50;
            this.lbPositionDes2.Text = "Position2:";
            this.lbPositionDes2.TextAlign = System.Drawing.ContentAlignment.MiddleLeft;
            // 
            // RadioFromPhaseRank
            // 
            this.RadioFromPhaseRank.Cursor = System.Windows.Forms.Cursors.Hand;
            this.RadioFromPhaseRank.Font = new System.Drawing.Font("Î¢ÈíÑÅºÚ", 12F);
            this.RadioFromPhaseRank.Location = new System.Drawing.Point(27, 191);
            this.RadioFromPhaseRank.Name = "RadioFromPhaseRank";
            this.RadioFromPhaseRank.Padding = new System.Windows.Forms.Padding(22, 0, 0, 0);
            this.RadioFromPhaseRank.Size = new System.Drawing.Size(114, 21);
            this.RadioFromPhaseRank.TabIndex = 52;
            this.RadioFromPhaseRank.Text = "From Phase Rank";
            this.RadioFromPhaseRank.Click += new System.EventHandler(this.RadioFromPhaseRank_CheckedChanged);
            // 
            // RadioFromMatchRank
            // 
            this.RadioFromMatchRank.Cursor = System.Windows.Forms.Cursors.Hand;
            this.RadioFromMatchRank.Font = new System.Drawing.Font("Î¢ÈíÑÅºÚ", 12F);
            this.RadioFromMatchRank.Location = new System.Drawing.Point(27, 307);
            this.RadioFromMatchRank.Name = "RadioFromMatchRank";
            this.RadioFromMatchRank.Padding = new System.Windows.Forms.Padding(22, 0, 0, 0);
            this.RadioFromMatchRank.Size = new System.Drawing.Size(114, 21);
            this.RadioFromMatchRank.TabIndex = 53;
            this.RadioFromMatchRank.Text = "From Match Rank";
            this.RadioFromMatchRank.Click += new System.EventHandler(this.RadioFromMatchRank_CheckedChanged);
            // 
            // RadioFromMatchHistory
            // 
            this.RadioFromMatchHistory.Cursor = System.Windows.Forms.Cursors.Hand;
            this.RadioFromMatchHistory.Font = new System.Drawing.Font("Î¢ÈíÑÅºÚ", 12F);
            this.RadioFromMatchHistory.Location = new System.Drawing.Point(27, 365);
            this.RadioFromMatchHistory.Name = "RadioFromMatchHistory";
            this.RadioFromMatchHistory.Padding = new System.Windows.Forms.Padding(22, 0, 0, 0);
            this.RadioFromMatchHistory.Size = new System.Drawing.Size(114, 21);
            this.RadioFromMatchHistory.TabIndex = 54;
            this.RadioFromMatchHistory.Text = "From Match History";
            this.RadioFromMatchHistory.Click += new System.EventHandler(this.RadioFromMatchHistory_CheckedChanged);
            // 
            // RadioFromPhasePosition
            // 
            this.RadioFromPhasePosition.Cursor = System.Windows.Forms.Cursors.Hand;
            this.RadioFromPhasePosition.Font = new System.Drawing.Font("Î¢ÈíÑÅºÚ", 12F);
            this.RadioFromPhasePosition.Location = new System.Drawing.Point(27, 249);
            this.RadioFromPhasePosition.Name = "RadioFromPhasePosition";
            this.RadioFromPhasePosition.Padding = new System.Windows.Forms.Padding(22, 0, 0, 0);
            this.RadioFromPhasePosition.Size = new System.Drawing.Size(114, 21);
            this.RadioFromPhasePosition.TabIndex = 55;
            this.RadioFromPhasePosition.Text = "From Phase Position";
            this.RadioFromPhasePosition.Click += new System.EventHandler(this.RadioFromPhasePosition_CheckedChanged);
            // 
            // btnCancle
            // 
            this.btnCancle.AccessibleRole = System.Windows.Forms.AccessibleRole.PushButton;
            this.btnCancle.Cursor = System.Windows.Forms.Cursors.Hand;
            this.btnCancle.Font = new System.Drawing.Font("Î¢ÈíÑÅºÚ", 12F);
            this.btnCancle.Location = new System.Drawing.Point(425, 465);
            this.btnCancle.Name = "btnCancle";
            this.btnCancle.Padding = new System.Windows.Forms.Padding(28, 0, 0, 0);
            this.btnCancle.Size = new System.Drawing.Size(50, 30);
            this.btnCancle.Symbol = 61453;
            this.btnCancle.TabIndex = 57;
            this.btnCancle.Click += new System.EventHandler(this.btnCancle_Click);
            // 
            // btnOK
            // 
            this.btnOK.AccessibleRole = System.Windows.Forms.AccessibleRole.PushButton;
            this.btnOK.Cursor = System.Windows.Forms.Cursors.Hand;
            this.btnOK.Font = new System.Drawing.Font("Î¢ÈíÑÅºÚ", 12F);
            this.btnOK.Location = new System.Drawing.Point(359, 465);
            this.btnOK.Name = "btnOK";
            this.btnOK.Padding = new System.Windows.Forms.Padding(28, 0, 0, 0);
            this.btnOK.Size = new System.Drawing.Size(50, 30);
            this.btnOK.TabIndex = 56;
            this.btnOK.Click += new System.EventHandler(this.btnOK_Click);
            // 
            // lbStartPhase
            // 
            this.lbStartPhase.AutoSize = true;
            this.lbStartPhase.Font = new System.Drawing.Font("Î¢ÈíÑÅºÚ", 12F);
            this.lbStartPhase.Location = new System.Drawing.Point(82, 162);
            this.lbStartPhase.Name = "lbStartPhase";
            this.lbStartPhase.Size = new System.Drawing.Size(59, 21);
            this.lbStartPhase.TabIndex = 59;
            this.lbStartPhase.Text = "Phase:";
            this.lbStartPhase.TextAlign = System.Drawing.ContentAlignment.MiddleLeft;
            // 
            // CmbStartPhase
            // 
            this.CmbStartPhase.DisplayMember = "Text";
            this.CmbStartPhase.FillColor = System.Drawing.Color.White;
            this.CmbStartPhase.Font = new System.Drawing.Font("Î¢ÈíÑÅºÚ", 12F);
            this.CmbStartPhase.FormattingEnabled = true;
            this.CmbStartPhase.ItemHeight = 23;
            this.CmbStartPhase.Location = new System.Drawing.Point(157, 266);
            this.CmbStartPhase.Margin = new System.Windows.Forms.Padding(4, 5, 4, 5);
            this.CmbStartPhase.MinimumSize = new System.Drawing.Size(63, 0);
            this.CmbStartPhase.Name = "CmbStartPhase";
            this.CmbStartPhase.Padding = new System.Windows.Forms.Padding(0, 0, 30, 0);
            this.CmbStartPhase.Size = new System.Drawing.Size(142, 29);
            this.CmbStartPhase.TabIndex = 58;
            this.CmbStartPhase.TextAlignment = System.Drawing.ContentAlignment.MiddleLeft;
            // 
            // lblSourcePhase
            // 
            this.lblSourcePhase.AutoSize = true;
            this.lblSourcePhase.Font = new System.Drawing.Font("Î¢ÈíÑÅºÚ", 12F);
            this.lblSourcePhase.Location = new System.Drawing.Point(82, 220);
            this.lblSourcePhase.Name = "lblSourcePhase";
            this.lblSourcePhase.Size = new System.Drawing.Size(59, 21);
            this.lblSourcePhase.TabIndex = 61;
            this.lblSourcePhase.Text = "Phase:";
            this.lblSourcePhase.TextAlign = System.Drawing.ContentAlignment.MiddleLeft;
            // 
            // CmbSourcePhase
            // 
            this.CmbSourcePhase.DisplayMember = "Text";
            this.CmbSourcePhase.FillColor = System.Drawing.Color.White;
            this.CmbSourcePhase.Font = new System.Drawing.Font("Î¢ÈíÑÅºÚ", 12F);
            this.CmbSourcePhase.FormattingEnabled = true;
            this.CmbSourcePhase.ItemHeight = 23;
            this.CmbSourcePhase.Location = new System.Drawing.Point(157, 310);
            this.CmbSourcePhase.Margin = new System.Windows.Forms.Padding(4, 5, 4, 5);
            this.CmbSourcePhase.MinimumSize = new System.Drawing.Size(63, 0);
            this.CmbSourcePhase.Name = "CmbSourcePhase";
            this.CmbSourcePhase.Padding = new System.Windows.Forms.Padding(0, 0, 30, 0);
            this.CmbSourcePhase.Size = new System.Drawing.Size(142, 29);
            this.CmbSourcePhase.TabIndex = 60;
            this.CmbSourcePhase.TextAlignment = System.Drawing.ContentAlignment.MiddleLeft;
            // 
            // lblSourcePhaseforMatch
            // 
            this.lblSourcePhaseforMatch.AutoSize = true;
            this.lblSourcePhaseforMatch.Font = new System.Drawing.Font("Î¢ÈíÑÅºÚ", 12F);
            this.lblSourcePhaseforMatch.Location = new System.Drawing.Point(82, 278);
            this.lblSourcePhaseforMatch.Name = "lblSourcePhaseforMatch";
            this.lblSourcePhaseforMatch.Size = new System.Drawing.Size(59, 21);
            this.lblSourcePhaseforMatch.TabIndex = 63;
            this.lblSourcePhaseforMatch.Text = "Phase:";
            this.lblSourcePhaseforMatch.TextAlign = System.Drawing.ContentAlignment.MiddleLeft;
            // 
            // CmbSourcePhaseForMatch
            // 
            this.CmbSourcePhaseForMatch.DisplayMember = "Text";
            this.CmbSourcePhaseForMatch.FillColor = System.Drawing.Color.White;
            this.CmbSourcePhaseForMatch.Font = new System.Drawing.Font("Î¢ÈíÑÅºÚ", 12F);
            this.CmbSourcePhaseForMatch.FormattingEnabled = true;
            this.CmbSourcePhaseForMatch.ItemHeight = 23;
            this.CmbSourcePhaseForMatch.Location = new System.Drawing.Point(157, 354);
            this.CmbSourcePhaseForMatch.Margin = new System.Windows.Forms.Padding(4, 5, 4, 5);
            this.CmbSourcePhaseForMatch.MinimumSize = new System.Drawing.Size(63, 0);
            this.CmbSourcePhaseForMatch.Name = "CmbSourcePhaseForMatch";
            this.CmbSourcePhaseForMatch.Padding = new System.Windows.Forms.Padding(0, 0, 30, 0);
            this.CmbSourcePhaseForMatch.Size = new System.Drawing.Size(142, 29);
            this.CmbSourcePhaseForMatch.TabIndex = 62;
            this.CmbSourcePhaseForMatch.TextAlignment = System.Drawing.ContentAlignment.MiddleLeft;
            this.CmbSourcePhaseForMatch.SelectedIndexChanged += new System.EventHandler(this.CmbSourcePhaseForMatch_SelectedIndexChanged);
            // 
            // lbSourcePhaseforHistoryMatch
            // 
            this.lbSourcePhaseforHistoryMatch.AutoSize = true;
            this.lbSourcePhaseforHistoryMatch.Font = new System.Drawing.Font("Î¢ÈíÑÅºÚ", 12F);
            this.lbSourcePhaseforHistoryMatch.Location = new System.Drawing.Point(82, 336);
            this.lbSourcePhaseforHistoryMatch.Name = "lbSourcePhaseforHistoryMatch";
            this.lbSourcePhaseforHistoryMatch.Size = new System.Drawing.Size(59, 21);
            this.lbSourcePhaseforHistoryMatch.TabIndex = 65;
            this.lbSourcePhaseforHistoryMatch.Text = "Phase:";
            this.lbSourcePhaseforHistoryMatch.TextAlign = System.Drawing.ContentAlignment.MiddleLeft;
            // 
            // CmbSourcePhaseforHistoryMatch
            // 
            this.CmbSourcePhaseforHistoryMatch.DisplayMember = "Text";
            this.CmbSourcePhaseforHistoryMatch.FillColor = System.Drawing.Color.White;
            this.CmbSourcePhaseforHistoryMatch.Font = new System.Drawing.Font("Î¢ÈíÑÅºÚ", 12F);
            this.CmbSourcePhaseforHistoryMatch.FormattingEnabled = true;
            this.CmbSourcePhaseforHistoryMatch.ItemHeight = 23;
            this.CmbSourcePhaseforHistoryMatch.Location = new System.Drawing.Point(157, 398);
            this.CmbSourcePhaseforHistoryMatch.Margin = new System.Windows.Forms.Padding(4, 5, 4, 5);
            this.CmbSourcePhaseforHistoryMatch.MinimumSize = new System.Drawing.Size(63, 0);
            this.CmbSourcePhaseforHistoryMatch.Name = "CmbSourcePhaseforHistoryMatch";
            this.CmbSourcePhaseforHistoryMatch.Padding = new System.Windows.Forms.Padding(0, 0, 30, 0);
            this.CmbSourcePhaseforHistoryMatch.Size = new System.Drawing.Size(142, 29);
            this.CmbSourcePhaseforHistoryMatch.TabIndex = 64;
            this.CmbSourcePhaseforHistoryMatch.TextAlignment = System.Drawing.ContentAlignment.MiddleLeft;
            this.CmbSourcePhaseforHistoryMatch.SelectedIndexChanged += new System.EventHandler(this.CmbSourcePhaseforHistoryMatch_SelectedIndexChanged);
            // 
            // TextPhasePosition
            // 
            this.TextPhasePosition.Cursor = System.Windows.Forms.Cursors.IBeam;
            this.TextPhasePosition.FillColor = System.Drawing.Color.White;
            this.TextPhasePosition.Font = new System.Drawing.Font("Î¢ÈíÑÅºÚ", 12F);
            this.TextPhasePosition.Location = new System.Drawing.Point(482, 202);
            this.TextPhasePosition.Margin = new System.Windows.Forms.Padding(4, 5, 4, 5);
            this.TextPhasePosition.Maximum = 2147483647D;
            this.TextPhasePosition.Minimum = -2147483648D;
            this.TextPhasePosition.Name = "TextPhasePosition";
            this.TextPhasePosition.Padding = new System.Windows.Forms.Padding(5);
            this.TextPhasePosition.Size = new System.Drawing.Size(162, 29);
            this.TextPhasePosition.TabIndex = 67;
            // 
            // lbPhasePosition
            // 
            this.lbPhasePosition.Font = new System.Drawing.Font("Î¢ÈíÑÅºÚ", 12F);
            this.lbPhasePosition.Location = new System.Drawing.Point(306, 206);
            this.lbPhasePosition.Name = "lbPhasePosition";
            this.lbPhasePosition.Size = new System.Drawing.Size(169, 21);
            this.lbPhasePosition.TabIndex = 66;
            this.lbPhasePosition.Text = "Position:";
            this.lbPhasePosition.TextAlign = System.Drawing.ContentAlignment.MiddleRight;
            // 
            // TextPhaseRank
            // 
            this.TextPhaseRank.Cursor = System.Windows.Forms.Cursors.IBeam;
            this.TextPhaseRank.FillColor = System.Drawing.Color.White;
            this.TextPhaseRank.Font = new System.Drawing.Font("Î¢ÈíÑÅºÚ", 12F);
            this.TextPhaseRank.Location = new System.Drawing.Point(482, 242);
            this.TextPhaseRank.Margin = new System.Windows.Forms.Padding(4, 5, 4, 5);
            this.TextPhaseRank.Maximum = 2147483647D;
            this.TextPhaseRank.Minimum = -2147483648D;
            this.TextPhaseRank.Name = "TextPhaseRank";
            this.TextPhaseRank.Padding = new System.Windows.Forms.Padding(5);
            this.TextPhaseRank.Size = new System.Drawing.Size(162, 29);
            this.TextPhaseRank.TabIndex = 69;
            // 
            // lbPhaseRank
            // 
            this.lbPhaseRank.Font = new System.Drawing.Font("Î¢ÈíÑÅºÚ", 12F);
            this.lbPhaseRank.Location = new System.Drawing.Point(306, 246);
            this.lbPhaseRank.Name = "lbPhaseRank";
            this.lbPhaseRank.Size = new System.Drawing.Size(169, 21);
            this.lbPhaseRank.TabIndex = 68;
            this.lbPhaseRank.Text = "Rank:";
            this.lbPhaseRank.TextAlign = System.Drawing.ContentAlignment.MiddleRight;
            // 
            // lbSourceMatch
            // 
            this.lbSourceMatch.Font = new System.Drawing.Font("Î¢ÈíÑÅºÚ", 12F);
            this.lbSourceMatch.Location = new System.Drawing.Point(306, 286);
            this.lbSourceMatch.Name = "lbSourceMatch";
            this.lbSourceMatch.Size = new System.Drawing.Size(169, 21);
            this.lbSourceMatch.TabIndex = 71;
            this.lbSourceMatch.Text = "Match:";
            this.lbSourceMatch.TextAlign = System.Drawing.ContentAlignment.MiddleRight;
            // 
            // CmbSourceMatch
            // 
            this.CmbSourceMatch.DisplayMember = "Text";
            this.CmbSourceMatch.FillColor = System.Drawing.Color.White;
            this.CmbSourceMatch.Font = new System.Drawing.Font("Î¢ÈíÑÅºÚ", 12F);
            this.CmbSourceMatch.FormattingEnabled = true;
            this.CmbSourceMatch.ItemHeight = 23;
            this.CmbSourceMatch.Location = new System.Drawing.Point(482, 282);
            this.CmbSourceMatch.Margin = new System.Windows.Forms.Padding(4, 5, 4, 5);
            this.CmbSourceMatch.MinimumSize = new System.Drawing.Size(63, 0);
            this.CmbSourceMatch.Name = "CmbSourceMatch";
            this.CmbSourceMatch.Padding = new System.Windows.Forms.Padding(0, 0, 30, 0);
            this.CmbSourceMatch.Size = new System.Drawing.Size(162, 29);
            this.CmbSourceMatch.TabIndex = 70;
            this.CmbSourceMatch.TextAlignment = System.Drawing.ContentAlignment.MiddleLeft;
            // 
            // TextMatchRank
            // 
            this.TextMatchRank.Controls.Add(this.TextProgress);
            this.TextMatchRank.Cursor = System.Windows.Forms.Cursors.IBeam;
            this.TextMatchRank.FillColor = System.Drawing.Color.White;
            this.TextMatchRank.Font = new System.Drawing.Font("Î¢ÈíÑÅºÚ", 12F);
            this.TextMatchRank.Location = new System.Drawing.Point(157, 90);
            this.TextMatchRank.Margin = new System.Windows.Forms.Padding(4, 5, 4, 5);
            this.TextMatchRank.Maximum = 2147483647D;
            this.TextMatchRank.Minimum = -2147483648D;
            this.TextMatchRank.Name = "TextMatchRank";
            this.TextMatchRank.Padding = new System.Windows.Forms.Padding(5);
            this.TextMatchRank.Size = new System.Drawing.Size(142, 29);
            this.TextMatchRank.TabIndex = 73;
            // 
            // TextProgress
            // 
            this.TextProgress.Cursor = System.Windows.Forms.Cursors.IBeam;
            this.TextProgress.FillColor = System.Drawing.Color.White;
            this.TextProgress.Font = new System.Drawing.Font("Î¢ÈíÑÅºÚ", 12F);
            this.TextProgress.Location = new System.Drawing.Point(30, 0);
            this.TextProgress.Margin = new System.Windows.Forms.Padding(4, 5, 4, 5);
            this.TextProgress.Maximum = 2147483647D;
            this.TextProgress.Minimum = -2147483648D;
            this.TextProgress.Name = "TextProgress";
            this.TextProgress.Padding = new System.Windows.Forms.Padding(5);
            this.TextProgress.Size = new System.Drawing.Size(199, 29);
            this.TextProgress.TabIndex = 51;
            // 
            // lbMatchRank
            // 
            this.lbMatchRank.Font = new System.Drawing.Font("Î¢ÈíÑÅºÚ", 12F);
            this.lbMatchRank.Location = new System.Drawing.Point(27, 394);
            this.lbMatchRank.Name = "lbMatchRank";
            this.lbMatchRank.Size = new System.Drawing.Size(114, 21);
            this.lbMatchRank.TabIndex = 72;
            this.lbMatchRank.Text = "Rank:";
            this.lbMatchRank.TextAlign = System.Drawing.ContentAlignment.MiddleLeft;
            // 
            // TextHistoryMatchRank
            // 
            this.TextHistoryMatchRank.Cursor = System.Windows.Forms.Cursors.IBeam;
            this.TextHistoryMatchRank.FillColor = System.Drawing.Color.White;
            this.TextHistoryMatchRank.Font = new System.Drawing.Font("Î¢ÈíÑÅºÚ", 12F);
            this.TextHistoryMatchRank.Location = new System.Drawing.Point(482, 362);
            this.TextHistoryMatchRank.Margin = new System.Windows.Forms.Padding(4, 5, 4, 5);
            this.TextHistoryMatchRank.Maximum = 2147483647D;
            this.TextHistoryMatchRank.Minimum = -2147483648D;
            this.TextHistoryMatchRank.Name = "TextHistoryMatchRank";
            this.TextHistoryMatchRank.Padding = new System.Windows.Forms.Padding(5);
            this.TextHistoryMatchRank.Size = new System.Drawing.Size(162, 29);
            this.TextHistoryMatchRank.TabIndex = 77;
            // 
            // lbHistoryMatchRank
            // 
            this.lbHistoryMatchRank.Font = new System.Drawing.Font("Î¢ÈíÑÅºÚ", 12F);
            this.lbHistoryMatchRank.Location = new System.Drawing.Point(306, 366);
            this.lbHistoryMatchRank.Name = "lbHistoryMatchRank";
            this.lbHistoryMatchRank.Size = new System.Drawing.Size(169, 21);
            this.lbHistoryMatchRank.TabIndex = 76;
            this.lbHistoryMatchRank.Text = "Rank:";
            this.lbHistoryMatchRank.TextAlign = System.Drawing.ContentAlignment.MiddleRight;
            // 
            // lbHistoryMatch
            // 
            this.lbHistoryMatch.Font = new System.Drawing.Font("Î¢ÈíÑÅºÚ", 12F);
            this.lbHistoryMatch.Location = new System.Drawing.Point(306, 326);
            this.lbHistoryMatch.Name = "lbHistoryMatch";
            this.lbHistoryMatch.Size = new System.Drawing.Size(169, 21);
            this.lbHistoryMatch.TabIndex = 75;
            this.lbHistoryMatch.Text = "Match:";
            this.lbHistoryMatch.TextAlign = System.Drawing.ContentAlignment.MiddleRight;
            // 
            // CmbHistoryMatch
            // 
            this.CmbHistoryMatch.DisplayMember = "Text";
            this.CmbHistoryMatch.FillColor = System.Drawing.Color.White;
            this.CmbHistoryMatch.Font = new System.Drawing.Font("Î¢ÈíÑÅºÚ", 12F);
            this.CmbHistoryMatch.FormattingEnabled = true;
            this.CmbHistoryMatch.ItemHeight = 23;
            this.CmbHistoryMatch.Location = new System.Drawing.Point(482, 322);
            this.CmbHistoryMatch.Margin = new System.Windows.Forms.Padding(4, 5, 4, 5);
            this.CmbHistoryMatch.MinimumSize = new System.Drawing.Size(63, 0);
            this.CmbHistoryMatch.Name = "CmbHistoryMatch";
            this.CmbHistoryMatch.Padding = new System.Windows.Forms.Padding(0, 0, 30, 0);
            this.CmbHistoryMatch.Size = new System.Drawing.Size(162, 29);
            this.CmbHistoryMatch.TabIndex = 74;
            this.CmbHistoryMatch.TextAlignment = System.Drawing.ContentAlignment.MiddleLeft;
            // 
            // TextHistoryLevel
            // 
            this.TextHistoryLevel.Cursor = System.Windows.Forms.Cursors.IBeam;
            this.TextHistoryLevel.FillColor = System.Drawing.Color.White;
            this.TextHistoryLevel.Font = new System.Drawing.Font("Î¢ÈíÑÅºÚ", 12F);
            this.TextHistoryLevel.Location = new System.Drawing.Point(482, 402);
            this.TextHistoryLevel.Margin = new System.Windows.Forms.Padding(4, 5, 4, 5);
            this.TextHistoryLevel.Maximum = 2147483647D;
            this.TextHistoryLevel.Minimum = -2147483648D;
            this.TextHistoryLevel.Name = "TextHistoryLevel";
            this.TextHistoryLevel.Padding = new System.Windows.Forms.Padding(5);
            this.TextHistoryLevel.Size = new System.Drawing.Size(162, 29);
            this.TextHistoryLevel.TabIndex = 79;
            // 
            // lbHistoryLevel
            // 
            this.lbHistoryLevel.Font = new System.Drawing.Font("Î¢ÈíÑÅºÚ", 12F);
            this.lbHistoryLevel.Location = new System.Drawing.Point(306, 406);
            this.lbHistoryLevel.Name = "lbHistoryLevel";
            this.lbHistoryLevel.Size = new System.Drawing.Size(169, 21);
            this.lbHistoryLevel.TabIndex = 78;
            this.lbHistoryLevel.Text = "History Level:";
            this.lbHistoryLevel.TextAlign = System.Drawing.ContentAlignment.MiddleRight;
            // 
            // TextPositionSourceDes
            // 
            this.TextPositionSourceDes.Cursor = System.Windows.Forms.Cursors.IBeam;
            this.TextPositionSourceDes.FillColor = System.Drawing.Color.White;
            this.TextPositionSourceDes.Font = new System.Drawing.Font("Î¢ÈíÑÅºÚ", 12F);
            this.TextPositionSourceDes.Location = new System.Drawing.Point(482, 82);
            this.TextPositionSourceDes.Margin = new System.Windows.Forms.Padding(4, 5, 4, 5);
            this.TextPositionSourceDes.Maximum = 2147483647D;
            this.TextPositionSourceDes.Minimum = -2147483648D;
            this.TextPositionSourceDes.Multiline = true;
            this.TextPositionSourceDes.Name = "TextPositionSourceDes";
            this.TextPositionSourceDes.Padding = new System.Windows.Forms.Padding(5);
            this.TextPositionSourceDes.Size = new System.Drawing.Size(162, 69);
            this.TextPositionSourceDes.TabIndex = 81;
            // 
            // LbPositionSourceDes
            // 
            this.LbPositionSourceDes.Font = new System.Drawing.Font("Î¢ÈíÑÅºÚ", 12F);
            this.LbPositionSourceDes.Location = new System.Drawing.Point(306, 126);
            this.LbPositionSourceDes.Name = "LbPositionSourceDes";
            this.LbPositionSourceDes.Size = new System.Drawing.Size(169, 21);
            this.LbPositionSourceDes.TabIndex = 80;
            this.LbPositionSourceDes.Text = "Position Source Description:";
            this.LbPositionSourceDes.TextAlign = System.Drawing.ContentAlignment.MiddleRight;
            // 
            // CmbCompetitor
            // 
            this.CmbCompetitor.DisplayMember = "Text";
            this.CmbCompetitor.FillColor = System.Drawing.Color.White;
            this.CmbCompetitor.Font = new System.Drawing.Font("Î¢ÈíÑÅºÚ", 12F);
            this.CmbCompetitor.FormattingEnabled = true;
            this.CmbCompetitor.ItemHeight = 23;
            this.CmbCompetitor.Location = new System.Drawing.Point(482, 42);
            this.CmbCompetitor.Margin = new System.Windows.Forms.Padding(4, 5, 4, 5);
            this.CmbCompetitor.MinimumSize = new System.Drawing.Size(63, 0);
            this.CmbCompetitor.Name = "CmbCompetitor";
            this.CmbCompetitor.Padding = new System.Windows.Forms.Padding(0, 0, 30, 0);
            this.CmbCompetitor.Size = new System.Drawing.Size(162, 29);
            this.CmbCompetitor.TabIndex = 82;
            this.CmbCompetitor.TextAlignment = System.Drawing.ContentAlignment.MiddleLeft;
            // 
            // btnNEXT
            // 
            this.btnNEXT.AccessibleRole = System.Windows.Forms.AccessibleRole.PushButton;
            this.btnNEXT.Cursor = System.Windows.Forms.Cursors.Hand;
            this.btnNEXT.Font = new System.Drawing.Font("Î¢ÈíÑÅºÚ", 12F);
            this.btnNEXT.Location = new System.Drawing.Point(269, 465);
            this.btnNEXT.Name = "btnNEXT";
            this.btnNEXT.Padding = new System.Windows.Forms.Padding(28, 0, 0, 0);
            this.btnNEXT.Size = new System.Drawing.Size(50, 30);
            this.btnNEXT.Symbol = 61778;
            this.btnNEXT.TabIndex = 83;
            this.btnNEXT.Click += new System.EventHandler(this.btnNEXT_Click);
            // 
            // btnPRE
            // 
            this.btnPRE.AccessibleRole = System.Windows.Forms.AccessibleRole.PushButton;
            this.btnPRE.Cursor = System.Windows.Forms.Cursors.Hand;
            this.btnPRE.Font = new System.Drawing.Font("Î¢ÈíÑÅºÚ", 12F);
            this.btnPRE.Location = new System.Drawing.Point(203, 465);
            this.btnPRE.Name = "btnPRE";
            this.btnPRE.Padding = new System.Windows.Forms.Padding(28, 0, 0, 0);
            this.btnPRE.Size = new System.Drawing.Size(50, 30);
            this.btnPRE.Symbol = 61841;
            this.btnPRE.TabIndex = 83;
            this.btnPRE.Click += new System.EventHandler(this.btnPRE_Click);
            // 
            // lbSourceProgress
            // 
            this.lbSourceProgress.AutoSize = true;
            this.lbSourceProgress.Font = new System.Drawing.Font("Î¢ÈíÑÅºÚ", 12F);
            this.lbSourceProgress.Location = new System.Drawing.Point(306, 166);
            this.lbSourceProgress.Name = "lbSourceProgress";
            this.lbSourceProgress.Size = new System.Drawing.Size(169, 21);
            this.lbSourceProgress.TabIndex = 50;
            this.lbSourceProgress.Text = "Source Progress Des:";
            this.lbSourceProgress.TextAlign = System.Drawing.ContentAlignment.MiddleRight;
            // 
            // TextSourceProgress
            // 
            this.TextSourceProgress.Cursor = System.Windows.Forms.Cursors.IBeam;
            this.TextSourceProgress.FillColor = System.Drawing.Color.White;
            this.TextSourceProgress.Font = new System.Drawing.Font("Î¢ÈíÑÅºÚ", 12F);
            this.TextSourceProgress.Location = new System.Drawing.Point(482, 162);
            this.TextSourceProgress.Margin = new System.Windows.Forms.Padding(4, 5, 4, 5);
            this.TextSourceProgress.Maximum = 2147483647D;
            this.TextSourceProgress.Minimum = -2147483648D;
            this.TextSourceProgress.Name = "TextSourceProgress";
            this.TextSourceProgress.Padding = new System.Windows.Forms.Padding(5);
            this.TextSourceProgress.Size = new System.Drawing.Size(162, 29);
            this.TextSourceProgress.TabIndex = 51;
            // 
            // lbProgress
            // 
            this.lbProgress.AutoSize = true;
            this.lbProgress.Font = new System.Drawing.Font("Î¢ÈíÑÅºÚ", 12F);
            this.lbProgress.Location = new System.Drawing.Point(363, 86);
            this.lbProgress.Name = "lbProgress";
            this.lbProgress.Size = new System.Drawing.Size(112, 21);
            this.lbProgress.TabIndex = 50;
            this.lbProgress.Text = "Progress Des:";
            this.lbProgress.TextAlign = System.Drawing.ContentAlignment.MiddleRight;
            // 
            // MatchCompetitionPositionInfo
            // 
            this.ClientSize = new System.Drawing.Size(659, 510);
            this.Controls.Add(this.btnPRE);
            this.Controls.Add(this.btnNEXT);
            this.Controls.Add(this.CmbCompetitor);
            this.Controls.Add(this.TextPositionSourceDes);
            this.Controls.Add(this.LbPositionSourceDes);
            this.Controls.Add(this.TextHistoryLevel);
            this.Controls.Add(this.lbHistoryLevel);
            this.Controls.Add(this.TextHistoryMatchRank);
            this.Controls.Add(this.lbHistoryMatchRank);
            this.Controls.Add(this.lbHistoryMatch);
            this.Controls.Add(this.CmbHistoryMatch);
            this.Controls.Add(this.TextMatchRank);
            this.Controls.Add(this.lbMatchRank);
            this.Controls.Add(this.lbSourceMatch);
            this.Controls.Add(this.CmbSourceMatch);
            this.Controls.Add(this.TextPhaseRank);
            this.Controls.Add(this.lbPhaseRank);
            this.Controls.Add(this.TextPhasePosition);
            this.Controls.Add(this.lbPhasePosition);
            this.Controls.Add(this.lbSourcePhaseforHistoryMatch);
            this.Controls.Add(this.CmbSourcePhaseforHistoryMatch);
            this.Controls.Add(this.lblSourcePhaseforMatch);
            this.Controls.Add(this.CmbSourcePhaseForMatch);
            this.Controls.Add(this.lblSourcePhase);
            this.Controls.Add(this.CmbSourcePhase);
            this.Controls.Add(this.lbStartPhase);
            this.Controls.Add(this.CmbStartPhase);
            this.Controls.Add(this.btnCancle);
            this.Controls.Add(this.btnOK);
            this.Controls.Add(this.RadioFromPhasePosition);
            this.Controls.Add(this.RadioFromMatchHistory);
            this.Controls.Add(this.RadioFromMatchRank);
            this.Controls.Add(this.RadioFromPhaseRank);
            this.Controls.Add(this.TextSourceProgress);
            this.Controls.Add(this.lbProgress);
            this.Controls.Add(this.lbSourceProgress);
            this.Controls.Add(this.TextPositionDes2);
            this.Controls.Add(this.lbPositionDes2);
            this.Controls.Add(this.TextPositionDes1);
            this.Controls.Add(this.lbPositionDes1);
            this.Controls.Add(this.lbCompetitorName);
            this.Controls.Add(this.TextMatchName);
            this.Controls.Add(this.lbMatchName);
            this.Controls.Add(this.lbLanguage);
            this.Controls.Add(this.CmbLanguage);
            this.KeyPreview = true;
            this.MaximizeBox = false;
            this.MinimizeBox = false;
            this.Name = "MatchCompetitionPositionInfo";
            this.ShowIcon = false;
            this.ShowInTaskbar = false;
            this.Text = "Match CompetitionPosition";
            this.FormClosed += new System.Windows.Forms.FormClosedEventHandler(this.MatchCompetitionPositionInfo_FormClosed);
            this.Load += new System.EventHandler(this.MatchCompetitionPositionInfo_Load);
            this.KeyDown += new System.Windows.Forms.KeyEventHandler(this.MatchCompetitionPositionInfo_KeyDown);
            this.TextMatchRank.ResumeLayout(false);
            this.TextMatchRank.PerformLayout();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private UITextBox TextMatchName;
        private UILabel lbMatchName;
        private UILabel lbLanguage;
        private UIComboBox CmbLanguage;
        private UITextBox TextPositionDes1;
        private UILabel lbCompetitorName;
        private UILabel lbPositionDes1;
        private UITextBox TextPositionDes2;
        private UILabel lbPositionDes2;
        private UIRadioButton RadioFromPhaseRank;
        private UIRadioButton RadioFromMatchRank;
        private UIRadioButton RadioFromMatchHistory;
        private UIRadioButton RadioFromPhasePosition;
        private UISymbolButton btnCancle;
        private UISymbolButton btnOK;
        private UILabel lbStartPhase;
        private UILabel lblSourcePhase;
        private UIComboBox CmbStartPhase;
        private UIComboBox CmbSourcePhase;
        private UILabel lblSourcePhaseforMatch;
        private UIComboBox CmbSourcePhaseForMatch;
        private UILabel lbSourcePhaseforHistoryMatch;
        private UIComboBox CmbSourcePhaseforHistoryMatch;
        private UITextBox TextPhasePosition;
        private UITextBox TextPhaseRank;
        private UILabel lbPhasePosition;
        private UILabel lbPhaseRank;
        private UILabel lbSourceMatch;
        private UIComboBox CmbSourceMatch;
        private UITextBox TextMatchRank;
        private UITextBox TextHistoryMatchRank;
        private UILabel lbMatchRank;
        private UILabel lbHistoryMatchRank;
        private UILabel lbHistoryMatch;
        private UIComboBox CmbHistoryMatch;
        private UITextBox TextHistoryLevel;
        private UILabel lbHistoryLevel;
        private UITextBox TextPositionSourceDes;
        private UILabel LbPositionSourceDes;
        private UIComboBox CmbCompetitor;
        private UISymbolButton btnNEXT;
        private UISymbolButton btnPRE;
        private UILabel lbSourceProgress;
        private UITextBox TextSourceProgress;
        private UILabel lbProgress;
        private UITextBox TextProgress;
    }
}