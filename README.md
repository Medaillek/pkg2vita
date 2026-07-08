# 🎮 pkg2vita

**An automated PowerShell script to extract, decrypt, and organize PS Vita Games, DLCs, Updates, and Avatars.**

Processing PS Vita `.zip` files manually is tedious. **pkg2vita** automates the entire process: it extracts your `.zip` archives, routes and renames your license files, decrypts the `.pkg` packages, and organizes the output into Vita-ready folders (`app`, `addcont`, `patch`, `license`, etc.). All you have to do is drag and drop the final output to your memory card!

## ✨ Features

* **Batch Processing:** Drop as many `.zip` files as you want into the folder; the script will handle all of them in one go.
* **Smart Tracking:** Successfully processed `.zip` files are automatically moved to a `Processed_Zips` folder, meaning you can drop new games in later without wasting time re-processing old ones.
* **Smart Renaming & Routing:** Automatically finds your game's `.bin` license file (no matter how deeply it was nested in the zip), moves it next to the `.pkg`, and renames it to `work.bin` so the decryptor can read it.
* **Auto-Sorting:** Automatically sorts your decrypted files into Vita-native directories (`app/` for games, `addcont/` for DLCs, `license/` for avatars, `patch/` for updates).
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
* All of your downloaded Game, DLC, Update, and Avatar `.zip` files.

**Your folder structure should look like this before running:**

```text
📂 Vita Games/
 ├── 📜 pkg2vita.ps1
 ├── ⚙️ pkg2zip.exe
 ├── 📦 Game_1.zip
 ├── 📦 Game_2_(DLC).zip
 ├── 📦 Game_3_(Update).zip
 └── 📦 Game_4_(Avatar).zip

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

Once the script finishes, it will generate a **`ReadyForVita`** folder with your files perfectly formatted, and move your original archives into a **`Processed_Zips`** folder.

```text
📂 Vita Games/
 ├── 📂 Processed_Zips/  <-- Your original .zip files are safely stored here
 └── 📂 ReadyForVita/
      ├── 📂 app/        <-- Contains your decrypted games (e.g., PCSB00550)
      ├── 📂 addcont/    <-- Contains your decrypted DLCs
      ├── 📂 patch/      <-- Contains game updates
      └── 📂 license/    <-- Contains Avatars and extra licenses

```

### Transferring to your PS Vita:

1. Connect your PS Vita to your PC using **VitaShell** (via USB or FTP) or by plugging your SD card directly into your PC (if using an SD2Vita adapter).
2. Open your main memory card directory (usually `ux0:`).
3. Copy the contents of the `ReadyForVita/` folder directly into the root of `ux0:` (or the root of your SD card).
*(If prompted to merge folders, click **Yes**).*
4. Disconnect your Vita or reinsert your SD card.
5. In VitaShell, press **Triangle (△)** and select **"Refresh LiveArea"**.
6. Close VitaShell. Your games, DLCs, and updates will now appear as bubbles or be applied to your games on your home screen!

*(**Note:** Ensure you have the `NoNpDrm` plugin installed on your PS Vita, otherwise the games will give an error when launched).*
