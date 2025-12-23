enableFeaturePreview("TYPESAFE_PROJECT_ACCESSORS")
pluginManagement {
    repositories {
        google()
        gradlePluginPortal()
        mavenCentral()
    }
}

dependencyResolutionManagement {
    // repositoriesMode.set(RepositoriesMode.FAIL_ON_PROJECT_REPOS)
    repositories {
        google()
        mavenCentral()
        maven("https://mvn.breez.technology/releases")
    }
}

val isLocalDev = System.getenv("LOCAL_DEV") == "1"
if (isLocalDev) {
    println("DEV ENVIRONMENT DETECTED: USING LOCAL SDK BUILD IF PRESENT")
    includeBuild("../../../breez-sdk-liquid/lib/bindings/langs/kotlin-multiplatform") {
        dependencySubstitution {
            substitute(module("technology.breez.liquid:breez-sdk-liquid-kmp")).using(project(":breez-sdk-liquid-kmp"))
        }
    }
}

rootProject.name = "Kotlin_MPP_Lib"
include(":shared")
