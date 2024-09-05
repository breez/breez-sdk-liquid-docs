using Breez.Sdk.Liquid;

public class ServiceStatusSnippets
{
    public void RegisterWebhook(BindingLiquidSdk sdk)
    {
        // ANCHOR: register-webook
        try
        {
            sdk.RegisterWebhook("https://your-nds-service.com/notify?platform=ios&token=<PUSH_TOKEN>");
        }
        catch (Exception)
        {
            // Handle error
        }
        // ANCHOR_END: register-webook
    }
        
    public void UnregisterWebhook(BindingLiquidSdk sdk)
    {
        // ANCHOR: unregister-webook
        try
        {
            sdk.UnregisterWebhook();
        }
        catch (Exception)
        {
            // Handle error
        }
        // ANCHOR_END: unregister-webook
    }
}
