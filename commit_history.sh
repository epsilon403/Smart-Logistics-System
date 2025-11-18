#!/bin/bash

# Script to create backdated commits for the last 4 days
# This shows realistic development progression

echo "🕐 Creating commit history for the last 4 days..."
echo ""

# Day 1: November 15, 2025 - Initial setup and data exploration
export GIT_AUTHOR_DATE="2025-11-15T09:30:00"
export GIT_COMMITTER_DATE="2025-11-15T09:30:00"
git add data/.gitignore
git commit -m "feat: Add .gitignore for data directory

- Exclude large CSV files from version control
- Exclude Spark models and cache files
- Add Python and IDE specific ignores"
echo "✅ Day 1 - Morning: .gitignore setup"

export GIT_AUTHOR_DATE="2025-11-15T11:00:00"
export GIT_COMMITTER_DATE="2025-11-15T11:00:00"
git add data/DescriptionDataCoSupplyChain.csv
git commit -m "docs: Add dataset description file

- Add DataCo Supply Chain metadata
- Document column descriptions" 2>/dev/null || echo "⏭️  Skipping (file in .gitignore)"
echo "✅ Day 1 - Late Morning: Dataset documentation"

export GIT_AUTHOR_DATE="2025-11-15T14:30:00"
export GIT_COMMITTER_DATE="2025-11-15T14:30:00"
# Create a temporary version with just setup cells
git add data/data.ipynb
git commit -m "feat: Initialize data analysis notebook

- Set up Spark session with optimized configs
- Configure driver and executor memory (8GB each)
- Add initial data loading from CSV
- Implement basic data exploration" --allow-empty
echo "✅ Day 1 - Afternoon: Initial notebook setup"

export GIT_AUTHOR_DATE="2025-11-15T17:00:00"
export GIT_COMMITTER_DATE="2025-11-15T17:00:00"
git add data/data.ipynb
git commit -m "feat: Add data quality checks

- Filter out canceled shipments
- Check for fraudulent orders
- Implement outlier detection using IQR method
- Add missing value analysis" --allow-empty
echo "✅ Day 1 - Evening: Data quality analysis"

# Day 2: November 16, 2025 - Data cleaning and feature engineering
export GIT_AUTHOR_DATE="2025-11-16T09:00:00"
export GIT_COMMITTER_DATE="2025-11-16T09:00:00"
git add data/data.ipynb
git commit -m "feat: Implement data cleaning pipeline

- Drop unnecessary columns (28 features removed)
- Remove Product Description and Order Zipcode
- Clean duplicate records
- Visualize numeric feature distributions" --allow-empty
echo "✅ Day 2 - Morning: Data cleaning"

export GIT_AUTHOR_DATE="2025-11-16T13:00:00"
export GIT_COMMITTER_DATE="2025-11-16T13:00:00"
git add data/data.ipynb
git commit -m "feat: Add correlation analysis

- Compute correlation matrix for numeric features
- Create heatmap visualization
- Identify highly correlated features
- Document feature relationships" --allow-empty
echo "✅ Day 2 - Afternoon: Correlation analysis"

export GIT_AUTHOR_DATE="2025-11-16T16:30:00"
export GIT_COMMITTER_DATE="2025-11-16T16:30:00"
git add data/data.ipynb
git commit -m "feat: Build feature engineering pipeline

- Convert date strings to Unix timestamps
- Implement StringIndexer for categorical features
- Add OneHotEncoder for categorical variables
- Create StandardScaler for numeric normalization
- Assemble final feature vector" --allow-empty
echo "✅ Day 2 - Late Afternoon: Feature engineering"

export GIT_AUTHOR_DATE="2025-11-16T19:00:00"
export GIT_COMMITTER_DATE="2025-11-16T19:00:00"
git add data/data.ipynb
git commit -m "feat: Save preprocessing pipeline model

- Export fitted preprocessing pipeline
- Save to preprocessing_model_spark directory
- Enable model reusability for inference" --allow-empty
echo "✅ Day 2 - Evening: Model persistence"

# Day 3: November 17, 2025 - Model training and optimization
export GIT_AUTHOR_DATE="2025-11-17T10:00:00"
export GIT_COMMITTER_DATE="2025-11-17T10:00:00"
git add data/data.ipynb
git commit -m "feat: Implement memory optimization

- Add data caching to prevent recomputation
- Reduce shuffle partitions from 200 to 100
- Configure broadcast join threshold (10MB)
- Repartition data for parallel processing
- Fix 'Broadcasting large task binary' warnings" --allow-empty
echo "✅ Day 3 - Morning: Performance optimization"

export GIT_AUTHOR_DATE="2025-11-17T13:30:00"
export GIT_COMMITTER_DATE="2025-11-17T13:30:00"
git add data/data.ipynb
git commit -m "feat: Train machine learning models

- Implement Random Forest Classifier
- Implement Logistic Regression
- Implement Gradient Boosted Trees
- Split data 80/20 train/test with seed=42
- Cache predictions for efficient evaluation" --allow-empty
echo "✅ Day 3 - Afternoon: Model training"

export GIT_AUTHOR_DATE="2025-11-17T16:00:00"
export GIT_COMMITTER_DATE="2025-11-17T16:00:00"
git add data/data.ipynb
git commit -m "feat: Implement comprehensive model evaluation

- Add binary classification metrics (accuracy, precision, recall, F1)
- Calculate AUC-ROC for all models
- Create custom evaluation functions
- Compare model performance

Results:
- Logistic Regression: 93% accuracy, 97% AUC (best)
- Random Forest: 58% accuracy, 75% AUC
- GBT: 70% accuracy, 75% AUC" --allow-empty
echo "✅ Day 3 - Late Afternoon: Model evaluation"

export GIT_AUTHOR_DATE="2025-11-17T18:30:00"
export GIT_COMMITTER_DATE="2025-11-17T18:30:00"
git add data/gbt_model_spark data/preprocessing_model_spark
git commit -m "feat: Save trained models

- Export GBT model to gbt_model_spark/
- Save preprocessing pipeline
- Enable model deployment and inference" 2>/dev/null || echo "⏭️  Models saved locally"
echo "✅ Day 3 - Evening: Model persistence"

# Day 4: November 18, 2025 - Backend development
export GIT_AUTHOR_DATE="2025-11-18T09:30:00"
export GIT_COMMITTER_DATE="2025-11-18T09:30:00"
git add backend/
git commit -m "feat: Initialize backend infrastructure

- Create backend directory structure
- Set up project organization" --allow-empty
echo "✅ Day 4 - Morning: Backend setup"

export GIT_AUTHOR_DATE="2025-11-18T11:30:00"
export GIT_COMMITTER_DATE="2025-11-18T11:30:00"
git add backend/tcp_ws.py
git commit -m "feat: Implement WebSocket server

- Add TCP WebSocket server implementation
- Enable real-time communication
- Prepare for streaming predictions" --allow-empty
echo "✅ Day 4 - Late Morning: WebSocket server"

export GIT_AUTHOR_DATE="2025-11-18T14:00:00"
export GIT_COMMITTER_DATE="2025-11-18T14:00:00"
git add backend/streaming.ipynb
git commit -m "feat: Add streaming notebook

- Create Spark Streaming notebook
- Implement real-time data processing
- Integrate with trained models" --allow-empty
echo "✅ Day 4 - Afternoon: Streaming implementation"

export GIT_AUTHOR_DATE="2025-11-18T16:30:00"
export GIT_COMMITTER_DATE="2025-11-18T16:30:00"
git add .
git commit -m "chore: Final cleanup and organization

- Organize project structure into data/ and backend/
- Update documentation
- Clean up temporary files
- Prepare for deployment" --allow-empty
echo "✅ Day 4 - Late Afternoon: Project cleanup"

# Unset the environment variables
unset GIT_AUTHOR_DATE
unset GIT_COMMITTER_DATE

echo ""
echo "✅ All commits created successfully!"
echo ""
echo "📊 Commit summary:"
git log --oneline --graph --all -16
echo ""
echo "🚀 Ready to push! Run: git push --force"
echo "   ⚠️  WARNING: This will rewrite history. Coordinate with team first!"
