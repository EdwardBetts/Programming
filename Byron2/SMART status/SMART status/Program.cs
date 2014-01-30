// Written by Byron COetsee
// 30/1/2014
// Code used from http://www.know24.net/blog/C+WMI+HDD+SMART+Information.aspx

using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Management;
using System.Net.Mail;
using System.Net; 

namespace SMART_status
{
    public class HDD
    {
        public int Index { get; set; }
        public bool IsOK { get; set; }
        public string Model { get; set; }
        public string Type { get; set; }
        public string Serial { get; set; }
        public long free_space { get; set; }
        public long total_size { get; set; }

        public Dictionary<int, Smart> Attributes = new Dictionary<int, Smart>() {
                {0x00, new Smart("Invalid")},
                {0x01, new Smart("Raw read error rate")},
                {0x02, new Smart("Throughput performance")},
                {0x03, new Smart("Spinup time")},
                {0x04, new Smart("Start/Stop count")},
                {0x05, new Smart("Reallocated sector count")},
                {0x06, new Smart("Read channel margin")},
                {0x07, new Smart("Seek error rate")},
                {0x08, new Smart("Seek timer performance")},
                {0x09, new Smart("Power-on hours count")},
                {0x0A, new Smart("Spinup retry count")},
                {0x0B, new Smart("Calibration retry count")},
                {0x0C, new Smart("Power cycle count")},
                {0x0D, new Smart("Soft read error rate")},
                {0xB8, new Smart("End-to-End error")},
                {0xBE, new Smart("Airflow Temperature")},
                {0xBF, new Smart("G-sense error rate")},
                {0xC0, new Smart("Power-off retract count")},
                {0xC1, new Smart("Load/Unload cycle count")},
                {0xC2, new Smart("HDD temperature")},
                {0xC3, new Smart("Hardware ECC recovered")},
                {0xC4, new Smart("Reallocation count")},
                {0xC5, new Smart("Pending sector count")},
                //{0xC6, new Smart("Offline scan uncorrectable count")},
                {0xC7, new Smart("UDMA CRC error rate")},
                {0xC8, new Smart("Write error rate")},
                {0xC9, new Smart("Soft read error rate")},
                {0xCA, new Smart("Data Address Mark errors")},
                {0xCB, new Smart("Run out cancel")},
                {0xCC, new Smart("Soft ECC correction")},
                {0xCD, new Smart("Thermal asperity rate (TAR)")},
                {0xCE, new Smart("Flying height")},
                {0xCF, new Smart("Spin high current")},
                {0xD0, new Smart("Spin buzz")},
                {0xD1, new Smart("Offline seek performance")},
                {0xDC, new Smart("Disk shift")},
                {0xDD, new Smart("G-sense error rate")},
                {0xDE, new Smart("Loaded hours")},
                {0xDF, new Smart("Load/unload retry count")},
                {0xE0, new Smart("Load friction")},
                {0xE1, new Smart("Load/Unload cycle count")},
                {0xE2, new Smart("Load-in time")},
                {0xE3, new Smart("Torque amplification count")},
                {0xE4, new Smart("Power-off retract count")},
                {0xE6, new Smart("GMR head amplitude")},
                {0xE7, new Smart("Temperature")},
                {0xF0, new Smart("Head flying hours")},
                {0xFA, new Smart("Read error retry rate")},
                /* slot in any new codes you find in here */
            };
    }

    public class Smart
    {
        public bool HasData
        {
            get
            {
                if (Current == 0 && Worst == 0 && Threshold == 0 && Data == 0)
                    return false;
                return true;
            }
        }
        public string Attribute { get; set; }
        public int Current { get; set; }
        public int Worst { get; set; }
        public int Threshold { get; set; }
        public int Data { get; set; }
        public bool IsOK { get; set; }

        public Smart()
        {
        }

        public Smart(string attributeName)
        {
            this.Attribute = attributeName;
        }
    }

    public class Program
    {
        public static void Main()
        {
            try
            {
                // 0 = retrieve list of drives on computer (this will return both HDD's and CDROM's and Virtual CDROM's)                    
                var dicDrives = new Dictionary<int, HDD>();

                var wdSearcher = new ManagementObjectSearcher("SELECT * FROM Win32_LogicalDisk"); //DiskDrive

                Console.WriteLine("Past stage 0");

                // 1 = extract model and interface information
                int iDriveIndex = 0;
                foreach (ManagementObject drive in wdSearcher.Get())
                {
                    if (drive["DriveType"].ToString().Trim().Equals("3"))
                    {
                        var hdd = new HDD();
                        hdd.Model = drive["Name"].ToString().Trim(); //Model
                        hdd.Type = drive["DriveType"].ToString().Trim(); //InterfaceType
                        //hdd.Index = int.Parse(drive["Index"].ToString().Trim());
                        hdd.total_size = Convert.ToInt64(drive["Size"]);
                        hdd.free_space = Convert.ToInt64(drive["FreeSpace"]);
                        dicDrives.Add(iDriveIndex, hdd);
                        iDriveIndex++;
                    }
                }
                Console.WriteLine("Past stage 1");

                var pmsearcher = new ManagementObjectSearcher("SELECT * FROM Win32_PhysicalMedia");

                // 2 = retrieve hdd serial number
                iDriveIndex = 0;
                foreach (ManagementObject drive in pmsearcher.Get())
                {
                    // because all physical media will be returned we need to exit
                    // after the hard drives serial info is extracted
                    if (iDriveIndex >= dicDrives.Count)
                        break;

                    dicDrives[iDriveIndex].Serial = drive["SerialNumber"] == null ? "PARTITION" : drive["SerialNumber"].ToString().Trim();
                    iDriveIndex++;
                }
                Console.WriteLine("Past stage 2");

                // 3 = get wmi access to hdd 
                var searcher = new ManagementObjectSearcher("Select * from Win32_DiskDrive"); //DiskDrive
                searcher.Scope = new ManagementScope(@"\root\wmi");

                Console.WriteLine("Past stage 3");

                // 4 = check if SMART reports the drive is failing
                // 4.1
                searcher.Query = new ObjectQuery("Select * from MSStorageDriver_FailurePredictStatus");
                iDriveIndex = 0;
                foreach (ManagementObject drive in searcher.Get())
                {
                    // 4.x
                    Console.WriteLine("Past stage 4."+iDriveIndex);
                    try
                    {

                        if (dicDrives[iDriveIndex].Type.Equals("3"))
                        {
                            dicDrives[iDriveIndex].IsOK = (bool)drive.Properties["PredictFailure"].Value == false;
                            iDriveIndex++;
                        }
                        if (dicDrives[iDriveIndex].Serial.Equals("PARTITION"))
                        {
                            dicDrives[iDriveIndex].IsOK = true;
                            iDriveIndex++;
                        }
                    }
                    catch (NullReferenceException e)
                    {
                        Console.WriteLine(e.Message + " : " + iDriveIndex);
                    }
                    catch (KeyNotFoundException e)
                    {
                        Console.WriteLine(e.Message + " : " + iDriveIndex);
                    }


                }
                Console.WriteLine("Past stage 4");

                // 5 = retrive attribute flags, value worste and vendor data information
                searcher.Query = new ObjectQuery("Select * from MSStorageDriver_FailurePredictData");
                iDriveIndex = 0;
                foreach (ManagementObject data in searcher.Get())
                {
                    Byte[] bytes = (Byte[])data.Properties["VendorSpecific"].Value;
                    for (int i = 0; i < 30; ++i)
                    {
                        try
                        {
                            int id = bytes[i * 12 + 2];

                            int flags = bytes[i * 12 + 4]; // least significant status byte, +3 most significant byte, but not used so ignored.
                            //bool advisory = (flags & 0x1) == 0x0;
                            bool failureImminent = (flags & 0x1) == 0x1;
                            //bool onlineDataCollection = (flags & 0x2) == 0x2;

                            int value = bytes[i * 12 + 5];
                            int worst = bytes[i * 12 + 6];
                            int vendordata = BitConverter.ToInt32(bytes, i * 12 + 7);
                            if (id == 0) continue;

                            var attr = dicDrives[iDriveIndex].Attributes[id];
                            attr.Current = value;
                            attr.Worst = worst;
                            attr.Data = vendordata;
                            attr.IsOK = failureImminent == false;
                        }
                        catch
                        {
                            // given key does not exist in attribute collection (attribute not in the dictionary of attributes)
                        }
                    }
                    iDriveIndex++;
                }
                Console.WriteLine("Past stage 5");

                // 6 = retreive threshold values foreach attribute
                searcher.Query = new ObjectQuery("Select * from MSStorageDriver_FailurePredictThresholds");
                iDriveIndex = 0;
                foreach (ManagementObject data in searcher.Get())
                {
                    Byte[] bytes = (Byte[])data.Properties["VendorSpecific"].Value;
                    for (int i = 0; i < 30; ++i)
                    {
                        try
                        {

                            int id = bytes[i * 12 + 2];
                            int thresh = bytes[i * 12 + 3];
                            if (id == 0) continue;

                            var attr = dicDrives[iDriveIndex].Attributes[id];
                            attr.Threshold = thresh;
                        }
                        catch
                        {
                            // given key does not exist in attribute collection (attribute not in the dictionary of attributes)
                        }
                    }
                    iDriveIndex++;
                }
                Console.WriteLine("Past stage 6");


                // 7 = print
                string output = string.Format("{0,-25}{1,10}{2,10}{3,15}{4,10}{5,7}\n", "ID", "Current", "Worst", "Threshold", "Data", "Status");
                string serial = "";
                string host_name = System.Environment.MachineName;
                foreach (var drive in dicDrives)
                {
                    string totalSize = "";
                    string freeSpace = "";

                    if (drive.Value.total_size < 1073741824)
                        totalSize = drive.Value.total_size / 1024 / 1024 + "MB";
                    else
                        totalSize = drive.Value.total_size / 1024 / 1024 / 1024 + "GB";

                    if (drive.Value.free_space < 1073741824)
                        freeSpace = drive.Value.free_space / 1024 / 1024 + "MB Free";
                    else
                        freeSpace = drive.Value.free_space / 1024 / 1024 / 1024 + "GB Free";

                    Console.WriteLine(drive.Value.Model + "\t" + drive.Value.Serial + "\t" + totalSize + "\t" + freeSpace + "\t"+drive.Value.Type);
                }
                
                    
                foreach (var drive in dicDrives)
                {
                    string freeSpace = "";

                    if (drive.Value.free_space < 1073741824)
                        freeSpace = drive.Value.free_space / 1024 / 1024 + "MB Free";
                    else
                        freeSpace = drive.Value.free_space / 1024 / 1024 / 1024 + "GB Free";
                    bool failing = false;
                    Console.WriteLine("-----------------------------------------------------");
                    Console.WriteLine(" DRIVE ({0}): " + drive.Value.Serial + " - " + drive.Value.Model + " - " + freeSpace, ((drive.Value.IsOK) ? "OK" : "BAD"));
                    Console.WriteLine("-----------------------------------------------------");
                    Console.WriteLine("");
                    //int free_space = Convert.ToInt32(drive.Value.Attributes["FreeSpace"]);
                    Console.WriteLine(string.Format("{0,-25}{1,10}{2,10}{3,15}{4,10}{5,7}", "ID", "Current", "Worst", "Threshold", "Data", "Status"));
                    foreach (var attr in drive.Value.Attributes)
                    {
                        if (attr.Value.HasData)
                        {
                            if ((attr.Value.Attribute.Equals("Reallocated sector count")) && (attr.Value.Data > 0))
                            {
                                failing = true; 
                                serial = drive.Value.Serial;
                            }
                            Console.WriteLine(string.Format("{0,-25}{1,10}{2,10}{3,15}{4,10}{5,7}", attr.Value.Attribute, attr.Value.Current, attr.Value.Worst, attr.Value.Threshold, attr.Value.Data, ((attr.Value.IsOK) ? "OK" : "")));
                            output = output + attr.Value.Attribute + "\t=\t" + attr.Value.Current + "\t=\t" + attr.Value.Worst + "\t=\t" + attr.Value.Threshold + "\t=\t" + attr.Value.Data + "\t=\t" + ((attr.Value.IsOK) ? "OK" : "") + "\n";
                            //output = output + string.Format("{0,-25}{1,10}{2,10}{3,15}{4,10}{5,7}", attr.Value.Attribute, attr.Value.Current, attr.Value.Worst, attr.Value.Threshold, attr.Value.Data, ((attr.Value.IsOK) ? "OK" : ""));
                        }
                    }
                    string messageBody = "";
                    if ((failing == true) || (drive.Value.free_space < (drive.Value.total_size*0.15)) || (drive.Value.IsOK == false))
                    {
                        MailMessage message = new MailMessage();
                        message.To.Add("byroncoetsee@gmail.com");
                        //message.CC.Add("gdegreef@computamaps.com");
                        message.CC.Add("achmat@gmail.com");
                        message.Priority = MailPriority.High;
                        message.Subject = "FAILING DRIVE <" + drive.Value.Model +"> on "+ host_name;
                        message.From = new MailAddress("server.admin@computamaps.com");
                        if (drive.Value.IsOK == false)
                            messageBody = messageBody + "Drive recieved BAD status\n";
                        if (drive.Value.free_space < (drive.Value.total_size * 0.15))
                            messageBody = messageBody + "Drive " + drive.Value.Model + "has less than 15% left.\n";
                        if (failing == true)
                            messageBody = messageBody + "Reallocated sector detected on drive " + drive.Value.Model;
                        message.Body = messageBody + "\n\n" + output;
                        SmtpClient smtp = new SmtpClient("secure.emailsrvr.com");

                        smtp.Credentials = new NetworkCredential("server.admin@computamaps.com", "Bl0ckC");

                        smtp.EnableSsl = true;

                        smtp.Send(message);
                    }
                    Console.WriteLine();
                    Console.WriteLine();
                    Console.WriteLine();
                }

                Console.ReadLine();
            }
            catch (ManagementException e)
            {
                Console.WriteLine("An error occurred while querying for WMI data: " + e.Message);
            }
            Console.Read();
        }
    }
}
