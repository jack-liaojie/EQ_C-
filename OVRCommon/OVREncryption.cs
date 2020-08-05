using System;
using System.Collections.Generic;
using System.Text;
using System.Security.Cryptography;

namespace AutoSports.OVRCommon
{
    public static class OVRDESEncryption
    {
        private static string m_strKey = "Auto@OVR";

        public static string Encrypt(string pToEncrypt)
        {
            return DESEncrypt(pToEncrypt, m_strKey);
        }

        public static string Decrypt(string pToDecrypt)
        {
            return DESDecrypt(pToDecrypt, m_strKey);
        }

        /// 进行DES加密。
        /// </summary>
        /// <param name="pToEncrypt">要加密的字符串。</param>
        /// <param name="sKey">密钥，且必须为8位。</param>
        /// <returns>以Base64格式返回的加密字符串。</returns>
        private static string DESEncrypt(string pToEncrypt, string sKey)
        {
            using (DESCryptoServiceProvider des = new DESCryptoServiceProvider())
            {
                byte[] inputByteArray = Encoding.UTF8.GetBytes(pToEncrypt);
                des.Key = ASCIIEncoding.ASCII.GetBytes(sKey);
                des.IV = ASCIIEncoding.ASCII.GetBytes(sKey);
                System.IO.MemoryStream ms = new System.IO.MemoryStream();
                using (CryptoStream cs = new CryptoStream(ms, des.CreateEncryptor(), CryptoStreamMode.Write))
                {
                    cs.Write(inputByteArray, 0, inputByteArray.Length);
                    cs.FlushFinalBlock();
                    cs.Close();
                }
                string str = Convert.ToBase64String(ms.ToArray());
                ms.Close();
                return str;
            }
        }

        /**/
        /// <summary>
        /// 进行DES解密。
        /// </summary>
        /// <param name="pToDecrypt">要解密的以Base64</param>
        /// <param name="sKey">密钥，且必须为8位。</param>
        /// <returns>已解密的字符串。</returns>
        private static string DESDecrypt(string pToDecrypt, string sKey)
        {
            byte[] inputByteArray = Convert.FromBase64String(pToDecrypt);
            using (DESCryptoServiceProvider des = new DESCryptoServiceProvider())
            {
                des.Key = ASCIIEncoding.ASCII.GetBytes(sKey);
                des.IV = ASCIIEncoding.ASCII.GetBytes(sKey);
                System.IO.MemoryStream ms = new System.IO.MemoryStream();
                using (CryptoStream cs = new CryptoStream(ms, des.CreateDecryptor(), CryptoStreamMode.Write))
                {
                    cs.Write(inputByteArray, 0, inputByteArray.Length);
                    cs.FlushFinalBlock();
                    cs.Close();
                }
                string str = Encoding.UTF8.GetString(ms.ToArray());
                ms.Close();
                return str;
            }
        }  
    }

    public static class OVRSimpleEncryption
    {
        private static string m_strKey = "NewAuto";

        public static string Encrypt(string strSrcCode)
        {
            // Get Key char summary
            int nKeySum = 0;
            for (int i = 0; i < m_strKey.Length; i++)
            {
                nKeySum += (int)(m_strKey[i]);
            }
            int nKey = nKeySum % 26;

            StringBuilder strDesCode = new StringBuilder();
            for (int i = 0; i < strSrcCode.Length; i++)
            {
                int nSrcCode = strSrcCode[i];

                int nDesCode = nSrcCode + nKey;

                if ((nDesCode >= 48 && nDesCode <= 57)  // digital
                    || (nDesCode >= 65 && nDesCode <= 90) // upper char
                    || (nDesCode >= 97 && nDesCode <= 122)) // lower char
                {
                    strDesCode.Append((Char)(nDesCode));
                    strDesCode.Append((Char)((nDesCode * nKey + i) % 26 + 65));
                }
                else
                {
                    strDesCode.Append((Char)(nSrcCode));
                    strDesCode.Append((Char)((nDesCode * nKey + i) % 9 + 48));
                }

            }

            return strDesCode.ToString();
        }

        public static string Decrypt(string strDesCode)
        {
            // Get Key char summary
            int nKeySum = 0;
            for (int i = 0; i < m_strKey.Length; i++)
            {
                nKeySum += (int)(m_strKey[i]);
            }
            int nKey = nKeySum % 26;


            StringBuilder strSrcCode = new StringBuilder();
            int nDesLen = strDesCode.Length;
            if (nDesLen % 2 != 0)
            {
                throw (new Exception("Invalid Encrypted String."));
            }

            for (int i = 0; i < nDesLen; i = i + 2)
            {
                int nDesCode = strDesCode[i];
                int nDesCodeMark = strDesCode[i + 1];

                if ((nDesCodeMark >= 65 && nDesCodeMark <= 90)) // 
                {
                    strSrcCode.Append((Char)(nDesCode - nKey));
                }
                else if ((nDesCodeMark >= 48 && nDesCodeMark <= 57))
                {
                    strSrcCode.Append(strDesCode[i]);
                }
                else
                    throw (new Exception("Invalid Encrypted String."));
            }

            return strSrcCode.ToString();
        }
    }


}
