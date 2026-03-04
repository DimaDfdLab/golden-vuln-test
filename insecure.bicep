// ============================================================================
// INTENTIONALLY VULNERABLE BICEP TEMPLATE - FOR SECURITY SCANNER TESTING ONLY
// This file contains deliberate misconfigurations to trigger Template Analyzer.
// DO NOT deploy these resources.
// ============================================================================

param location string = resourceGroup().location
param sqlAdminPassword string = 'P@ssw0rd123!'

// --- Storage Account: HTTP allowed, no blob encryption scope enforcement ---
resource storageAccount 'Microsoft.Storage/storageAccounts@2021-09-01' = {
  name: 'insecurestorageacct'
  location: location
  kind: 'StorageV2'
  sku: {
    name: 'Standard_LRS'
  }
  properties: {
    supportsHttpsTrafficOnly: false
    minimumTlsVersion: 'TLS1_0'
    allowBlobPublicAccess: true
    networkAcls: {
      defaultAction: 'Allow'
    }
  }
}

// --- SQL Server: No auditing, no threat detection ---
resource sqlServer 'Microsoft.Sql/servers@2021-11-01' = {
  name: 'insecure-sql-server'
  location: location
  properties: {
    administratorLogin: 'sqladmin'
    administratorLoginPassword: sqlAdminPassword
    minimalTlsVersion: '1.0'
    publicNetworkAccess: 'Enabled'
  }
}

resource sqlDatabase 'Microsoft.Sql/servers/databases@2021-11-01' = {
  parent: sqlServer
  name: 'insecure-db'
  location: location
  properties: {
    collation: 'SQL_Latin1_General_CP1_CI_AS'
  }
}

// --- Key Vault: No soft delete, no purge protection ---
resource keyVault 'Microsoft.KeyVault/vaults@2021-11-01-preview' = {
  name: 'insecure-keyvault'
  location: location
  properties: {
    sku: {
      family: 'A'
      name: 'standard'
    }
    tenantId: subscription().tenantId
    enableSoftDelete: false
    enablePurgeProtection: false
    networkAcls: {
      defaultAction: 'Allow'
      bypass: 'None'
    }
    accessPolicies: []
  }
}

// --- App Service: No HTTPS only, no minimum TLS ---
resource appServicePlan 'Microsoft.Web/serverfarms@2021-03-01' = {
  name: 'insecure-plan'
  location: location
  sku: {
    name: 'F1'
    tier: 'Free'
  }
}

resource webApp 'Microsoft.Web/sites@2021-03-01' = {
  name: 'insecure-webapp'
  location: location
  properties: {
    serverFarmId: appServicePlan.id
    httpsOnly: false
    siteConfig: {
      minTlsVersion: '1.0'
      ftpsState: 'AllAllowed'
      http20Enabled: false
      remoteDebuggingEnabled: true
    }
  }
}

// --- Container Registry: No admin user disabled, no network rules ---
resource containerRegistry 'Microsoft.ContainerRegistry/registries@2021-12-01-preview' = {
  name: 'insecureacr'
  location: location
  sku: {
    name: 'Basic'
  }
  properties: {
    adminUserEnabled: true
    publicNetworkAccess: 'Enabled'
  }
}
