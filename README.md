# CPU Benchmark AHK by Prince Xaine
- A CPU benchmark made in Autohotkey v1.1
- **Requires Autohotkey v1.1 installed**
- Autohotkey install Link: https://www.autohotkey.com/download/1.1/AutoHotkey112207_Install.exe
- The program utilizes Factorials to stress the CPU.

![image](https://github.com/user-attachments/assets/957e8d48-dd59-4dc7-a605-11562b22d30b)
![image](https://github.com/user-attachments/assets/df56124d-1688-40ef-9350-6a2f1b879283)

# How to Use
- To use, just choose how many threads you would like to use, then click "Start Benchmark".
- To opt out of the multi-threading test, simply reduce the # of Threads to 1.
- The test will lock your mouse.
- The test will automatically complete in ~20 seconds.

# Results
- The script will dump the results, with a timestamp, into whatever directory it is in.
- You only need ensure that you have write access to the directory.

# Other Features
- Stress Test: Allows you to run a stress test for any length of time on your processor.
- High Priority: The program is built to run in high-priority. This offers consistent results.

# Future Updates
- Include timer for stress test.
- Include Real-Time option.

# Limitations
- This program is stand-alone. I will not be including temperature sensors as AHK does not support it.
  If you wish to monitor temps, you will need to utilize a third-party application.
- Much like the temperature monitoring, Autohotkey has no way of identifying the turbo overclock speed of your processor. It will only identify the base speed.

# How it works
- When user launches the program, a temp folder with a random 9+ digit code is created in the file directory.
- When user selects "Benchmark", the script runs a single-thread test within the "parent" script.
    (This just means the script does not launch any other scripts to run this test.)
- When # of Threads is greater than 1, the script then runs a multi-thread test by dynamically creating Core"x".ahk files within the script directory temp folder.
- After creating the files, the script launches these files in "high priority" mode, which offers more consistent results.
- The benchmark results are then saved in a text file called "CPUBenchmarkResults.txt"
- When the program is closed, the temporary folder and all of the dynamically created cores and files are deleted.
- If the user presses the "ESC" key during either the benchmark or stress tests, the core.ahk processes are destroyed, and the temp folder is deleted. Then the program exits.
- The stress test does the same thing as the multi-threaded benchmark, except those cores are coded to continue until user exits.
