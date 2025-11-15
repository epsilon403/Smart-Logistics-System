#!/bin/bash

# Script to remove large CSV files from Git repository
# WARNING: This will rewrite Git history - coordinate with team before running!

echo "🚨 WARNING: This script will remove large files from Git history"
echo "This is a destructive operation that rewrites history!"
echo ""
read -p "Do you want to continue? (yes/no): " confirm

if [ "$confirm" != "yes" ]; then
    echo "❌ Operation cancelled"
    exit 0
fi

echo ""
echo "📦 Step 1: Removing files from Git tracking..."
git rm --cached DataCoSupplyChainDataset.csv 2>/dev/null || echo "   File already removed from tracking"
git rm --cached DescriptionDataCoSupplyChain.csv 2>/dev/null || echo "   File already removed from tracking"

echo ""
echo "💾 Step 2: Committing changes..."
git add .gitignore
git commit -m "Remove large CSV files from Git tracking and update .gitignore"

echo ""
echo "✅ Done! The files are now ignored."
echo ""
echo "📌 Next steps:"
echo "   1. Run: git push"
echo "   2. The CSV files will still exist in Git history (taking up space)"
echo ""
echo "🔧 To completely remove from history (advanced):"
echo "   Option A - Use BFG Repo-Cleaner (recommended):"
echo "      java -jar bfg.jar --delete-files DataCoSupplyChainDataset.csv"
echo "      git reflog expire --expire=now --all"
echo "      git gc --prune=now --aggressive"
echo "      git push --force"
echo ""
echo "   Option B - Use git filter-repo:"
echo "      git filter-repo --path DataCoSupplyChainDataset.csv --invert-paths"
echo "      git push --force"
echo ""
echo "⚠️  WARNING: Force pushing rewrites history - notify your team first!"
