# Shell scripts for batch transcoding videos
### Provides shell scripts for ffmpeg and handbrake

#### NOTES
- When running the scripts make sure that ffmpeg.exe and/or HandBrakeCLI.exe are in your Path variable and can be run from anywhere on the system
- When running powershell scripts make sure you have valid execution policies set or you will not be able to run the scripts, a simple command to fix this is to run `Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope LocalMachine` in powershell as an administrator
- The scripts currently don't implement more complex methods of transcoding, feel free to send a pull request if you developed your own version
