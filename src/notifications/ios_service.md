# Setting up the Notification Service Extension

## Add a Notification Service Extension target

In Xcode add a new Target to your application:
1. In the menu `File > New > Target...`
2. Select `Notification Service Extension`
3. Give the name `NotificationService`

This should create a new target with a bundle identifier like `com.example.application.NotificationService` and a folder in your application called `NotificationService`.

## Identifiers

To share data between the main application and service extension targets, you need to add a common `app group` to the main application identifier and new service extension identifier.  Go the [Apple Developer](https://developer.apple.com/account/resources/identifiers/list/applicationGroup) portal, in the Identifiers section select the App Groups dropdown to the right, then:
1. Click `+` to add an App Group
2. Select `App Groups` from the list
3. Give the App Group a description and identifier, such as `group.com.example.application`

### Update Identifiers
Now add the App Group to your existing main application release and debug Identifiers, in the Identifiers section select the App IDs dropdown to the right, then:
1. Click the Identifier to edit
2. Enable the `App Groups` app service
3. Click `Edit` and select the created app group

### Create Service Extension Identifiers
Create new release and debug Identifiers for the new service extension.
1. Click `+` to add an Identifier
2. Select `App IDs` from the list
3. Give the Identifier a description and identifier the same as the service extension, like `com.example.application.NotificationService`
4. Enable the `App Groups` app service
5. Save the Identifier, then edit it again to add the created app group as above

## Provisioning Profiles

Once you've updated and created the application Identifiers, you need to create new Provisioning Profiles for the main application and service extension that include the app group service. Go the [Apple Developer](https://developer.apple.com/account/resources/profiles/list) portal, in the Profiles section, then:
1. Click `+` to add a Provisioning Profile
2. Select the Development or Distribution type depending if its for release or debug building
3. Select the App ID
4. Select the Certificate, then generate the Provisioning Profile making a note of the name

## Configure Notification Service Extension

Back in Xcode you need to configure for each of your projects's targets, updating the Provisioning Profiles then adding capabilities for App Groups and Keychain Sharing. First for each target:
1. Select the `Signing & Capabilities` tab
2. Update the Provisioning Profile to the newly created ones

### Add an App Group Capability
Then add an App Group capability still in the `Signing & Capabilities` tab for each target:
1. Click `+ Capability` to add a capability
2. Select `App Groups` from the list
3. In the capability with the title `App Groups`, enable the created app group, like `group.com.example.application`

### Add an Keychain Sharing Capability
Then add a Keychain Sharing capability still in the `Signing & Capabilities` tab for each target:
1. Click `+ Capability` to add a capability
2. Select `Keychain Sharing` from the list
3. In the capability with the title `Keychain Sharing`, add a name for the Keychain Group, like `com.example.SharedKeychain`