# 🎮 pkg2vita

**An automated PowerShell script to extract, decrypt, and organize PS Vita Games and DLCs.**

Processing PS Vita `.zip` files manually is tedious. **pkg2vita** automates the entire process: it extracts your `.zip` archives, renames your license files, decrypts the `.pkg` packages, and organizes the output into Vita-ready folders (`app` for games, `addcont` for DLCs). All you have to do is drag and drop the final output to your memory card!

## ✨ Features

* **Batch Processing:** Drop as many `.zip` files as you want into the folder; the script will handle all of them in one go.
* **Smart Renaming:** Automatically finds your game's `.bin` license file and renames it to `work.bin` so the decryptor can read it.
* **Auto-Sorting:** Automatically sorts your decrypted files into Vita-native `app/` and `addcont/` directories.
* **Clean Cleanup:** Automatically deletes temporary extraction folders to save hard drive space.

---

## 🛠️ Requirements

Before using this script, ensure you have the following installed/downloaded:

1. **7-Zip** - Used for extracting the initial `.zip` files.
* Download: [7-zip.org](https://www.7-zip.org/)
* *Note: The script assumes 7-Zip is installed at `C:\Program Files\7-Zip\7z.exe`. If yours is installed elsewhere, you will need to edit the `$7zPath` variable inside the script.*


2. **pkg2zip** - The utility used to decrypt the Vita packages.
* Download: [pkg2zip releases on GitHub](https://github.com/mmozeiko/pkg2zip/releases)



---

## 🚀 Setup & Installation

1. Download the `pkg2vita.ps1` script.
2. Create a new, empty folder on your computer (e.g., `Vita Games`).
3. Place the following files inside this new folder:
* The `pkg2vita.ps1` script.
* `pkg2zip.exe` (extracted from the GitHub release).
* All of your downloaded Game and DLC `.zip` files.



**Your folder structure should look like this before running:**

```text
📂 Vita Games/
 ├── 📜 pkg2vita.ps1
 ├── ⚙️ pkg2zip.exe
 ├── 📦 Game_1.zip
 ├── 📦 Game_2_(DLC).zip
 └── 📦 Game_3.zip

```

---

## 💻 How to Use

Because Windows blocks unauthorized PowerShell scripts by default, you may need to bypass the execution policy to run it.

1. **Open PowerShell** in your working folder:
* *Windows 11:* Right-click inside the folder and select **"Open in Terminal"**.
* *Windows 10:* Hold `Shift` + Right-Click inside the folder and select **"Open PowerShell window here"**.


2. **Bypass the Execution Policy** (if necessary) by typing the following and hitting `Enter`:
```powershell
Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process

```


*(Type `Y` and press `Enter` if prompted).*
3. **Run the script** by typing:
```powershell
.\pkg2vita.ps1

```


4. **Wait for it to finish!** The script will output its progress to the console.

---

## 📂 The Output

Once the script finishes, it will generate a new folder called **`ReadyForVita`**. Inside, you will find your files perfectly formatted and decrypted.

```text
📂 ReadyForVita/
 ├── 📂 app/         <-- Contains your decrypted games (e.g., PCSB00550)
 └── 📂 addcont/     <-- Contains your decrypted DLCs

```

### Transferring to your PS Vita:

1. Connect your PS Vita to your PC using **VitaShell** (via USB or FTP).
2. Open your memory card directory (usually `ux0:`).
3. Copy the contents of the `ReadyForVita` folder directly into the root of `ux0:`.
*(If prompted to merge folders, click **Yes**).*
4. Disconnect your Vita.
5. In VitaShell, press **Triangle (△)** and select **"Refresh LiveArea"**.
6. Close VitaShell. Your games and DLCs will now appear as bubbles on your home screen!

*(**Note:** Ensure you have the `NoNpDrm` plugin installed on your PS Vita, otherwise the games will give an error when launched).*
