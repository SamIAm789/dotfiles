Enable it in the BIOS first
Power on and repeatedly press F10 to enter the BIOS Setup.
Go to Advanced → Remote Management Options (sometimes called “Remote Management” or similar).
Make sure these are set:
Intel Active Management Technology (AMT) → Enabled
Intel Management Engine → Enabled (if the option exists)
Look for Unconfigure AMT on next boot (or similar).
If you have never set it up, or you want a clean start → set it to Apply.
Save & Exit (F10 → Yes).
The machine will reboot.
2. Enter MEBx and finish activation
During the next boot, repeatedly press Ctrl + P (on most EliteDesk desktops).
Some HP units use F6 or show it in the Esc startup menu → choose the Intel ME / AMT option.
Login with the default password:
admin
You must change the password immediately.
Requirements: at least 8 characters, one upper-case, one lower-case, one number, one special character.
Inside MEBx:
Go to Intel AMT Configuration
Manageability Feature Selection → set to Enabled / Intel AMT
Enable SOL / IDER / KVM (or the individual options if listed)
User Consent → set to None (recommended if you want unattended BIOS access)
Network Setup → configure IP (DHCP is fine for most home use)
Choose Activate Network Access
Exit MEBx and let it reboot.
3. Quick test
After reboot, from another machine try:
`http://<ip-of-the-elitedesk>:16992`