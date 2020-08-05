using System;
using System.Collections.Generic;
using System.Text;
using System.Windows.Forms;

namespace AutoSports.OVRCommon
{
    public delegate void NotifyDGVCellOfSelectionChanged(object sender, object selItem);

    public class OVRCustomComboBoxItem
    {
        private string m_strValue;  // ValueMember
        private string m_strTag;   // DisplayMember

        public OVRCustomComboBoxItem(string strValue, string strTag)
        {

            this.m_strValue = strValue;
            this.m_strTag = strTag;
        }

        public string Value
        {
            get { return m_strValue; }
        }

        public string Tag
        {
            get { return m_strTag; }
        }

        public override string ToString()
        {
            return this.m_strTag + " - " + this.m_strValue;
        }

    }

    public class DGVCustomComboBoxColumn : DataGridViewColumn
    {
        private System.Collections.Generic.List<Object> olItems;

        public System.Collections.Generic.List<Object> Items
        {
            get { return olItems; }
        }

        public DGVCustomComboBoxColumn() : base(new DGVCustomComboBoxCell())
        {
            olItems = new System.Collections.Generic.List<Object>();
        }

        public void FillComboBoxItems(System.Data.SqlClient.SqlDataReader sdr, string displayMember, string valueMember)
        {
            if (sdr == null) return;

            int iValue = -1;
            int iDisplay = -1;
            for (int i = 0; i < sdr.FieldCount; i++)
            {
                if (valueMember == sdr.GetName(i))
                {
                    iValue = i;
                }
                else if (displayMember == sdr.GetName(i))
                {
                    iDisplay = i;
                }
            }

            if (iDisplay == -1 || iValue == -1) return;

            FillComboBoxItems(sdr, iDisplay, iValue);
        }

        public void FillComboBoxItems(System.Data.SqlClient.SqlDataReader sdr, int displayMember, int valueMember)
        {
            olItems.Clear();

            if (sdr == null) return;
            if (valueMember >= sdr.FieldCount || displayMember >= sdr.FieldCount) return;

            while (sdr.Read())
            {
                olItems.Add(new OVRCustomComboBoxItem(sdr[valueMember].ToString(), sdr[displayMember].ToString()));
            }
        }

        public void FillComboBoxItems(System.Data.DataTable table, string displayMember, string valueMember)
        {
            if (table == null) return;

            int iValue = -1;
            int iDisplay = -1;
            for (int i = 0; i < table.Columns.Count; i++)
            {
                if (valueMember == table.Columns[i].ColumnName)
                {
                    iValue = i;
                }
                else if (displayMember == table.Columns[i].ColumnName)
                {
                    iDisplay = i;
                }
            }

            if (iDisplay == -1 || iValue == -1) return;

            FillComboBoxItems(table, iDisplay, iValue);
        }

        public void FillComboBoxItems(System.Data.DataTable table, int displayMember, int valueMember)
        {
            olItems.Clear();

            if (table == null) return;
            if (valueMember >= table.Columns.Count || displayMember >= table.Columns.Count) return;

            for (int i = 0; i < table.Rows.Count; i++ )
            {
                olItems.Add(new OVRCustomComboBoxItem(table.Rows[i][valueMember].ToString(), table.Rows[i][displayMember].ToString()));
            }
        }

        public override DataGridViewCell CellTemplate
        {
            get { return base.CellTemplate; }

            set
            {
                if (value != null && !value.GetType().IsAssignableFrom(typeof(DGVCustomComboBoxCell)))
                {
                    string s = "Cell type is not based upon the MaskedTextBoxCell.";
                    throw new InvalidCastException(s);
                }
                base.CellTemplate = value;
            }
        }
    }

    public class DGVCustomComboBoxCell : DataGridViewTextBoxCell
    {
        public DGVCustomComboBoxCell()
        {

        }

        private void OnComboBoxSelectionChanged(object sender, object selItem)
        {
            if (selItem is OVRCustomComboBoxItem)
            {
                Tag = (selItem as OVRCustomComboBoxItem).Value;
            }
        }

        public override void InitializeEditingControl(int rowIndex, object initialFormattedValue,
                                              DataGridViewCellStyle dataGridViewCellStyle)
        {
            base.InitializeEditingControl(rowIndex, initialFormattedValue, dataGridViewCellStyle);

            if (this.OwningColumn is DGVCustomComboBoxColumn)
            {
                DGVComboBoxEditingControl editCtrl = this.DataGridView.EditingControl as DGVComboBoxEditingControl;
                DGVCustomComboBoxColumn column = this.OwningColumn as DGVCustomComboBoxColumn;

                editCtrl.Items.Clear();
                editCtrl.DisplayMember = "Tag";
                editCtrl.ValueMember = "Value";
                editCtrl.NotifyDGVCell = this.OnComboBoxSelectionChanged;
                for (int i = 0; i < column.Items.Count; i++)
                {
                    editCtrl.Items.Add(column.Items[i]);

                    if (this.Value != null && (column.Items[i] as OVRCustomComboBoxItem).Tag == this.Value.ToString())
                    {
                        editCtrl.SelectedIndex = i;
                    }
                }
            }
        }

        public override Type EditType
        {
            get { return typeof(DGVComboBoxEditingControl); }
        }

    }

    public class DGVComboBoxEditingControl : ComboBox, IDataGridViewEditingControl
    {
        protected int rowIndex;
        protected DataGridView dataGridView;
        protected bool valueChanged = false;

        private NotifyDGVCellOfSelectionChanged delNotifyDGVCell;

        public NotifyDGVCellOfSelectionChanged NotifyDGVCell
        {
            set { delNotifyDGVCell = value; }
        }

        public DGVComboBoxEditingControl()
        {
            this.DropDownStyle = ComboBoxStyle.DropDownList;
        }

        protected override void OnSelectionChangeCommitted(EventArgs e)
        {
            base.OnSelectionChangeCommitted(e);

            NotifyDataGridViewOfValueChange();
        }

        protected override void OnDropDown(EventArgs e)
        {
            base.OnDropDown(e);

            System.Drawing.Graphics g = this.CreateGraphics();

            int iTemp = 0, iMaxWidth = 0;
            foreach (OVRCustomComboBoxItem item in this.Items)
            {
                iTemp = (int)g.MeasureString(item.Tag, this.Font).Width;

                if (iTemp > iMaxWidth) iMaxWidth = iTemp;
            }

            iMaxWidth += (this.Items.Count > this.MaxDropDownItems) ? SystemInformation.VerticalScrollBarWidth : 0;

            if (this.DropDownWidth < iMaxWidth) this.DropDownWidth = iMaxWidth;
        }

        protected virtual void NotifyDataGridViewOfValueChange()
        {
            this.valueChanged = true;
            if (this.dataGridView != null)
            {
                this.dataGridView.NotifyCurrentCellDirty(true);
            }
            if (this.delNotifyDGVCell != null)
            {
                this.delNotifyDGVCell(this, this.SelectedItem);
            }
        }

        #region IDataGridViewEditingControl Members

		public Cursor EditingPanelCursor
        {
            get { return Cursors.IBeam; }
        }

        public DataGridView EditingControlDataGridView
        {
            get { return this.dataGridView; }

            set { this.dataGridView = value; }
        }

		public object EditingControlFormattedValue
        {
            get
            {
                if (this.SelectedItem == null) return null;

                return (this.SelectedItem as OVRCustomComboBoxItem).Tag;
            }

            set
            {
                if (value is OVRCustomComboBoxItem)
                {
                    this.SelectedItem = value;
                    NotifyDataGridViewOfValueChange();
                }
            }
        }

        public bool RepositionEditingControlOnValueChange
        {
            get { return false; }
        }

        public int EditingControlRowIndex
        {
            get { return this.rowIndex; }

            set { this.rowIndex = value; }
        }

        public bool EditingControlValueChanged
        {
            get { return this.valueChanged; }

            set { this.valueChanged = value; }
        }
    
        public void ApplyCellStyleToEditingControl(DataGridViewCellStyle dataGridViewCellStyle)
        {
            this.Font = dataGridViewCellStyle.Font;
            this.ForeColor = dataGridViewCellStyle.ForeColor;
            this.BackColor = dataGridViewCellStyle.BackColor;
        }

        public object GetEditingControlFormattedValue(DataGridViewDataErrorContexts context)
        {
            if (this.SelectedItem == null) return null;

            return (this.SelectedItem as OVRCustomComboBoxItem).Tag;
        }

        public bool EditingControlWantsInputKey(Keys keyData, bool dataGridViewWantsInputKey)
        {
            switch (keyData & Keys.KeyCode)
            {
                case Keys.Up:
                case Keys.Down:
                case Keys.Right:
                case Keys.Left:
                case Keys.Home:
                case Keys.End:
                case Keys.Prior:
                case Keys.Next:
                    return true;
            }

            return !dataGridViewWantsInputKey;
        }

        public void PrepareEditingControlForEdit(bool selectAll)
        {
            if (selectAll)
            {
                SelectAll();
            }
            else
            {
                this.SelectionStart = this.ToString().Length;
            }
        }

		#endregion // IDataGridViewEditingControl.
		
    }

}
