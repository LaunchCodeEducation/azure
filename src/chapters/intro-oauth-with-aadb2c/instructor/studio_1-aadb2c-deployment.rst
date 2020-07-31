.. authorization url https://student0720tenant.b2clogin.com/student0720tenant.onmicrosoft.com/oauth2/v2.0/authorize?p=b2c_1_coding-events-api-susi

.. sourcecode:: js
   :caption: appsettings.json

   {
   "Logging": {
      "LogLevel": {
      "Default": "Information",
      "Microsoft": "Warning",
      "Microsoft.Hosting.Lifetime": "Information"
      }
   },
   "AllowedHosts": "*",
   "KeyVaultName": "{KV name}",
   "JWT": {
      "ADB2C": {
      "RequireHttpsMetadata": true,
      "MetadataAddress": "https://{instance}/{domain}/v2.0/.well-known/openid-configuration?p={flow policy}",
      "TokenValidationParameters": {
         "ValidAudience": "{app ID}",
         "ValidateIssuer": true,
         "ValidateAudience": true,
         "ValidateLifetime": true,
         "ValidateIssuerSigningKey": true
      }
      }
   },
   "SwaggerAuth": {
      "ClientId": "",
      // TODO: check if "authorizationUrl" includes app id path
      "AuthorizationUrl": "https://login.microsoftonline.com/{tenant}/oauth2/v2.0/authorize",
      "Scopes": {
      "UserImpersonation": "https://{domain}/{app name}/{published scope name}"
      }
   },
   "Server": {
      "Origin": "{VM pubic IP}"
   }
   }

   // ex: "{app ID}
   // ex: "06eb34fd-455b-4084-92c3-07d5389e6c15"

   // ex: https://{instance}/{domain}/v2.0/.well-known/openid-configuration?p={flow policy}
   // ex: "https://mycodingevents.b2clogin.com/mycodingevents.onmicrosoft.com/v2.0/.well-known/openid-configuration?

   // ex: JWT.ADB2C.RequireHttpsMetadata value is assignd to options.RequireHttpsMetadata
   // ex: JWT.ADB2C.TokenValidationParameters has its object entries automatically bound to

   // ex: https://{instance}/{domain}/oauth2/v2.0/authorize?p={flow policy}
   // ex: https://mycodingevents.b2clogin.com/mycodingevents.onmicrosoft.com/oauth2/v2.0/authorize?

   // ex: https://{domain}/{app name}/{published scope name}
   // ex: https://mycodingevents.onmicrosoft.com/code-events/user_impersonation
