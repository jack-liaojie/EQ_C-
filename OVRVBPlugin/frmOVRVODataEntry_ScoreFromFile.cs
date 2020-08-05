using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using System.IO;

namespace AutoSports.OVRVBPlugin
{
	public partial class frmOVRVODataEntry
	{
		private FileSystemWatcher _scoreFileWatcher;
		private string _scoreFileFullPath;

		private void _chkScoreFromFile_CheckedChanged(object sender, EventArgs e)
		{
			if (_scoreFileWatcher != null)
			{
				_scoreFileWatcher.EnableRaisingEvents = false;
				_scoreFileWatcher = null;
				_scoreFileFullPath = null;
				_chkScoreFromFile.Checked = false;

				return;	
			}

			try
			{
				_scoreFileFullPath = @"D:\Watcher\123.txt";
				_scoreFileWatcher = new FileSystemWatcher(Path.GetDirectoryName(_scoreFileFullPath), @"*" + Path.GetExtension(_scoreFileFullPath));
				_scoreFileWatcher.Changed +=new FileSystemEventHandler(_scoreFileWatcher_Changed);
				_scoreFileWatcher.EnableRaisingEvents = true;
				_chkScoreFromFile.Checked = true;
			}
			catch (Exception err)
			{
				MessageBox.Show("Launch File watcher failed! " + err.ToString());
				_scoreFileWatcher = null;
				_chkScoreFromFile.Checked = false;
			}
		}

		private void _scoreFileWatcher_Changed(object sender, FileSystemEventArgs e)
		{
			if (e.FullPath != _scoreFileFullPath)
			{
				return;
			}

			string strStream;
			StreamReader reader = new StreamReader(e.FullPath);
			strStream = reader.ReadToEnd();
			reader.Close();
			reader = null;


			string[] straScore = strStream.Split(',');

		}
	}
}
