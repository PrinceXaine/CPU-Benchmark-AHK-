# CPU Benchmark AHK by Prince Xaine
- A CPU benchmark made in Autohotkey v1.1
- **Requires Autohotkey v1.1 installed**
- Autohotkey install Link: https://www.autohotkey.com/download/1.1/AutoHotkey112207_Install.exe
- The program utilizes Factorials to stress the CPU.

![image](https://github.com/user-attachments/assets/65fd6d05-7319-4d11-8c9d-0fdeaffd8339)
![image](https://github.com/user-attachments/assets/b0947122-065f-49cf-a085-88ee3bffd7fd)
![image](https://github.com/user-attachments/assets/aad0c5ca-b730-4a39-b653-022ddd9e06a3)


# How to Use
- To use, just choose how many threads you would like to use, then click "Start Benchmark".
- To opt out of the multi-threading test, simply reduce the # of Threads to 1.
- The test will lock your mouse.
- The test will automatically complete in ~20 seconds.
- You may, at any time during the test, press the escape ("ESC") key to stop the regain your mouse movement, stop all benchmarking threads and exit the program.

# Results
- The script will dump the results, with a timestamp, into whatever directory it is in.
- You only need ensure that you have write access to the directory.

# Other Features
- Stress Test: Allows you to run a stress test for any length of time on your processor.
- High Priority: The program is built to run in high-priority. This offers consistent results.
- Admin Privileges: The script will ask you for admin privileges when it starts. If the user declines, the script will run without them.
- Real-Time: Requires Admin Privileges. Further increases how precise the benchmark is. Does not apply to stress test for obvious reasons.

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
