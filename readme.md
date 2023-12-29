The goal of this project is to have a fully automatic package application workflow that re-packages existing applications into MSIXes using the [MSIX Packaging Tool](https://learn.microsoft.com/en-us/windows/msix/packaging-tool/create-an-msix-overview), using only Github Actions.

### Challenges with this approach
 - The MSIX Packaging Tool is difficult to install programmatically from a system context. 
 - Packaging is recommended to be done on a system that closely resembles where it shall be ran. The selection of Windows OSes on Github hosted runners is limited.
 - Application-installation needs to be done completely without user-input.

### Strengths with this approach
 - Each run gets a fresh runner, limiting the noise generated when packaging.
 - There is no infrastructure to maintain.
 - Updating an application is as simple as changing a few parameters.

### Roadmap
- [X] Programmatically install MSIX Packaging Tool in the runner.
- [X] Start one runner per application.
- [X] Avoid unnecessarily packaging applications without changes.
- [X] Signing with PFX from an Azure Key Vault
- [X] Download installation files from HTTPS
- [ ] Download installation files from Azure Blob using identity-based authentication
- [ ] Download multiple installation files per application, e.g. through a ZIP-package
- [X] Uploading application MSIX file to Azure Files
- [ ] Uploading application MSIX file to Azure Blob
- [ ] Automatically update public applications when new releases comes
- [ ] Additionally create an [MSIX image](https://learn.microsoft.com/en-us/azure/virtual-desktop/app-attach-create-msix-image?tabs=cim) from the MSIX package

### Acknowledgments 
Uses [vcsjones/AzureSignTool](https://github.com/vcsjones/AzureSignTool). Thanks!