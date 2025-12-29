# Azure DP-203 Project 1 – Retail Lakehouse

## Overview
End-to-end Azure data engineering project implementing a Lakehouse architecture using Microsoft Azure services. The project demonstrates ingestion, transformation, and analytics-ready data layers following Bronze–Silver–Gold design.

## Tech Stack
- Azure Data Factory (Ingestion)
- Azure Data Lake Storage Gen2
- Azure Synapse Analytics
- Apache Spark
- Delta Lake
- GitHub (Version Control)

## Architecture
![Architecture](architecture/architecture.png)

## Data Flow
1. Raw retail sales data ingested using Azure Data Factory
2. Data stored in Bronze layer (raw CSV) in ADLS Gen2
3. Spark transformations convert Bronze data to Silver (cleaned Delta)
4. Aggregations produce Gold layer for analytics
5. Gold data is queryable via SQL or BI tools

## Repository Structure
azure-dp203-project1-retail-lakehouse/
├── adf/ # ADF pipelines, datasets, linked services
├── synapse/ # Spark notebooks and SQL scripts
├── infra/ # Infrastructure as Code (Bicep/ARM)
├── architecture/ # Architecture diagrams
├── data/ # Sample input data
└── README.md


## Key Features
- Bronze–Silver–Gold Lakehouse architecture
- Delta Lake implementation
- Cost-optimized Spark pools
- Git-integrated Azure services
- Reproducible deployment

## How to Recreate
1. Deploy infrastructure using files in `infra/`
2. Import ADF pipelines from `adf/`
3. Run Spark notebooks in `synapse/notebooks/`
4. Query Gold layer for analytics

===========================================================================================================================   

# My Retail Data Lakehouse Project

This is a portable Azure Synapse project for retail sales data (Bronze → Silver → Gold layers).

## How to Set Up on a New Machine/Azure Account

### Step 1: Clone the Code
Open a command prompt (Windows: search "cmd"; Mac: Terminal).
Install Git if needed (download from git-scm.com).
Run:
git clone https://github.com/yourusername/my-retail-lakehouse.git
cd my-retail-lakehouse

### Step 2: Install Azure CLI (if not installed)
Download from https://learn.microsoft.com/en-us/cli/azure/install-azure-cli
Run: az --version (to check)

### Step 3: Login to Azure
az login  (opens browser — sign in to your Azure account)

### Step 4: Deploy Resources
Run this command (change group name if needed):
az deployment group create \
  --resource-group my-new-rg \
  --template-file infra/template.json \
  --parameters infra/parameters.json

It creates everything! Note: Change names in parameters.json if there's a conflict (e.g., storage name must be unique).

### Step 5: Open Synapse Studio
In Azure Portal, go to the new workspace → Open Synapse Studio.
Connect Git (Phase 2 above) to this same GitHub repo.
Publish/pull — notebooks appear!

### Step 6: Run the Project
Upload your CSV data to storage (use Azure Storage Explorer app — free download).
Run notebooks as before.

## Author
Amardeep Singh
