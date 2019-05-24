using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.IO;
using System.Linq;
using System.Reflection;
using System.Text;
using System.Threading.Tasks;

namespace PwnBootCLI
{
    class Program
    {
        /* 
         * PwnBoot by iBoot32
         *
         *    A CLI tool to boot a SSH Ramdisk
         *  from scratch, and subsequently barebones
         *  jailbreak the device booted with a SSH
         *  Ramdisk. This tool also supports booting
         *  a SSH Ramdisk with iBEC patched for 
         *  verbose boot, and finally, it supportsdw
         *  pwning dfu via irecovery.
         *  
         *  This tool may be used in any other program,
         *  wrapper, or tool provided the proper credit
         *  is given, meaning my name (iBoot32) and
         *  a link to PwnBoot's project's GitHub is shown
         *  in your readme or website or place of software 
         *  release.
         *  
         *  Enjoy!
         *  -  iBoot32
        */

        public static string[] validArgs = { "-p", "-b", "-vb", "-j" };
        static bool SetUp()
        {
            if (File.Exists("C:/PwnBoot/setup"))
            {
                return true;
            }
            else
            {
                return false;
            }
        }


        static void Main(string[] args)
        {
            Console.WriteLine("");
            Console.WriteLine("  PwnBoot CLI by u/iBoot32");
            Console.WriteLine("  -------------------------------");
            Console.WriteLine("");

            if (!SetUp())
            {
                Console.WriteLine("PwnBoot has not been set up yet... downloading required files...");

                //get batch file from resources
                Stream stream = Assembly.GetExecutingAssembly().GetManifestResourceStream("PwnBootCLI.dl.bat");
                string workdir = Directory.GetCurrentDirectory();
                if (File.Exists(workdir + "\\dl.bat"))
                {
                    File.Delete("dl.bat");
                }
                FileStream fileStream = new FileStream("dl.bat", FileMode.CreateNew);
                for (int i = 0; i < stream.Length; i++)
                    fileStream.WriteByte((byte)stream.ReadByte());
                fileStream.Close();

                var p = new Process();
                p.StartInfo = new ProcessStartInfo("dl.bat", "")
                {
                    UseShellExecute = false
                };

                p.Start();
                p.WaitForExit();
                var exitCode = p.ExitCode;
                p.Close();

                if (exitCode != 0)
                {
                    Console.WriteLine("error");
                    File.Delete("dl.bat");
                }
                if (exitCode == 0)
                {
                    File.Delete("dl.bat");
                    Console.WriteLine("done setting up");
                    File.Create("C:/PwnBoot/setup");
                }

            }



            if (args == null || args.Length == 0 || args[0] == "-help") //if no args provided or passed -help option, display help
            {
                Console.WriteLine("");
                Console.WriteLine(" Usage:");
                Console.WriteLine("   pwnboot.exe [device] [options]");
                Console.WriteLine("");
                Console.WriteLine("");
                Console.WriteLine(" Valid [device] entries");
                Console.WriteLine("    iPhone2,1");
                Console.WriteLine("");
                Console.WriteLine("");
                Console.WriteLine(" Options:");
                Console.WriteLine("    -p      Just Pwn DFU");
                Console.WriteLine("    -b      Boot SSH Ramdisk");
                Console.WriteLine("    -vb     Boot SSH Ramdisk with Verbose Boot");
                Console.WriteLine("    -j      Barebones Jailbreak over Booted SSH Ramdisk");
                Environment.Exit(1);
            }
            else
            {
                try
                {
                    //First we're just gonna validate the passed args to make sure there aren't too many, the device is valid, and the mode arg is valid.
                    if (args.Length > 2)
                    {
                        Console.WriteLine("  You provided too many args");
                    }

                    if (args[0] != "iPhone2,1")
                    {
                        Console.WriteLine("  Your selected device model, '" + args[0] + "' is not a valid device.");
                        Environment.Exit(1);
                    }

                    if (!validArgs.Contains(args[1]))
                    {
                        Console.WriteLine("  Your selected option of '" + args[1] + "'is not a valid option.");
                        Environment.Exit(1);
                    }
                }

                catch (Exception)
                {
                    Console.WriteLine("  The args you provided were incorrect.");
                    Environment.Exit(1);
                }

                //Since args are validated, get the mode arg (args[1]) and jump to correct mode

                if (args[1] == "-p")
                {
                    PwnDFU();
                }

                if (args[1] == "-b")
                {
                    BootRamdisk();
                }

                if (args[1] == "-vb")
                {
                    VerboseBootRamdisk();
                }

                if (args[1] == "-j")
                {
                    JailbreakViaSSHRamdisk();
                }
            }
        }

        static void PwnDFU()
        {
            var p = new Process();
            p.StartInfo = new ProcessStartInfo("C:/PwnBoot/irec.exe", "-e")
            {
                UseShellExecute = false
            };

            p.Start();
            p.WaitForExit();
        }

        static void BootRamdisk()
        {
            Console.WriteLine("");
            Console.WriteLine("");

            //extract prep.bat from resources
            File.Delete("C:/PwnBoot/prep.bat");

            Program pro = new Program();
            string resource = "PwnBootCLI.prep.bat";
            string path = "C:/PwnBoot/prep.bat";
            Stream stream = pro.GetType().Assembly.GetManifestResourceStream(resource);
            byte[] bytes = new byte[(int)stream.Length];
            stream.Read(bytes, 0, bytes.Length);
            File.WriteAllBytes(path, bytes);

            var p = new Process();
            p.StartInfo = new ProcessStartInfo("cmd.exe", "/c cd C:/PwnBoot && prep.bat")
            {
                UseShellExecute = false
            };

            p.Start();
            p.WaitForExit();
            var exitCode = p.ExitCode;
            p.Close();

            Console.WriteLine("");
            Console.WriteLine("If successful, your device should now be showing an Apple Logo and a blank progress bar, indicating that the patched ramdisk has been booted and the ssh service is running.");
            Console.WriteLine("If not, please try PwnBoot again or file a bug report.");
            Console.WriteLine("");
        }

        static void VerboseBootRamdisk()
        {
            Console.WriteLine("");
            Console.WriteLine("");

            //extract prep.bat from resources
            File.Delete("C:/PwnBoot/prepverbose.bat");

            Program pro = new Program();
            string resource = "PwnBootCLI.prepverbose.bat";
            string path = "C:/PwnBoot/prepverbose.bat";
            Stream stream = pro.GetType().Assembly.GetManifestResourceStream(resource);
            byte[] bytes = new byte[(int)stream.Length];
            stream.Read(bytes, 0, bytes.Length);
            File.WriteAllBytes(path, bytes);

            var p = new Process();
            p.StartInfo = new ProcessStartInfo("cmd.exe", "/c cd C:/PwnBoot && prepverbose.bat")
            {
                UseShellExecute = false
            };

            p.Start();
            p.WaitForExit();
            var exitCode = p.ExitCode;
            p.Close();

            Console.WriteLine("");
            Console.WriteLine("If successful, your device should now be showing an Apple Logo and a blank progress bar, indicating that the patched ramdisk has been booted and the ssh service is running.");
            Console.WriteLine("If not, please try PwnBoot again or file a bug report.");
            Console.WriteLine("");
        }

        static void JailbreakViaSSHRamdisk()
        {
            Console.WriteLine("PwnBoot currently only supports booting a custom SSH ramdisk and forwarding the connection over USB for full filesystem access. Jailbreaking will come in a near update.");
            Console.WriteLine("");
            Console.WriteLine("Forwarding SSH Service Over USB");
            Console.WriteLine("");
            Console.WriteLine("Leave this window open until you're done with SSH. Close the window once you're done.");
            Console.WriteLine("");
            Console.WriteLine("");
            var p = new Process();
                        p.StartInfo = new ProcessStartInfo("cmd.exe", "/c cd C:/PwnBoot && itunnel_mux --lport 2022")
                        {
                            UseShellExecute = false
                        };

                        p.Start();
                        p.WaitForExit();
                        var exitCode = p.ExitCode;
                        p.Close();
        }
    }

}
