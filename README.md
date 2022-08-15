# dotnet6-eventgrid-bicep
A Dotnet 6 MVC quick start application that publishes an event to EventGrid, authentication is done through Azure AD. This is used as an example of assigning a RBAC role for EventGrid through Bicep.

- Using Managed Identity with [Aure-SDK-for-net](https://docs.microsoft.com/en-us/dotnet/azure/sdk/authentication-azure-hosted-apps?tabs=azure-portal%2Cazure-app-service%2Ccommand-line#managed-identity-types)

- Using [DefaultAzureCredential](https://docs.microsoft.com/en-us/dotnet/azure/sdk/authentication-azure-hosted-apps?tabs=azure-portal%2Cazure-app-service%2Ccommand-line#3---implement-defaultazurecredential-in-your-application) for authentication.

- C# EventGrid - [Quickstart](https://github.com/Azure/azure-sdk-for-net/blob/main/sdk/eventgrid/Azure.Messaging.EventGrid/samples/Sample1_PublishEventsToTopic.md)
