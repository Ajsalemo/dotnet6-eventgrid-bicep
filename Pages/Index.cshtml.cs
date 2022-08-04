using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using Azure.Messaging.EventGrid;
using Azure.Identity;
using Azure.Core.Serialization;
using System.Text.Json;

namespace azure_webaps_linux_dotnet_eventgrid_example.Pages;

public class IndexModel : PageModel
{
    private readonly ILogger<IndexModel> _logger;

    public IndexModel(ILogger<IndexModel> logger)
    {
        _logger = logger;
    }

    public async Task OnGet()
    {
        try
        {
            Guid g = Guid.NewGuid();
            var azureEventGridTopicEndpoint = Environment.GetEnvironmentVariable("AZURE_EVENT_GRID_TOPIC_ENDPOINT");
            var message = "Order_" + g;

            EventGridPublisherClient client = new EventGridPublisherClient(
                new Uri(azureEventGridTopicEndpoint),
                new DefaultAzureCredential());

            var myCustomDataSerializer = new JsonObjectSerializer(
                new JsonSerializerOptions()
                {
                    PropertyNamingPolicy = JsonNamingPolicy.CamelCase
                });

            // Add EventGridEvents to a list to publish to the topic
            List<EventGridEvent> eventsList = new List<EventGridEvent>
            {
                // EventGridEvent with custom model serialized to JSON
                new EventGridEvent(
                    "OrderEventSubject",
                    "Order.EventType",
                    "1.0",
                    message
                )
            };

            // Send the events
            await client.SendEventsAsync(eventsList);
            _logger.LogInformation("Sent a message to EventGrid, message: " + message);
            }
        catch (System.Exception)
        {
            throw;
        }
    }
}
