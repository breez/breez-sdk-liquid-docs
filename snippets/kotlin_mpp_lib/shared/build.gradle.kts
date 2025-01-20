plugins {
    alias(libs.plugins.kotlinMultiplatform)
    alias(libs.plugins.androidLibrary)
}

kotlin {
    androidTarget {
        compilations.all {
            kotlinOptions {
                jvmTarget = "1.8"
            }
        }
    }
    
    listOf(
        iosX64(),
        iosArm64(),
        iosSimulatorArm64()
    ).forEach {
        it.binaries.framework {
            baseName = "shared"
            isStatic = true
        }
    }

    sourceSets {
        commonTest.dependencies {
            implementation(libs.kotlin.test)
        }
        val commonMain by getting {
            dependencies {
                implementation("technology.breez.liquid:breez-sdk-liquid-kmp:0.6.0-dev1")
            }
        }
    }
}

android {
    namespace = "com.example.kotlinmpplib"
    compileSdk = 34
    defaultConfig {
        minSdk = 34
    }
}

dependencies {
    implementation("androidx.core:core-ktx:+")
}
