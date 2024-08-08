# Setting up the Foreground Service

In the `AndroidManifest.xml` file of the application's `app/src/main` directory, add the user permissions necessary to handle notifications `POST_NOTIFICATIONS` as a foreground service `FOREGROUND_SERVICE`. Then to your main application add two services, one to handle messaging events and one to handle the foreground service.

```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
    xmlns:tools="http://schemas.android.com/tools">

    <!-- Add these permissions -->
    <uses-permission android:name="android.permission.POST_NOTIFICATIONS" />
    <uses-permission android:name="android.permission.FOREGROUND_SERVICE" />

    <application
        android:label="Custom App"
        android:name="${applicationName}"
        android:roundIcon="@mipmap/ic_launcher"
        android:icon="@mipmap/ic_launcher">

        <!-- Add a service to handle messaging events -->
        <service
            android:name=".ExampleFcmService"
            android:exported="false">
            <intent-filter>
                <action android:name="com.google.firebase.MESSAGING_EVENT" />
            </intent-filter>
        </service>

        <!-- Add a service to handle the foreground service -->
        <service
            android:name=".ExampleForegroundService"
            android:foregroundServiceType="shortService"
            android:exported="false"
            android:stopWithTask="false">
        </service>
    </application>
</manifest>
```
