# Data Files

## ⚠️ Large File Warning

The dataset `DataCoSupplyChainDataset.csv` (91.47 MB) is **too large for GitHub** (recommended max: 50 MB).

## Current Status

✅ File is currently pushed to GitHub (with warning)  
⚠️ Future pushes should exclude this file

## Options to Handle Large Data Files

### Option 1: Keep in `.gitignore` (Recommended for now)

The file is now in `.gitignore`, so future changes won't be tracked. To remove it from the repository:

```bash
# Remove from Git tracking but keep local file
git rm --cached DataCoSupplyChainDataset.csv
git rm --cached DescriptionDataCoSupplyChain.csv

# Commit the removal
git commit -m "Remove large CSV files from repository"
git push
```

### Option 2: Use Git LFS (Large File Storage)

If you need to version control large files:

```bash
# Install Git LFS
sudo apt-get install git-lfs  # Linux
# or brew install git-lfs      # macOS

# Initialize Git LFS
git lfs install

# Track CSV files with LFS
git lfs track "*.csv"

# Add .gitattributes
git add .gitattributes

# Migrate existing file to LFS
git lfs migrate import --include="*.csv"

# Push with LFS
git push
```

### Option 3: Host Data Externally

Store data on:
- **Google Drive** / **Dropbox** (free, easy)
- **AWS S3** / **Azure Blob Storage** (scalable, paid)
- **Kaggle Datasets** (public datasets)
- **DVC (Data Version Control)** (recommended for ML projects)

## Recommended Workflow

1. **Add to `.gitignore`** ✅ (Already done)
2. **Remove from Git history** (optional, see Option 1)
3. **Document data source** in main README
4. **Use external storage** for team collaboration

## Data Loading

When team members clone the repo, they should:
1. Download the CSV from [data source link]
2. Place it in the project root
3. Run `data.ipynb`

---

**Note**: The `.gitignore` file has been updated to prevent future commits of large data files.
