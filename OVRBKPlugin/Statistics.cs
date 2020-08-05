
namespace AutoSports.OVRBKPlugin
{
    /// <summary>
    /// Statistics entitie class.
    /// </summary>
    public class Statistics
    {
        #region Properties
        /// <summary>
        /// For the statistics viewmodel and model communication key.
        /// </summary>
        public int StatType { get; set; }
        /// <summary>
        /// 
        /// </summary>
        public string FieldName { get; set; }
        /// <summary>
        /// 
        /// </summary>
        public string StatValue { get; set; }
        /// <summary>
        /// 
        /// </summary>
        public string Molecules { get; set; }
        /// <summary>
        /// 
        /// </summary>
        public string Denominator { get; set; }
        #endregion

        #region Operation helper
        /// <summary>
        /// Clear statistics value.
        /// </summary>
        public void ClearStatValue()
        {
            StatValue = "";
            Molecules = "";
            Denominator = "";
        }
        /// <summary>
        /// example data: 12/34.
        /// </summary>
        /// <returns></returns>
        public string GetMoleDeno()
        {
            return Molecules + " / " + Denominator;
        }
        /// <summary>
        /// example data: 12.34%.
        /// </summary>
        /// <returns></returns>
        public string GetPercentage()
        {
            if (Denominator.Length == 0)
                return "";

            double dMolecules = 0.0f;
            if (!double.TryParse(Molecules, out dMolecules))
                return "";

            double dDenominator = 0.0f;
            if (!double.TryParse(Denominator, out dDenominator))
                return "";

            double dValue = dMolecules / dDenominator;

            return string.Format("{0:f2}%", dValue);
        }

        /// <summary>
        /// To other statistics object.
        /// </summary>
        /// <param name="refStatistics"></param>
        public void ToStatistics(ref Statistics refStatistics)
        {
            refStatistics.StatType = StatType;
            refStatistics.FieldName = FieldName;
            refStatistics.StatValue = StatValue;
            refStatistics.Molecules = Molecules;
            refStatistics.Denominator = Denominator;
        }

        #endregion
    }
}
