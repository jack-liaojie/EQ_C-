using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.IO.Ports;
using System.Data;

namespace OVRDVPlugin.TSInterface
{
    public static class SerialPortConfig
    {

        public static string[] GetPortNames()
        {
            return SerialPort.GetPortNames();
        }
        public static List<string> GetBaudRate()
        {
            List<string> rates = new List<string>();
            rates.Add("300");
            rates.Add("600");
            rates.Add("1200");
            rates.Add("2400");
            rates.Add("4800");
            rates.Add("9600");
            rates.Add("19200");
            rates.Add("38400");
            rates.Add("43000");
            rates.Add("56000");
            rates.Add("57600");
            rates.Add("115200");
            return rates;
        }

        public static List<string> GetDataBits()
        {
            List<string> bits = new List<string>();
            bits.Add("6");
            bits.Add("7");
            bits.Add("8");
            return bits;
        }

        public static string[] GetParity()
        {
            return Enum.GetNames(typeof(Parity));
        }

        public static string[] GetStopBits()
        {
            return Enum.GetNames(typeof(StopBits));
        }
    }
}
