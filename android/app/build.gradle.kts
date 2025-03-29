plugins {
    id("com.android.application")
    id("kotlin-android")
    // Le plugin Flutter Gradle doit être appliqué après les plugins Android et Kotlin.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.acces_camera"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = "27.0.12077973"  // Ajoute la version du NDK ici dans la section android.

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        // Définir l'identifiant unique de l'application (ID de l'application).
        applicationId = "com.example.acces_camera"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            // Configurer la signature de l'application pour la version de production
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}
